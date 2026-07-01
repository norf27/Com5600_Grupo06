/*
Fecha: 3/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion: Procedure para importar provincias (Uso de Función de Limpieza para UPSERT)
*/

USE sist_gestion_parques; 
GO 

CREATE OR ALTER PROCEDURE Staging.SP_Importar_Provincias
    @RutaArchivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    --limpiar tabla
    TRUNCATE TABLE Staging.STG_ImportarProvincias;

    --guardar en @sql lo que queremos ejecutar
    SET @SQL = N'
    INSERT INTO Staging.STG_ImportarProvincias (Contenido_JSON)
    SELECT BulkColumn 
    FROM OPENROWSET(BULK ''' + @RutaArchivo + ''', SINGLE_CLOB) AS J;';
    
    --ejecutar la consulta de @sql
    BEGIN TRY
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
        VALUES (@RutaArchivo, 'SISTEMA_CRÍTICO', 'Error físico al abrir o leer el archivo JSON de Provincias: ' + ERROR_MESSAGE());
        RETURN;
    END CATCH;

    --si el nombre es null o esta vacio, agregarlo a errores con la descipcion del error 
    --guarda el id o la provincia, si el ID es vacio va a quedar como Sin ID y la prov como NULL
    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('ID Origen: ', COALESCE(id_json, 'Sin ID'), ' | Nombre extraído: ', COALESCE(nombre_json, 'Sin nombre')),
        'Error de formato: El nombre de la provincia es nulo o vacío en el origen JSON.'
    FROM Staging.STG_ImportarProvincias STG 
    CROSS APPLY OPENJSON(STG.Contenido_JSON, '$.provincias')
    WITH (
        id_json VARCHAR(10) '$.id',
        nombre_json VARCHAR(100) '$.nombre'
    )
    WHERE nombre_json IS NULL OR TRIM(nombre_json) = ''; 

    --upsert 
    UPDATE P --si ya existe que le ponga el Estado como 'A' y guarde el nombre limpio en producción
    SET 
        P.Nombre = Staging.FN_Limpiar_Texto(ProvJson.nombre),
        P.Estado = 'A'
    FROM Parque.Provincia P
    INNER JOIN (
        SELECT DISTINCT TRIM(J.nombre) AS nombre
        FROM Staging.STG_ImportarProvincias STG
        CROSS APPLY OPENJSON(STG.Contenido_JSON, '$.provincias')
        WITH (
            nombre VARCHAR(100) '$.nombre'
        ) AS J
    ) ProvJson ON UPPER(TRIM(P.Nombre)) = Staging.FN_Limpiar_Texto(ProvJson.nombre)
    WHERE ProvJson.nombre <> '';

    INSERT INTO Parque.Provincia (Nombre, Estado) --si no existe que la cree limpia
    SELECT 
        Staging.FN_Limpiar_Texto(ProvJson.nombre), 
        'A'
    FROM Staging.STG_ImportarProvincias STG
    CROSS APPLY OPENJSON(STG.Contenido_JSON, '$.provincias')
    WITH (
        nombre VARCHAR(100) '$.nombre'
    ) ProvJson
    WHERE TRIM(ProvJson.nombre) <> ''
      AND NOT EXISTS (
          SELECT 1 
          FROM Parque.Provincia P 
          -- Al evaluar contra el texto limpio por función, evitamos que intente
          -- insertar nuevamente una provincia procesada en la ejecución anterior
          WHERE UPPER(TRIM(P.Nombre)) = Staging.FN_Limpiar_Texto(ProvJson.nombre)
      );

END;
GO
