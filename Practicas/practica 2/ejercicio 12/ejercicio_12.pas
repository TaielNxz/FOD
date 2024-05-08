{
	12. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
	mismo (información guardada acerca de los movimientos que ocurren en el server) que se
	encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
	nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
	servidor de correo genera un archivo con la siguiente información: nro_usuario,
	cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
	usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
	sabe que un usuario puede enviar cero, uno o más mails por día.

		a. Realice el procedimiento necesario para actualizar la información del log en un
		día particular. Defina las estructuras de datos que utilice su procedimiento.
		
		b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
		detalle de un día determinado:
			nro_usuario 1: cantidadMensajesEnviados
			nro_usuario 2: cantidadMensajesEnviados
			nro_usuario X: cantidadMensajesEnviados
			………
			nro_usuario X+n: cantidadMensajesEnviados
			
		Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
		existen en el sistema. Considere la implementación de esta opción de las
		siguientes maneras:
		
		i- Como un procedimiento separado del punto a).
		ii- En el mismo procedimiento de actualización del punto a). Qué cambios
		se requieren en el procedimiento del punto a) para realizar el informe en
		el mismo recorrido?
}


program practica02_ejercicio12;
const
	valorAlto = 9999;
type

	log_maestro = record
		nro_usuario : integer;
		nombreUsuario : string;
		nombre : string;
		apellido : string;
		cantMailEnviados : integer;
	end;
	
	log_detalle = record
		nro_usuario: integer;
		destino: string;
		mensaje: string;
	end;

	archivo_maestro = file of log_maestro;
	archivo_detalle = file of log_detalle;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Actualizar archivo maestro de Logs con un detalle');
	writeln('2. Exportar reporte en una archivo de texto');
	writeln('3. Actualizar maestro Y Exportar reporte en una archivo de texto');
	writeln('4. Crear maestro');
	writeln('5. Crear detalle');
	writeln('6. Mostrar maestro');
	writeln('7. Mostrar detalle');
	writeln('8. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var detalle:archivo_detalle ; var dato:log_detalle );
begin
	if ( not eof(detalle) ) then
		read( detalle , dato )
	else
		dato.nro_usuario := valorAlto;
end;


procedure actualizarLogMaestro( var maestro:archivo_maestro ; var detalle:archivo_detalle );
var
	regd : log_detalle;
	regm : log_maestro;
begin

	{ abrir archivos }
	reset( maestro );
	reset( detalle );
	
	{ leer registros }
	leer( detalle , regd );
	
	while ( regd.nro_usuario <> valorAlto ) do
	begin

		{ recorrer hasta encontrar el usuario a modificar }
		read( maestro , regm );
		while ( regd.nro_usuario <> regm.nro_usuario ) do
		begin
			read( maestro , regm );
		end;
		
		{ sumar la cantidad de mails de todos los logs del usuario }
		while ( regd.nro_usuario = regm.nro_usuario ) do 
		begin
		
			{ sumar todos los mails }
			regm.cantMailEnviados := regm.cantMailEnviados + 1;
			
			{ leer proximo registro }
			leer( detalle , regd );
			
		end;
		
		{ reubicar puntero }
		seek( maestro , filepos(maestro)-1 );
		
		{ agregar log actualizado en el archivo maestro }
		write( maestro , regm );
		
	end;

	{ cerrar archivos }
	close( maestro );
	close( detalle );

	{ notificar exito }
	writeln('se actualizo con exito...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure exportarReporteTxt( var maestro:archivo_maestro ; var texto:Text );
var
	regm : log_maestro;
begin

	{ abrir maestro }
	reset( maestro );
	
	{ crear archivo de texto }
	rewrite( texto );
	
	{ recorrer hasta terminar el archivo maestro }
	while ( not eof(maestro) ) do
	begin
		
		{ leer log der archivo maestro }
		read( maestro , regm );
	
		{ agregar log al registro de texto }
		with regm do
		begin
			writeln( texto , 'nro_usuario: ' , nro_usuario , ' cantidadMensajesEnviados: ' , cantMailEnviados );
		end;

	end;
	
	{ cerrar archivos }
	close( maestro );
	close( texto );
	
	{ notificar exito }
	writeln('se exporto con exito...');

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure actualizarYExportarLog( var maestro:archivo_maestro ; var detalle:archivo_detalle ; var texto:Text );
var
	regd : log_detalle;
	regm : log_maestro;
begin

	{ abrir archivos }
	reset( maestro );
	reset( detalle );
	
	{ crear archivo de texto }
	rewrite( texto );
	
	{ leer registros }
	leer( detalle , regd );
	
	while ( regd.nro_usuario <> valorAlto ) do
	begin

		{ recorrer hasta encontrar el usuario a modificar }
		read( maestro , regm );
		while ( regd.nro_usuario <> regm.nro_usuario ) do
		begin
			read( maestro , regm );
		end;
		
		{ sumar la cantidad de mails de todos los logs del usuario }
		while ( regd.nro_usuario = regm.nro_usuario ) do 
		begin
		
			{ sumar todos los mails }
			regm.cantMailEnviados := regm.cantMailEnviados + 1;
			
			{ leer proximo registro }
			leer( detalle , regd );
			
		end;
		
		{ agregar log al registro de texto }
		with regm do
		begin
			writeln( texto , 'nro_usuario: ' , nro_usuario , ' cantidadMensajesEnviados: ' , cantMailEnviados );
		end;
		
		{ reubicar puntero }
		seek( maestro , filepos(maestro)-1 );
		
		{ agregar log actualizado en el archivo maestro }
		write( maestro , regm );
		
	end;

	{ cerrar archivos }
	close( maestro );
	close( detalle );
	close( texto );

	{ notificar exito }
	writeln('tarea realizada con exito...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerLogMaestro( var l:log_maestro );
	begin
		with l do
		begin
			writeln('-----------------------');
			write('numero de usuario: ');
			readln(nro_usuario);
			if ( nro_usuario <> -1 ) then 
			begin
				write('nombre de usuario: ');
				readln(nombreUsuario);
				write('nombre: ');
				readln(nombre);
				write('apelldio: ');
				readln(apellido);
				write('cantidad de mails enviados: ');
				readln(cantMailEnviados);
			end;
		end;
	end;

var
	l : log_maestro;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer log }
	leerLogMaestro(l);
	
	while ( l.nro_usuario <> -1 ) do 
	begin
	
		{ agregar aceeso al archivo maestro }
		write( maestro , l );
	
		{ leer proximo log }
		leerLogMaestro(l);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerLogDetalle( var l:log_detalle );
	begin
		with l do
		begin
			writeln('-----------------------');
			write('numero de usuario: ');
			readln(nro_usuario);
			if ( nro_usuario <> -1 ) then 
			begin
				write('cuenta destino: ');
				readln(destino);
				write('mensaje: ');
				readln(mensaje);
			end;
		end;
	end;

var
	l : log_detalle;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primer log }
	leerLogDetalle(l);
	
	while ( l.nro_usuario <> -1 ) do 
	begin
	
		{ agregar aceeso al archivo detalle }
		write( detalle , l );
	
		{ leer proximo log }
		leerLogDetalle(l);
	
	end;
	
	{ cerrar archivo }
	close( detalle );

end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );

	procedure imprimirLogMaestro( l:log_maestro );
	begin
		with l do
		begin
			writeln('-----------------------');
			writeln('numero de usuario: ' , nro_usuario);
			writeln('nombre de usuario: ' , nombreUsuario);
			writeln('nombre: ' , nombre);
			writeln('apellido: ' , apellido);
			writeln('cantidad de mails enviados: ' , cantMailEnviados);
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
{                                                         OPCION 7                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirLogDetalle( l:log_detalle );
	begin
		with l do
		begin
			writeln('-----------------------');
			writeln('numero de usuario: ' , nro_usuario);
			writeln('cuenta destino: ' , destino);
			writeln('mensaje: ' , mensaje);
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
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	detalle : archivo_detalle;
	texto : Text;
	texto2 : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	assign( detalle , 'archivo_detalle');
	assign( texto , 'reporte.txt');
	assign( texto2 , 'reporte2.txt');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 8 ) do 
	begin
		menu( opcion );
		case opcion of
			1: actualizarLogMaestro( maestro , detalle );
			2: exportarReporteTxt( maestro , texto );
			3: actualizarYExportarLog( maestro , detalle , texto2 );
			4: crearMaestro( maestro );
			5: crearDetalle( detalle );
			6: mostrarMaestro( maestro );
			7: mostrarDetalle( detalle ) ;
			8: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
