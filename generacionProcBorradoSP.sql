
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------

--------------------PARQUE-----------------------
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
--------------------EMPLEADOS-----------------------
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

--------------------CONSECIONES-----------------------
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

--------------------VENTAS----------------------------

--------------------ATRACCIONES-----------------------