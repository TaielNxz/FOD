{
	6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
	construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
	máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
	archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
	cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
	cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
	detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
	tiempo_total_de_sesiones_abiertas.
	
	Notas:
		● Cada archivo detalle está ordenado por cod_usuario y fecha.
		● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
		inclusive, en diferentes máquinas.
		● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program practica02_ejercicio06;
const
	valorAlto = 9999;
	dimf = 5;
type

	log_maestro = record
		cod_usuario : integer;
		fecha : integer;
		tiempo_total_de_sesiones_abiertas : integer;
	end;
	
	log_detalle = record		
		cod_usuario : integer;
		fecha : integer;
		tiempo_sesion : integer;
	end;
	
	archivo_maestro = file of log_maestro;
	archivo_detalle = file of log_detalle;
	
	vector_detalle = array [1..dimf] of archivo_detalle;
	vector_registro_detalle = array [1..dimf] of log_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Crear maestro con ' , dimf , ' detalles');
	writeln('2. Crear detalles');
	writeln('3. Mostrar maestro');
	writeln('4. Mostrar detalles');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_detalle ; var dato:log_detalle );
begin	
	if ( not eof(archivo) ) then
		read( archivo , dato )
	else
		dato.cod_usuario := valorAlto;
end;

procedure minimo( var vectorRD:vector_registro_detalle ; var regMin:log_detalle ; var vectorD:vector_detalle );
var
	posMin : integer;
	i : integer;
begin

	regMin.cod_usuario := valorAlto;
	regMin.fecha := valorAlto;
	
	{ recorro todo todos los detalles }
	for i := 1 to dimF do 
	begin
	
		{ guardo el registro con codigo mas pequeño }
		if ( vectorRD[i].cod_usuario < regMin.cod_usuario ) then 
		begin
			regMin := vectorRD[i];
			posMin := i;
		end;
	
		{ entre los registros con el mismo codigo, guardo el de la menor fecha }
		if ( vectorRD[i].cod_usuario = regMin.cod_usuario ) and ( vectorRD[i].fecha < regMin.fecha ) then
		begin
			regMin := vectorRD[i];
			posMin := i;
		end;
		
	end;
	
	{ obtengo el dato del registro con cod_usuario y la fecha mas pequeños }
	if ( regMin.cod_usuario <> valorAlto ) then
		leer( vectorD[posMin] , vectorRD[posMin] );

end;
	
procedure crearMaestro( var maestro:archivo_maestro ; var vectorD:vector_detalle );
var
	regm : log_maestro;
	regMin : log_detalle;
	vectorRD : vector_registro_detalle;
	i : integer;
begin
	
	{ crear archivo maestro }
	reset( maestro );
	
	{ abrir y leer archivos detalles }
	for i:=1 to dimF do begin
		reset( vectorD[i] );
		read( vectorD[i] , vectorRD[i] );
	end;
	
	{ buscar el registro minimo en el vector }
	minimo( vectorRD , regMin , vectorD );
	
	{ cuando se llegue al final del archivo se retornara un valorAlto y se cancelará el bucle }
	while ( regMin.cod_usuario <> valorAlto ) do
	begin
		
		{ crear registro maestro }
		regm.cod_usuario := regMin.cod_usuario;
		regm.fecha := regMin.fecha;
		regm.tiempo_total_de_sesiones_abiertas := 0;
		
		{ recorrer todos los archivos con el mismo codigo }
		while ( regm.cod_usuario = regMin.cod_usuario ) and ( regm.fecha = regMin.fecha ) do
		begin
		
			{ modificar datos del maestro }
			regm.tiempo_total_de_sesiones_abiertas := regm.tiempo_total_de_sesiones_abiertas + regMin.tiempo_sesion;
			
			{ leer proximo registro }
			minimo( vectorRD , regMin , vectorD );
			
		end;
			
		{ agregar registro nuevo en el archivo maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrar archivo maestro }
	close( maestro );
	
	{ cerrar archivos detalle }
	for i:=1 to dimF do
		close( vectorD[i] );

	{ notificar exito }
	writeln('archivo creado con exito...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerLogDetalle( var l:log_detalle );
	begin
		with l do
		begin
			writeln('-----------------');
			write('codigo de usuario: ');
			readln(cod_usuario);
			if ( cod_usuario <> -1 ) then 
			begin
				write('fecha: ');
				readln(fecha);
				write('tiempo_sesion: ');
				readln(tiempo_sesion);
			end;
		end;
	end;

var
	l : log_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primer log }
	leerLogDetalle( l );
	
	{ agregar nuevos logs al archivo hasta que se ingrese el codigo -1 }
	while ( l.cod_usuario <> -1 ) do 
	begin
		
		{ agregar log al archivo detalle }
		write( detalle , l );
		
		{ leer proximo log }
		leerLogDetalle( l );
		
	end;
	
	{ cerrar archivo }
	close( detalle )

end;

procedure crearDetalles( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('= = = = = = = = = = =');
		writeln( 'Creando Detalle ' , iString );
		crearDetalle( vectorD[i] );
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
	
	procedure imprimirLogMaestro( l:log_maestro );
	begin
		with l do 
		begin
			writeln('------------------');
			writeln('codigo de usuario: ', cod_usuario);
			writeln('fecha: ', fecha);
			writeln('tiempo_total_de_sesiones_abiertas: ', tiempo_total_de_sesiones_abiertas);
		end;
	end;

var
	l : log_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer log del maestro }
		read( maestro , l );
		
		{ mostrar log en consola }
		imprimirLogMaestro(l);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle ( var detalle:archivo_detalle );

	procedure imprimirLogDetalle( l:log_detalle );
	begin
		with l do 
		begin
			writeln('------------------');
			writeln('codigo de usuario: ', cod_usuario);
			writeln('fecha: ', fecha);
			writeln('tiempo_sesion: ', tiempo_sesion );
		end;
	end;

var
	l : log_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer log del detalle }
		read( detalle , l );
		
		{ mostrar log en consola }
		imprimirLogDetalle(l);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;

procedure mostrarDetalles( vectorD:vector_detalle );
var
	i : integer;
	iString : string;
begin

	for i := 1 to dimF do begin
		str( i , iString );
		writeln;
		writeln('=====================');
		writeln( ' Detalle ' , iString );
		mostrarDetalle( vectorD[i] );
		writeln('=====================');
	end;

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	vectorD : vector_detalle;
	i : integer;
	iString : String;
	opcion : integer;
BEGIN

	{ asignar espacio fisico al maestro }
	// assign( maestro , 'var/log' );
	assign( maestro , 'archivo_maestro' );
	
	{ asignar espacio a los detalles }
	for i := 1 to dimf do begin
	
		{ crear variable string con el valor de 'i' }
		str( i , iString );
	
		{ asignar espacio fisico a el detalle actual }
		assign( vectorD[i] , 'archivo_detalle_'+iString );
		
	end;

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 5 ) do 
	begin
		menu( opcion );
		case opcion of
			1: crearMaestro( maestro , vectorD );
			2: crearDetalles( vectorD );
			3: mostrarMaestro( maestro );
			4: mostrarDetalles( vectorD );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
