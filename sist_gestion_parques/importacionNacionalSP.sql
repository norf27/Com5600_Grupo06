/*
Fecha: 3/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Procedure para importar Parques Nacionales (Versión Prolija con Función)
*/

USE sist_gestion_parques; 
GO 

--forma de limpiar el texto cuando lee las tildes, si alguno encuentra una forma mas prolija cambienlo
CREATE OR ALTER FUNCTION Staging.FN_Limpiar_Texto (@Texto VARCHAR(500))
RETURNS VARCHAR(500)
AS
BEGIN
    IF @Texto IS NULL RETURN NULL;

    -- Acá vive la lógica de reemplazo bien guardada y aislada
SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, '"', '');
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(161), 'a'); -- á
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(130), 'A'); -- Á
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(169), 'e'); -- é
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(137), 'E'); -- É
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(173), 'i'); -- í
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(141), 'I'); -- Í
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(179), 'o'); -- ó
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(147), 'O'); -- Ó
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(186), 'u'); -- ú
    SET @Texto = REPLACE(@Texto COLLATE Latin1_General_CS_AS, CHAR(195) + CHAR(154), 'U'); -- Ú

    RETURN TRIM(@Texto);
END;
GO



CREATE OR ALTER PROCEDURE Staging.SP_Importar_Nacional
    @RutaArchivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    --limpiar tabla
    TRUNCATE TABLE Staging.STG_DefensaAreasProtegidas;

    --guardar sentencia a ejecutar
    SET @SQL = N'
    BULK INSERT Staging.STG_DefensaAreasProtegidas
    FROM ''' + @RutaArchivo + '''
    WITH (
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''0x0a'', 
        FIRSTROW = 3,       
        CODEPAGE = ''ACP''   
    );';
    --hacer el bulk insert
    BEGIN TRY
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
        VALUES (@RutaArchivo, 'SISTEMA_CRÍTICO', 'Error físico al abrir o leer el archivo CSV: ' + ERROR_MESSAGE());
        RETURN;
    END CATCH;

    --si hay algun error en hectarea dar el error
    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('Parque: ', COALESCE(nombre, 'NULL'), ' | Prov: ', COALESCE(provincia, 'NULL'), ' | Has: ', COALESCE(hectareas, 'NULL')),
        'Error de formato: El valor de hectáreas o el año de creación contiene texto o caracteres no numéricos.'
    FROM Staging.STG_DefensaAreasProtegidas
    WHERE TRY_CAST(REPLACE(hectareas, '"', '') AS DECIMAL(12,2)) IS NULL  
       OR (TRY_CAST(REPLACE(creacion, '"', '') AS INT) IS NULL AND REPLACE(creacion, '"', '') IS NOT NULL);

    --si tiene una provincia que no existe dar el error
    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('Parque: ', REPLACE(S.nombre, '"', ''), ' | Provincia faltante: ', REPLACE(S.provincia, '"', '')),
        'Error de Consistencia: La provincia no existe en la tabla Parque.Provincia. Debe darla de alta primero.'
    FROM Staging.STG_DefensaAreasProtegidas S
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Parque.Provincia P 
        WHERE UPPER(TRIM(P.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    );

    --upsert
    UPDATE P
    SET 
        P.Superficie = TRY_CAST(S.hectareas AS DECIMAL(12,2)),
        P.Anio_Creacion = CASE WHEN TRY_CAST(S.creacion AS INT) IS NOT NULL 
                           THEN TRY_CAST(S.creacion AS INT) 
                           ELSE P.Anio_Creacion END,        
        P.Ambiente_Ecoregion = Staging.FN_Limpiar_Texto(REPLACE(TRIM(S.ambiente_protegido), '"', '')),
        P.ID_provincia = PROV.ID, 
        P.Fecha_Ultima_Actualizacion = GETDATE()
    FROM Parque.Parque P
    INNER JOIN Staging.STG_DefensaAreasProtegidas S ON UPPER(TRIM(P.Nombre)) = UPPER(TRIM(REPLACE(S.nombre, '"', '')))
    INNER JOIN Parque.Provincia PROV ON UPPER(TRIM(PROV.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    WHERE TRY_CAST(REPLACE(S.hectareas, '"', '') AS DECIMAL(12,2)) IS NOT NULL; 


    INSERT INTO Parque.Parque (Nombre, Superficie, ID_tipo, ID_provincia, Anio_Creacion, Ambiente_Ecoregion, Estado, Fecha_Ultima_Actualizacion)
    SELECT 
        Staging.FN_Limpiar_Texto(REPLACE(TRIM(S.nombre), '"', '')), 
        TRY_CAST(S.hectareas AS DECIMAL(12,2)),
        NULL,
        PROV.ID, 
        TRY_CAST(REPLACE(S.creacion, '"', '') AS INT), 
        Staging.FN_Limpiar_Texto(REPLACE(TRIM(S.ambiente_protegido), '"', '')),
        'A',
        GETDATE()
    FROM Staging.STG_DefensaAreasProtegidas S
    -- Cruzamos directo contra la función limpia
    INNER JOIN Parque.Provincia PROV ON UPPER(TRIM(PROV.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    WHERE TRY_CAST(REPLACE(S.hectareas, '"', '') AS DECIMAL(12,2)) IS NOT NULL
      AND TRY_CAST(S.hectareas AS DECIMAL(12,2)) > 0
      AND NOT EXISTS (
          SELECT 1 
          FROM Parque.Parque P 
          WHERE UPPER(TRIM(P.Nombre)) = UPPER(TRIM(REPLACE(S.nombre, '"', '')))
      );
END;
GO
