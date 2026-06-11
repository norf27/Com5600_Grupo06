
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------

--------------------PARQUE-----------------------


--------------------EMPLEADOS-----------------------
CREATE OR ALTER PROCEDURE Empleados.Agr_Guia
    @Nombre VARCHAR(100),
    @DNI VARCHAR(20),
    @CUIL VARCHAR(20),
    @Nacimiento DATE,
    @Sueldo DECIMAL(11,2),
    @Estado CHAR(1),
    @ID_Parque BIGINT
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Empleado BIGINT;

        -- Llamada al agregado de Empleado, pendiente. 
        EXEC @ID_Empleado = Parque.Agr_Empleado
            @Nombre = @Nombre,
            @DNI = @DNI,
            @CUIL = @CUIL,
            @Nacimiento = @Nacimiento,
            @Sueldo = @Sueldo,
            @Estado = @Estado,
            @ID_Parque = @ID_Parque;

        IF EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Empleado)
        BEGIN
            PRINT('Este empleado ya es un guia.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al registrar el guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Guia (ID_Empleado) VALUES (@ID_Empleado);
    RETURN @ID_Empleado;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Habilitacion
    @Detalles VARCHAR(100),
    @Fecha DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;
        SET @Detalles = TRIM(@Detalles);

        IF @Detalles = '' OR LEN(@Detalles) > 100
        BEGIN
            PRINT('Los detalles de la habilitacion no son validos.');
            RAISERROR('.', 16, 1);
        END

        IF @Fecha IS NULL OR @Fecha > GETDATE()
        BEGIN
            PRINT('La fecha de habilitacion no es valida.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Habilitacion 
        WHERE Detalles = @Detalles AND Fecha = @Fecha;

        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al resgistrar la habilitacion', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Habilitacion (Detalles, Fecha) 
    VALUES (@Detalles, @Fecha);
    
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Especialidad
    @Nombre VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;
        SET @Nombre = TRIM(@Nombre);

        IF @Nombre = '' OR @Nombre LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El nombre de la especialidad no es valido.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Especialidad WHERE Nombre = @Nombre;
        
        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al registrar la especialidad', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Especialidad (Nombre) VALUES (@Nombre);
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Titulo
    @Nombre VARCHAR(100),
    @Fecha DATE,
    @Origen VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;

        SET @Nombre = TRIM(@Nombre);
        SET @Origen = TRIM(@Origen);

        IF @Nombre = '' OR @Nombre LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El nombre del titulo no es valido.');
            RAISERROR('.', 16, 1);
        END

        IF @Origen = '' OR @Origen LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El origen del titulo no es valido.');
            RAISERROR('.', 16, 1);
        END

        IF @Fecha IS NULL OR @Fecha > GETDATE()
        BEGIN
            PRINT('La fecha del titulo no es valida.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Titulo 
        WHERE Nombre = @Nombre AND Origen = @Origen AND Fecha = @Fecha;

        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error en el registro del titulo', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Titulo (Nombre, Fecha, Origen) 
    VALUES (@Nombre, @Fecha, @Origen);
    
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Habilitacion
    @ID_Guia BIGINT,
    @Detalles VARCHAR(100),
    @Fecha DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Habilitacion BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Habilitacion = Empleados.Agr_Habilitacion
            @Detalles = @Detalles,
            @Fecha = @Fecha;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion)
        BEGIN
            PRINT('El guia ya tiene esta habilitacion.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar la habilitacion al guía.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Habilitacion (ID_Guia, ID_Habilitacion)
    VALUES (@ID_Guia, @ID_Habilitacion);
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Especialidad
    @ID_Guia BIGINT,
    @Nombre_Especialidad VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Especialidad BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Especialidad = Empleados.Agr_Especialidad
            @Nombre = @Nombre_Especialidad;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad)
        BEGIN
            PRINT('El guia ya tiene asignada esta especialidad.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar la especialidad al guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Especialidad (ID_Guia, ID_Especialidad)
    VALUES (@ID_Guia, @ID_Especialidad);
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Titulo
    @ID_Guia BIGINT,
    @Nombre_Titulo VARCHAR(100),
    @Fecha_Titulo DATE,
    @Origen_Titulo VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Titulo BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Titulo = Empleados.Agr_Titulo
            @Nombre = @Nombre_Titulo,
            @Fecha = @Fecha_Titulo,
            @Origen = @Origen_Titulo;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo)
        BEGIN
            PRINT('El guia ya tiene asignado este titulo.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar el título al guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Titulo (ID_Guia, ID_Titulo)
    VALUES (@ID_Guia, @ID_Titulo);
END
GO
--------------------CONSECIONES-----------------------


--------------------VENTAS-----------------------
CREATE OR ALTER PROCEDURE Ventas.SP_Cliente_Alta
(
@Nombre VARCHAR(100),
@Documento VARCHAR(20),
@Tipo_doc VARCHAR(20),
@Nacimiento DATE
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))='' -- elimina espacios en blanco
SET @Errores += CHAR(13) + '- El nombre es obligatorio';

IF @Documento IS NULL OR LTRIM(RTRIM(@Documento))=''
SET @Errores += CHAR(13) + '- El documento es obligatorio';

IF @Tipo_doc IS NULL OR LTRIM(RTRIM(@Tipo_doc))=''
SET @Errores += CHAR(13) + '- El tipo de documento es obligatorio';

IF @Nacimiento > CAST(GETDATE() AS DATE)
SET @Errores += CHAR(13) + '- La fecha de nacimiento no puede ser futura';

IF @Nacimiento > DATEADD(YEAR,-18,CAST(GETDATE() AS DATE))
SET @Errores += CHAR(13) + '- El cliente debe ser mayor de edad';

IF EXISTS
(
SELECT 1
FROM Ventas.Cliente
WHERE Documento=@Documento
)
SET @Errores += CHAR(13) + '- Ya existe un cliente con ese documento';

-- ERRORES

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;;
END

-- INSERT

INSERT INTO Ventas.Cliente
(
Nombre,
Documento,
Tipo_doc,
Nacimiento
)
VALUES
(
@Nombre,
@Documento,
@Tipo_doc,
@Nacimiento
);

PRINT 'Cliente registrado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_TipoVisitante_Alta
(
@Nombre VARCHAR(100)
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))=''
SET @Errores += CHAR(13) + '- El nombre es obligatorio';

IF EXISTS
(
SELECT 1
FROM Ventas.Tipo_visitante
WHERE Nombre=@Nombre
)
SET @Errores += CHAR(13) + '- Ya existe un tipo de visitante con ese nombre';


-- ERRORES

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

-- INSERT

INSERT INTO Ventas.Tipo_visitante(Nombre)
VALUES(@Nombre);

PRINT 'Tipo de visitante registrado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Tarifa_Alta
(
@Fecha_desde DATE,
@Fecha_hasta DATE,
@Precio DECIMAL(11,2),
@ID_tipo_visitante BIGINT,
@ID_parque BIGINT
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Precio <= 0
SET @Errores += CHAR(13)+'- El precio debe ser mayor a cero';

IF @Fecha_hasta < @Fecha_desde
SET @Errores += CHAR(13)+'- La fecha hasta debe ser posterior a la fecha desde';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Tipo_visitante
WHERE ID=@ID_tipo_visitante
)
SET @Errores += CHAR(13)+'- El tipo de visitante no existe';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Parque
WHERE ID=@ID_parque
)
SET @Errores += CHAR(13)+'- El parque no existe';

