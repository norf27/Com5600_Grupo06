-- Pruebas automáticas para generacionProcModificacion.sql
USE sist_gestion_parques;
GO


PRINT '===== Parque.ModificarTipo_parque =====';
BEGIN TRY
    EXEC Parque.ModificarTipo_parque @ID=NULL, @NuevoNombre=NULL, @NuevaDesc=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarTipo_parque @ID=NULL, @NuevoNombre='TEST', @NuevaDesc='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarTipo_parque @ID=-999999, @NuevoNombre=NULL, @NuevaDesc='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarTipo_parque @ID=-999999, @NuevoNombre='TEST', @NuevaDesc=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.ModificarProvincia =====';
BEGIN TRY
    EXEC Parque.ModificarProvincia @ID=NULL, @NuevoNombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarProvincia @ID=NULL, @NuevoNombre='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarProvincia @ID=-999999, @NuevoNombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.ModificarParque =====';
BEGIN TRY
    EXEC Parque.ModificarParque @ID=NULL, @NuevaSuperficie=NULL, @NuevoNombre=NULL, @NuevoID_tipo=NULL, @NuevoID_provincia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarParque @ID=NULL, @NuevaSuperficie=-999999, @NuevoNombre='TEST', @NuevoID_tipo=-999999, @NuevoID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarParque @ID=-999999, @NuevaSuperficie=NULL, @NuevoNombre='TEST', @NuevoID_tipo=-999999, @NuevoID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarParque @ID=-999999, @NuevaSuperficie=-999999, @NuevoNombre=NULL, @NuevoID_tipo=-999999, @NuevoID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarParque @ID=-999999, @NuevaSuperficie=-999999, @NuevoNombre='TEST', @NuevoID_tipo=NULL, @NuevoID_provincia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.ModificarParque @ID=-999999, @NuevaSuperficie=-999999, @NuevoNombre='TEST', @NuevoID_tipo=-999999, @NuevoID_provincia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.ModificarGuardaparque =====';
BEGIN TRY
    EXEC Empleados.ModificarGuardaparque @ID_Empleado=NULL, @NuevoID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.ModificarGuardaparque @ID_Empleado=NULL, @NuevoID_Empleado=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.ModificarGuardaparque @ID_Empleado=-999999, @NuevoID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.ModificarR_Guardaparque_Parque =====';
BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque @ID_Guardaparque=NULL, @ID_Parque=NULL, @Fecha_ingreso=NULL, @NuevoID_Guardaparque=NULL, @NuevoID_Parque=NULL, @NuevaFecha_ingreso=NULL, @NuevaFecha_egreso=NULL, @NuevoMotivo_egreso=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = NULL,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = NULL,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = NULL,
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = NULL,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = NULL,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = NULL,
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = NULL,
        @NuevoMotivo_egreso = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarR_Guardaparque_Parque
        @ID_Guardaparque = -999999,
        @ID_Parque = -999999,
        @Fecha_ingreso = '2024-01-01',
        @NuevoID_Guardaparque = -999999,
        @NuevoID_Parque = -999999,
        @NuevaFecha_ingreso = '2024-02-01',
        @NuevaFecha_egreso = '2024-12-31',
        @NuevoMotivo_egreso = NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.ModificarEmpleado =====';
BEGIN TRY
    EXEC Empleados.ModificarEmpleado @ID=NULL, @Nacimiento=NULL, @DNI=NULL, @Nombre=NULL, @Sueldo=NULL, @Estado=NULL, @ID_parque=NULL, @CUIL=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = NULL,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = NULL,
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = NULL,
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = NULL,
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = NULL,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = NULL,
        @ID_parque = -999999,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = NULL,
        @CUIL = 'TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Empleados.ModificarEmpleado
        @ID = -999999,
        @Nacimiento = '2000-01-01',
        @DNI = 'TEST',
        @Nombre = 'TEST',
        @Sueldo = -999999,
        @Estado = 'TEST',
        @ID_parque = -999999,
        @CUIL = NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
PRINT '===== Empleados.Modificar_Guia =====';
BEGIN TRY
    EXEC Empleados.Modificar_Guia @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Guia @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Modificar_Habilitacion @ID=NULL, @Detalles=NULL, @Fecha=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Habilitacion @ID=NULL, @Detalles='TEST', @Fecha='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Habilitacion @ID=-999999, @Detalles=NULL, @Fecha='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Habilitacion @ID=-999999, @Detalles='TEST', @Fecha='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Modificar_Especialidad @ID=NULL, @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Especialidad @ID=NULL, @Nombre='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Especialidad @ID=-999999, @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_Titulo =====';
