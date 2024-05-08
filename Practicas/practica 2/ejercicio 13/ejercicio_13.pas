{
	13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
	próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
	cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
	para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
	y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
	más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
	uno del maestro. Se pide realizar los módulos necesarios para:
	
		a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
		sin asiento disponible.
		
		b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
		tengan menos de una cantidad específica de asientos disponibles. La misma debe
		ser ingresada por teclado.
	
	NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}


program practica02_ejercicio13;
const
	valorAlto = 'ZZZZ';
type

	vuelo_maestro = record
		destino : string;
		fecha : integer;
		hora : integer;
		asientosDisponibles : integer;
	end;

	vuelo_detalle = record
		destino : string;
		fecha : integer;
		hora : integer;
		asientosComprados : integer;
	end;

	archivo_maestro = file of vuelo_maestro;
	archivo_detalle = file of vuelo_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar archivo maestro de Vuelos con 2 detalles');
	writeln('2. Generar una lista con aquellos vuelos que tengan menos de una cantidad especifica de asientos disponibles');
	writeln('3. Crear maestro');
	writeln('4. Crear detalle 1');
	writeln('5. Crear detalle 2');
	writeln('6. Mostrar maestro');
	writeln('7. Mostrar detalle 1');
	writeln('8. Mostrar detalle 2');
	writeln('9. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer ( var archivo:archivo_detalle ; var dato:vuelo_detalle );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.destino := valorAlto;
end;

procedure minimo( var regd1,regd2,regMin:vuelo_detalle ; var detalle1,detalle2:archivo_detalle );
begin
	if ( regd1.destino < regd2.destino ) or
	   (( regd1.destino = regd2.destino ) and ( regd1.fecha < regd2.fecha )) or
	   (( regd1.destino = regd2.destino ) and ( regd1.fecha = regd2.fecha ) and ( regd1.hora < regd2.hora )) then begin
		regMin:= regd1;
		leer( detalle1 , regd1 );
	end else begin
		regMin:= regd2;
		leer( detalle2 , regd2 );
	end;
end;

procedure actualizarMaestro( var maestro:archivo_maestro ; var detalle1:archivo_detalle ; var detalle2:archivo_detalle );
var
	regd1, regd2, regMin : vuelo_detalle;
	regm : vuelo_maestro;
	destinoActual : string;
	fechaActual : integer;
	horaActual : integer;
	totalAsientos : integer;
begin

	{ abrir archivos }
	reset( maestro );
	reset( detalle1 );
	reset( detalle2 );
	
	{ leer registros }
	leer( detalle1 , regd1 );
	leer( detalle2 , regd2 );

	{ buscar el registro con destino minimo }
	minimo( regd1 , regd2 , regMin , detalle1 , detalle2 );
	
	
	while( regMin.destino <> valorAlto ) do
	begin

		destinoActual := regMin.destino;
		
		{ recorremos todos los registros con el mismo destino }
		while ( regMin.destino = destinoActual ) do
		begin
		
			fechaActual := regMin.fecha;
		
			{ recorremos todos los registros con el mismo destino y fecha }
			while ( regMin.destino = destinoActual ) and ( regMin.fecha = fechaActual ) do
			begin

				horaActual := regMin.hora;
				totalAsientos := 0;
				
				{ recorremos todos los registros con el mismo destino, fecha y hora }
				while ( regMin.destino = destinoActual ) and ( regMin.fecha = fechaActual ) and ( regMin.hora = horaActual ) do
				begin
				
					{ recolectar todos los asientos }
					totalAsientos := totalAsientos + regMin.asientosComprados;
				
					{ leer proximo registro }
					minimo( regd1 , regd2 , regMin , detalle1 , detalle2 );
					
				end;
				
				{ buscar en el maestro el registro a modificar }
				read( maestro , regm );
				while ( regm.destino <> destinoActual ) or ( regm.fecha <> fechaActual ) or ( regm.hora <> horaActual ) do 
				begin
					read( maestro , regm );
				end;

				{ reubicar puntero }
				seek ( maestro , filePos(maestro)-1 );
				
				{ modificar archivo maestro }
				regm.asientosDisponibles := regm.asientosDisponibles - totalAsientos;
				write( maestro , regm );

			end;
		
		end;
	
	end;
	
	{ cerrar archivos }
	close( maestro );
	close( detalle1 );
	close( detalle2 );
	
	{ notificar exito... }
	writeln('actualizado con exito');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure generarLista( var maestro:archivo_maestro ; var texto:Text );
var
	maxCant : integer;
	regm : vuelo_maestro;
begin

	write('ingresar cantidad de asientos disponibles: ');
	readln( maxCant );
	
	{ abrir maestro }
	reset( maestro );
	
	{ crear archivo de texto }
	rewrite( texto );
	
	while ( not eof(maestro) ) do
	begin
		
		{ leer vuelo }
		read( maestro , regm );
		
		{ escribir en archivo de texto }
		with regm do 
		begin
			if ( asientosDisponibles < maxCant ) then 
			begin
				writeln( texto , 'destino: ' , destino , ', fecha: ' , fecha , ', hora: ' ,  hora , ', asientos disponibles: ' , asientosDisponibles  );
			end;
		end;

	end;
	
	{ cerrar archivos }
	close( maestro );
	close( texto );
	
	{ notificar exito... }
	writeln;
	writeln('se genero un archivo con los vuelos con cantidad de asientos menor a ' , maxCant );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerVueloMaestro( var v:vuelo_maestro );
	begin
		with v do
		begin
			writeln('-----------------------');
			write('destino del vuelo: ');
			readln(destino);
			if ( destino <> 'fin' ) then 
			begin
				write('fecha: ');
				readln(fecha);
				write('hora de salida: ');
				readln(hora);
				write('cantidad de asientos disponibles: ');
				readln(asientosDisponibles);
			end;
		end;
	end;
	
var
	v : vuelo_maestro;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer vuelo }
	leerVueloMaestro(v);
	
	while ( v.destino <> 'fin' ) do 
	begin
	
		{ agregar vuelo al archivo maestro }
		write( maestro , v );
	
		{ leer proximo vuelo }
		leerVueloMaestro(v);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                      OPCION 4 y 5                                                        }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerVueloDetalle( var v:vuelo_detalle );
	begin
		with v do
		begin
			writeln('-----------------------');
			write('destino del vuelo: ');
			readln(destino);
			if ( destino <> 'fin' ) then 
			begin
				write('fecha: ');
				readln(fecha);
				write('hora de salida: ');
				readln(hora);
				write('cantidad de asientos comprados: ');
				readln(asientosComprados);
			end;
		end;
	end;

