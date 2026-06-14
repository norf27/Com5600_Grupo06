
use sist_gestion_parques
go

----------------Parque------------
print '=================Tipo parque================='
--dar de alta:
declare @ID int
exec @ID = Parque.SP_TipoParque_Alta @Nombre = 'Acuatico', @Descripcion = 'es humedo'
select * from Parque.Tipo_parque
--dar de baja (estado cambia a inactivo)
exec Parque.SP_TipoParque_Baja @ID = @ID
select * from Parque.Tipo_parque
--dar de alta cambiando la descripcion (estado pasa a activo y cambia la descripcion)
exec @ID = Parque.SP_TipoParque_Alta @Nombre = 'Acuatico', @Descripcion = 'ahora es todavia mas humedo'
select * from Parque.Tipo_parque
--probar de dar de alta cuando sigue como activo
begin try
exec Parque.SP_TipoParque_Alta @Nombre = 'Acuatico', @Descripcion = 'no importa'
end try
begin catch
print error_message()
end catch
--modificar datos de el parque
exec Parque.SP_TipoParque_Modificar @ID = @ID, @Nombre = ' nombre acuatico', @NuevaDesc = 'Nueva descripcion acuatica'
select * from Parque.Tipo_parque
--probar de insertar con algun error o varios
--nombre null
begin try
exec Parque.SP_TipoParque_Alta @Nombre = null, @Descripcion = 'ahora es todavia mas humedo'
end try
begin catch
print error_message()
end catch
--desc null
begin try
exec Parque.SP_TipoParque_Alta @Nombre = 'Tipo', @Descripcion = null
end try
begin catch
print error_message()
end catch
--ambos null
begin try
exec Parque.SP_TipoParque_Alta @Nombre = null, @Descripcion = null
end try
begin catch
print error_message()
end catch

print '=================Provincia================='
--dar de alta:

exec @ID = Parque.SP_Provincia_Alta @Nombre = 'Cordoba'
select * from Parque.Provincia
--dar de baja (estado cambia a inactivo)
exec Parque.SP_Provincia_Baja @ID = @ID
select * from Parque.Provincia
--dar de alta de vuelta (estado pasa a activo)
exec @ID = Parque.SP_Provincia_Alta @Nombre = 'Cordoba'
select * from Parque.Provincia
--probar de dar de alta cuando sigue como activo
begin try
exec Parque.SP_Provincia_Alta @Nombre = 'Cordoba'
end try
begin catch
print error_message()
end catch
--modificar datos
exec Parque.SP_Provincia_Modificar @ID = @ID, @Nombre = 'Mendoza ahora'
select * from Parque.Provincia
--probar de insertar con algun error o varios
--nombre null
begin try
exec Parque.SP_Provincia_Alta @Nombre = null
end try
begin catch
print error_message()
end catch

print '=================Parque================='
--dar de alta:
exec @ID =  Parque.SP_Parque_Alta @Superficie = 180, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1
select * from Parque.parque
--dar de baja (estado cambia a inactivo)
exec Parque.SP_Parque_Baja @ID = @ID
select * from Parque.parque
--dar de alta cambiando la superficie (estado pasa a activo y cambia la descripcion)
exec @ID = Parque.SP_Parque_Alta @Superficie = 2000, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1
select * from Parque.parque
--probar de dar de alta cuando sigue como activo
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1
end try
begin catch
print error_message()
end catch
--modificar datos de el parque
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre = ' parque de la costa', @ID_tipo = 1, @ID_provincia = 1
select * from Parque.parque
--probar de insertar con algun error o varios
--superficie null
begin try
exec Parque.SP_Parque_Alta @Superficie = null, @Nombre = 'Parque de la unlam', @ID_tipo = 1, @ID_provincia = 1
end try
begin catch
print error_message()
end catch
--nombre null
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  null, @ID_tipo = 1, @ID_provincia = 1
end try
begin catch
print error_message()
end catch
--ID tipo null
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  'parque', @ID_tipo = null, @ID_provincia = 1
end try
begin catch
print error_message()
end catch
--ID tipo no existe
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  'parque', @ID_tipo = -1, @ID_provincia = 1
end try
begin catch
print error_message()
end catch
--varios a la vez
begin try
exec Parque.SP_Parque_Alta @Superficie = -1, @Nombre =  null, @ID_tipo = null, @ID_provincia = 255
end try
begin catch
print error_message()
end catch

-----------------------------Empleados-------------------------

print '=================Empleado================='
--dar de alta:
Exec @ID = Empleados.SP_Empleado_Alta @Nacimiento = '2001-01-01', @DNI = '46960693', @Nombre = 'Nicolas Orfano', @Sueldo = 170.3, @ID_parque = 1, @CUIL = '20-46960693-1'
select * from Empleados.Empleado

