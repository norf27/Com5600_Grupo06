USE sist_gestion_parques; 
GO 

CREATE OR ALTER PROCEDURE Staging.SP_Importar_Nacional
    @RutaArchivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    --  Limpiar tabla previa

    TRUNCATE TABLE Staging.STG_DefensaAreasProtegidas;

    -- Importacion cruda de archivo

    SET @SQL = N'
    BULK INSERT Staging.STG_DefensaAreasProtegidas
    FROM ''' + @RutaArchivo + '''
    WITH (
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2,       -- Saltea la fila de cabeceras
        CODEPAGE = ''ACP''   -- Soporte nativo para eñes y acentos en español
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
        CONCAT('Parque: ', COALESCE(nombre, 'NULL'), ' | Prov: ', COALESCE(provincia, 'NULL'), ' | Has: ', COALESCE(hectareas, 'NULL')),
        'Error de formato: El valor de hectáreas o el año de creación contiene texto o caracteres no numéricos.'
    FROM Staging.STG_DefensaAreasProtegidas
    WHERE TRY_CAST(hectareas AS DECIMAL(12,2)) IS NULL 
       OR (TRY_CAST(creacion AS INT) IS NULL AND creacion IS NOT NULL);

    -- Upsert

    UPDATE P
    SET 
        P.Provincia = TRIM(S.provincia),
        P.Anio_Creacion = TRY_CAST(S.creacion AS INT),
        P.Hectareas = Staging.FN_TransformarAreaAHectareas(S.hectareas, 'HA'),
        P.Ambiente_Ecoregion = TRIM(S.ambiente_protegido),
        P.Fecha_Ultima_Actualizacion = GETDATE()
    FROM Parque.ParqueNacional P
    INNER JOIN Staging.STG_DefensaAreasProtegidas S 
        ON UPPER(TRIM(P.Nombre)) = UPPER(TRIM(S.nombre)) 
    WHERE TRY_CAST(S.hectareas AS DECIMAL(12,2)) IS NOT NULL;

    INSERT INTO Parque.ParqueNacional (Nombre, Provincia, Anio_Creacion, Hectareas, Ambiente_Ecoregion)
    SELECT 
        TRIM(S.nombre), 
        TRIM(S.provincia), 
        TRY_CAST(S.creacion AS INT), 
        Staging.FN_TransformarAreaAHectareas(S.hectareas, 'HA'), 
        TRIM(S.ambiente_protegido)
    FROM Staging.STG_DefensaAreasProtegidas S
    WHERE TRY_CAST(S.hectareas AS DECIMAL(12,2)) IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM Parque.ParqueNacional P 
          WHERE UPPER(TRIM(P.Nombre)) = UPPER(TRIM(S.nombre))
      );
END;
GO
