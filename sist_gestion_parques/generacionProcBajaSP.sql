/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script de genaracion de procedure de borrado
*/
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------


--------------------PARQUE-----------------------
CREATE OR ALTER PROCEDURE Parque.SP_TipoParque_Baja @ID INT as 
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
        update Parque.Tipo_parque set Estado = 'i' where ID = @ID --ejemplo dar de baja borrado logico
        COMMIT;
		print 'El tipo de parque fue dado de baja con exito' 
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

CREATE OR ALTER PROCEDURE Parque.SP_Provincia_Baja @ID tinyint as
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
        update Parque.Provincia set Estado = 'i' where ID = @ID
        COMMIT;
		print 'La provincia fue dada de baja con exito' 
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

CREATE OR ALTER PROCEDURE Parque.SP_Parque_Baja @ID INT as
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
        update Parque.Parque set Estado = 'i' where ID = @ID
        COMMIT;
		print 'El parque fue dado de baja con exito' 
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
	
CREATE OR ALTER PROCEDURE Empleados.SP_Guardaparque_Baja
@ID_Empleado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Baja fisica del rol guardaparque. Se bloquea si tiene parques asignados.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Empleado IS NULL
        SET @error += 'El ID_Empleado no puede ser null' + CHAR(10);
    IF @ID_Empleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guardaparque WHERE ID_Empleado = @ID_Empleado)
        SET @error += 'El guardaparque indicado no existe' + CHAR(10);
    IF @ID_Empleado IS NOT NULL AND EXISTS (SELECT 1 FROM Empleados.R_Guardaparque_Parque WHERE ID_Guardaparque = @ID_Empleado)
        SET @error += 'No se puede borrar porque el guardaparque tiene parques asignados' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		update Empleados.Guardaparque set Estado = 'i' where ID_Empleado = @ID_Empleado --ejemplo dar de baja borrado logico

        COMMIT;
        PRINT 'Guardaparque eliminado correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
END;
GO


CREATE OR ALTER PROCEDURE Empleados.SP_GuardaparqueParque_Baja
    @ID_Guardaparque INT,
    @ID_Parque INT,
    @Fecha_ingreso DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Baja de una asignacion puntual identificada por su clave compuesta.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guardaparque IS NULL
        SET @error += 'El ID_Guardaparque no puede ser null' + CHAR(10);
    IF @ID_Parque IS NULL
        SET @error += 'El ID_Parque no puede ser null' + CHAR(10);
    IF @Fecha_ingreso IS NULL
        SET @error += 'La fecha de ingreso no puede ser null' + CHAR(10);
    IF NOT EXISTS (
        SELECT 1
        FROM Empleados.R_Guardaparque_Parque
        WHERE ID_Guardaparque = @ID_Guardaparque
          AND ID_Parque = @ID_Parque
          AND Fecha_ingreso = @Fecha_ingreso
    )
        SET @error += 'La asignacion indicada no existe' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		UPDATE Empleados.R_Guardaparque_Parque SET Estado = 'i'
		WHERE ID_Guardaparque = @ID_Guardaparque
  		AND ID_Parque = @ID_Parque
  		AND Fecha_ingreso = @Fecha_ingreso;
        COMMIT;
        PRINT 'Asignacion de guardaparque al parque eliminada correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
END;
GO

	
CREATE OR ALTER PROCEDURE Empleados.SP_Empleado_Baja @ID INT as --es borrado logico
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
		print 'El empleado fue dado de baja con exito' 
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




CREATE OR ALTER PROCEDURE Empleados.SP_GuiaHabilitacion_Baja
	@ID_Guia INT,
	@ID_Habilitacion INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		IF EXISTS(SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion)
		BEGIN
			DELETE
			FROM Empleados.R_Guia_Habilitacion
			WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion
		END 

		ELSE

		BEGIN
			PRINT('No existe la asignacion de habilitacion')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de asignacion de habilitacion',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Habilitacion_Baja
	@Id INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Id_Guia INT;

		IF EXISTS(SELECT 1 FROM Empleados.Habilitacion WHERE ID = @Id)
		BEGIN
			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Habilitacion = @Id)
			BEGIN
				SELECT TOP 1 @Id_Guia = ID_Guia 
				FROM Empleados.R_Guia_Habilitacion 
				WHERE ID_Habilitacion = @Id

				EXEC Empleados.SP_GuiaHabilitacion_Baja
					@Id_Guia, @Id
			END

			DELETE
			FROM Empleados.Habilitacion
			WHERE ID = @Id
		END 

		ELSE

		BEGIN
			PRINT('No existe la habilitacion')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de habilitacion',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO
