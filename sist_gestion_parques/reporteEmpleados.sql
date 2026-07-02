/*
Fecha: 03/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas
Descripcion: Reporte de empleados activos por parque, mostrando el descifrado
de DNI, sueldo y CUIL mediante la frase clave y el ID del empleado como autenticador.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Empleados.SP_ReporteEmpleadosActivos
AS
BEGIN
    SET NOCOUNT ON;

    -- En una implementacion productiva, la frase clave debe obtenerse
    -- desde una capa segura y no almacenarse en el codigo.
    DECLARE @FraseClaveCargadaPorUsuario NVARCHAR(128) = N'MessiGoat';

    SELECT
        E.ID,
        E.Nombre,
        E.Nacimiento,
        CONVERT(
            VARCHAR(8),
            DecryptByPassPhrase(
                @FraseClaveCargadaPorUsuario,
                E.DNI_CifradoFraseClave,
                1,
                CONVERT(VARBINARY, E.ID)
            )
        ) AS DNI,
        CONVERT(
            DECIMAL(11,2),
            CONVERT(
                VARCHAR(32),
                DecryptByPassPhrase(
                    @FraseClaveCargadaPorUsuario,
                    E.Sueldo_CifradoFraseClave,
                    1,
                    CONVERT(VARBINARY, E.ID)
                )
            )
        ) AS Sueldo,
        CONVERT(
            VARCHAR(13),
            DecryptByPassPhrase(
                @FraseClaveCargadaPorUsuario,
                E.CUIL_CifradoFraseClave,
                1,
                CONVERT(VARBINARY, E.ID)
            )
        ) AS CUIL,
        E.Estado,
        E.ID_parque,
        P.Nombre AS Parque
    FROM Empleados.Empleado AS E
    INNER JOIN Parque.Parque AS P
        ON P.ID = E.ID_parque
    WHERE UPPER(E.Estado) = 'A'
    ORDER BY
        P.Nombre ASC,
        E.Nombre ASC,
        E.ID ASC;
END;
GO
