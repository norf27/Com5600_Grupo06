/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script para Reporte de ingresos por semana, mes y año, por parque.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Ventas.SP_ReporteIngresosPorPeriodo
AS
BEGIN
    SET NOCOUNT ON;

    WITH Ingresos AS
    (
        SELECT
            P.Nombre AS Parque,
            CAST(C.Fecha AS DATE) AS Fecha_Ingreso,
            'Entrada' AS Concepto,
            T.Precio AS Importe
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
            -- Solo contar ingresos con pagos Confirmados o Activos
            AND UPPER(PA.Estado) IN ('C', 'A')

        UNION ALL

        SELECT
            P.Nombre AS Parque,
            CAST(C.Fecha AS DATE) AS Fecha_Ingreso,
            'Tour' AS Concepto,
            ISNULL(Tour.Costo, 0) AS Importe
        FROM Ventas.Entrada E
        INNER JOIN Atracciones.R_Tour_Entrada RTE ON E.ID = RTE.ID_Entrada
        INNER JOIN Atracciones.Tour Tour ON RTE.ID_Tour = Tour.ID_Tour
        INNER JOIN Parque.Parque P ON Tour.ID_Parque = P.ID
        INNER JOIN Ventas.Compra C ON E.ID_compra = C.ID
        INNER JOIN Ventas.Pago PA ON PA.ID_compra = C.ID
        WHERE
            UPPER(E.Estado) = 'A'
            AND UPPER(RTE.Estado) = 'A'
            AND UPPER(Tour.Estado) = 'A'
            AND UPPER(P.Estado) = 'A'
            AND UPPER(C.Estado) = 'A'
            -- Solo contar ingresos con pagos Confirmados o Activos
            AND UPPER(PA.Estado) IN ('C', 'A')
    )
    SELECT
        Parque,
        YEAR(Fecha_Ingreso) AS Anio,
        MONTH(Fecha_Ingreso) AS Mes,
        DATENAME(MONTH, Fecha_Ingreso) AS Nombre_Mes,
        DATEPART(WEEK, Fecha_Ingreso) AS Semana,
        SUM(CASE WHEN Concepto = 'Entrada' THEN Importe ELSE 0 END) AS Ingresos_Entradas,
        SUM(CASE WHEN Concepto = 'Tour' THEN Importe ELSE 0 END) AS Ingresos_Tours,
        SUM(Importe) AS Ingresos_Totales
    FROM Ingresos
    GROUP BY
        Parque,
        YEAR(Fecha_Ingreso),
        MONTH(Fecha_Ingreso),
        DATENAME(MONTH, Fecha_Ingreso),
        DATEPART(WEEK, Fecha_Ingreso)
    ORDER BY
        Parque ASC,
        Anio DESC,
        Mes DESC,
        Semana DESC;
END;
GO
