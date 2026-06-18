/*
Fecha: 03/07/2026
Integrantes: Cuda Federico, Santiago Grasso, Luna Gauna Thiago Gonzalo, Nicolas Orfano
Descripcion:
Procedimiento de negocio para el registro de ventas de entradas.
*/
use sist_gestion_parques
go
--se le tiene que mandar un varchar con el formato datos_persona;datos entrada; datos tours |
--dar sin ningun espacio
--@Nombre,@Documento,@tipo_doc,@nacimiento,@ID_tipo visitante;@ID_tour (pueden ser varios separados por ',')|otro visitante
/*
como funciona paso a paso:
1) separar los campos por | de forma que solo quedan los datos en 1 string de cada cliente (con tours e info del visitante)
2) separar los campos por ; de forma que solo quedan los datos de visitante en 1 string y los de tours en otro
3) separar los campos por , para que quede la informacion del visitante en diferentes columnas (si queda null es porque hubo un error)
4) separar los campos por , para que quede cada tour en una fila diferente asociado el ID del visitante 
(el ID es uno temporal asignado, no el que habra en la tabla cliente) quedaria tipo ID | TOUR
si algun tour queda null es porque hubo un error
5) Limpiar las tablas: falla si pasa alguna de las siguientes cosas
	algun visitante con algo null 
	hay un tour donde haya algo null (siendo que se envio un parametro por tour)
	si el tour no existe o no esta activo
	no hay tarifa de visitante para el parque pedido que este activa
6) ver si hay cupo para todos los tours pedidos. Para esto se hace:
	hacer una tabla temporal que sea ID_TOUR | cantidad pedida total
	hacer cupo maximo (de la tabla de tours real) - cantidad pedida hoy (cantidad de entradas que tengan la fecha de hoy y ese tour)
	si esa resta < cantidad pedida total para ese tour -> entonces da error porque no quedan cupos para todo lo pedido
7) ver si hay tours asignados donde el ID_parque del tour no sea el de este pedido, si es asi da error
8) insertar o actualizar clientes
	poner en una tabla temporal nueva para que los ids queden secuenciales asi hacemos un for aumentando el ID por 1
	hacer un for que es: if existe el cliente -> modicar la fila. else -> agregar cliente
9) crear compra de entradas (con total = 0, pero para crear entradas necesitamos una compra)
10) crear una tabla temporal para guardar ID_cliente (el id real de la tabla cliente)| ID_tarifa | Precio tarifa | Precio tours 
	y con eso crear la fila de entrada por cada cliente y despues sumando el total de todas las tarifas + tours guardar en compra
*/




