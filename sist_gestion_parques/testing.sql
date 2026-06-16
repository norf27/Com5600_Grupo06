
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
exec Parque.SP_TipoParque_Modificar @ID = @ID, @Nombre = 'nombre acuatico', @Desc = 'Nueva descripcion acuatica'
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
exec @ID =  Parque.SP_Parque_Alta @Superficie = 180, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
select * from Parque.parque
--dar de baja (estado cambia a inactivo)
exec Parque.SP_Parque_Baja @ID = @ID
select * from Parque.parque
--dar de alta cambiando la superficie (estado pasa a activo y cambia la descripcion)
exec @ID = Parque.SP_Parque_Alta @Superficie = 2000, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
select * from Parque.parque
--probar de dar de alta cuando sigue como activo
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
end try
begin catch
print error_message()
end catch
--modificar datos de el parque
exec Parque.SP_Parque_Modificar @ID = @ID, @Superficie = 1800, @Nombre = 'parque de la costa', @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
select * from Parque.parque
--probar de insertar con algun error o varios
--superficie null
begin try
exec Parque.SP_Parque_Alta @Superficie = null, @Nombre = 'Parque de la unlam', @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
end try
begin catch
print error_message()
end catch
--nombre null
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  null, @ID_tipo = 1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
end try
begin catch
print error_message()
end catch
--ID tipo null
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  'parque', @ID_tipo = null, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
end try
begin catch
print error_message()
end catch
--ID tipo no existe
begin try
exec Parque.SP_Parque_Alta @Superficie = 180, @Nombre =  'parque', @ID_tipo = -1, @ID_provincia = 1, @Fecha_Ultima_Actualizacion = null
end try
begin catch
print error_message()
end catch
--varios a la vez
begin try
exec Parque.SP_Parque_Alta @Superficie = -1, @Nombre =  null, @ID_tipo = null, @ID_provincia = 255, @Fecha_Ultima_Actualizacion = null
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

PRINT '=================Guia================='
DECLARE @ID_Guia INT;
--Dar de alta:

EXEC @ID_Guia = Empleados.SP_Guia_Alta @Nombre = 'Francisco Pascasio', @DNI = '22333444', @CUIL = '20-22333444-1', @Nacimiento = '1985-05-15', @Sueldo = 350000.00, @ID_Parque = 1
SELECT * FROM Empleados.Empleado WHERE ID = @ID_Guia
SELECT * FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia

--Dar de baja (estado cambia a inactivo en guia y sus relaciones en cascada)
EXEC Empleados.SP_Guia_Baja @ID_Empleado = @ID_Guia
SELECT * FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia

--Dar de alta de vuelta (estado pasa a activo, se reactiva)
/* comentado porque da error
EXEC @ID_Guia = Empleados.SP_Guia_Alta @Nombre = 'Francisco Pascasio', @DNI = '22333444', @CUIL = '20-22333444-1', @Nacimiento = '1985-05-15', @Sueldo = 350000.00, @ID_Parque = 1
SELECT * FROM Empleados.Guia WHERE ID_Empleado = @ID_Guia
*/
--Prueba de dar de alta cuando sigue como activo
BEGIN TRY
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Francisco Pascasio', @DNI = '22333444', @CUIL = '20-22333444-1', @Nacimiento = '1985-05-15', @Sueldo = 350000.00, @ID_Parque = 1
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH 

--Modificar datos del guia (modifica la tabla empleado vinculada)

EXEC Empleados.SP_Guia_Modificar @ID_Empleado = @ID_Guia, @Nacimiento = '1985-05-15', @DNI = '22333444', @Nombre = 'Francisco Moreno', @Sueldo = 400000.00, @Estado = 'a', @ID_Parque = 1, @CUIL = '20-22333444-1'
SELECT * FROM Empleados.Empleado WHERE ID = @ID_Guia


--Pruebas de insercion erronea

-- 1. DNI es NULL
BEGIN TRY
    PRINT 'Prueba 1: DNI NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba DNI', @DNI = NULL, @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. Nombre es NULL
BEGIN TRY
    PRINT 'Prueba 2: Nombre NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = NULL, @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Formato de DNI inválido (menos de 8 dígitos o caracteres alfabéticos)
BEGIN TRY
    PRINT 'Prueba 3: Formato DNI invalido'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Formato', @DNI = '1234AB', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. CUIL es NULL
BEGIN TRY
    PRINT 'Prueba 4: CUIL NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba CUIL', @DNI = '11111111', @CUIL = NULL, @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 5. Formato de CUIL inválido (sin guiones o longitud incorrecta)