--dar de baja (estado cambia a inactivo)
exec Empleados.SP_Empleado_Baja @ID = @ID 
select * from Empleados.Empleado
--dar de alta cambiando el sueldo (estado pasa a activo y cambia la descripcion)
Exec @ID = Empleados.SP_Empleado_Alta @Nacimiento = '2001-01-01', @DNI = '46960693', @Nombre = 'Nicolas Orfano', @Sueldo = 190.3, @ID_parque = 1, @CUIL = '20-46960693-1'
select * from Empleados.Empleado
--probar de dar de alta cuando sigue como activo
begin try
Exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-01-01', @DNI = '46960693', @Nombre = 'Nicolas Orfano', @Sueldo = 170.3, @ID_parque = 1, @CUIL = '20-46960693-1'
select * from Empleados.Empleado
end try
begin catch
print error_message()
end catch
--modificar datos
exec Empleados.SP_Empleado_Modificar @ID = @ID, @Nacimiento = '2001-01-01', @DNI = '111111111', @Nombre = 'Dibu Martinez', @Sueldo = 170.3, @Estado = 'v', @ID_parque = 1, @CUIL = '20-11111111-1'
select * from Empleados.Empleado
--probar de insertar con algun error o varios
--menor de edad
begin try
Exec Empleados.SP_Empleado_Alta @Nacimiento = '2019-01-01', @DNI = '46960693', @Nombre = 'Nicolas Orfano', @Sueldo = 170.3, @ID_parque = 1, @CUIL = '20-46960693-1'
end try
begin catch
print error_message()
end catch
--dni de formato invalido, nombre null y parque inexistente
begin try
Exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-01-01', @DNI = '1234', @Nombre = null, @Sueldo = 170.3, @ID_parque = -1, @CUIL = '20-46960693-1'
end try
begin catch
print error_message()
end catch
--cuil mal escrito y sueldo negativo
begin try
Exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-01-01', @DNI = '46960693', @Nombre = 'Nicolas Orfano', @Sueldo = -33, @ID_parque = 1, @CUIL = 'invalido'
end try
begin catch
print error_message()
end catch

--------------------CONSECIONES-----------------------
print '=================Tipo Actividad================='
--dar de alta:
exec @ID = Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de comida rapida', @Descripcion = 'venta de comida rapida en algun lado'
select * from Concesiones.Tipo_actividad
--dar de baja (estado cambia a inactivo)
exec Concesiones.SP_TipoActividad_Baja @ID = @ID
select * from Concesiones.Tipo_actividad
--dar de alta cambiando la desc (estado pasa a activo y cambia la descripcion)
exec @ID = Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de comida rapida', @Descripcion = 'venta de comida rapida en la entrada'
select * from Concesiones.Tipo_actividad
--probar de dar de alta cuando sigue como activo
begin try
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de comida rapida', @Descripcion = 'venta de comida rapida en la entrada'
end try
begin catch
print error_message()
end catch
--modificar datos
exec Concesiones.SP_TipoActividad_Modificar @ID = @ID, @Nombre = 'venta de comida saludable', @NuevaDesc = 'venta de comida saludable en algun lado'
select * from Concesiones.Tipo_actividad
--probar de insertar con algun error o varios
--nombre null
begin try
exec Concesiones.SP_TipoActividad_Alta @Nombre = null, @Descripcion = 'venta de comida rapida en la entrada'
end try
begin catch
print error_message()
end catch
--descripcion null
begin try
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de comida rapida', @Descripcion = null
end try
begin catch
print error_message()
end catch
--ambos null
begin try
exec Concesiones.SP_TipoActividad_Alta @Nombre = null, @Descripcion = null
end try
begin catch
print error_message()
end catch

print '=================Empresa================='
--dar de alta:
exec @ID = Concesiones.SP_Empresa_Alta @Nombre = 'Burguer queen', @CUIT = '10-12345678-0', @Correo = 'BurguerQ@gmail.com'
select * from Concesiones.Empresa
--dar de baja (estado cambia a inactivo)
exec Concesiones.SP_Empresa_Baja @ID = @ID
select * from Concesiones.Empresa
--dar de alta cambiando el correo (estado pasa a activo y cambia la descripcion)
exec @ID = Concesiones.SP_Empresa_Alta @Nombre = 'Burguer queen', @CUIT = '10-12345678-0', @Correo = 'HamburgueseriaBQ@gmail.com'
select * from Concesiones.Empresa
--probar de dar de alta cuando sigue como activo
begin try
exec Concesiones.SP_Empresa_Alta @Nombre = 'Burguer queen', @CUIT = '10-12345678-0', @Correo = 'HamburgueseriaBQ@gmail.com'
end try
begin catch
print error_message()
end catch
--modificar datos
exec Concesiones.SP_Empresa_Modificar @ID = @ID, @Nombre = 'Pizza queen', @CUIT = '10-12345678-0', @Correo = 'PizzeriaBQ@gmail.com'
select * from Concesiones.Empresa
--probar de insertar con algun error o varios
--nombre null y cuit repetido
begin try
exec Concesiones.SP_Empresa_Alta @Nombre = null, @CUIT = '10-12345678-0', @Correo = 'HamburgueseriaBQ@gmail.com'
end try
begin catch
print error_message()
end catch
--cuit invalido
begin try
exec Concesiones.SP_Empresa_Alta @Nombre = 'Burguer queen', @CUIT = 'error', @Correo = 'HamburgueseriaBQ@gmail.com'
end try
begin catch
print error_message()
end catch
--correo null y cuit repetido
begin try
exec Concesiones.SP_Empresa_Alta @Nombre = 'Burguer queen', @CUIT = '10-12345678-0', @Correo = null
end try
begin catch
print error_message()
end catch
--todo mal
begin try
exec Concesiones.SP_Empresa_Alta @Nombre = null, @CUIT = '10-err-0', @Correo = null
end try
begin catch
print error_message()
end catch

