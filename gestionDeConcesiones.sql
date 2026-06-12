/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion:
Procedimiento de negocio para la gestion de concesiones.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Concesiones.SP_RegistrarConcesion
(
    @IDEmpresa BIGINT,
    @IDTipoActividad BIGINT,
    @IDParque BIGINT,
    @FechaInicio DATE,
    @FechaFin DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Errores VARCHAR(MAX) = '';

    ---------------------------------------------------
    -- VALIDACIONES 
    ---------------------------------------------------

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

    IF @FechaInicio < CAST(GETDATE() AS DATE)
        SET @Errores += CHAR(13) + '- La fecha de inicio no puede ser anterior a la fecha actual.';

    IF @FechaFin <= @FechaInicio
        SET @Errores += CHAR(13) + '- La fecha de finalización debe ser posterior a la fecha de inicio.';

    ---------------------------------------------------
    -- VALIDACIONES DE INTEGRIDAD
    ---------------------------------------------------
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

    ---------------------------------------------------
    -- ERRORES
    ---------------------------------------------------
    IF @Errores <> ''
    BEGIN
        THROW 50001, @Errores, 1;
    END

    ---------------------------------------------------
    -- BLOQUE TRANSACCIONAL
    ---------------------------------------------------
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Concesiones.Concesion
        (
            Fecha_inicio,
            Fecha_fin,
            ID_empresa,
            ID_tipo,
            ID_parque
        )
        VALUES
        (
            @FechaInicio,
            @FechaFin,
            @IDEmpresa,
            @IDTipoActividad,
            @IDParque
        );

        COMMIT TRANSACTION;

        SELECT 
            SCOPE_IDENTITY() AS IDConcesion,
            'Concesión registrada correctamente.' AS Mensaje;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
