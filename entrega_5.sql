create database sist_gestion_parques
collate Latin1_General_CI_AI;
go
use sist_gestion_parques
go
--INFO PARQUE
create table Tipo_parque
(
ID bigint primary key clustered identity(1,1),
Nombre varchar(100) not null,
Descripcion varchar(250) not null
)

create table Provincia
(
ID bigint primary key clustered identity(1,1),
Nombre varchar(100) not null
)

create table Parque
(
ID bigint primary key clustered identity(1,1),
Superficie int not null,
Nombre varchar(100) not null,
ID_tipo bigint not null,
ID_provincia bigint not null,
constraint check_superficie check (superficie > 0),
constraint FK_tipo_parque foreign key (ID_tipo) references Tipo_parque(ID),
constraint FK_provincia foreign key (ID_provincia) references Provincia(ID)
)

create table Empleado --agregar chequeo de estados cuando determinemos cuales puede ser EJ: inactivo, activo, licencia, etc
(
ID bigint primary key clustered identity (1,1),
Nacimiento date not null,
DNI varchar(8) not null unique,
Nombre varchar(100) not null,
Sueldo decimal(11,2) not null,
Estado char(1) not null,
ID_parque bigint not null,
CUIL varchar(13) not null,
constraint FK_parque foreign key (ID_parque) references Parque(ID),
constraint check_DNI check (DNI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
constraint check_sueldo check (sueldo > 0),
constraint check_nacimiento check (nacimiento <= dateadd(year, -18, cast(getdate() as date))), --que sea >= 18 años
constraint check_CUIL check (CUIL like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]')
)
--CONCESIONES
create table Tipo_actividad
(
ID bigint primary key clustered identity(1,1),
Nombre varchar(100) not null
)

create table Empresa
(
ID bigint primary key clustered identity(1,1),
Nombre varchar(100) not null,
CUIT varchar(13) not null,
Correo varchar(100) not null,
constraint check_CUIT check (CUIT like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]')
)

create table Concesion --ver estados posibles para agregar check
(
ID bigint primary key clustered identity(1,1),
Fecha_inicio date not null,
Fecha_fin date not null,
Estado char(1),
ID_empresa bigint not null,
ID_tipo bigint not null,
ID_parque bigint not null,
constraint FK_empresa foreign key (ID_empresa) references Empresa(ID),
constraint FK_tipo_actividad foreign key (ID_tipo) references Tipo_actividad(ID),
constraint FK_parque foreign key (ID_parque) references Parque(ID)
)

create table Pago_mensual --ver estados posibles para check
(
ID bigint primary key clustered identity(1,1),
Monto decimal(11,2) not null,
Estado char(1) not null,
Metodo varchar(100) not null,
ID_concesion bigint not null,
constraint FK_concesion foreign key (ID_concesion) references Concesion(ID),
constraint check_monto check (monto > 0)
)

--GUARDAPARQUES Y GUIAS
CREATE TABLE Guardaparque (
    ID_Empleado BIGINT PRIMARY KEY,
    CONSTRAINT FK_Guardaparque_Empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID) ON DELETE CASCADE
);
CREATE TABLE Guardaparque_Parque (
    ID_Guardaparque BIGINT,
    ID_Parque INT, 
    Fecha_ingreso DATE NOT NULL,
    Fecha_egreso DATE NULL,
    Motivo_egreso VARCHAR(255) NULL,
    
    PRIMARY KEY (ID_Guardaparque, ID_Parque, Fecha_ingreso),
    CONSTRAINT FK_GuardaparqueParque_Guardaparque FOREIGN KEY (ID_Guardaparque) REFERENCES Guardaparque(ID_Empleado),
    CONSTRAINT CK_GuardaparqueParque_Fechas CHECK (Fecha_egreso IS NULL OR Fecha_egreso >= Fecha_ingreso),
    CONSTRAINT CK_GuardaparqueParque_ConsistenciaEgreso CHECK (
        (Fecha_egreso IS NULL AND Motivo_egreso IS NULL) OR 
        (Fecha_egreso IS NOT NULL AND Motivo_egreso IS NOT NULL)
    )
);
CREATE TABLE Guia (
    ID_Empleado BIGINT PRIMARY KEY,
    CONSTRAINT FK_Guia_Empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID) ON DELETE CASCADE
);
CREATE TABLE Habilitacion (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Detalles VARCHAR(100) NOT NULL,
    Fecha DATE NOT NULL
);
CREATE TABLE Guia_Habilitacion (
    ID_Guia BIGINT,
    ID_Habilitacion INT,
    PRIMARY KEY (ID_Guia, ID_Habilitacion),
    CONSTRAINT FK_GuiaHabilitacion_Guia FOREIGN KEY (ID_Guia) REFERENCES Guia(ID_Empleado),
    CONSTRAINT FK_GuiaHabilitacion_Habilitacion FOREIGN KEY (ID_Habilitacion) REFERENCES Habilitacion(ID)
);
CREATE TABLE Especialidad (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);
CREATE TABLE Guia_Especialidad (
    ID_Guia BIGINT,
    ID_Especialidad INT,
    PRIMARY KEY (ID_Guia, ID_Especialidad),
    CONSTRAINT FK_GuiaEspecialidad_Guia FOREIGN KEY (ID_Guia) REFERENCES Guia(ID_Empleado),
    CONSTRAINT FK_GuiaEspecialidad_Especialidad FOREIGN KEY (ID_Especialidad) REFERENCES Especialidad(ID)
);

CREATE TABLE Titulo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Fecha DATE NOT NULL,
    Origen VARCHAR(100) NOT NULL
);

CREATE TABLE Guia_Titulo (
    ID_Guia BIGINT,
    ID_Titulo INT,
    PRIMARY KEY (ID_Guia, ID_Titulo),
    CONSTRAINT FK_GuiaTitulo_Guia FOREIGN KEY (ID_Guia) REFERENCES Guia(ID_Empleado),
    CONSTRAINT FK_GuiaTitulo_Titulo FOREIGN KEY (ID_Titulo) REFERENCES Titulo(ID)
);