BEGIN TRY
    PRINT 'Prueba 5: Formato CUIL invalido'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Formato', @DNI = '11111111', @CUIL = '20111111111', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 6. Fecha de Nacimiento es NULL
BEGIN TRY
    PRINT 'Prueba 6: Nacimiento NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Edad', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = NULL, @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 7. Es menor de edad (menos de 18 años)
BEGIN TRY
    PRINT 'Prueba 7: Menor de edad'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Edad', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '2020-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 8. Sueldo es NULL
BEGIN TRY
    PRINT 'Prueba 8: Sueldo NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Sueldo', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = NULL, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 9. Sueldo es 0 o negativo
BEGIN TRY
    PRINT 'Prueba 9: Sueldo negativo o cero'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Sueldo', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = -5000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 10. ID de Parque es NULL
BEGIN TRY
    PRINT 'Prueba 10: ID Parque NULL'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Parque', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 11. ID de Parque no existe (Asumiendo que el ID 99999 no está registrado)
BEGIN TRY
    PRINT 'Prueba 11: ID Parque Inexistente'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba Parque', @DNI = '11111111', @CUIL = '20-11111111-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 99999
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requieren insertar un registro válido primero)

PRINT '--- Insertando Guia Valido para pruebas de duplicidad ---'
DECLARE @ID_Prueba INT;
EXEC @ID_Prueba = Empleados.SP_Guia_Alta @Nombre = 'Guia Base Duplicidad', @DNI = '99888777', @CUIL = '20-99888777-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1

-- 12. CUIL repetido (Mismo CUIL, diferente DNI)
BEGIN TRY
    PRINT 'Prueba 12: CUIL Repetido'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Prueba CUIL Repetido', @DNI = '11223344', @CUIL = '20-99888777-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 13. Guía ya registrado y activo (Mismo DNI)
BEGIN TRY
    PRINT 'Prueba 13: Guia ya activo'
    EXEC Empleados.SP_Guia_Alta @Nombre = 'Guia Base Duplicidad', @DNI = '99888777', @CUIL = '20-99888777-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- Limpieza del dato de prueba
EXEC Empleados.SP_Guia_Baja @ID_Empleado = @ID_Prueba;



PRINT '=================Habilitacion (Catálogo)================='
DECLARE @ID_Hab INT;

--Dar de alta:
EXEC @ID_Hab = Empleados.SP_Habilitacion_Alta @Nombre = 'Primeros Auxilios', @Detalles = 'RCP y manejo de heridas'
SELECT * FROM Empleados.Habilitacion WHERE ID = @ID_Hab

--Dar de baja (estado cambia a inactivo en habilitacion y sus relaciones en cascada)
EXEC Empleados.SP_Habilitacion_Baja @ID = @ID_Hab
SELECT * FROM Empleados.Habilitacion WHERE ID = @ID_Hab

--Dar de alta cambiando los detalles (estado pasa a activo, se reactiva)
EXEC @ID_Hab = Empleados.SP_Habilitacion_Alta @Nombre = 'Primeros Auxilios', @Detalles = 'RCP avanzado y supervivencia'
SELECT * FROM Empleados.Habilitacion WHERE ID = @ID_Hab

--Prueba de dar de alta cuando sigue como activo
BEGIN TRY
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = 'Primeros Auxilios', @Detalles = 'No importa'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos de la habilitacion
EXEC Empleados.SP_Habilitacion_Modificar @ID = @ID_Hab, @Nombre = 'Primeros Auxilios Avanzados', @Detalles = 'RCP avanzado y supervivencia'
SELECT * FROM Empleados.Habilitacion WHERE ID = @ID_Hab

--Pruebas de insercion erronea

-- 1. Nombre es NULL
BEGIN TRY
    PRINT 'Prueba 1: Nombre NULL'
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = NULL, @Detalles = 'Detalles validos'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. Nombre está vacío o contiene solo espacios
BEGIN TRY
    PRINT 'Prueba 2: Nombre vacio'
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = '   ', @Detalles = 'Detalles validos'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Detalles es NULL
BEGIN TRY
    PRINT 'Prueba 3: Detalles NULL'
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = 'Manejo de 4x4', @Detalles = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH
    
-- 4. Detalles está vacío o contiene solo espacios
BEGIN TRY
    PRINT 'Prueba 4: Detalles vacio'
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = 'Manejo de 4x4', @Detalles = '   '
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requiere insertar un registro primero)

PRINT '--- Insertando Habilitacion Valida para prueba de duplicidad ---'
DECLARE @ID_Hab_Prueba INT;
EXEC @ID_Hab_Prueba = Empleados.SP_Habilitacion_Alta @Nombre = 'Habilitacion de Prueba', @Detalles = 'Detalles originales'

