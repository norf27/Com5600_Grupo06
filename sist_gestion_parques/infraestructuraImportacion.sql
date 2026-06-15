USE sist_gestion_parques; 

IF SCHEMA_ID('Staging') IS NULL
BEGIN
    EXEC('CREATE SCHEMA Staging'); 
END
GO

-- Archivo Nacional (aprn_f_defensa_2026.csv)

DROP TABLE IF EXISTS Staging.STG_DefensaAreasProtegidas;
CREATE TABLE Staging.STG_DefensaAreasProtegidas (
    nombre VARCHAR(MAX) NULL,
    provincia VARCHAR(MAX) NULL,
    creacion VARCHAR(MAX) NULL,
    hectareas VARCHAR(MAX) NULL,
    ambiente_protegido VARCHAR(MAX) NULL
);
GO

-- Archivo Internacional (WDPA_WDOECM_Jun2026_Public_ARG_csv.csv)

DROP TABLE IF EXISTS Staging.STG_WDPA_Areas;
CREATE TABLE Staging.STG_WDPA_Areas (
    TYPE VARCHAR(MAX) NULL,
    SITE_ID VARCHAR(MAX) NULL,
    NAME VARCHAR(MAX) NULL,
    DESIG VARCHAR(MAX) NULL,
    STATUS VARCHAR(MAX) NULL,
    STATUS_YR VARCHAR(MAX) NULL,
    GIS_AREA VARCHAR(MAX) NULL,
    MANG_AUTH VARCHAR(MAX) NULL
);
GO

-- Tabla para reportar los errores que impiden el procesamiento

DROP TABLE IF EXISTS Staging.Log_Errores_Importacion;
CREATE TABLE Staging.Log_Errores_Importacion (
    ID_Log INT IDENTITY(1,1) PRIMARY KEY,
    Fecha_Proceso DATETIME DEFAULT GETDATE(),
    Archivo_Origen VARCHAR(255) NOT NULL,
    Fila_Contenido_Raw VARCHAR(MAX) NOT NULL,
    Motivo_Error VARCHAR(500) NOT NULL
);
GO
