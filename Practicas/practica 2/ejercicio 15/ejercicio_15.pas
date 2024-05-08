{
	15. La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
	correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
	fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
	y total de ejemplares vendido.
	
	Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
	país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
	cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
	procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
	actualización del archivo maestro en función de las ventas registradas. Además deberá
	informar fecha y semanario que tuvo más ventas y la misma información del semanario con
	menos ventas.
	
	Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
	ventas de semanarios si no hay ejemplares para hacerlo
}
program practica02_ejercicio15;
const
	valorAlto = 9999;
	dimf = 3; // 100
type
	
	emision = record
		fecha : integer;
		codigoSemanario : integer;
		nombreSemanario : string;
		descripcion : string;
		precio : integer;
		totalEjemplares : integer;
		totalVendidos : integer;
	end;
	
	venta = record
		fecha : integer;
		codigoSemanario : integer;
		totalVendidos : integer;
	end;

	archivo_maestro = file of emision;
	archivo_detalle = file of venta;

	vector_detalle = array [1..dimf] of archivo_detalle;
	vector_registro_detalle = array [1..dimf] of venta;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro con ' , dimf  , ' detalles');
	writeln('2. Crear maestro');
	writeln('3. Crear ' , dimf  , ' detalles');
	writeln('4. Mostrar maestro');
	writeln('5. Mostrar ' , dimf  , ' detalles');
	writeln('6. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer ( var archivo:archivo_detalle ; var dato:venta );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.fecha := valorAlto;
end;

procedure minimo( var regMin:venta ; var vectorRD:vector_registro_detalle ; var vectorD:vector_detalle );
var
	i : integer;
	minPos : integer;
begin

	regMin.fecha := valorAlto;
	minPos := 0;

	for i := 1 to dimf do 
	begin
	
		if ( vectorRD[i].fecha < regMin.fecha ) or 
		   (( vectorRD[i].fecha = regMin.fecha ) and ( vectorRD[i].codigoSemanario < regMin.codigoSemanario )) then 
		begin
			regMin := vectorRD[i];
			minPos := i;
		end;
	
	end;
	
	if ( minPos <> 0 ) then
		leer( vectorD[minPos] , vectorRD[minPos] );

end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var vectorD:vector_detalle );
var
	vectorRD : vector_registro_detalle;
	regMin, regMinVentas, regMaxVentas : venta;
	regm : emision;
	i : integer;
	fechaActual, codigoActual, totalVentas : integer;
begin

	{ abrir  maestro }
	reset( maestro );
	
	{ abrir y leer detalles }
	for i := 1 to dimf do
	begin
		reset( vectorD[i] );
		read( vectorD[i] , vectorRD[i] );
	end;
	
	{ obtener registro mas pequeño }
	minimo( regMin , vectorRD , vectorD );

	{ valores para informar el minimo y el maximo }
	regMinVentas := regMin;
	regMaxVentas := regMin;
	
	while ( regMin.fecha <> valorAlto ) do
	begin
		
		fechaActual := regMin.fecha;

		while ( regMin.fecha = fechaActual ) do
		begin
		
			codigoActual := regMin.codigoSemanario;
			
			totalVentas := 0;
			
			while ( regMin.fecha = fechaActual ) and ( regMin.codigoSemanario = codigoActual ) do
			begin
			
				{ recoletar todas las ventas }
				totalVentas := totalVentas + regMin.totalVendidos;
			
				{ obtener proximo registro minimo }
				minimo( regMin , vectorRD , vectorD );
			
			end;
			
			{ guardar registro con mayor cantidad de ventas }
			if ( totalVentas < regMinVentas.totalVendidos ) then
				regMinVentas := regMin;
			
			{ guardar registro con menor cantidad de ventas}
			if ( totalVentas > regMaxVentas.totalVendidos ) then
				regMaxVentas := regMin;


			{ buscar en el maestro el registro a modificar }
			read( maestro , regm );
			while ( regm.fecha <> fechaActual ) and ( regm.codigoSemanario <> codigoActual ) do begin
				read( maestro , regm );
			end;
			
			{ actualizar datos del registro maestro }		
			regm.totalVendidos := regm.totalVendidos + totalVentas;

			{ reubicar puntero }
			seek( maestro , filepos(maestro)-1 ) ;
			
			{ acutalizar registro del maestro }
			write( maestro , regm );
			
		end;
	
	end;
	
	{ informar minimo y maximo }
	with regMinVentas do
		writeln('semanario con menos ventas --> fecha: ' , fecha , ' codigo de semanario: ' , codigoSemanario );

	with regMaxVentas do
		writeln('semanario con mas ventas --> fecha: ' , fecha , ' codigo de semanario: ' , codigoSemanario );

	{ cerrar archivos }
	close( maestro );
	for i := 1 to dimf do
		close( vectorD[i] );
		
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerEmision( var e:emision );
	begin
		with e do
		begin
			writeln('-----------------------');
			write('fecha: ');
			readln(fecha);
			if ( fecha <> -1 ) then 
			begin
				write('codigo de seminario: ');
				readln(codigoSemanario);
				write('nombre de seminario: ');
				readln(nombreSemanario);
				write('descripcion: ');
				readln(descripcion);
				write('precio: ');
				readln(precio);
				write('cantidad total de ejemplares: ');
				readln(totalEjemplares);
				write('cantidad de ejemplares vendidos: ');
				readln(totalVendidos);
			end;
		end;
	end;
	