CREATE OR ALTER PROCEDURE Empleados.SP_GuiaEspecialidad_Baja
	@ID_Guia INT,
	@ID_Especialidad INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		IF EXISTS(SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad)
		BEGIN
			DELETE
			FROM Empleados.R_Guia_Especialidad
			WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad
		END 

		ELSE

		BEGIN
			PRINT('No existe la asignacion de especialidad')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de asignacion de especialidad',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Especialidad
	@Id INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Id_Guia INT;

		IF EXISTS(SELECT 1 FROM Empleados.Especialidad WHERE ID = @Id)
		BEGIN
			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Especialidad = @Id)
			BEGIN
				SELECT TOP 1 @Id_Guia = ID_Guia 
				FROM Empleados.R_Guia_Especialidad 
				WHERE ID_Especialidad = @Id

				EXEC Empleados.SP_GuiaEspecialidad_Baja
					@Id_Guia, @Id
			END

			DELETE
			FROM Empleados.Especialidad
			WHERE ID = @Id
		END 

		ELSE

		BEGIN
			PRINT('No existe la especialidad')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de especialidad',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

CREATE OR ALTER PROCEDURE Empleados.SP_GuiaTitulo_Baja
	@ID_Guia INT,
	@ID_Titulo INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		IF EXISTS(SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo)
		BEGIN
			DELETE
			FROM Empleados.R_Guia_Titulo
			WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo
		END 

		ELSE

		BEGIN
			PRINT('No existe la asignacion de titulo')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de asignacion de titulo',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Titulo_Baja
	@Id INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Id_Guia INT;

		IF EXISTS(SELECT 1 FROM Empleados.Titulo WHERE ID = @Id)
		BEGIN
			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Titulo = @Id)
			BEGIN
				SELECT TOP 1 @Id_Guia = ID_Guia 
				FROM Empleados.R_Guia_Titulo 
				WHERE ID_Titulo = @Id

				EXEC Empleados.SP_GuiaTitulo_Baja
					@Id_Guia, @Id
			END

			DELETE
			FROM Empleados.Titulo
			WHERE ID = @Id
		END 

		ELSE

		BEGIN
			PRINT('No existe el titulo')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de titulo',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Guia_Baja
	@ID_Empleado INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @Id_Aux INT;

		IF EXISTS(SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Empleado)
		BEGIN
			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Empleado)
			BEGIN
				SELECT TOP 1 @Id_Aux = ID_Habilitacion 
				FROM Empleados.R_Guia_Habilitacion 
				WHERE ID_Guia = @ID_Empleado

				EXEC Empleados.SP_GuiaHabilitacion_Baja
					@ID_Empleado, @Id_Aux
			END

			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Empleado)
			BEGIN
				SELECT TOP 1 @Id_Aux = ID_Especialidad 
				FROM Empleados.R_Guia_Especialidad 
				WHERE ID_Guia = @ID_Empleado

				EXEC Empleados.SP_GuiaEspecialidad_Baja
					@ID_Empleado, @Id_Aux
			END

			WHILE EXISTS(SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Empleado)
			BEGIN
				SELECT TOP 1 @Id_Aux = ID_Titulo 
				FROM Empleados.R_Guia_Titulo 
				WHERE ID_Guia = @ID_Empleado

				EXEC Empleados.SP_GuiaEspecialidad_Baja
					@ID_Empleado, @Id_Aux
			END

			DELETE
			FROM Empleados.Guia
			WHERE ID_Empleado = @ID_Empleado
		END 

		ELSE

		BEGIN
			PRINT('No existe el guia')
			RAISERROR('.',16,1)
		END
	END TRY
	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio algo el borrado de guia',16,1)
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END
			RETURN;
		END
		IF ERROR_SEVERITY() = 10
		BEGIN
			COMMIT TRANSACTION
			RETURN;
		END
	END CATCH
	COMMIT TRANSACTION
END
GO

--------------------CONSECIONES-----------------------
CREATE OR ALTER PROCEDURE Concesiones.SP_TipoActividad_Baja @ID INT as 
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
        update Concesiones.Tipo_actividad set Estado = 'i' where ID = @ID
        COMMIT;
		print 'El tipo de actividad fue dado de baja con exito' 
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

CREATE OR ALTER PROCEDURE Concesiones.SP_Empresa_Baja @ID INT as
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
        update Concesiones.Empresa set Estado = 'i' where ID = @ID 
        COMMIT;
		print 'La empresa fue dada de baja con exito' 
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


CREATE OR ALTER PROCEDURE Concesiones.SP_Concesion_Baja @ID INT as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(500) = ''
        if @ID is null
            set @error += 'El ID no puede ser null' + char(10)
        if not exists(select 1 from Concesiones.Concesion where ID = @ID)
            set @error += 'El ID no existe' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        update Concesiones.Concesion set Estado = 'i' where ID = @ID
		update Concesiones.Pago_mensual set Estado = 'i' where ID_concesion = @ID
        COMMIT;
		print 'La concesion fue dada de baja con exito' 
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

