/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script de genaracion de procedure de modificacion
*/
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

CREATE OR ALTER PROCEDURE ModificarGuardaparque
    @ID_Empleado BIGINT,
    @NuevoID_Empleado BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Se valida la clave actual y la nueva clave antes de modificar la relacion.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Empleado IS NULL
        SET @error += 'El ID_Empleado no puede ser null' + CHAR(10);
    IF @NuevoID_Empleado IS NULL
        SET @error += 'El nuevo ID_Empleado no puede ser null' + CHAR(10);
    IF @ID_Empleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guardaparque WHERE ID_Empleado = @ID_Empleado)
        SET @error += 'El guardaparque indicado no existe' + CHAR(10);
    IF @NuevoID_Empleado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Empleado WHERE ID = @NuevoID_Empleado)
        SET @error += 'El nuevo empleado indicado no existe' + CHAR(10);
    IF @NuevoID_Empleado IS NOT NULL AND @NuevoID_Empleado <> @ID_Empleado AND EXISTS (SELECT 1 FROM Empleados.Guardaparque WHERE ID_Empleado = @NuevoID_Empleado)
        SET @error += 'El nuevo empleado indicado ya esta registrado como guardaparque' + CHAR(10);
    IF @NuevoID_Empleado IS NOT NULL AND @NuevoID_Empleado <> @ID_Empleado AND EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @NuevoID_Empleado)
        SET @error += 'El nuevo empleado indicado ya esta registrado como guia' + CHAR(10);
    -- No se permite cambiar la PK si ya esta referenciada por asignaciones a parques.
    IF @ID_Empleado IS NOT NULL AND @NuevoID_Empleado <> @ID_Empleado AND EXISTS (SELECT 1 FROM Empleados.R_Guardaparque_Parque WHERE ID_Guardaparque = @ID_Empleado)
        SET @error += 'No se puede cambiar el empleado porque el guardaparque tiene parques asignados' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Empleados.Guardaparque
        SET ID_Empleado = @NuevoID_Empleado
        WHERE ID_Empleado = @ID_Empleado;

        COMMIT;
        PRINT 'Guardaparque modificado correctamente';
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


CREATE OR ALTER PROCEDURE ModificarR_Guardaparque_Parque
    @ID_Guardaparque BIGINT,
    @ID_Parque BIGINT,
    @Fecha_ingreso DATE,
    @NuevoID_Guardaparque BIGINT,
    @NuevoID_Parque BIGINT,
    @NuevaFecha_ingreso DATE,
    @NuevaFecha_egreso DATE = NULL,
    @NuevoMotivo_egreso VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Modificacion de una relacion con clave compuesta.
    -- Se reciben los datos originales para ubicar el registro y los nuevos para actualizarlo.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guardaparque IS NULL
        SET @error += 'El ID_Guardaparque no puede ser null' + CHAR(10);
    IF @ID_Parque IS NULL
        SET @error += 'El ID_Parque no puede ser null' + CHAR(10);
    IF @Fecha_ingreso IS NULL
        SET @error += 'La fecha de ingreso original no puede ser null' + CHAR(10);
    IF @NuevoID_Guardaparque IS NULL
        SET @error += 'El nuevo ID_Guardaparque no puede ser null' + CHAR(10);
    IF @NuevoID_Parque IS NULL
        SET @error += 'El nuevo ID_Parque no puede ser null' + CHAR(10);
    IF @NuevaFecha_ingreso IS NULL
        SET @error += 'La nueva fecha de ingreso no puede ser null' + CHAR(10);
    IF NOT EXISTS (
        SELECT 1
        FROM Empleados.R_Guardaparque_Parque
        WHERE ID_Guardaparque = @ID_Guardaparque
          AND ID_Parque = @ID_Parque
          AND Fecha_ingreso = @Fecha_ingreso
    )
        SET @error += 'La asignacion original no existe' + CHAR(10);
    IF @NuevoID_Guardaparque IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guardaparque WHERE ID_Empleado = @NuevoID_Guardaparque)
        SET @error += 'El nuevo guardaparque indicado no existe' + CHAR(10);
    IF @NuevoID_Parque IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Parque.Parque WHERE ID = @NuevoID_Parque)
        SET @error += 'El nuevo parque indicado no existe' + CHAR(10);
    IF @NuevaFecha_egreso IS NOT NULL AND @NuevaFecha_ingreso IS NOT NULL AND @NuevaFecha_egreso < @NuevaFecha_ingreso
        SET @error += 'La nueva fecha de egreso no puede ser anterior a la nueva fecha de ingreso' + CHAR(10);
    IF (@NuevaFecha_egreso IS NULL AND @NuevoMotivo_egreso IS NOT NULL) OR (@NuevaFecha_egreso IS NOT NULL AND (@NuevoMotivo_egreso IS NULL OR LTRIM(RTRIM(@NuevoMotivo_egreso)) = ''))
        SET @error += 'Debe informar fecha y motivo de egreso juntos, o dejar ambos vacios' + CHAR(10);
    -- Evita duplicar la clave compuesta al cambiar los datos identificatorios.
    IF EXISTS (
        SELECT 1
        FROM Empleados.R_Guardaparque_Parque
        WHERE ID_Guardaparque = @NuevoID_Guardaparque
          AND ID_Parque = @NuevoID_Parque
          AND Fecha_ingreso = @NuevaFecha_ingreso
          AND NOT (ID_Guardaparque = @ID_Guardaparque AND ID_Parque = @ID_Parque AND Fecha_ingreso = @Fecha_ingreso)
    )
        SET @error += 'Ya existe otra asignacion con esos nuevos datos' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Empleados.R_Guardaparque_Parque
        SET ID_Guardaparque = @NuevoID_Guardaparque,
            ID_Parque = @NuevoID_Parque,
            Fecha_ingreso = @NuevaFecha_ingreso,
            Fecha_egreso = @NuevaFecha_egreso,
            Motivo_egreso = @NuevoMotivo_egreso
        WHERE ID_Guardaparque = @ID_Guardaparque
          AND ID_Parque = @ID_Parque
          AND Fecha_ingreso = @Fecha_ingreso;

        COMMIT;
        PRINT 'Asignacion de guardaparque al parque modificada correctamente';
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