BEGIN TRY
    EXEC Empleados.Modificar_Titulo @ID=NULL, @Nombre=NULL, @Fecha=NULL, @Origen=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Titulo @ID=NULL, @Nombre='TEST', @Fecha='2000-01-01', @Origen='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Titulo @ID=-999999, @Nombre=NULL, @Fecha='2000-01-01', @Origen='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Titulo @ID=-999999, @Nombre='TEST', @Fecha=NULL, @Origen='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_Titulo @ID=-999999, @Nombre='TEST', @Fecha='2000-01-01', @Origen=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_R_Guia_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Habilitacion @ID_Guia=NULL, @ID_Habilitacion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Habilitacion @ID_Guia=NULL, @ID_Habilitacion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Habilitacion @ID_Guia=-999999, @ID_Habilitacion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_R_Guia_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Especialidad @ID_Guia=NULL, @ID_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Especialidad @ID_Guia=NULL, @ID_Especialidad=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Especialidad @ID_Guia=-999999, @ID_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Modificar_R_Guia_Titulo =====';
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Titulo @ID_Guia=NULL, @ID_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Titulo @ID_Guia=NULL, @ID_Titulo=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Modificar_R_Guia_Titulo @ID_Guia=-999999, @ID_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.ModificarTipo_actividad =====';
BEGIN TRY
    EXEC Concesiones.ModificarTipo_actividad @ID=NULL, @NuevoNombre=NULL, @NuevaDesc=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarTipo_actividad @ID=NULL, @NuevoNombre='TEST', @NuevaDesc='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarTipo_actividad @ID=-999999, @NuevoNombre=NULL, @NuevaDesc='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarTipo_actividad @ID=-999999, @NuevoNombre='TEST', @NuevaDesc=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.ModificarEmpresa =====';
BEGIN TRY
    EXEC Concesiones.ModificarEmpresa @ID=NULL, @NuevoNombre=NULL, @NuevoCUIT=NULL, @NuevoCorreo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarEmpresa @ID=NULL, @NuevoNombre='TEST', @NuevoCUIT='TEST', @NuevoCorreo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarEmpresa @ID=-999999, @NuevoNombre=NULL, @NuevoCUIT='TEST', @NuevoCorreo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarEmpresa @ID=-999999, @NuevoNombre='TEST', @NuevoCUIT=NULL, @NuevoCorreo='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarEmpresa @ID=-999999, @NuevoNombre='TEST', @NuevoCUIT='TEST', @NuevoCorreo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.ModificarConcesion =====';
BEGIN TRY
    EXEC Concesiones.ModificarConcesion @ID=NULL, @Fecha_inicio=NULL, @Fecha_fin=NULL, @ID_empresa=NULL, @ID_tipo=NULL, @ID_parque=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = NULL,
        @Fecha_inicio = '2024-01-01',
        @Fecha_fin = '2024-12-31',
        @ID_empresa = -999999,
        @ID_tipo = -999999,
        @ID_parque = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = -999999,
        @Fecha_inicio = NULL,
        @Fecha_fin = '2024-12-31',
        @ID_empresa = -999999,
        @ID_tipo = -999999,
        @ID_parque = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = -999999,
        @Fecha_inicio = '2024-01-01',
        @Fecha_fin = NULL,
        @ID_empresa = -999999,
        @ID_tipo = -999999,
        @ID_parque = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = -999999,
        @Fecha_inicio = '2024-01-01',
        @Fecha_fin = '2024-12-31',
        @ID_empresa = NULL,
        @ID_tipo = -999999,
        @ID_parque = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = -999999,
        @Fecha_inicio = '2024-01-01',
        @Fecha_fin = '2024-12-31',
        @ID_empresa = -999999,
        @ID_tipo = NULL,
        @ID_parque = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC Concesiones.ModificarConcesion
        @ID = -999999,
        @Fecha_inicio = '2024-01-01',
        @Fecha_fin = '2024-12-31',
        @ID_empresa = -999999,
        @ID_tipo = -999999,
        @ID_parque = NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.ModificarPago_mensual =====';
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual @ID=NULL, @Fecha=NULL, @Monto=NULL, @Metodo=NULL, @ID_concesion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual
        @ID = NULL,
        @Fecha = '2024-01-01',
        @Monto = -999999,
        @Metodo = 'TEST',
        @ID_concesion = -999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual @ID=-999999, @Fecha=NULL, @Monto=-999999, @Metodo='TEST', @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual @ID=-999999, @Fecha='2000-01-01', @Monto=NULL, @Metodo='TEST', @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual @ID=-999999, @Fecha='2000-01-01', @Monto=-999999, @Metodo=NULL, @ID_concesion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.ModificarPago_mensual @ID=-999999, @Fecha='2000-01-01', @Monto=-999999, @Metodo='TEST', @ID_concesion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Cliente_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=NULL, @Nombre=NULL, @Documento=NULL, @Tipo_doc=NULL, @Nacimiento=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=NULL, @Nombre='TEST', @Documento='TEST', @Tipo_doc='TEST', @Nacimiento='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=-999999, @Nombre=NULL, @Documento='TEST', @Tipo_doc='TEST', @Nacimiento='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=-999999, @Nombre='TEST', @Documento=NULL, @Tipo_doc='TEST', @Nacimiento='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=-999999, @Nombre='TEST', @Documento='TEST', @Tipo_doc=NULL, @Nacimiento='2000-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Modificar @ID=-999999, @Nombre='TEST', @Documento='TEST', @Tipo_doc='TEST', @Nacimiento=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_TipoVisitante_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Modificar @ID=NULL, @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Modificar @ID=NULL, @Nombre='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Modificar @ID=-999999, @Nombre=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Tarifa_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Modificar @ID=NULL, @Fecha_desde=NULL, @Fecha_hasta=NULL, @Precio=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Modificar @ID=NULL, @Fecha_desde='2000-01-01', @Fecha_desde='2000-03-03', @Precio=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Modificar @ID=-999999, @Fecha_desde=NULL, @Fecha_desde='2000-03-03', @Precio=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Modificar @ID=-999999, @Fecha_desde='2000-01-01', @Fecha_hasta=NULL, @Precio=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Modificar @ID=-999999, @Fecha_desde='2000-01-01', @Fecha_desde='2000-03-03', @Precio=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Entrada_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_Entrada_Modificar @ID=NULL, @Fecha_acceso=NULL, @ID_cliente=NULL, @ID_tarifa=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Modificar @ID=NULL, @Fecha_acceso='2000-01-01', @ID_cliente=-999999, @ID_tarifa=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Modificar @ID=-999999, @Fecha_acceso=NULL, @ID_cliente=-999999, @ID_tarifa=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Modificar @ID=-999999, @Fecha_acceso='2000-01-01', @ID_cliente=NULL, @ID_tarifa=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Modificar @ID=-999999, @Fecha_acceso='2000-01-01', @ID_cliente=-999999, @ID_tarifa=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Compra_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=NULL, @Fecha=NULL, @Total=NULL, @Cantidad=NULL, @Punto_venta=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=NULL, @Fecha=-999999, @Total=-999999, @Cantidad=-999999, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=-999999, @Fecha=NULL, @Total=-999999, @Cantidad=-999999, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=-999999, @Fecha=-999999, @Total=NULL, @Cantidad=-999999, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=-999999, @Fecha=-999999, @Total=-999999, @Cantidad=NULL, @Punto_venta='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Modificar @ID=-999999, @Fecha=-999999, @Total=-999999, @Cantidad=-999999, @Punto_venta=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Pago_Modificar =====';
