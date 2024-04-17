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
	writeln('1. Compactar archivo detalle ');
	writeln('2. Mostrar detalle');
	writeln('3. Mostrar maestro');
	writeln('4. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure leer( var archivo:archivo_empleados ; var dato:empleado );
begin

	if ( not EOF( archivo ) ) then
		read( archivo, dato )
	else
		dato.codigo := valorAlto;
	
end;

procedure imprimirEmpleado( e:empleado );
begin
	writeln('------------------');
	writeln('Codigo: ', e.codigo);
	writeln('Nombre: ', e.nombre);
	writeln('Monto: ', e.monto:3:1);
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
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
	
	{ leer detalle }
	leer( detalle , regd );
	
	{ recorrer todo el detalle }
	while ( regd.codigo <> valorAlto ) do
	begin
		
		montoTotal := 0;
		regActual := regd;

		{ recorrer todos los registros con el mismo codigo y sumar sus montos }
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
			
		{ se reubica el puntero en el maestro }	
		seek( maestro , filepos(maestro) );

		{ se actualiza el maestro }
		write( maestro , regm );
		
	end;
	
	{ cerrar ambos archivos }
	close( maestro );
	close( detalle );
	
end;
{ ======================================================================================================================== }
{                                                   OPCIONES 2 y 3                                                         }
{ ======================================================================================================================== }
procedure mostrarArchivo ( var archivo_binario:archivo_empleados );
var
	e : empleado;
begin

	{ abrir archivo }
	reset( archivo_binario );
	
	while ( not eof (archivo_binario) ) do begin
	
		{ leer archivo }
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
	
	{ variable para las opciones }
	opcion := 0;

	{ mostrar opciones hasta ingresar el 4... }
	while ( opcion <> 4 ) do 
	begin
	
		{ mostrar en consola un menu con opciones }
		menu( opcion );
		
		{ opciones... }
		case opcion of
			1: compactar( maestro , detalle );
			2: mostrarArchivo( detalle );
			3: mostrarArchivo( maestro );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;

	end;
	
END.
