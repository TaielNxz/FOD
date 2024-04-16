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
type

	cadena50 = string[50];
	empleado = record
		apellido : cadena50;
		nombre : cadena50;
		edad : cadena50;
		DNI : integer;
		numero : integer;
	end;
	
	archivoEmpleados = file of empleado;
	
{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
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

procedure crearArchivo( var archivo_logico : archivoEmpleados  );
var
	e : empleado;
begin

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
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : archivoEmpleados;
	archivo_fisico : cadena50;
BEGIN

	{ Agregar nombre del archivo }
	write('Nombre del archivo a crear: ');
	readln( archivo_fisico );
	
	{ Asignar a espacio fisico }
	assign( archivo_logico , archivo_fisico );
	
	{ generar archivo binario }
	crearArchivo( archivo_logico );
	
END.
