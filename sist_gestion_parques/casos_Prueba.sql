/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Grasso Santiago, Luna Gauna Thiago Gonzalo, Orfano Nicolas
Descripcion: Script de pruebas para la carga inicial de datos del sistema, incluyendo tipos de parque, 
importación de provincias desde archivo externo y alta de parques con datos de ejemplo para validar el correcto 
funcionamiento de los procedimientos almacenados.
*/

use sist_gestion_parques

--tipo parque
exec Parque.SP_TipoParque_Alta @Nombre = 'Acuatico', @Descripcion = 'Centrado en la conservacion de vida maritima'
exec Parque.SP_TipoParque_Alta @Nombre = 'Aventura', @Descripcion = 'Centrado en atracciones extremas y experiencias de adrenalina'
exec Parque.SP_TipoParque_Alta @Nombre = 'Natural', @Descripcion = 'Centrado en la preservacion del medio ambiente y el contacto con la naturaleza'
--provs
exec Staging.SP_Importar_Provincias @RutaArchivo = 'C:\Datasets\provincias.json'
--parques
exec Parque.SP_Parque_Alta 
@Superficie = 2000, @Nombre = 'Parque Del Topo', @ID_tipo = 1, @ID_provincia = 2, @Anio_Creacion = 1998,
@Ambiente_Ecoregion = 'Altos andes', @Fecha_Ultima_Actualizacion = '2025-12-04'

exec Parque.SP_Parque_Alta 
@Superficie = 3500, @Nombre = 'Parque De La Montaña', @ID_tipo = 1, @ID_provincia = 3, @Anio_Creacion = 2005,
@Ambiente_Ecoregion = 'Bosques Patagónicos', @Fecha_Ultima_Actualizacion = '2025-12-04'

exec Parque.SP_Parque_Alta 
@Superficie = 1500, @Nombre = 'Reserva Del Lago Azul', @ID_tipo = 2, @ID_provincia = 5, @Anio_Creacion = 1995,
@Ambiente_Ecoregion = 'Esteros del Iberá', @Fecha_Ultima_Actualizacion = '2025-11-20'

exec Parque.SP_Parque_Alta 
@Superficie = 5000, @Nombre = 'Parque Aventura Sur', @ID_tipo = 3, @ID_provincia = 7, @Anio_Creacion = 2010,
@Ambiente_Ecoregion = 'Estepa Patagónica', @Fecha_Ultima_Actualizacion = '2025-10-15'

exec Parque.SP_Parque_Alta 
@Superficie = 2800, @Nombre = 'Parque Del Sol', @ID_tipo = 2, @ID_provincia = 1, @Anio_Creacion = 1987,
@Ambiente_Ecoregion = 'Chaco Seco', @Fecha_Ultima_Actualizacion = '2025-09-30'

exec Parque.SP_Parque_Alta 
@Superficie = 4200, @Nombre = 'Parque Oceano Vivo', @ID_tipo = 3, @ID_provincia = 8, @Anio_Creacion = 2001,
@Ambiente_Ecoregion = 'Mar Argentino', @Fecha_Ultima_Actualizacion = '2025-12-01'

exec Parque.SP_Parque_Alta 
@Superficie = 1200, @Nombre = 'Parque Verde Central', @ID_tipo = 3, @ID_provincia = 4, @Anio_Creacion = 1999,
@Ambiente_Ecoregion = 'Pampa', @Fecha_Ultima_Actualizacion = '2025-08-18'

exec Parque.SP_Parque_Alta 
@Superficie = 6700, @Nombre = 'Parque De Las Cascadas', @ID_tipo = 1, @ID_provincia = 6, @Anio_Creacion = 2015,
@Ambiente_Ecoregion = 'Selva Paranaense', @Fecha_Ultima_Actualizacion = '2025-11-05'

exec Parque.SP_Parque_Alta 
@Superficie = 2300, @Nombre = 'Parque Historico Nacional', @ID_tipo = 2, @ID_provincia = 9, @Anio_Creacion = 1975,
@Ambiente_Ecoregion = 'Monte de Sierras y Bolsones', @Fecha_Ultima_Actualizacion = '2025-07-22'

exec Parque.SP_Parque_Alta 
@Superficie = 3900, @Nombre = 'Parque Acuatico Tropical', @ID_tipo = 2, @ID_provincia = 10, @Anio_Creacion = 2018,
@Ambiente_Ecoregion = 'Yungas', @Fecha_Ultima_Actualizacion = '2025-12-10'

/*
select Superficie, P.Nombre, tp.Nombre,  pr.Nombre, P.Anio_Creacion, P.Ambiente_Ecoregion, p.Fecha_Ultima_Actualizacion 
from Parque.Parque P inner join Parque.Provincia pr on P.ID_provincia = pr.ID
inner join Parque.Tipo_parque tp on tp.ID = P.ID_tipo 
*/


