{
	1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
	incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
	cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
	archivo debe ser proporcionado por el usuario desde teclado.
}

program practica01_ejercicio01;

TYPE
	archivoEnteros = file of integer;
	cadena50 = string[50];
	
VAR
	archivo_fisico : cadena50;
	archivo_logico : archivoEnteros;
	num : integer;

BEGIN

	{ Leer nombre del archivo }
	write('Nombre del Archivo: ');
	readln( archivo_fisico );
	
	{ Asignar espacio en memoria fisica }
	assign( archivo_logico , archivo_fisico );
	
	{ Crear archivo }
	rewrite( archivo_logico );     
	
	{ leer primer numero }
	write('Numero: ');
	readln( num );
	
	while ( num <> 30000 ) do begin
	
		{ Escribir en el archivo }
		write( archivo_logico , num );
		
		{ Leer nuevo numero }
		write('Numero: ');
		readln( num );
		
	end;
	
	{ cierre del archivo }
	close( archivo_logico );

END.
