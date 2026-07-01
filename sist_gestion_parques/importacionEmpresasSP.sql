/*

Fecha: 3/07/2026
Universidad Nacional de La Matanza, Bases de Datos Aplicadas
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas 
Descripcion: Procedure para importar Empresas.

*/

USE sist_gestion_parques; 
GO

CREATE OR ALTER PROCEDURE Staging.SP_Importar_EmpresasCSV
    @RutaArchivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SQL NVARCHAR(MAX);

    TRUNCATE TABLE Staging.STG_Empresa;

    SET @SQL = N'
    BULK INSERT Staging.STG_Empresa
    FROM ''' + @RutaArchivo + '''
    WITH (
        FORMAT = ''CSV'',
        FIRSTROW = 2,
        FIELDQUOTE = ''"'',
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''0x0a'', 
        CODEPAGE = ''65001'' 
    );';

    BEGIN TRY
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
        VALUES (@RutaArchivo, 'SISTEMA_CRÍTICO', 'Error físico al abrir o leer el archivo CSV: ' + ERROR_MESSAGE());
        RETURN;
    END CATCH;

    UPDATE Staging.STG_Empresa
    SET organizacion = TRIM(REPLACE(organizacion, '"', '')),
        telefono = CASE 
                      WHEN TRIM(REPLACE(telefono, '"', '')) IN ('NA', '') THEN NULL 
                      ELSE TRIM(REPLACE(telefono, '"', '')) 
                   END;

    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT 
        @RutaArchivo,
        CONCAT('Organización: ', COALESCE(organizacion, 'NULL')),
        'Error de formato: La organización no tiene nombre o excede la longitud permitida (100 caracteres).'
    FROM Staging.STG_Empresa
    WHERE organizacion IS NULL 
       OR organizacion = ''
       OR LEN(organizacion) > 100;

    INSERT INTO Staging.Log_Errores_Importacion (Archivo_Origen, Fila_Contenido_Raw, Motivo_Error)
    SELECT
        @RutaArchivo,
        CONCAT('Teléfono: ', COALESCE(telefono, 'NULL')),
        'Teléfono inválido: formato incorrecto o longitud inválida.'
    FROM Staging.STG_Empresa
    WHERE telefono IS NOT NULL
      AND (
            --telefono LIKE '%[^0-9 ()-/]%'
            LEN(telefono) < 6
            OR LEN(telefono) > 50
          );

    UPDATE E
    SET 
        E.Telefono = LEFT(S.telefono, 20),
        E.Estado = 'A'
    FROM Concesiones.Empresa E
    INNER JOIN Staging.STG_Empresa S ON UPPER(TRIM(E.Nombre)) = UPPER(TRIM(S.organizacion))
    WHERE S.organizacion IS NOT NULL 
      AND LEN(S.organizacion) <= 100;

    INSERT INTO Concesiones.Empresa (Nombre, Telefono, Estado)
    SELECT DISTINCT
        S.organizacion,
        LEFT(S.telefono, 20),
        'A'
    FROM Staging.STG_Empresa S
    WHERE S.organizacion IS NOT NULL 
      AND S.organizacion <> ''
      AND LEN(S.organizacion) <= 100
      AND NOT EXISTS (
          SELECT 1 
          FROM Concesiones.Empresa E 
          WHERE UPPER(TRIM(E.Nombre)) = UPPER(TRIM(S.organizacion))
      );
END;
GO
