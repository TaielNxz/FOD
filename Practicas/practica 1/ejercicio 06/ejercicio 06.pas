{
	6. Agregar al menú del programa del ejercicio 5, opciones para:
	
		a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
		teclado.
		
		b. Modificar el stock de un celular dado.
		
		c. Exportar el contenido del archivo binario a un archivo de texto denominado:
		”SinStock.txt”, con aquellos celulares que tengan stock 0.
		NOTA: Las búsquedas deben realizarse por nombre de celular.
}


program practica01_ejercicio05;
TYPE

	celular = record
		codigo : integer;
		nombre : string;
		marca : string;
		precio : real;
		stock_minimo : integer;
		stock_disponible : integer;
		descripcion : string;
	end;
	
	archivo_celulares = file of celular;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }

procedure imprimirCelular( c : celular );
begin
	writeln('--------------------------');
	writeln('codigo: ' , c.codigo);
	writeln('nombre: ' , c.nombre);
	writeln('marca: ' , c.marca); 
	writeln('precio: ' , c.precio); 
	writeln('stock_minimo: ' , c.stock_minimo); 
	writeln('stock_disponible: ' , c.stock_disponible); 
	writeln('descripcion: ' , c.descripcion);
end;

procedure menu( var opcion : integer );
begin
	writeln('========================================================================');
	writeln('1. Crear archivo de celulares y cargarlo con datos ingresados desde un archivo de texto denominado celulares.txt ');
	writeln('2. Listar celulares');
	writeln('3. Listar celulares con stock menor al stock minimo');
	writeln('4. Listar celulares cuya descripcion contenga una cadena de caracteres proporcionada por el usuario.');
	writeln('5. Exportar el archivo binario a celulares2.txt');
	writeln('6. Agregar celulares');
	writeln('7. Modificar el stock de un celular');
	writeln('8. Exportar celulares con stock 0 a SinStock.txt');
	writeln('9. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure exportarTextoABinario( var archivo_binario : archivo_celulares ; var archivo_texto : Text );
var
	c : celular;
begin

	{ asignar nombre fisico }
	assign( archivo_texto , 'celulares.txt'); 

	{ abrir archivo de texto }
	reset( archivo_texto );
	
	{ crear archivo binario }
	rewrite( archivo_binario );
	
	{ mensaje }
	writeln('Creando nuevo archivo...');
	
	{ recorrer todo el archivo de texto }
	while ( not eof(archivo_texto) ) do 
	begin
	
	
		{ leer datos del archivo de texto }
		with c do begin
			readln( archivo_texto , codigo , precio , marca );
			readln( archivo_texto , stock_disponible , stock_minimo , descripcion );
			readln( archivo_texto , nombre );
		end;
		
		{ escribir en archivo binario }
		write( archivo_binario , c );

	end;
	
	{ cerrar archivos }
	close( archivo_binario );
	close( archivo_texto );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure listarCelulares( var archivo_binario : archivo_celulares );
var
	c : celular;
begin

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ recorrer todo el archivo }
	while ( not eof(archivo_binario) ) do
	begin
		
		{ leer archivo binario }
		read( archivo_binario , c );
		
		{ mostrar informacion }
		imprimirCelular( c );
		
	end;
	
	{ cerrar archivo }
	close( archivo_binario );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure listarCelularesMenorStock( var archivo_binario : archivo_celulares );
var
	c : celular;
begin
	
	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ recorrer todo el archivo }
	while ( not eof(archivo_binario) ) do
	begin
		
		{ leer archivo binario }
		read( archivo_binario , c );
		
		{ imprimir celulares que tengan stock por debajo del minimo }
		if( c.stock_disponible < c.stock_minimo ) then
			imprimirCelular( c );

	end;
	
	{ cerrar archivo }
	close( archivo_binario );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure listarCelularesConDescripcion( var archivo_binario : archivo_celulares );
var
	c : celular;
begin
	
	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ recorrer todo el archivo }
	while ( not eof(archivo_binario) ) do
	begin
		
		{ leer archivo binario }
		read( archivo_binario , c );
		
		{ imprimir celulares que tengan una descripcion }
		if( c.descripcion <> ' ' ) then
			imprimirCelular( c );
			
	end;
	
	{ cerrar archivo }
	close( archivo_binario );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure exportarBinarioATexto ( var archivo_binario : archivo_celulares ; var archivo_texto : Text );
var
	c : celular;
