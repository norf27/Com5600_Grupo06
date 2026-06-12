/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion:
Procedimiento de negocio para el registro de ventas de entradas.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Ventas.SP_RegistrarVentaEntradas
(
    @Documento VARCHAR(20),
    @TipoDoc VARCHAR(20),
    @Nombre VARCHAR(100),
    @Nacimiento DATE,
    @ID_Tarifa BIGINT,
    @CantidadEntradas INT,
    @MetodoPago VARCHAR(100),
    @FechaAcceso DATE,
    @PuntoVenta VARCHAR(100),
    @ListaTours VARCHAR(MAX)   -- Cadena de IDs de tours separados por coma (ej: '1,2,3')
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IDCliente BIGINT;
    DECLARE @IDCompra BIGINT;
    DECLARE @IDEntrada BIGINT;
    
    DECLARE @PrecioTarifa DECIMAL(11,2);
    DECLARE @CostoTours DECIMAL(11,2);
    DECLARE @TotalPorEntrada DECIMAL(11,2);
    DECLARE @TotalCompra DECIMAL(11,2);
    
    DECLARE @Errores VARCHAR(MAX) = '';

    ------------------------------------------------------
    -- VALIDACIONES PREVENTIVAS
    ------------------------------------------------------
    
    IF EXISTS (
        SELECT 1 
        FROM STRING_SPLIT(@ListaTours, ',') 
        WHERE TRY_CAST(value AS BIGINT) IS NULL
    )
        SET @Errores += CHAR(13) + '- La lista de tours contiene valores o caracteres inválidos.';

    IF EXISTS (
        SELECT value 
        FROM STRING_SPLIT(@ListaTours, ',') 
        WHERE TRY_CAST(value AS BIGINT) IS NOT NULL
        GROUP BY value 
        HAVING COUNT(*) > 1
    )
        SET @Errores += CHAR(13) + '- Existen tours repetidos en la lista de selección.';

    IF @Documento IS NULL OR @Documento NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
        SET @Errores += CHAR(13) + '- El documento del cliente debe contener exactamente 8 dígitos numéricos.';

    IF @TipoDoc IS NULL OR LTRIM(RTRIM(@TipoDoc)) = ''
        SET @Errores += CHAR(13) + '- Debe especificar el tipo de documento.';

    IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = ''
        SET @Errores += CHAR(13) + '- Debe ingresar el nombre del cliente.';

    IF @Nacimiento IS NULL OR @Nacimiento > DATEADD(YEAR, -18, CAST(GETDATE() AS DATE))
        SET @Errores += CHAR(13) + '- El cliente debe ser mayor de edad para efectuar la compra.';

    IF @CantidadEntradas IS NULL OR @CantidadEntradas <= 0
        SET @Errores += CHAR(13) + '- La cantidad de entradas debe ser mayor a 0.';


    IF @MetodoPago NOT IN ('Tarjeta', 'Transferencia', 'Efectivo')
        SET @Errores += CHAR(13) + '- El método de pago indicado no es válido. (Permitidos: Tarjeta, Transferencia, Efectivo).';

    IF @PuntoVenta IS NULL OR LTRIM(RTRIM(@PuntoVenta)) = ''
        SET @Errores += CHAR(13) + '- Debe especificar el punto de venta.';

    IF @FechaAcceso IS NULL OR @FechaAcceso < CAST(GETDATE() AS DATE)
        SET @Errores += CHAR(13) + '- La fecha de acceso no puede ser anterior al día de hoy.';

    ------------------------------------------------------
    -- VALIDACIONES DE INTEGRIDAD
    ------------------------------------------------------

    IF NOT EXISTS (SELECT 1 FROM Ventas.Tarifa WHERE ID = @ID_Tarifa)
    BEGIN
        SET @Errores += CHAR(13) + '- La tarifa especificada no existe en la base de datos.';
    END
    ELSE
    BEGIN
        IF EXISTS (
            SELECT 1 FROM Ventas.Tarifa 
            WHERE ID = @ID_Tarifa AND (@FechaAcceso < Fecha_desde OR @FechaAcceso > Fecha_hasta)
        )
        SET @Errores += CHAR(13) + '- La tarifa seleccionada no se encuentra vigente para la fecha de acceso solicitada.';
    END

    IF @ListaTours IS NULL OR LTRIM(RTRIM(@ListaTours)) = ''
        SET @Errores += CHAR(13) + '- Debe seleccionar al menos un tour para la entrada.';

    IF @Errores = '' AND EXISTS (
        SELECT 1 
        FROM (SELECT TRY_CAST(value AS BIGINT) ID_Tour FROM STRING_SPLIT(@ListaTours, ',')) T
        LEFT JOIN Atracciones.Tour TT ON TT.ID_Tour = T.ID_Tour
        WHERE TT.ID_Tour IS NULL
    )
        SET @Errores += CHAR(13) + '- Uno o más tours dentro de la lista no existen.';

    -- Validar control de cupos cruzando con Fecha de Acceso considerando la cantidad total de entradas solicitadas
    IF @Errores = '' AND EXISTS (
        SELECT 1
        FROM Atracciones.Tour T
        JOIN (SELECT DISTINCT TRY_CAST(value AS BIGINT) ID_Tour FROM STRING_SPLIT(@ListaTours, ',')) X ON X.ID_Tour = T.ID_Tour
        WHERE (
            -- Cuenta las asignaciones activas exclusivamente para la misma fecha del evento
            SELECT COUNT(*)
            FROM Atracciones.R_Tour_Entrada RTE
            JOIN Ventas.Entrada E ON RTE.ID_Entrada = E.ID
            WHERE RTE.ID_Tour = T.ID_Tour AND E.Fecha_acceso = @FechaAcceso
        ) + @CantidadEntradas > T.Cupo_max
    )
        SET @Errores += CHAR(13) + '- Cupo insuficiente en uno o más tours seleccionados para la fecha solicitada.';

    ------------------------------------------------------
    -- ERRORES
    ------------------------------------------------------
    IF @Errores <> ''
    BEGIN
        THROW 50001, @Errores, 1;
    END

    ------------------------------------------------------
    -- OBTENCIÓN DE DATOS (COSTOS Y TOTALES)
    ------------------------------------------------------
    SELECT @PrecioTarifa = Precio FROM Ventas.Tarifa WHERE ID = @ID_Tarifa;

    SELECT @CostoTours = ISNULL(SUM(Costo), 0)
    FROM Atracciones.Tour
    WHERE ID_Tour IN (SELECT DISTINCT TRY_CAST(value AS BIGINT) FROM STRING_SPLIT(@ListaTours, ','));

    SET @TotalPorEntrada = @PrecioTarifa + @CostoTours;
    SET @TotalCompra = @TotalPorEntrada * @CantidadEntradas;

    ------------------------------------------------------
    -- BLOQUE TRANSACCIONAL
    ------------------------------------------------------
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Gestion de Existencia del Cliente

        SELECT @IDCliente = ID FROM Ventas.Cliente WHERE Documento = @Documento AND Tipo_doc = @TipoDoc;

        IF @IDCliente IS NULL
        BEGIN
            INSERT INTO Ventas.Cliente (Nombre, Documento, Tipo_doc, Nacimiento)
            VALUES (@Nombre, @Documento, @TipoDoc, @Nacimiento);
            
            SET @IDCliente = SCOPE_IDENTITY();
        END

        -- Insercion en Ventas.Compra 
        INSERT INTO Ventas.Compra (Fecha, Total, Cantidad, Punto_venta)
        VALUES (GETDATE(), @TotalCompra, @CantidadEntradas, @PuntoVenta);
        
        SET @IDCompra = SCOPE_IDENTITY();

        -- Insercion en Ventas.Pago 
        INSERT INTO Ventas.Pago (Metodo, Monto, Estado, ID_compra)
        VALUES (@MetodoPago, @TotalCompra, 'A', @IDCompra);

        -- Creacion individual de cada entrada fisica adquirida
        DECLARE @i INT = 1;

        WHILE @i <= @CantidadEntradas
        BEGIN
            
            -- Insertar registro individual de Entrada
            INSERT INTO Ventas.Entrada (Fecha_acceso, ID_cliente, ID_tarifa, ID_compra)
            VALUES (@FechaAcceso, @IDCliente, @ID_Tarifa, @IDCompra);

            SET @IDEntrada = SCOPE_IDENTITY();

            INSERT INTO Atracciones.R_Tour_Entrada (ID_Tour, ID_Entrada)
            SELECT DISTINCT TRY_CAST(value AS BIGINT), @IDEntrada
            FROM STRING_SPLIT(@ListaTours, ',');

            SET @i += 1;
        END

        COMMIT TRANSACTION;
        PRINT 'Proceso completado con éxito: 1 Compra, 1 Pago y ' + CAST(@CantidadEntradas AS VARCHAR) + ' Entrada(s) con sus tours asociados.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        THROW;
    END CATCH
END;
GO