-- ERRORES

IF @Errores<>''
BEGIN
THROW 50001, @Errores, 1;
END

-- INSERT

INSERT INTO Ventas.Tarifa
(
Fecha_desde,
Fecha_hasta,
Precio,
ID_tipo_visitante,
ID_parque
)
VALUES
(
@Fecha_desde,
@Fecha_hasta,
@Precio,
@ID_tipo_visitante,
@ID_parque
);

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Entrada_Alta
(
@Fecha_acceso DATE,
@ID_cliente BIGINT,
@ID_tarifa BIGINT,
@ID_compra BIGINT
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Fecha_acceso < CAST(GETDATE() AS DATE)
SET @Errores += CHAR(13) + '- La fecha de acceso no puede ser anterior a la fecha actual';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Cliente
WHERE ID=@ID_cliente
)
SET @Errores += CHAR(13) + '- El cliente no existe';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Tarifa
WHERE ID=@ID_tarifa
)
SET @Errores += CHAR(13) + '- La tarifa no existe';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Compra
WHERE ID=@ID_compra
)
SET @Errores += CHAR(13) + '- La compra no existe';

-- ERRORES

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

-- INSERT

INSERT INTO Ventas.Entrada
(
Fecha_acceso,
ID_cliente,
ID_tarifa,
ID_compra
)
VALUES
(
@Fecha_acceso,
@ID_cliente,
@ID_tarifa,
@ID_compra
);

PRINT 'Entrada registrada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Compra_Alta
(
@Fecha DATETIME,
@Total DECIMAL(11,2),
@Cantidad INT,
@Punto_venta VARCHAR(100)
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Fecha > GETDATE()
SET @Errores += CHAR(13) + '- La fecha de compra no puede ser futura';

IF @Total < 0
SET @Errores += CHAR(13) + '- El total no puede ser negativo';

IF @Cantidad <= 0
SET @Errores += CHAR(13) + '- La cantidad debe ser mayor a cero';

IF @Punto_venta IS NULL
OR LTRIM(RTRIM(@Punto_venta))=''
SET @Errores += CHAR(13) + '- El punto de venta es obligatorio';

-- ERRORES

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

INSERT INTO Ventas.Compra
(
Fecha,
Total,
Cantidad,
Punto_venta
)
VALUES
(
@Fecha,
@Total,
@Cantidad,
@Punto_venta
);

PRINT 'Compra registrada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Pago_Alta
(
@Metodo VARCHAR(100),
@Monto DECIMAL(11,2),
@Estado CHAR(1),
@ID_compra BIGINT
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

-- VALIDACIONES

IF @Metodo IS NULL
OR LTRIM(RTRIM(@Metodo))=''
SET @Errores += CHAR(13) + '- El método de pago es obligatorio';

IF @Monto <= 0
SET @Errores += CHAR(13) + '- El monto debe ser mayor a cero';

IF @Estado NOT IN ('P','A','R')
SET @Errores += CHAR(13) + '- Estado inválido (P=Pendiente, A=Aprobado, R=Rechazado)';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Compra
WHERE ID=@ID_compra
)
SET @Errores += CHAR(13) + '- La compra no existe';

IF EXISTS
(
SELECT 1
FROM Ventas.Pago
WHERE ID_compra=@ID_compra
)
SET @Errores += CHAR(13) + '- La compra ya posee un pago asociado';

-- ERRORES

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

-- INSERT

INSERT INTO Ventas.Pago
(
Metodo,
Monto,
Estado,
ID_compra
)
VALUES
(
@Metodo,
@Monto,
@Estado,
@ID_compra
);

PRINT 'Pago registrado correctamente';

END
GO 


--------------------ATRACCIONES-----------------------
