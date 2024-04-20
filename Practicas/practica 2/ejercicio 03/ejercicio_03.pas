{
	3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
	de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
	productos que comercializa. De cada producto se maneja la siguiente información: código de
	producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
	genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
	cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
	realizar un programa con opciones para:
	
		a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
			● Ambos archivos están ordenados por código de producto.
			● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
			archivo detalle.
			● El archivo detalle sólo contiene registros que están en el archivo maestro.
		
		b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
		stock actual esté por debajo del stock mínimo permitido.
}


program practica02_ejercicio03;
CONST
	valorAlto = 9999;
TYPE

	producto = record
		codigo : integer;
		nombre : String;
		precio : integer;
		stockActual : integer;
		stockMinimo : integer;
	end;
	
	venta = record
		codigo : integer;
		cantVentas : integer;
	end;
	
	archivo_maestro = file of producto;
	archivo_detalle = file of venta;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro');
	writeln('2. Exportar a texto productos con stock por debajo del minimo');
	writeln('3. Crear maestro');
	writeln('4. Crear detalle');
	writeln('5. Mostrar maestro');
	writeln('6. Mostrar detalle');
	writeln('7. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_detalle ; var dato:venta );
begin

	if ( not eof(archivo) ) then
		read( archivo , dato )
	else
		dato.codigo := valorAlto;

end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var detalle:archivo_detalle );
var
	regm : producto;
	regd : venta;
	codAct : integer;
	totalVentas : integer;
begin
	
	{ abrir ambos archivos }
	reset( maestro );
	reset( detalle );
	
	{ leer ambos archivos }
	leer( detalle , regd );
	read( maestro , regm );
	

	while ( regd.codigo <> valorAlto ) do
	begin
	
		codAct := regd.codigo;
		totalVentas := 0;
		
		{ sumar y leer hasta encontrar un codigo nuevo }
		while ( codAct = regd.codigo ) do
		begin
			
			{ sumar ventas de los registros con mismo codigo }
			totalVentas := totalVentas + regd.cantVentas;
			
			{ leer proximo registro }
			leer( detalle , regd );
			
		end;
		
		{ buscar el registro del maestro que hay que modificar }
		while ( regm.codigo <> codAct ) do
			read( maestro, regm );
		
		{ ya encontrado el registro lo modificamos }
		regm.stockActual := regm.stockActual - totalVentas;
		
		{ reubica el puntero }
		seek( maestro , filepos(maestro)-1 );
		
		{ se actualiza el maestro }
		write( maestro , regm );
		
		{ se avanza en el maestro }
		if ( not EOF(maestro) ) then 
			read( maestro, regm );
		
	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( detalle );
	
	{ notificar exito }
	writeln('actualizado correctamente...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure exportarTexto( var maestro:archivo_maestro ; var texto:Text );
var
	regm : producto;
begin

	{ abrir archivo maestro }
	reset( maestro );
	
	{ crear archivo de texto }
	rewrite( texto );
	
	{ leer e imprimir hasta haber recorrido todo el archivo maestro }
	while ( not eof(maestro) ) do 
	begin
	
		{ leer registro }
		read ( maestro , regm );
		
		{ escribir en el archivo los registros cuyo 'stock actual' sea menor al minimo }
		if ( regm.stockActual < regm.stockMinimo ) then
			with regm do
				writeln ( texto , codigo , '  ' , nombre , '  ' , precio , '  ' , stockActual , '  ' , stockMinimo );
	
	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( texto );

	{ notificar exito }
	writeln('exportado correctamente...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerProducto( var p:producto );
	begin
		with p do
		begin
			writeln('-----------------');
			write('codigo: ');
			readln(codigo);
			if ( codigo <> -1 ) then 
			begin
				write('nombre: ');
				readln(nombre);
				write('precio: ');
				readln(precio);
				write('stockActual: ');
				readln(stockActual);
				write('stockMinimo: ');
				readln(stockMinimo);
			end;
		end;
	end;

var
	p : producto;
begin

	{ crear archivo }
	rewrite( maestro );

	{ leer primer producto }
	leerProducto( p );

	{ agregar nuevos productos al archivo hasta que se ingrese el codigo -1 }
	while ( p.codigo <> -1 ) do 
	begin

		{ agregar producto al archivo maestro }
		write( maestro , p );

		{ leer proximo producto }
		leerProducto( p );
	
	end;

	{ cerrar archivo }
	close( maestro )

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerVenta( var v:venta );
	begin
		with v do
		begin
			writeln('-----------------');
			write('codigo: ');
			readln(codigo);
			if ( codigo <> -1 ) then 
			begin
				write('cantVentas: ');
				readln(cantVentas);
			end;
		end;
	end;

var
	v : venta;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primera venta }
	leerVenta( v );
	
	{ agregar nuevas ventas al archivo hasta que se ingrese el codigo -1 }
	while ( v.codigo <> -1 ) do 
	begin
		
		{ agregar venta al archivo detalle }
		write( detalle , v );
		
		{ leer proxima venta }
		leerVenta( v );
		
	end;
	
	{ cerrar archivo }
	close( detalle )

end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro ( var maestro:archivo_maestro );
	
	procedure imprimirProducto( p:producto );
	begin
		with p do 
		begin
			writeln('------------------');
			writeln('codigo de producto: ', codigo);
			writeln('nombre: ', nombre);
			writeln('precio: ', precio);
			writeln('stockActual: ', stockActual);
			writeln('stockMinimo: ', stockMinimo);
		end;
	end;

var
	p : producto;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer producto del maestro }
		read( maestro , p );
		
		{ mostrar producto en consola }
		imprimirProducto(p);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle ( var detalle:archivo_detalle );

	procedure imprimirVenta( v:venta );
	begin
		with v do 
		begin
			writeln('------------------');
			writeln('codigo de producto: ', codigo);
			writeln('cantVentas: ', cantVentas);
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
		
		{ mostrar venta en consola }
		imprimirVenta(v);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	detalle : archivo_detalle;
	texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro' );
	assign( detalle , 'archivo_detalle' );
	assign( texto , 'stock_minimo.txt' );
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , detalle );
			2: exportarTexto( maestro , texto );
			3: crearMaestro( maestro );
			4: crearDetalle( detalle );
			5: mostrarMaestro( maestro );
			6: mostrarDetalle( detalle );
			7: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