-- 5. Habilitación ya registrada y activa (Mismo nombre)
BEGIN TRY
    PRINT 'Prueba 5: Habilitacion duplicada (activa)'
    -- Intentamos ingresarla de nuevo (incluso si los detalles son diferentes, la clave de unicidad es el nombre)
    EXEC Empleados.SP_Habilitacion_Alta @Nombre = 'Habilitacion de Prueba', @Detalles = 'Otros detalles distintos'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- Limpieza del dato de prueba 
EXEC Empleados.SP_Habilitacion_Baja @ID = @ID_Hab_Prueba;


PRINT '=================Especialidad (Catálogo)================='
DECLARE @ID_Esp INT;

--Dar de alta:
EXEC @ID_Esp = Empleados.SP_Especialidad_Alta @Nombre = 'Botanica', @Detalles = 'Reconocimiento de flora nativa'
SELECT * FROM Empleados.Especialidad WHERE ID = @ID_Esp

--Dar de baja (estado cambia a inactivo en especialidad y sus relaciones en cascada)
EXEC Empleados.SP_Especialidad_Baja @ID = @ID_Esp
SELECT * FROM Empleados.Especialidad WHERE ID = @ID_Esp

--Dar de alta cambiando los detalles (estado pasa a activo, se reactiva)
EXEC @ID_Esp = Empleados.SP_Especialidad_Alta @Nombre = 'Botanica', @Detalles = 'Reconocimiento de flora nativa'
SELECT * FROM Empleados.Especialidad WHERE ID = @ID_Esp

--Prueba de dar de alta cuando sigue activo
BEGIN TRY
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Botanica', @Detalles = 'Otra cosa'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos de la especialidad
EXEC Empleados.SP_Especialidad_Modificar @ID = @ID_Esp, @Nombre = 'Flora Nativa', @Detalles = 'Reconocimiento avanzado de flora'
SELECT * FROM Empleados.Especialidad WHERE ID = @ID_Esp

--Pruebas de insercion erronea

-- 1. Nombre es NULL
BEGIN TRY
    PRINT 'Prueba 1: Nombre NULL'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = NULL, @Detalles = 'Detalles de prueba'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. Nombre está vacío o tiene solo espacios
BEGIN TRY
    PRINT 'Prueba 2: Nombre vacio'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = '   ', @Detalles = 'Detalles de prueba'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Nombre contiene caracteres inválidos (números)
BEGIN TRY
    PRINT 'Prueba 3: Nombre con numeros'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Supervivencia 101', @Detalles = 'Detalles de prueba'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. Nombre contiene caracteres inválidos (símbolos)
BEGIN TRY
    PRINT 'Prueba 4: Nombre con simbolos'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Flora @ Fauna', @Detalles = 'Detalles de prueba'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 5. Detalles es NULL
BEGIN TRY
    PRINT 'Prueba 5: Detalles NULL'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Supervivencia', @Detalles = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 6. Detalles está vacío o tiene solo espacios
BEGIN TRY
    PRINT 'Prueba 6: Detalles vacio'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Supervivencia', @Detalles = '   '
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requiere insertar un registro primero)
PRINT '--- Insertando Especialidad Valida para prueba de duplicidad ---'
DECLARE @ID_Esp_Prueba INT;
EXEC @ID_Esp_Prueba = Empleados.SP_Especialidad_Alta @Nombre = 'Supervivencia Extrema', @Detalles = 'Tecnicas de supervivencia en montaña'

-- 7. Especialidad ya registrada y activa (Mismo nombre)
BEGIN TRY
    PRINT 'Prueba 7: Especialidad duplicada (activa)'
    EXEC Empleados.SP_Especialidad_Alta @Nombre = 'Supervivencia Extrema', @Detalles = 'Otros detalles distintos'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- Limpieza del dato de prueba 
EXEC Empleados.SP_Especialidad_Baja @ID = @ID_Esp_Prueba;


PRINT '=================Titulo (Catálogo)================='
DECLARE @ID_Tit INT;
--Dar de alta:
EXEC @ID_Tit = Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Turismo'
SELECT * FROM Empleados.Titulo WHERE ID = @ID_Tit

--Dar de baja (estado cambia a inactivo en titulo y sus relaciones en cascada)
EXEC Empleados.SP_Titulo_Baja @ID = @ID_Tit
SELECT * FROM Empleados.Titulo WHERE ID = @ID_Tit

--Dar de alta cambiando los detalles (estado pasa a activo, se reactiva)
EXEC @ID_Tit = Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Turismo'
SELECT * FROM Empleados.Titulo WHERE ID = @ID_Tit

