{
	1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
	stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
	todos los productos que comercializa. De cada producto se maneja la siguiente
	información: código de producto, nombre comercial, precio de venta, stock actual y
	stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
	ventas de productos realizadas. De cada venta se registran: código de producto y
	cantidad de unidades vendidas. Resuelve los siguientes puntos:
	
	a. Se pide realizar un procedimiento que actualice el archivo maestro con el
	archivo detalle, teniendo en cuenta que:
		
		i. Los archivos no están ordenados por ningún criterio.
		ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
		del archivo detalle.
		
	b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
	cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
	archivo detalle?
	
}
program practica03_parte02_ejercicio01;
const
	valorAlto = 9999;
type

	producto = record
		codigo : integer;
		nombre : string;
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
	writeln('1. Actualizar Maestro con detalle');
	writeln('2. Crear maestro');
	writeln('3. Crear detalle');
	writeln('4. Mostrar maestro');
	writeln('5. Mostrar detalle');
	writeln('6. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure actualizarMaestro( var maestro:archivo_maestro ; var detalle:archivo_detalle );
var
    regd : venta;
    regm : producto;
    cantActual: integer;
begin

	{ abrir archivos }
    reset(maestro);
    reset(detalle);
    
	{ recorrer todo el maestro }
    while ( not eof(maestro) ) do
	begin
	
		cantActual := 0;
	
		{ leer registro del maestro }
		read( maestro , regm );
		
		
		{ recorrer todo el detalle }
		while ( not eof(detalle) ) do
		begin
		
			{ leer registro detalle }
			read( detalle, regd );
			
			{ acumular ventas de todos los registros con mismo codigo }
			if ( regm.codigo = regd.codigo ) then
				cantActual := cantActual + regd.cantVentas;

		end;
		
		{ reubicar puntero al inicio del archivo }
		seek( detalle , 0 );
		
		{ reducir el stock y guardar en el maestro }
		if ( cantActual > 0 ) then
		begin
			
			regm.stockActual := regm.stockActual - cantActual;
			
			seek( maestro , filepos(maestro)-1 );
			
			write( maestro , regm );
			
		end;
		
	end;
        
	{ cerrar archivos }
    close(maestro);
    close(detalle);
    
    { notificar exito... }
    writeln('se actualizo con exito...');
    
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
			write('codigo de producto: ');
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
	
	procedure imprimirProductoMaestro( p:producto );
	begin
		with p do begin
			writeln('------------------');
			writeln('codigo: ', codigo);
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
		imprimirProductoMaestro(p);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle ( var detalle:archivo_detalle );

	procedure imprimirProductoDetalle( v:venta );
	begin
		with v do begin
			writeln('------------------');
			writeln('codigo: ', codigo);
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
		imprimirProductoDetalle(v);
		
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
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro' );
	assign( detalle , 'archivo_texto.txt' );

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 6 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , detalle );
			2: crearMaestro( maestro );
			3: crearDetalle( detalle );
			4: mostrarMaestro( maestro );
			5: mostrarDetalle( detalle );
			6: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
