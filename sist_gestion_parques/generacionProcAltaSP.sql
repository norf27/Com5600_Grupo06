/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Script de genaracion de procedure de agregado
*/
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------
--siempre se da de alta con estado activo la tabla
--verificar si ya existe pero con estado = 'i', entonces cambiar a 'a'


--------------------PARQUE-----------------------
CREATE OR ALTER PROCEDURE Parque.SP_TipoParque_Alta @Nombre varchar(100), @Descripcion varchar(250)as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error = @error + 'El nombre no puede ser null' + char(10)
        if @Descripcion is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)

        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Parque.Tipo_parque where Nombre = @Nombre

        if @ID is not null and @Estado = 'A'
            set @error += 'El tipo de parque "' + @Nombre +'" ya existe en la tabla' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Parque.Tipo_parque set Estado = 'a', Descripcion = @Descripcion where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Parque.Tipo_parque(Nombre, Descripcion) values (@Nombre, @Descripcion)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente el tipo de parque "' + @Nombre +'"'
        RETURN @ret
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
CREATE OR ALTER PROCEDURE Parque.SP_Provincia_Alta @Nombre varchar(100)as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)

        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Parque.Provincia where Nombre = @Nombre

        if @ID is not null and @Estado = 'A'
            set @error += 'La provincia "' + @Nombre +'" ya existe en la tabla' + char(10)
        

        if @error != ''
            throw 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Parque.Provincia set Estado = 'a' where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Parque.Provincia(Nombre) values (@Nombre)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente la provincia "' + @Nombre +'"'
        RETURN @ret
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
CREATE OR ALTER PROCEDURE Parque.SP_Parque_Alta @Superficie DECIMAL(12,2), @Nombre varchar(100), @ID_tipo int, @ID_provincia tinyint, @Anio_Creacion int = null,
@Ambiente_Ecoregion VARCHAR(255) = null, @Fecha_Ultima_Actualizacion date as
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
            set @error += 'El ID_tipo no puede ser null para altas manuales de usuario' + char(10)
        if not exists (select 1 from Parque.Tipo_parque where ID = @ID_tipo and Estado = 'A')
            set @error += 'El ID_tipo no existe' + char(10)
        if @ID_provincia is null
            set @error += 'El ID_provincia no puede ser null' + char(10)
        if not exists (select 1 from Parque.Provincia where ID = @ID_provincia and Estado = 'A')
            set @error += 'El ID_provincia no existe' + char(10)
		if @Fecha_Ultima_Actualizacion is null
    		set @Fecha_Ultima_Actualizacion = getdate()
		
        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Parque.Parque where Nombre = @Nombre

        if @ID is not null and @Estado = 'A'
            set @error += 'El Parque de nombre "' + @Nombre + '" ya existe' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
    declare @ret int
    if @ID is not null
    begin
        update Parque.Parque set Superficie = @Superficie, Nombre = @Nombre, ID_tipo = @ID_tipo, ID_provincia = @ID_provincia, Estado = 'A',
        Anio_Creacion = @Anio_Creacion, Ambiente_Ecoregion = @Ambiente_Ecoregion, Fecha_Ultima_Actualizacion = @Fecha_Ultima_Actualizacion
        where ID = @ID
        set @ret = @ID
    end
    else
    begin
        insert into Parque.Parque (Superficie, Nombre, ID_tipo, ID_provincia, Anio_Creacion, Ambiente_Ecoregion, Fecha_Ultima_Actualizacion) values (@Superficie, @Nombre, @ID_tipo, @ID_provincia, @Anio_Creacion, @Ambiente_Ecoregion, @Fecha_Ultima_Actualizacion)
        set @ret = SCOPE_IDENTITY()
    end
    COMMIT;
    print 'se inserto correctamente el parque "' + @Nombre +'"'
    RETURN @ret

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
CREATE OR ALTER PROCEDURE Empleados.SP_Guardaparque_Alta
    @ID_Empleado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable utilizada para acumular mensajes de validacion.
    DECLARE @error VARCHAR(MAX) = '';

    -- Variable para conocer si el guardaparque ya existe
    -- y si se encuentra activo o inactivo.
    DECLARE @Estado CHAR(1);

    -- Busca el estado actual del guardaparque.
    SELECT @Estado = Estado
    FROM Empleados.Guardaparque
    WHERE ID_Empleado = @ID_Empleado;

    ------------------------------------------------------------------
    -- VALIDACIONES
    ------------------------------------------------------------------

    -- Verifica que se haya informado un empleado.
    IF @ID_Empleado IS NULL
        SET @error += 'El ID_Empleado no puede ser null' + CHAR(10);

    -- Verifica que el empleado exista.
    IF @ID_Empleado IS NOT NULL
       AND NOT EXISTS (
            SELECT 1
            FROM Empleados.Empleado
            WHERE ID = @ID_Empleado
       )
        SET @error += 'El empleado indicado no existe' + CHAR(10);

    -- Impide que una misma persona sea guia y guardaparque a la vez.
    IF @ID_Empleado IS NOT NULL
       AND EXISTS (
            SELECT 1
            FROM Empleados.Guia
            WHERE ID_Empleado = @ID_Empleado
              AND Estado = 'A'
       )
        SET @error += 'El empleado indicado ya esta registrado como guia' + CHAR(10);

    -- Verifica si ya existe un guardaparque activo.
    IF @Estado = 'A'
        SET @error += 'El empleado indicado ya esta registrado como guardaparque' + CHAR(10);

    -- Si hubo errores se cancela la operacion.
    IF @error <> ''
        THROW 50001, @error, 1;

    ------------------------------------------------------------------
    -- TRANSACCION
    ------------------------------------------------------------------

    BEGIN TRANSACTION;

    BEGIN TRY

        -- Si existe pero fue dado de baja logicamente,
        -- se reactiva el registro.
        IF @Estado = 'I'
        BEGIN
            UPDATE Empleados.Guardaparque
            SET Estado = 'A'
            WHERE ID_Empleado = @ID_Empleado;
        END

        -- Si no existe, se crea un nuevo registro.
        ELSE
        BEGIN
            INSERT INTO Empleados.Guardaparque
            (
                ID_Empleado
            )
            VALUES
            (
                @ID_Empleado
            );
        END

        COMMIT;

        PRINT 'Guardaparque registrado correctamente';

    END TRY
    BEGIN CATCH

        -- Ante cualquier error se deshacen los cambios.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();

        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;

    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE Empleados.SP_GuardaparqueParque_Alta
    @ID_Guardaparque INT,
    @ID_Parque INT,
    @Fecha_ingreso DATE,
    @Fecha_egreso DATE = NULL,
    @Motivo_egreso VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @error VARCHAR(MAX) = '';
    DECLARE @Estado CHAR(1);

    SELECT @Estado = Estado
    FROM Empleados.R_Guardaparque_Parque
    WHERE ID_Guardaparque = @ID_Guardaparque
      AND ID_Parque = @ID_Parque
      AND Fecha_ingreso = @Fecha_ingreso;

    IF @ID_Guardaparque IS NULL
        SET @error += 'El ID_Guardaparque no puede ser null' + CHAR(10);

    IF @ID_Parque IS NULL
        SET @error += 'El ID_Parque no puede ser null' + CHAR(10);

    IF @Fecha_ingreso IS NULL
        SET @error += 'La fecha de ingreso no puede ser null' + CHAR(10);

    IF @ID_Guardaparque IS NOT NULL
       AND NOT EXISTS (
            SELECT 1
            FROM Empleados.Guardaparque
            WHERE ID_Empleado = @ID_Guardaparque
              AND Estado = 'A'
       )
        SET @error += 'El guardaparque indicado no existe' + CHAR(10);

    IF @ID_Parque IS NOT NULL
       AND NOT EXISTS (
            SELECT 1
            FROM Parque.Parque
            WHERE ID = @ID_Parque
              AND Estado = 'A'
       )
        SET @error += 'El parque indicado no existe' + CHAR(10);

    IF @Fecha_egreso IS NOT NULL
       AND @Fecha_ingreso IS NOT NULL
       AND @Fecha_egreso < @Fecha_ingreso
        SET @error += 'La fecha de egreso no puede ser anterior a la fecha de ingreso' + CHAR(10);

    IF (@Fecha_egreso IS NULL AND @Motivo_egreso IS NOT NULL)
       OR
       (@Fecha_egreso IS NOT NULL
        AND (@Motivo_egreso IS NULL OR LTRIM(RTRIM(@Motivo_egreso)) = ''))
        SET @error += 'Debe informar fecha y motivo de egreso juntos, o dejar ambos vacios' + CHAR(10);

    IF @Estado = 'A'
        SET @error += 'Ya existe esa asignacion de guardaparque al parque' + CHAR(10);

    IF EXISTS (
        SELECT 1
        FROM Empleados.R_Guardaparque_Parque
        WHERE ID_Guardaparque = @ID_Guardaparque
          AND Estado = 'A'
          AND (
                (@Fecha_ingreso >= Fecha_ingreso
                    AND (@Fecha_ingreso <= Fecha_egreso OR Fecha_egreso IS NULL))
                OR
                (@Fecha_egreso IS NOT NULL
                    AND @Fecha_egreso >= Fecha_ingreso
                    AND (@Fecha_egreso <= Fecha_egreso OR Fecha_egreso IS NULL))
                OR
                (@Fecha_ingreso <= Fecha_ingreso
                    AND (
                        @Fecha_egreso >= Fecha_egreso
                        OR (@Fecha_egreso IS NULL AND Fecha_egreso IS NOT NULL)
                    ))
              )
    )
        SET @error += 'El guardaparque ya tiene una asignacion activa o superpuesta en ese rango de fechas.' + CHAR(10);

    IF @error <> ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;

    BEGIN TRY

        IF @Estado = 'I'
        BEGIN
            UPDATE Empleados.R_Guardaparque_Parque
            SET Estado = 'A',
                Fecha_egreso = @Fecha_egreso,
                Motivo_egreso = @Motivo_egreso
            WHERE ID_Guardaparque = @ID_Guardaparque
              AND ID_Parque = @ID_Parque
              AND Fecha_ingreso = @Fecha_ingreso;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.R_Guardaparque_Parque
            (
                ID_Guardaparque,
                ID_Parque,
                Fecha_ingreso,
                Fecha_egreso,
                Motivo_egreso
            )
            VALUES
            (
                @ID_Guardaparque,
                @ID_Parque,
                @Fecha_ingreso,
                @Fecha_egreso,
                @Motivo_egreso
            );
        END

        COMMIT;

        PRINT 'Asignacion de guardaparque al parque registrada correctamente';

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


