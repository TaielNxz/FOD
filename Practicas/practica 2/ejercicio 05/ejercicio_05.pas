{
	5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
	De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
	stock mínimo y precio del producto.
	Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
	debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
	maestro. 
	La información que se recibe en los detalles es: código de producto y cantidad
	vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
	descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
	debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
	procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
	ventajas/desventajas en cada caso).
	
	Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
	puede venir 0 o N registros de un determinado producto.
}


program practica02_ejercicio05;
const
	valorAlto = 9999;
	dimf = 3;
type

	producto = record
		codigo : integer;
		nombre : string[20];
		precio : integer;
		stockActual : integer;
		stockMinimo : integer;
		descripcion : string[100];
	end;
	
	venta = record
		codigo : integer;
		cantVentas : integer;
	end;
	
	archivo_maestro = file of producto;
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
	writeln('1. Actualizar Maestro con ' , dimf , ' detalles');
	writeln('2. Exportar a texto productos con stock por debajo del minimo');
	writeln('3. Crear maestro');
	writeln('4. Crear detalles');
	writeln('5. Mostrar maestro');
	writeln('6. Mostrar detalles');
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

procedure minimo( var vectorRD:vector_registro_detalle ; var regMin:venta ; var vectorD:vector_detalle );
var
	posMin : integer;
	i : integer;
begin

	regMin.codigo := valorAlto;
	
	{ recorro todo todos los detalles }
	for i:=1 to dimF do 
	begin
	
		{ si encuentro registro con un codigo mas pequeño }
		if ( vectorRD[i].codigo < regMin.codigo ) then begin
		
			{ actualizar el registro mas pequeño }
			regMin := vectorRD[i];
			
			{ guardar posicion del arreglo en la que se encontro el codigo pequeño }
			posMin := i;
			
		end;

	end;
	
	{ obtengo el dato del registro con codigo mas pequeño }
	if ( regMin.codigo <> valorAlto ) then
		leer( vectorD[posMin] , vectorRD[posMin] );

end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var vectorD:vector_detalle );
var
	regm : producto;
	regMin : venta;
	i : integer;
	vectorRD : vector_registro_detalle;
begin
	
	{ abrir archivo maestro }
	reset( maestro );
	
	{ abrir y leer archivos detalles }
	for i:=1 to dimF do begin
		reset( vectorD[i] );
		read( vectorD[i] , vectorRD[i] );
	end;
		
	{ buscar el registro minimo en el vector }
	minimo( vectorRD , regMin , vectorD );
	

	while ( regMin.codigo <> valorAlto ) do
	begin
		
		{ recorrer maestro hasta encontrar el detalle con el mismo codigo }
		read( maestro , regm );
		while ( regm.codigo <> regMin.codigo ) do
			read( maestro , regm );
		
		{ modificar y leer hasta encontrar un codigo nuevo }
		while( regm.codigo = regMin.codigo ) do
		begin
					
			{ modificar stock del maestro }
			regm.stockActual := regm.stockActual - regMin.cantVentas;
			
			{ leer proximo registro }
			minimo( vectorRD , regMin , vectorD );
		
		end;
		
		{ reubicar puntero }
		seek ( maestro, filepos(maestro)-1 );
			
		{ actualizar archivo maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrar archivo maestro }
	close( maestro );
	
	{ cerrar archivos detalle }
	for i:=1 to dimF do
		close( vectorD[i] );

	{ notificar exito }
	writeln('actualizado con exito...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure exportarTexto( var maestro:archivo_maestro ; var texto:Text );
var
	p : producto;
begin

	{ abrir archivo maestro }
	reset( maestro );
	
	{ crear archivo de texto }
	rewrite( texto );	
	
	{ recorrer archivo maestro }
	while ( not eof (maestro) ) do 
	begin
	
		{ leer producto del maestro }
		read( maestro , p );
		
		{ escribir en el archivo los registros cuyo 'stock actual' sea menor al minimo }
		if ( p.stockActual < p.stockMinimo ) then
			with p do
				writeln ( texto , nombre , '  ' , descripcion , '  ' , stockActual , '  ' , precio );

	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( texto );
	
	{ notificar exito }
	writeln('exportado con exito...');

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
				write('descripcion: ');
				readln(descripcion);
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

procedure crearDetalles( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('= = = = = = = = = = =');
		writeln( 'Creando Detalle ' , iString );
		crearDetalle( vectorD[i] );
	end;

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
			writeln('descripcion: ', descripcion);
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

procedure mostrarDetalles( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('=====================');
		writeln( ' Detalle ' , iString );
		mostrarDetalle( vectorD[i] );
		writeln('=====================');
	end;


end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	vectorD : vector_detalle;
	texto : Text;
	i : integer;
	iString : string;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro' );
	assign( texto , 'archivo_texto.txt' );

	{ asignar espacio a los detalles }
	for i := 1 to dimf do begin
	
		{ crear variable string con el valor de 'i' }
		str( i , iString );
	
		{ asignar espacio fisico a el detalle actual }
		assign( vectorD[i] , 'archivo_detalle_'+iString );
		
	end;

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , vectorD );
			2: exportarTexto( maestro , texto );
			3: crearMaestro( maestro );
			4: crearDetalles( vectorD );
			5: mostrarMaestro( maestro );
			6: mostrarDetalles( vectorD );
			7: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
