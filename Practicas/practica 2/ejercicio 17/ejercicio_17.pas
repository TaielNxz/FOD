{
	17. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
	diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
	de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
	nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
	por localidad, luego por municipio y luego por hospital.
	
	Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
	listado con el siguiente formato:


	==========================================================================
	Nombre: Localidad 1

		Nombre: Municipio 1
			Nombre Hospital 1:______ ; Cantidad de casos Hospital 1 ______
			Nombre Hospital 2:______ ; Cantidad de casos Hospital 2 ______
			……………………..
			Nombre Hospital N:______ ; Cantidad de casos Hospital N ______
		Cantidad de casos Municipio 1

		Nombre Municipio N
			Nombre Hospital 1:______ ; Cantidad de casos Hospital 1 ______
			Nombre Hospital 2:______ ; Cantidad de casos Hospital 2 ______
			……………………..
			Nombre Hospital N:______ ; Cantidad de casos Hospital N ______
		Cantidad de casos Municipio N
		
	Cantidad de casos Localidad 1:______
	==========================================================================
	
	.............. . .
	
	==========================================================================
	Nombre: Localidad N

		Nombre: Municipio 1
			Nombre Hospital 1:______ ; Cantidad de casos Hospital 1 ______
			Nombre Hospital 2:______ ; Cantidad de casos Hospital 2 ______
			……………………..
			Nombre Hospital N:______ ; Cantidad de casos Hospital N ______
		Cantidad de casos Municipio 1

		Nombre Municipio N
			Nombre Hospital 1:______ ; Cantidad de casos Hospital 1 ______
			Nombre Hospital 2:______ ; Cantidad de casos Hospital 2 ______
			……………………..
			Nombre Hospital N:______ ; Cantidad de casos Hospital N ______
		Cantidad de casos Municipio N
		
	Cantidad de casos Localidad N:______
	==========================================================================
	Cantidad de casos Totales en la Provincia:
	
	
	Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
	información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
	aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
	deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
	posibles.
	
	NOTA: El archivo debe recorrerse solo una vez.
}
program practica02_ejercicio17;
const
	valorAlto = 9999;
type
	
	hospital = record
		codigoLocalidad : integer;
		nombreLocalidad : string;
		codigoMunicipio : integer;
		nombreMunicipio : string;
		codigoHospital : integer;
		nombreHospital : string;
		fecha : integer;
		cantCasos : integer;
	end;

	archivo_maestro = file of hospital;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Mostrar informacion de hospitales y exportar municipios con menos de 1500 casos a un .txt');
	writeln('2. Exportar a archivo de texto');
	writeln('3. Crear archivo');
	writeln('4. Mostrar archivo');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var maestro:archivo_maestro ; var dato:hospital );
begin
	if ( not eof(maestro) ) then
		read( maestro , dato )
	else
		dato.codigoLocalidad := valorAlto;
end;

procedure informarYExportar( var maestro:archivo_maestro ; var texto:Text );
var
	regm : hospital;
	localidadActual, municipioActual, hospitalActual : integer;
	casosLocalidad, casosMunicipio, casosHospital, totalCasos : integer;
