{
	6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
	la información correspondiente a las prendas que se encuentran a la venta. De cada
	prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
	precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
	prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
	prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
	ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
	stock de la prenda correspondiente a valor negativo.
	
	Adicionalmente, deberá implementar otro procedimiento que se encargue de
	efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
	información de las prendas a la venta. Para ello se deberá utilizar una estructura
	auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
	que no están marcadas como borradas. Al finalizar este proceso de compactación
	del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
	original.
}
program practica03_ejercicio06;
const
	valorAlto = 9999;
type

	prenda = record
		cod_prenda : integer;
		descripcion : string;
		colores : string;
		tipo_prenda : string;
		stock : integer;
		precio_unitario : real;
	end;
	
	archivo_maestro = file of prenda;
	archivo_detalle = file of integer;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar archivo de prendas');
	writeln('2. Compactar archivo maestro');
	writeln('3. Crear maestro');
	writeln('4. Crear detalle');
	writeln('5. Listar maestro');
	writeln('6. Listar archivo compactado');
	writeln('7. Listar detalle');
	writeln('8. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure eliminar( var maestro:archivo_maestro ; codigo:integer );
var
	p : prenda;
begin

	{ abrir maestro }
	reset ( maestro );
	
	{ buscar prenda en el maestro }
	read( maestro , p );
	while ( p.cod_prenda <> codigo ) do
		read( maestro , p );
		
	{ reubicar puntero }
	seek( maestro , filepos(maestro)-1 );
	
	{ modificar stock al valor negativo }
	p.stock := p.stock * -1;
	
	{ actualizar maestro }
	write( maestro , p );
	
	{ cerrar archivo }
	close( maestro );
	
end;

procedure leerArcD ( var detalle:archivo_detalle ; var dato:integer );
begin
	if ( not eof (detalle) ) then
		read ( detalle , dato )
	else
		dato := valorAlto;
end;

procedure actualizar( var maestro:archivo_maestro ; var detalle:archivo_detalle );
var
	p : integer;
begin
	
	{ abrir detalle }
	reset(detalle);
	
	{ leer primer codigo de prenda del detalle }
	leerArcD( detalle , p );
	

	while ( p <> valorAlto ) do 
	begin
	
		{ elminar prenda del maestro }
		eliminar( maestro , p );
		
		{ leer proximo codigo }
		leerArcD( detalle , p );
		
	end;
	
	{ cerrar archivo }
	close (detalle);

	writeln('Actualizado con exito...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure leerArcM ( var maestro:archivo_maestro ; var dato:prenda );
begin
	if ( not eof (maestro) ) then
		read ( maestro , dato )
	else
		dato.cod_prenda := valorAlto;
end;

procedure compactar ( var maestro:archivo_maestro ; var nuevo:archivo_maestro );
var
	p : prenda;
begin	

	{ abrir maestro }
	reset(maestro);
	
	{ crear archivo compacto }
	rewrite(nuevo);
	
	{ leer primera prenda }
	leerArcM( maestro , p );
	

	while ( p.cod_prenda <> valorAlto ) do begin
	
		{ si tiene stock se guarda en el archivo compacto }
		if ( p.stock >= 0 ) then 
			write( nuevo , p );
		
		{ leer proxima prenda }
		leerArcM( maestro , p );
		
	end;
	
	{ cerrar archivos }
	close(maestro);
	close(nuevo);
	
	writeln('Compactado con exito...');
	
end;
{ ======================================================================================================================== }
{                                                        OPCION 3                                                          }
{ ======================================================================================================================== }
procedure leerPrenda( var p:prenda );
begin

	with p do
	begin
		writeln('-----------------------');
		write('codigo de prenda: ');
		readln( cod_prenda );
		if ( cod_prenda <> -1 ) then
		begin
			write('descripcion: ');
			readln( descripcion );
			write('colores: ');
			readln( colores );
			write('tipo de prenda: ');
			readln( tipo_prenda );
			write('stock: ');
			readln( stock );
			write('precio unitario: ');
			readln( precio_unitario );
			
		end;
	end;
	
end;

procedure crearMaestro( var maestro:archivo_maestro );
var
	p : prenda;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera prenda }
	leerPrenda( p );
	
	while ( p.cod_prenda <> -1 ) do
	begin
	
		{ agregar prenda al archivo }
		write( maestro , p );
	
		{ leer proxima prenda }
		leerPrenda( p );
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                           OPCION 4                                                       }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );
var
	p : integer;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primera prenda }
	write('Codigo de prenda: ');
	readln( p );
	
	
	while ( p <> -1 ) do
	begin
	
		{ agregar prenda al archivo }
		write( detalle , p );
	
		{ leer proxima prenda }
		write('Codigo de prenda: ');
		readln( p );
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;
{ ======================================================================================================================== }
{                                                      OPCION 5 y 6                                                        }
{ ======================================================================================================================== }
procedure imprmimirPrenda( p:prenda );
begin

	with p do
	begin
		writeln('-----------------------');
		writeln('codigo de prenda: ' , cod_prenda );
		writeln('descripcion: ' , descripcion );
		writeln('colores: ' , colores );
		writeln('tipo de prenda: ' , tipo_prenda );
		writeln('stock: ' , stock );
		writeln('precio unitario: ' , precio_unitario:1:0 );
	end;
	
end;


procedure listarArchivo( var archivo_logico:archivo_maestro );
var
	p : prenda;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo_logico) ) do begin
	
		{ leer prenda del archivo }
		read( archivo_logico , p );
		
		{ mostrar prenda en consola }
		if ( p.cod_prenda > 0 ) then
			imprmimirPrenda(p);
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                          OPCION 7                                                        }
{ ======================================================================================================================== }
procedure listarDetalle( var detalle:archivo_detalle );
var
	p : integer;
begin

	{ abrir archivo }
	reset( detalle );
	
	while ( not eof(detalle) ) do begin
	
		{ leer prenda del archivo }
		read( detalle , p );
		
		{ mostrar prenda en consola }
		writeln( 'codigo de prenda: ' , p )
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro, nuevo : archivo_maestro;
	detalle : archivo_detalle; 
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	assign( detalle , 'archivo_detalle');
	assign( nuevo , 'archivo_nuevo');
	

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 8 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizar( maestro , detalle );
			2: compactar( maestro , nuevo );
			3: crearMaestro( maestro );
			4: crearDetalle( detalle );
			5: listarArchivo( maestro );
			6: listarArchivo( nuevo );
			7: listarDetalle( detalle );
			8: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