--generar tours
exec Atracciones.SP_Tour_Alta @Costo = 15000, @Cupo_max = 3, @Nombre = 'Cueva del Topo', @Horario = '09:00', @Tipo = 'T', @Duracion = 150, @ID_parque = 1
exec Atracciones.SP_Tour_Alta @Costo = 11000, @Cupo_max = 40, @Nombre = 'Sendero de las Alturas', @Horario = '09:00', @Tipo = 'T', @Duracion = 80, @ID_parque = 1
exec Atracciones.SP_Tour_Alta @Costo = 12500, @Cupo_max = 35, @Nombre = 'Travesía Subterránea', @Horario = '15:00', @Tipo = 'A', @Duracion = 100, @ID_parque = 1
exec Atracciones.SP_Tour_Alta @Costo = 18000, @Cupo_max = 25, @Nombre = 'Ascenso al Mirador', @Horario = '08:30', @Tipo = 'T', @Duracion = 120, @ID_parque = 2
exec Atracciones.SP_Tour_Alta @Costo = 19000, @Cupo_max = 18, @Nombre = 'Caminata entre Coihues', @Horario = '14:00', @Tipo = 'T', @Duracion = 130, @ID_parque = 2
exec Atracciones.SP_Tour_Alta @Costo = 23000, @Cupo_max = 17, @Nombre = 'Escalada de Alta Montaña', @Horario = '10:00', @Tipo = 'A', @Duracion = 180, @ID_parque = 2
exec Atracciones.SP_Tour_Alta @Costo = 22000, @Cupo_max = 15, @Nombre = 'Paseo Náutico Iberá', @Horario = '09:30', @Tipo = 'T', @Duracion = 180, @ID_parque = 3
exec Atracciones.SP_Tour_Alta @Costo = 26000, @Cupo_max = 14, @Nombre = 'Safari Fotográfico Nocturno', @Horario = '20:00', @Tipo = 'T', @Duracion = 220, @ID_parque = 3
exec Atracciones.SP_Tour_Alta @Costo = 27000, @Cupo_max = 12, @Nombre = 'Aventura en Canoa', @Horario = '16:00', @Tipo = 'A', @Duracion = 210, @ID_parque = 3
exec Atracciones.SP_Tour_Alta @Costo = 12000, @Cupo_max = 30, @Nombre = 'Vientos de la Estepa', @Horario = '10:30', @Tipo = 'T', @Duracion = 90, @ID_parque = 4
exec Atracciones.SP_Tour_Alta @Costo = 13000, @Cupo_max = 28, @Nombre = 'Ruta de los Fósiles', @Horario = '13:00', @Tipo = 'T', @Duracion = 110, @ID_parque = 4
exec Atracciones.SP_Tour_Alta @Costo = 15000, @Cupo_max = 26, @Nombre = 'Trekking de Arcilla', @Horario = '15:30', @Tipo = 'A', @Duracion = 125, @ID_parque = 4
exec Atracciones.SP_Tour_Alta @Costo = 25000, @Cupo_max = 10, @Nombre = 'Sendero del Quebracho', @Horario = '08:00', @Tipo = 'T', @Duracion = 200, @ID_parque = 5
exec Atracciones.SP_Tour_Alta @Costo = 32000, @Cupo_max = 8, @Nombre = 'Avistaje de Fauna Chaqueña', @Horario = '07:00', @Tipo = 'T', @Duracion = 250, @ID_parque = 5
exec Atracciones.SP_Tour_Alta @Costo = 35000, @Cupo_max = 10, @Nombre = 'Expedición Calor Extremo', @Horario = '16:30', @Tipo = 'A', @Duracion = 260, @ID_parque = 5
exec Atracciones.SP_Tour_Alta @Costo = 16000, @Cupo_max = 22, @Nombre = 'Acantilados y Lobos Marinos', @Horario = '11:00', @Tipo = 'T', @Duracion = 140, @ID_parque = 6
exec Atracciones.SP_Tour_Alta @Costo = 17000, @Cupo_max = 24, @Nombre = 'Mirador de Ballenas', @Horario = '14:30', @Tipo = 'T', @Duracion = 150, @ID_parque = 6
exec Atracciones.SP_Tour_Alta @Costo = 17500, @Cupo_max = 21, @Nombre = 'Buceo en el Mar Argentino', @Horario = '10:00', @Tipo = 'A', @Duracion = 145, @ID_parque = 6
exec Atracciones.SP_Tour_Alta @Costo = 30000, @Cupo_max = 12, @Nombre = 'Cabalgata Criolla', @Horario = '09:00', @Tipo = 'T', @Duracion = 240, @ID_parque = 7
exec Atracciones.SP_Tour_Alta @Costo = 28000, @Cupo_max = 16, @Nombre = 'Caminata por la Llanura', @Horario = '15:00', @Tipo = 'T', @Duracion = 190, @ID_parque = 7
exec Atracciones.SP_Tour_Alta @Costo = 31000, @Cupo_max = 11, @Nombre = 'Travesía de los Pastizales', @Horario = '10:30', @Tipo = 'A', @Duracion = 225, @ID_parque = 7
exec Atracciones.SP_Tour_Alta @Costo = 14000, @Cupo_max = 35, @Nombre = 'Sendero de las Orquídeas', @Horario = '12:00', @Tipo = 'T', @Duracion = 100, @ID_parque = 8
exec Atracciones.SP_Tour_Alta @Costo = 14500, @Cupo_max = 32, @Nombre = 'Paseo de la Bruma', @Horario = '14:00', @Tipo = 'T', @Duracion = 95, @ID_parque = 8
exec Atracciones.SP_Tour_Alta @Costo = 13500, @Cupo_max = 33, @Nombre = 'Aventura bajo los Saltos', @Horario = '10:00', @Tipo = 'A', @Duracion = 105, @ID_parque = 8
exec Atracciones.SP_Tour_Alta @Costo = 20000, @Cupo_max = 18, @Nombre = 'Camino del Inca y Cardones', @Horario = '08:30', @Tipo = 'T', @Duracion = 160, @ID_parque = 9
exec Atracciones.SP_Tour_Alta @Costo = 21000, @Cupo_max = 20, @Nombre = 'Ruta de los Pueblos Originarios', @Horario = '16:00', @Tipo = 'T', @Duracion = 170, @ID_parque = 9
exec Atracciones.SP_Tour_Alta @Costo = 24000, @Cupo_max = 19, @Nombre = 'Exploración de Yacimientos', @Horario = '11:00', @Tipo = 'A', @Duracion = 175, @ID_parque = 9
exec Atracciones.SP_Tour_Alta @Costo = 27000, @Cupo_max = 15, @Nombre = 'Sendero de la Selva Nublada', @Horario = '09:00', @Tipo = 'T', @Duracion = 210, @ID_parque = 10
exec Atracciones.SP_Tour_Alta @Costo = 29000, @Cupo_max = 13, @Nombre = 'Expedición Helechos Gigantes', @Horario = '13:30', @Tipo = 'T', @Duracion = 230, @ID_parque = 10
exec Atracciones.SP_Tour_Alta @Costo = 33000, @Cupo_max = 14, @Nombre = 'Canopy en la Selva', @Horario = '11:15', @Tipo = 'A', @Duracion = 235, @ID_parque = 10



--select * from Atracciones.Tour

--guias

exec Empleados.SP_Guia_Alta @Nombre = 'Lautaro lopez', @DNI = '46970123', @CUIL = '20-46970123-1', @Nacimiento = '2001-01-05', @Sueldo = 1500000, @ID_parque = 1
exec Empleados.SP_Guia_Alta @Nombre = 'Juan Pérez', @DNI = '38123456', @CUIL = '20-38123456-9', @Nacimiento = '1994-05-12', @Sueldo = 1200000, @ID_parque = 3
exec Empleados.SP_Guia_Alta @Nombre = 'María Florencia Gómez', @DNI = '40234567', @CUIL = '27-40234567-2', @Nacimiento = '1997-08-24', @Sueldo = 1350000, @ID_parque = 7
exec Empleados.SP_Guia_Alta @Nombre = 'Lucas Agustín Rodríguez', @DNI = '42345678', @CUIL = '20-42345678-4', @Nacimiento = '2000-01-15', @Sueldo = 1100000, @ID_parque = 1
exec Empleados.SP_Guia_Alta @Nombre = 'Camila Belén Fernández', @DNI = '39456789', @CUIL = '27-39456789-1', @Nacimiento = '1996-03-30', @Sueldo = 1400000, @ID_parque = 10

