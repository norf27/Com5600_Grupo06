/*
Fecha: 3/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion: Procedure para importar Parques Nacionales (Versión Corregida con Soporte Decimal)
*/

USE sist_gestion_parques; 
GO 

-- Función para limpiar tildes y caracteres extraños
CREATE OR ALTER FUNCTION Staging.FN_Limpiar_Texto (@Texto VARCHAR(500))
RETURNS VARCHAR(500)
AS
BEGIN
    IF @Texto IS NULL RETURN NULL;

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

    -- 1. Limpiar tabla de staging
    TRUNCATE TABLE Staging.STG_DefensaAreasProtegidas;

    -- 2. Armar y ejecutar el BULK INSERT
    SET @SQL = N'
    BULK INSERT Staging.STG_DefensaAreasProtegidas
    FROM ''' + @RutaArchivo + '''
    WITH (
        FIELDTERMINATOR = '';'',
        ROWTERMINATOR = ''0x0a'', 
        FIRSTROW = 3,       
        CODEPAGE = ''ACP''   
    );';

    BEGIN TRY
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
        VALUES (@RutaArchivo, 'SISTEMA_CRÍTICO', 'Error físico al abrir o leer el archivo CSV: ' + ERROR_MESSAGE());
        RETURN;
    END CATCH;


    UPDATE Staging.STG_DefensaAreasProtegidas
    SET hectareas = REPLACE(REPLACE(hectareas, '"', ''), ',', '.'),
        creacion = REPLACE(creacion, '"', ''),
        provincia = TRIM(provincia),
        nombre = TRIM(nombre);


    -- 3. Validar errores de formato numérico o de año
    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('Parque: ', COALESCE(nombre, 'NULL'), ' | Prov: ', COALESCE(provincia, 'NULL'), ' | Has: ', COALESCE(hectareas, 'NULL')),
        'Error de formato: El valor de hectáreas o el año de creación contiene texto o caracteres no numéricos.'
    FROM Staging.STG_DefensaAreasProtegidas
    WHERE TRY_CAST(hectareas AS DECIMAL(12,2)) IS NULL  
       OR (TRY_CAST(creacion AS INT) IS NULL AND creacion IS NOT NULL);


    -- 4. Validar si la provincia no existe en la tabla maestra
    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('Parque: ', S.nombre, ' | Provincia faltante: ', S.provincia),
        'Error de Consistencia: La provincia no existe en la tabla Parque.Provincia. Debe darla de alta primero.'
    FROM Staging.STG_DefensaAreasProtegidas S
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Parque.Provincia P 
        WHERE UPPER(TRIM(P.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    );


    -- 5. Ejecutar el UPDATE (Upsert de registros existentes)
    UPDATE P
    SET 
        P.Superficie = TRY_CAST(S.hectareas AS DECIMAL(12,2)),
        P.Anio_Creacion = CASE WHEN TRY_CAST(S.creacion AS INT) IS NOT NULL 
                               THEN TRY_CAST(S.creacion AS INT) 
                               ELSE P.Anio_Creacion END,        
        P.Ambiente_Ecoregion = Staging.FN_Limpiar_Texto(REPLACE(TRIM(S.ambiente_protegido), '"', '')),
        P.ID_provincia = PROV.ID, 
        P.Fecha_Ultima_Actualizacion = GETDATE(),
        P.Estado = 'I'
    FROM Parque.Parque P
    INNER JOIN Staging.STG_DefensaAreasProtegidas S ON UPPER(TRIM(P.Nombre)) = UPPER(TRIM(REPLACE(S.nombre, '"', '')))
    INNER JOIN Parque.Provincia PROV ON UPPER(TRIM(PROV.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    WHERE TRY_CAST(S.hectareas AS DECIMAL(12,2)) IS NOT NULL; 


    -- 6. Ejecutar el INSERT (Nuevos registros)
    INSERT INTO Parque.Parque (Nombre, Superficie, ID_tipo, ID_provincia, Anio_Creacion, Ambiente_Ecoregion, Estado, Fecha_Ultima_Actualizacion)
    SELECT 
        Staging.FN_Limpiar_Texto(S.nombre), 
        TRY_CAST(S.hectareas AS DECIMAL(12,2)),
        NULL,
        PROV.ID, 
        TRY_CAST(S.creacion AS INT), 
        Staging.FN_Limpiar_Texto(REPLACE(TRIM(S.ambiente_protegido), '"', '')),
        'I',
        GETDATE()
    FROM Staging.STG_DefensaAreasProtegidas S
    INNER JOIN Parque.Provincia PROV ON UPPER(TRIM(PROV.Nombre)) = Staging.FN_Limpiar_Texto(S.provincia)
    WHERE TRY_CAST(S.hectareas AS DECIMAL(12,2)) IS NOT NULL
      AND TRY_CAST(S.hectareas AS DECIMAL(12,2)) > 0
      AND NOT EXISTS (
          SELECT 1 
          FROM Parque.Parque P 
          WHERE UPPER(TRIM(P.Nombre)) = UPPER(TRIM(S.nombre))
      );
END;
GO
