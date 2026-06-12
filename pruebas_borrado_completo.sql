-- Pruebas automáticas para generacionProcBorradoSP.sql
USE sist_gestion_parques;
GO


PRINT '===== Parque.BorrarTipo_parque =====';
BEGIN TRY
    EXEC Parque.BorrarTipo_parque @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.BorrarTipo_parque @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.BorrarProvincia =====';
BEGIN TRY
    EXEC Parque.BorrarProvincia @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.BorrarProvincia @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Parque.BorrarParque =====';
BEGIN TRY
    EXEC Parque.BorrarParque @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Parque.BorrarParque @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Guardaparque.Borrar =====';
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== EmpleadosGuardaparque.Borrar_Parque =====';
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar_Parque @ID_Guardaparque=NULL, @ID_Parque=NULL, @Fecha_ingreso=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar_Parque @ID_Guardaparque=NULL, @ID_Parque=-999999, @Fecha_ingreso='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar_Parque @ID_Guardaparque=-999999, @ID_Parque=NULL, @Fecha_ingreso='2001-01-01';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Guardaparque_Borrar_Parque @ID_Guardaparque=-999999, @ID_Parque=-999999, @Fecha_ingreso=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== EmpleadosBorrarEmpleado =====';
BEGIN TRY
    EXEC EmpleadosBorrarEmpleado @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC EmpleadosBorrarEmpleado @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_Guia =====';
BEGIN TRY
    EXEC Empleados.Borrar_Guia @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_Guia @ID_Empleado=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Borrar_Habilitacion @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_Habilitacion @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Borrar_Especialidad @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_Especialidad @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_Titulo =====';
BEGIN TRY
    EXEC Empleados.Borrar_Titulo @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_Titulo @Id=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_R_Guia_Habilitacion =====';
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Habilitacion @ID_Guia=NULL, @ID_Habilitacion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Habilitacion @ID_Guia=NULL, @ID_Habilitacion=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Habilitacion @ID_Guia=-999999, @ID_Habilitacion=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_R_Guia_Especialidad =====';
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Especialidad @ID_Guia=NULL, @ID_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Especialidad @ID_Guia=NULL, @ID_Especialidad=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Especialidad @ID_Guia=-999999, @ID_Especialidad=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Empleados.Borrar_R_Guia_Titulo =====';
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Titulo @ID_Guia=NULL, @ID_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Titulo @ID_Guia=NULL, @ID_Titulo=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Empleados.Borrar_R_Guia_Titulo @ID_Guia=-999999, @ID_Titulo=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.BorrarTipo_actividad =====';
BEGIN TRY
    EXEC Concesiones.BorrarTipo_actividad @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.BorrarTipo_actividad @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.BorrarEmpresa =====';
BEGIN TRY
    EXEC Concesiones.BorrarEmpresa @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.BorrarEmpresa @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.BorrarConcesion =====';
BEGIN TRY
    EXEC Concesiones.BorrarConcesion @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.BorrarConcesion @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Concesiones.BorrarPago_mensual =====';
BEGIN TRY
    EXEC Concesiones.BorrarPago_mensual @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Concesiones.BorrarPago_mensual @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Cliente_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_Cliente_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Cliente_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_TipoVisitante_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_TipoVisitante_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Tarifa_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Tarifa_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Entrada_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_Entrada_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Entrada_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Compra_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_Compra_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Compra_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Ventas.SP_Pago_Baja =====';
BEGIN TRY
    EXEC Ventas.SP_Pago_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Ventas.SP_Pago_Baja @ID=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== Tour.Borrar =====';
BEGIN TRY
    EXEC Atracciones.Tour_Borrar @ID_Tour=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Atracciones.Tour_Borrar @ID_Tour=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== R_Tour.Borrar_Guia =====';
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=NULL, @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=NULL, @ID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=-999999, @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

PRINT '===== R_Tour.Borrar_Entrada =====';
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=NULL,  @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=-999999, @ID_Guia=NULL;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;
BEGIN TRY
    EXEC Atracciones.R_Tour_Borrar_Guia @ID_Tour=NULL, @ID_Guia=-999999;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

