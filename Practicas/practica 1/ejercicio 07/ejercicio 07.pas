{
	7. Realizar un programa que permita:
	
		a) Crear un archivo binario a partir de la información almacenada en un archivo de
		texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
		archivo de texto consiste en: código de novela, nombre, género y precio de
		diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
		líneas en el archivo de texto. 
		La primera línea contendrá la siguiente información: código novela, precio y género, 
		y la segunda línea almacenará el nombre de la novela.
		
		b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
		agregar una novela y modificar una existente. Las búsquedas se realizan por
		código de novela.
		
	NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
}


program practica01_ejercicio07;
TYPE 

	novela = record
		codigo : integer;
		nombre : string;
		genero : string;
		precio : integer;
	end;

	archivo_novelas = file of novela;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure leerNovela( var n : novela );
begin
	writeln('------------------------------');
	with n do
	begin
		write('Codigo: ');
		readln( codigo );
		if ( codigo <> 0 ) then
		begin
			write('nombre: ');
			readln( nombre );
			write('genero: '); 
			readln( genero );
			write('precio: '); 
			readln( precio );
		end;	
	end;
end;

procedure modificarNovela( var n : novela );
begin
	with n do
	begin
		write('nombre: ');
		readln( nombre );
		write('genero: '); 
		readln( genero );
		write('precio: '); 
		readln( precio );
	end;
end;

procedure imprimirNovela( n : novela );
begin
	writeln('--------------------------');
	with n do
	begin
		writeln('codigo: ' , codigo);
		writeln('nombre: ' , nombre);
		writeln('genero: ' , genero);
		writeln('precio: ' , precio);
	end;
end;

procedure menu( var opcion : integer );
begin
	writeln('========================================================================');
	writeln('1. Crear un archivo binario y cargarlo con datos ingresados desde un archivo de texto denominado novelas.txt ');
	writeln('2. Agregar Novelas');
	writeln('3. Editar Novela');
	writeln('4. Listar Novelas');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure exportarBinarioATexto( var archivo_texto : Text ; var archivo_binario : archivo_novelas );
var
	n : novela;
begin

	{ crear archivo binario }
	rewrite( archivo_binario );
	
	{ abrir archivo de texto }
	reset( archivo_texto );
	
	while ( not eof(archivo_texto) ) do
	begin
	
		{ leer archivo de texto }
		with n do begin
			readln( archivo_texto , codigo , precio , genero );
			readln( archivo_texto , nombre );
		end;
		
		{ escribir en archivo binario }
		write( archivo_binario , n );
		
	end;

	{ cerrar archivos }
	close( archivo_binario );
	close( archivo_texto );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure agregarNovela( var archivo_binario : archivo_novelas );
var
	n : novela;
begin

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ posicionarse al final del archivo }
	seek( archivo_binario , fileSize(archivo_binario) );
	
	{ mensaje... }
	write('Agregando novelas ( finalizar con codigo 0 ): ');
	
	{ leer primera novela }
	leerNovela( n );
	
	while ( n.codigo <> 0 ) do begin
	
		{ escribir en archivo  }
		write( archivo_binario , n );
	
		{ leer proxima novela }
		leerNovela( n );
		
	end;
	
	{ cerrar archivo }
	close( archivo_binario );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure actualizarNovela( var archivo_binario : archivo_novelas );
var
	n : novela;
	cod : integer;
	encontrado : boolean;
begin
	
	encontrado := false;

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ leer codigo de novela a buscar }
	write('codigo de la novela a buscar: ');
	readln( cod );
	
	while ( not encontrado ) and ( not EOF(archivo_binario) ) do 
	begin
	
		{ leer registro }
		read( archivo_binario , n );
	
		{ si se encontro el codigo, actualizamos el registro }
		if ( n.codigo = cod ) then 
		begin
		
			{ modificamos el booleano para cancelar el while }
			encontrado := true;
			
			{ modificar novela }
			modificarNovela( n );
			
			{ posicionamos el puntero en el registro a modificar }
			seek( archivo_binario , filepos(archivo_binario)-1 );
			
			{ escribimos en el archivo }
			write( archivo_binario , n );
			
		end;

	end;
	
	if ( encontrado ) then
		writeln('actualizado con exito')
	else
		writeln('no se encontro el codigo ', cod );
	
	{ cerrar archivo }
	close( archivo_binario );

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure listarNovelas( var archivo_binario : archivo_novelas );
var
	n : novela;
begin

	{ abrir archivo binario }
	reset( archivo_binario );
	
	{ recorrer todo el archivo }
	while ( not eof(archivo_binario) ) do
	begin
		
		{ leer archivo binario }
		read( archivo_binario , n );
		
		{ mostrar informacion }
		imprimirNovela( n );
		
	end;
	
	{ cerrar archivo }
	close( archivo_binario );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_binario : archivo_novelas;
	archivo_texto : Text;
	opcion : integer;
BEGIN
	
	{ asignar espacio fisico }
	assign( archivo_binario , 'novelas' );
	assign( archivo_texto , 'novelas.txt' );

	{ variable para las opciones }
	opcion := 0;

	{ hasta que no se ingrese la opcion 6... }
	while ( opcion <> 5 ) do 
	begin
	
		{ mostrar en consola un menu con opciones }
		menu( opcion );
		
		{ opciones... }
		case opcion of
			1: exportarBinarioATexto( archivo_texto , archivo_binario );
			2: agregarNovela( archivo_binario );
			3: actualizarNovela( archivo_binario );
			4: listarNovelas( archivo_binario );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;

	end;
	
END.
