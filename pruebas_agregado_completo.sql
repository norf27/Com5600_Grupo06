-- Pruebas automáticas para generacionProcAgregadoSP.sql
USE sist_gestion_parques;
GO


PRINT '===== Parque.AñadirTipo_parque =====';
BEGIN TRY
    EXEC Parque.AñadirTipo_parque @Nombre=NULL, @Descripcion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirTipo_parque @Nombre=NULL, @Descripcion='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirTipo_parque @Nombre='TEST', @Descripcion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.AñadirProvincia =====';
BEGIN TRY
    EXEC Parque.AñadirProvincia @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirProvincia @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.AñadirParque =====';
BEGIN TRY
    EXEC Parque.AñadirParque @Superficie=NULL, @Nombre=NULL, @ID_tipo=NULL, @ID_provincia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirParque @Superficie=NULL, @Nombre='TEST', @ID_tipo=-999999, @ID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirParque @Superficie=-999999, @Nombre=NULL, @ID_tipo=-999999, @ID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirParque @Superficie=-999999, @Nombre='TEST', @ID_tipo=NULL, @ID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.AñadirParque @Superficie=-999999, @Nombre='TEST', @ID_tipo=-999999, @ID_provincia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.AnadirGuardaparque =====';
BEGIN TRY
    EXEC Empleados.AnadirGuardaparque @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirGuardaparque @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.AnadirR_Guardaparque_Parque =====';
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=NULL, @ID_Parque=NULL, @Fecha_ingreso=NULL, @Fecha_egreso=NULL, @Motivo_egreso=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=NULL, @ID_Parque=-999999, @Fecha_ingreso='2001-01-01', @Fecha_egreso='2001-03-03', @Motivo_egreso='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=-999999, @ID_Parque=NULL, @Fecha_ingreso='2001-01-01', @Fecha_egreso='2001-03-03', @Motivo_egreso='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=-999999, @ID_Parque=-999999, @Fecha_ingreso='2001-01-01', @Fecha_egreso='2001-03-03', @Motivo_egreso='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=-999999, @ID_Parque=-999999, @Fecha_ingreso='2001-01-01', @Fecha_egreso=NULL, @Motivo_egreso='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AnadirR_Guardaparque_Parque @ID_Guardaparque=-999999, @ID_Parque=-999999, @Fecha_ingreso='2001-01-01', @Fecha_egreso='2001-03-03', @Motivo_egreso=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.AñadirEmpleado =====';
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento=NULL, @DNI=NULL, @Nombre=NULL, @Sueldo=NULL, @Estado=NULL, @ID_parque=NULL, @CUIL=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento=NULL, @DNI='TEST', @Nombre='TEST', @Sueldo=-999999, @Estado='TEST', @ID_parque=-999999, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2019-01-01', @DNI=NULL, @Nombre='TEST', @Sueldo=-999999, @Estado='TEST', @ID_parque=-999999, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2001-01-01', @DNI='TEST', @Nombre=NULL, @Sueldo=-999999, @Estado='TEST', @ID_parque=-999999, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2001-01-01', @DNI='TEST', @Nombre='TEST', @Sueldo=NULL, @Estado='TEST', @ID_parque=-999999, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2001-01-01', @DNI='TEST', @Nombre='TEST', @Sueldo=-999999, @Estado=NULL, @ID_parque=-999999, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2001-01-01', @DNI='TEST', @Nombre='TEST', @Sueldo=-999999, @Estado='TEST', @ID_parque=NULL, @CUIL='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.AñadirEmpleado @Nacimiento='2001-01-01', @DNI='TEST', @Nombre='TEST', @Sueldo=-999999, @Estado='TEST', @ID_parque=-999999, @CUIL=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_Guia =====';
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre=NULL, @DNI=NULL, @CUIL=NULL, @Nacimiento=NULL, @Sueldo=NULL, @Estado=NULL, @ID_Parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre=NULL, @DNI='TEST', @CUIL='TEST', @Nacimiento='2001-01-01', @Sueldo=-999999, @Estado='TEST', @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI=NULL, @CUIL='TEST', @Nacimiento='2001-01-01', @Sueldo=-999999, @Estado='TEST', @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI='TEST', @CUIL=NULL, @Nacimiento='2001-01-01', @Sueldo=-999999, @Estado='TEST', @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI='TEST', @CUIL='TEST', @Nacimiento=NULL, @Sueldo=-999999, @Estado='TEST', @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI='TEST', @CUIL='TEST', @Nacimiento='2001-01-01', @Sueldo=NULL, @Estado='TEST', @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI='TEST', @CUIL='TEST', @Nacimiento='2001-01-01', @Sueldo=-999999, @Estado=NULL, @ID_Parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Guia @Nombre='TEST', @DNI='TEST', @CUIL='TEST', @Nacimiento='2001-01-01', @Sueldo=-999999, @Estado='TEST', @ID_Parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Agr_Habilitacion @Detalles=NULL, @Fecha=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Habilitacion @Detalles=NULL, @Fecha='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Habilitacion @Detalles='TEST', @Fecha=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Agr_Especialidad @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Especialidad @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_Titulo =====';
BEGIN TRY
    EXEC Empleados.Agr_Titulo @Nombre=NULL, @Fecha='2001-01-01', @Origen=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Titulo @Nombre=NULL, @Fecha='2001-01-01', @Origen='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Titulo @Nombre='TEST', @Fecha=NULL, @Origen='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_Titulo @Nombre='TEST', @Fecha='2001-01-01', @Origen=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_R_Guia_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Habilitacion @ID_Guia=NULL, @Detalles=NULL, @Fecha=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Habilitacion @ID_Guia=NULL, @Detalles='TEST', @Fecha='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Habilitacion @ID_Guia=-999999, @Detalles=NULL, @Fecha='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Habilitacion @ID_Guia=-999999, @Detalles='TEST', @Fecha=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_R_Guia_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Especialidad @ID_Guia=NULL, @Nombre_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Especialidad @ID_Guia=NULL, @Nombre_Especialidad='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Especialidad @ID_Guia=-999999, @Nombre_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Agr_R_Guia_Titulo =====';
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Titulo @ID_Guia=NULL, @Nombre_Titulo=NULL, @Fecha_Titulo=NULL, @Origen_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Titulo @ID_Guia=NULL, @Nombre_Titulo='TEST', @Fecha_Titulo='2001-01-01', @Origen_Titulo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Titulo @ID_Guia=-999999, @Nombre_Titulo=NULL, @Fecha_Titulo='2001-01-01', @Origen_Titulo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Titulo @ID_Guia=-999999, @Nombre_Titulo='TEST', @Fecha_Titulo=NULL, @Origen_Titulo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Agr_R_Guia_Titulo @ID_Guia=-999999, @Nombre_Titulo='TEST', @Fecha_Titulo='2001-01-01', @Origen_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.AñadirTipo_actividad =====';
BEGIN TRY
    EXEC Concesiones.AñadirTipo_actividad @Nombre=NULL, @Descripcion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirTipo_actividad @Nombre=NULL, @Descripcion='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirTipo_actividad @Nombre='TEST', @Descripcion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.AñadirEmpresa =====';