--Prueba de dar de alta cuando sigue activo
BEGIN TRY
    EXEC Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Turismo'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos del titulo
EXEC Empleados.SP_Titulo_Modificar @ID = @ID_Tit, @Nombre = 'Licenciado en Turismo Sustentable'
SELECT * FROM Empleados.Titulo WHERE ID = @ID_Tit

--Pruebas de insercion erronea
-- 1. Nombre es NULL
BEGIN TRY
    PRINT 'Prueba 1: Nombre NULL'
    EXEC Empleados.SP_Titulo_Alta @Nombre = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. Nombre está vacío o contiene solo espacios
BEGIN TRY
    PRINT 'Prueba 2: Nombre vacio'
    EXEC Empleados.SP_Titulo_Alta @Nombre = '   '
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Nombre contiene caracteres inválidos (números)
BEGIN TRY
    PRINT 'Prueba 3: Nombre con numeros'
    EXEC Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Turismo 2026'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. Nombre contiene caracteres inválidos (símbolos)
BEGIN TRY
    PRINT 'Prueba 4: Nombre con simbolos'
    EXEC Empleados.SP_Titulo_Alta @Nombre = 'Tecnicatura / Guia'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH


-- PRUEBAS DE DUPLICIDAD (Requiere insertar un registro primero)

PRINT '--- Insertando Titulo Valido para prueba de duplicidad ---'
DECLARE @ID_Tit_Prueba INT;
EXEC @ID_Tit_Prueba = Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Biologia'

-- 5. Título ya registrado y activo (Mismo nombre)
BEGIN TRY
    PRINT 'Prueba 5: Titulo duplicado (activo)'
    EXEC Empleados.SP_Titulo_Alta @Nombre = 'Licenciatura en Biologia'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- Limpieza del dato de prueba 
EXEC Empleados.SP_Titulo_Baja @ID = @ID_Tit_Prueba;


PRINT '=================Guia - Habilitacion================='

--Dar de alta (crea o recupera la habilitacion 'Alta Montaña' y la asigna al guia):
EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_Guia, @Nombre_Habilitacion = 'Alta Montaña', @Detalles_Habilitacion = 'Rescate', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'n'
SELECT @ID_Hab = ID FROM Empleados.Habilitacion WHERE Nombre = 'Alta Montaña';
SELECT * FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Hab

--Dar de baja (estado cambia a inactivo)
EXEC Empleados.SP_GuiaHabilitacion_Baja @ID_Guia = @ID_Guia, @ID_Habilitacion = @ID_Hab
SELECT * FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Hab

--Dar de alta nuevamente (reactiva la relacion)
/* comentado porque da error
EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_Guia, @Nombre_Habilitacion = 'Alta Montaña', @Detalles_Habilitacion = 'Rescate', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'n'
SELECT * FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Hab
*/
--Prueba de dar de alta cuando sigue activo
BEGIN TRY
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_Guia, @Nombre_Habilitacion = 'Alta Montaña', @Detalles_Habilitacion = 'Rescate', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'n'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos en la relacion
EXEC Empleados.SP_GuiaHabilitacion_Modificar @ID_Guia = @ID_Guia, @ID_Habilitacion = @ID_Hab, @NuevaFecha_Vencimiento = '2035-12-31', @NuevoTipo = 'p'
SELECT * FROM Empleados.R_Guia_Habilitacion WHERE ID_Guia = @ID_Guia AND ID_Habilitacion = @ID_Hab

--Pruebas de insercion erronea
DECLARE @ID_GuiaHab_Prueba INT;
EXEC @ID_GuiaHab_Prueba = Empleados.SP_Guia_Alta @Nombre = 'Guia Test Relacion', @DNI = '55666777', @CUIL = '20-55666777-1', @Nacimiento = '1990-01-01', @Sueldo = 300000, @ID_Parque = 1;

-- 1. ID Guia es NULL
BEGIN TRY
    PRINT 'Prueba 1: ID Guia NULL'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = NULL, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. ID Guia Inexistente
BEGIN TRY
    PRINT 'Prueba 2: ID Guia Inexistente'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = 999999, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Fecha de Vencimiento NULL
BEGIN TRY
    PRINT 'Prueba 3: Fecha Vencimiento NULL'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = NULL, @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. Fecha de Vencimiento en el pasado
BEGIN TRY
    PRINT 'Prueba 4: Fecha Vencimiento pasada'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = '2000-01-01', @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 5. Tipo de habilitacion invalido (Fuera del dominio municipal/provincial/nacional)
BEGIN TRY
    PRINT 'Prueba 5: Tipo de habilitacion invalido'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'internacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 6. Error heredado de Habilitacion: Nombre NULL