exec Empleados.SP_Guia_Alta @Nombre = 'Martina Silva', @DNI = '41678901', @CUIL = '27-41678901-8', @Nacimiento = '1999-07-19', @Sueldo = 1250000, @ID_parque = 2
exec Empleados.SP_Guia_Alta @Nombre = 'Mateo Martínez', @DNI = '37789012', @CUIL = '20-37789012-5', @Nacimiento = '1993-12-05', @Sueldo = 1600000, @ID_parque = 8
exec Empleados.SP_Guia_Alta @Nombre = 'Sofía Diaz', @DNI = '43890123', @CUIL = '27-43890123-6', @Nacimiento = '2002-04-22', @Sueldo = 1050000, @ID_parque = 4
exec Empleados.SP_Guia_Alta @Nombre = 'Nicolás Álvarez', @DNI = '36901234', @CUIL = '20-36901234-2', @Nacimiento = '1992-09-14', @Sueldo = 1750000, @ID_parque = 9
exec Empleados.SP_Guia_Alta @Nombre = 'Valentina Romero', @DNI = '44012345', @CUIL = '27-44012345-0', @Nacimiento = '2003-06-08', @Sueldo = 1000000, @ID_parque = 6

exec Empleados.SP_Guia_Alta @Nombre = 'Facundo López', @DNI = '35123451', @CUIL = '20-35123451-7', @Nacimiento = '1990-02-27', @Sueldo = 1900000, @ID_parque = 1
exec Empleados.SP_Guia_Alta @Nombre = 'Catalina Torres', @DNI = '42234562', @CUIL = '27-42234562-3', @Nacimiento = '2000-10-10', @Sueldo = 1300000, @ID_parque = 10
exec Empleados.SP_Guia_Alta @Nombre = 'Bautista Benítez', @DNI = '46345673', @CUIL = '20-46345673-1', @Nacimiento = '2005-05-18', @Sueldo = 900000, @ID_parque = 3
exec Empleados.SP_Guia_Alta @Nombre = 'Micaela Herrera', @DNI = '38456784', @CUIL = '27-38456784-9', @Nacimiento = '1994-11-23', @Sueldo = 1500000, @ID_parque = 5
exec Empleados.SP_Guia_Alta @Nombre = 'Julián Medina', @DNI = '40567895', @CUIL = '20-40567895-6', @Nacimiento = '1997-01-07', @Sueldo = 1450000, @ID_parque = 8

exec Empleados.SP_Guia_Alta @Nombre = 'Victoria Castro', @DNI = '41678906', @CUIL = '27-41678906-4', @Nacimiento = '1999-03-14', @Sueldo = 1200000, @ID_parque = 2
exec Empleados.SP_Guia_Alta @Nombre = 'Tomas Flores', @DNI = '39789017', @CUIL = '20-39789017-2', @Nacimiento = '1996-07-29', @Sueldo = 1380000, @ID_parque = 7
exec Empleados.SP_Guia_Alta @Nombre = 'Abril Morales', @DNI = '43890128', @CUIL = '27-43890128-0', @Nacimiento = '2002-12-12', @Sueldo = 1150000, @ID_parque = 6
exec Empleados.SP_Guia_Alta @Nombre = 'Federico Suárez', @DNI = '34901239', @CUIL = '20-34901239-8', @Nacimiento = '1989-04-05', @Sueldo = 2100000, @ID_parque = 9
exec Empleados.SP_Guia_Alta @Nombre = 'Juana Ruiz', @DNI = '45012340', @CUIL = '27-45012340-5', @Nacimiento = '2003-09-21', @Sueldo = 1050000, @ID_parque = 4

/*
exec Empleados.SP_Especialidad_Alta @Nombre = 'Escalada', @Detalles = 'El guia esta capacitado para liderar un tour con alta exigencia fisica'
exec Empleados.SP_Habilitacion_Alta @Nombre = 'Nacional', @Detalles = 'Habilitacion otorgada por el gobierno nacional'
exec Empleados.SP_Titulo_Alta @Nombre = 'Geologo UBA' */
--asignar guias

exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 1, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 2, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 6, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 8, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 14, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 10, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 3, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 7, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 9, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'
exec Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 5, @Nombre_especialidad = 'Escalada', @Detalles_especialidad = 'El guia esta capacitado para liderar un tour con alta exigencia fisica', @Nivel ='B'

exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 1, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 6, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 2, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 8, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 14, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 10, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 3, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 7, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 9, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'
exec Empleados.SP_GuiaHabilitacion_Alta @ID_guia = 5, @Nombre_habilitacion = 'Nacional', @Detalles_habilitacion = 'Habilitacion otorgada por el gobierno nacional', @Fecha_Vencimiento = '2030-01-01', @tipo = 'N'


exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 1, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 6, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 2, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 8, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 14, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 10, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 3, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 7, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 9, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'
exec Empleados.SP_GuiaTitulo_Alta @ID_Guia = 5, @Nombre_Titulo = 'geologo', @Fecha_Emision = '2013-01-01', @Origen = 'UNLAM'

exec Atracciones.SP_AsignarGuiaTour @ID_tour = 1, @ID_guia = 1
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 2, @ID_guia = 6
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 3, @ID_guia = 2
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 4, @ID_guia = 8
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 5, @ID_guia = 14
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 6, @ID_guia = 10
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 7, @ID_guia = 3
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 8, @ID_guia = 7
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 9, @ID_guia = 9
exec Atracciones.SP_AsignarGuiaTour @ID_tour = 10, @ID_guia = 5





