/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion:
Sentencias para creacion de roles.
*/

use sist_gestion_parques;
go

-- admin (control de todo)
create role Rol_Admin;

-- programador: DDL en todos los esquemas
create role Rol_Programador;

-- gerente de RRHH: empleados, guías, especializaciones, etc.
create role Rol_Gerente_RRHH;

-- gerente de ventas: todo lo relacionado a entradas, tickets y ventas
create role Rol_Gerente_Ventas;

-- gerente de concesiones: manejo de concesiones y sus pagos mensuales
create role Rol_Gerente_Concesiones;

-- gerente de tours: atracciones, tours, guías asignados a tours, etc.
create role Rol_Gerente_Tours;

-- gerente general: infraestructura de parques y tipos de parques
create role Rol_Gerente_General;

-- importar datos
create role Rol_Importador_Datos;

-- cajero: solo registrar ventas
create role Rol_Cajero;
go

-- admin
-- agregar admin como dueño de la base de datos
alter role db_owner add member Rol_Admin;
go

-- programador
-- crear, modificar y borrar tablas en la base de datos
grant alter to Rol_Programador;
grant create table to Rol_Programador;
grant create procedure to Rol_Programador;
grant create view to Rol_Programador;
grant create function to Rol_Programador;
go

-- gerente de RRHH
-- lectura de esquema de empleados
grant select on schema::Empleados to Rol_Gerente_RRHH;
-- ejecutar procedures de empleados (dar de alta, baja y modificar)
grant execute on schema::Empleados to Rol_Gerente_RRHH;
go

-- gerente de ventas
-- lectura de esquema de ventas
grant select on schema::Ventas to Rol_Gerente_Ventas;
-- ejecutar procedures ABM
grant execute on schema::Ventas to Rol_Gerente_Ventas;
go

-- gerente de concesiones
-- lectura de tablas y ejecucion de procedures ABM
grant select on schema::Concesiones to Rol_Gerente_Concesiones;
grant execute on schema::Concesiones to Rol_Gerente_Concesiones;
-- pero que no pueda agregar concesiones de forma manual, solo a traves de SP_RegistrarConcesion
deny execute on Concesiones.SP_Concesion_Alta to Rol_Gerente_General;
-- lo mismo pero con pago
deny execute on Concesiones.SP_PagoMensual_Alta to Rol_Gerente_General;
--que no pueda
go

-- gerente de tours
-- lectura y execute de procedures ABM
grant select on schema::Atracciones to Rol_Gerente_Tours;
grant execute on schema::Atracciones to Rol_Gerente_Tours;
-- que no pueda usar el dar de alta guias o tours de forma manual, solo con los procedures de logica de negocio
deny execute on Atracciones.SP_TourGuia_Alta to Rol_Gerente_General;
deny execute on Atracciones.SP_Tour_Alta to Rol_Gerente_General;
go

-- gerente general
-- lectura y escritura de parques
grant select on schema::Parque to Rol_Gerente_General;
grant execute on schema::Parque to Rol_Gerente_General;
-- pero que no pueda tocar nada de provincia (nunca las deberia cargar manualmente, para esto esta el importar dataset de provs)
deny execute on Parque.SP_Provincia_Alta to Rol_Gerente_General;
deny execute on Parque.SP_Provincia_Baja to Rol_Gerente_General;
deny execute on Parque.SP_Provincia_Modificar to Rol_Gerente_General;

go

-- importar datos
-- permisos sobre el esquema staging
grant select, insert, update, delete on schema::Staging to Rol_Importador_Datos;
grant execute on schema::Staging to Rol_Importador_Datos;
go

-- cajero (no puede hacer nada mas que ejecutar el procedure de registrar ventas)
grant execute on Ventas.SP_RegistrarVenta to Rol_Cajero;
go