begin

	{ crear archivo de texto }
	rewrite( texto );

	{ abrir maestro }
	reset( maestro );
	
	{ leer primer registro del maestro }
	leer( maestro , regm );
	
	totalCasos := 0;
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( regm.codigoLocalidad <> valorAlto ) do begin
		
		
		localidadActual := regm.codigoLocalidad;
		writeln('==========================================================================');
		writeln('Localidad: ' , localidadActual );
		writeln;
		casosLocalidad := 0;
	
	
		{ recorrer registros de la misma localidad }
		while ( regm.codigoLocalidad = localidadActual ) do
		begin
		
		
			municipioActual := regm.codigoMunicipio;
			writeln('  ----------------------------------------------------------------------');
			writeln('  Municipio: ' , municipioActual );
			casosMunicipio := 0;
			
			
			{ recorrer registros del mismo municipio }
			while ( regm.codigoLocalidad = localidadActual ) and ( regm.codigoMunicipio = municipioActual ) do
			begin
			
			
				hospitalActual := regm.codigoHospital;					
				casosHospital := 0;
				
				
				{ recorrer registros del mismo hospital }
				while ( regm.codigoLocalidad = localidadActual ) and ( regm.codigoMunicipio = municipioActual ) and ( regm.codigoHospital = hospitalActual ) do
				begin

					{ contar todos los casos de un hospital }
					casosHospital := casosHospital + regm.cantCasos;
					
					{ leer proximo hospital del maestro }
					leer( maestro , regm );

				end;
				
				
				{ informar casos del hospital }
				writeln('  - Hospital: ' , hospitalActual , ' ; Cantidad de Casos: ' , casosHospital );
								
				{ acumular casos del municipio actual }
				casosMunicipio := casosMunicipio + casosHospital;
			
				
			end;
			
			
			{ informar casos del municipio }
			writeln('  Cantidad de casos del Municipio ' , municipioActual , ': ' , casosMunicipio );
			writeln('  ----------------------------------------------------------------------');
			writeln;
			
			{ acumular casos de la localidad actual }
			casosLocalidad := casosLocalidad + casosMunicipio;
			
			{ agregar municipios con menos de 1500 casos a un archivo de texto }
			if ( casosMunicipio < 1500 ) then
				writeln( texto , 'Localidad: ' , localidadActual , 'Municipio: ' , municipioActual , 'Cantidad de casos: ' , casosMunicipio );


		end;
		

		{ informar casos de la localidad  }
		writeln('Cantidad de casos de la localidad ' , localidadActual , ': ' , casosLocalidad );
		writeln('==========================================================================');
		writeln;
		
		{ acumular casos totales de la provincia }
		totalCasos := totalCasos + casosLocalidad;


	end;
	

	{ informar casos totales de la provincia }
	writeln('Cantidad de casos Totales en la Provincia: ' , totalCasos );
	
	{ cerrar archivos }
	close( texto );
	close( maestro );


end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerHospital( var h:hospital );
	begin
		with h do
		begin
			writeln('-----------------------');
			write('codigo de localidad: ');
			readln(codigoLocalidad);
			if ( codigoLocalidad <> -1 ) then 
			begin
				write('nombre de localidad: ');
				readln(nombreLocalidad);
				write('codigo de municipio: ');
				readln(codigoMunicipio);
				write('nombre de municipio: ');
				readln(nombreMunicipio);
				write('codigo de hospital: ');
				readln(codigoHospital);
				write('nombre de hospital: ');
				readln(nombreHospital);
				write('fecha: ');
				readln(fecha);
				write('cantidad de casos: ');
				readln(cantCasos);
			end;
		end;
	end;
	
var
	h : hospital;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer hospital }
	leerHospital(h);
	
	while ( h.codigoLocalidad <> -1 ) do 
	begin
	
		{ agregar hospital al archivo maestro }
		write( maestro , h );
	
		{ leer proximo hospital }
		leerHospital(h);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirHospital( h:hospital );
	begin
		with h do
		begin
			writeln('-----------------------');
			writeln('codigo de localidad: ' , codigoLocalidad);
			writeln('nombre de localidad: ' , nombreLocalidad);
			writeln('codigo de municipio: ' , codigoMunicipio);
			writeln('nombre de municipio: ' , nombreMunicipio);
			writeln('codigo de hospital: ' , codigoHospital);
			writeln('nombre de hospital: ' , nombreHospital);
			writeln('fecha: ' , fecha);
			writeln('cantidad de casos: ' , cantCasos);
		end;
	end;

var
	h : hospital;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer hospital del maestro }
		read( maestro , h );
		
		{ mostrar hospital en consola }
		imprimirHospital(h);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	assign( texto , 'archivo_texto.txt');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 8 ) do 
	begin
		menu( opcion );
		case opcion of
			1: informarYExportar( maestro , texto );
			3: crearMaestro( maestro );
			4: mostrarMaestro( maestro );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
