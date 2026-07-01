/*
Fecha: 03/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion:
Procedimientos de negocio para la gestion de concesiones.
*/

USE sist_gestion_parques;
GO
-- las concesiones siempre empiezan el 1ero de un mes y terminan el 1ero del otro, nunca en el medio

create or alter procedure Concesiones.SP_RegistrarConcesion
(
    @IDEmpresa INT,
    @IDTipoActividad INT,
    @IDParque INT,
    @FechaInicio DATE,
    @FechaFin DATE,
    @Monto_mensual DECIMAL(11,2),
    @Metodo VARCHAR(100)
)
AS
BEGIN
SET NOCOUNT ON;

    DECLARE @Errores VARCHAR(MAX) = '';


    IF NOT EXISTS (SELECT 1 FROM Concesiones.Empresa WHERE ID = @IDEmpresa)
        SET @Errores += CHAR(13) + '- La empresa indicada no existe.';

    IF NOT EXISTS (SELECT 1 FROM Concesiones.Tipo_actividad WHERE ID = @IDTipoActividad)
        SET @Errores += CHAR(13) + '- El tipo de actividad indicado no existe.';

    IF NOT EXISTS (SELECT 1 FROM Parque.Parque WHERE ID = @IDParque)
        SET @Errores += CHAR(13) + '- El parque indicado no existe.';

    IF @FechaInicio IS NULL
        SET @Errores += CHAR(13) + '- Debe indicar la fecha de inicio.';

    IF @FechaFin IS NULL
        SET @Errores += CHAR(13) + '- Debe indicar la fecha de finalización.';

    IF DAY(@FechaFin) != 1
        SET @Errores += CHAR(13) + '- Debe iniciar un dia 1.';

    IF  DAY(@FechaInicio) != 1
        SET @Errores += CHAR(13) + '- Debe finalizar un dia 1.';

    /*IF @FechaInicio < CAST(GETDATE() AS DATE)
        SET @Errores += CHAR(13) + '- La fecha de inicio no puede ser anterior a la fecha actual.';*/ --sacado para poder hacer casos de prueba

    IF @FechaFin <= @FechaInicio
        SET @Errores += CHAR(13) + '- La fecha de finalización debe ser posterior a la fecha de inicio.';

    IF @Errores = '' AND EXISTS
    (
        SELECT 1
        FROM Concesiones.Concesion
        WHERE ID_parque = @IDParque 
          AND ID_tipo = @IDTipoActividad
          AND (
                @FechaInicio BETWEEN Fecha_inicio AND Fecha_fin
                OR @FechaFin BETWEEN Fecha_inicio AND Fecha_fin
                OR Fecha_inicio BETWEEN @FechaInicio AND @FechaFin
              )
    )
    BEGIN
        SET @Errores += CHAR(13) + '- Ya existe una concesión de este tipo de actividad en el parque que se superpone con las fechas indicadas.';
    END
    
    Declare @CantidadPagos INT = DATEDIFF(MONTH, @FechaInicio, @FechaFin)

    IF @Errores <> ''
    BEGIN
        THROW 50001, @Errores, 1;
    END


    BEGIN TRY
        BEGIN TRANSACTION;

        --insertar en concesion
        DECLARE @IDConcesion INT
        EXEC @IDConcesion = Concesiones.SP_Concesion_Alta @FechaInicio, @FechaFin, @IDEmpresa, @IDTipoActividad, @IDParque
        
        --crear 1 pago mensual por cada mes que deberia pagar, queda como adeudado cada mes
        WHILE @FechaInicio <= @FechaFin
        BEGIN
            EXEC Concesiones.SP_PagoMensual_Alta @FechaInicio, @Monto_mensual, @Metodo, @IDConcesion 

            SET @FechaInicio = DATEADD(MONTH, 1, @FechaInicio);
        END;

        COMMIT TRANSACTION;

        Print 'Concesión registrada correctamente.'
        RETURN @IDConcesion
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


create or alter procedure Concesiones.SP_RegistrarPago @ID_concesion int, @Fecha date as
begin
    declare @error varchar(100) = ''
    if @ID_concesion is null
        set @error += 'El ID_Concesion no puede ser null' + char(10)
    if @Fecha is null
        set @error += 'La fecha no puede ser null' + char(10)
    if not exists (select 1 from Concesiones.Concesion where ID = @ID_concesion and Estado = 'A')
        set @error += 'El ID_Concesion no existe' + char(10)
    if day(@Fecha) != 1
        set @error += 'La fecha siempre debe ser del 1ro del mes que se desea pagar' + char(10)
    declare @ID_pago int, @Pago char(1), @Monto decimal(11,2), @Metodo varchar(100)

    select @ID_pago = ID, @Pago = Pago, @Monto = Monto, @Metodo = Metodo
    from Concesiones.Pago_mensual where ID_concesion = @ID_concesion and Fecha = @Fecha and Estado = 'a'
    
    if @ID_pago is null
        set @error += 'No se encontro un pago para esta fecha' + char(10)
    if @ID_pago is not null and @Pago = 'P'
        set @error += 'Ya se registro un pago para esta fecha para esa concesion' + char(10)
    if @error != ''
        throw 50001, @error, 1

    BEGIN TRY
        BEGIN TRANSACTION;

        exec Concesiones.SP_PagoMensual_Modificar @ID_pago, @Fecha, @Monto, @Metodo, 'P', @ID_concesion
        
        COMMIT TRANSACTION;

        Print 'Pago registrado correctamente.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH

end
go
