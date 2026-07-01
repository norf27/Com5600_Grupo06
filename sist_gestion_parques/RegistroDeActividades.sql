/*
Fecha: 03/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion:
Procedimiento de negocio para el registro de actividades (tours).
*/

use sist_gestion_parques
go

CREATE OR ALTER PROCEDURE Atracciones.RegistrarActividad
(
    @Costo DECIMAL(11,2),
    @Cupo_Max INT,
    @Tipo CHAR(1),
    @Duracion INT,
    @Nombre VARCHAR(100), 
    @Horario VARCHAR(5),
    @ID_Guia INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @error VARCHAR(MAX) = '';

     IF @Horario NOT LIKE '[0-2][0-9]:[0-6][0-9]'
        SET @error += 'El Horario debe ser formato HH:MM' + CHAR(10);

    IF @Tipo NOT IN ('A','T')
        SET @error += 'El tipo debe ser A: atraccion o T:tour' + CHAR(10);

    IF @Horario IS NULL
        SET @error += 'El horario no puede ser null' + CHAR(10);

    IF @Nombre IS NULL
        SET @error += 'El nombre no puede ser null' + CHAR(10);

    IF @Costo IS NULL
        SET @error += 'El costo no puede ser null' + CHAR(10);

    IF @Costo IS NOT NULL AND @Costo < 0
        SET @error += 'El costo no puede ser menor a 0' + CHAR(10);

    IF @Cupo_Max IS NULL
        SET @error += 'El cupo maximo no puede ser null' + CHAR(10);

    IF @Cupo_Max IS NOT NULL AND @Cupo_Max <= 0
        SET @error += 'El cupo maximo debe ser mayor a 0' + CHAR(10);

    IF @Tipo IS NULL OR LTRIM(RTRIM(@Tipo)) = ''
        SET @error += 'El tipo no puede ser null ni vacio' + CHAR(10);

    IF @Duracion IS NULL
        SET @error += 'La duracion no puede ser null' + CHAR(10);

    IF @Duracion IS NOT NULL AND @Duracion <= 0
        SET @error += 'La duracion debe ser mayor a 0' + CHAR(10);

    IF @ID_Guia IS NULL
        SET @error += 'Debe indicar un guia' + CHAR(10);

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

        INSERT INTO Atracciones.Tour
        (
            Costo,
            Cupo_Max,
            Tipo,
            Duracion,
            Nombre,
            Horario
        )
        VALUES
        (
            @Costo,
            @Cupo_Max,
            @Tipo,
            @Duracion,
            @Nombre,
            @Horario
        );

        DECLARE @ID_Tour INT;

        SET @ID_Tour = SCOPE_IDENTITY();

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

        PRINT 'Actividad registrada correctamente';
        RETURN @ID_Tour;
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
