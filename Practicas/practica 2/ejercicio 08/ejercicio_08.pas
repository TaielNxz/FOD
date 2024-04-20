{
	8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
	los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
	cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
	mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
	cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
	por la empresa.
	
	El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
	mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
	
	Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
	compras. No es necesario que informe tales meses en el reporte.
}
program practica02_ejercicio08;
const
	valorAlto = 999;
type

	rangoMeses = 1..12;
	rangoDias = 1..31;

	venta = record
		cod_cliente : integer;
		nombre : string;
		apellido : string;
		anio : integer;
		mes : rangoMeses;
		dia : rangoDias;
		monto : real;
	end;
	
	archivo_maestro = file of venta;
	
	vectorMontos = array [rangoMeses] of real;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Informar montos recaudados por la empresa y sus clientes');
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
procedure datosCliente( c:venta ; montoTotalCliente:real ; montosMes:vectorMontos );
var
	i : integer;
begin
	with c do 
	begin
		writeln('=============================');
		writeln(' Codigo de Cliente: ', c.cod_cliente);
		writeln(' Nombre: ', c.nombre);
		writeln(' Apellido: ', c.apellido);
		writeln('- - - - - - - - - - - - - - -');
		writeln(' Monto por mes: ');
		for i:= 1 to 12 do 
			writeln(' mes ' , i , ': ' , montosMes[i]:0:2 );
		writeln(' Monto total: ', montoTotalCliente:0:2 );
		writeln('=============================');
		writeln;
	end;
end;

procedure leer( var archivo:archivo_maestro ; var dato:venta );
begin
	if ( not eof(archivo) ) then
		read( archivo , dato )
	else
		dato.cod_cliente := valorAlto;
end;

procedure informarMontos( var maestro:archivo_maestro );
var
	regm : venta;
	ventaActual : venta;
	montoTotalEmpresa : real;
	montoTotalCliente : real;
	montosMes : vectorMontos;
	i : integer;
begin

	{ abrir maestro }
	reset( maestro );
	
	{ obtener primera venta }
	leer( maestro , regm );
	
	montoTotalEmpresa := 0;
	
	while ( regm.cod_cliente <> valorAlto ) do
	begin
	
		ventaActual := regm;
		montoTotalCliente := 0;
		for i:= 1 to 12 do 
			montosMes[i]:= 0;
		
		{ buscar una venta con nuevo codigo de cliente }
		while( ventaActual.cod_cliente <> regm.cod_cliente ) do
			leer( maestro , regm );
	
		{ procesar todas las ventas que tengan el mismo codigo de cliente }
		while( regm.cod_cliente <> valorAlto ) and ( ventaActual.cod_cliente = regm.cod_cliente ) do 
		begin
		
			{ sumar monto total de las ventas del cliente actual }
			montoTotalCliente := montoTotalCliente + regm.monto;
			
			{ sumar monto de un mes especifico }
			montosMes[regm.mes]:= montosMes[regm.mes] + regm.monto;
			
			{ leer proxima venta }
			leer( maestro , regm );
			
		end;
		
		{ informar datos de las ventas del cliente }
		datosCliente( ventaActual , montoTotalCliente , montosMes );

		montoTotalEmpresa := montoTotalEmpresa + montoTotalCliente; 
	
	end;
	
	{ informar datos de las ventas de la empresa }
	writeln('Monto total de la empresa: ', montoTotalEmpresa:0:2 );
	
	{ cerrar maestro }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerVenta( var v:venta );
	begin
		with v do
		begin
			writeln('-----------------------');
			write('codigo de cliente: ');
			readln(cod_cliente);
			if ( cod_cliente <> -1 ) then 
			begin
				write('nombre: ');
				readln(nombre);
				write('apellido: ');
				readln(apellido);
				write('anio: ');
				readln(anio);
				write('mes: ');
				readln(mes);
				write('dia: ');
				readln(dia);
				write('monto: ');
				readln(monto);
			end;
		end;
	end;
	
var
	v : venta;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera venta }
	leerVenta(v);
	
	while ( v.cod_cliente <> -1 ) do 
	begin
	
		{ agregar venta al archivo maestro }
		write( maestro , v );
	
		{ leer proxima venta }
		leerVenta(v);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
	
	procedure imprimirVenta( v:venta );
	begin
		with v do 
		begin
			writeln('------------------------');
			writeln('codigo de cliente: ', cod_cliente);
			writeln('nombre: ', nombre);
			writeln('apellido: ', apellido);
			writeln('anio: ', anio);
			writeln('mes: ', mes);
			writeln('dia: ', dia);
			writeln('monto: ', monto:0:2 );
		end;
	end;

var
	v:venta;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer venta del maestro }
		read( maestro , v );
		
		{ mostrar venta en consola }
		imprimirVenta(v);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ============================================================================================= }
{                                      PROGRAMA PRINCIPAL                                       }
{ ============================================================================================= }
VAR
	maestro : archivo_maestro;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro' );
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 4 ) do 
	begin
		menu( opcion );
		case opcion of
			1: informarMontos( maestro );
			2: crearMaestro( maestro );
			3: mostrarMaestro( maestro );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;

END.