CREATE OR ALTER PROCEDURE Empleados.Modificar_Guia
	@ID_Empleado BIGINT
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Id_Validacion BIGINT;

		SELECT @Id_Validacion = ID_Empleado
		FROM Empleados.Guia
		WHERE ID_Empleado = @ID_Empleado;

		IF @Id_Validacion IS NULL
		BEGIN
			PRINT('No existe un guia con el ID proporcionado.');
			RETURN;
		END

		-- Nota: la tabla guia funciona como una extension de empleado 
		-- y contiene unicamente el ID_Empleado como clave primaria y foranea, 
		-- no posee columnas propias adicionales que admitan modificacion por ahora.

		PRINT('Guia verificado correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar el guia.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO
CREATE OR ALTER PROCEDURE Empleados.Modificar_Habilitacion
	@ID BIGINT,
	@Detalles VARCHAR(100) = NULL,
	@Fecha DATE = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Actual_Detalles VARCHAR(100);
		DECLARE @Actual_Fecha DATE;

		SELECT 
			@Actual_Detalles = Detalles,
			@Actual_Fecha = Fecha
		FROM Empleados.Habilitacion 
		WHERE ID = @ID;

		IF @Actual_Detalles IS NULL
		BEGIN
			PRINT('No existe una habilitacion con el ID proporcionado.');
			RETURN;
		END

		IF @Detalles IS NOT NULL AND @Detalles <> ''
		BEGIN
			SET @Detalles = TRIM(@Detalles);
			
			IF LEN(@Detalles) > 100
			BEGIN
				PRINT('Los detalles superan el maximo permitido de 100 caracteres.');
				RAISERROR('.', 16, 1);
			END

			IF @Detalles <> @Actual_Detalles
			BEGIN
				UPDATE Empleados.Habilitacion
				SET Detalles = @Detalles
				WHERE ID = @ID;
			END
		END

		IF @Fecha IS NOT NULL
		BEGIN
			IF @Fecha > GETDATE()
			BEGIN
				PRINT('La fecha de habilitacion no es valida.');
				RAISERROR('.', 16, 1);
			END

			IF @Fecha <> @Actual_Fecha
			BEGIN
				UPDATE Empleados.Habilitacion
				SET Fecha = @Fecha
				WHERE ID = @ID;
			END
		END

		PRINT('Habilitacion actualizada correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar la habilitacion.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE Empleados.Modificar_Especialidad
	@ID BIGINT,
	@Nombre VARCHAR(100) = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Actual_Nombre VARCHAR(100);

		SELECT @Actual_Nombre = Nombre
		FROM Empleados.Especialidad 
		WHERE ID = @ID;

		IF @Actual_Nombre IS NULL
		BEGIN
			PRINT('No existe una especialidad con el ID proporcionado.');
			RETURN;
		END

		IF @Nombre IS NOT NULL AND @Nombre <> ''
		BEGIN
			SET @Nombre = TRIM(@Nombre);
			
			IF LEN(@Nombre) > 100
			BEGIN
				PRINT('El nombre supera el maximo permitido de 100 caracteres.');
				RAISERROR('.', 16, 1);
			END

			IF @Nombre LIKE '%[^a-zA-Z ]%'
			BEGIN
				PRINT('El nombre de la especialidad no es valido.');
				RAISERROR('.', 16, 1);
			END

			IF @Nombre <> @Actual_Nombre
			BEGIN
				IF EXISTS (
					SELECT 1 FROM Empleados.Especialidad 
					WHERE Nombre = @Nombre AND ID <> @ID
				)
				BEGIN
					PRINT('Ya existe otra especialidad con el nombre ingresado.');
					RAISERROR('.', 16, 1);
				END

				UPDATE Empleados.Especialidad
				SET Nombre = @Nombre
				WHERE ID = @ID;
			END
		END

		PRINT('Especialidad actualizada correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar la especialidad.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE Empleados.Modificar_Titulo
	@ID BIGINT,
	@Nombre VARCHAR(100) = NULL,
	@Fecha DATE = NULL,
	@Origen VARCHAR(100) = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Actual_Nombre VARCHAR(100);
		DECLARE @Actual_Fecha DATE;
		DECLARE @Actual_Origen VARCHAR(100);

		SELECT 
			@Actual_Nombre = Nombre,
			@Actual_Fecha = Fecha,
			@Actual_Origen = Origen
		FROM Empleados.Titulo 
		WHERE ID = @ID;

		IF @Actual_Nombre IS NULL
		BEGIN
			PRINT('No existe un titulo con el ID proporcionado.');
			RETURN;
		END

		IF @Nombre IS NOT NULL AND @Nombre <> ''
		BEGIN
			SET @Nombre = TRIM(@Nombre);
			
			IF LEN(@Nombre) > 100
			BEGIN
				PRINT('El nombre supera el maximo permitido de 100 caracteres.');
				RAISERROR('.', 16, 1);
			END

			IF @Nombre LIKE '%[^a-zA-Z ]%'
			BEGIN
				PRINT('El nombre del titulo no es valido.');
				RAISERROR('.', 16, 1);
			END

			IF @Nombre <> @Actual_Nombre
			BEGIN
				UPDATE Empleados.Titulo
				SET Nombre = @Nombre
				WHERE ID = @ID;
			END
		END

		IF @Origen IS NOT NULL AND @Origen <> ''
		BEGIN
			SET @Origen = TRIM(@Origen);
			
			IF LEN(@Origen) > 100
			BEGIN
				PRINT('El origen supera el maximo permitido de 100 caracteres.');
				RAISERROR('.', 16, 1);
			END

			IF @Origen LIKE '%[^a-zA-Z ]%'
			BEGIN
				PRINT('El origen del titulo no es valido.');
				RAISERROR('.', 16, 1);
			END

			IF @Origen <> @Actual_Origen
			BEGIN
				UPDATE Empleados.Titulo
				SET Origen = @Origen
				WHERE ID = @ID;
			END
		END

		IF @Fecha IS NOT NULL
		BEGIN
			IF @Fecha > GETDATE()
			BEGIN
				PRINT('La fecha del titulo no es valida.');
				RAISERROR('.', 16, 1);
			END

			IF @Fecha <> @Actual_Fecha
			BEGIN
				UPDATE Empleados.Titulo
				SET Fecha = @Fecha
				WHERE ID = @ID;
			END
		END

		PRINT('Titulo actualizado correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar el titulo.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO
--Las tablas de relacion solo tienen de campo los claves de las tablas que unen
--funciones de modificacion son redundantes, pero fueron realizadas en caso de 
--que se decida añadir algun atributo a futuro.
CREATE OR ALTER PROCEDURE Empleados.Modificar_R_Guia_Habilitacion
	@ID_Guia BIGINT,
	@ID_Habilitacion BIGINT = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Id_Validacion BIGINT;

		SELECT TOP 1 @Id_Validacion = ID_Guia
		FROM Empleados.R_Guia_Habilitacion
		WHERE ID_Guia = @ID_Guia;

		IF @Id_Validacion IS NULL
		BEGIN
			PRINT('No existe una asignacion con el Id proporcionado.');
			RETURN;
		END

		IF @ID_Habilitacion IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Empleados.Habilitacion WHERE ID = @ID_Habilitacion)
			BEGIN
				PRINT('La habilitacion no es valida');
				RAISERROR('.', 16, 1);
			END

			UPDATE Empleados.R_Guia_Habilitacion
			SET ID_Habilitacion = @ID_Habilitacion
			WHERE ID_Guia = @ID_Guia;
		END

		PRINT('Asignacion modificada correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar la asignacion.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE Empleados.Modificar_R_Guia_Especialidad
	@ID_Guia BIGINT,
	@ID_Especialidad BIGINT = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Id_Validacion BIGINT;

		SELECT TOP 1 @Id_Validacion = ID_Guia
		FROM Empleados.R_Guia_Especialidad
		WHERE ID_Guia = @ID_Guia;

		IF @Id_Validacion IS NULL
		BEGIN
			PRINT('No existe una asignacion con el Id proporcionado.');
			RETURN;
		END

		IF @ID_Especialidad IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Empleados.Especialidad WHERE ID = @ID_Especialidad)
			BEGIN
				PRINT('La especialidad no es valida');
				RAISERROR('.', 16, 1);
			END

			UPDATE Empleados.R_Guia_Especialidad
			SET ID_Especialidad = @ID_Especialidad
			WHERE ID_Guia = @ID_Guia;
		END

		PRINT('Asignacion modificada correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar la asignacion.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE Empleados.Modificar_R_Guia_Titulo
	@ID_Guia BIGINT,
	@ID_Titulo BIGINT = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @Id_Validacion BIGINT;

		SELECT TOP 1 @Id_Validacion = ID_Guia
		FROM Empleados.R_Guia_Titulo
		WHERE ID_Guia = @ID_Guia;

		IF @Id_Validacion IS NULL
		BEGIN
			PRINT('No existe una asignacion con el Id proporcionado.');
			RETURN;
		END

		IF @ID_Titulo IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Empleados.Titulo WHERE ID = @ID_Titulo)
			BEGIN
				PRINT('El titulo no es valido');
				RAISERROR('.', 16, 1);
			END

			UPDATE Empleados.R_Guia_Titulo
			SET ID_Titulo = @ID_Titulo
			WHERE ID_Guia = @ID_Guia;
		END

		PRINT('Asignacion modificada correctamente.');
	END TRY

	BEGIN CATCH
		IF ERROR_SEVERITY() > 10
		BEGIN
			RAISERROR('Ocurrio un error al modificar la asignacion.', 16, 1);
			RETURN;
		END
	END CATCH
END
GO
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

CREATE OR ALTER PROCEDURE ModificarTour
    @ID_Tour BIGINT,
    @Costo DECIMAL(11,2),
    @Cupo_max INT,
    @Tipo CHAR(1),
    @Duracion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Modifica los datos principales del tour.
    -- Tambien controla que el nuevo cupo no quede por debajo de las entradas ya asignadas.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @ID_Tour)
        SET @error += 'El tour indicado no existe' + CHAR(10);
    IF @Costo IS NULL
        SET @error += 'El costo no puede ser null' + CHAR(10);
    IF @Costo IS NOT NULL AND @Costo < 0
        SET @error += 'El costo no puede ser menor a 0' + CHAR(10);
    IF @Cupo_max IS NULL
        SET @error += 'El cupo maximo no puede ser null' + CHAR(10);
    IF @Cupo_max IS NOT NULL AND @Cupo_max <= 0
        SET @error += 'El cupo maximo debe ser mayor a 0' + CHAR(10);
    -- Regla de negocio: no bajar el cupo por debajo de la cantidad ya reservada.
    IF @ID_Tour IS NOT NULL AND @Cupo_max IS NOT NULL AND @Cupo_max < (SELECT COUNT(*) FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @ID_Tour)
        SET @error += 'El cupo maximo no puede ser menor a la cantidad de entradas ya asignadas al tour' + CHAR(10);
    IF @Tipo IS NULL OR LTRIM(RTRIM(@Tipo)) = ''
        SET @error += 'El tipo no puede ser null ni vacio' + CHAR(10);
    IF @Duracion IS NULL
        SET @error += 'La duracion no puede ser null' + CHAR(10);
    IF @Duracion IS NOT NULL AND @Duracion <= 0
        SET @error += 'La duracion debe ser mayor a 0' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Atracciones.Tour
        SET Costo = @Costo,
            Cupo_max = @Cupo_max,
            Tipo = @Tipo,
            Duracion = @Duracion
        WHERE ID_Tour = @ID_Tour;

        COMMIT;
        PRINT 'Tour modificado correctamente';
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


CREATE OR ALTER PROCEDURE ModificarR_Tour_Guia
    @ID_Tour BIGINT,
    @ID_Guia BIGINT,
    @NuevoID_Tour BIGINT,
    @NuevoID_Guia BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Modifica una asignacion tour-guia identificada por clave compuesta.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF @NuevoID_Tour IS NULL
        SET @error += 'El nuevo ID_Tour no puede ser null' + CHAR(10);
    IF @NuevoID_Guia IS NULL
        SET @error += 'El nuevo ID_Guia no puede ser null' + CHAR(10);
    IF NOT EXISTS (SELECT 1 FROM Atracciones.R_Tour_Guia WHERE ID_Tour = @ID_Tour AND ID_Guia = @ID_Guia)
        SET @error += 'La asignacion original de guia al tour no existe' + CHAR(10);
    IF @NuevoID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @NuevoID_Tour)
        SET @error += 'El nuevo tour indicado no existe' + CHAR(10);
    IF @NuevoID_Guia IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @NuevoID_Guia)
        SET @error += 'El nuevo guia indicado no existe' + CHAR(10);
    -- Evita que la modificacion genere una relacion duplicada.
    IF EXISTS (
        SELECT 1
        FROM Atracciones.R_Tour_Guia
        WHERE ID_Tour = @NuevoID_Tour
          AND ID_Guia = @NuevoID_Guia
          AND NOT (ID_Tour = @ID_Tour AND ID_Guia = @ID_Guia)
    )
        SET @error += 'Ya existe otra asignacion con esos nuevos datos' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Atracciones.R_Tour_Guia
        SET ID_Tour = @NuevoID_Tour,
            ID_Guia = @NuevoID_Guia
        WHERE ID_Tour = @ID_Tour
          AND ID_Guia = @ID_Guia;

        COMMIT;
        PRINT 'Asignacion de guia al tour modificada correctamente';
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


