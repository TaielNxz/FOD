{
	2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
	localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
	siguiente información: código de localidad, número de mesa y cantidad de votos en
	dicha mesa. Presentar en pantalla un listado como se muestra a continuación:

		Código de Localidad           Total de Votos
		...................           ..............
		...................    		  ..............
		Total General de Votos:    	  ..............

	NOTAS:

		● La información en el archivo no está ordenada por ningún criterio.
		● Trate deresolver el problema sin modificar el contenido del archivo dado.
		● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
		  llevar el control de las localidades que han sido procesadas.
}
program practica03_parte02_ejercicio02;
const
	valorAlto = 9999;
type

	mesa = record
		cod_localidad : integer;
		numeroMesa : integer;
		cantVotos : integer;
	end;

	archivo_maestro = file of mesa;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Mostrar informacion de los votos');
	writeln('2. Crear maestro');
	writeln('3. Listar maestro');
	writeln('4. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure imprimirArchivo( var archivoAux:archivo_maestro ; totalVotos:integer );
var
    m : mesa;
begin
	
	{ abrir archivo }
    reset( archivoAux );
    
    while ( not eof(archivoAux) ) do
	begin
		
		{ leer localidad }
		read( archivoAux , m );
		
		{ mostrar en consola }
		with m do
		begin
			writeln('--------------------------');
			writeln( 'Codigo de Localidad: ' , cod_localidad );
			writeln( 'Total de Votos: ' , cantVotos );
		end;

	end;
	writeln('--------------------------');
    writeln( 'Total General de Votos: ', totalVotos );
    
    { cerrar archivo }
    close( archivoAux );
    
end;

procedure crearAuxiliarEImprimir( var maestro:archivo_maestro ; var archivoAux:archivo_maestro );
var
	regm , aux : mesa;
	encontrado : boolean;
	totalVotos : integer;
begin

	{ abrir maestro }
	reset( maestro );
	
	{ crear archivo auxiliar }
	rewrite( archivoAux );
	
	totalVotos := 0;
	
	{ sumar los votos de todas las provincias }
	while ( not eof(maestro) ) do
	begin
	
		{ leer registro del maestro }
		read( maestro , regm );
		
		encontrado := false;
		
		seek( archivoAux , 0 );

		{ encontrar registro con el mismo codigo }
		while ( not eof(archivoAux) ) and ( not encontrado ) do
		begin
		
			read( archivoAux , aux );

			if ( aux.cod_localidad = regm.cod_localidad ) then
				encontrado := true;

		end;
		
		{ si se encontro lo modificamos y lo agregamos al archivo auxiliar }
		if ( encontrado ) then
		begin
		
			aux.cantVotos := aux.cantVotos + regm.cantVotos;
			
			seek( archivoAux , filepos(archivoAux)-1 );
			
			write( archivoAux , aux );
			
		{ si no se encontro entonces es un registro nuevo }
		end else
			write( archivoAux , regm );

		totalVotos := totalVotos + regm.cantVotos;

	end;

	{ cerrar archivos }
	close( maestro );
	close( archivoAux );
	
	{ notificar exito }
	writeln('se creo el archivo auxiliar con exito...');
	
	{ mostrar en consola }
	imprimirArchivo( archivoAux , totalVotos );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerMesa( var m:mesa );
	begin
		with m do
		begin
			writeln('-----------------------');
			write('codigo de localidad: ');
			readln(cod_localidad);
			if ( cod_localidad <> -1 ) then 
			begin
				write('numero de mesa: ');
				readln(numeroMesa);
				write('cantidad de votos: ');
				readln(cantVotos);
			end;
		end;
	end;
	
var
	m : mesa;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera mesa }
	leerMesa(m);
	
	while ( m.cod_localidad <> -1 ) do 
	begin
	
		{ agregar mesa al archivo maestro }
		write( maestro , m );
	
		{ leer proxima mesa }
		leerMesa(m);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
		
	procedure imprimirInfoMesa( m:mesa );
	begin
		with m do 
		begin
			writeln('------------------------');
			writeln('codigo de localidad: ', cod_localidad);
			writeln('numero de mesa: ', numeroMesa);
			writeln('cantidad de votos: ', cantVotos);
		end;
	end;

var
	m : mesa;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer mesa del maestro }
		read( maestro , m );
		
		{ mostrar mesa en consola }
		imprimirInfoMesa(m);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro , archivoAux : archivo_maestro;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'maestro');
	assign( archivoAux , 'auxiliar');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 4 ) do 
	begin
		menu( opcion );
		case opcion of
			1: crearAuxiliarEImprimir( maestro , archivoAux );
			2: crearMaestro( maestro );
			3: mostrarMaestro( maestro );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.