BEGIN TRY
    EXEC Ventas.SP_Pago_Modificar @ID=NULL, @Metodo=NULL, @Monto=NULL, @Estado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Modificar @ID=NULL, @Metodo='TEST', @Monto=-999999, @Estado='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Modificar @ID=-999999, @Metodo=NULL, @Monto=-999999, @Estado='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Modificar @ID=-999999, @Metodo='TEST', @Monto=NULL, @Estado='TEST';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Modificar @ID=-999999, @Metodo='TEST', @Monto=-999999, @Estado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== ModificarTour =====';
BEGIN TRY
    EXEC ModificarTour @ID_Tour=NULL, @Costo=NULL, @Cupo_max=NULL, @Tipo=NULL, @Duracion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarTour @ID_Tour=NULL, @Costo=-999999, @Cupo_max=-999999, @Tipo='TEST', @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarTour @ID_Tour=-999999, @Costo=NULL, @Cupo_max=-999999, @Tipo='TEST', @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarTour @ID_Tour=-999999, @Costo=-999999, @Cupo_max=NULL, @Tipo='TEST', @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarTour @ID_Tour=-999999, @Costo=-999999, @Cupo_max=-999999, @Tipo=NULL, @Duracion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarTour @ID_Tour=-999999, @Costo=-999999, @Cupo_max=-999999, @Tipo='TEST', @Duracion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== ModificarR_Tour_Guia =====';
BEGIN TRY
    EXEC ModificarR_Tour_Guia @ID_Tour=NULL, @ID_Guia=NULL, @NuevoID_Tour=NULL, @NuevoID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Guia @ID_Tour=NULL, @ID_Guia=-999999, @NuevoID_Tour=-999999, @NuevoID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Guia @ID_Tour=-999999, @ID_Guia=NULL, @NuevoID_Tour=-999999, @NuevoID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Guia @ID_Tour=-999999, @ID_Guia=-999999, @NuevoID_Tour=NULL, @NuevoID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Guia @ID_Tour=-999999, @ID_Guia=-999999, @NuevoID_Tour=-999999, @NuevoID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== ModificarR_Tour_Entrada =====';
BEGIN TRY
    EXEC ModificarR_Tour_Entrada @ID_Tour=NULL, @ID_Entrada=NULL, @NuevoID_Tour=NULL, @NuevoID_Entrada=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Entrada @ID_Tour=NULL, @ID_Entrada=-999999, @NuevoID_Tour=-999999, @NuevoID_Entrada=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Entrada @ID_Tour=-999999, @ID_Entrada=NULL, @NuevoID_Tour=-999999, @NuevoID_Entrada=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Entrada @ID_Tour=-999999, @ID_Entrada=-999999, @NuevoID_Tour=NULL, @NuevoID_Entrada=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC ModificarR_Tour_Entrada @ID_Tour=-999999, @ID_Entrada=-999999, @NuevoID_Tour=-999999, @NuevoID_Entrada=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== TODO MAL A LA VEZ =====';