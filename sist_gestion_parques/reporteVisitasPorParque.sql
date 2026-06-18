/*
Fecha: 3/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script para tabla cruzada mostrando visitas por mes y parque.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Ventas.SP_ReporteVisitasPorPeriodo
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.Nombre AS Parque,
        YEAR(E.Fecha_acceso) AS Anio,
        MONTH(E.Fecha_acceso) AS Mes,
        DATENAME(MONTH, E.Fecha_acceso) AS Nombre_Mes,
        DATEPART(WEEK, E.Fecha_acceso) AS Semana,
        COUNT(E.ID) AS Cantidad_Visitas
    FROM Ventas.Entrada E
    INNER JOIN Ventas.Tarifa T ON E.ID_tarifa = T.ID
    INNER JOIN Parque.Parque P ON T.ID_parque = P.ID
    INNER JOIN Ventas.Compra C ON E.ID_compra = C.ID
    INNER JOIN Ventas.Pago PA ON PA.ID_compra = C.ID
    WHERE 
        UPPER(E.Estado) = 'A'
        AND UPPER(T.Estado) = 'A'
        AND UPPER(P.Estado) = 'A'
        AND UPPER(C.Estado) = 'A'
        -- Solo contar visitas con pagos Confirmados o Activos
        AND UPPER(PA.Estado) IN ('C', 'A') 
    GROUP BY 
        P.Nombre,
        YEAR(E.Fecha_acceso),
        MONTH(E.Fecha_acceso),
        DATENAME(MONTH, E.Fecha_acceso),
        DATEPART(WEEK, E.Fecha_acceso)
    ORDER BY 
        Parque ASC,
        Anio DESC,
        Mes DESC,
        Semana DESC;
END;

