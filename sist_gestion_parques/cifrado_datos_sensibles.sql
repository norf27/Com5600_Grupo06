USE sist_gestion_parques;
GO

create or alter procedure SP_Cifrar as begin
------------------ COLUMNAS CIFRADAS: EMPLEADO -------------------

IF COL_LENGTH('Empleados.Empleado', 'DNI_CifradoFraseClave') IS NULL
BEGIN
	ALTER TABLE Empleados.Empleado
	ADD DNI_CifradoFraseClave VARBINARY(256) NULL;
END


IF COL_LENGTH('Empleados.Empleado', 'Sueldo_CifradoFraseClave') IS NULL
BEGIN
	ALTER TABLE Empleados.Empleado
	ADD Sueldo_CifradoFraseClave VARBINARY(256) NULL;
END


IF COL_LENGTH('Empleados.Empleado', 'CUIL_CifradoFraseClave') IS NULL
BEGIN
	ALTER TABLE Empleados.Empleado
	ADD CUIL_CifradoFraseClave VARBINARY(256) NULL;
END


------------------ COLUMNAS CIFRADAS: CLIENTE -------------------

IF COL_LENGTH('Ventas.Cliente', 'Tipo_doc_CifradoFraseClave') IS NULL
BEGIN
	ALTER TABLE Ventas.Cliente
	ADD Tipo_doc_CifradoFraseClave VARBINARY(256) NULL;
END


IF COL_LENGTH('Ventas.Cliente', 'Documento_CifradoFraseClave') IS NULL
BEGIN
	ALTER TABLE Ventas.Cliente
	ADD Documento_CifradoFraseClave VARBINARY(256) NULL;
END


------------------ CIFRADO DE DATOS SENSIBLES -------------------

-- Obtenemos la clave de cifrado. Lo cargariamos desde otra capa.
DECLARE @FraseClaveCargadaPorUsuario NVARCHAR(128);
SET @FraseClaveCargadaPorUsuario = 'MessiGoat';

-- Se usa SQL dinamico porque no se puede usar go adentro de un procedure

-- Ciframos los datos sensibles de empleados.
-- Se agrega un hash/autenticador usando la PK ID de Empleados.Empleado.
exec sp_executesql '
UPDATE Empleados.Empleado
SET DNI_CifradoFraseClave =
		EncryptByPassPhrase(
			@FraseClaveCargadaPorUsuario,
			CONVERT(VARBINARY(MAX), DNI),
			1,
			CONVERT(VARBINARY, ID)
		),
	Sueldo_CifradoFraseClave =
		EncryptByPassPhrase(
			@FraseClaveCargadaPorUsuario,
			CONVERT(VARBINARY(MAX), CONVERT(VARCHAR(32), Sueldo)),
			1,
			CONVERT(VARBINARY, ID)
		),
	CUIL_CifradoFraseClave =
		EncryptByPassPhrase(
			@FraseClaveCargadaPorUsuario,
			CONVERT(VARBINARY(MAX), CUIL),
			1,
			CONVERT(VARBINARY, ID)
		);
		'
-- Ciframos los datos sensibles de clientes.
-- Se agrega un hash/autenticador usando la PK ID de Ventas.Cliente.
exec sp_executesql '
UPDATE Ventas.Cliente
SET Tipo_doc_CifradoFraseClave =
		EncryptByPassPhrase(
			@FraseClaveCargadaPorUsuario,
			CONVERT(VARBINARY(MAX), Tipo_doc),
			1,
			CONVERT(VARBINARY, ID)
		),
	Documento_CifradoFraseClave =
		EncryptByPassPhrase(
			@FraseClaveCargadaPorUsuario,
			CONVERT(VARBINARY(MAX), Documento),
			1,
			CONVERT(VARBINARY, ID)
		);
	'

end
go