{
	16. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
	de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
	modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
	información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
	detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
	Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
	detalles. Además se debe informar cuál fue la moto más vendida.
	
	NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
	ser recorrido sólo una vez y en forma simultánea con los detalles
}
program practica02_ejercicio16;
const
	valorAlto = 9999;
	dimf = 3; // 10
type
	
	moto = record
		codigo : integer;
		nombre : string;
		descripcion : string;
		modelo : string;
		marca : string;
		stock : integer;
	end;

	venta = record
		codigo : integer;
		precio : integer;
		fecha : integer;
	end;

	archivo_maestro = file of moto;
	archivo_detalle = file of venta;

	vector_detalle = array [1..dimf] of archivo_detalle;
	vector_registro_detalle = array [1..dimf] of venta;

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
procedure leer ( var archivo:archivo_detalle ; var dato:venta );
begin
	if ( not eof(archivo) ) then 
		read( archivo , dato )
	else 
		dato.codigo := valorAlto;
end;

procedure minimo( var regMin:venta ; var vectorRD:vector_registro_detalle ; var vectorD:vector_detalle );
var
	i : integer;
	minPos : integer;
begin

	regMin.codigo := valorAlto;
	minPos := 0;

	for i := 1 to dimf do 
	begin
	
		if ( vectorRD[i].codigo < regMin.codigo ) then 
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
	regMin : venta;
	regm, regMaxVentas : moto;
	i : integer;
	codigoActual, totalVendido, maxVentas : integer;
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
	
	maxVentas := -1;
			
	while ( regMin.codigo <> valorAlto ) do
	begin
		
		codigoActual := regMin.codigo;
		totalVendido := 0;
		
		while ( regMin.codigo = codigoActual ) do
		begin
		
			{ recoletar todas las ventas }
			totalVendido := totalVendido + 1;
			
			{ obtener proximo registro minimo }
			minimo( regMin , vectorRD , vectorD );

		end;

		{ buscar en el maestro el registro a modificar }
		read( maestro , regm );
		while ( regm.codigo <> codigoActual ) do begin
			read( maestro , regm );
		end;

		{ actualizar datos del registro maestro }		
		regm.stock := regm.stock - totalVendido;

		{ guardar registro con mayor cantidad de ventas }
		if ( totalVendido > maxVentas ) then
		begin
			maxVentas := totalVendido;
			regMaxVentas := regm;
		end;
		
		{ reubicar puntero }
		seek( maestro , filepos(maestro)-1 ) ;

		{ acutalizar registro del maestro }
		write( maestro , regm );
	
	end;
	
	{ informar moto mas vendida }
	with regMaxVentas do
	begin
		writeln('Moto mas vendida');
		writeln('codigo: ' , codigo , ' nombre: ' , nombre , ' descripcion: ' , descripcion , ' modelo: ' , modelo , ' marca: ' , marca , ' stock: ' , stock);
		writeln;
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

	procedure leerMoto( var m:moto );
	begin
		with m do
		begin
			writeln('-----------------------');
			write('codigo: ');
			readln(codigo);
			if ( codigo <> -1 ) then 
			begin
				write('nombre: ');
				readln(nombre);
				write('descripcion: ');
				readln(descripcion);
				write('modelo: ');
				readln(modelo);
				write('marca: ');
				readln(marca);
				write('stock: ');
				readln(stock);
			end;
		end;
	end;
	
var
	m : moto;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera moto }
	leerMoto(m);
	
	while ( m.codigo <> -1 ) do 
	begin
	
		{ agregar moto al archivo maestro }
		write( maestro , m );
	
		{ leer proxima moto }
		leerMoto(m);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearDetalle( var detalle:archivo_detalle );

	procedure leerVenta( var v:venta );
	begin
		with v do
		begin
			writeln('-----------------------');
			write('codigo: ');
			readln(codigo);
			if ( codigo <> -1 ) then 
			begin
				write('precio: ');
				readln(precio);
				write('fecha: ');
				readln(fecha);
			end;
		end;
	end;

var
	v : venta;
begin

	{ crear archivo }
	rewrite( detalle );
	
	{ leer la primera venta }
	leerVenta(v);
	
	while ( v.codigo <> -1 ) do 
	begin
	
		{ agregar venta al archivo detalle }
		write( detalle , v );
	
		{ leer proxima venta }
		leerVenta(v);
	
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

	procedure imprimirMoto( m:moto );
	begin
		with m do
		begin
			writeln('-----------------------');
			writeln('codigo: ' , codigo);
			writeln('nombre: ' , nombre);
			writeln('descripcion: ' , descripcion);
			writeln('modelo: ' , modelo);
			writeln('marca: ' , marca);
			writeln('stock: ' , stock);
		end;
	end;

var
	m : moto;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer moto del maestro }
		read( maestro , m );
		
		{ mostrar moto en consola }
		imprimirMoto(m);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure mostrarDetalle( var detalle:archivo_detalle );

	procedure imprimirVenta( v:venta );
	begin
		with v do
		begin
			writeln('-----------------------');
			writeln('codigo: ' , codigo);
			writeln('precio: ' , precio);
			writeln('fecha: ' , fecha);
		end;
	end;

var
	v : venta;
begin

	{ abrir archivo }
	reset( detalle );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(detalle) ) do begin
	
		{ leer venta del detalle }
		read( detalle , v );
		
		{ mostrar log en consola }
		imprimirVenta(v);
		
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
	while ( opcion <> 8 ) do 
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
