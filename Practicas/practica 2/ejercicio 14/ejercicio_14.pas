{
	14. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
	carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
	como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
	de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
	agua, # viviendas sin sanitarios. 
	
	Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
	de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
	de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
	construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
	
	Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
	recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
	provincia y código de localidad. 
	
	Para la actualización del archivo maestro, se debe proceder de la siguiente manera: 
		● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
		● Idempara viviendas sin agua, sin gas y sin sanitarios.
		● Alasviviendas de chapa se le resta el valor recibido de viviendas construidas
		
	La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
	
	Realice las declaraciones necesarias, el programa principal y los procedimientos que
	requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
	chapa (las localidades pueden o no haber sido actualizadas).
}


program practica02_ejercicio14;
const
	valorAlto = 9999;
	dimf = 10;
type

	provincia_maestro = record
		codigoProvincia : integer;
		nombreProvincia : string;
		codigoLocalidad : integer;
		nombreLocalidad : string;
		cantChapa : integer;
		cantSinLuz : integer;
		cantSinGas : integer;
		cantSinAgua : integer;
		cantSinSanitario : integer;
	end;
	
	provincia_detalle = record
		codigoProvincia : integer;
		codigoLocalidad : integer;
		cantConstruidas : integer;
		cantConLuz : integer;
		cantConGas : integer;
		cantConAgua : integer;
		cantConSanitario : integer;
	end;

	archivo_maestro = file of provincia_maestro;
	archivo_detalle = file of provincia_detalle;

	vector_detalle = array [1..dimf] of archivo_detalle;
	vector_registro_detalle = array [1..dimf] of provincia_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar maestro con ' , dimf  , ' detalles');
	writeln('2. Crear maestro');
	writeln('3. Crear ' , dimf  , ' detalles');
	writeln('4. Mostrar maestro');
	writeln('5. Mostrar ' , dimf  , ' detalles');
	writeln('6. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer ( var archivo:archivo_detalle ; var dato:provincia_detalle );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.codigoProvincia := valorAlto;
end;

procedure minimo( var regMin:provincia_detalle ; var vectorRD:vector_registro_detalle ; var vectorD:vector_detalle );
var
	i : integer;
	minPos : integer;
begin

	regMin.codigoProvincia := valorAlto;
	minPos := 0;

	for i := 1 to dimf do 
	begin
	
		if ( vectorRD[i].codigoProvincia < regMin.codigoProvincia ) or 
		   (( vectorRD[i].codigoProvincia = regMin.codigoProvincia ) and ( vectorRD[i].codigoLocalidad < regMin.codigoLocalidad )) then 
		begin
			regMin := vectorRD[i];
			minPos := i;
		end;
	
	end;
	
	if ( minPos <> 0 ) then
		leer( vectorD[minPos] , vectorRD[minPos] );

end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var vectorD:vector_detalle );
var
	vectorRD : vector_registro_detalle;
	regMin : provincia_detalle;
	regm : provincia_maestro;
	i : integer;
	provinciaActual : integer;
	localidadActual : integer;
	totalConstruidas, totalConLuz, totalConGas, totalConAgua, totalConSanitario : integer;
begin

	{ abrir  maestro }
	reset( maestro );
	
	{ abrir y leer detalles }
	for i := 1 to dimf do
	begin
		reset( vectorD[i] );
		read( vectorD[i] , vectorRD[i] );
	end;
	
	{ obtener registro mas pequeño }
	minimo( regMin , vectorRD , vectorD );

	
	while ( regMin.codigoProvincia <> valorAlto ) do
	begin
		
		provinciaActual := regMin.codigoProvincia;
		
		while ( regMin.codigoProvincia = provinciaActual ) do
		begin
		
			localidadActual := regMin.codigoLocalidad;
			
			totalConstruidas := 0;
			totalConLuz := 0;
			totalConGas := 0;
			totalConAgua := 0;
			totalConSanitario := 0;
			
			while ( regMin.codigoProvincia = provinciaActual ) and ( regMin.codigoLocalidad = localidadActual ) do
			begin
			
				{ recoletar datos de la provincia actual }
				totalConstruidas := totalConstruidas + regMin.cantConstruidas;
				totalConLuz := totalConLuz + regMin.cantConLuz;
				totalConGas := totalConGas + regMin.cantConGas;
				totalConAgua := totalConAgua + regMin.cantConAgua;
				totalConSanitario := totalConSanitario + regMin.cantConSanitario;
			
				{ obtener proximo registro minimo }
				minimo( regMin , vectorRD , vectorD );
			
			end;
		
			{ buscar en el maestro el registro a modificar }
			read( maestro , regm );
			while ( regm.codigoProvincia <> provinciaActual ) and ( regm.codigoLocalidad <> localidadActual ) do begin
				read( maestro , regm );
			end;
			
			{ actualizar datos del registro maestro }		
			regm.cantChapa := regm.cantChapa - totalConstruidas;
			regm.cantSinLuz := regm.cantSinLuz - totalConLuz;
			regm.cantSinGas := regm.cantSinGas - totalConGas;
			regm.cantSinAgua := regm.cantSinAgua - totalConAgua;
			regm.cantSinSanitario := regm.cantSinSanitario - totalConSanitario;
			
			{ reubicar puntero }
			seek( maestro , filepos(maestro)-1 ) ;
			
			{ acutalizar registro del maestro }
			write( maestro , regm );
			
		end;
	
	end;


	{ cerrar archivos }
	close( maestro );
	for i := 1 to dimf do
		close( vectorD[i] );
		
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerProvinciaMaestro( var p:provincia_maestro );
	begin
		with p do
		begin
			writeln('-----------------------');
			write('codigo de provincia: ');
			readln(codigoProvincia);
			if ( codigoProvincia <> -1 ) then 
			begin
				write('nombre de provincia: ');
				readln(nombreProvincia);
				write('codigo de localidad: ');
				readln(codigoLocalidad);
				write('nombre de localidad: ');
				readln(nombreLocalidad);
				write('cantidad de viviendas de chapa: ');
				readln(cantChapa);
				write('cantidad de viviendas sin luz: ');
				readln(cantSinLuz);
				write('cantidad de viviendas sin gas: ');
				readln(cantSinGas);
				write('cantidad de viviendas sin agua: ');
				readln(cantSinAgua);
				write('cantidad de viviendas sin sanitario: ');
				readln(cantSinSanitario);	
			end;
		end;
	end;
	