--empleados
exec Empleados.SP_Empleado_Alta @Nacimiento = '1993-04-11', @DNI = '37111222', @Nombre = 'Andrés Almada', @Sueldo = 1400000, @ID_parque = 4, @CUIL = '20-37111222-3'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1998-09-25', @DNI = '41222333', @Nombre = 'Barbara Bustos', @Sueldo = 1310000, @ID_parque = 8, @CUIL = '27-41222333-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-05-19', @DNI = '43333444', @Nombre = 'Cristian Carrizo', @Sueldo = 1120000, @ID_parque = 2, @CUIL = '20-43333444-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1995-11-02', @DNI = '39444555', @Nombre = 'Diana Duarte', @Sueldo = 1550000, @ID_parque = 9, @CUIL = '27-39444555-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2004-02-14', @DNI = '45555666', @Nombre = 'Esteban Estrada', @Sueldo = 990000, @ID_parque = 1, @CUIL = '20-45555666-5'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1997-07-31', @DNI = '40666777', @Nombre = 'Fiorella Funes', @Sueldo = 1260000, @ID_parque = 6, @CUIL = '27-40666777-3'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1992-01-15', @DNI = '36777888', @Nombre = 'Gabriel Gallardo', @Sueldo = 1850000, @ID_parque = 10, @CUIL = '20-36777888-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2000-08-22', @DNI = '42888999', @Nombre = 'Isabela Ibarra', @Sueldo = 1230000, @ID_parque = 3, @CUIL = '27-42888999-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1994-12-05', @DNI = '38999000', @Nombre = 'Hugo Jérez', @Sueldo = 1480000, @ID_parque = 5, @CUIL = '20-38999000-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2003-03-10', @DNI = '44111333', @Nombre = 'Karina Krüger', @Sueldo = 1040000, @ID_parque = 7, @CUIL = '27-44111333-5'

exec Empleados.SP_Empleado_Alta @Nacimiento = '1991-06-28', @DNI = '35222444', @Nombre = 'Lautaro Leguizamón', @Sueldo = 1920000, @ID_parque = 2, @CUIL = '20-35222444-2'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1996-10-14', @DNI = '39333555', @Nombre = 'Malena Moyano', @Sueldo = 1370000, @ID_parque = 5, @CUIL = '27-39333555-0'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2005-01-09', @DNI = '46444666', @Nombre = 'Nahuel Núñez', @Sueldo = 910000, @ID_parque = 8, @CUIL = '20-46444666-8'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1999-04-23', @DNI = '41555777', @Nombre = 'Olga Ortega', @Sueldo = 1290000, @ID_parque = 1, @CUIL = '27-41555777-6'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2002-11-17', @DNI = '43666888', @Nombre = 'Pedro Palacios', @Sueldo = 1160000, @ID_parque = 10, @CUIL = '20-43666888-4'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1990-05-30', @DNI = '35777999', @Nombre = 'Romina Quiroga', @Sueldo = 1980000, @ID_parque = 3, @CUIL = '27-35777999-2'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1997-02-12', @DNI = '40888111', @Nombre = 'Sergio Sanabria', @Sueldo = 1430000, @ID_parque = 7, @CUIL = '20-40888111-0'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2003-07-04', @DNI = '44999222', @Nombre = 'Tamara Toledo', @Sueldo = 1010000, @ID_parque = 6, @CUIL = '27-44999222-8'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1993-09-18', @DNI = '37123987', @Nombre = 'Valentín Valdez', @Sueldo = 1620000, @ID_parque = 4, @CUIL = '20-37123987-6'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1996-01-27', @DNI = '39234098', @Nombre = 'Wendy Williams', @Sueldo = 1390000, @ID_parque = 9, @CUIL = '27-39234098-4'

exec Empleados.SP_Empleado_Alta @Nacimiento = '1988-08-08', @DNI = '33445566', @Nombre = 'Xavier Xavier', @Sueldo = 2200000, @ID_parque = 6, @CUIL = '20-33445566-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-12-11', @DNI = '43556677', @Nombre = 'Yara Yáñez', @Sueldo = 1180000, @ID_parque = 3, @CUIL = '27-43556677-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1994-03-05', @DNI = '38667788', @Nombre = 'Zacarías Zárate', @Sueldo = 1500000, @ID_parque = 1, @CUIL = '20-38667788-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1999-06-20', @DNI = '41778899', @Nombre = 'Adriana Arrieta', @Sueldo = 1270000, @ID_parque = 5, @CUIL = '27-41778899-5'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1991-10-15', @DNI = '36889900', @Nombre = 'Blas Barrionuevo', @Sueldo = 1750000, @ID_parque = 9, @CUIL = '20-36889900-3'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2002-02-28', @DNI = '43990011', @Nombre = 'Cecilia Cáceres', @Sueldo = 1100000, @ID_parque = 2, @CUIL = '27-43990011-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1995-04-13', @DNI = '39001122', @Nombre = 'Damián Delgado', @Sueldo = 1420000, @ID_parque = 8, @CUIL = '20-39001122-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2000-09-07', @DNI = '42112233', @Nombre = 'Elsa Espinoza', @Sueldo = 1240000, @ID_parque = 7, @CUIL = '27-42112233-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1993-07-24', @DNI = '37223344', @Nombre = 'Fabio Figueroa', @Sueldo = 1580000, @ID_parque = 10, @CUIL = '20-37223344-5'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1997-12-19', @DNI = '40334455', @Nombre = 'Gisela Godoy', @Sueldo = 1340000, @ID_parque = 4, @CUIL = '27-40334455-3'

exec Empleados.SP_Empleado_Alta @Nacimiento = '2004-05-06', @DNI = '45445566', @Nombre = 'Hernán Herrera', @Sueldo = 970000, @ID_parque = 10, @CUIL = '20-45445566-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1996-02-18', @DNI = '39556677', @Nombre = 'Irene Insaurralde', @Sueldo = 1410000, @ID_parque = 4, @CUIL = '27-39556677-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1990-11-30', @DNI = '35667788', @Nombre = 'Jorge Juárez', @Sueldo = 1910000, @ID_parque = 7, @CUIL = '20-35667788-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2003-08-14', @DNI = '44778899', @Nombre = 'Laura Luna', @Sueldo = 1030000, @ID_parque = 1, @CUIL = '27-44778899-5'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1992-05-25', @DNI = '36889911', @Nombre = 'Marcos Mansilla', @Sueldo = 1780000, @ID_parque = 9, @CUIL = '20-36889911-3'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1999-01-03', @DNI = '41990022', @Nombre = 'Natalia Nieva', @Sueldo = 1300000, @ID_parque = 5, @CUIL = '27-41990022-1'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2005-06-22', @DNI = '46112233', @Nombre = 'Omar Ojeda', @Sueldo = 890000, @ID_parque = 2, @CUIL = '20-46112233-9'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1994-10-09', @DNI = '38223344', @Nombre = 'Patricia Páez', @Sueldo = 1460000, @ID_parque = 6, @CUIL = '27-38223344-7'
exec Empleados.SP_Empleado_Alta @Nacimiento = '1989-12-15', @DNI = '34334455', @Nombre = 'Quintín Quiroz', @Sueldo = 2050000, @ID_parque = 3, @CUIL = '20-34334455-5'
exec Empleados.SP_Empleado_Alta @Nacimiento = '2001-03-27', @DNI = '43445566', @Nombre = 'Raquel Ramos', @Sueldo = 1190000, @ID_parque = 8, @CUIL = '27-43445566-3'

