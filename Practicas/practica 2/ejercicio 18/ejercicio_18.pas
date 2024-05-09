{
	18. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
	toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
	información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
	en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
	reuniendo dicha información.
	
	Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
	nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
	del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
	padre.
	
	En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
	apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
	lugar.
	
	Realizar un programa que cree el archivo maestro a partir de toda la información de los
	archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
	apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
	apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
	además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
	deberá, además, listar en un archivo de texto la información recolectada de cada persona.
	
	
	Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única. Tenga
	en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
	además puede no haber fallecido
}
program practica02_ejercicio16;
const
	valorAlto = 9999;
	dimf = 1; // 50
type

	persona = record
		nombre : string;
		apellido : string;
		DNI : integer;
	end;
	
	direccion = record
		calle : string;
		nro : integer;
		piso : integer;
		depto : integer;
		ciudad : string;
	end;
	
	detalle_fallecido = record
		nroPartida : integer;
		datosFallecido : persona;
		matriculaFallecimiento : string;
		fecha : integer;
		hora : integer;
		lugar : string;
	end;
	
	detalle_nacimiento = record
		nroPartida : integer;
		nombre : string;
		apellido : string;
		matriculaNacimiento : integer;
		datosDireccion : direccion;
		datosMadre: persona;
		datosPadre : persona;
	end;
	
	acta = record
		nroPartida : integer;
		nombre : string;
		apellido : string;
		matriculaNacimiento : integer;
		datosDireccion : direccion;
		datosMadre: persona;
		datosPadre : persona;
		fallecio : boolean;
		matriculaFallecimiento : string;
		fecha : integer;
		hora : integer;
		lugar : string;
	end;


	archivo_maestro = file of acta;
	archivo_detalle_fallecidos = file of detalle_fallecido;
	archivo_detalle_nacimientos = file of detalle_nacimiento;

	vector_detalle_fallecidos = array [1..dimf] of archivo_detalle_fallecidos;
	vector_detalle_nacimientos = array [1..dimf] of archivo_detalle_nacimientos;
	
	vector_registro_detalle_fallecidos = array [1..dimf] of detalle_fallecido;
	vector_registro_detalle_nacimientos = array [1..dimf] of detalle_nacimiento;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro con ' , dimf*2  , ' detalles ( 2 por cada una de las ' , dimf , ' delegaciones )');
	writeln('2. Crear ' , dimf  , ' detalles de Fallecidos');
	writeln('3. Crear ' , dimf  , ' detalles de Nacimientos');
	writeln('4. Listar maestro');
	writeln('5. Listar ' , dimf  , ' detalles de Fallecidos');
	writeln('6. Listar ' , dimf  , ' detalles de Nacimientos');
	writeln('7. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure leerDireccion( var d:direccion );
begin
	with d do
	begin
		write('calle: ');
		readln(calle);
		write('numero: ');
		readln(nro);
		write('piso: ');
		readln(piso);
		write('departamento: ');
		readln(depto);
		write('ciudad: ');
		readln(ciudad);
	end;
end;

procedure leerPersona( var p:persona );
begin
	with p do
	begin
		write('nombre: ');
		readln(nombre);
		write('apellido: ');
		readln(apellido);
		write('DNI: ');
		readln(DNI);
	end;
end;

procedure imprimirDireccion( var d:direccion );
begin
	with d do
	begin
		writeln('calle: ' , calle);
		writeln('numero: ', nro);
		writeln('piso: ' , piso);
		writeln('departamento: ' , depto);
		writeln('ciudad: ' , ciudad);
	end;
end;

procedure imprimirPersona( var p:persona );
begin
	with p do
	begin
		writeln('nombre: ' , nombre);
		writeln('apellido: ' , apellido);
		writeln('DNI: ' , DNI);
	end;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leerFallecido( var archivo:archivo_detalle_fallecidos ; var dato:detalle_fallecido );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.nroPartida := valorAlto;
end;

procedure leerNacimiento( var archivo:archivo_detalle_nacimientos ; var dato:detalle_nacimiento );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.nroPartida := valorAlto;
end;

procedure minimoFallecido( var regMin:detalle_fallecido ; var vectorRF:vector_registro_detalle_fallecidos ; var vectorF:vector_detalle_fallecidos );
var
	i : integer;
	minPos : integer;
begin

	regMin.nroPartida := valorAlto;
	minPos := 0;

	for i := 1 to dimf do 
	begin
	
		if ( vectorRF[i].nroPartida < regMin.nroPartida ) then 
		begin
			regMin := vectorRF[i];
			minPos := i;
		end;
	
	end;
	
	if ( minPos <> 0 ) then
		leerFallecido( vectorF[minPos] , vectorRF[minPos] );

end;

procedure minimoNacimiento( var regMin:detalle_nacimiento ; var vectorRN:vector_registro_detalle_nacimientos ; var vectorN:vector_detalle_nacimientos );
var
	i : integer;
	minPos : integer;
begin

	regMin.nroPartida := valorAlto;
	minPos := 0;

	for i := 1 to dimf do 
	begin
	
		if ( vectorRN[i].nroPartida < regMin.nroPartida ) then 
		begin
			regMin := vectorRN[i];
			minPos := i;
		end;
	
	end;
	
	if ( minPos <> 0 ) then
		leerNacimiento( vectorN[minPos] , vectorRN[minPos] );

end;

procedure mergeMaestro( var maestro:archivo_maestro ; var vectorF:vector_detalle_fallecidos ; var vectorN:vector_detalle_nacimientos );
var
	vectorRF : vector_registro_detalle_fallecidos;
	vectorRN: vector_registro_detalle_nacimientos;
	minFallecido : detalle_fallecido;
	minNacido : detalle_nacimiento;
	regm : acta;
	i : integer;
begin


	{ crear maestro }
	rewrite( maestro );
	
	{ abrir y leer detalles }
	for i := 1 to dimf do
	begin
		reset( vectorF[i] );
		reset( vectorN[i] );
		read( vectorF[i] , vectorRF[i] );
		read( vectorN[i] , vectorRN[i] );
	end;
	
	{ obtener registros mas pequeños }
	minimoFallecido( minFallecido , vectorRF , vectorF );
	minimoNacimiento( minNacido , vectorRN , vectorN );
	
	
	while( minNacido.nroPartida <> valoralto ) do
	begin
	
		{ crear registro maestro }
		regm.nroPartida := minNacido.nroPartida;
		regm.nombre := minNacido.nombre; 
		regm.apellido := minNacido.apellido;
		regm.matriculaNacimiento := minNacido.matriculaNacimiento;	
		regm.datosDireccion := minNacido.datosDireccion;
		regm.datosMadre := minNacido.datosMadre;
		regm.datosPadre := minNacido.datosPadre;
		
		{ agregar datos adicionales si es que fallecio }
		if ( minNacido.nroPartida = minFallecido.nroPartida ) then
		begin
			regm.fallecio := true;
			regm.matriculaFallecimiento := minFallecido.matriculaFallecimiento;
			regm.fecha := minFallecido.fecha;
			regm.hora := minFallecido.hora;
			regm.lugar := minFallecido.lugar;
		end else
		begin
			regm.fallecio := false;
			regm.matriculaFallecimiento := '';
			regm.fecha := -1;
			regm.hora := -1;
			regm.lugar := '';
		end;

		{ agregar registro en el maestro }
		write( maestro , regm );
		
		{ continuar lectura }
		minimoNacimiento( minNacido , vectorRN , vectorN );
        if ( regm.fallecio ) then
			minimoFallecido( minFallecido , vectorRF , vectorF );

	end;

	
	{ cerrar maestro }
	close( maestro );
	
	{ cerrar detalles }
	for i := 1 to dimf do
	begin
		close( vectorF[i] );
		close( vectorN[i] );
	end;
	
	{ notificar exito... }
	writeln('actualizado con exito...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearDetalleFallecidos( var detalle:archivo_detalle_fallecidos );

	procedure leerActaFallecido( var f:detalle_fallecido );
	begin
		with f do
		begin
			writeln('-----------------------');
			write('numero de partida nacimiento: ');
			readln(nroPartida);
			if ( nroPartida <> -1 ) then 
			begin
			
				writeln('datos del fallecido:');
				leerPersona( datosFallecido );
				
				write('matricula de fallecimiento: ');
				readln(matriculaFallecimiento);
				write('fecha: ');
				readln(fecha);
				write('hora: ');
				readln(hora);
				write('lugar: ');
				readln(lugar);
			end;
		end;
	end;
	
var
	f : detalle_fallecido;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer la primera acta de fallecido }
	leerActaFallecido(f);
	
	while ( f.nroPartida <> -1 ) do 
	begin
	
		{ agregar acta al archivo detalle }
		write( detalle , f );
	
		{ leer la proxima acta de fallecido }
		leerActaFallecido(f);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;


procedure crearDetallesFallecidos( var vectorFallecidos:vector_detalle_fallecidos );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('=====================================');
		writeln(' CREANDO DETALLE DE FALLECIDOS NRO ' , i );
		crearDetalleFallecidos( vectorFallecidos[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearDetalleNacimientos( var detalle:archivo_detalle_nacimientos );

	procedure leerActaNacimiento( var n:detalle_nacimiento );
	begin
		with n do
		begin
			writeln('-----------------------');
			write('numero de partida nacimiento: ');
			readln(nroPartida);
			if ( nroPartida <> -1 ) then 
			begin
				write('nombre: ');
				readln(nombre);
				write('apellido: ');
				readln(apellido);
				write('matricula de nacimiento: ');
				readln(matriculaNacimiento);
				
				writeln('datos de la direccion: ');
				leerDireccion( datosDireccion );
				writeln('datos de la madre: ');
				leerPersona( datosMadre );
				writeln('datos del padre: ');
				leerPersona( datosPadre );
			end;
		end;
	end;
	
var
	n : detalle_nacimiento;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer la primera acta de nacimiento }
	leerActaNacimiento(n);
	
	while ( n.nroPartida <> -1 ) do 
	begin
	
		{ agregar acta al archivo detalle }
		write( detalle , n );
	
		{ leer la proxima acta de nacimiento }
		leerActaNacimiento(n);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;


procedure crearDetallesNacimientos( var vectorNacimientos:vector_detalle_nacimientos );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('=====================================');
		writeln(' CREANDO DETALLE DE NACIMIENTOS NRO ' , i );
		crearDetalleNacimientos( vectorNacimientos[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirActa( a:acta );
	begin
		with a do
		begin
			writeln('==================================');
			writeln('numero de partida nacimiento: ' , nroPartida);
			writeln('nombre: ' , nombre);
			writeln('apellido: ' , apellido);
			writeln('matricula de nacimiento: ' , matriculaNacimiento);
			writeln('-----------------------');
			writeln('datos de la direccion: ');
			imprimirDireccion( datosDireccion );
			writeln('-----------------------');
			writeln('datos de la madre: ');
			imprimirPersona( datosMadre );
			writeln('-----------------------');
			writeln('datos del padre: ');
			imprimirPersona( datosPadre );
			
			if ( fallecio ) then
			begin
				writeln('-----------------------');
				writeln('matricula de fallecimiento: ' , matriculaFallecimiento);
				writeln('fecha: ' , fecha);
				writeln('hora: ' , hora);
				writeln('lugar: ' , lugar);
			end;
		end;
	end;
	
var
	a : acta;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer acta del maestro }
		read( maestro , a );
		
		{ mostrar acta en consola }
		imprimirActa(a);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalleFallecidos( var detalle:archivo_detalle_fallecidos );

	procedure imprimirActaFallecido( f:detalle_fallecido );
	begin
		with f do
		begin
			
			writeln('==================================');
			writeln('numero de partida nacimiento: ' , nroPartida);
			writeln('datos del fallecido:');
			imprimirPersona( datosFallecido );
			writeln('-----------------------');
			writeln('matricula de fallecimiento: ' , matriculaFallecimiento);
			writeln('fecha: ' , fecha);
			writeln('hora: ' , hora);
			writeln('lugar: ' , lugar);
		end;
	end;
	
var
	f : detalle_fallecido;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer acta de fallecido del detalle }
		read( detalle , f );
		
		{ mostrar acta de nacimiento en consola }
		imprimirActaFallecido(f);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;

procedure mostrarDetallesFallecidos( var vectorFallecidos:vector_detalle_fallecidos );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' DETALLE FALLECIDOS NRO ' , i );
		mostrarDetalleFallecidos( vectorFallecidos[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalleNacimientos( var detalle:archivo_detalle_nacimientos );

	procedure imprimirActaNacimiento( n:detalle_nacimiento );
	begin
		with n do
		begin
			writeln('==================================');
			writeln('numero de partida nacimiento: ' , nroPartida);
			writeln('nombre: ' , nombre);
			writeln('apellido: ' , apellido);
			writeln('matricula de nacimiento: ' , matriculaNacimiento);
			writeln('-----------------------');
			writeln('datos de la direccion: ');
			imprimirDireccion( datosDireccion );
			writeln('-----------------------');
			writeln('datos de la madre: ');
			imprimirPersona( datosMadre );
			writeln('-----------------------');
			writeln('datos del padre: ');
			imprimirPersona( datosPadre );
		end;
	end;

var
	n : detalle_nacimiento;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer acta de nacimiento del detalle }
		read( detalle , n );
		
		{ mostrar acta de nacimiento en consola }
		imprimirActaNacimiento(n);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;

procedure mostrarDetalleSNacimientos( var vectorNacimientos:vector_detalle_nacimientos );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' DETALLE NACIMIENTOS NRO ' , i );
		mostrarDetalleNacimientos( vectorNacimientos[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }	
VAR
	maestro : archivo_maestro;
	vectorFallecidos : vector_detalle_fallecidos;
	vectorNacimientos : vector_detalle_nacimientos;
	opcion : integer;
	i : integer;
	iString : string;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	
	for i := 1 to dimf do
	begin
		str( i , iString );	
		assign( vectorFallecidos[i] , 'archivo_fallecidos_'+iString );
		assign( vectorNacimientos[i] , 'archivo_nacimientos_'+iString );
	end;

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: mergeMaestro( maestro , vectorFallecidos , vectorNacimientos ); // FALTA
			2: crearDetallesFallecidos( vectorFallecidos );
			3: crearDetallesNacimientos( vectorNacimientos );
			4: mostrarMaestro( maestro );
			5: mostrarDetallesFallecidos( vectorFallecidos );
			6: mostrarDetallesNacimientos( vectorNacimientos );
			7: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
