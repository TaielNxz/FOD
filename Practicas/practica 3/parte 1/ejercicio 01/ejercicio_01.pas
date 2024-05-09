{
	1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
	agregándole una opción para realizar bajas copiando el último registro del archivo en
	la posición del registro a borrar y luego truncando el archivo en la posición del último
	registro de forma tal de evitar duplicados
}
program practica03_ejercicio01;
uses crt;
type

	cadena50 = string[50];
	empleado = record
		apellido : cadena50;
		nombre : cadena50;
		edad : integer;
		DNI : integer;
		numero : integer;
	end;
	
	archivoEmpleados = file of empleado;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln('========================================================================');
	writeln('1. Crear archivo de empleados');
	writeln('2. Listar empleados');
	writeln('3. Agregar empleados');
	writeln('4. Modificar la edad de un empleado');
	writeln('5. Exportar el contenido del archivo a un archivo de texto');
	writeln('6. Exportar a un archivo de texto los empleados que no tengan cargado el DNI (DNI en 00)');
	writeln('7. Eliminar empleado');
	writeln('8. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure mostrarInfoEmpleado( e : empleado );
begin
	write('Numero de Empleado: ', e.numero);
	write(' Nombre: ', e.nombre); 
	write(' Apellido: ', e.apellido); 
	write(' DNI: ' , e.DNI );
	write(' Edad: ' , e.edad );
	writeln;
end;

procedure leerEmpleado ( var e : empleado ; nroEmpleado : integer );
begin
	write('Apellido: '); 
	readln(e.apellido);
	if ( e.apellido <> 'fin' ) then 
	begin
		write('Nombre: '); 
		readln(e.nombre);
		write('Edad: '); 
		readln(e.edad);
		write('DNI: '); 
		readln(e.DNI);
		e.numero := nroEmpleado+1;
		writeln('Numero de Empleado: ' , e.numero ); 
	end;
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure crearArchivoDeEmpleados( var archivo_logico : archivoEmpleados ; var archivo_fisico : cadena50 );
var
	e : empleado;
begin
	
	{ leer nombre del archivo }
	write('Nombre del archivo a crear: ');
	readln( archivo_fisico );

	{ asignar espacio fisico }
	assign( archivo_logico , archivo_fisico );

 	{ Crear archivo }
	rewrite( archivo_logico );
	
	writeln;
	writeln('ingresar empleados ( para finalizar ingrese "fin" ):');
	writeln;
	
	{ Leer primer empleado }
	leerEmpleado( e , fileSize(archivo_logico)  );
	
	while( e.apellido <> 'fin' ) do
	begin
		
		{ escribir en el archivo }
		write( archivo_logico , e );
		
		{ leer proximo empelado }
		leerEmpleado( e , fileSize(archivo_logico) );

	end;
	
	{ Cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure listarEmpleados ( var archivo_logico : archivoEmpleados );
var
	e : empleado;
	
	archivo_fisico : cadena50;
begin
	
	write('nombre del archivo a listar: ');
	readln( archivo_fisico );
	assign( archivo_logico , archivo_fisico );
	
	{ Abrir archivo binario }
	reset( archivo_logico );
	
	{ Recorrer archivo }
	while( not eof( archivo_logico ) ) do
	begin
	
		{ Leer archivo }
		read( archivo_logico , e );

		{ imprimir empleado }
		mostrarInfoEmpleado( e );

	end;
	
	{ Cerrar archivo binario }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure agregarEmpleados( var archivo_logico : archivoEmpleados );
var
	e : empleado;
	archivo_fisico : cadena50;
begin
	
	write('nombre del archivo a modificar: ');
	readln( archivo_fisico );
	assign( archivo_logico , archivo_fisico );

	{ Abrir archivo binario }
	reset( archivo_logico );
	
	{ Nos posicionamos al final del archivo binario }
	seek( archivo_logico , fileSize(archivo_logico) );

	writeln;
	writeln('agregar empleados ( para finalizar ingrese "fin" ):');
	writeln;
	
	{ leer primer empelado }
	leerEmpleado( e , fileSize(archivo_logico) );
	
	while( e.apellido <> 'fin' ) do
	begin
	
		{ escribir en archivo }
		write( archivo_logico , e );
		
		{ leer otro empleado }
		leerEmpleado( e , fileSize(archivo_logico) );
		
	end;

	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure modificarEdad( var archivo_logico : archivoEmpleados );
var
	e : empleado;
	num : integer;
	edadActualizada : integer;
	encontrado : boolean;
	archivo_fisico : cadena50;
begin

	write('nombre del archivo a modificar: ');
	readln( archivo_fisico );
	assign( archivo_logico , archivo_fisico );

	write('Numero del empleado a modificar: ');
	readln( num );

	write('Edad actualizada: ');
	readln( edadActualizada );
	
	{ Abrir archivo binario }
	reset( archivo_logico );

	{ Recorrer archivo binario }
	encontrado := false;
	while ( not eof(archivo_logico) ) and ( not encontrado ) do
	begin
	
		{ Leer archivo binario }
		read( archivo_logico , e );
		
		{ Si se encontro al empleado... }
		if ( e.numero = num ) then
		begin
		
			{ actualizar edad }
			e.edad := edadActualizada;
			
			{ booleano para cancelar while }
			encontrado := true;
			
			{ movemos el puntero una posicion hacia atras }
			seek( archivo_logico , filePos(archivo_logico) - 1 );
			
			{ Escribimos el dato en el archivo }
			write( archivo_logico , e );
			
		end;

	end;
	
	{ Cerrar archivo binario }
	close( archivo_logico );
	
	{ Se notifica si se encontro o no }
	if ( not encontrado ) then
		writeln('El numero de empleado no fue encontrado')
	else
		writeln('Se actualizo la edad correctamente');	
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure exportar( var archivo_logico : archivoEmpleados ; var archivo_texto : Text );
var
	e : empleado;
	archivo_fisico : cadena50;
begin

	write('nombre del archivo a exportar: ');
	readln( archivo_fisico );
	assign( archivo_logico , archivo_fisico );

	{ Asignar nombre al archivo de texto  }
	assign( archivo_texto , 'todos_empleados.txt' );
	
	{ Abrir archivo binario }
	reset( archivo_logico );

	{ Crear archivo de texto }
	rewrite( archivo_texto );

	while ( not eof(archivo_logico) ) do 
	begin
		read( archivo_logico , e );
		with e do 
			writeln( archivo_texto , 'Numero de Empleado: ', numero:10 , ' Nombre: ' , nombre:10 , ' Apellido: ' , apellido:10 , ' Edad: ' , edad:10 , ' DNI: ' , dni:10 );
	end;
	
	{ Cerrar archivos }
	close ( archivo_logico );
	close ( archivo_texto );
	
	writeln('exportado con exito...');
end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure exportarSinDNI( var archivo_logico : archivoEmpleados ; var archivo_texto : Text );
var
	e : empleado;
	archivo_fisico : cadena50;
begin

	write('nombre del archivo a exportar: ');
	readln( archivo_fisico );
	assign( archivo_logico , archivo_fisico );
	
	{ Asignar nombre }
	assign( archivo_texto , 'faltaDNIEmpleados.txt' );
	
	{ Abrir archivo binario }
	reset( archivo_logico );

	{ Crear archivo de texto }
	rewrite( archivo_texto );

	while ( not eof(archivo_logico) ) do 
	begin
	
		{ Leer empleado }
		read( archivo_logico , e );
		
		{ Si tiene '00' agrego al archivo }
		if ( e.DNI = 00 ) then
			with e do 
				writeln ( archivo_texto , 'Numero de Empleado: ', numero:10 , ' Nombre: ' , nombre:10 , ' Apellido: ' , apellido:10 , ' Edad: ' , edad:10 , ' DNI: ' , dni:10 );
	
	end;
	
	{ Cerrar archivos }
	close ( archivo_logico );
	close ( archivo_texto );
	
	writeln('exportado con exito...');
end;
{ ======================================================================================================================== }
{                                                         OPCION 7                                                         }
{ ======================================================================================================================== }
procedure eliminarEmpleado( var archivo_logico:archivoEmpleados );
var
	aux, e : empleado;
	num : integer;
	encontrado : boolean;
	nombre : string;
begin

	encontrado := false;

	{ ingresar nombre del archivo a modificar }
	write('nombre del archivo a modificar: ');
	readln( nombre );
	assign( archivo_logico , nombre );

	{ abrir archivo }
	reset( archivo_logico );

	{ leer numero a buscar }
	write('Numero del empleado a eliminar: ');
	readln( num );

	{ copiar ultimo elemento del archivo }
	seek ( archivo_logico , filesize(archivo_logico)-1 );
	read( archivo_logico , aux );

	{ reubicar puntero }
	seek( archivo_logico , 0 );
	

	while ( not eof(archivo_logico) ) and ( not (encontrado) ) do 
	begin
	
		{ leer un empleado }
		read( archivo_logico , e );
		
		{ si es el que buscamos se elimina }
		if ( e.numero = num ) then
		begin
			
			encontrado := true;
			
			{ reemplaza el registro a eliminar con la copia que hicimos del ultimo elemento del archivo }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			write( archivo_logico , aux );
			
			{ posicionamos el puntero en el ultimo elemento del archivo 
			  y usamos el "truncate" para borrar todos los registros posteriores ( solo el ultimo en este caso ) }
			seek( archivo_logico , filesize(archivo_logico)-1 );
			truncate( archivo_logico );
			
		end;
	
	end;

	{ notificar operacion... }
	if ( encontrado ) then
		writeln('Empleado eliminado con exito')
	else
		writeln('No se encontro el empleado con numero ' , num );
	writeln;	
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : archivoEmpleados;
	archivo_fisico : cadena50;
	text_empleados : Text;
	opcion : integer;
BEGIN

	opcion := 0;
	while ( opcion <> 8 ) do 
	begin
		menu( opcion );
		clrscr;
		case opcion of 
			1: crearArchivoDeEmpleados( archivo_logico , archivo_fisico );
			2: listarEmpleados( archivo_logico );
			3: agregarEmpleados( archivo_logico );
			4: modificarEdad( archivo_logico );
			5: exportar( archivo_logico , text_empleados );
			6: exportarSinDNI( archivo_logico , text_empleados );
			7: eliminarEmpleado( archivo_logico );
			8: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;

END.

