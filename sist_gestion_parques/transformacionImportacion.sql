USE sist_gestion_parques; 
GO 

---------------------------- CONVERSION DE MONEDAS ----------------------------

DROP TABLE IF EXISTS Staging.Cotizaciones_Moneda;
CREATE TABLE Staging.Cotizaciones_Moneda (
    Moneda CHAR(3) PRIMARY KEY,
    Tasa_A_Pesos_ARS DECIMAL(10,2) NOT NULL
);
GO

-- Cotizaciones de ejemplo
INSERT INTO Staging.Cotizaciones_Moneda (Moneda, Tasa_A_Pesos_ARS)
VALUES ('USD', 950.00), ('BRL', 170.50), ('ARS', 1.00);
GO

CREATE OR ALTER FUNCTION Staging.FN_ConvertirMontoAPesos (
    @MontoRaw VARCHAR(100),
    @MonedaOrigen CHAR(3)
)
RETURNS DECIMAL(11,2)
AS
BEGIN
    DECLARE @MontoConvertido DECIMAL(11,2) = NULL;
    DECLARE @ValorNumerico DECIMAL(11,2) = TRY_CAST(@MontoRaw AS DECIMAL(11,2));
    DECLARE @Tasa DECIMAL(10,2);

    IF @ValorNumerico IS NOT NULL
    BEGIN
        SELECT TOP 1 @Tasa = Tasa_A_Pesos_ARS 
        FROM Staging.Cotizaciones_Moneda 
        WHERE Moneda = @MonedaOrigen;

        IF @Tasa IS NOT NULL
            SET @MontoConvertido = @ValorNumerico * @Tasa;
    END

    RETURN @MontoConvertido;
END;
GO

---------------------------- CONVERSIÓN DE SUPERFICIES ----------------------------
   
CREATE OR ALTER FUNCTION Staging.FN_TransformarAreaAHectareas (
    @AreaRaw VARCHAR(100),
    @UnidadOrigen VARCHAR(10) -- 'KM2' o 'HA'
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @AreaConvertida DECIMAL(12,2) = NULL;
    DECLARE @ValorNumerico DECIMAL(12,4) = TRY_CAST(@AreaRaw AS DECIMAL(12,4));

    IF @ValorNumerico IS NOT NULL
    BEGIN
        -- Transformar KM2 a Hectareas
        IF UPPER(@UnidadOrigen) = 'KM2'
            SET @AreaConvertida = CAST((@ValorNumerico * 100.0) AS DECIMAL(12,2));
        ELSE
            SET @AreaConvertida = CAST(@ValorNumerico AS DECIMAL(12,2));
    END

    RETURN @AreaConvertida;
END;
GO

---------------------------- CONVERSION DE ERRORES (NOT REPORTED)----------------------------

CREATE OR ALTER FUNCTION Staging.FN_LimpiarTextoInternacional (
    @TextoRaw VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @TextoLimpio VARCHAR(MAX) = TRIM(@TextoRaw);
    
    -- Transformar Falta de datos a NULL
    IF UPPER(@TextoLimpio) IN ('NOT REPORTED', 'NOT APPLICABLE', '')
        SET @TextoLimpio = NULL;

    RETURN @TextoLimpio;
END;
GO
