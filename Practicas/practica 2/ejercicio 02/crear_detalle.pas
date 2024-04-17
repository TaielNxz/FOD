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

	rango = 0..2;

	alumno_detalle = record
		codigo : integer;
		estado : rango; { 0 -> desaprobada/sin cursar ; 1 -> finalPendiente ; 2 -> finalAprobado }
	end;

	archivo_detalle = file of alumno_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure leerAlumno( var a:alumno_detalle ; cod:integer );
begin
	with a do 
	begin
		writeln('-----------------------');
		codigo := cod;
		writeln('codigo de alumno: ' , codigo );
		write('estado ( 1 o 2 ): ');
		readln( estado );	
	end;
end;


procedure crearDetalleDeEmpleados( var detalle:archivo_detalle );
var
	a : alumno_detalle;
	codigoActual : integer;
	estado : integer;
begin

	{ crear archivo detalle }
	rewrite( detalle );

	codigoActual := 999;
	while ( codigoActual <> 0 ) do 
	begin
		
		writeln;
		write('nuevo codigo de alumno: ');
		readln( codigoActual );
		
		estado := 999;
		while ( codigoActual <> 0 ) and ( estado <> 0 ) do begin
		
			{ leer proximo alumno }
			leerAlumno( a , codigoActual );
			
			{ si no se cancelo la carga, escribe en el archivo }
			if ( a.estado <> 0 ) then
				write( detalle , a )
			else
				estado := 0;

		end;
		
	end;
	
	{ cerrar archivo }
	close( detalle ); 
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	detalle : archivo_detalle;
BEGIN

	{ asignar espacio fisico }
	assign( detalle , 'alumnos_detalle' );

	writeln('creando detalle de alumnos ( 0 para finalizar )');
	writeln;

	{ crear archivo binario }
	crearDetalleDeEmpleados( detalle );

END.
