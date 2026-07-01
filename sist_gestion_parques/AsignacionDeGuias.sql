/*
Fecha: 03/07/2026
Universidad Nacional de La Matanza
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas
Descripcion:
Procedimiento de negocio para la asignacion de guias a tours existentes.
*/

use sist_gestion_parques
go

CREATE OR ALTER PROCEDURE Atracciones.SP_AsignarGuiaTour
(
    @ID_Guia INT,
    @ID_Tour INT
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guia IS NULL
        SET @error += 'La ID del guia no puede ser null' + CHAR(10);

    IF @ID_Tour IS NULL
        SET @error += 'La ID del tour no puede ser null' + CHAR(10);

    IF NOT EXISTS
    (
        SELECT 1
        FROM Empleados.Guia
        WHERE ID_Empleado = @ID_Guia
    )
        SET @error += 'El guia indicado no existe' + CHAR(10);

    IF NOT EXISTS
    (
        SELECT 1
        FROM Atracciones.Tour
        WHERE ID_Tour = @ID_Tour
    )
        SET @error += 'El tour indicado no existe' + CHAR(10);

    IF EXISTS
    (
        SELECT 1
        FROM Atracciones.R_Tour_Guia
        WHERE ID_Guia = @ID_Guia
          AND ID_Tour = @ID_Tour
    )
        SET @error += 'El guia ya se encuentra asignado al tour' + CHAR(10);

    IF NOT EXISTS
    (
        SELECT 1
        FROM Empleados.R_Guia_Habilitacion
        WHERE ID_Guia = @ID_Guia
    )
        SET @error += 'El guia no posee habilitaciones registradas' + CHAR(10);

    IF NOT EXISTS
    (
        SELECT 1
        FROM Empleados.R_Guia_Especialidad
        WHERE ID_Guia = @ID_Guia
    )
        SET @error += 'El guia no posee especialidades registradas' + CHAR(10);

    IF NOT EXISTS
    (
        SELECT 1
        FROM Empleados.R_Guia_Titulo
        WHERE ID_Guia = @ID_Guia
    )
        SET @error += 'El guia no posee titulos registrados' + CHAR(10);

    IF @error <> ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;

    BEGIN TRY

        INSERT INTO Atracciones.R_Tour_Guia
        (
            ID_Tour,
            ID_Guia
        )
        VALUES
        (
            @ID_Tour,
            @ID_Guia
        );

        COMMIT;

        PRINT 'Guia asignado correctamente al tour';

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();

        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;

    END CATCH;
END;
GO
