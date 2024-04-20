{

	9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
	provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
	provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
	Presentar en pantalla un listado como se muestra a continuación:

	=========================================
	Código de Provincia
	-----------------------------------------
	Código de Localidad        Total de Votos
	...................	       ..............
	...................	       ..............
	
	Total de Votos Provincia: .....
	=========================================
	
	=========================================
	Código de Provincia
	-----------------------------------------
	Código de Localidad        Total de Votos
	...................	       ..............
	...................	       ..............

	Total de Votos Provincia: .....
	=========================================
	
	Total General de Votos: .....

	NOTA: La información está ordenada por código de provincia y código de localidad.
}


program practica02_ejercicio09;
const
	valorAlto = 9999;
type

	mesa = record
		cod_provincia : integer;
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
	writeln('1. Contabilizar e Informar votos de las mesas electorales');
	writeln('2. Crear maestro');
	writeln('3. Mostrar maestro');
	writeln('4. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var maestro:archivo_maestro ; var dato:mesa );
begin
	if ( not eof(maestro) ) then
		read( maestro , dato )
	else
		dato.cod_provincia := valorAlto;
end;

procedure informarVotos( var maestro:archivo_maestro );
var
	regm : mesa;
	provinciaActual, localidadActual : integer;
	totalVotos, totalProvincia, totalLocalidad : integer;
begin

	{ abrir maestro }
	reset( maestro );
	
	{ leer primera mesa }
	leer( maestro , regm );
	
	totalVotos := 0;
	
	{ sumar los votos de todas las provincias }
	while ( regm.cod_provincia <> valorAlto ) do
	begin
	
		provinciaActual := regm.cod_provincia;
		totalProvincia := 0;
		
		writeln('=========================================');
		writeln(' Codigo de Provincia: ' , provinciaActual );
		writeln('=========================================');
		
		{ sumar los votos de todas las 'localidades' de la 'provincia actual' }
		while ( provinciaActual = regm.cod_provincia ) do
		begin

			localidadActual := regm.cod_localidad;
			totalLocalidad := 0;
	
			{ sumar los votos de todas las 'mesas' de la 'localidad actual' }
			while ( provinciaActual = regm.cod_provincia ) and ( localidadActual = regm.cod_localidad ) do
			begin

				totalLocalidad := totalLocalidad + regm.cantVotos;

				leer( maestro , regm );
				
			end;
			
			writeln();
			writeln(' Codigo de Localidad       Total de Votos');
			writeln(' ' , localidadActual:10 , totalLocalidad:25 );

			totalProvincia := totalProvincia + totalLocalidad;

		end;
		
		writeln();
		writeln('=========================================');
		writeln(' Total de Votos Provincia: ' , totalProvincia);
		writeln('=========================================');
		writeln; writeln;
		
		totalVotos := totalVotos + totalProvincia;
	
	end;
	
	writeln(' Total General de Votos: ' , totalVotos);
	
	{ cerrar maestro }
	reset( maestro );
	
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
			write('codigo de provincia: ');
			readln(cod_provincia);
			if ( cod_provincia <> -1 ) then 
			begin
				write('codigo de localidad: ');
				readln(cod_localidad);
				write('numero de mesa: ');
				readln(numeroMesa);
				write('cantidad de votos: ');
				readln(cantVotos);
			end;
		end;
	end;
	
var
	m:mesa;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera mesa }
	leerMesa(m);
	
	while ( m.cod_provincia <> -1 ) do 
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
			writeln('codigo de provincia: ', cod_provincia);
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
	maestro : archivo_maestro;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 4 ) do 
	begin
		menu( opcion );
		case opcion of
			1: informarVotos( maestro );
			2: crearMaestro( maestro );
			3: mostrarMaestro( maestro );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
