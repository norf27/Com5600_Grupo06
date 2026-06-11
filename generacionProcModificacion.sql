
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------

--------------------PARQUE-----------------------
create or alter procedure ModificarTipo_parque @ID bigint, @NuevoNombre varchar(100),@NuevaDesc varchar(250) as 
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error = @error + 'La ID no puede ser null' + char(10)
        if not exists (select 1 from Parque.Tipo_parque where ID = @ID)
            set @error = @error + 'No existe ID' + char(10)
        if @NuevaDesc is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)
        if @NuevoNombre is null
            set @error = @error + 'El nombre no puede ser null' + char(10)
        if exists(select 1 from Parque.Tipo_parque where Nombre = @NuevoNombre and ID != @ID)
            set @error += 'El tipo de parque "' + @NuevoNombre +'" ya existe en la tabla Tipo_parque' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Parque.Tipo_parque set Descripcion = @NuevaDesc, Nombre = @NuevoNombre where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

create or alter procedure ModificarProvincia @ID bigint, @NuevoNombre varchar(100) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Parque.Provincia where ID = @ID)
            set @error += 'No existe ID' + char(10)
        if @NuevoNombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if exists (select 1 from Parque.Provincia where Nombre = @NuevoNombre and ID != @ID)
            set @error += 'El nombre ya existe' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Parque.Provincia set Nombre = @NuevoNombre where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

create or alter procedure ModificarParque @ID bigint, @NuevaSuperficie int, @NuevoNombre varchar(100), @NuevoID_tipo bigint, @NuevoID_provincia bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
         if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Parque.Parque where ID = @ID)
            set @error += 'No existe ID' + char(10)
        if @NuevaSuperficie is null
            set @error += 'La superficie no puede ser null' + char(10)
        if @NuevaSuperficie <= 0
            set @error += 'La superficie no puede ser <= 0' + char(10)
        if @NuevoNombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @NuevoID_tipo is null
            set @error += 'El ID_tipo no puede ser null' + char(10)
        if not exists (select 1 from Parque.Tipo_parque where ID = @NuevoID_tipo)
            set @error += 'El ID_tipo no existe' + char(10)
        if @NuevoID_provincia is null
            set @error += 'El ID_provincia no puede ser null' + char(10)
        if not exists (select 1 from Parque.Provincia where ID = @NuevoID_provincia)
            set @error += 'El ID_provincia no existe' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Parque.Parque set Superficie = @NuevaSuperficie, Nombre = @NuevoNombre, ID_tipo = @NuevoID_tipo, ID_provincia = @NuevoID_provincia where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

--------------------EMPLEADOS-----------------------
create or alter procedure ModificarEmpleado @ID bigint, @Nacimiento date,
@DNI varchar(8),
@Nombre varchar(100),
@Sueldo decimal(11,2),
@Estado char(1),
@ID_parque bigint,
@CUIL varchar(13) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Estado is null
            set @Estado = 'a'
        if @DNI is null
            set @error += 'El DNI no puede ser null' + char(10)
        if exists(select 1 from Empleados.Empleado where DNI = @DNI and ID != @ID)
            set @error += 'El DNI no puede ser repetido' + char(10)
        if @Nacimiento is null
            set @error += 'La fecha de nacimiento no puede ser null' + char(10)
        if @Nacimiento > dateadd(year, -18, cast(getdate() as date))
            set @error += 'La fecha de nacimiento debe ser de hace al menos 18 años' + char(10)
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @sueldo is null 
            set @error += 'El sueldo no puede ser null' + char(10)
        if @sueldo <= 0
            set @error += 'El sueldo debe ser mayor a 0' + char(10)
        if @Estado not in ('i', 'a', 'l','v')
            set @error += 'Estado invalido. Validos: a, i, l, v' + char(10)
        if @ID_parque is null
            set @error += 'El ID_parque no puede ser null' + char(10)
        if not exists(select 1 from Parque.Parque where ID = @ID_parque)
            set @error += 'El ID_parque no existe' + char(10)
        if @CUIL is null
            set @error += 'El CUIL no puede ser null' + char(10)
        if exists (select 1 from Empleados.Empleado where CUIL = @CUIL and ID != @ID)
            set @error += 'El CUIL no puede ser repetido' + char(10)
        if @DNI not like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
            set @error += 'El DNI es invalido' + char(10)
        if @CUIL not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIL es invalido' + char(10)
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Empleados.Empleado where ID = @ID)
            set @error += 'No existe ID' + char(10)
    
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Empleados.Empleado set Nombre = @Nombre, Nacimiento = @Nacimiento, DNI = @DNI, Sueldo = @Sueldo, Estado = @Estado, ID_parque = @ID_parque, CUIL = @CUIL
        where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