BEGIN TRY
    PRINT 'Prueba 6: Nombre Habilitacion NULL (Heredado)'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = NULL, @Detalles_Habilitacion = 'Control de plagas', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 7. Error heredado de Habilitacion: Detalles NULL
BEGIN TRY
    PRINT 'Prueba 7: Detalles Habilitacion NULL (Heredado)'
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Caza', @Detalles_Habilitacion = NULL, @Fecha_Vencimiento = '2030-01-01', @Tipo = 'nacional'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requiere insertar la relación primero)

PRINT '--- Insertando Relacion Valida para prueba de duplicidad ---'
EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Pesca Deportiva', @Detalles_Habilitacion = 'Pesca y devolucion', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'provincial'

-- 8. Relación ya registrada y activa
BEGIN TRY
    PRINT 'Prueba 8: Asignacion duplicada (activa)'
    -- Intentamos asignarle la MISMA habilitacion al MISMO guia
    EXEC Empleados.SP_GuiaHabilitacion_Alta @ID_Guia = @ID_GuiaHab_Prueba, @Nombre_Habilitacion = 'Pesca Deportiva', @Detalles_Habilitacion = 'Pesca y devolucion', @Fecha_Vencimiento = '2030-01-01', @Tipo = 'provincial'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- Limpieza del dato de prueba 
EXEC Empleados.SP_Guia_Baja @ID_Empleado = @ID_GuiaHab_Prueba;


PRINT '=================Guia - Especialidad================='
--Dar de alta:
EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_Guia, @Nombre_Especialidad = 'Avistaje de Aves', @Detalles_Especialidad = 'Ornitologia', @Nivel = 'E'
SELECT @ID_Esp = ID FROM Empleados.Especialidad WHERE Nombre = 'Avistaje de Aves';
SELECT * FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Esp

--Dar de baja (estado cambia a inactivo)
EXEC Empleados.SP_GuiaEspecialidad_Baja @ID_Guia = @ID_Guia, @ID_Especialidad = @ID_Esp
SELECT * FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Esp

--Dar de alta nuevamente (reactiva la relacion)
/* comentado porque da error
EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_Guia, @Nombre_Especialidad = 'Avistaje de Aves', @Detalles_Especialidad = 'Ornitologia', @Nivel = 'E'
SELECT * FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Esp
*/
--Prueba de dar de alta cuando sigue activo
BEGIN TRY
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_Guia, @Nombre_Especialidad = 'Avistaje de Aves', @Detalles_Especialidad = 'Ornitologia', @Nivel = 'E'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos en la relacion
EXEC Empleados.SP_GuiaEspecialidad_Modificar @ID_Guia = @ID_Guia, @ID_Especialidad = @ID_Esp, @NuevoNivel = 'B'
SELECT * FROM Empleados.R_Guia_Especialidad WHERE ID_Guia = @ID_Guia AND ID_Especialidad = @ID_Esp

--Pruebas de insercion erronea
DECLARE @ID_GuiaEsp_Prueba INT;
EXEC @ID_GuiaEsp_Prueba = Empleados.SP_Guia_Alta @Nombre = 'Guia Test Especialidad', @DNI = '66777888', @CUIL = '20-66777888-1', @Nacimiento = '1992-01-01', @Sueldo = 320000, @ID_Parque = 1;

-- 1. ID Guia es NULL
BEGIN TRY
    PRINT 'Prueba 1: ID Guia NULL'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = NULL, @Nombre_Especialidad = 'Escalada', @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. ID Guia Inexistente
BEGIN TRY
    PRINT 'Prueba 2: ID Guia Inexistente'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = 999999, @Nombre_Especialidad = 'Escalada', @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Nivel es NULL
BEGIN TRY
    PRINT 'Prueba 3: Nivel NULL'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Escalada', @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. Nivel está vacío o contiene espacios
BEGIN TRY
    PRINT 'Prueba 4: Nivel Vacio'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Escalada', @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = ' '
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 5. Error heredado de Especialidad: Nombre NULL
BEGIN TRY
    PRINT 'Prueba 5: Nombre Especialidad NULL (Heredado)'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = NULL, @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 6. Error heredado de Especialidad: Nombre con caracteres inválidos
BEGIN TRY
    PRINT 'Prueba 6: Nombre Especialidad con Numeros (Heredado)'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Escalada 101', @Detalles_Especialidad = 'Manejo de cuerdas', @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 7. Error heredado de Especialidad: Detalles NULL
BEGIN TRY
    PRINT 'Prueba 7: Detalles Especialidad NULL (Heredado)'
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Escalada', @Detalles_Especialidad = NULL, @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requiere insertar la relación primero)