CREATE OR ALTER PROCEDURE Empleados.SP_Empleado_Alta
@Nacimiento date,
@DNI varchar(8),
@Nombre varchar(100),
@Sueldo decimal(11,2),
@ID_parque int,
@CUIL varchar(13) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @DNI is null
            set @error += 'El DNI no puede ser null' + char(10)
        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Empleados.Empleado where DNI = @DNI

        if @ID is not null and @Estado = 'A'
            set @error += 'Ya existe un Empleado con el DNI"' + @DNI + '"' + char(10)
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
        if not exists(select 1 from Parque.Parque where ID = @ID_parque and Estado = 'A')
            set @error += 'El ID_parque no existe' + char(10)
        if @CUIL is null
            set @error += 'El CUIL no puede ser null' + char(10)
        if exists (select 1 from Empleados.Empleado where CUIL = @CUIL and (ID != @ID or @ID is null))
            set @error += 'El CUIL no puede ser repetido' + char(10)
        if @DNI not like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
            set @error += 'El DNI es invalido' + char(10)
        if @CUIL not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIL es invalido' + char(10)
        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Empleados.Empleado set Nombre = @Nombre, Nacimiento = @Nacimiento, DNI = @DNI, Sueldo = @Sueldo, Estado = 'a', ID_parque = @ID_parque, CUIL = @CUIL
            where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Empleados.Empleado(Nacimiento, DNI, CUIL, Nombre, Sueldo, ID_parque) values (@Nacimiento, @DNI, @CUIL, @Nombre, @Sueldo, @ID_parque)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente el empleado de DNI "' + @DNI +'"'
        RETURN @ret
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