BEGIN TRY
    EXEC Concesiones.AñadirEmpresa @Nombre=NULL, @CUIT=NULL, @Correo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirEmpresa @Nombre=NULL, @CUIT='TEST', @Correo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirEmpresa @Nombre='TEST', @CUIT=NULL, @Correo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirEmpresa @Nombre='TEST', @CUIT='TEST', @Correo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.AñadirConcesion =====';
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio=NULL, @Fecha_fin=NULL, @ID_empresa=NULL, @ID_tipo=NULL, @ID_parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio='2001-01-01', @Fecha_fin='2001-01-01', @ID_empresa=-999999, @ID_tipo=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio='2001-01-01', @Fecha_fin=NULL, @ID_empresa=-999999, @ID_tipo=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio='2000-01-01', @Fecha_fin='2001-01-01', @ID_empresa=NULL, @ID_tipo=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio='2001-01-01', @Fecha_fin='2001-01-03', @ID_empresa=-999999, @ID_tipo=NULL, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirConcesion @Fecha_inicio='2001-01-01', @Fecha_fin='2001-01-03', @ID_empresa=-999999, @ID_tipo=-999999, @ID_parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.AñadirPago_mensual =====';
BEGIN TRY
    EXEC Concesiones.AñadirPago_mensual @Fecha=NULL, @Monto=NULL, @Metodo=NULL, @ID_concesion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirPago_mensual @Fecha=NULL, @Monto=-999999, @Metodo='TEST', @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirPago_mensual @Fecha='2001-01-01', @Monto=NULL, @Metodo='TEST', @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirPago_mensual @Fecha='2001-01-01', @Monto=-999999, @Metodo=NULL, @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.AñadirPago_mensual @Fecha='2001-01-01', @Monto=-999999, @Metodo='TEST', @ID_concesion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Cliente_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_Cliente_Alta @Nombre=NULL, @Documento=NULL, @Tipo_doc=NULL, @Nacimiento=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Alta @Nombre=NULL, @Documento='TEST', @Tipo_doc='TEST', @Nacimiento='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Alta @Nombre='TEST', @Documento=NULL, @Tipo_doc='TEST', @Nacimiento='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Alta @Nombre='TEST', @Documento='TEST', @Tipo_doc=NULL, @Nacimiento='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Alta @Nombre='TEST', @Documento='TEST', @Tipo_doc='TEST', @Nacimiento=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_TipoVisitante_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Alta @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Alta @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Tarifa_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde=NULL, @Fecha_hasta=NULL, @Precio=NULL, @ID_tipo_visitante=NULL, @ID_parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde=NULL, @Fecha_hasta='2001-01-01', @Precio=-999999, @ID_tipo_visitante=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde='2001-01-01', @Fecha_hasta=NULL, @Precio=-999999, @ID_tipo_visitante=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde='2001-01-01', @Fecha_hasta='2001-01-03', @Precio=NULL, @ID_tipo_visitante=-999999, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde='2001-01-01', @Fecha_hasta='2001-01-01', @Precio=-999999, @ID_tipo_visitante=NULL, @ID_parque=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Alta @Fecha_desde='2001-01-01', @Fecha_hasta='2001-01-01', @Precio=-999999, @ID_tipo_visitante=-999999, @ID_parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Entrada_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_Entrada_Alta @Fecha_acceso=NULL, @ID_cliente=NULL, @ID_tarifa=NULL, @ID_compra=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Alta @Fecha_acceso=NULL, @ID_cliente=-999999, @ID_tarifa=-999999, @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Alta @Fecha_acceso='2001-01-01', @ID_cliente=NULL, @ID_tarifa=-999999, @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Alta @Fecha_acceso='2001-01-01', @ID_cliente=-999999, @ID_tarifa=NULL, @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Alta @Fecha_acceso='2001-01-01', @ID_cliente=-999999, @ID_tarifa=-999999, @ID_compra=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Compra_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_Compra_Alta @Fecha=NULL, @Total=NULL, @Cantidad=NULL, @Punto_venta=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Alta @Fecha=NULL, @Total=-999999, @Cantidad=-999999, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Alta @Fecha='2001-01-01', @Total=NULL, @Cantidad=-999999, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Alta @Fecha='2001-01-01', @Total=-999999, @Cantidad=NULL, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Alta @Fecha='2001-01-01', @Total=-999999, @Cantidad=-999999, @Punto_venta=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Pago_Alta =====';