PRINT '--- Insertando Relacion Valida para prueba de duplicidad ---'
EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Fotografia de Naturaleza', @Detalles_Especialidad = 'Fotografia macro y paisaje', @Nivel = 'B'

-- 8. Relación ya registrada y activa
BEGIN TRY
    PRINT 'Prueba 8: Asignacion duplicada (activa)'
    -- Intentamos asignarle la MISMA especialidad al MISMO guia
    EXEC Empleados.SP_GuiaEspecialidad_Alta @ID_Guia = @ID_GuiaEsp_Prueba, @Nombre_Especialidad = 'Fotografia de Naturaleza', @Detalles_Especialidad = 'Fotografia macro y paisaje', @Nivel = 'E'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH


-- Limpieza del dato de prueba 
EXEC Empleados.SP_Guia_Baja @ID_Empleado = @ID_GuiaEsp_Prueba;


PRINT '=================Guia - Titulo================='
--Dar de alta:
EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_Guia, @Nombre_Titulo = 'Guia de Parque Nacional', @Fecha_emision = '2010-12-01', @Origen = 'Ministerio de Turismo'
SELECT @ID_Tit = ID FROM Empleados.Titulo WHERE Nombre = 'Guia de Parque Nacional';
SELECT * FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Tit

--Dar de baja (estado cambia a inactivo)
EXEC Empleados.SP_GuiaTitulo_Baja @ID_Guia = @ID_Guia, @ID_Titulo = @ID_Tit
SELECT * FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Tit

--Dar de alta nuevamente (reactiva la relacion)
/* comentado porque da error
EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_Guia, @Nombre_Titulo = 'Guia de Parque Nacional', @Fecha_emision = '2010-12-01', @Origen = 'Ministerio de Turismo'
SELECT * FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Tit
*/
--Prueba de dar de alta cuando sigue activo
BEGIN TRY
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_Guia, @Nombre_Titulo = 'Guia de Parque Nacional', @Fecha_emision = '2010-12-01', @Origen = 'Ministerio de Turismo'
END TRY
BEGIN CATCH
    PRINT error_message()
END CATCH

--Modificar datos en la relacion
EXEC Empleados.SP_GuiaTitulo_Modificar @ID_Guia = @ID_Guia, @ID_Titulo = @ID_Tit, @NuevaFecha_emision = '2011-03-15', @NuevoOrigen = 'APN'
SELECT * FROM Empleados.R_Guia_Titulo WHERE ID_Guia = @ID_Guia AND ID_Titulo = @ID_Tit

--Pruebas de insercion erronea

DECLARE @ID_GuiaTit_Prueba INT;
EXEC @ID_GuiaTit_Prueba = Empleados.SP_Guia_Alta @Nombre = 'Guia Test Titulo', @DNI = '77888999', @CUIL = '20-77888999-1', @Nacimiento = '1993-01-01', @Sueldo = 340000, @ID_Parque = 1;

-- 1. ID Guia es NULL
BEGIN TRY
    PRINT 'Prueba 1: ID Guia NULL'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = NULL, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = '2020-05-10', @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 2. ID Guia Inexistente
BEGIN TRY
    PRINT 'Prueba 2: ID Guia Inexistente'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = 999999, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = '2020-05-10', @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 3. Fecha de emision NULL
BEGIN TRY
    PRINT 'Prueba 3: Fecha Emision NULL'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = NULL, @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 4. Fecha de emision en el futuro
BEGIN TRY
    PRINT 'Prueba 4: Fecha Emision Futura'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = '2050-01-01', @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 5. Origen es NULL
BEGIN TRY
    PRINT 'Prueba 5: Origen NULL'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = '2020-05-10', @Origen = NULL
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 6. Origen está vacío o contiene espacios
BEGIN TRY
    PRINT 'Prueba 6: Origen Vacio'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Guia de Alta Montaña', @Fecha_emision = '2020-05-10', @Origen = '   '
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 7. Error heredado de Titulo: Nombre NULL
BEGIN TRY
    PRINT 'Prueba 7: Nombre Titulo NULL (Heredado)'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = NULL, @Fecha_emision = '2020-05-10', @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- 8. Error heredado de Titulo: Nombre con caracteres inválidos (Números)
BEGIN TRY
    PRINT 'Prueba 8: Nombre Titulo con Numeros (Heredado)'
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Guia 2026', @Fecha_emision = '2020-05-10', @Origen = 'Ministerio'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH

-- PRUEBAS DE DUPLICIDAD (Requiere insertar la relación primero)

PRINT '--- Insertando Relacion Valida para prueba de duplicidad ---'
EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Tecnicatura en Turismo', @Fecha_emision = '2015-12-01', @Origen = 'Universidad Provincial'

