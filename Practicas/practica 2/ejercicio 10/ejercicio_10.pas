{

	10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
	empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
	división, número de empleado, categoría y cantidad de horas extras realizadas por el
	empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
	división y, por último, por número de empleado. Presentar en pantalla un listado con el
	siguiente formato:
	
	==========================================================
	Departamento
	==========================================================
	
	----------------------------------------------------------
	División
	
	Número de Empleado     Total de Hs.       Importe a cobrar
	..................     ............       ................

	Número de Empleado     Total de Hs.       Importe a cobrar
	..................     ............       ................

	Total de horas división:  ____
	Monto total por división: ____
	----------------------------------------------------------
	
	----------------------------------------------------------
	División
	.......................
	----------------------------------------------------------
	
	==========================================================
	Total horas departamento: ____
	Monto total departamento: ____
	==========================================================

	Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
	iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
	de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
	de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
	posición del valor coincidente con el número de categoría.
	
}

program practica02_ejercicio10;
const
	valorAlto = 'ZZZ';
	dimf = 15;
type

	empleado = record
		departamento : string;
		division : string;
		numero : integer;
		categoria : integer;
		horasExtras : integer;
	end;
	
	archivo_maestro = file of empleado;
	
	vector_montos = array [1..dimf] of real;
	
{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Contabilizar e Informar votos de las mesas electorales');
	writeln('2. Crear archivo de texto');
	writeln('3. Crear maestro');
	writeln('4. Mostrar maestro');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure crearVectorMontos( var texto:Text ; var montos:vector_montos  );
var
	categoria : integer;
	valorHoras : real;
begin

	{ abrir archivo de texto }
	reset( texto );
	
	while ( not eof(texto) ) do 
	begin
	
		{ leer categoria y velor del archivo de texto }
		readln( texto , categoria , valorHoras );
		
		{ cargar vector con los datos }
		montos[categoria] := valorHoras;
		
	end;
	
	{ cerrar archivo de texto }
	close( texto );
	
	{ notificar exito... }
	writeln('vector cargado con exito...');
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer( var maestro:archivo_maestro ; var dato:empleado );
begin
	if ( not eof(maestro) ) then
		read( maestro , dato )
	else
		dato.departamento := valorAlto;
end;

procedure informarHorasExtras( var maestro:archivo_maestro ; var montos:vector_montos );
var
	regm : empleado;
	horasGeneral, horasDepartamento, horasDivision, horasNumero : integer;
	montoGeneral, montoDepartamento, montoDivision, montoNumero : real;
	departamentoActual : string;
	divisionActual : string;
	numeroActual : integer;
begin

	{ abrir maestro }
	reset( maestro );

	{ leer primer empleado }
	leer( maestro , regm );
	
	horasGeneral := 0;
	montoGeneral := 0;
	
	while ( regm.departamento <> valorAlto ) do
	begin
	
		departamentoActual := regm.departamento;
		horasDepartamento := 0;
		montoDepartamento := 0;

		writeln('============================================================');
		writeln(' Departamento: ' , departamentoActual );
		writeln('============================================================');
	
		while ( departamentoActual = regm.departamento ) do
		begin
		
			divisionActual := regm.division;
			horasDivision := 0;
			montoDivision := 0;
			
			writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
			writeln(' Division: ' , divisionActual);
			writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
			
			while ( departamentoActual = regm.departamento ) and ( divisionActual = regm.division ) do
			begin

				numeroActual := regm.numero;
				horasNumero := 0;
				montoNumero := 0;

				while ( departamentoActual = regm.departamento ) and ( divisionActual = regm.division ) and ( numeroActual = regm.numero ) do
				begin
				
					{ sumar horas extras y montos }
					horasNumero := horasNumero + regm.horasExtras;
					montoNumero := montoNumero + ( montos[regm.categoria] * regm.horasExtras );
				
					{ leer proximo empleado }
					leer( maestro , regm );
				
				end;

				writeln();
				writeln(' Numero de Empleado   Total de Horas.     Importe a cobrar');
				writeln( numeroActual:11 , horasNumero:19 , montoNumero:24:2 );
				writeln();
				
				horasDivision := horasDivision + horasNumero;
				montoDivision := montoDivision + montoNumero;
				
			end;
		
			horasDepartamento := horasDepartamento + horasDivision;
			montoDepartamento := montoDepartamento + montoDivision;
			
		end;
		
		horasGeneral := horasGeneral + horasDepartamento;
		montoGeneral := montoGeneral + montoDepartamento;
		
		writeln('============================================================');
		writeln(' Total horas departamento:', horasDepartamento );
		writeln(' Monto total departamento:', montoDepartamento:0:2 );
		writeln('============================================================');
		writeln();
	
	end;

	writeln(' Total general horas: ' , horasGeneral );
	writeln(' Total general monto: ' , montoGeneral:0:2 );

	{ cerrar maestro }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearTexto( var texto:Text );
var
	i : integer;
	categoria : integer;
	valorHoras : real;
begin

	{ crear archivo de texto }
	rewrite( texto );
	
	for i := 1 to dimf do 
	begin
	
		{ ingresar datos de la categoria }
		writeln('----------------------------');
		writeln('numero de categoria: ' , i );
		categoria := i;
		write('valor de las horas extra: ');
		readln( valorHoras );
	
		{ ecribir en archivo de texto }
		writeln( texto , categoria , ' ' , valorHoras )
		
	end;
	
	{ cerrar archivo de texto }
	close( texto );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerEmpleado( var e:empleado );
	begin
		with e do
		begin
			writeln('-----------------------');
			write('nombre de departamento: ');
			readln(departamento);
			if ( departamento <> 'fin' ) then 
			begin
				write('nombre de division: ');
				readln(division);
				write('numero de empleado: ');
				readln(numero);
				write('numero de categoria ' , '(1..' , dimf , '): ' );
				readln(categoria);
				write('cantidad de horas extras: ');
				readln(horasExtras);
			end;
		end;
	end;
	
var
	e : empleado;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer empleado }
	leerEmpleado(e);
	
	while ( e.departamento <> 'fin' ) do 
	begin
	
		{ agregar mesa al archivo maestro }
		write( maestro , e );
	
		{ leer proximo empleado }
		leerEmpleado(e);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
		
	procedure imprimirEmpleado( e:empleado );
	begin
		with e do 
		begin
			writeln('------------------------');
			writeln('nombre de departamento: ', departamento);
			writeln('nombre de division: ', division);
			writeln('numero de empleado: ', numero);
			writeln('categoria: ', categoria);
			writeln('cantidad de horas extras: ', horasExtras);
		end;
	end;

var
	e : empleado;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer empleado del maestro }
		read( maestro , e );
		
		{ mostrar empleado en consola }
		imprimirEmpleado(e);
		
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
	montos : vector_montos;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');
	assign( texto , 'archivo_texto');
	
	{ cargar vector con los montos de cada categoria , SI NO EXISTE EL ARCHIVO DE TEXTO TIRA ERROR }
	crearVectorMontos( texto , montos );
	
	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 5 ) do 
	begin
		menu( opcion );
		case opcion of
			1: informarHorasExtras( maestro , montos );
			2: crearTexto( texto );
			3: crearMaestro( maestro );
			4: mostrarMaestro( maestro );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
