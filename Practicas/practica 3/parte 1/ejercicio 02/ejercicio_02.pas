{
	2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
	información de asistentes a un congreso a partir de la información obtenida por
	teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
	nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
	archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
	asistente inferior a 1000.
	
	Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
	String a su elección. Ejemplo: ‘@Saldaño’.
}
program practica03_ejercicio02;
type
	
	asistente = record
		numero : integer;
		apellido : string;
		nombre : string;
		email : string;
		telefono : integer;
		DNI : integer;
	end;
	
	archivo_asistentes = file of asistente;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Crear archivo de Asistentes');
	writeln('2. Listar archivo de Asistentes');
	writeln('3. Eliminar asistentes con numero inferior a 1000');
	writeln('4. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leerAsistente( var a:asistente );
begin

	with a do
	begin
		writeln('-----------------------');
		write('numero de asistente: ');
		readln( numero );
		if ( numero <> -1 ) then
		begin
			write('apellido: ');
			readln( apellido );
			write('nombre: ');
			readln( nombre );
			write('email: ');
			readln( email );
			write('telefono: ');
			readln( telefono );
			write('DNI: ');
			readln( DNI );
		end;
	end;
	
end;

procedure crearArchivo( var archivo_logico:archivo_asistentes );
var
	a : asistente;
begin

	{ crear archivo }
	rewrite( archivo_logico );
	
	{ leer primer asistente }
	leerAsistente( a );
	
	while ( a.numero <> -1 ) do
	begin
	
		{ agregar asistente al archivo }
		write( archivo_logico , a );
		
		{ leer proximo asistente }
		leerAsistente( a );
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure imprimirAsistente( var a:asistente );
begin

	with a do
	begin
		if ( a.nombre <> '@eliminado' ) then
		begin
			writeln('-----------------------');
			writeln('numero:' , numero );
			writeln('apellido:' , apellido );
			writeln('nombre:' , nombre );
			writeln('email:' , email );
			writeln('telefono:' , telefono );
			writeln('DNI:' , DNI );
		end;
	end;
	
end;


procedure listarAsistentes( var archivo_logico:archivo_asistentes );
var
	a : asistente;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo_logico) ) do begin
	
		{ leer asistente del archivo }
		read( archivo_logico , a );
		
		{ mostrar asistente en consola }
		imprimirAsistente(a);
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure leer ( var archivo_logico:archivo_asistentes ; var dato:asistente );
begin
	if ( not eof (archivo_logico) ) then
		read ( archivo_logico , dato )
	else
		dato.numero := -1;
end;

procedure eliminarAsistente( var archivo_logico:archivo_asistentes );
var
	a : asistente;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer primer asistente }
	leer( archivo_logico , a );
	
	while ( a.numero <> -1 ) do
	begin
	
		if ( a.numero < 1000 ) then
		begin
		
			{ se modifica el campo para indicar el borrado logico }
			a.nombre := '@eliminado';
			
			{ modificar registro del archivo }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			write( archivo_logico , a );
		
		end;
		
		{ leer proximo asistente }
		leer( archivo_logico , a );
	
	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : archivo_asistentes;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_logico , 'asistentes');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 4 ) do 
	begin
		menu( opcion );
		case opcion of
			1: crearArchivo( archivo_logico );
			2: listarAsistentes( archivo_logico );
			3: eliminarAsistente( archivo_logico );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.