CREATE OR ALTER PROCEDURE ModificarR_Tour_Entrada
    @ID_Tour BIGINT,
    @ID_Entrada BIGINT,
    @NuevoID_Tour BIGINT,
    @NuevoID_Entrada BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Modifica una asignacion tour-entrada identificada por clave compuesta.
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Entrada IS NULL
        SET @error += 'El ID_Entrada no puede ser null' + CHAR(10);
    IF @NuevoID_Tour IS NULL
        SET @error += 'El nuevo ID_Tour no puede ser null' + CHAR(10);
    IF @NuevoID_Entrada IS NULL
        SET @error += 'El nuevo ID_Entrada no puede ser null' + CHAR(10);
    IF NOT EXISTS (SELECT 1 FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @ID_Tour AND ID_Entrada = @ID_Entrada)
        SET @error += 'La asignacion original de entrada al tour no existe' + CHAR(10);
    IF @NuevoID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @NuevoID_Tour)
        SET @error += 'El nuevo tour indicado no existe' + CHAR(10);
    IF @NuevoID_Entrada IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Ventas.Entrada WHERE ID = @NuevoID_Entrada)
        SET @error += 'La nueva entrada indicada no existe' + CHAR(10);
    IF EXISTS (
        SELECT 1
        FROM Atracciones.R_Tour_Entrada
        WHERE ID_Tour = @NuevoID_Tour
          AND ID_Entrada = @NuevoID_Entrada
          AND NOT (ID_Tour = @ID_Tour AND ID_Entrada = @ID_Entrada)
    )
        SET @error += 'Ya existe otra asignacion con esos nuevos datos' + CHAR(10);
    -- Si se mueve la entrada a otro tour, tambien se verifica el cupo del nuevo tour.
    IF @NuevoID_Tour IS NOT NULL AND @NuevoID_Tour <> @ID_Tour AND EXISTS (
        SELECT 1
        FROM Atracciones.Tour
        WHERE ID_Tour = @NuevoID_Tour
          AND Cupo_max <= (SELECT COUNT(*) FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @NuevoID_Tour)
    )
        SET @error += 'El nuevo tour ya alcanzo su cupo maximo' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Atracciones.R_Tour_Entrada
        SET ID_Tour = @NuevoID_Tour,
            ID_Entrada = @NuevoID_Entrada
        WHERE ID_Tour = @ID_Tour
          AND ID_Entrada = @ID_Entrada;

        COMMIT;
        PRINT 'Asignacion de entrada al tour modificada correctamente';
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
