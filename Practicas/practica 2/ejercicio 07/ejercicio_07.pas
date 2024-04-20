{
	7. Sedesea modelar la información necesaria para un sistema de recuentos de casos de covid
	para el ministerio de salud de la provincia de buenos aires.
	
	Diariamente se reciben archivos provenientes de los distintos municipios, la información
	contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
	casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
	fallecidos.
	
	El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
	nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
	nuevos, cantidad de recuperados y cantidad de fallecidos.
	
	Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
	recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
	localidad y código de cepa.
	
	Para la actualización se debe proceder de la siguiente manera: 
	
		1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
		2. Idem anterior para los recuperados.
		3. Los casos activos se actualizan con el valor recibido en el detalle.
		4. Idem anterior para los casos nuevos hallados.
		
	Realice las declaraciones necesarias, el programa principal y los procedimientos que
	requiera para la actualización solicitada e informe cantidad de localidades con más de 50
	casos activos (las localidades pueden o no haber sido actualizadas).

}
program practica02_ejercicio07;
const
	valorAlto = 9999;
	dimf = 3;
type

	localidad_maestro = record
		codlocalidad : integer;
		nombreLocalidad : string[20];
		codCepa : integer;
		cantActivos : integer;
		cantNuevos : integer;
		cantRecuperados : integer;
		cantFallecidos : integer;
	end;
	
	localidad_detalle = record
		codlocalidad : integer;
		codCepa : integer;
		cantActivos : integer;
		cantNuevos : integer;
		cantRecuperados : integer;
		cantFallecidos : integer;
	end;
	
	archivo_maestro = file of localidad_maestro;
	archivo_detalle = file of localidad_detalle;
	
	vector_detalle = array [1..dimf] of archivo_detalle;
	vector_registro_detalle = array [1..dimf] of localidad_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro con ' , dimf , ' detalles');
	writeln('2. Crear maestro');
	writeln('3. Crear detalles');
	writeln('4. Mostrar maestro');
	writeln('5. Mostrar detalles');
	writeln('6. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_detalle ; var dato:localidad_detalle );
begin
	if ( not eof(archivo) ) then
		read( archivo , dato )
	else
		dato.codLocalidad := valorAlto;
end;

procedure minimo( var vectorRD:vector_registro_detalle ; var regMin:localidad_detalle ; var vectorD:vector_detalle );
var
	posMin : integer;
	i : integer;
begin

	regMin.codLocalidad := valorAlto;
	regMin.codCepa := valorAlto;
	
	{ recorro todo todos los detalles }
	for i:= 1 to dimF do
	begin
		
		{ guardo el registro con codigo de localidad y codigo de cepa mas pequeños }
		if ( vectorRD[i].codLocalidad < regMin.codLocalidad  ) and ( vectorRD[i].codCepa < regMin.codCepa ) then
		begin
			posMin := i;
			regMin := vectorRD[i];
		end;
		
	end;
	
	if ( regMin.codLocalidad <> valorAlto ) then
		leer( vectorD[posMin] , vectorRD[posMin] );

end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var vectorD:vector_detalle );
var
	regm : localidad_maestro;
	regMin : localidad_detalle;
	vectorRD : vector_registro_detalle;
	i : integer;