-- 9. Relación ya registrada y activa
BEGIN TRY
    PRINT 'Prueba 9: Asignacion duplicada (activa)'
    -- Intentamos asignarle el MISMO titulo al MISMO guia (incluso variando fecha/origen, la clave principal es Titulo-Guia)
    EXEC Empleados.SP_GuiaTitulo_Alta @ID_Guia = @ID_GuiaTit_Prueba, @Nombre_Titulo = 'Tecnicatura en Turismo', @Fecha_emision = '2016-01-01', @Origen = 'Otro Origen'
END TRY
BEGIN CATCH PRINT CONCAT('   -> ERROR: ', ERROR_MESSAGE()) END CATCH


-- Limpieza del dato de prueba
EXEC Empleados.SP_Guia_Baja @ID_Empleado = @ID_GuiaTit_Prueba;
  
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
exec Concesiones.SP_TipoActividad_Modificar @ID = @ID, @Nombre = 'venta de comida saludable', @Desc = 'venta de comida saludable en algun lado'
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
select * from Concesiones.Pago_mensual
end try
begin catch
print error_message()
end catch
print 'aca'
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

print '=================Gestion concesiones y pagos================='

--testing concesion
Declare @ID_Parque_1 int
Declare @ID_prov int
declare @ID_tipo_parque int
declare @ID_tipo_actividad int
declare @ID_empresa int
declare @ID_concesion int
--crear tipo de parque y provincia
exec @ID_tipo_parque = Parque.SP_TipoParque_Alta 'Seco','No esta mojado'
exec @ID_prov = Parque.SP_Provincia_Alta 'Mendoza'
--crear parque
exec @ID_Parque_1 = Parque.SP_Parque_Alta 2000, 'Parque del norte', @ID_tipo_parque, @ID_prov, @Fecha_Ultima_Actualizacion = null 
--crear tipo de actividad
exec @ID_tipo_actividad = Concesiones.SP_TipoActividad_Alta 'Venta de comida', 'vende comida en la entrada al predio'
--crear Empresa
exec @ID_empresa = Concesiones.SP_Empresa_Alta 'Super Panchos SA', '20-12345678-1', 'superPanchos@gmail.com'

--registrar concesion
exec @ID_concesion = Concesiones.SP_RegistrarConcesion @ID_empresa, @ID_tipo_actividad, @ID_Parque_1, '2026-08-01', '2026-12-01', 1800.75, 'Efectivo'
select * from Concesiones.Concesion
select * from Concesiones.Pago_mensual

--registrar un pago para el primer mes
exec Concesiones.SP_RegistrarPago @ID_concesion, '2026-08-01'
select * from Concesiones.Pago_mensual

--probar de registrar concesion duplicada
begin try
exec @ID_concesion = Concesiones.SP_RegistrarConcesion @ID_empresa, @ID_tipo_actividad, @ID_Parque_1, '2026-08-01', '2026-12-01', 1800.75, 'Efectivo'
end try
begin catch
print error_message()
end catch

--probar de registrar pago para un mes ya pagado
begin try
exec Concesiones.SP_RegistrarPago @ID_concesion, '2026-08-01'
end try
begin catch
print error_message()
end catch
--probar de registrar pago para una concesion que no y fecha null
begin try
exec Concesiones.SP_RegistrarPago -1, null
end try
begin catch
print error_message()
end catch
--borrar concesion (deja todos los pagos en estado 'i')
exec Concesiones.SP_Concesion_Baja @ID_concesion
select * from Concesiones.Pago_mensual


