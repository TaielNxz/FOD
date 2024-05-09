{
	3. Suponga que trabaja en una oficina donde está montada una LAN (red local). La
	misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
	todas las máquinas se conectan con un servidor central. Semanalmente cada
	máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
	en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
	los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
	procedimiento que reciba los archivos detalle y genere un archivo maestro con los
	siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
	
	Notas:

		● Los archivos detalle no están ordenados por ningún criterio.
		● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
		  inclusive, en diferentes máquinas
}
program practica03_parte02_ejercicio03;
const
	dimf = 5;
	valorAlto = 9999;
type
	
	log = record
		cod: integer;
		fecha: string;
		tiempo_sesion: real;
	end;
	
	archivo_logs = file of log;
	
    vector_detalle = array[1..dimf] of archivo_logs;


{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Hacer un Merge de los ' , dimf , ' detalles' );
	writeln('2. Crear ' , dimf , ' detalles');
	writeln('3. Listar maestro');
	writeln('4. Listar ' , dimf , ' detalles');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure mergeArchivos( var maestro:archivo_logs ; var vectorD:vector_detalle );
var
	regm, regd : log;
	i : integer;
	encontrado : boolean;
begin

	{ crear maestro }
	rewrite( maestro );
	
	for i:= 1 to dimf do
	begin
	
		{ abrir detalle }
		reset( vectorD[i] );
		
		regd.cod := valorAlto;
		
		while ( not eof(vectorD[i]) ) do
		begin
		
			encontrado := false;
			
			seek( maestro , 0 );

			{ leer un registro del detalle }
			read( vectorD[i] , regd );
			 
			{ recorrer todo el maestro para ver si hay otro registro con el mismo codigo }
			while ( not eof(maestro) ) and ( not encontrado ) do
			begin
			
				{ leer registro del }
				read( maestro , regm );
				
				if ( regm.cod = regd.cod ) then
					encontrado := true;
				
			end;
			
			{ si se encontro un registro con el mismo codigo, lo actualizamos }
			if ( encontrado ) then
			begin
			
				regm.tiempo_sesion := regm.tiempo_sesion + regd.tiempo_sesion;
				
				seek( maestro , filepos(maestro)-1 );
			
				write( maestro , regm );
			
			{ si NO se encontro un registro con el mismo codigo, creamos un nuevo registro }
			end else
				write( maestro , regd );
				
		end;

		{ cerrar detalle }
		close( vectorD[i] );

	end;
	
	{ cerrar archivos }
	close( maestro );
	
	{ notificar exito... }
	writeln('se creo el archivo correctamente...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearArchivoLogs( var archivo:archivo_logs );

	procedure leerLog( var l:log );
	begin
		with l do
		begin
			writeln('-----------------------');
			write('codigo de sesion: ');
			readln(cod);
			if ( cod <> -1 ) then 
			begin
				write('fecha: ');
				readln(fecha);
				write('tiempo de sesion: ');
				readln(tiempo_sesion);
			end;
		end;
	end;

var
	l : log;
begin

	{ crear archivo }
	rewrite( archivo );
	
	{ leer primer log }
	leerLog(l);
	
	while ( l.cod <> -1 ) do 
	begin
	
		{ agregar aceeso al archivo de logs }
		write( archivo , l );
	
		{ leer proximo log }
		leerLog(l);
	
	end;
	
	{ cerrar archivo }
	close( archivo );

end;

procedure crearArchivos( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('= = = = = = = = = = =');
		writeln( 'Creando Detalle ' , iString );
		crearArchivoLogs( vectorD[i] );
	end;

end;
{ ======================================================================================================================== }
{                                                     OPCION 3 y 4                                                         }
{ ======================================================================================================================== }
procedure mostrarArchivoLogs( var archivo:archivo_logs );

	procedure imprimirLog( l:log );
	begin
		with l do
		begin
			writeln('-----------------------');
			writeln('codigo de usuario: ' , cod);
			writeln('fecha: ' , fecha);
			writeln('tiempo de sesion: ' , tiempo_sesion:1:0);
		end;
	end;

var
	l : log;
begin

	{ abrir archivo }
	reset( archivo );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo) ) do begin
	
		{ leer log del archivo de logs }
		read( archivo , l );
		
		{ mostrar log en consola }
		imprimirLog(l);
		
	end;
	
	{ cerrar archivo }
	close( archivo );
	
end;

procedure mostrarArchivos( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('=====================');
		writeln( ' Detalle ' , iString );
		mostrarArchivoLogs( vectorD[i] );
		writeln('=====================');
	end;


end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_logs;
	vectorD : vector_detalle;
	opcion : integer;
	i : integer;
	iString : string;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	
	for i := 1 to dimf do begin
		str( i , iString );
		assign( vectorD[i] , 'archivo_detalle_'+iString );
	end;
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: mergeArchivos( maestro , vectorD );
			2: crearArchivos( vectorD );
			3: mostrarArchivoLogs( maestro );
			4: mostrarArchivos( vectorD );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