--guardaparque

exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 40
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 41
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 42
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 43
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 44
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 45
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 46
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 47
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 48
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 49
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 50
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 51
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 52
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 53
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 54
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 55
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 56
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 57
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 58
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 59
exec Empleados.SP_Guardaparque_Alta @ID_Empleado = 60

--empresas
exec Concesiones.SP_Empresa_Alta @Nombre = 'Pancheria Don Carlos', @CUIT = '30-45896321-9', @Correo = 'contacto@pancheriadoncarlos.com', @telefono = '+54 11 6900 2210'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Café Martinez Express', @CUIT = '30-70823415-2', @Correo = 'express@cafemartinez.com.ar', @telefono = '+54 11 4789 3322'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Kiosco El Trébol', @CUIT = '20-34895126-4', @Correo = 'kioscoeltrebol@gmail.com', @telefono = '+54 11 5566 9911'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Heladerías Grido Sucursal', @CUIT = '33-65478932-9', @Correo = 'franquicias@gridohelados.com', @telefono = '+54 351 420 8800'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Maxikiosco Open 25', @CUIT = '30-71452896-1', @Correo = 'administracion@open25.com.ar', @telefono = '+54 11 4322 1100'

exec Concesiones.SP_Empresa_Alta @Nombre = 'Restaurante El Fortín', @CUIT = '30-52369874-5', @Correo = 'reservas@elfortinresto.com', @telefono = '+54 11 4641 4422'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Minimercado Express', @CUIT = '30-71852963-8', @Correo = 'compras@minimercadoexpress.com', @telefono = '+54 11 3220 5544'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Regalería Las Violetas', @CUIT = '27-38456123-2', @Correo = 'lasvioletasregalos@outlook.com', @telefono = '+54 11 6874 1155'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Pizzería La Guitarrita', @CUIT = '30-68954123-7', @Correo = 'info@laguitarrita.com.ar', @telefono = '+54 11 4783 0077'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Cervecería Patagonia Bar', @CUIT = '30-71524896-3', @Correo = 'parque@cervezapatagonia.com', @telefono = '+54 294 445 5600'

exec Concesiones.SP_Empresa_Alta @Nombre = 'Hamburguesas Dean & Dennis', @CUIT = '30-71485296-4', @Correo = 'concesiones@deandennis.com', @telefono = '+54 11 5235 9900'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Artesanías del Norte', @CUIT = '20-28965412-5', @Correo = 'artesaníasdelnorte@gmail.com', @telefono = '+54 387 421 5566'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Chopp & Co Foodtruck', @CUIT = '30-71695842-1', @Correo = 'choppandco@hotmail.com', @telefono = '+54 11 2541 3698'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Bufé Los Parques', @CUIT = '33-54896532-4', @Correo = 'administracion@bufelosparques.com', @telefono = '+54 11 4899 1234'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Souvenirs Autóctonos S.R.L.', @CUIT = '30-66584125-9', @Correo = 'ventas@souvenirsautoctonos.com', @telefono = '+54 261 423 8899'

exec Concesiones.SP_Empresa_Alta @Nombre = 'El Rey del Pancho', @CUIT = '20-36958412-3', @Correo = 'elreydelpancho@gmail.com', @telefono = '+54 11 6523 0014'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Librería y Copias Campus', @CUIT = '27-32659841-8', @Correo = 'campuslibreria@outlook.com', @telefono = '+54 11 4502 3652'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Subway Concesión', @CUIT = '30-70954126-2', @Correo = 'subwayparques@subwayargentina.com', @telefono = '+54 11 5031 2000'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Helados Chungo', @CUIT = '30-58469512-5', @Correo = 'locales@chungo.com.ar', @telefono = '+54 11 4545 3000'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Parrilla El Tano', @CUIT = '30-62145896-4', @Correo = 'eltanoparrilla@hotmail.com', @telefono = '+54 11 4204 5214'

exec Concesiones.SP_Empresa_Alta @Nombre = 'Drugstore Estación', @CUIT = '30-71985412-1', @Correo = 'drugstoreestacion@gmail.com', @telefono = '+54 11 3654 7892'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Regalos Regionales Tandil', @CUIT = '20-25698412-7', @Correo = 'info@regionalestandil.com', @telefono = '+54 249 442 3658'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Empanadas El Noble', @CUIT = '30-70789654-3', @Correo = 'concesiones@elnoble.com.ar', @telefono = '+54 11 5129 7000'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Golosinas y Cía', @CUIT = '30-55698412-6', @Correo = 'ventas@golosinasycia.com', @telefono = '+54 11 4951 2365'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Waffles & Co', @CUIT = '27-40125489-4', @Correo = 'wafflesandco@gmail.com', @telefono = '+54 11 5988 3412'

exec Concesiones.SP_Empresa_Alta @Nombre = 'Choribar Parrilla Urbana', @CUIT = '30-71326598-5', @Correo = 'hola@choribar.com.ar', @telefono = '+54 11 4772 1546'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Kiosco Dulce Visión', @CUIT = '20-31564897-9', @Correo = 'dulcevision@outlook.com', @telefono = '+54 11 6321 4785'
exec Concesiones.SP_Empresa_Alta @Nombre = 'La Matera Regionales', @CUIT = '30-69854125-2', @Correo = 'contacto@lamateraregionales.com', @telefono = '+54 2324 421569'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Sandwichería Gourmet', @CUIT = '30-71456982-8', @Correo = 'gourmet@sandwicheria.com', @telefono = '+54 11 4821 3654'
exec Concesiones.SP_Empresa_Alta @Nombre = 'Donas Delicity', @CUIT = '30-65894125-6', @Correo = 'delicitydonas@gmail.com', @telefono = '+54 11 4371 8899'

--tipos de actividad

exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de bebidas energéticas', @Descripcion = 'Venta de bebidas energéticas y suplementos en la entrada al parque'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Alquiler de bicicletas', @Descripcion = 'Puesto de alquiler de bicicletas paseadoras y de montaña por hora o fracción'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Pizzería y cafetería', @Descripcion = 'Servicio de cafetería por la mañana y pizzería al molde durante el almuerzo y cena'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de artesanías locales', @Descripcion = 'Exposición y comercialización de productos artesanales autóctonos hechos por productores de la región'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Maxikiosco y golosinas', @Descripcion = 'Venta minorista de golosinas, cigarrillos, galletitas y artículos de primera necesidad'

exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Heladería artesanal', @Descripcion = 'Venta de helados artesanales bochas, paletas y postres helados en la zona recreativa'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Puesto de comida rápida', @Descripcion = 'Despacho de panchos, hamburguesas, papas fritas y gaseosas en foodtruck autorizado'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Alquiler de kayaks', @Descripcion = 'Prestación de servicios de alquiler de botes, kayaks y chalecos salvavidas en el muelle'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Tienda de recuerdos y souvenirs', @Descripcion = 'Venta de remeras, gorras, llaveros e imanes alegóricos y personalizados del parque'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Servicio de fotografía profesional', @Descripcion = 'Captura y revelado instantáneo de fotos de los visitantes en los puntos panorámicos'

exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Librería y papelería', @Descripcion = 'Venta de mapas del parque, guías turísticas, postales, revistas y artículos de librería'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Puesto de licuados y jugos', @Descripcion = 'Elaboración y venta de jugos exprimidos naturales, licuados de fruta y ensaladas de fruta frescas'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Alquiler de reposeras y sombrillas', @Descripcion = 'Puesto de atención para el alquiler diario de equipamiento de playa y descanso'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de indumentaria deportiva', @Descripcion = 'Venta de ropa técnica para trekking, gorros para el sol, zapatillas de caminata y protectores'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Parrilla tradicional', @Descripcion = 'Venta de sándwiches de lomo, choripanes y carnes asadas al paso para los visitantes'

exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Kiosco de diarios y revistas', @Descripcion = 'Puesto de distribución de periódicos locales, nacionales, revistas y crucigramas'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Venta de productos orgánicos', @Descripcion = 'Comercialización de frutos secos, miel pura, barras de cereal y snacks saludables'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Estacionamiento medido', @Descripcion = 'Servicio de ordenamiento y custodia de vehículos en las playas de estacionamiento del predio'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Puesto de pochoclos y garrapiñadas', @Descripcion = 'Elaboración a la vista y venta de pochoclos dulces, salados y frutos secos acaramelados'
exec Concesiones.SP_TipoActividad_Alta @Nombre = 'Alquiler de binoculares', @Descripcion = 'Alquiler de equipos ópticos y guías impresas para el avistaje de aves y fauna autóctona'

--concesiones viejas
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 4, @IDTipoActividad = 12, @IDParque = 3, @FechaInicio = '2022-03-01', @FechaFin = '2023-03-01', @Monto_mensual = 650000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 18, @IDTipoActividad = 5, @IDParque = 7, @FechaInicio = '2021-06-01', @FechaFin = '2022-06-01', @Monto_mensual = 480000, @Metodo = 'Efectivo'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 1, @IDTipoActividad = 20, @IDParque = 1, @FechaInicio = '2023-01-01', @FechaFin = '2024-01-01', @Monto_mensual = 800000, @Metodo = 'Débito Automático'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 11, @IDTipoActividad = 8, @IDParque = 10, @FechaInicio = '2020-11-01', @FechaFin = '2021-05-01', @Monto_mensual = 550000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 7, @IDTipoActividad = 14, @IDParque = 5, @FechaInicio = '2024-02-01', @FechaFin = '2025-02-01', @Monto_mensual = 720000, @Metodo = 'Efectivo'

exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 15, @IDTipoActividad = 2, @IDParque = 2, @FechaInicio = '2022-09-01', @FechaFin = '2023-03-01', @Monto_mensual = 420000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 9, @IDTipoActividad = 19, @IDParque = 8, @FechaInicio = '2021-04-01', @FechaFin = '2022-04-01', @Monto_mensual = 900000, @Metodo = 'Débito Automático'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 21, @IDTipoActividad = 11, @IDParque = 4, @FechaInicio = '2023-07-01', @FechaFin = '2024-01-01', @Monto_mensual = 350000, @Metodo = 'Efectivo'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 13, @IDTipoActividad = 17, @IDParque = 9, @FechaInicio = '2020-05-01', @FechaFin = '2021-05-01', @Monto_mensual = 600000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 3, @IDTipoActividad = 3, @IDParque = 6, @FechaInicio = '2022-12-01', @FechaFin = '2023-12-01', @Monto_mensual = 1100000, @Metodo = 'Débito Automático'

exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 20, @IDTipoActividad = 15, @IDParque = 2, @FechaInicio = '2024-05-01', @FechaFin = '2025-05-01', @Monto_mensual = 850000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 6, @IDTipoActividad = 9, @IDParque = 10, @FechaInicio = '2021-10-01', @FechaFin = '2022-04-01', @Monto_mensual = 500000, @Metodo = 'Efectivo'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 14, @IDTipoActividad = 6, @IDParque = 4, @FechaInicio = '2023-08-01', @FechaFin = '2024-08-01', @Monto_mensual = 680000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 2, @IDTipoActividad = 13, @IDParque = 7, @FechaInicio = '2022-01-01', @FechaFin = '2022-07-01', @Monto_mensual = 400000, @Metodo = 'Efectivo'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 17, @IDTipoActividad = 1, @IDParque = 3, @FechaInicio = '2024-04-01', @FechaFin = '2025-04-01', @Monto_mensual = 590000, @Metodo = 'Débito Automático'

--activas
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 5, @IDTipoActividad = 10, @IDParque = 1, @FechaInicio = '2026-01-01', @FechaFin = '2027-01-01', @Monto_mensual = 850000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 12, @IDTipoActividad = 4, @IDParque = 9, @FechaInicio = '2025-08-01', @FechaFin = '2026-08-01', @Monto_mensual = 700000, @Metodo = 'Débito Automático'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 8, @IDTipoActividad = 16, @IDParque = 5, @FechaInicio = '2026-04-01', @FechaFin = '2027-04-01', @Monto_mensual = 620000, @Metodo = 'Efectivo'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 19, @IDTipoActividad = 2, @IDParque = 3, @FechaInicio = '2025-12-01', @FechaFin = '2026-12-01', @Monto_mensual = 950000, @Metodo = 'Transferencia'
exec Concesiones.SP_RegistrarConcesion @IDEmpresa = 10, @IDTipoActividad = 18, @IDParque = 8, @FechaInicio = '2026-06-01', @FechaFin = '2027-06-01', @Monto_mensual = 1200000, @Metodo = 'Débito Automático'

--hacer concesiones que esten parcialmente pagadas
update Concesiones.Pago_mensual set Pago = 'P' where Fecha < '2026-05-01'


