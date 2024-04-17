{
	2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
	cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
	(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
	un archivo detalle con el código de alumno e información correspondiente a una materia
	(esta información indica si aprobó la cursada o aprobó el final).
	
	Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
	haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
	programa con opciones para:
	
		a. Actualizar el archivo maestro de la siguiente manera:
		
			i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
			y se decrementa en uno la cantidad de materias sin final aprobado.
			
			ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
			final.
		
		b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
		aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
		es un reporte de salida (no se usa con fines de carga), debe informar todos los
		campos de cada alumno en una sola línea del archivo de texto.
		
	NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}
program practica02_ejercicio01_crear_detalles;
TYPE

	cadena20 = String[20];
	
	alumno_maestro = record
		codigo : integer;
		nombre : cadena20;
		apellido : cadena20;
		finalPendiente : integer;
		finalAprobado  : integer;
	end;

	archivo_maestro = file of alumno_maestro;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure leerAlumno( var a:alumno_maestro );
begin
	with a do 
	begin
		writeln('------------------------');
		write('codigo: ');
		readln( codigo );
		if ( codigo <> -1 ) then
		begin
			write('nombre: ');
			readln( nombre );
			write('apellido: ');
			readln( apellido );
			write('cantidad de finales pendientes: ');
			readln( finalPendiente );	
			write('cantidad de finales aprobados: ');
			readln( finalAprobado );	
		end;
	end;
end;


procedure crearMaestroDeEmpleados( var maestro:archivo_maestro );
var
	a : alumno_maestro;
begin

	{ crear archivo detalle }
	rewrite( maestro );

	{ leo primer alumno }
	leerAlumno( a );

	{ agregar nuevos alumnos al registro hasta que se ingrese el codigo -1 }
	while ( a.codigo <> -1 ) do 
	begin
		
		{ escribo en el archivo }
		write( maestro , a );
			
		{ leo proximo alumno }
		leerAlumno( a );

	end;
	
	{ cerrar archivo }
	close( maestro ); 
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'alumnos_maestro' );

	writeln('creando maestro de alumnos ( -1 para finalizar )');
	writeln;

	{ crear archivo binario }
	crearMaestroDeEmpleados( maestro );

END.