BEGIN TRY
    EXEC Ventas.SP_Pago_Alta @Metodo=NULL, @Monto=NULL, @Estado=NULL, @ID_compra=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Alta @Metodo=NULL, @Monto=-999999, @Estado='TEST', @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Alta @Metodo='TEST', @Monto=NULL, @Estado='TEST', @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Alta @Metodo='TEST', @Monto=-999999, @Estado=NULL, @ID_compra=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Alta @Metodo='TEST', @Monto=-999999, @Estado='TEST', @ID_compra=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== AnadirTour =====';
BEGIN TRY
    EXEC AnadirTour @Costo=NULL, @Cupo_max=NULL, @Tipo=NULL, @Duracion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirTour @Costo=NULL, @Cupo_max=-999999, @Tipo='TEST', @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirTour @Costo=-999999, @Cupo_max=NULL, @Tipo='TEST', @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirTour @Costo=-999999, @Cupo_max=-999999, @Tipo=NULL, @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirTour @Costo=-999999, @Cupo_max=-999999, @Tipo='TEST', @Duracion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== AnadirR_Tour_Guia =====';
BEGIN TRY
    EXEC AnadirR_Tour_Guia @ID_Tour=NULL, @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirR_Tour_Guia @ID_Tour=NULL, @ID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirR_Tour_Guia @ID_Tour=-999999, @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== AnadirR_Tour_Entrada =====';
BEGIN TRY
    EXEC AnadirR_Tour_Entrada @ID_Tour=NULL, @ID_Entrada=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirR_Tour_Entrada @ID_Tour=NULL, @ID_Entrada=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC AnadirR_Tour_Entrada @ID_Tour=-999999, @ID_Entrada=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