--------------------CONSECIONES-----------------------
create or alter procedure ModificarTipo_actividad @ID bigint, @NuevoNombre varchar(100),@NuevaDesc varchar(250) as 
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error = @error + 'La ID no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Tipo_actividad where ID = @ID)
            set @error = @error + 'No existe ID' + char(10)
        if @NuevaDesc is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)
        if @NuevoNombre is null
            set @error = @error + 'El nombre no puede ser null' + char(10)
        if exists(select 1 from Concesiones.Tipo_actividad where Nombre = @NuevoNombre and ID != @ID)
            set @error += 'El tipo de actividad "' + @NuevoNombre + '" ya existe en la tabla Tipo_actividad' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Concesiones.Tipo_actividad set Descripcion = @NuevaDesc, Nombre = @NuevoNombre where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

create or alter procedure ModificarEmpresa @ID bigint,
@NuevoNombre varchar(100),
@NuevoCUIT varchar(13),
@NuevoCorreo varchar(100) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Concesiones.Empresa where ID = @ID)
            set @error += 'No existe ID' + char(10)
        if @NuevoNombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @NuevoCUIT is null
            set @error += 'El CUIT no puede ser null' + char(10)
        if exists(select 1 from Concesiones.Empresa where CUIT = @NuevoCUIT and ID != @ID)
            set @error += 'El CUIT "' + @NuevoCUIT + '" ya esta siendo usado en la tabla' + char(10)
        if @NuevoCorreo is null
            set @error += 'El correo no puede ser null' + char(10)
        if @NuevoCUIT not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIT es invalido' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Concesiones.Empresa set Nombre = @NuevoNombre, Correo = @NuevoCorreo, CUIT = @NuevoCUIT where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

create or alter procedure ModificarConcesion
        @ID BIGINT,
        @Fecha_inicio DATE,
		@Fecha_fin DATE,
		@ID_empresa BIGINT,
		@ID_tipo BIGINT,
		@ID_parque BIGINT as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Concesiones.Concesion where ID = @ID)
            set @error += 'El ID no existe' + char(10)
        if @Fecha_inicio is null
            set @error += 'La fecha de inicio no puede ser null' + char(10)
        if @Fecha_fin is null
            set @error += 'La fecha de fin no puede ser null' + char(10)
        if @ID_empresa is null
            set @error += 'El ID_empresa no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Empresa where ID = @ID_empresa)
            set @error += 'El ID_empresa no existe' + char(10)
        if @ID_tipo is null
            set @error += 'El ID_tipo no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Tipo_actividad where ID = @ID_tipo)
            set @error += 'El ID_tipo no existe' + char(10)
        if @ID_parque is null
            set @error += 'El ID_parque no puede ser null' + char(10)
        if not exists (select 1 from Parque.Parque where ID = @ID_parque)
            set @error += 'El ID_parque no existe' + char(10)
        if @Fecha_fin < @Fecha_inicio
            set @error += 'La fecha de fin no puede ser anterior a la fecha de inicio' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Concesiones.Concesion set Fecha_fin = @Fecha_fin, Fecha_inicio = @Fecha_inicio, ID_empresa = @ID_empresa, ID_tipo = @ID_tipo,
        ID_parque = @ID_parque where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go


create or alter procedure ModificarPago_mensual 
        @ID bigint, 
        @Fecha DATE,
		@Monto DECIMAL(11,2),
		@Metodo VARCHAR(100),
		@ID_concesion BIGINT as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(500) = ''
         if @ID is null
            set @error += 'El ID no puede ser null'
        if not exists (select 1 from Concesiones.Pago_mensual where ID = @ID)
            set @error += 'El ID es invalido' + char(10)
        if @Monto is null
            set @error += 'El monto no puede ser null' + char(10)
        if @Metodo is null
            set @error += 'El metodo no puede ser null' + char(10)
        if @ID_concesion is null
            set @error += 'El ID_concesion no puede ser null' + char(10)
        if @Monto <= 0
            set @error += 'El monto no puede ser menor o igual a 0' + char(10)
        if not exists (select 1 from Concesiones.Concesion where ID = @ID_concesion)
            set @error += 'El ID_concesion no existe' + char(10)
        if @Fecha is null
            set @Fecha = DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1)
        if exists (select 1 from Concesiones.Concesion where ID = @ID_concesion and Fecha_inicio > @Fecha)
            set @error += 'La fecha no puede ser menor al inicio de su concesion' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Concesiones.Pago_mensual set Fecha = @Fecha, Monto = @Monto, Metodo = @Metodo, ID_concesion = @ID_concesion where ID = @ID
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(500) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);
       
        THROW;
    END CATCH;
END;
go

--------------------VENTAS----------------------------
CREATE OR ALTER PROCEDURE Ventas.SP_Cliente_Modificar
(
@ID BIGINT,
@Nombre VARCHAR(100),
@Documento VARCHAR(20),
@Tipo_doc VARCHAR(20),
@Nacimiento DATE
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Cliente
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- El cliente no existe';

IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))=''
SET @Errores += CHAR(13) + '- El nombre es obligatorio';