create or alter procedure Ventas.SP_RegistrarVenta @ID_parque int, @Pedido varchar(max), @PuntoDeVenta varchar(100) as
begin
	set nocount on
	declare @Fecha_actual date = getdate()
	DECLARE @error varchar(500) = ''
	if @ID_parque is null
		set @error += 'El ID_parque no puede ser null' + char(10)
	if @Pedido is null
		set @error += 'El pedido no puede ser null' + char(10)
	if not exists(select 1 from Parque.Parque where ID = @ID_parque and Estado = 'A')
		set @error += 'El ID_parque ingresado no existe' + char(10)

	if @error != ''
		throw 50001, @error, 1
	--hacer tabla temporal del que se esta leyendo ahora
	create table #VisitanteJunto 
	(
		ID int,
		info varchar(8000) COLLATE database_default
	)
	create table #VisitanteYTours--
	(
		ID int,
		info_visitante varchar(8000) COLLATE database_default,
		info_tours varchar(8000) COLLATE database_default
	)
	create table #VisitanteSeparado
	(
	ID int,
	Nombre varchar(100) COLLATE database_default,
	Documento varchar(20) COLLATE database_default, 
	Tipo_doc varchar(20) COLLATE database_default,
	Nacimiento date,
	ID_tipo int
	)
	create table #tours
	( 
	ID_visitante int,
	ID_tour int
	)
	CREATE TABLE #ProcesarClientes 
	(
    FilaID INT PRIMARY KEY,
    Nombre VARCHAR(100) COLLATE database_default,
    Documento VARCHAR(20) COLLATE database_default,
    Tipo_doc VARCHAR(20) COLLATE database_default,
	Nacimiento DATE
	)

	--1)
	insert into #VisitanteJunto(ID, info)
	select row_number() over(order by (select 1)), value
	FROM string_split(@Pedido,'|')
	
	--2)
	--left agarra los primeros X caracteres, para saber cuantos agarro hago charindex que da la pos del ; -1 asi no incluyo el ;
	--dps right agarra los ultimox X caracteres, para eso hago largo del str - la pos.
	--EJ: si tengo aaa;bbb. char index ; devuelve 4 -> agarro los primeros 3. y los ultimos (7 - 4) 3
	insert into #VisitanteYTours(ID, info_visitante, info_tours)
	select ID, left(info, charindex(';', info) - 1), right(info, len(info) - charindex(';', info))
	from #VisitanteJunto
	
	--3)
	--cross apply actua como un for para cada fila de v y devuelve en 5 filas distintas los datos de cada fila de v
	--tipo ID | value | ordinal
	--usamos pivot para transformar estas filas que van del 1 al 5 en columnas
	--va a haber mas de un ordinal 1,2 o lo que sea pero como tenemos el ID para a hacer una fila para cada ID
	--uso try_cast asi si el str esta mal no crashea la consulta, sino que deja con null y mas tarde descartamos
	;with src as (
	select 
	v.ID,s.value, s.ordinal
	from #VisitanteYTours v cross apply string_split(v.info_visitante, ',', 1) s
	)
	insert into #VisitanteSeparado
	select ID, try_cast([1] as varchar(100)), try_cast([2] as varchar(20)), try_cast([3] as varchar(20)), try_cast([4] as date), try_cast([5] as int)
	from src
	pivot(max(value) for src.ordinal in ([1],[2],[3],[4],[5])) as pvt
	

	--4)
	--string split devuelve por cada string de numeros como '1,2,3,4' 
	--una tabla ID | value | ordinal
	--de ahi agarramos solo ID y value
	insert into #tours
	select
    v.ID,
    try_cast(s.value as int) as ID_tour
	from #VisitanteYTours v
	cross apply string_split(v.info_tours, ',', 1) s
	WHERE TRIM(s.value) != ''
	--fin parsear informacion

	--5)
	--limpiar tablas


	
	IF EXISTS (
		SELECT 1
		FROM #VisitanteSeparado v
		LEFT JOIN #tours t ON v.ID = t.ID_visitante 
		WHERE 
			-- Si alguno es null es pq no se pudo castear el visitante
			v.Nombre IS NULL 
			OR v.Documento IS NULL 
			OR v.Tipo_doc IS NULL 
			OR v.Nacimiento IS NULL 
			OR v.ID_tipo IS NULL
        
	
			--si probo de ingresar un tour pero fallo el casteo (quedo null)
			OR EXISTS (SELECT 1 FROM #tours t2 WHERE t2.ID_visitante = v.ID AND t2.ID_tour IS NULL)
			
			--si el tour no existe
			OR (t.ID_tour IS NOT NULL AND t.ID_tour NOT IN (SELECT ID_Tour FROM Atracciones.Tour WHERE Estado != 'I'))
			
			--ver que el tipo de visitante coincida con alguna tarifa activa
			OR v.ID_tipo NOT IN (SELECT ID FROM Ventas.Tarifa WHERE Fecha_hasta IS NULL AND Estado = 'A' AND ID_parque = @ID_parque)
	)
	BEGIN
		THROW 51000, 'Hubo un problema a la hora de extraer los datos', 1;
	END;

	--6)
	--ver si hay espacio en los tours pedidos 
	create TABLE #DemandaPedido
	(
		ID_Tour INT,
		CantidadSolicitada INT
	)
	
	INSERT INTO #DemandaPedido (ID_Tour, CantidadSolicitada)
	SELECT ID_tour, COUNT(*)
	FROM #tours
	GROUP BY ID_tour

	
	IF EXISTS (
			SELECT 1
			FROM #DemandaPedido dp
			INNER JOIN Atracciones.Tour tr ON dp.ID_Tour = tr.ID_Tour
			WHERE (
				tr.Cupo_max -- cupo maximo del tour
				- 
				-- menos las personas que ya compraron hoy
				ISNULL((
					SELECT COUNT(*) --contar de gente que pidio ese tour hoy
					FROM Atracciones.R_Tour_Entrada rte 
					INNER JOIN Ventas.Entrada e ON rte.ID_Entrada = e.ID --queda la tabla ID tour | ID entrada y sobre esa hacemos el count(*) a ver cuantas filas de hoy tienen eso
					WHERE rte.ID_Tour = dp.ID_Tour --solo tomar en cuenta el tour de la fila "actual" 
					  AND e.Fecha_acceso = CAST(@Fecha_actual AS DATE)
					  AND e.Estado = 'A'
				), 0)
			) < dp.CantidadSolicitada --si cupos libres - ocupados < lo que pedimos en este pedido, dar error
		)
			THROW 51001, 'Algun tour de los pedidos esta lleno', 1
	
	--7)

	if exists (select 1 from Atracciones.Tour t inner join #tours ts on ts.ID_tour = t.ID_Tour where ID_Parque != @ID_parque)
		THROW 51001, 'Algun tour de los pedidos no pertenece al parque', 1 
	--insertar Clientes que no existan

	
	--8) 

	--insertar en ProcesarClientes para que queden ids de forma secuencial
	--asi se puede hacer un for aumentando la id por 1
	INSERT INTO #ProcesarClientes (FilaID, Nombre, Documento, Tipo_doc, Nacimiento)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS FilaID, 
		Nombre, 
		Documento, 
		Tipo_doc,
		Nacimiento
	FROM #VisitanteSeparado;

	--vars para hacer el for 
	DECLARE @TotalFilas INT = (SELECT MAX(FilaID) from #ProcesarClientes);
	DECLARE @FilaActual INT = 1;

	DECLARE @Nombre VARCHAR(100),
			@Documento VARCHAR(20),
			@Tipo_doc VARCHAR(20),
			@Nacimiento DATE
	begin transaction
	begin try
	WHILE @FilaActual <= @TotalFilas
	BEGIN
		SELECT 
			@Nombre = Nombre,
			@Documento = Documento,
			@Tipo_doc = Tipo_doc,
			@Nacimiento = Nacimiento
		FROM #ProcesarClientes
		WHERE FilaID = @FilaActual;

		--ver si existe
		IF EXISTS (
			SELECT 1 
			FROM Ventas.Cliente 
			WHERE Documento = @Documento AND Tipo_doc = @Tipo_doc
		)
		BEGIN --si existe en la tabla, actualizar datos, siempre los actualizo por si esta desactivado
			DECLARE @ID_real_actual int = (select ID from Ventas.Cliente WHERE Documento = @Documento AND Tipo_doc = @Tipo_doc)
			EXEC Ventas.SP_Cliente_Modificar
				@ID = @ID_real_actual,
				@Nombre = @Nombre, 
				@Documento = @Documento, 
				@Tipo_doc = @Tipo_doc, 
				@Nacimiento = @Nacimiento
		END
		ELSE
		BEGIN
			--si no existe, agregarlo
			EXEC Ventas.SP_Cliente_Alta
				@Nombre = @Nombre, 
				@Documento = @Documento, 
				@Tipo_doc = @Tipo_doc,
				@Nacimiento = @Nacimiento
		END

		SET @FilaActual = @FilaActual + 1;
	END;

	--9) 

	
	--crear compra de entradas
	-- asigna a ID_Compra el ID de lo que acabamos de insertar
	Declare @ID_Compra int
	exec @ID_Compra = Ventas.SP_Compra_Alta @Fecha = @Fecha_actual, @Total = 0, @Cantidad = @TotalFilas, @Punto_venta = @PuntoDeVenta, @Descuento = 1
	--calcular el precio de cada entrada

	--10) 

	CREATE TABLE #aux 
	(
    ID_Cliente INT,
    ID_Tarifa INT,
    PrecioTarifa DECIMAL(11,2),
	PrecioTours DECIMAL(11,2)
	)

	;WITH CostoToursPorVisitante AS ( --deberia quedar ID temporal | total gastado en tours
		SELECT 
			t.ID_visitante,
			SUM(ISNULL(tr.Costo, 0.00)) AS TotalCostoTours --sumar los costos por visitante
		FROM #tours t
		INNER JOIN Atracciones.Tour tr ON t.ID_tour = tr.ID_Tour --conseguir el precio de cada tour
		GROUP BY t.ID_visitante --agrupar por ID de visitante (no la real sino la asignada temporalmente)
	)
	INSERT INTO #aux (ID_Cliente, ID_Tarifa, PrecioTarifa, PrecioTours)
	SELECT 
		c.ID AS ID_Cliente,
		t.ID AS ID_Tarifa,
		t.Precio,
		ISNULL(ct.TotalCostoTours, 0.00) AS PrecioTours --si no hay tours que ponga 0
	FROM #VisitanteSeparado v
	INNER JOIN Ventas.Cliente c ON v.Documento = c.Documento AND v.Tipo_doc = c.Tipo_doc --conseguir el ID real
	INNER JOIN Ventas.Tarifa t ON t.ID_parque = @ID_parque AND t.ID_tipo_visitante = v.ID_tipo AND t.Fecha_hasta IS NULL AND t.Estado = 'A' --conseguir tarifa dependiendo de su tipo de entrada
	LEFT JOIN CostoToursPorVisitante ct ON v.ID = ct.ID_visitante; --asignar a cada cliente el precio de sus tours
	--esta tabla antes de hacer el select va a quedar algo asi como:
	--Nombre | Documento | Tipo_doc | Nacimiento | ID_tipo | ID_cliente(el de ventas.cliente) | ID_tarifa | Precio entrada (descarte los campos que no son relevantes, va a haber mas) | total tours


	--insertar en base a los datos que conseguimos antes, no uso el procedure ya que no consegui como insertarlas usandolo
	INSERT INTO Ventas.Entrada (Fecha_acceso, ID_cliente, ID_tarifa, ID_compra, Estado)
	SELECT 
		CAST(@Fecha_actual AS DATE), 
		ID_Cliente,
		ID_Tarifa,
		@ID_Compra,
		'A'
	FROM #aux

	--modificar la tabla de compra ahora con el total real
	DECLARE @TotalCalculado DECIMAL(11,2) = (SELECT SUM(PrecioTarifa + PrecioTours) FROM #aux);

	--modificar total calcularo dependiendo si es feriado, dia de semana o algun dia especial
	--F: fin de semana
	--S: semana
	DECLARE @DiaSemana CHAR(1)
	IF DATEPART(dw, @Fecha_actual) IN (1, 7) --1 domingo, 7 sabado
		SET @DiaSemana = 'F'; -- Es fin de semana
	ELSE
		SET @DiaSemana = 'S' -- Es dia de semana
	--ver si es feriado

	DECLARE @urlFeriados NVARCHAR(128) = 'https://api.argentinadatos.com/v1/feriados/2026' 
	DECLARE @Object INT
	DECLARE @jsonTable TABLE(DATA NVARCHAR(MAX))
	DECLARE @EsDiaEspecial CHAR(1) = 'I'

		-- 2. Consumo de API para verificar si el día actual es feriado
	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT
	EXEC sp_OAMethod @Object, 'OPEN', NULL, 'GET', @urlFeriados, 'FALSE'
	EXEC sp_OAMethod @Object, 'SEND'

	INSERT INTO @jsonTable 
	EXEC sp_OAGetProperty @Object, 'RESPONSETEXT'
	EXEC sp_OADestroy @Object

	DECLARE @datosFeriados NVARCHAR(MAX) = (SELECT DATA FROM @jsonTable)
    
		-- Usamos GETDATE() para obtener la fecha del sistema en formato ISO
	DECLARE @HoyISO NVARCHAR(10) = FORMAT(@Fecha_actual, 'yyyy-MM-dd')
    
	-- 3. Parseo e interpretación
	IF EXISTS 
	(
		SELECT 1 FROM OPENJSON(@datosFeriados)
		WITH (fecha NVARCHAR(10) '$.fecha')
		WHERE fecha = @HoyISO
	)
		SET @EsDiaEspecial = 'A'; 
	
	declare @Aumento decimal(3,2) = 1
	if @DiaSemana = 'S' and @EsDiaEspecial = 'I'
		set @Aumento -= 0.05 --si es dia de semana es 5% mas barata (si no es feriado)
	if @EsDiaEspecial = 'A' and @DiaSemana = 'S' --si es feriado un dia de semana
		set @Aumento += 0.1 --lo aumenta un 10%

	set @TotalCalculado *= @Aumento

	EXEC Ventas.SP_Compra_Modificar
		@ID = @ID_Compra,
		@Fecha = @Fecha_actual,
		@Total = @TotalCalculado,
		@Cantidad = @TotalFilas,
		@Punto_venta = @PuntoDeVenta,
		@Descuento = @Aumento
		
	--crear la relacion entre tours y entrada para cada visitante
	INSERT INTO Atracciones.R_Tour_Entrada (ID_Tour, ID_Entrada)
	SELECT 
		t.ID_tour,
		e.ID AS ID_Entrada
	FROM #tours t INNER JOIN #VisitanteSeparado vs ON t.ID_visitante = vs.ID --con esto conseguimos el doc y tipo doc de cada visitante
	INNER JOIN Ventas.Cliente c ON vs.Documento = c.Documento AND vs.Tipo_doc = c.Tipo_doc --con el doc buscamos el id real
	INNER JOIN Ventas.Entrada e ON e.ID_cliente = c.ID AND e.ID_compra = @ID_Compra; --buscamos la entrada para el cliente en la compra de ahora
	--antes del select la tabla se veria algo asi:
	--ID temporal | tour | DOC | tipo doc | ID real en tabla clientes| entrada (faltan columnas pero no son relevantes o son repetidas)
	
	
	
	commit 
	end try
	begin catch
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	end catch
	end
	go

