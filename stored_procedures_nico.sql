use sist_gestion_parques
go
create or alter procedure AñadirTipo_parque @Nombre varchar(100), @Descripcion varchar(250) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error = @error + 'El nombre no puede ser null' + char(10)
        if @Descripcion is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)
        if exists (select 1 from Parque.Tipo_parque where Nombre = @Nombre)
            set @error += 'El tipo de parque "' + @Nombre +'" ya existe en la tabla' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Parque.Tipo_parque(Nombre, Descripcion) values (@Nombre, @Descripcion)
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(max) = ERROR_MESSAGE();
        DECLARE @Num INT           = ERROR_NUMBER();
        THROW;
    END CATCH;
END;
go

create or alter procedure BorrarTipo_parque @ID bigint as 
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error = @error + 'La ID no puede ser null' + char(10)
        if not exists (select 1 from Parque.Tipo_parque where ID = @ID)
            set @error = @error + 'No existe ID' + char(10)
        if exists (select 1 from Parque.Parque where ID_tipo = @ID)
            set @error = @error + 'No se puede borrar ya que esta siendo usado en la tabla Parque' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Parque.Tipo_parque where ID = @ID
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



create or alter procedure AñadirProvincia @Nombre varchar(100) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if exists (select 1 from Parque.Provincia where Nombre = @Nombre)
            set @error += 'La provincia "' + @Nombre +'" ya existe en la tabla' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Parque.Provincia(Nombre) values (@Nombre)
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

create or alter procedure BorrarProvincia @ID bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Parque.Provincia where ID = @ID)
            set @error += 'No existe ID' + char(10)
        if exists(select 1 from Parque.Parque where ID_provincia = @ID)
            set @error += 'No se puede borrar ya que esta siendo usada en la tabla Parque' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Parque.Provincia where ID = @ID
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



create or alter procedure AñadirParque @Superficie int, @Nombre varchar(100), @ID_tipo bigint, @ID_provincia bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Superficie is null
            set @error += 'La superficie no puede ser null' + char(10)
        if @Superficie <= 0
            set @error += 'La superficie no puede ser <= 0' + char(10)
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @ID_tipo is null
            set @error += 'El ID_tipo no puede ser null' + char(10)
        if not exists (select 1 from Parque.Tipo_parque where ID = @ID_tipo)
            set @error += 'El ID_tipo no existe' + char(10)
        if @ID_provincia is null
            set @error += 'El ID_provincia no puede ser null' + char(10)
        if not exists (select 1 from Parque.Provincia where ID = @ID_provincia)
            set @error += 'El ID_provincia no existe' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Parque.Parque (Superficie, Nombre, ID_tipo, ID_provincia) values (@Superficie, @Nombre, @ID_tipo, @ID_provincia)
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

create or alter procedure BorrarParque @ID bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Parque.Parque where ID = @ID)
            set @error += 'No existe ID' + char(10)
        
        if exists(select 1 from Empleados.Empleado where ID_parque = @ID)
            set @error += 'No se puede borrar ya que esta siendo usado en la tabla Empleado' + char(10)
        if exists(select 1 from Empleados.R_Guardaparque_Parque where ID_parque = @ID)
            set @error += 'No se puede borrar ya que esta siendo usado en la tabla Guardaparque_Parque' + char(10)
        if exists(select 1 from Concesiones.Concesion where ID_parque = @ID)
            set @error += 'No se puede borrar ya que esta siendo usado en la tabla Concesion' + char(10)
        if exists(select 1 from Ventas.Tarifa where ID_parque = @ID)
            set @error += 'No se puede borrar ya que esta siendo usado en la tabla Tarifa' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Parque.Parque where ID = @ID
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




create or alter procedure AñadirEmpleado 
@Nacimiento date,
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
        if exists(select 1 from Empleados.Empleado where DNI = @DNI)
            set @error += 'El DNI "' + @DNI +'" ya esta siendo usado en la tabla' + char(10)
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
        if exists (select 1 from Empleados.Empleado where CUIL = @CUIL)
            set @error += 'El CUIL no puede ser repetido' + char(10)
        if @DNI not like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
            set @error += 'El DNI es invalido' + char(10)
        if @CUIL not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIL es invalido' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Empleados.Empleado(Nacimiento, DNI, CUIL, Nombre, Sueldo, Estado, ID_parque) values (@Nacimiento, @DNI, @CUIL, @Nombre, @Sueldo, @Estado, @ID_parque)
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

