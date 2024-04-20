{
	4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
	archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
	alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
	agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
	localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
	necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
	
	NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
	pueden venir 0, 1 ó más registros por cada provincia.
}


program practica02_ejercicio04;
const
	valorAlto = 'ZZZ';
type

	cadena20 = string[20];
	
	encuesta_maestro = record
		provincia : cadena20;
		alfabetizadas : integer;
		encuestados : integer
	end;
	
	encuesta_detalle = record
		provincia : cadena20;
		codigo : integer;
		alfabetizadas : integer;
		encuestados : integer
	end;
	
	archivo_maestro = file of encuesta_maestro;
	archivo_detalle = file of encuesta_detalle;
	
{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar Maestro con 2 Detalles');
	writeln('2. Crear maestro');
	writeln('3. Crear detalle 1');
	writeln('4. Crear detalle 2');
	writeln('5. Mostrar maestro');
	writeln('6. Mostrar detalle 1');
	writeln('7. Mostrar detalle 2');
	writeln('8. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_detalle ; var dato:encuesta_detalle );
begin
	if ( not EOF(archivo) ) then 
		read( archivo , dato )
	else 
		dato.provincia := valorAlto;
end;

procedure minimo( var regd1,regd2,regMin:encuesta_detalle ; var detalle1,detalle2:archivo_detalle );
begin

	if ( regd1.provincia < regd2.provincia ) then
	begin
		regMin := regd1;
		leer( detalle1 , regd1 );
	end else begin
		regMin := regd2;
		leer( detalle2 , regd2 );
	end;
		
end;
	
procedure actualizarMaestro( var maestro:archivo_maestro ; var detalle1:archivo_detalle ; var detalle2:archivo_detalle );
var
	regm : encuesta_maestro;
	regd1 : encuesta_detalle;
	regd2 : encuesta_detalle;
	regMin : encuesta_detalle;
begin
	
	{ abrir archivos }
	reset( maestro );
	reset( detalle1 );
	reset( detalle2 );
	
	{ leer archivos }
	leer( detalle1 , regd1 );
	leer( detalle2 , regd2 );
	
	{ buscar el registro minimo entre los 2 detalles }
	minimo( regd1 , regd2 , regMin , detalle1 , detalle2 );
	

	while ( regMin.provincia <> valorAlto ) do
	begin
	
		{ recorrer maestro hasta encontrar el registro a modificar }
		read( maestro , regm );
		while ( regm.provincia <> regMin.provincia ) do
			read( maestro , regm );
			
		{ actualizar registro maestro con todos los detalles correspondientes a la provincia }
		while( regm.provincia = regMin.provincia ) do
		begin
		
			{ modificar datos del registro maestro }
			regm.alfabetizadas := regm.alfabetizadas + regMin.alfabetizadas;
			regm.encuestados := regm.encuestados + regMin.encuestados;
			
			{ leer proximo registro }
			minimo( regd1 , regd2 , regMin , detalle1 , detalle2 );
			
		end;
		
		{ reubicar puntero del maestro }
		seek( maestro , filepos(maestro)-1 );
	
		{ actualizar archivo maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrer archivos }
	reset( maestro );
	reset( detalle1 );
	reset( detalle2 );
	
	writeln('Actualizado con exito');

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerEncuestaMaestro( var e:encuesta_maestro );
	begin
		with e do
		begin
			writeln('-----------------');
			write('nombre de provincia: ');
			readln(provincia);
			if ( provincia <> 'fin' ) then 
			begin
				write('cantidad de personas alfabetizadas: ');
				readln(alfabetizadas);
				write('cantidad de personas encuestadas: ');
				readln(encuestados);
			end;
		end;
	end;

var
	e : encuesta_maestro;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera encuesta }
	leerEncuestaMaestro( e );
	
	{ leer encuestas hasta que se ingrese 'fin' }
	while ( e.provincia <> 'fin' ) do 
	begin
		
		{ agregar encuesta al archivo maestro }
		write( maestro , e );
		
		{ leer proxima encuesta }
		leerEncuestaMaestro( e );
		
	end;
	
	{ cerrar archivo }
	close( maestro )

end;
{ ======================================================================================================================== }
{                                                     OPCION 3 y 4                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerEncuestaDetalle( var e:encuesta_detalle );
	begin
		with e do
		begin
			writeln('-----------------');
			write('nombre de provincia: ');
			readln(provincia);
			if ( provincia <> 'fin' ) then 
			begin
				write('codigo de localidad: ');
				readln(codigo);
				write('cantidad de personas alfabetizadas: ');
				readln(alfabetizadas);
				write('cantidad de personas encuestadas: ');
				readln(encuestados);
			end;
		end;
	end;

var
	e : encuesta_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primera encuesta }
	leerEncuestaDetalle( e );
	
	{ leer encuestas hasta que se ingrese 'fin' }
	while ( e.provincia <> 'fin' ) do 
	begin
		
		{ agregar encuesta al archivo detalle }
		write( detalle , e );
		
		{ leer proxima encuesta }
		leerEncuestaDetalle( e );
		
	end;
	
	{ cerrar archivo }
	close( detalle )

end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirEncuestaMaestro( e:encuesta_maestro );
	begin
		with e do 
		begin
			writeln('------------------');
			writeln('nombre de provincia: ' , provincia);
			writeln('cantidad de personas alfabetizadas: ' , alfabetizadas);
			writeln('cantidad de personas encuestadas: ' , encuestados );
		end;
	end;

var
	e : encuesta_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer encuesta del archivo maestro }
		read( maestro , e );
		
		{ imprimir encuesta en la consola }
		imprimirEncuestaMaestro(e);
		
	end;
	
	{ cerrar archivo maestro }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                     OPCION 6 y 7                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirEncuestaDetalle( e:encuesta_detalle );
	begin
		with e do 
		begin
			writeln('------------------');
			writeln('nombre de provincia: ' , provincia);
			writeln('codigo de localidad: ' , codigo);
			writeln('cantidad de personas alfabetizadas: ' , alfabetizadas);
			writeln('cantidad de personas encuestadas: ' , encuestados );
		end;
	end;

var
	e : encuesta_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer encuesta del detalle }
		read( detalle , e );
		
		{ imprimir encuesta en la consola }
		imprimirEncuestaDetalle(e);
		
	end;
	
	{ cerrar archivo }
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	detalle1 : archivo_detalle;
	detalle2 : archivo_detalle;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro' );
	assign( detalle1 , 'archivo_detalle1' );
	assign( detalle2 , 'archivo_detalle2' );

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 8 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , detalle1 , detalle2 );
			2: crearMaestro( maestro );
			3: crearDetalle( detalle1 );
			4: crearDetalle( detalle2 );
			5: mostrarMaestro( maestro );
			6: mostrarDetalle( detalle1 );
			7: mostrarDetalle( detalle2 );
			8: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;

END.