begin

	{ abrir archivos maestro }
	reset( maestro );
	
	{ abrir y leer archivos detalles }
	for i:=1 to dimF do begin
		reset( vectorD[i] );
		read( vectorD[i] , vectorRD[i] );
	end;
	
	{ buscar el registro minimo en el vector }
	minimo( vectorRD , regMin , vectorD );
	
	{ cuando se llegue al final del archivo se retornara un valorAlto y se cancelará el bucle }
	while ( regMin.codLocalidad <> valorAlto ) do
	begin
		
		{ recorrer maestro hasta encontrar el registro detalle }
		read( maestro , regm );
		while ( regm.codlocalidad <> regMin.codlocalidad ) do
			read( maestro , regm );
		
		{ recorrer todos los archivos con el mismo codigo }
		while( regm.codlocalidad = regMin.codlocalidad ) and ( regm.codCepa = regMin.codCepa ) do
		begin
		
			{ modificar datos del maestro }
			regm.cantFallecidos := regm.cantFallecidos + regMin.cantFallecidos;
			regm.cantRecuperados := regm.cantRecuperados + regMin.cantRecuperados;
			regm.cantActivos := regMin.cantActivos;
			regm.cantNuevos := regMin.cantNuevos;
			
			{ leer proximo registro }
			minimo( vectorRD , regMin , vectorD );
			
		end;
		
		{ reubicar puntero }
		seek ( maestro, filepos(maestro)-1 );
			
		{ actualizar archivo maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrar archivo maestro }
	close( maestro );
	
	{ cerrar archivos detalle }
	for i:=1 to dimF do
		close( vectorD[i] );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerLocalidadMaestro( var l:localidad_maestro );
	begin
		with l do
		begin
			writeln('-----------------');
			write('codigo de localidad: ');
			readln(codlocalidad);
			if ( codlocalidad <> -1 ) then 
			begin
				write('nombre de localidad: ');
				readln(nombreLocalidad);
				write('codigo de cepa: ');
				readln(codCepa);
				write('cantidad de casos activos: ');
				readln(cantActivos);
				write('cantidad de casos nuevos: ');
				readln(cantNuevos);
				write('cantidad de recuperados: ');
				readln(cantRecuperados);
				write('cantidad de fallecidos: ');
				readln(cantFallecidos);
			end;
		end;
	end;
	
var
	l : localidad_maestro;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera localidad }
	leerLocalidadMaestro(l);
	
	while ( l.codLocalidad <> -1 ) do 
	begin
	
		{ agregar localidad al archivo maestro }
		write( maestro , l );
	
		{ leer proxima localidad }
		leerLocalidadMaestro(l);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerLocalidadDetalle( var l:localidad_detalle );
	begin
		with l do
		begin
			writeln('-----------------');
			write('codigo de localidad: ');
			readln(codlocalidad);
			if ( codlocalidad <> -1 ) then 
			begin
				write('codigo de cepa: ');
				readln(codCepa);
				write('cantidad de casos activos: ');
				readln(cantActivos);
				write('cantidad de casos nuevos: ');
				readln(cantNuevos);
				write('cantidad de recuperados: ');
				readln(cantRecuperados);
				write('cantidad de fallecidos: ');
				readln(cantFallecidos);
			end;
		end;
	end;
	
var
	l : localidad_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primera localidad }
	leerLocalidadDetalle(l);
	
	{ agregar nuevas localidades al archivo hasta que se ingrese el codigo -1 }
	while ( l.codLocalidad <> -1 ) do 
	begin
	
		{ agregar localidad al archivo detalle }
		read( detalle , l );
	
		{ leer proxima localidad }
		leerLocalidadDetalle(l);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;

procedure crearDetalles( var vectorD:vector_detalle );
var
	i : integer;
	iString : String;
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
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
	
	procedure imprimirLocalidadMaestro( l:localidad_maestro );
	begin
		with l do 
		begin
			writeln('------------------');
			writeln('codigo de localidad: ', codlocalidad);
			writeln('codigo de cepa: ', codCepa);
			writeln('cantidad de casos activos: ', cantActivos);
			writeln('cantidad de casos nuevos: ', cantNuevos);
			writeln('cantidad de recuperados: ', cantRecuperados);
			writeln('cantidad de fallecidos: ', cantFallecidos);
		end;
	end;

var
	l : localidad_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer localidad del maestro }
		read( maestro , l );
		
		{ mostrar localidad en consola }
		imprimirLocalidadMaestro(l);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );
	
	procedure imprimirLocalidadDetalle( l:localidad_detalle );
	begin
		with l do 
		begin
			writeln('------------------');
			writeln('codigo de localidad: ', codlocalidad);
			writeln('codigo de cepa: ', codCepa);
			writeln('cantidad de casos activos: ', cantActivos);
			writeln('cantidad de casos nuevos: ', cantNuevos);
			writeln('cantidad de recuperados: ', cantRecuperados);
			writeln('cantidad de fallecidos: ', cantFallecidos);
		end;
	end;

var
	l : localidad_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer localidad del maestro }
		read( detalle , l );
		
		{ mostrar localidad en consola }
		imprimirLocalidadDetalle(l);
		
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
	while ( opcion <> 6 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , vectorD );
			2: crearMaestro( maestro );
			3: crearDetalles( vectorD );
			4: mostrarMaestro( maestro );
			5: mostrarDetalles( vectorD );
			6: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
END.