CREATE OR ALTER PROCEDURE Empleados.SP_Guia_Alta
    @Nombre VARCHAR(100),
    @DNI VARCHAR(8),
    @CUIL VARCHAR(13),
    @Nacimiento DATE,
    @Sueldo DECIMAL(11,2),
    @ID_Parque INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    IF @DNI IS NULL
        SET @error += 'El DNI no puede ser null' + CHAR(10);
    IF @Nombre IS NULL
        SET @error += 'El nombre no puede ser null' + CHAR(10);

    DECLARE @ID_Empleado INT, @Estado char(1);
    SELECT @ID_Empleado = ID FROM Empleados.Empleado WHERE DNI = @DNI;

    IF @ID_Empleado IS NOT NULL
    BEGIN
        SELECT @Estado = Estado FROM Empleados.Guia WHERE ID_Empleado = @ID_Empleado;
        
        IF @Estado = 'A'
            SET @error += 'El empleado indicado ya esta registrado como guia y se encuentra activo' + CHAR(10);
    END

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ret INT;

        EXEC @ret = Empleados.SP_Empleado_Alta 
            @Nacimiento = @Nacimiento,
            @DNI = @DNI,
            @Nombre = @Nombre,
            @Sueldo = @Sueldo,
            @ID_parque = @ID_Parque,
            @CUIL = @CUIL;

        IF @Estado IS NOT NULL 
        BEGIN
            UPDATE Empleados.Guia SET Estado = 'a' WHERE ID_Empleado = @ret;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.Guia (ID_Empleado) VALUES (@ret);
        END

        COMMIT;
        PRINT 'Guia registrado o reactivado correctamente';
        RETURN @ret;
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Habilitacion_Alta
    @Nombre VARCHAR(100),
    @Detalles VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    SET @Nombre = TRIM(@Nombre);
    SET @Detalles = TRIM(@Detalles);

    IF @Nombre = '' OR @Nombre IS NULL
        SET @error += 'El nombre de la habilitacion no puede ser null o estar vacio' + CHAR(10);
    IF @Nombre LIKE '%[^a-zA-Z ]%'
        SET @error += 'El nombre de la habilitacion debe contener solo letras y espacios' + CHAR(10);
    IF @Detalles = '' OR @Detalles IS NULL
        SET @error += 'Los detalles de la habilitacion no pueden ser null o estar vacio' + CHAR(10);

    DECLARE @ID int, @Estado char(1);
    SELECT @ID = ID, @Estado = Estado FROM Empleados.Habilitacion WHERE Nombre = @Nombre;

    IF @ID IS NOT NULL AND @Estado = 'A'
        SET @error += 'La habilitacion ya existe en la tabla' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ret int;
        IF @ID IS NOT NULL
        BEGIN
            UPDATE Empleados.Habilitacion SET Detalles = @Detalles, Estado = 'A' WHERE ID = @ID;
            SET @ret = @ID;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.Habilitacion (Nombre, Detalles) VALUES (@Nombre, @Detalles);
            SET @ret = SCOPE_IDENTITY();
        END

        COMMIT;
        PRINT 'Habilitacion registrada correctamente';
        RETURN @ret;
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Especialidad_Alta
    @Nombre VARCHAR(100),
    @Detalles VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    SET @Nombre = TRIM(@Nombre);
    SET @Detalles = TRIM(@Detalles);

    IF @Nombre = '' OR @Nombre IS NULL
        SET @error += 'El nombre de la especialidad no puede ser null o estar vacio' + CHAR(10);
    IF @Nombre LIKE '%[^a-zA-Z ]%'
        SET @error += 'El nombre de la especialidad debe contener solo letras y espacios' + CHAR(10);
    IF @Detalles = '' OR @Detalles IS NULL
        SET @error += 'Los detalles de la especialidad no pueden ser null o estar vacio' + CHAR(10);

    DECLARE @ID int, @Estado char(1);
    SELECT @ID = ID, @Estado = Estado FROM Empleados.Especialidad WHERE Nombre = @Nombre;

    IF @ID IS NOT NULL AND @Estado = 'A'
        SET @error += 'La especialidad ya existe en la tabla' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ret int;
        IF @ID IS NOT NULL
        BEGIN
            UPDATE Empleados.Especialidad SET Detalles = @Detalles, Estado = 'A' WHERE ID = @ID;
            SET @ret = @ID;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.Especialidad (Nombre, Detalles) VALUES (@Nombre, @Detalles);
            SET @ret = SCOPE_IDENTITY();
        END

        COMMIT;
        PRINT 'Especialidad registrada correctamente';
        RETURN @ret;
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_Titulo_Alta
    @Nombre VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    SET @Nombre = TRIM(@Nombre);

    IF @Nombre = '' OR @Nombre IS NULL
        SET @error += 'El nombre del titulo no puede ser null o estar vacio' + CHAR(10);
    IF @Nombre LIKE '%[^a-zA-Z ]%'
        SET @error += 'El nombre del titulo debe contener solo letras y espacios' + CHAR(10);

    DECLARE @ID int, @Estado char(1);
    SELECT @ID = ID, @Estado = Estado FROM Empleados.Titulo WHERE Nombre = @Nombre;

    IF @ID IS NOT NULL AND @Estado = 'A'
        SET @error += 'El titulo ya existe en la tabla' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ret int;
        IF @ID IS NOT NULL
        BEGIN
            UPDATE Empleados.Titulo SET Estado = 'A' WHERE ID = @ID;
            SET @ret = @ID;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.Titulo (Nombre) VALUES (@Nombre);
            SET @ret = SCOPE_IDENTITY();
        END

        COMMIT;
        PRINT 'Titulo registrado correctamente';
        RETURN @ret;
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_GuiaHabilitacion_Alta
    @ID_Guia int,
    @Nombre_Habilitacion VARCHAR(100),
    @Detalles_Habilitacion VARCHAR(100),
    @Fecha_Vencimiento DATE,
    @Tipo CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF @ID_Guia IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        SET @error += 'El guia especificado no existe' + CHAR(10);
    IF @Fecha_Vencimiento IS NULL
        SET @error += 'La fecha de vencimiento no puede ser NULL' + CHAR(10);
    IF @Fecha_Vencimiento < GETDATE()
        SET @error += 'La fecha de vencimiento ya paso' + CHAR(10);
    IF @Tipo NOT IN ('M', 'P', 'N')
        SET @error += 'El tipo debe ser municipal, provincial o nacional' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ID_Habilitacion int;

        EXEC @ID_Habilitacion = Empleados.SP_Habilitacion_Alta 
            @Nombre = @Nombre_Habilitacion,
            @Detalles = @Detalles_Habilitacion;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion)
        BEGIN
            UPDATE Empleados.R_Guia_Habilitacion 
            SET Fecha_Vencimiento = @Fecha_Vencimiento, Tipo = @Tipo, Estado = 'A'
            WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.R_Guia_Habilitacion (ID_Guia, ID_Habilitacion, Fecha_Vencimiento, Tipo)
            VALUES (@ID_Guia, @ID_Habilitacion, @Fecha_Vencimiento, @Tipo);
        END

        COMMIT;
        PRINT 'Habilitacion asignada al guia correctamente';
        RETURN; 
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_GuiaEspecialidad_Alta
    @ID_Guia int,
    @Nombre_Especialidad VARCHAR(100),
    @Detalles_Especialidad VARCHAR(100),
    @Nivel CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF @ID_Guia IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        SET @error += 'El guia especificado no existe' + CHAR(10);
    IF @Nivel IS NULL OR @Nivel = ''
        SET @error += 'El nivel no puede estar vacio' + CHAR(10);
    IF @Nivel NOT IN ('B', 'I', 'E')
        SET @error += 'El nivel debe ser basico, intermedio o experto' + CHAR(10);


    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ID_Especialidad int;

        EXEC @ID_Especialidad = Empleados.SP_Especialidad_Alta 
            @Nombre = @Nombre_Especialidad,
            @Detalles = @Detalles_Especialidad;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad)
        BEGIN
            UPDATE Empleados.R_Guia_Especialidad
            SET Nivel = @Nivel, Estado = 'A'
            WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.R_Guia_Especialidad (ID_Guia, ID_Especialidad, Nivel)
            VALUES (@ID_Guia, @ID_Especialidad, @Nivel);
        END

        COMMIT;
        PRINT 'Especialidad asignada al guia correctamente';
        RETURN; 
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
GO