create or alter procedure BorrarEmpleado @ID bigint as --es borrado logico
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Empleados.Empleado where ID = @ID)
            set @error += 'No existe ID' + char(10)
        --no importa si esta en guardaparque o guia porque nunca se deberia borrar 100%, solo quedar inactivo
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY   
        update Empleados.Empleado set Estado = 'i' where ID = @ID --borrado logico
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



create or alter procedure AñadirTipo_actividad @Nombre varchar(100), @Descripcion varchar(250) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if exists(select 1 from Concesiones.Tipo_actividad where Nombre = @Nombre)
            set @error += 'El tipo de actividad "' + @Nombre +'" ya existe en la tabla' + char(10)
        if @Descripcion is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Concesiones.Tipo_actividad(Nombre, Descripcion) values (@Nombre, @Descripcion)
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

create or alter procedure BorrarTipo_actividad @ID bigint as 
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error = @error + 'La ID no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Tipo_actividad where ID = @ID)
            set @error = @error + 'No existe ID' + char(10)
        if exists (select 1 from Concesiones.Concesion where ID_tipo = @ID)
            set @error = @error + 'No se puede borrar ya que esta siendo usada en la tabla Concesion' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Concesiones.Tipo_actividad where ID = @ID
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



create or alter procedure AñadirEmpresa 
@Nombre varchar(100),
@CUIT varchar(13),
@Correo varchar(100) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @CUIT is null
            set @error += 'El CUIT no puede ser null' + char(10)
        if exists(select 1 from Concesiones.Empresa where CUIT = @CUIT)
            set @error += 'El CUIT "' + @CUIT + '" ya esta siendo usado en la tabla' + char(10)
        if @Correo is null
            set @error += 'El correo no puede ser null' + char(10)
        if @CUIT not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIT es invalido' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Concesiones.Empresa(Nombre, CUIT, Correo) values (@Nombre, @CUIT, @Correo)

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

--el borrado lo hago pero igual nunca se deberia usar ya que concesiones guarda el historico asi que nunca vas a poder borrar una empresa
--que fue parte de una concesion pero bueno

create or alter procedure BorrarEmpresa @ID bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' +char(10)
        if not exists(select 1 from Concesiones.Empresa where ID = @ID)
            set @error += 'No existe ID' + char(10)
        if exists (select 1 from Concesiones.Concesion where ID_empresa = @ID)
            set @error += 'No se puede borrar ya que esta siendo usada en la tabla Concesion' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        Delete from Concesiones.Empresa where ID = @ID 
        --esto nunca se deberia ejecutar en teoria, salvo que haya una empresa sin concesion
        --aunque en ese caso, porque estaria en la base?
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

-----no son mios de aca a abajo pero creo q quedaron en el aire asi que los hice-----------

create or alter procedure AñadirConcesion 
        @Fecha_inicio DATE,
		@Fecha_fin DATE,
		@ID_empresa BIGINT,
		@ID_tipo BIGINT,
		@ID_parque BIGINT as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
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
        insert into Concesiones.Concesion(Fecha_inicio, Fecha_fin, ID_empresa, ID_tipo, ID_parque) values (@Fecha_inicio, @Fecha_fin, @ID_empresa, @ID_tipo, @ID_parque)
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

--una concesion nunca se puede borrar, ya que deberia quedar el historico pero igual lo hago x las dudas
create or alter procedure BorrarConcesion @ID bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(500) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Concesiones.Concesion where ID = @ID)
            set @error += 'El ID no existe' + char(10)
        if exists(select 1 from Concesiones.Pago_mensual where ID_concesion = @ID)
            set @error += 'El ID esta siendo usado en la tabla Pago_mensual' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Concesiones.Concesion where ID = @ID
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



create or alter procedure AñadirPago_mensual 
        @Fecha DATE,
		@Monto DECIMAL(11,2),
		@Metodo VARCHAR(100),
		@ID_concesion BIGINT as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(500) = ''
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
            set @Fecha = EOMONTH(GETDATE())
        if exists (select 1 from Concesiones.Concesion where ID = @ID_concesion and Fecha_inicio > @Fecha)
            set @error += 'La fecha no puede ser menor al inicio de su concesion' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        insert into Concesiones.Pago_mensual(Fecha, Monto, Metodo, ID_concesion) values (@Fecha, @Monto, @Metodo, @ID_concesion)
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

--un pago tampoco se deberia poder borrar pero la hago igual
create or alter procedure BorrarPago_mensual @ID bigint as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(500) = ''
        if @ID is null
            set @error += 'El ID no puede ser null'
        if not exists (select 1 from Concesiones.Pago_mensual where ID = @ID)
            set @error += 'El ID es invalido' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        delete from Concesiones.Pago_mensual where ID = @ID
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