--importar parques y empresas de archivos
--los nombres no son los de los archivos originales por claridad
exec Staging.SP_Importar_Nacional @RutaArchivo = 'C:\Datasets\parques.csv'
exec Staging.SP_Importar_EmpresasCSV @RutaArchivo = 'C:\Datasets\empresas.csv'
select * from Staging.Log_Errores_Importacion



--crear tipo de visitante
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Adulto residente nacional'
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Adulto extranjero'
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Menor de edad (6 a 12 años)'
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Jubilado y pensionado nacional'
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Estudiante universitario o terciario'
exec Ventas.SP_TipoVisitante_Alta @Nombre = 'Residente local (provincial/municipal)'
--crear tarifas activas

exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 1
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 1
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 1
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 1
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 1
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 1


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 2
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 2
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 2
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 2
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 2
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 2


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 3
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 3
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 3
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 3
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 3
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 3


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 4
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 4
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 4
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 4
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 4
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 4


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 5
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 5
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 5
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 5
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 5
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 5


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 6
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 6
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 6
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 6
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 6
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 6


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 7
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 7
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 7
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,     @ID_tipo_visitante = 4, @ID_parque = 7
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 7
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 7


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 8
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 8
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 8
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 8
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 8
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 8


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 9
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 9
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 9
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 9
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 9
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 9


exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 15000, @ID_tipo_visitante = 1, @ID_parque = 10
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 35000, @ID_tipo_visitante = 2, @ID_parque = 10
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 8000,  @ID_tipo_visitante = 3, @ID_parque = 10
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 50000,     @ID_tipo_visitante = 4, @ID_parque = 10
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 10000, @ID_tipo_visitante = 5, @ID_parque = 10
exec Ventas.SP_Tarifa_Alta @Fecha_desde = '2026-01-01', @Fecha_hasta = null, @Precio = 5000,  @ID_tipo_visitante = 6, @ID_parque = 10



--ventas de entradas
--@Nombre,@Documento,@tipo_doc,@nacimiento,@ID_tipo visitante;@ID_tour (pueden ser varios separados por ',')|otro visitante
exec Ventas.SP_RegistrarVenta @ID_parque = 1, @Pedido = 'Gustavo Cerati,50000073,ARG,1959-08-11,1;1,2|Marie Curie,50000074,POL,1867-11-07,2;1,2,3', @PuntoDeVenta = 'Ventanilla 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 1, @Pedido = 'Charly Garcia,50000075,ARG,1951-10-23,1;2|Mercedes Sosa,50000076,ARG,1935-07-09,5;1,3,2', @PuntoDeVenta = 'Ventanilla Online 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 1, @Pedido = 'Albert Einstein,50000077,GER,1879-03-14,6;2', @PuntoDeVenta = 'Boletería Central'

exec Ventas.SP_RegistrarVenta @ID_parque = 2, @Pedido = 'Luis Alberto Spinetta,50000078,ARG,1950-01-23,1;4,5', @PuntoDeVenta = 'Boletería Central'
exec Ventas.SP_RegistrarVenta @ID_parque = 2, @Pedido = 'Freddie Mercury,50000080,ENG,1946-09-05,2;4,5,6', @PuntoDeVenta = 'Ventanilla 2'
exec Ventas.SP_RegistrarVenta @ID_parque = 2, @Pedido = 'Ricardo Darin,50000081,ARG,1957-01-16,1;5|Guillermo Francella,50000082,ARG,1955-02-14,2;4,6', @PuntoDeVenta = 'Acceso Sur'

exec Ventas.SP_RegistrarVenta @ID_parque = 3, @Pedido = 'Marta Minujin,50000083,ARG,1943-01-30,1;7,9|Julio Cortazar,50000084,ARG,1914-08-26,3;8', @PuntoDeVenta = 'Ventanilla 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 3, @Pedido = 'Jorge Luis Borges,50000085,ARG,1899-08-24,1;7,8,9', @PuntoDeVenta = 'Ventanilla 2'
exec Ventas.SP_RegistrarVenta @ID_parque = 3, @Pedido = 'Stephen Hawking,50000086,ENG,1942-01-08,2;8|Isaac Newton,50000087,ENG,1643-01-04,2;7,9', @PuntoDeVenta = 'Boletería Central'

exec Ventas.SP_RegistrarVenta @ID_parque = 4, @Pedido = 'Quino Lavado,50000088,ARG,1932-07-17,1;10,12|Mafalda Espejo,50000089,ARG,1964-09-29,5;11', @PuntoDeVenta = 'Acceso Norte'
exec Ventas.SP_RegistrarVenta @ID_parque = 4, @Pedido = 'Elon Musk,50000090,USA,1971-06-28,2;10,11,12', @PuntoDeVenta = 'Ventanilla Online 2'
exec Ventas.SP_RegistrarVenta @ID_parque = 4, @Pedido = 'Tita Merello,50000091,ARG,1904-10-11,6;12|Anibal Troilo,50000092,ARG,1914-07-11,1;10,11', @PuntoDeVenta = 'Ventanilla 1'

exec Ventas.SP_RegistrarVenta @ID_parque = 5, @Pedido = 'René Favaloro,50000093,ARG,1923-07-12,1;13,14|Lalisa Manoban,50000094,THA,1997-03-27,5;15', @PuntoDeVenta = 'Ventanilla Online 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 5, @Pedido = 'Keanu Reeves,50000095,CAN,1964-09-02,2;14,15', @PuntoDeVenta = 'Boletería Central'
exec Ventas.SP_RegistrarVenta @ID_parque = 5, @Pedido = 'Carlos Gardel,50000096,ARG,1890-12-11,1;13|Tita Russ,50000097,ARG,1940-05-15,3;14,15', @PuntoDeVenta = 'Ventanilla 2'

exec Ventas.SP_RegistrarVenta @ID_parque = 6, @Pedido = 'Astor Piazzolla,50000098,ARG,1921-03-11,1;16,17|Amalia Lacroze,50000099,ARG,1921-08-15,5;18', @PuntoDeVenta = 'Ventanilla 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 6, @Pedido = 'Tom Cruise,50000100,USA,1962-07-03,2;16,17,18', @PuntoDeVenta = 'Acceso Este'
exec Ventas.SP_RegistrarVenta @ID_parque = 6, @Pedido = 'Atahualpa Yupanqui,50000101,ARG,1908-01-31,1;17|Lola Mora,50000102,ARG,1866-11-17,6;16,18', @PuntoDeVenta = 'Boletería Principal'

