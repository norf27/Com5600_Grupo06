/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion: Generacion de tablas
*/

------------------ CREACIÓN DE BBDD -------------------
/*
ALTER DATABASE sist_gestion_parques
SET MULTI_USER;
GO
*/
USE master;
GO

ALTER DATABASE sist_gestion_parques
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE sist_gestion_parques;
GO 

IF DB_ID('sist_gestion_parques') IS NULL
    CREATE DATABASE sist_gestion_parques COLLATE Latin1_General_CI_AS;
GO	

USE sist_gestion_parques
GO

------------------ CREACIÓN DE ESQUEMAS -------------------

IF SCHEMA_ID('Parque') IS NULL
BEGIN
	EXEC('CREATE SCHEMA Parque'); 
END
GO

IF SCHEMA_ID('Empleados') IS NULL
BEGIN
	EXEC('CREATE SCHEMA Empleados'); 
END
GO

IF SCHEMA_ID('Concesiones') IS NULL
BEGIN
	EXEC('CREATE SCHEMA Concesiones'); 
END
GO

IF SCHEMA_ID('Ventas') IS NULL
BEGIN
	EXEC('CREATE SCHEMA Ventas'); 
END
GO

IF SCHEMA_ID('Atracciones') IS NULL
BEGIN
	EXEC('CREATE SCHEMA Atracciones'); 
END
GO
------------------ CREACIÓN DE TABLAS -------------------
--------------------PARQUE-----------------------
IF OBJECT_ID('Parque.Tipo_parque', 'U') IS NULL
BEGIN
	CREATE TABLE Parque.Tipo_parque
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Nombre VARCHAR(100) NOT NULL,
		Descripcion VARCHAR(250) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tipo_parque CHECK (Estado in ('A', 'I'))
	);
END

IF OBJECT_ID('Parque.Provincia', 'U') IS NULL
BEGIN
	CREATE TABLE Parque.Provincia
	(
		ID TINYINT PRIMARY KEY CLUSTERED IDENTITY(1,1), --no usar INT, usar tinyint
		Nombre VARCHAR(100) NOT NULL UNIQUE,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Provincia CHECK (Estado in ('A', 'I'))
	);
END

IF OBJECT_ID('Parque.Parque', 'U') IS NULL
BEGIN
	CREATE TABLE Parque.Parque
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Superficie INT NOT NULL,
		Nombre VARCHAR(100) NOT NULL UNIQUE,
		ID_tipo INT NOT NULL,
		ID_provincia TINYINT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Parque CHECK (Estado in ('A', 'I')),
		CONSTRAINT check_superficie CHECK (superficie > 0),
		CONSTRAINT FK_tipo_parque FOREIGN KEY (ID_tipo) REFERENCES Parque.Tipo_parque(ID),
		CONSTRAINT FK_provincia FOREIGN KEY (ID_provincia) REFERENCES Parque.Provincia(ID)
	);
