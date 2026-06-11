
USE sist_gestion_parques
GO
------------- CREACION DE STORE PROCEDURE -------------

--------------------PARQUE-----------------------


--------------------EMPLEADOS-----------------------
CREATE OR ALTER PROCEDURE Empleados.Agr_Guia
    @Nombre VARCHAR(100),
    @DNI VARCHAR(20),
    @CUIL VARCHAR(20),
    @Nacimiento DATE,
    @Sueldo DECIMAL(11,2),
    @Estado CHAR(1),
    @ID_Parque BIGINT
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Empleado BIGINT;

        -- Llamada al agregado de Empleado, pendiente. 
        EXEC @ID_Empleado = Parque.Agr_Empleado
            @Nombre = @Nombre,
            @DNI = @DNI,
            @CUIL = @CUIL,
            @Nacimiento = @Nacimiento,
            @Sueldo = @Sueldo,
            @Estado = @Estado,
            @ID_Parque = @ID_Parque;

        IF EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Empleado)
        BEGIN
            PRINT('Este empleado ya es un guia.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al registrar el guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Guia (ID_Empleado) VALUES (@ID_Empleado);
    RETURN @ID_Empleado;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Habilitacion
    @Detalles VARCHAR(100),
    @Fecha DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;
        SET @Detalles = TRIM(@Detalles);

        IF @Detalles = '' OR LEN(@Detalles) > 100
        BEGIN
            PRINT('Los detalles de la habilitacion no son validos.');
            RAISERROR('.', 16, 1);
        END

        IF @Fecha IS NULL OR @Fecha > GETDATE()
        BEGIN
            PRINT('La fecha de habilitacion no es valida.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Habilitacion 
        WHERE Detalles = @Detalles AND Fecha = @Fecha;

        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al resgistrar la habilitacion', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Habilitacion (Detalles, Fecha) 
    VALUES (@Detalles, @Fecha);
    
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Especialidad
    @Nombre VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;
        SET @Nombre = TRIM(@Nombre);

        IF @Nombre = '' OR @Nombre LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El nombre de la especialidad no es valido.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Especialidad WHERE Nombre = @Nombre;
        
        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al registrar la especialidad', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Especialidad (Nombre) VALUES (@Nombre);
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_Titulo
    @Nombre VARCHAR(100),
    @Fecha DATE,
    @Origen VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @Id BIGINT;

        SET @Nombre = TRIM(@Nombre);
        SET @Origen = TRIM(@Origen);

        IF @Nombre = '' OR @Nombre LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El nombre del titulo no es valido.');
            RAISERROR('.', 16, 1);
        END

        IF @Origen = '' OR @Origen LIKE '%[^a-zA-Z ]%' OR LEN(@Nombre) > 100
        BEGIN
            PRINT('El origen del titulo no es valido.');
            RAISERROR('.', 16, 1);
        END

        IF @Fecha IS NULL OR @Fecha > GETDATE()
        BEGIN
            PRINT('La fecha del titulo no es valida.');
            RAISERROR('.', 16, 1);
        END

        SELECT @Id = ID FROM Empleados.Titulo 
        WHERE Nombre = @Nombre AND Origen = @Origen AND Fecha = @Fecha;

        IF @Id IS NOT NULL
        BEGIN
            RETURN @Id;
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error en el registro del titulo', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.Titulo (Nombre, Fecha, Origen) 
    VALUES (@Nombre, @Fecha, @Origen);
    
    SET @Id = SCOPE_IDENTITY();
    RETURN @Id;
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Habilitacion
    @ID_Guia BIGINT,
    @Detalles VARCHAR(100),
    @Fecha DATE
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Habilitacion BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Habilitacion = Empleados.Agr_Habilitacion
            @Detalles = @Detalles,
            @Fecha = @Fecha;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Habilitacion)
        BEGIN
            PRINT('El guia ya tiene esta habilitacion.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar la habilitacion al guía.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Habilitacion (ID_Guia, ID_Habilitacion)
    VALUES (@ID_Guia, @ID_Habilitacion);
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Especialidad
    @ID_Guia BIGINT,
    @Nombre_Especialidad VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Especialidad BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Especialidad = Empleados.Agr_Especialidad
            @Nombre = @Nombre_Especialidad;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Especialidad)
        BEGIN
            PRINT('El guia ya tiene asignada esta especialidad.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar la especialidad al guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Especialidad (ID_Guia, ID_Especialidad)
    VALUES (@ID_Guia, @ID_Especialidad);
END
GO

CREATE OR ALTER PROCEDURE Empleados.Agr_R_Guia_Titulo
    @ID_Guia BIGINT,
    @Nombre_Titulo VARCHAR(100),
    @Fecha_Titulo DATE,
    @Origen_Titulo VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        DECLARE @ID_Titulo BIGINT;

        IF NOT EXISTS (SELECT 1 FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia)
        BEGIN
            PRINT('El guia especificado no existe.');
            RAISERROR('.', 16, 1);
        END

        EXEC @ID_Titulo = Empleados.Agr_Titulo
            @Nombre = @Nombre_Titulo,
            @Fecha = @Fecha_Titulo,
            @Origen = @Origen_Titulo;

        IF EXISTS (SELECT 1 FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Titulo)
        BEGIN
            PRINT('El guia ya tiene asignado este titulo.');
            RAISERROR('.', 16, 1);
        END

    END TRY
    BEGIN CATCH
        IF ERROR_SEVERITY() > 10
        BEGIN
            RAISERROR('Ocurrio un error al asignar el título al guia.', 16, 1);
            RETURN;
        END
    END CATCH

    INSERT INTO Empleados.R_Guia_Titulo (ID_Guia, ID_Titulo)
    VALUES (@ID_Guia, @ID_Titulo);
END
GO
--------------------CONSECIONES-----------------------


--------------------VENTAS-----------------------


--------------------ATRACCIONES-----------------------