exec Ventas.SP_RegistrarVenta @ID_parque = 7, @Pedido = 'Mariano Moreno,50000103,ARG,1778-09-23,1;19,20,21', @PuntoDeVenta = 'Terminal Automática 2'
exec Ventas.SP_RegistrarVenta @ID_parque = 7, @Pedido = 'Lady Gaga,50000104,USA,1986-03-28,2;19|Taylor Swift,50000105,USA,1989-12-13,2;20,21', @PuntoDeVenta = 'Ventanilla Online 2'
exec Ventas.SP_RegistrarVenta @ID_parque = 7, @Pedido = 'Juana Azurduy,50000106,ARG,1780-07-12,4;19,21', @PuntoDeVenta = 'Ventanilla 1'

exec Ventas.SP_RegistrarVenta @ID_parque = 8, @Pedido = 'Domingo Faustino Sarmiento,50000107,ARG,1811-02-15,1;22|Benjamín Franklin,50000108,USA,1706-01-17,1;23,24', @PuntoDeVenta = 'Informes Entrada'
exec Ventas.SP_RegistrarVenta @ID_parque = 8, @Pedido = 'Bill Gates,50000109,USA,1955-10-28,2;22,23,24', @PuntoDeVenta = 'Boletería Central'
exec Ventas.SP_RegistrarVenta @ID_parque = 8, @Pedido = 'Alfonsina Storni,50000110,ARG,1892-05-29,3;22|Silvina Ocampo,50000111,ARG,1903-07-28,6;23', @PuntoDeVenta = 'Ventanilla 2'

exec Ventas.SP_RegistrarVenta @ID_parque = 9, @Pedido = 'José de San Martín,50000112,ARG,1778-02-25,1;25,26|Remedios de Escalada,50000113,ARG,1797-11-20,5;27', @PuntoDeVenta = 'Ventanilla Online 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 9, @Pedido = 'Steve Jobs,50000114,USA,1955-02-24,2;25,26,27', @PuntoDeVenta = 'Ventanilla 1'
exec Ventas.SP_RegistrarVenta @ID_parque = 9, @Pedido = 'Juan José Castelli,50000115,ARG,1764-07-19,1;26|Manuel Belgrano Segunda,50000116,ARG,1770-06-03,1;25,27', @PuntoDeVenta = 'Acceso Sur'

exec Ventas.SP_RegistrarVenta @ID_parque = 10, @Pedido = 'Federico Moura,50000117,ARG,1951-10-23,1;28,29|Luca Prodan,50000118,ITA,1953-05-17,5;30', @PuntoDeVenta = 'Boletería VIP'
exec Ventas.SP_RegistrarVenta @ID_parque = 10, @Pedido = 'Michael Jackson,50000119,USA,1958-08-29,2;28,29,30', @PuntoDeVenta = 'Boletería VIP'
exec Ventas.SP_RegistrarVenta @ID_parque = 10, @Pedido = 'Luis Sandrini,50000120,ARG,1905-02-22,1;28|Niní Marshall,50000121,ARG,1903-06-01,1;29,30', @PuntoDeVenta = 'Ventanilla Online 2'
/*
select * from Ventas.Pago
select * from ventas.Compra
select * from Ventas.Cliente*/

update Ventas.Pago set Estado = 'C'
--pongo como si hubiesen pagado todo

print 'este ultimo va a fallar porque esta lleno el tour'
begin try
exec Ventas.SP_RegistrarVenta @ID_parque = 1, @Pedido = 'Gustavo Cerati,50000073,ARG,1959-08-11,1;1', @PuntoDeVenta = 'Ventanilla 1'
select * from Atracciones.Tour
end try
begin catch
print error_message()
end catch

exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 40, @ID_Parque = 1, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 40, @ID_Parque = 2, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 40, @ID_Parque = 3, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 41, @ID_Parque = 4, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 41, @ID_Parque = 5, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 41, @ID_Parque = 6, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 42, @ID_Parque = 7, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 42, @ID_Parque = 8, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 42, @ID_Parque = 9, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 43, @ID_Parque = 10, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 43, @ID_Parque = 1, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 43, @ID_Parque = 2, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 44, @ID_Parque = 3, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 44, @ID_Parque = 4, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 44, @ID_Parque = 5, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 45, @ID_Parque = 6, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 45, @ID_Parque = 7, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 45, @ID_Parque = 8, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 46, @ID_Parque = 9, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 46, @ID_Parque = 10, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 46, @ID_Parque = 1, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 47, @ID_Parque = 2, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 47, @ID_Parque = 3, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 47, @ID_Parque = 4, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 48, @ID_Parque = 5, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 48, @ID_Parque = 6, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 48, @ID_Parque = 7, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 49, @ID_Parque = 8, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 49, @ID_Parque = 9, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 49, @ID_Parque = 10, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 50, @ID_Parque = 1, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 50, @ID_Parque = 3, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 50, @ID_Parque = 5, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 51, @ID_Parque = 2, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 51, @ID_Parque = 4, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 51, @ID_Parque = 6, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 52, @ID_Parque = 7, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 52, @ID_Parque = 9, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 52, @ID_Parque = 1, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 53, @ID_Parque = 8, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 53, @ID_Parque = 10, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 53, @ID_Parque = 2, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 54, @ID_Parque = 3, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 54, @ID_Parque = 6, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 54, @ID_Parque = 9, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 55, @ID_Parque = 4, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 55, @ID_Parque = 8, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 55, @ID_Parque = 2, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 56, @ID_Parque = 5, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 56, @ID_Parque = 10, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 56, @ID_Parque = 1, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 57, @ID_Parque = 6, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 57, @ID_Parque = 2, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 57, @ID_Parque = 7, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 58, @ID_Parque = 8, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 58, @ID_Parque = 4, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 58, @ID_Parque = 3, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 59, @ID_Parque = 9, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 59, @ID_Parque = 1, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 59, @ID_Parque = 5, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 60, @ID_Parque = 10, @Fecha_ingreso = '2018-01-01', @Fecha_egreso = '2019-12-31', @Motivo_egreso = 'Traslado'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 60, @ID_Parque = 3, @Fecha_ingreso = '2020-01-01', @Fecha_egreso = '2022-12-31', @Motivo_egreso = 'Rotacion'
exec Empleados.SP_GuardaparqueParque_Alta @ID_Guardaparque = 60, @ID_Parque = 4, @Fecha_ingreso = '2023-01-01', @Fecha_egreso = NULL, @Motivo_egreso = NULL

