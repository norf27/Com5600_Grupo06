USE sist_gestion_parques; 
GO 

CREATE OR ALTER PROCEDURE Staging.SP_Importar_WDPA
    @RutaArchivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    --  Limpiar tabla previa
    TRUNCATE TABLE Staging.STG_WDPA_Areas;

    -- Importacion cruda de archivo

    SET @SQL = N'
    BULK INSERT Staging.STG_WDPA_Areas
    FROM ''' + @RutaArchivo + '''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2        -- Saltea las cabeceras técnicas en inglés
    );';
    
    BEGIN TRY
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
        VALUES (@RutaArchivo, 'SISTEMA_CRÍTICO', 'Error físico al abrir o leer el archivo CSV: ' + ERROR_MESSAGE());
        RETURN;
    END CATCH;

    -- Validacion

    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('WDPA_ID: ', COALESCE(SITE_ID, 'NULL'), ' | Name: ', COALESCE(NAME, 'NULL'), ' | Area_Raw: ', COALESCE(GIS_AREA, 'NULL')),
        'Error de formato: El campo GIS_AREA no contiene un valor numerico decimal válido o es indeterminado.'
    FROM Staging.STG_WDPA_Areas
    WHERE TRY_CAST(GIS_AREA AS DECIMAL(12,4)) IS NULL;

    -- Upsert
    
    UPDATE P
    SET 
        P.Anio_Creacion = TRY_CAST(Staging.FN_LimpiarTextoInternacional(S.STATUS_YR) AS INT),
        P.Superficie = Staging.FN_TransformarAreaAHectareas(S.GIS_AREA, 'KM2'),
        P.Ambiente_Ecoregion = TRIM(S.DESIG),
        P.Fecha_Ultima_Actualizacion = GETDATE()
    FROM Parque.Parque P
    INNER JOIN Staging.STG_WDPA_Areas S 
        ON UPPER(TRIM(P.Nombre)) = UPPER(TRIM(S.NAME)) 
    WHERE TRY_CAST(S.GIS_AREA AS DECIMAL(12,4)) IS NOT NULL; 

    INSERT INTO Parque.Parque (Nombre, Superficie, ID_tipo, ID_provincia, Anio_Creacion, Ambiente_Ecoregion)
    SELECT 
        TRIM(S.NAME), 
        Staging.FN_TransformarAreaAHectareas(S.GIS_AREA, 'KM2'), 
        NULL, -- El CSV de la ONU no se mapea a los Tipos locales
        NULL, -- El CSV de la ONU no especifica provincias locales
        TRY_CAST(Staging.FN_LimpiarTextoInternacional(S.STATUS_YR) AS INT), 
        TRIM(S.DESIG)
    FROM Staging.STG_WDPA_Areas S
    WHERE TRY_CAST(S.GIS_AREA AS DECIMAL(12,4)) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM Parque.Parque P 
          WHERE UPPER(TRIM(P.Nombre)) = UPPER(TRIM(S.NAME))
      );
END;
GO