begin

	{ asignar nombre fisico }
	assign( archivo_texto ,'celulares2.txt' );

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ crear archivo de texto }
	rewrite( archivo_texto );
	
	{ recorrer archivo binario }
	while ( not EOF(archivo_binario) ) do
	begin
	
		{ leer registro del archivo binario }
		read( archivo_binario , c );
		
		{ escribir registro en archivo de texto }
		with c do begin
			writeln( archivo_texto, codigo , ' ' , precio:1:1 , ' ' , marca );
			writeln( archivo_texto, stock_disponible , ' ' , stock_minimo , ' ' , descripcion );
			writeln( archivo_texto, nombre );
		end;
	
	end;
	
	{ cerrar archivos }
	close( archivo_binario );
	close( archivo_texto );
	
	writeln('exportado con exito...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure agregarCelular( var archivo_binario : archivo_celulares );

	procedure leerCelular( var c : celular );
	begin
		writeln('------------------------------');
		with c do
		begin
			write('Codigo: ');
			readln( c.codigo );
			if ( c.codigo <> 0 ) then
			begin
				write('nombre: ');
				readln( c.nombre );
				write('marca: '); 
				readln( c.marca );
				write('precio: '); 
				readln( c.precio );
				write('stock_minimo: '); 
				readln( c.stock_minimo );
				write('stock_disponible: '); 
				readln( c.stock_disponible );
				write('descripcion: ');
				readln( c.descripcion );
			end;	
		end;
	end;


var
	c : celular;
begin

	{ abrir archivo }
	reset( archivo_binario );
	
	{ posicionarse al final del archivo }
	seek( archivo_binario , filesize(archivo_binario) );
	
	{ mostrar mensaje }
	writeln('agregando celulares ( finalizar ingresando "0" )');
	
	{ leer archivo }
	leerCelular( c );
	
	{ escribir en el archivo hasta ingresar codigo 0 }
	while ( c.codigo <> 0 ) do
	begin
	
		{ escribir en el archivo }
		write( archivo_binario , c );
	
		{ leer nuevo celular }
		leerCelular( c );
		
	end;
	
	{ cerrar archivo }
	close( archivo_binario );

end;
{ ======================================================================================================================== }
{                                                         OPCION 7                                                         }
{ ======================================================================================================================== }
procedure modificarStock( var archivo_binario : archivo_celulares );
var
	c : celular;
	cod : integer;
	encontrado : boolean;
begin

	encontrado := false;

	{ abrir archivo }
	reset( archivo_binario );
	
	{ leer codigo del registro a modificar }
	write('codigo del registro a modificar: ');
	readln( cod );
	
	{ leer primer registro }
	read( archivo_binario , c );
	
	{ recorrer archivo hasta encontrar el codigo }
	while ( not encontrado ) and ( not EOF(archivo_binario) ) do 
	begin
		
		{ si se encontro el codigo, modificar registro... }
		if ( c.codigo = cod ) then
		begin
		
			{ modificar boolean para cancelar el while }
			encontrado := true;
			
			{ ingresar nuevo stock }
			write('ingresar nuevo stock: ');
			readln( c.stock_disponible );
			
			{ posicionarse en el registro a editar }
			seek ( archivo_binario ,filePos(archivo_binario)-1 );
			
			{ editar registro }
			write ( archivo_binario , c );
			
		end;
		
		{ leer proximo registro }
		read( archivo_binario , c )
		
	end;
	
	{ notificar resultado }
	if ( encontrado ) then
		writeln('modificado exitosamente')
	else
		writeln('no se encontro el registro con codigo ' , cod );

	{ cerrar archivo }
	close( archivo_binario );
	
end;

{ ======================================================================================================================== }
{                                                         OPCION 8                                                         }
{ ======================================================================================================================== }
procedure exportarBinarioATextoSinStock ( var archivo_binario : archivo_celulares ; var archivo_texto : Text );
var
	c : celular;
begin

	{ asignar nombre fisico }
	assign( archivo_texto ,'SinStock.txt' );

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ crear archivo de texto }
	rewrite( archivo_texto );
	
	{ recorrer archivo binario }
	while ( not EOF(archivo_binario) ) do
	begin
	
		{ leer registro del archivo binario }
		read( archivo_binario , c );
		
		{ escribir registro sin stock en archivo de texto }
		if ( c.stock_disponible = 0 ) then
			with c do begin
				writeln( archivo_texto, codigo , ' ' , precio:1:1 , ' ' , marca );
				writeln( archivo_texto, stock_disponible , ' ' , stock_minimo , ' ' , descripcion );
				writeln( archivo_texto, nombre );
			end;
	
	end;
	
	{ cerrar archivos }
	close( archivo_binario );
	close( archivo_texto );
	
	writeln('exportado con exito...');

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_binario : archivo_celulares;
	archivo_texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_binario , 'celulares' );

	{ hasta que no se ingrese la opcion 6... }
	opcion := 0;
	while ( opcion <> 9 ) do 
	begin
	
		{ mostrar en consola un menu con opciones }
		menu( opcion );
		
		{ opciones... }
		case opcion of
			1: exportarTextoABinario( archivo_binario , archivo_texto );
			2: listarCelulares( archivo_binario );
			3: listarCelularesMenorStock( archivo_binario );
			4: listarCelularesConDescripcion( archivo_binario );
			5: exportarBinarioATexto( archivo_binario , archivo_texto );
			6: agregarCelular( archivo_binario );
			7: modificarStock( archivo_binario );
			8: exportarBinarioATextoSinStock( archivo_binario , archivo_texto );
			9: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;

	end;

END.