CREATE OR ALTER PROCEDURE Empleados.SP_GuiaTitulo_Alta
    @ID_Guia int,
    @Nombre_Titulo VARCHAR(100),
    @Fecha_emision DATE,
    @Origen VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @error VARCHAR(MAX) = '';

    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF @ID_Guia IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        SET @error += 'El guia especificado no existe' + CHAR(10);
    IF @Fecha_emision IS NULL
        SET @error += 'La fecha de emision no puede ser nula' + CHAR(10);
    IF @Fecha_emision > GETDATE()
        SET @error += 'La fecha de emision no puede ser futura ' + CHAR(10);
    IF @Origen IS NULL OR LTRIM(RTRIM(@Origen)) = ''
        SET @error += 'El origen no puede estar vacio' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ID_Titulo int;

        EXEC @ID_Titulo = Empleados.SP_Titulo_Alta 
            @Nombre = @Nombre_Titulo;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo)
        BEGIN
            UPDATE Empleados.R_Guia_Titulo
            SET Fecha_Emision = @Fecha_emision, Origen = @Origen, Estado = 'A'
            WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo;
        END
        ELSE
        BEGIN
            INSERT INTO Empleados.R_Guia_Titulo (ID_Guia, ID_Titulo, Fecha_emision, Origen)
            VALUES (@ID_Guia, @ID_Titulo, @Fecha_emision, @Origen);
        END

        COMMIT;
        PRINT 'Titulo asignado al guia correctamente';
        RETURN;
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
GO
--------------------CONSECIONES-----------------------
CREATE OR ALTER PROCEDURE Concesiones.SP_TipoActividad_Alta
@Nombre varchar(100), 
@Descripcion varchar(250) as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Nombre is null
            set @error += 'El nombre no puede ser null' + char(10)
        if @Descripcion is null
            set @error = @error + 'La descripcion no puede ser null' + char(10)
        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Concesiones.Tipo_actividad where Nombre = @Nombre

        if @ID is not null and @Estado = 'A'
            set @error += 'El tipo de actividad "' + @Nombre +'" ya existe' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Concesiones.Tipo_actividad set Descripcion=@Descripcion, Estado = 'a' where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Concesiones.Tipo_actividad(Nombre, Descripcion) values (@Nombre, @Descripcion)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente el tipo de actividad "' + @Nombre +'"'
        RETURN @ret
    
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


