/*
Fecha: 3/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script para Reporte de parques y concesiones
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Concesiones.SP_ReporteParquesYConcesiones
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.ID AS ID_Parque,
        P.Nombre AS Parque,
        P.Superficie,
        C.ID AS ID_Concesion,
        C.Fecha_inicio AS Fecha_Inicio,
        C.Fecha_fin AS Fecha_Fin,
        E.Nombre AS Titular_Empresa,
        E.CUIT AS CUIT_Empresa,
        TA.Nombre AS Servicio_Prestado,
        CASE 
            WHEN CAST(GETDATE() AS DATE) BETWEEN C.Fecha_inicio AND C.Fecha_fin THEN 'Vigente'
            ELSE 'Finalizada'
        END AS Estado_Vigencia
    FROM Parque.Parque P
    LEFT JOIN Concesiones.Concesion C ON C.ID_parque = P.ID AND UPPER(C.Estado) = 'A'
    LEFT JOIN Concesiones.Empresa E ON C.ID_empresa = E.ID AND UPPER(E.Estado) = 'A'
    LEFT JOIN Concesiones.Tipo_actividad TA ON C.ID_tipo = TA.ID AND UPPER(TA.Estado) = 'A'
    WHERE UPPER(P.Estado) = 'A'
    ORDER BY P.Nombre ASC, C.Fecha_inicio DESC;
END;
GO