var
	e : emision;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer emision }
	leerEmision(e);
	
	while ( e.fecha <> -1 ) do 
	begin
	
		{ agregar emision al archivo maestro }
		write( maestro , e );
	
		{ leer proxima provincia }
		leerEmision(e);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerVenta( var v:venta );
	begin
		with v do
		begin
			writeln('-----------------------');
			write('fecha: ');
			readln(fecha);
			if ( fecha <> -1 ) then 
			begin
				write('codigo de seminario: ');
				readln(codigoSemanario);
				write('cantidad de ejemplares vendidos: ');
				readln(totalVendidos);
			end;
		end;
	end;

var
	v : venta;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer la primera venta }
	leerVenta(v);
	
	while ( v.fecha <> -1 ) do 
	begin
	
		{ agregar venta al archivo detalle }
		write( detalle , v );
	
		{ leer proxima venta }
		leerVenta(v);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;

procedure crearDetalles( var vectorD:vector_detalle );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' CREANDO DETALLE ' , i );
		crearDetalle ( vectorD[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirEmision( e:emision );
	begin
		with e do
		begin
			writeln('-----------------------');
			writeln('fecha: ' , fecha);
			writeln('codigo de seminario: ' , codigoSemanario);
			writeln('nombre de seminario: ' , nombreSemanario);
			writeln('descripcion: ' , descripcion);
			writeln('precio: ' , precio);
			writeln('cantidad total de ejemplares: ' , totalEjemplares);
			writeln('cantidad de ejemplares vendidos: ' , totalVendidos);
		end;
	end;


var
	e : emision;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer emision del maestro }
		read( maestro , e );
		
		{ mostrar emision en consola }
		imprimirEmision(e);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirVenta( v:venta );
	begin
		with v do
		begin
			writeln('-----------------------');
			writeln('fecha: ' , fecha);
			writeln('codigo de seminario: ' , codigoSemanario);
			writeln('cantidad de ejemplares vendidos: ' , totalVendidos);
		end;
	end;

var
	v : venta;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer venta del detalle }
		read( detalle , v );
		
		{ mostrar log en consola }
		imprimirVenta(v);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;

procedure mostrarDetalles( var vectorD:vector_detalle );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' DETALLE ' , i );
		mostrarDetalle ( vectorD[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	vectorD : vector_detalle;
	opcion : integer;
	i : integer;
	iString : string;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	for i := 1 to dimf do
	begin
		str( i , iString );	
		assign( vectorD[i] , 'archivo_detalle_'+iString );
	end;

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 6 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , vectorD );
			2: crearMaestro( maestro );
			3: crearDetalles( vectorD );
			4: mostrarMaestro( maestro );
			5: mostrarDetalles( vectorD );
			6: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