CREATE OR ALTER PROCEDURE Concesiones.SP_Empresa_Alta
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
        if @Correo is null
            set @error += 'El correo no puede ser null' + char(10)
        if @CUIT not like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
            set @error += 'El CUIT es invalido' + char(10)

        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Concesiones.Empresa where CUIT = @CUIT

        if @ID is not null and @Estado = 'A'
            set @error += 'Ya existe una empresa con el CUIT "' + @CUIT + '"' + char(10)


        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Concesiones.Empresa set Nombre = @Nombre, Correo = @Correo, Estado = 'a' where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Concesiones.Empresa(Nombre, CUIT, Correo) values (@Nombre, @CUIT, @Correo)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente la empresa de CUIT "' + @CUIT +'"'
        RETURN @ret
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


CREATE OR ALTER PROCEDURE Concesiones.SP_Concesion_Alta
        @Fecha_inicio DATE,
		@Fecha_fin DATE,
		@ID_empresa int,
		@ID_tipo int,
		@ID_parque int as
BEGIN
    SET NOCOUNT ON;
    declare @error varchar(max) = ''
        if @Fecha_inicio is null
            set @error += 'La fecha de inicio no puede ser null' + char(10)
        if @Fecha_fin is null
            set @error += 'La fecha de fin no puede ser null' + char(10)
        if @ID_empresa is null
            set @error += 'El ID_empresa no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Empresa where ID = @ID_empresa and Estado = 'A')
            set @error += 'El ID_empresa no existe' + char(10)
        if @ID_tipo is null
            set @error += 'El ID_tipo no puede ser null' + char(10)
        if not exists (select 1 from Concesiones.Tipo_actividad where ID = @ID_tipo and Estado = 'A')
            set @error += 'El ID_tipo no existe' + char(10)
        if @ID_parque is null
            set @error += 'El ID_parque no puede ser null' + char(10)
        if not exists (select 1 from Parque.Parque where ID = @ID_parque and Estado = 'A')
            set @error += 'El ID_parque no existe' + char(10)
        if @Fecha_fin < @Fecha_inicio
            set @error += 'La fecha de fin no puede ser anterior a la fecha de inicio' + char(10)
        
        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Concesiones.Concesion where Fecha_inicio = @Fecha_inicio and Fecha_fin = @Fecha_fin and ID_empresa = @ID_empresa and ID_tipo = @ID_tipo and ID_parque = @ID_parque
        if @ID is not null and @Estado = 'A'
            set @error += 'Ya existe esta misma concesion' + char(10)

        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
        declare @ret int
        if @ID is not null
        begin
            update Concesiones.Concesion set Estado = 'a' where ID = @ID
            set @ret = @ID
        end
        else
        begin
            insert into Concesiones.Concesion(Fecha_inicio, Fecha_fin, ID_empresa, ID_tipo, ID_parque) values (@Fecha_inicio, @Fecha_fin, @ID_empresa, @ID_tipo, @ID_parque)
            set @ret = SCOPE_IDENTITY()
        end
        COMMIT;
        print 'se inserto correctamente la concesion '
        RETURN @ret

        

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