IF EXISTS
(
SELECT 1
FROM Ventas.Cliente
WHERE Documento=@Documento
AND ID<>@ID
)
SET @Errores += CHAR(13) + '- El documento ya pertenece a otro cliente';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

UPDATE Ventas.Cliente
SET
Nombre=@Nombre,
Documento=@Documento,
Tipo_doc=@Tipo_doc,
Nacimiento=@Nacimiento
WHERE ID=@ID;

PRINT 'Cliente modificado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_TipoVisitante_Modificar
(
@ID BIGINT,
@Nombre VARCHAR(100)
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Tipo_visitante
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- El tipo de visitante no existe';

IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))=''
SET @Errores += CHAR(13) + '- El nombre es obligatorio';

IF EXISTS
(
SELECT 1
FROM Ventas.Tipo_visitante
WHERE Nombre=@Nombre
AND ID<>@ID
)
SET @Errores += CHAR(13) + '- Ya existe otro tipo de visitante con ese nombre';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

UPDATE Ventas.Tipo_visitante
SET Nombre=@Nombre
WHERE ID=@ID;

PRINT 'Tipo de visitante modificado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Tarifa_Modificar
(
@ID BIGINT,
@Fecha_desde DATE,
@Fecha_hasta DATE,
@Precio DECIMAL(11,2)
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Tarifa
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- La tarifa no existe';

IF @Precio <= 0
SET @Errores += CHAR(13) + '- El precio debe ser mayor a cero';

IF @Fecha_hasta < @Fecha_desde
SET @Errores += CHAR(13) + '- Las fechas son inválidas';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

UPDATE Ventas.Tarifa
SET
Fecha_desde=@Fecha_desde,
Fecha_hasta=@Fecha_hasta,
Precio=@Precio
WHERE ID=@ID;

PRINT 'Tarifa modificada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Entrada_Modificar
(
@ID BIGINT,
@Fecha_acceso DATE,
@ID_cliente BIGINT,
@ID_tarifa BIGINT
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Entrada
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- La entrada no existe';

IF @Fecha_acceso < CAST(GETDATE() AS DATE)
SET @Errores += CHAR(13) + '- La fecha de acceso no puede ser anterior a la fecha actual';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Cliente
WHERE ID=@ID_cliente
)
SET @Errores += CHAR(13) + '- El cliente no existe';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Tarifa
WHERE ID=@ID_tarifa
)
SET @Errores += CHAR(13) + '- La tarifa no existe';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END


UPDATE Ventas.Entrada
SET
Fecha_acceso=@Fecha_acceso,
ID_cliente=@ID_cliente,
ID_tarifa=@ID_tarifa
WHERE ID=@ID;

PRINT 'Entrada modificada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Compra_Modificar
(
@ID BIGINT,
@Fecha DATETIME,
@Total DECIMAL(11,2),
@Cantidad INT,
@Punto_venta VARCHAR(100)
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Compra
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- La compra no existe';

IF @Fecha > GETDATE()
SET @Errores += CHAR(13) + '- La fecha de compra no puede ser futura';

IF @Total < 0
SET @Errores += CHAR(13) + '- El total no puede ser negativo';

IF @Cantidad <= 0
SET @Errores += CHAR(13) + '- La cantidad debe ser mayor a cero';

IF @Punto_venta IS NULL
OR LTRIM(RTRIM(@Punto_venta))=''
SET @Errores += CHAR(13) + '- El punto de venta es obligatorio';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

UPDATE Ventas.Compra
SET
Fecha=@Fecha,
Total=@Total,
Cantidad=@Cantidad,
Punto_venta=@Punto_venta
WHERE ID=@ID;

PRINT 'Compra modificada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Pago_Modificar
(
@ID BIGINT,
@Metodo VARCHAR(100),
@Monto DECIMAL(11,2),
@Estado CHAR(1)
)
AS
BEGIN

DECLARE @Errores VARCHAR(MAX)='';

IF NOT EXISTS
(
SELECT 1
FROM Ventas.Pago
WHERE ID=@ID
)
SET @Errores += CHAR(13) + '- El pago no existe';

IF @Metodo IS NULL
OR LTRIM(RTRIM(@Metodo))=''
SET @Errores += CHAR(13) + '- El método de pago es obligatorio';

IF @Monto <= 0
SET @Errores += CHAR(13) + '- El monto debe ser mayor a cero';

IF @Estado NOT IN ('P','A','R')
SET @Errores += CHAR(13) + '- Estado inválido (P=Pendiente, A=Aprobado, R=Rechazado)';

IF @Errores <> ''
BEGIN
THROW 50001, @Errores, 1;
END

UPDATE Ventas.Pago
SET
Metodo=@Metodo,
Monto=@Monto,
Estado=@Estado
WHERE ID=@ID;

PRINT 'Pago modificado correctamente';

END
GO 

--------------------ATRACCIONES-----------------------