var
	p : provincia_maestro;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera provincia }
	leerProvinciaMaestro(p);
	
	while ( p.codigoProvincia <> -1 ) do 
	begin
	
		{ agregar provincia al archivo maestro }
		write( maestro , p );
	
		{ leer proxima provincia }
		leerProvinciaMaestro(p);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerProvinciaDetalle( var p:provincia_detalle );
	begin
		with p do
		begin
			writeln('-----------------------');
			write('codigo de provincia: ');
			readln(codigoProvincia);
			if ( codigoProvincia <> -1 ) then 
			begin
				write('codigo de localidad: ');
				readln(codigoLocalidad);
				write('cantidad de viviendas construidas: ');
				readln(cantConstruidas);
				write('cantidad de viviendas con luz: ');
				readln(cantConLuz);
				write('cantidad de viviendas con gas: ');
				readln(cantConGas);
				write('cantidad de viviendas con aguas: ');
				readln(cantConAgua);	
				write('cantidad de viviendas con sanitario: ');
				readln(cantConSanitario);	
			end;
		end;
	end;

var
	p : provincia_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primera provincia }
	leerProvinciaDetalle(p);
	
	while ( p.codigoProvincia <> -1 ) do 
	begin
	
		{ agregar provincia al archivo detalle }
		write( detalle , p );
	
		{ leer proxima provincia }
		leerProvinciaDetalle(p);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;

procedure crearDetalles( var vectorD:vector_detalle );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' CREANDO DETALLE ' , i );
		crearDetalle ( vectorD[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirProvinciaMaestro( p:provincia_maestro );
	begin
		with p do
		begin
			writeln('-----------------------');
			writeln('codigo de provincia: ' , codigoProvincia);
			writeln('nombre de provincia: ' , nombreProvincia);
			writeln('codigo de localidad: ' , codigoLocalidad);
			writeln('nombre de localidad: ' , nombreLocalidad);
			writeln('cantidad de viviendas de chapa: ' , cantChapa);
			writeln('cantidad de viviendas sin luz: ' , cantSinLuz);
			writeln('cantidad de viviendas sin gas: ' , cantSinGas);
			writeln('cantidad de viviendas sin agua: ' , cantSinAgua);
			writeln('cantidad de viviendas sin sanitario: ' , cantSinSanitario);
		end;
	end;

var
	p : provincia_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer provincia del maestro }
		read( maestro , p );
		
		{ mostrar provincia en consola }
		imprimirProvinciaMaestro(p);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirProvinciaDetalle( p:provincia_detalle );
	begin
		with p do
		begin
			writeln('-----------------------');
			writeln('codigo de provincia: ' , codigoProvincia);
			writeln('codigo de localidad: ' , codigoLocalidad);
			writeln('cantidad de viviendas construidas: ' , cantConstruidas);
			writeln('cantidad de viviendas con luz: ' , cantConLuz);
			writeln('cantidad de viviendas con gas: ' , cantConGas);
			writeln('cantidad de viviendas con agua: ' , cantConAgua);
			writeln('cantidad de viviendas con sanitario: ' , cantConSanitario);
		end;
	end;

var
	p : provincia_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer provincia del detalle }
		read( detalle , p );
		
		{ mostrar log en consola }
		imprimirProvinciaDetalle(p);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;

procedure mostrarDetalles( var vectorD:vector_detalle );
var
	i : integer;
begin

	for i:= 1 to dimf do 
	begin
		writeln('==================================');
		writeln(' DETALLE ' , i );
		mostrarDetalle ( vectorD[i] );
		writeln;
	end;

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	vectorD : vector_detalle;
	opcion : integer;
	i : integer;
	iString : string;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	for i := 1 to dimf do
	begin
		str( i , iString );	
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
