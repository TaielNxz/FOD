{
	5. Realizar un programa para una tienda de celulares, que presente un menú con
	opciones para:
	
		a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
		ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
		correspondientes a los celulares deben contener: código de celular, nombre,
		descripción, marca, precio, stock mínimo y stock disponible.
		
		b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
		stock mínimo.
		
		c. Listar en pantalla los celulares del archivo cuya descripción contenga una
		cadena decaracteres proporcionada por el usuario.
		
		d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
		“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
		podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
		debería respetar el formato dado para este tipo de archivos en la NOTA 2.
		
	NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
	
	NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
	tres líneas consecutivas. 
	En la primera se especifica: código de celular, el precio y marca, 
	en la segunda el stock disponible, stock mínimo y la descripción 
	y en la tercera nombre en ese orden. 
	Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
}


program practica01_ejercicio05;
uses crt, SysUtils;
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
	writeln('6. Salir');
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
	
	{ limpiar pantalla }
	clrscr;
	
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
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_binario : archivo_celulares;
	archivo_texto : Text;
	archivo_texto_nuevo : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_binario , 'celulares' );
	assign( archivo_texto , 'celulares.txt'); 
	assign( archivo_texto_nuevo ,'celulares2.txt' );

	{ hasta que no se ingrese la opcion 6... }
	opcion := 0;
	while ( opcion <> 6 ) do 
	begin
	
		{ mostrar en consola un menu con opciones }
		menu( opcion );

		{ limpiar la pantalla }
		clrscr;
		
		{ opciones... }
		case opcion of
			1: exportarTextoABinario( archivo_binario , archivo_texto );
			2: listarCelulares( archivo_binario );
			3: listarCelularesMenorStock( archivo_binario );
			4: listarCelularesConDescripcion( archivo_binario );
			5: exportarBinarioATexto( archivo_binario , archivo_texto_nuevo );
			6: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;

	end;

END.