var
	v : vuelo_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primer vuelo }
	leerVueloDetalle(v);
	
	while ( v.destino <> 'fin' ) do 
	begin
	
		{ agregar aceeso al archivo detalle }
		write( detalle , v );
	
		{ leer proximo vuelo }
		leerVueloDetalle(v);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirVueloMaestro( v:vuelo_maestro );
	begin
		with v do
		begin
			writeln('-----------------------');
			writeln('destino del vuelo: ' , destino);
			writeln('fecha: ' , fecha);
			writeln('hora: ' , hora);
			writeln('cantidad de asientos disponibles: ' , asientosDisponibles );
		end;
	end;

var
	v : vuelo_maestro;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer vuelo del maestro }
		read( maestro , v );
		
		{ mostrar vuelo en consola }
		imprimirVueloMaestro(v);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                     OPCION 7 y 8                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirVueloDetalle( v:vuelo_detalle );
	begin
		with v do
		begin
			writeln('-----------------------');
			writeln('destino del vuelo: ' , destino);
			writeln('fecha: ' , fecha);
			writeln('hora: ' , hora);
			writeln('cantidad de asientos comprados: ' , asientosComprados );
		end;
	end;
		
var
	v : vuelo_detalle;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer vuelo del detalle }
		read( detalle , v );
		
		{ mostrar vuelo en consola }
		imprimirVueloDetalle(v);
		
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
	texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	assign( detalle1 , 'archivo_detalle1');
	assign( detalle2 , 'archivo_detalle2');
	assign( texto , 'lista.txt' );

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 9 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarMaestro( maestro , detalle1 , detalle2 );
			2: generarLista( maestro , texto );
			3: crearMaestro( maestro );
			4: crearDetalle( detalle1 );
			5: crearDetalle( detalle2 );
			6: mostrarMaestro( maestro );
			7: mostrarDetalle( detalle1 );
			8: mostrarDetalle( detalle2 );
			9: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
