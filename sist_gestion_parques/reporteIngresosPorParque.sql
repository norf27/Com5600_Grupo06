/*
Fecha: 03/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion: Script para Reporte de ingresos por semana, mes y año, por parque.
*/

USE sist_gestion_parques;
GO

CREATE OR ALTER PROCEDURE Ventas.SP_ReporteIngresosPorPeriodo @UsarUSD char(1) = 'F'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @multiplicar decimal(10,2) = 1 --por defecto 1 peso = 1 peso
    if @UsarUSD != 'F'
    begin
        DECLARE @urlDolar NVARCHAR(128) = 'https://dolarapi.com/v1/dolares/oficial' 
        DECLARE @Object INT
        DECLARE @jsonTable TABLE(DATA NVARCHAR(MAX))
        DECLARE @ValorUsd DECIMAL(10, 2) -- Variable para guardar el precio final


        EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT
        EXEC sp_OAMethod @Object, 'OPEN', NULL, 'GET', @urlDolar, 'FALSE'
        EXEC sp_OAMethod @Object, 'SEND'


        INSERT INTO @jsonTable 
        EXEC sp_OAGetProperty @Object, 'RESPONSETEXT'
        EXEC sp_OADestroy @Object


        DECLARE @datosDolar NVARCHAR(MAX) = (SELECT DATA FROM @jsonTable)


        SELECT @ValorUsd = precio
        FROM OPENJSON(@datosDolar)
        WITH (
            precio DECIMAL(10, 2) '$.venta'
        )
        set @multiplicar = @ValorUsd
    end
    ;WITH Ingresos AS
    (
        SELECT
            P.Nombre AS Parque,
            CAST(C.Fecha AS DATE) AS Fecha_Ingreso,
            'Entrada' AS Concepto,
            T.Precio * C.Descuento AS Importe
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
            -- Solo contar ingresos con pagos Confirmados
            AND UPPER(PA.Estado) = 'C'

        UNION ALL

        SELECT
            P.Nombre AS Parque,
            CAST(C.Fecha AS DATE) AS Fecha_Ingreso,
            'Tour' AS Concepto,
            ISNULL(Tour.Costo, 0) * C.Descuento AS Importe
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
            -- Solo contar ingresos con pagos Confirmados
            AND UPPER(PA.Estado) IN ('C')
    )
    SELECT
        Parque,
        YEAR(Fecha_Ingreso) AS Anio,
        MONTH(Fecha_Ingreso) AS Mes,
        DATENAME(MONTH, Fecha_Ingreso) AS Nombre_Mes,
        DATEPART(WEEK, Fecha_Ingreso) AS Semana,
        SUM(CASE WHEN Concepto = 'Entrada' THEN Importe ELSE 0 END) / @multiplicar AS Ingresos_Entradas,
        SUM(CASE WHEN Concepto = 'Tour' THEN Importe ELSE 0 END) / @multiplicar AS Ingresos_Tours,
        SUM(Importe) / @multiplicar AS Ingresos_Totales
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