END
--------------------EMPLEADOS-----------------------
IF OBJECT_ID('Empleados.Empleado', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Empleado 
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY (1,1),
		Nacimiento DATE NOT NULL,
		DNI VARCHAR(8) NOT NULL UNIQUE,
		Nombre VARCHAR(100) NOT NULL,
		Sueldo DECIMAL(11,2) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: ACTIVO, i:INACTIVO, l: LICENCIA, v:VACACIONES
		ID_parque INT NOT NULL,
		CUIL VARCHAR(13) NOT NULL UNIQUE,
		CONSTRAINT FK_parque_emp FOREIGN KEY (ID_parque) REFERENCES Parque.Parque(ID),
		CONSTRAINT check_DNI CHECK (DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		CONSTRAINT check_sueldo CHECK (sueldo > 0),
		CONSTRAINT check_nacimiento CHECK (nacimiento <= DATEADD(YEAR, -18, CAST(GETDATE() AS DATE))), 
		CONSTRAINT check_CUIL CHECK (CUIL LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
		CONSTRAINT check_Estado_Empleado CHECK (Estado IN ('i','a','l','v'))
	);
END

IF OBJECT_ID('Empleados.Guardaparque', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Guardaparque
	(
		ID_Empleado INT PRIMARY KEY,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Guardaparque CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_Guardaparque_Empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleados.Empleado(ID) ON DELETE CASCADE
	);
END
    
IF OBJECT_ID('Empleados.R_Guardaparque_Parque', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.R_Guardaparque_Parque --no tiene estado porque el estado de guardaparque se maneja desde empleado
	(
		ID_Guardaparque INT,
		ID_Parque INT, 
		Fecha_ingreso DATE NOT NULL,
		Fecha_egreso DATE NULL,
		Motivo_egreso VARCHAR(255) NULL,
		PRIMARY KEY (ID_Guardaparque, ID_Parque, Fecha_ingreso),
		CONSTRAINT FK_GuardaparqueParque_Guardaparque FOREIGN KEY (ID_Guardaparque) REFERENCES Empleados.Guardaparque(ID_Empleado),
		CONSTRAINT FK_GuardaparqueParque_Parque FOREIGN KEY (ID_Parque) REFERENCES Parque.Parque(ID),
		CONSTRAINT CK_GuardaparqueParque_Fechas CHECK (Fecha_egreso IS NULL OR Fecha_egreso >= Fecha_ingreso),
		CONSTRAINT CK_GuardaparqueParque_ConsistenciaEgreso CHECK (
			(Fecha_egreso IS NULL AND Motivo_egreso IS NULL) OR 
			(Fecha_egreso IS NOT NULL AND Motivo_egreso IS NOT NULL)
		)
	);
END


IF OBJECT_ID('Empleados.Guia', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Guia --no tiene estado porque el estado de guia se maneja desde empleado
	(
		ID_Empleado INT PRIMARY KEY,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Guia CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_Guia_Empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleados.Empleado(ID) ON DELETE CASCADE
	);
END
    
IF OBJECT_ID('Empleados.Habilitacion', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Habilitacion 
	(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		Detalles VARCHAR(100) NOT NULL,
		Fecha DATE NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Habilitacion CHECK (Estado in ('A', 'I'))
	);
END
    
IF OBJECT_ID('Empleados.R_Guia_Habilitacion', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.R_Guia_Habilitacion 
	(
		ID_Guia INT,
		ID_Habilitacion INT,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado CHECK (Estado in ('A', 'I')),
		PRIMARY KEY (ID_Guia, ID_Habilitacion),
		CONSTRAINT FK_GuiaHabilitacion_Guia FOREIGN KEY (ID_Guia) REFERENCES Empleados.Guia(ID_Empleado),
		CONSTRAINT FK_GuiaHabilitacion_Habilitacion FOREIGN KEY (ID_Habilitacion) REFERENCES Empleados.Habilitacion(ID)
	);
END

IF OBJECT_ID('Empleados.Especialidad', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Especialidad 
	(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		Nombre VARCHAR(100) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Especialidad CHECK (Estado in ('A', 'I'))
	);
END
    
IF OBJECT_ID('Empleados.R_Guia_Especialidad', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.R_Guia_Especialidad 
	(
		ID_Guia INT,
		ID_Especialidad INT,
		PRIMARY KEY (ID_Guia, ID_Especialidad),
		CONSTRAINT FK_GuiaEspecialidad_Guia FOREIGN KEY (ID_Guia) REFERENCES Empleados.Guia(ID_Empleado),
		CONSTRAINT FK_GuiaEspecialidad_Especialidad FOREIGN KEY (ID_Especialidad) REFERENCES Empleados.Especialidad(ID)
	);
END

IF OBJECT_ID('Empleados.Titulo', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.Titulo 
	(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		Nombre VARCHAR(100) NOT NULL,
		Fecha DATE NOT NULL,
		Origen VARCHAR(100) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Titulo CHECK (Estado in ('A', 'I'))
	);
END

IF OBJECT_ID('Empleados.R_Guia_Titulo', 'U') IS NULL
BEGIN
	CREATE TABLE Empleados.R_Guia_Titulo 
	(
		ID_Guia INT,
		ID_Titulo INT,
		PRIMARY KEY (ID_Guia, ID_Titulo),
		CONSTRAINT FK_GuiaTitulo_Guia FOREIGN KEY (ID_Guia) REFERENCES Empleados.Guia(ID_Empleado),
		CONSTRAINT FK_GuiaTitulo_Titulo FOREIGN KEY (ID_Titulo) REFERENCES Empleados.Titulo(ID)
	);
END

--------------------CONSECIONES-----------------------

IF OBJECT_ID('Concesiones.Tipo_actividad', 'U') IS NULL
BEGIN
	CREATE TABLE Concesiones.Tipo_actividad
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Nombre VARCHAR(100) NOT NULL UNIQUE,
		Descripcion VARCHAR(250) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tipo_actividad CHECK (Estado in ('A', 'I'))
	);
END

IF OBJECT_ID('Concesiones.Empresa', 'U') IS NULL
BEGIN
	CREATE TABLE Concesiones.Empresa
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Nombre VARCHAR(100) NOT NULL,
		CUIT VARCHAR(13) NOT NULL UNIQUE,
		Correo VARCHAR(100) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Empresa CHECK (Estado in ('A', 'I')),
		CONSTRAINT check_CUIT CHECK (CUIT LIKE '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
	);
END

IF OBJECT_ID('Concesiones.Concesion', 'U') IS NULL
BEGIN
	CREATE TABLE Concesiones.Concesion
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Fecha_inicio DATE NOT NULL,
		Fecha_fin DATE NOT NULL,
		ID_empresa INT NOT NULL,
		ID_tipo INT NOT NULL,
		ID_parque INT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo. no hace referencia a si se encuentra en proceso actualmente
		--sino a si se debe tener en cuenta al recorrer la tabla o no
		CONSTRAINT check_Estado_Concesion CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_empresa FOREIGN KEY (ID_empresa) REFERENCES Concesiones.Empresa(ID),
		CONSTRAINT FK_tipo_actividad FOREIGN KEY (ID_tipo) REFERENCES Concesiones.Tipo_actividad(ID),
		CONSTRAINT FK_parque FOREIGN KEY (ID_parque) REFERENCES Parque.Parque(ID)
	);
END

IF OBJECT_ID('Concesiones.Pago_mensual', 'U') IS NULL
BEGIN
	CREATE TABLE Concesiones.Pago_mensual 
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Fecha DATE NOT NULL,
		Monto DECIMAL(11,2) NOT NULL,
		Metodo VARCHAR(100) NOT NULL,
		ID_concesion INT NOT NULL,
		Pago char(1) NOT NULL default 'd', --P:pago, D: deudor
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo. no hace referencia al estado del pago mensual (EJ: adeudado o pago)
		--solo hace referencia a si se debe tener en cuenta al recorrer la tabla
		CONSTRAINT check_Estado_Pago_mensual CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_concesion FOREIGN KEY (ID_concesion) REFERENCES Concesiones.Concesion(ID),
		CONSTRAINT check_monto CHECK (monto > 0),
		CONSTRAINT check_pago CHECK (Pago in ('P', 'D')) 
	);
END

--------------------VENTAS-----------------------
IF OBJECT_ID('Ventas.Tipo_visitante', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Tipo_visitante
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Nombre VARCHAR(100) NOT NULL UNIQUE,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tipo_visitante CHECK (Estado in ('A', 'I'))
	);
END

IF OBJECT_ID('Ventas.Cliente', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Cliente
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Nombre VARCHAR(100) NOT NULL,
		Documento VARCHAR(20) NOT NULL UNIQUE,
		Tipo_doc VARCHAR(20) NOT NULL,
		Nacimiento DATE NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Cliente CHECK (Estado in ('A', 'I')),
		CONSTRAINT CK_cliente_nacimiento CHECK (Nacimiento <= CAST(GETDATE() AS DATE)),
	);
END

IF OBJECT_ID('Ventas.Tarifa', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Tarifa  
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Fecha_desde DATE NOT NULL,
		Fecha_hasta DATE NULL,
		Precio DECIMAL(11,2) NOT NULL,
		ID_tipo_visitante INT NOT NULL,
		ID_parque INT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo. no hace referencia a si se encuentra actualmente activa el tipo de tarifa
		--eso se ve usando fecha_hasta, es solo para ver si se toma en cuenta al recorrer la tabla o no
		CONSTRAINT check_Estado_Tarifa CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_tarifa_tipo_visitante FOREIGN KEY (ID_tipo_visitante) REFERENCES Ventas.Tipo_visitante(ID),
		CONSTRAINT FK_tarifa_parque FOREIGN KEY (ID_parque) REFERENCES Parque.Parque(ID),
		CONSTRAINT CK_tarifa_precio CHECK (Precio > 0),
		CONSTRAINT CK_tarifa_fechas CHECK (Fecha_hasta >= Fecha_desde)
	);
END

IF OBJECT_ID('Ventas.Compra', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Compra
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Fecha DATETIME NOT NULL DEFAULT GETDATE(),
		Total DECIMAL(11,2) NOT NULL,
		Cantidad INT NOT NULL,
		Punto_venta VARCHAR(100) NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Compra CHECK (Estado in ('A', 'I')),
		CONSTRAINT CK_compra_total CHECK (Total >= 0),
		CONSTRAINT CK_compra_cantidad CHECK (Cantidad > 0)
	);
END
    
IF OBJECT_ID('Ventas.Pago', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Pago
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Metodo VARCHAR(100) NOT NULL,
		Monto DECIMAL(11,2) NOT NULL,
		Estado CHAR(1) NOT NULL,
		ID_compra INT NOT NULL UNIQUE,
		CONSTRAINT FK_pago_compra FOREIGN KEY (ID_compra) REFERENCES Ventas.Compra(ID),
		CONSTRAINT CK_pago_monto CHECK (Monto > 0),
		CONSTRAINT CK_pago_estado_Pago CHECK (Estado IN ('P','C','R', 'A', 'I')) -- Pendiente / Confirmado / Rechazado / Activo / Inactivo
		--activo e inactivo no son para ver el estado del pago, sino para ver si se debe tomar en cuenta la fila o no al recorrer la tabla
	);
END

IF OBJECT_ID('Ventas.Entrada', 'U') IS NULL
BEGIN
	CREATE TABLE Ventas.Entrada
	(
		ID INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		Fecha_acceso DATE NOT NULL,
		ID_cliente INT NOT NULL,
		ID_tarifa INT NOT NULL,
		ID_compra INT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo. no se refiere a si la entrada se puede usar en el parque o no
		--solo a si se debe tener en cuenta a la hora de leer la tabla
		CONSTRAINT check_Estado_Entrada CHECK (Estado in ('A', 'I')),
		CONSTRAINT FK_entrada_cliente FOREIGN KEY (ID_cliente) REFERENCES Ventas.Cliente(ID),
		CONSTRAINT FK_entrada_tarifa FOREIGN KEY (ID_tarifa) REFERENCES Ventas.Tarifa(ID),
		CONSTRAINT FK_entrada_compra FOREIGN KEY (ID_compra) REFERENCES Ventas.Compra(ID)
	);
END

--------------------ATRACCIONES-----------------------
IF OBJECT_ID('Atracciones.Tour', 'U') IS NULL
BEGIN
	CREATE TABLE Atracciones.Tour 
	(
		ID_Tour INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
		ID_Parque INT NOT NULL,
		Costo DECIMAL (11,2),
		Cupo_max INT NOT NULL,
		Tipo CHAR (1) NOT NULL, --que seria esto?
		Duracion INT NOT NULL, -- minutos
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tour CHECK (Estado in ('A', 'I')),
		CONSTRAINT check_cupo CHECK (Cupo_max > 0),
		CONSTRAINT check_duracion CHECK (Duracion > 0),
		CONSTRAINT FK_tour_parque FOREIGN KEY (ID_parque) REFERENCES Parque.Parque(ID)
	);
END

IF OBJECT_ID('Atracciones.R_Tour_Guia', 'U') IS NULL
BEGIN
	CREATE TABLE Atracciones.R_Tour_Guia
	(
		ID_Tour INT NOT NULL,
		ID_Guia INT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tour_guia CHECK (Estado in ('A', 'I')),
		CONSTRAINT PK_tour_guia PRIMARY KEY (ID_tour, ID_guia),
		CONSTRAINT FK_tour_guia_t FOREIGN KEY (ID_tour) REFERENCES Atracciones.Tour(ID_Tour),
		CONSTRAINT FK_tour_guia_g FOREIGN KEY (ID_guia) REFERENCES Empleados.Guia(ID_Empleado)
	);
END

IF OBJECT_ID('Atracciones.R_Tour_Entrada', 'U') IS NULL
BEGIN
	CREATE TABLE Atracciones.R_Tour_Entrada 
	(
		ID_Tour INT NOT NULL,
		ID_Entrada INT NOT NULL,
		Estado CHAR(1) NOT NULL DEFAULT 'a', --a: activo, i: inactivo
		CONSTRAINT check_Estado_Tour_Entrada CHECK (Estado in ('A', 'I')),
		CONSTRAINT PK_tour_entrada PRIMARY KEY (ID_Tour, ID_Entrada),
		CONSTRAINT FK_tour_entrada_t FOREIGN KEY (ID_tour) REFERENCES Atracciones.Tour(ID_Tour),
		CONSTRAINT FK_tour_entrada_e FOREIGN KEY (ID_entrada) REFERENCES Ventas.Entrada(ID)
	);
END
