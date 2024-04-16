{
	3. Realizar un programa que presente un menú con opciones para:
	
	a. Crear un archivo de registros no ordenados de empleados y completarlo con
	datos ingresados desde teclado. De cada empleado se registra: número de
	empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
	DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
	
	b. Abrir el archivo anteriormente generado y
	
		i.Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado, el cual se proporciona desde el teclado.
		
		ii.Listar en pantalla los empleados de a uno por línea.
		
		iii.Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
	
	NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario
}

program practica01_ejercicio03;
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
	
{ ============================================================================================= }
{                                       PROCEDIMIENTOS                                          }
{ ============================================================================================= }
procedure menu( var opcion : integer );
begin
	writeln('========================================================================');
	writeln('1. Crear archivo de empleados');
	writeln('2. Listar datos de empleados que tengan un nombre o apellido determinado');
	writeln('3. Listar los empleados de a uno por linea');
	writeln('4. Listar los empleados mayores de 70, proximos a jubilarse');
	writeln('5. Salir');
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
{ ============================================================================================= }
{                                           OPCION 1                                            } 
{ ============================================================================================= }
procedure crearArchivoDeEmpleados( var archivo_logico : archivoEmpleados  );

	procedure leerEmpleado ( var e : empleado );
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
			readln(e.dni);
			write('Numero de Empleado: '); 
			readln(e.numero);
		end;
		writeln;
	end;

var
	archivo_fisico : cadena50;
	e : empleado;
begin

	{ leer nombre del archivo }
	write('Nombre del archivo a crear: ');
	readln( archivo_fisico );

	{ asignar espacio fisico }
	assign( archivo_logico , archivo_fisico );

 	{ Crear archivo }
	rewrite( archivo_logico );
	
	{ Leer primer empleado }
	leerEmpleado( e );
	
	while( e.apellido <> 'fin' ) do
	begin
		
		{ escribir en el archivo }
		write( archivo_logico , e );
		
		{ leer proximo empelado }
		leerEmpleado( e );

	end;
	
	{ Cerrar archivo }
	close( archivo_logico );

end;
{ ============================================================================================= }
{                                           OPCION 2                                            } 
{ ============================================================================================= }
procedure listarDatos1 ( var archivo_logico : archivoEmpleados );
var
	e : empleado;
	info : cadena50;
begin
	
	// Leer dato a buscar
	write('Ingrese un nombre o apellido a buscar: ');
	readln( info );
	
	// Abrir archivo binario
	reset( archivo_logico );
	
	// Recorrer archivo
	while( not eof( archivo_logico ) ) do
	begin
	
		// Leer archivo
		read( archivo_logico , e );
		
		// Si es el ingresado se imprime
		if ( info = e.apellido ) or ( info = e.nombre ) then
			mostrarInfoEmpleado( e );

	end;
	
	// Cerrar archivo binario
	close( archivo_logico );

end;
{ ============================================================================================= }
{                                           OPCION 3                                            } 
{ ============================================================================================= }
procedure listarDatos2( var archivo_logico : archivoEmpleados );
var
	e : empleado;
begin

	// Abrir archivo binario
	reset( archivo_logico );
	
	// Recorrer archivo
	while ( not eof( archivo_logico ) ) do
	begin
	
		// Leer archivo
		read( archivo_logico , e );
		
		// Mostrar en consola
		mostrarInfoEmpleado( e );
		
	end;
	
	// Cerrar archivo binario
	close( archivo_logico );

end;
{ ============================================================================================= }
{                                           OPCION 4                                            } 
{ ============================================================================================= }
procedure listarDatos3( var archivo_logico : archivoEmpleados );
var
	e : empleado;
begin

	// Abrir archivo binario
	reset( archivo_logico );
	
	// Recorrer archivo
	while ( not eof( archivo_logico ) ) do
	begin
	
		// Leer archivo
		read( archivo_logico , e );
		
		// Mostrar en consola
		if ( e.edad > 70 ) then
			mostrarInfoEmpleado( e );

	end;
	
	// Cerrar archivo binario
	close( archivo_logico );
	
end;
{ ============================================================================================= }
{                                     PROGRAMA PRINCIPAL                                        }
{ ============================================================================================= }
VAR
	empleados : archivoEmpleados;
	opcion : integer;
BEGIN

	opcion := 0;
	while ( opcion <> 5 ) do
	begin
		menu( opcion );
		clrscr;
		case opcion of 
			1: crearArchivoDeEmpleados( empleados );
			2: listarDatos1( empleados );
			3: listarDatos2( empleados );
			4: listarDatos3( empleados );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;

END.