print '=================Registrar ventas================='
--Pruebas Ventas
Declare @ID_Parque_1_vts int, @ID_Parque_2_vts int
Declare @ID_tipo_visitante_1 int, @ID_tipo_visitante_2 int
Declare @ID_prov_vts int
declare @ID_tipo_parque_vts int
declare @ID_tarifa_1 int, @ID_tarifa_2 int
declare @ID_tour_1 int, @ID_tour_2 int, @ID_tour_3 int
--crear 2 tipos de visitante
exec @ID_tipo_visitante_1 = Ventas.SP_TipoVisitante_Alta 'Adulto'
exec @ID_tipo_visitante_2 = Ventas.SP_TipoVisitante_Alta 'Estudiante'
--crear tipo de parque y provincia
exec @ID_tipo_parque_vts = Parque.SP_TipoParque_Alta 'Acuatico','Esta mojado'
exec @ID_prov_vts = Parque.SP_Provincia_Alta 'Cordoba'
--crear 2 parques
exec @ID_Parque_1_vts = Parque.SP_Parque_Alta 2000, 'Parque de la jungla', @ID_tipo_parque_vts, @ID_prov_vts, null, null, null
exec @ID_Parque_2_vts = Parque.SP_Parque_Alta 150,'parque el palmar', @ID_tipo_parque_vts, @ID_prov_vts, null, null, null
--crear 1 cliente
exec Ventas.SP_Cliente_Alta 'Lionel Messi', '12345678', 'ARG', '1987-06-24'
--crear 2 tarifas
exec @ID_tarifa_1 = Ventas.SP_Tarifa_Alta '2025-01-01', NULL, 150, @ID_tipo_visitante_1, @ID_Parque_1_vts --entrada para adulto = 150
exec @ID_tarifa_2 = Ventas.SP_Tarifa_Alta '2025-01-01', NULL, 50, @ID_tipo_visitante_2, @ID_Parque_1_vts --entrada para estudiante = 50
--crear tours
exec @ID_tour_1 = Atracciones.SP_Tour_Alta 200, 5, 'a', 20, @ID_Parque_1_vts --cupo max = 5 personas, cuesta 200
exec @ID_tour_2 = Atracciones.SP_Tour_Alta 300, 3, 'a', 20, @ID_Parque_1_vts --cupo max = 3 personas, cuesta 300
exec @ID_tour_3 = Atracciones.SP_Tour_Alta 50, 50, 'a', 20, @ID_Parque_2_vts --cupo max = 50, cuesta 50

Print '======compras=========='

--realizar compras para 1 sola persona ya registrada
declare @pedido varchar(8000)
set @pedido = concat('Lionel Messi,12345678,ARG,1987-06-24,', @ID_tipo_visitante_1, ';', @ID_tour_1);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
select * from Ventas.Cliente
select * from Ventas.Compra --total = 350 = 200(tour) + 150(entrada)
--realizar compras para 1 persona sin registrar (debera registrarla)
set @pedido = concat('Nicolas Orfano,87654321,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
select * from Ventas.Cliente
select * from Ventas.Compra --total = 250 = 200(tour) + 50(entrada)

--realizar compras para una persona con varios tours validos
set @pedido = concat('Santiago Grasso,11112222,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1, ',', @ID_tour_2);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
select * from Ventas.Cliente
select * from Ventas.Compra --total = 550 = 200(tour 1) + 300(tour 2) + 50(entrada)
--realizar compras para una persona con 1 tour invalido (ID no existe)(da error)
begin try
set @pedido = concat('Lionel Scaloni,22221111,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1, ',', @ID_tour_2, ',', -1);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
end try
begin catch
print error_message()
end catch

--realizar compras para una persona con 1 tour de otro parque (debera dar error)
begin try
set @pedido = concat('Lionel Scaloni,22221111,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1, ',', @ID_tour_2, ',', @ID_tour_3);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
end try
begin catch
print error_message()
end catch
--realizar compra para 2 personas, cada una con distintos tours
set @pedido = concat('Lionel Scaloni,22221111,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1, ',', '|', 
					 'Diego Armando Maradona,10101010,ARG,1987-06-24,', @ID_tipo_visitante_1, ';', @ID_tour_2
);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
select * from Ventas.Compra --total = 700. tarifa de entrada: 50 (sacaloni) + 150 (maradona). tours: 200 (sacaloni) + 300 (maradona)
--realizar compra para un tour cuando ya esta lleno el cupo para ese dia
--en este caso el tour_2 tiene cupo para 3 personas y ya hay 2 entradas asociadas a este tour para la fecha de hoy
--pero le pedimos 2 mas (1 para Dibu Martinez y 1 para Michael Jackson
begin try
set @pedido = concat('Dibu Martinez,11111111,ARG,1987-06-24,', @ID_tipo_visitante_2, ';', @ID_tour_1, ',', @ID_tour_2,'|',
'Michael Jackson,00100212,ARG,1987-06-24,', @ID_tipo_visitante_1, ';', @ID_tour_1, ',', @ID_tour_2
);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
end try
begin catch
print error_message()
end catch
--enviar datos invalidos 
--dar fecha invalida
begin try
set @pedido = concat('Dibu Martinez,11111111,ARG,soy fecha invalida,', @ID_tipo_visitante_2, ';', @ID_tour_1);
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
end try
begin catch
print error_message()
end catch
--dar tour que no es numero
begin try
set @pedido = concat('Dibu Martinez,11111111,ARG,soy fecha invalida,', @ID_tipo_visitante_2, ';', 'soy un tour que no es numero');
exec Ventas.SP_RegistrarVenta @ID_parque = @ID_Parque_1_vts, @Pedido = @pedido, @PuntoDeVenta = 'ventanilla'
end try
begin catch
print error_message()
end catch
