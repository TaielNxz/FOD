{

	1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
	empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
	nombre y monto de la comisión. La información del archivo se encuentra ordenada por
	código de empleado y cada empleado puede aparecer más de una vez en el archivo de
	comisiones.
	
	Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
	consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
	única vez con el valor total de sus comisiones.
	
	NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
	recorrido una única vez.
	
}


program practica02_ejercicio01;
CONST
	valorAlto = 9999;
TYPE

	cadena20 = String[20];
	
	empleado = record
		codigo : integer;
	    nombre : cadena20;
		monto  : real;
	end;
	
	archivo_empleados = file of empleado;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln('========================================================================');
	writeln('1. Compactar archivo detalle');
	writeln('2. Crear archivo detalle');
	writeln('3. Mostrar detalle');
	writeln('4. Mostrar maestro');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var archivo:archivo_empleados ; var dato:empleado );
begin
	if ( not EOF( archivo ) ) then
		read( archivo, dato )
	else
		dato.codigo := valorAlto;
end;

procedure compactar( var maestro:archivo_empleados ; var detalle:archivo_empleados );
var
	regm : empleado;
	regd : empleado;
	regActual : empleado;
	montoTotal : real;
begin
	
	{ crear archivo maestro }
	rewrite( maestro );
	
	{ abrir archivo detalle }
	reset( detalle );
	
	{ leer primer registro }
	leer( detalle , regd );
	
	while ( regd.codigo <> valorAlto ) do
	begin
		
		montoTotal := 0;
		regActual := regd;

		{ sumar todos los montos que tengan el mismo codigo }
		while ( regActual.codigo = regd.codigo ) do
		begin
		
			{ sumar monto del registro acutal }
			montoTotal := montoTotal + regd.monto;
			
			{ leer proximo registro }
			leer( detalle , regd );

		end;

		{ crear registro maestro }
		regm.codigo := regActual.codigo;
		regm.nombre := regActual.nombre;
		regm.monto := montoTotal;

		{ se actualiza el maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_empleados );

	procedure leerEmpleado( var e:empleado );
	begin
		with e do
		begin
			writeln('-----------------');
			write('codigo: ');
			readln(codigo);
			if ( codigo <> -1 ) then 
			begin
				write('nombre: ');
				readln(nombre);
				write('monto: ');
				readln(monto);
			end;
		end;
	end;

var
	e : empleado;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer primer empleado }
	leerEmpleado( e );
	
	{ agregar nuevos empleados al archivo hasta que se ingrese el codigo -1 }
	while ( e.codigo <> -1 ) do 
	begin
		
		{ agregar empleado al archivo detalle }
		write( detalle , e );
		
		{ leer proximo empleado }
		leerEmpleado( e );
		
	end;
	
	{ cerrar archivo }
	close( detalle )

end;
{ ======================================================================================================================== }
{                                                   OPCIONES 3 y 4                                                         }
{ ======================================================================================================================== }
procedure mostrarArchivo( var archivo_binario:archivo_empleados );

	procedure imprimirEmpleado( e:empleado );
	begin
		writeln('------------------');
		writeln('Codigo: ', e.codigo);
		writeln('Nombre: ', e.nombre);
		writeln('Monto: ', e.monto:3:1);
	end;

var
	e : empleado;
begin

	{ abrir archivo }
	reset( archivo_binario );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof (archivo_binario) ) do begin
	
		{ leer empleado del archivo }
		read( archivo_binario , e );
		
		{ mostrar empleado en consola }
		imprimirEmpleado (e);
		
	end;
	
	{ cerrar archivo }
	close( archivo_binario );
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_empleados; 
	detalle : archivo_empleados;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'empleados_maestro' );
	assign( detalle , 'empleados_detalle' );
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 5 ) do 
	begin
		menu( opcion );
		case opcion of
			1: compactar( maestro , detalle );
			2: crearDetalle( detalle );
			3: mostrarArchivo( detalle );
			4: mostrarArchivo( maestro );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;

	end;
	
END.