CREATE OR ALTER PROCEDURE Concesiones.SP_PagoMensual_Alta --siempre se registra el pago como deudor 
        @Fecha DATE,
		@Monto DECIMAL(11,2),
		@Metodo VARCHAR(100),
		@ID_concesion int as
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
            set @error += 'La fecha no puede ser null' + char(10)
        if exists (select 1 from Concesiones.Concesion where ID = @ID_concesion and (Fecha_inicio > @Fecha or Fecha_fin < @Fecha))
            set @error += 'La fecha escapa al rango de su concesion' + char(10)
        declare @ID int, @Estado char(1)
        select @ID = ID, @Estado = Estado from Concesiones.Pago_mensual where ID_concesion = @ID_concesion and @Fecha = Fecha
        if @ID is not null and @Estado = 'A'
            set @error += 'Ya hay un pago registrado para esa concesion y esa fecha ' + char(10)



        if @error != ''
            throw 50001, @error, 1;
    BEGIN TRANSACTION;
    BEGIN TRY
    declare @ret int
    if @ID is not null
    begin
        update Concesiones.Pago_mensual set Pago = 'D', Fecha = @Fecha, Monto = @Monto, Metodo = @Metodo, ID_concesion = @ID_concesion where ID = @ID
        set @ret = @ID
    end
    else
    begin
        insert into Concesiones.Pago_mensual(Fecha, Monto, Metodo, ID_concesion) values (@Fecha, @Monto, @Metodo, @ID_concesion)
        set @ret = SCOPE_IDENTITY()
    end
    COMMIT;
    print 'se inserto correctamente el pago para la concesion'
    RETURN @ret
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


--------------------VENTAS-----------------------
CREATE OR ALTER PROCEDURE Ventas.SP_Cliente_Alta
(
	@Nombre VARCHAR(100),
	@Documento VARCHAR(20),
	@Tipo_doc VARCHAR(20),
	@Nacimiento DATE
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
	IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))='' -- elimina espacios en blanco
	SET @Errores += CHAR(13) + '- El nombre es obligatorio';
	
	IF @Documento IS NULL OR LTRIM(RTRIM(@Documento))=''
	SET @Errores += CHAR(13) + '- El documento es obligatorio';
	
	IF @Tipo_doc IS NULL OR LTRIM(RTRIM(@Tipo_doc))=''
	SET @Errores += CHAR(13) + '- El tipo de documento es obligatorio';
	
	IF @Nacimiento > CAST(GETDATE() AS DATE)
	SET @Errores += CHAR(13) + '- La fecha de nacimiento no puede ser futura';
	
	IF @Nacimiento > DATEADD(YEAR,-18,CAST(GETDATE() AS DATE))
	SET @Errores += CHAR(13) + '- El cliente debe ser mayor de edad';
	
    IF @Nacimiento IS NULL
	SET @Errores += CHAR(13) + '- El nacimiento es obligatorio';
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Cliente
		WHERE Documento=@Documento
	)
	SET @Errores += CHAR(13) + '- Ya existe un cliente con ese documento';

	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Cliente where Documento = @Documento AND Tipo_doc = @Tipo_doc

	-- ERRORES
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;;
	END
	
	-- INSERT
	if @ID is not NULL
		update Ventas.Cliente set Estado='a' where ID = @ID
	else 
		INSERT INTO Ventas.Cliente
		(
			Nombre,
			Documento,
			Tipo_doc,
			Nacimiento			
		)
		VALUES
		(
			@Nombre,
			@Documento,
			@Tipo_doc,
			@Nacimiento
		);
	
	PRINT 'Cliente registrado correctamente';
    RETURN SCOPE_IDENTITY();
END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_TipoVisitante_Alta
(
	@Nombre VARCHAR(100)
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
	IF @Nombre IS NULL OR LTRIM(RTRIM(@Nombre))=''
	SET @Errores += CHAR(13) + '- El nombre es obligatorio';
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Tipo_visitante
		WHERE Nombre=@Nombre
	)
	SET @Errores += CHAR(13) + '- Ya existe un tipo de visitante con ese nombre';

	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Tipo_visitante where Nombre = @Nombre
	
	-- ERRORES
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
	-- INSERT
	if @ID is not NULL
		update Ventas.Tipo_visitante set Estado='a' where ID = @ID
	else 
		INSERT INTO Ventas.Tipo_visitante(Nombre)
		VALUES(@Nombre);
	
	PRINT 'Tipo de visitante registrado correctamente';
    RETURN SCOPE_IDENTITY();
END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Tarifa_Alta
(
	@Fecha_desde DATE,
	@Fecha_hasta DATE,
	@Precio DECIMAL(11,2),
	@ID_tipo_visitante int,
	@ID_parque int
)
AS
BEGIN
	
	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
	IF @Precio <= 0
	SET @Errores += CHAR(13)+'- El precio debe ser mayor a cero';
	
	IF @Fecha_hasta < @Fecha_desde
	SET @Errores += CHAR(13)+'- La fecha hasta debe ser posterior a la fecha desde';
	
	IF NOT EXISTS
	(
		SELECT 1
		FROM Ventas.Tipo_visitante
		WHERE ID=@ID_tipo_visitante
	)
	SET @Errores += CHAR(13)+'- El tipo de visitante no existe';
	
	IF NOT EXISTS
	(
		SELECT 1
		FROM Parque.Parque
		WHERE ID=@ID_parque
	)
	SET @Errores += CHAR(13)+'- El parque no existe';
	
	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Tarifa where ID_tipo_visitante = @ID_tipo_visitante AND ID_parque = @ID_parque
	-- ERRORES
	
	IF @Errores<>''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
	-- INSERT
	if @ID is not NULL
		update Ventas.Tarifa set Estado='a' where ID = @ID
	else 
		INSERT INTO Ventas.Tarifa
		(
			Fecha_desde,
			Fecha_hasta,
			Precio,
			ID_tipo_visitante,
			ID_parque
		)
		VALUES
		(
			@Fecha_desde,
			@Fecha_hasta,
			@Precio,
			@ID_tipo_visitante,
			@ID_parque
		);
    RETURN SCOPE_IDENTITY();
