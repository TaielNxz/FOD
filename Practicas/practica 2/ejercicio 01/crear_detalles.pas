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
program practica02_ejercicio01_crear_detalles;
TYPE

	cadena20 = String[20];

	empleado = record
		codigo : integer;
	    nombre : cadena20;
		monto  : real;
	end;

	archivo_empleados = file of empleado;


procedure datosEmpleado( var cod:integer ; var nom:string );
begin
	writeln;
	writeln('NUEVO EMPLEADO ( para finalizar la carga ingrese -1 ) ');
	writeln('- - - - - - - - - - - - - - - - - - ');
	write('codigo: ');
	readln( cod );
	if ( cod <> -1 ) then begin
		write('nombre: ');
		readln( nom );
	end;
end;


procedure leerEmpleado( var e:empleado ; cod:integer ; nom:string );
begin
	with e do 
	begin
		writeln('-----------------------');
		
		codigo := cod;
		writeln('codigo: ' , codigo );
		
		nombre := nom;
		writeln('nombre: ' , nombre );

		write('monto: ');
		readln( monto );	
	end;
end;


procedure crearDetalleDeEmpleados( var detalle:archivo_empleados );
var
	e : empleado;
	codigoActual : integer;
	nombreActual : string;
	monto : integer;
begin

	codigoActual := 999;

	{ crear archivo }
	rewrite( detalle );

	{ ingresar y escribir numeros hasta que se ingrese un 0 }
	while ( codigoActual <> -1 ) do 
	begin
		
		monto := 999;
		
		datosEmpleado( codigoActual , nombreActual );
		
		{ escribir registros con el codigo actual }
		while ( codigoActual <> -1 ) and ( monto <> -1 ) do begin
		
			{ leer proximo empleado }
			leerEmpleado( e , codigoActual , nombreActual );
			
			{ si no se cancelo la carga, escribe en el archivo }
			if ( e.monto <> -1 ) then
				write( detalle , e )
			else
				monto := -1;

		end;
		
	end;
	
	{ cerrar archivo }
	close( detalle ); 
	
end;

VAR
	detalle : archivo_empleados;
BEGIN

	{ asignar espacio fisico }
	assign( detalle , 'empleados_detalle' );

	writeln('creando detalle de empleados');
	writeln;

	{ crear archivo binario }
	crearDetalleDeEmpleados( detalle );

END.