CREATE OR ALTER PROCEDURE Concesiones.SP_PagoMensual_Baja @ID INT as
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
        update Concesiones.Pago_mensual set Estado = 'i' where ID = @ID
        COMMIT;
		print 'El pago mensual fue dado de baja con exito' 
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
CREATE OR ALTER PROCEDURE Ventas.SP_Cliente_Baja
(
	@ID INT
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
	
	IF EXISTS -- no elimina cliente si tiene entrada  
	(
		SELECT 1
		FROM Ventas.Entrada
		WHERE ID_cliente=@ID
	)
	SET @Errores += CHAR(13) + '- El cliente posee entradas asociadas';
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END

    update Ventas.Cliente set Estado = 'i' where ID = @ID

	PRINT 'Cliente eliminado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_TipoVisitante_Baja
(
	@ID INT
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
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Tarifa
		WHERE ID_tipo_visitante=@ID
	)
	SET @Errores += CHAR(13) + '- El tipo de visitante posee tarifas asociadas';
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END

    update Ventas.Tipo_visitante set Estado = 'i' where ID = @ID
		
	
	PRINT 'Tipo de visitante eliminado correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Tarifa_Baja
(
	@ID INT
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
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Entrada
		WHERE ID_tarifa=@ID
	)
	SET @Errores += CHAR(13) + '- La tarifa posee entradas asociadas';
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
		
	update Ventas.Tarifa set Estado = 'i' where ID = @ID

		
	PRINT 'Tarifa eliminada correctamente';

END
GO 


CREATE OR ALTER PROCEDURE Ventas.SP_Entrada_Baja
(
	@ID INT
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
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
    update Ventas.Entrada set Estado = 'i' where ID = @ID

	PRINT 'Entrada eliminada correctamente';

END
GO

CREATE OR ALTER PROCEDURE Ventas.SP_Compra_Baja
(
	@ID INT
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
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Pago
		WHERE ID_compra=@ID
	)
	SET @Errores += CHAR(13) + '- La compra posee un pago asociado';
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Entrada
		WHERE ID_compra=@ID
	)
	SET @Errores += CHAR(13) + '- La compra posee entradas asociadas';
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
	update Ventas.Compra set Estado = 'i' where ID = @ID
	
	PRINT 'Compra eliminada correctamente';

END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Pago_Baja
(
	@ID INT
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
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
		
	update Ventas.Pago set Estado = 'i' where ID = @ID

	PRINT 'Pago eliminado correctamente';

END
GO 

--------------------ATRACCIONES-----------------------
CREATE OR ALTER PROCEDURE Atracciones.SP_Tour_Baja
    @ID_Tour INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Baja fisica del tour. Se bloquea si posee guias o entradas relacionadas.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @ID_Tour)
        SET @error += 'El tour indicado no existe' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND EXISTS (SELECT 1 FROM Atracciones.R_Tour_Guia WHERE ID_Tour = @ID_Tour)
        SET @error += 'No se puede borrar porque el tour tiene guias asignados' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND EXISTS (SELECT 1 FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @ID_Tour)
        SET @error += 'No se puede borrar porque el tour tiene entradas asignadas' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		update Atracciones.Tour set Estado = 'i' where ID_Tour = @ID_Tour --ejemplo dar de baja borrado logico
        COMMIT;
        PRINT 'Tour eliminado correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
END;
GO





CREATE OR ALTER PROCEDURE Atracciones.SP_TourEntrada_Baja
    @ID_Tour INT,
    @ID_Entrada INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Elimina una asignacion puntual entre tour y entrada.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Entrada IS NULL
        SET @error += 'El ID_Entrada no puede ser null' + CHAR(10);
    IF NOT EXISTS (SELECT 1 FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @ID_Tour AND ID_Entrada = @ID_Entrada)
        SET @error += 'La asignacion indicada no existe' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		UPDATE Atracciones.R_Tour_Entrada SET Estado = 'i'
		WHERE ID_Tour = @ID_Tour AND ID_Entrada = @ID_Entrada;

        COMMIT;
        PRINT 'Asignacion de entrada al tour eliminada correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
END;
GO
CREATE OR ALTER PROCEDURE Atracciones.SP_TourGuia_Baja
    @ID_Tour INT,
    @ID_Guia INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Elimina una asignacion puntual entre tour y guia.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF NOT EXISTS (SELECT 1 FROM Atracciones.R_Tour_Guia WHERE ID_Tour = @ID_Tour AND ID_Guia = @ID_Guia)
        SET @error += 'La asignacion indicada no existe' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		UPDATE Atracciones.R_Tour_Guia SET Estado = 'i'
		WHERE ID_Tour = @ID_Tour AND ID_Guia = @ID_Guia;

        COMMIT;
        PRINT 'Asignacion de guia al tour eliminada correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
END;
GO