print '=================Concesion================='
--dar de alta:
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = '2024-01-01', @Fecha_fin = '2024-02-01', @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
select * from Concesiones.Concesion
--dar de baja (estado cambia a inactivo)
exec Concesiones.SP_Concesion_Baja @ID = @ID
select * from Concesiones.Concesion
--dar de alta de vuelta(en esta tabla siempre se crea una nueva salvo que sea todo igual)
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = '2024-01-01', @Fecha_fin = '2024-02-01', @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
select * from Concesiones.Concesion
--probar de dar de alta cuando sigue como activo
begin try
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = '2024-01-01', @Fecha_fin = '2024-02-01', @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
end try
begin catch
print error_message()
end catch
--modificar datos
exec Concesiones.SP_Concesion_Modificar @ID = @ID, @Fecha_inicio = '2024-01-11', @Fecha_fin = '2024-09-28', @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
select * from Concesiones.Concesion
--probar de insertar con algun error o varios
--fecha inicio mayor que fecha fin
begin try
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = '2026-01-01', @Fecha_fin = '2024-02-01', @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
end try
begin catch
print error_message()
end catch
--fechas null
begin try
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = null, @Fecha_fin = null, @ID_empresa = 1, @ID_tipo = 1, @ID_parque = 1
end try
begin catch
print error_message()
end catch
--ids invalidos
begin try
exec @ID = Concesiones.SP_Concesion_Alta @Fecha_inicio = '2024-01-01', @Fecha_fin = '2024-02-01', @ID_empresa = -1, @ID_tipo = -1, @ID_parque = -1
end try
begin catch
print error_message()
end catch


print '=================Pago mensual================='
--dar de alta: (queda como deudor al registrar)
exec @ID = Concesiones.SP_PagoMensual_Alta @Fecha = '2024-02-02', @Monto = 190.33, @Metodo = 'Tarjeta', @ID_concesion = 1
select * from Concesiones.Pago_mensual
--dar de baja (estado cambia a inactivo)
exec Concesiones.SP_PagoMensual_Baja @ID = @ID
select * from Concesiones.Pago_mensual
--dar de alta de vuelta con otro metodo
exec @ID = Concesiones.SP_PagoMensual_Alta @Fecha = '2024-02-02', @Monto = 190.33, @Metodo = 'Efectivo', @ID_concesion = 1
select * from Concesiones.Pago_mensual
--probar de dar de alta cuando sigue como activo
begin try
exec Concesiones.SP_PagoMensual_Alta @Fecha = '2024-02-02', @Monto = 190.33, @Metodo = 'Efectivo', @ID_concesion = 1
end try
begin catch
print error_message()
end catch
--modificar datos
exec Concesiones.SP_PagoMensual_Modificar @ID = @ID, @Fecha = '2024-03-02', @Monto = 190.33, @Metodo = 'Efectivo', @ID_concesion = 1, @Pago = 'P'
select * from Concesiones.Pago_mensual
--probar de insertar con algun error o varios
--fecha menor a la fecha de inicio de su consecion
begin try
exec Concesiones.SP_PagoMensual_Alta @Fecha = '2001-01-01', @Monto = 190.33, @Metodo = 'Efectivo', @ID_concesion = 1
end try
begin catch
print error_message()
end catch
--fecha mayor al fin de su consecion
begin try
exec Concesiones.SP_PagoMensual_Alta @Fecha = '2090-01-01', @Monto = 190.33, @Metodo = 'Efectivo', @ID_concesion = 1
end try
begin catch
print error_message()
end catch
--monto negativo e id invalido
begin try
exec Concesiones.SP_PagoMensual_Alta @Fecha = '2021-01-01', @Monto = -30, @Metodo = 'Efectivo', @ID_concesion = -1
end try
begin catch
print error_message()
end catch