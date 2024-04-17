{
	7. Realizar un programa que permita:
	
		a) Crear un archivo binario a partir de la información almacenada en un archivo de
		texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
		archivo de texto consiste en: código de novela, nombre, género y precio de
		diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
		líneas en el archivo de texto. La primera línea contendrá la siguiente información:
		código novela, precio y género, y la segunda línea almacenará el nombre de la
		novela.
		
		b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
		agregar una novela y modificar una existente. Las búsquedas se realizan por
		código de novela.
		
	NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
}


program practica01_ejercicio07_crear_txt;
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

procedure crearArchivoNovelasTxt( var archivo_texto : Text );
var
	n : novela;
begin

	{ crear archivo de texto }
	rewrite( archivo_texto );

	{ leer primera novela }
	leerNovela( n );

	{ escribir hasta ingresar el 0 }
	while ( n.codigo <> 0 ) do
	begin
	
		{ leer archivo de texto }
		with n do begin
			writeln( archivo_texto , codigo , ' ' , precio , ' ' , genero );
			writeln( archivo_texto , nombre );
		end;
		
		{ leer proxima novela }
		leerNovela( n );
		
	end;

	{ cerrar archivo }
	close( archivo_texto );

end;

{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_texto : Text;
BEGIN
	
	{ asignar espacio fisico }
	assign( archivo_texto , 'novelas.txt' );

	{ mensaje }
	writeln('creando novelas.txt ( finalizar con codigo 0 )');

	{ crear archivo de texto }
	crearArchivoNovelasTxt( archivo_texto );

END.
