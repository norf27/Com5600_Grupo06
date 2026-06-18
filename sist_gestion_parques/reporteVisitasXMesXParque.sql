/*
Fecha: 3/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script para Reporte de visitas por semana, mes y año, por parque.
*/




USE sist_gestion_parques
GO

CREATE OR ALTER PROCEDURE Parque.SP_ReporteVisitasXMesXParque
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;

        WITH DatosBase AS (
            SELECT 
                p.Nombre AS NombreParque,
                MONTH(e.Fecha_acceso) AS Mes,
                e.ID AS ID_Entrada
            FROM Ventas.Entrada e
            INNER JOIN Ventas.Tarifa t ON e.ID_tarifa = t.ID
            INNER JOIN Parque.Parque p ON t.ID_parque = p.ID
            WHERE YEAR(e.Fecha_acceso) = @Anio 
              AND UPPER(e.Estado) = 'A' 
        )

        SELECT 
            NombreParque AS Parque,
            ISNULL([1], 0) AS Enero,
            ISNULL([2], 0) AS Febrero,
            ISNULL([3], 0) AS Marzo,
            ISNULL([4], 0) AS Abril,
            ISNULL([5], 0) AS Mayo,
            ISNULL([6], 0) AS Junio,
            ISNULL([7], 0) AS Julio,
            ISNULL([8], 0) AS Agosto,
            ISNULL([9], 0) AS Septiembre,
            ISNULL([10], 0) AS Octubre,
            ISNULL([11], 0) AS Noviembre,
            ISNULL([12], 0) AS Diciembre
        FROM DatosBase
        PIVOT 
        (
            COUNT(ID_Entrada)
            FOR Mes IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
        ) AS MatrizPivot
        ORDER BY NombreParque;
   
END;
GO