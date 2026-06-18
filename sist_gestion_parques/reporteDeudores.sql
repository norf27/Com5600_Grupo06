/*
Fecha: 3/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion:
Procedimiento para reporte de deudores.
*/



use sist_gestion_parques
go

create or alter procedure SP_MostrarDeudores @Fecha date = NULL as
begin
if @Fecha is null
	set @Fecha = getdate()

select e.Nombre as Empresa, e.CUIT, p.Nombre as Parque, pm.Fecha, pm.Monto
from Concesiones.Pago_mensual pm inner join Concesiones.Concesion c 
inner join Concesiones.Empresa e on c.ID_empresa = e.ID
inner join Parque.Parque p on p.ID = c.ID_parque
on c.ID = pm.ID_concesion
where c.Estado = 'A' and  pm.Estado = 'A' and pm.Pago = 'D' and pm.Fecha < @Fecha
FOR XML PATH('Deudor'), ROOT('Reportes');



end;
go
