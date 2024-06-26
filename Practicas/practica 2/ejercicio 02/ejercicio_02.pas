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


program practica02_ejercicio02;
CONST
	valorAlto = 9999;
TYPE

	rango = 0..2;
	cadena20 = String[20];
	
	alumno_maestro = record
		codigo : integer;
		nombre : cadena20;
		apellido : cadena20;
		finalPendiente : integer;
		finalAprobado  : integer;
	end;
	
	alumno_detalle = record
		codigo : integer;
		estado : rango; { 0 -> desaprobada/sin cursar ; 1 -> finalPendiente ; 2 -> finalAprobado }
	end;

	archivo_maestro = file of alumno_maestro;
	archivo_detalle = file of alumno_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro con 1 detalle');
	writeln('2. Exportar a texto alumnos con mas finales aprobados que pendientes');
	writeln('3. Crear maestro');
	writeln('4. Crear detalle');
	writeln('5. Mostrar maestro');
	writeln('6. Mostrar detalle');
	writeln('7. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_detalle ; var dato:alumno_detalle );
begin

	if ( not eof(archivo) ) then
		read( archivo , dato )
	else
		dato.codigo := valorAlto;
		
end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var detalle:archivo_detalle );
var
	regm : alumno_maestro;
	regd : alumno_detalle;
	codAct : integer;
	cantPendientes : integer;
	cantAprobadas : integer;
begin

	{ abrir ambos archivos }
	reset( maestro );
	reset( detalle );
	
	{ leer detalle }
	leer( detalle , regd );
	
	{ recorrer todo el archivo detalle }
	while( regd.codigo <> valorAlto ) do
	begin
	
		codAct := regd.codigo;
		cantPendientes := 0;
		cantAprobadas := 0;
	
		{ recorrer todos los registros con el mismo codigo }
		while ( codAct = regd.codigo ) do 
		begin
			
			{ sumar materias con final pendiente }
			if ( regd.estado = 1 ) then
				cantPendientes := cantPendientes + 1;
				
			{ sumar materias con final aprobado y restar una pendiente }
			if ( regd.estado = 2 ) then
			begin
				cantAprobadas := cantAprobadas + 1;
				cantPendientes := cantPendientes - 1;
			end;

			{ leer proximo registro }
			leer( detalle , regd )
			
		end;
		
		{ leer maestro para empezar a recorrer }
		read( maestro , regm );
		
		{ buscar el registro a modificar }
		while ( regm.codigo <> codAct ) do
			read( maestro, regm );

		{ ya encontrado lo modificamos... }
		regm.finalPendiente := regm.finalPendiente + cantPendientes;
		regm.finalAprobado := regm.finalAprobado + cantAprobadas;
		
		{ reubica el puntero }
		seek( maestro , filepos(maestro)-1 );
		
		{ escribe en el archivo maestro para actualizarlo }
		write( maestro , regm );
		
	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( detalle );

	{ notificar exito }
	writeln('actualizado correctamente...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure exportarTexto( var maestro:archivo_maestro ; var texto:Text );
var
	regm : alumno_maestro;
begin

	{ abrir archivo maestro }
	reset( maestro );
	
	{ crear archivo de texto }
	rewrite( texto );
	
	{ recorrer archivo maestro }
	while( not eof(maestro) ) do
	begin
	
		{ leer registro meastro }
		read( maestro , regm );
		
		{ escribir en archivo de texto }
		if ( regm.finalAprobado > regm.finalPendiente ) then
			with regm do
				writeln ( texto , codigo , ' ' , nombre , ' ' , apellido , ' ' , finalPendiente , ' ' , finalAprobado );

	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( texto );

	{ notificar exito }
	writeln('exportado correctamente...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerAlumnoMaestro( var a:alumno_maestro );
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

var
	a : alumno_maestro;
begin

	{ crear archivo }
	rewrite( maestro );

	{ leer primer alumno }
	leerAlumnoMaestro( a );

	{ agregar nuevos alumnos al archivo hasta que se ingrese el codigo -1 }
	while ( a.codigo <> -1 ) do 
	begin
		
		{ agregar alumno al archivo maestro }
		write( maestro , a );
			
		{ leer proximo alumno }
		leerAlumnoMaestro( a );

	end;
	
	{ cerrar archivo maestro }
	close( maestro ); 
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerAlumnoDetalle( var a:alumno_detalle );
	begin
		with a do 
		begin
			writeln('------------------------');
			write('codigo: ');
			readln( codigo );
			if ( codigo <> -1 ) then
			begin
				write('estado ( 1:pendiente / 2:aprobado ): ');
				readln( estado );	
			end;
		end;
	end;

var
	a : alumno_detalle;
begin

	{ crear archivo }
	rewrite( detalle );

	{ leer primer alumno }
	leerAlumnoDetalle( a );

	{ agregar nuevos alumnos al archivo hasta que se ingrese el codigo -1 }
	while ( a.codigo <> -1 ) do 
	begin
		
		{ agregar alumno al archivo detalle }
		write( detalle , a );
			
		{ leer proximo alumno }
		leerAlumnoDetalle( a );

	end;
	
	{ cerrar archivo }
	close( detalle ); 
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro ( var maestro:archivo_maestro );

	procedure imprimirMaestro( a:alumno_maestro );
	begin
		with a do 
		begin
		writeln('------------------');
		writeln('Codigo de Alumno: ' , codigo);
		writeln('nombre: ' , nombre);
		writeln('apellido: ' , apellido);
		writeln('cantidad de finales pendientes: ' , finalPendiente );
		writeln('cantidad de finales aprobados: ' , finalAprobado);
		end;
	end;

var
	a : alumno_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer archivo }
		read( maestro , a );
		
		{ mostrar alumno en consola }
		imprimirMaestro(a);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle ( var detalle:archivo_detalle );

	procedure imprimirDetalle( a:alumno_detalle );
	begin
		writeln('------------------');
		writeln('Codigo de Alumno: ', a.codigo);
		case a.estado of
			0: writeln('Estado: 0 (desaprobada/sin cursar)');
			1: writeln('Estado: 1 (finalPendiente)');
			2: writeln('Estado: 2 (finalAprobado)')
		end;
	end;

var
	a : alumno_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer alumno del detalle }
		read( detalle , a );
		
		{ mostrar alumno en consola }
		imprimirDetalle(a);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	detalle : archivo_detalle;
	texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'alumnos_maestro' );
	assign( detalle , 'alumnos_detalle' );
	assign( texto , 'alumnos_texto.txt' );

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , detalle );
			2: exportarTexto( maestro , texto );
			3: crearMaestro( maestro );
			4: crearDetalle( detalle );
			5: mostrarMaestro( maestro );
			6: mostrarDetalle( detalle );
			7: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