END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Entrada_Alta
(
	@Fecha_acceso DATE,
	@ID_cliente int,
	@ID_tarifa int,
	@ID_compra int
)
AS
BEGIN
	
	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
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
	
	IF NOT EXISTS
	(
	SELECT 1
	FROM Ventas.Compra
	WHERE ID=@ID_compra
	)
	SET @Errores += CHAR(13) + '- La compra no existe';

	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Entrada where ID_compra = @ID_compra AND ID_tarifa = @ID_tarifa AND ID_cliente = @ID_cliente

	-- ERRORES
	
	IF @Errores <> ''
	BEGIN
	THROW 50001, @Errores, 1;
	END
	
	-- INSERT
	if @ID is not NULL
		update Ventas.Entrada set Estado='a' where ID = @ID
	else 
		INSERT INTO Ventas.Entrada
		(
		Fecha_acceso,
		ID_cliente,
		ID_tarifa,
		ID_compra
		)
		VALUES
		(
		@Fecha_acceso,
		@ID_cliente,
		@ID_tarifa,
		@ID_compra
		);
	
	PRINT 'Entrada registrada correctamente';
    RETURN SCOPE_IDENTITY();
END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Compra_Alta
(
	@Fecha DATETIME,
	@Total DECIMAL(11,2),
	@Cantidad INT,
	@Punto_venta VARCHAR(100)
)
AS
BEGIN
	
	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
	IF @Fecha > GETDATE()
	SET @Errores += CHAR(13) + '- La fecha de compra no puede ser futura';
	
	IF @Total < 0
	SET @Errores += CHAR(13) + '- El total no puede ser negativo';
	
	IF @Cantidad <= 0
	SET @Errores += CHAR(13) + '- La cantidad debe ser mayor a cero';
	
	IF @Punto_venta IS NULL
	OR LTRIM(RTRIM(@Punto_venta))=''
	SET @Errores += CHAR(13) + '- El punto de venta es obligatorio';

	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Compra where Punto_venta = @Punto_venta AND Total = @Total AND Fecha = @Fecha

	-- ERRORES
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
	if @ID is not NULL
			update Ventas.Compra set Estado='a' where ID = @ID
		else 
			INSERT INTO Ventas.Compra
	(
		Fecha,
		Total,
		Cantidad,
		Punto_venta
	)
	VALUES
	(
		@Fecha,
		@Total,
		@Cantidad,
		@Punto_venta
	);
	
	PRINT 'Compra registrada correctamente';
    RETURN SCOPE_IDENTITY();
END
GO 

CREATE OR ALTER PROCEDURE Ventas.SP_Pago_Alta
(
	@Metodo VARCHAR(100),
	@Monto DECIMAL(11,2),
	@Estados CHAR(1),
	@ID_compra int
)
AS
BEGIN

	DECLARE @Errores VARCHAR(MAX)='';
	
	-- VALIDACIONES
	
	IF @Metodo IS NULL
	OR LTRIM(RTRIM(@Metodo))=''
	SET @Errores += CHAR(13) + '- El método de pago es obligatorio';
	
	IF @Monto <= 0
	SET @Errores += CHAR(13) + '- El monto debe ser mayor a cero';
	
	IF @Estados NOT IN ('P','A','R')
	SET @Errores += CHAR(13) + '- Estado inválido (P=Pendiente, A=Aprobado, R=Rechazado)';
	
	IF NOT EXISTS
	(
		SELECT 1
		FROM Ventas.Compra
		WHERE ID=@ID_compra
	)
	SET @Errores += CHAR(13) + '- La compra no existe';
	
	IF EXISTS
	(
		SELECT 1
		FROM Ventas.Pago
		WHERE ID_compra=@ID_compra
	)
	SET @Errores += CHAR(13) + '- La compra ya posee un pago asociado';

	declare @ID int, @Estado char(1)
	select @ID = ID, @Estado = Estado from Ventas.Pago where ID_compra = @ID_compra AND Monto = @Monto
	-- ERRORES
	
	IF @Errores <> ''
	BEGIN
		THROW 50001, @Errores, 1;
	END
	
	-- INSERT
	if @ID is not NULL
		update Ventas.Pago set Estado='a' where ID = @ID
	else 
		INSERT INTO Ventas.Pago
		(
			Metodo,
			Monto,
			Estado,
			ID_compra
		)
		VALUES
		(
			@Metodo,
			@Monto,
			@Estados,
			@ID_compra
		);
	
	PRINT 'Pago registrado correctamente';
    RETURN SCOPE_IDENTITY();
END
GO 


--------------------ATRACCIONES-----------------------
CREATE OR ALTER PROCEDURE Atracciones.SP_Tour_Alta
    @Costo DECIMAL(11,2),
    @Cupo_max INT,
    @Tipo CHAR(1),
    @Duracion INT,
    @ID_parque int
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones basicas de dominio para evitar datos inconsistentes.
    DECLARE @error VARCHAR(MAX) = '';

    IF @Costo IS NULL
        SET @error += 'El costo no puede ser null' + CHAR(10);
    IF @ID_parque IS NULL
        SET @error += 'El ID_parque no puede ser null' + CHAR(10);
    IF @Costo IS NOT NULL AND @Costo < 0
        SET @error += 'El costo no puede ser menor a 0' + CHAR(10);
    IF @Cupo_max IS NULL
        SET @error += 'El cupo maximo no puede ser null' + CHAR(10);
    IF @Cupo_max IS NOT NULL AND @Cupo_max <= 0
        SET @error += 'El cupo maximo debe ser mayor a 0' + CHAR(10);
    IF @Tipo IS NULL OR LTRIM(RTRIM(@Tipo)) = ''
        SET @error += 'El tipo no puede ser null ni vacio' + CHAR(10);
    IF @Duracion IS NULL
        SET @error += 'La duracion no puede ser null' + CHAR(10);
    IF @Duracion IS NOT NULL AND @Duracion <= 0
        SET @error += 'La duracion debe ser mayor a 0' + CHAR(10);
    IF NOT EXISTS (SELECT 1 FROM Parque.Parque where ID = @ID_parque AND Estado = 'A')
        SET @error += 'No existe ningun parque con el ID_parque enviado' + CHAR(10);
    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		INSERT INTO Atracciones.Tour
        (
            Costo,
            Cupo_max,
            Tipo,
            Duracion,
            ID_parque
        )
        VALUES
        (
            @Costo,
            @Cupo_max,
            @Tipo,
            @Duracion,
            @ID_parque
        );

        COMMIT;

        PRINT 'Tour registrado correctamente';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @Msg NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @Num INT = ERROR_NUMBER();
        PRINT CONCAT('ERROR (', @Num, '): ', @Msg);

        THROW;
    END CATCH;
    RETURN SCOPE_IDENTITY();
END;
GO

CREATE OR ALTER PROCEDURE Atracciones.SP_TourGuia_Alta
    @ID_Tour int,
    @ID_Guia int
AS
BEGIN
    SET NOCOUNT ON;

    -- Asigna un guia existente a un tour existente.
    DECLARE @error VARCHAR(MAX) = '';
------------------------
	DECLARE @Estado CHAR(1);

	SELECT @Estado = Estado
	FROM Atracciones.R_Tour_Guia
	WHERE ID_Tour = @ID_Tour
  	AND ID_Guia = @ID_Guia;
------------------------

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Guia IS NULL
        SET @error += 'El ID_Guia no puede ser null' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @ID_Tour)
        SET @error += 'El tour indicado no existe' + CHAR(10);
    IF @ID_Guia IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        SET @error += 'El guia indicado no existe' + CHAR(10);
    IF @Estado = 'a'
    	SET @error += 'El guia ya esta asignado a ese tour' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY

    	IF @Estado = 'I'
    	BEGIN
        	UPDATE Atracciones.R_Tour_Guia
        	SET Estado = 'A'
        	WHERE ID_Tour = @ID_Tour
          	AND ID_Guia = @ID_Guia;
    	END
    	ELSE
    	BEGIN
        	INSERT INTO Atracciones.R_Tour_Guia
        	(
            	ID_Tour,
            	ID_Guia
        	)
        	VALUES
        	(
            	@ID_Tour,
            	@ID_Guia
        	);
    	END

    	COMMIT;

    	PRINT 'Guia asignado al tour correctamente';

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

CREATE OR ALTER PROCEDURE Atracciones.SP_TourEntrada_Alta
    @ID_Tour int,
    @ID_Entrada int
AS
BEGIN
    SET NOCOUNT ON;

    -- Asigna una entrada existente a un tour existente.
    -- Se controla el cupo maximo antes de insertar.
    DECLARE @error VARCHAR(MAX) = '';
	--------------------------------
	DECLARE @Estado CHAR(1);

	SELECT @Estado = Estado
	FROM Atracciones.R_Tour_Entrada
	WHERE ID_Tour = @ID_Tour
  	AND ID_Entrada = @ID_Entrada;
	--------------------------------

    IF @ID_Tour IS NULL
        SET @error += 'El ID_Tour no puede ser null' + CHAR(10);
    IF @ID_Entrada IS NULL
        SET @error += 'El ID_Entrada no puede ser null' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Atracciones.Tour WHERE ID_Tour = @ID_Tour)
        SET @error += 'El tour indicado no existe' + CHAR(10);
    IF @ID_Entrada IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Ventas.Entrada WHERE ID = @ID_Entrada)
        SET @error += 'La entrada indicada no existe' + CHAR(10);
	IF @Estado = 'a'
    	SET @error += 'La entrada ya esta asignada a ese tour' + CHAR(10);
    IF @ID_Tour IS NOT NULL AND EXISTS (
        SELECT 1
        FROM Atracciones.Tour
        WHERE ID_Tour = @ID_Tour
          AND Cupo_max <= (SELECT COUNT(*) FROM Atracciones.R_Tour_Entrada WHERE ID_Tour = @ID_Tour)
    )
        SET @error += 'El tour ya alcanzo su cupo maximo' + CHAR(10);

    IF @error != ''
        THROW 50001, @error, 1;

    BEGIN TRANSACTION;
    BEGIN TRY
		IF @Estado = 'I'
		BEGIN
    		UPDATE Atracciones.R_Tour_Entrada
    		SET Estado = 'A'
    		WHERE ID_Tour = @ID_Tour
      		AND ID_Entrada = @ID_Entrada;
		END
		ELSE
		BEGIN
    		INSERT INTO Atracciones.R_Tour_Entrada
    		(
        		ID_Tour,
        		ID_Entrada
    		)
    		VALUES
    		(
        		@ID_Tour,
		        @ID_Entrada
    		);
		END
		--------------

        COMMIT;
        PRINT 'Entrada asignada al tour correctamente';
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
