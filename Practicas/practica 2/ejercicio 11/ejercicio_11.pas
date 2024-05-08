{
	11. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
	de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
	realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
	idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
	por los siguientes criterios: año, mes, día e idUsuario.
	Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
	el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
	mostrado a continuación:
	
	===========================================================================
	Año: ___
	
		-------------------------------------------------------------------
		Mes: 1
		
			día 1
				idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1: ___
				idusuario N Tiempo total de acceso en el dia 1 mes 1: ___
			Tiempo total acceso dia 1 mes 1: ___
			
			día N
				idUsuario 1 Tiempo Total de acceso en el dia N mes 1: ___
				idusuario N Tiempo total de acceso en el dia N mes 1: ___
			Tiempo total acceso dia N mes 1: ___
			

		Total tiempo de acceso mes 1: ____
		-------------------------------------------------------------------
		
		-------------------------------------------------------------------
		Mes 12
		
			día 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12: ___
			idusuario N Tiempo total de acceso en el dia 1 mes 12: ___
			Tiempo total acceso dia 1 mes 12: ___
			
			día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 12: ___
			idusuario N Tiempo total de acceso en el dia N mes 12: ___
			Tiempo total acceso dia N mes 12: ___
			
		Total tiempo de acceso mes 12: ____
		-------------------------------------------------------------------
		
	Total tiempo de acceso año
	===========================================================================

	Se deberá tener en cuenta las siguientes aclaraciones:
		● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado
		● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año no encontrado”.
		● Debedefinir las estructuras de datos necesarias.
		● El recorrido del archivo debe realizarse una única vez procesando sólo la información necesaria.

}


program practica02_ejercicio11;
const
	valorAlto = 9999;
type
	
	acceso = record
		anio : integer;
		mes : integer;
		dia : integer;
		idUsuario : integer;
		tiempo : integer;
	end;
	
	archivo_maestro = file of acceso;


{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Informar accesos de los usuarios');
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
procedure leer( var maestro:archivo_maestro ; var dato:acceso );
begin
	if ( not eof(maestro) ) then
		read( maestro , dato )
	else
		dato.anio := valorAlto;
end;

procedure informarHorasExtras( var maestro:archivo_maestro );
var
	regm : acceso;
	anioActual , mesActual , diaActual , idActual : integer;
	horasAnio , horasMes , horasDia , horasID : integer;
begin

	{ abrir maestro }
	reset( maestro );

	{ leer primer empleado }
	leer( maestro , regm );

	while ( regm.anio <> valorAlto ) do
	begin
	
		horasAnio := 0;
		anioActual := regm.anio;
		
		writeln('===================================================================');
		writeln(' Anio: ' , anioActual);
		writeln('===================================================================');

		while ( anioActual = regm.anio ) do
		begin
		
			horasMes := 0;
			mesActual := regm.mes;
			
			writeln;
			writeln('-------------------------------------------------------------------');
			writeln('  Mes: ' , mesActual);
			writeln('-------------------------------------------------------------------');

			while ( anioActual = regm.anio ) and ( mesActual = regm.mes ) do
			begin
		
				horasDia := 0;
				diaActual := regm.dia;
				
				writeln;
				writeln('   dia: ' , diaActual );

				while ( anioActual = regm.anio ) and ( mesActual = regm.mes ) and ( diaActual = regm.dia ) do
				begin
				
					horasID := 0;
					idActual := regm.idUsuario;
			
					while ( anioActual = regm.anio ) and ( mesActual = regm.mes ) and ( diaActual = regm.dia ) and ( idActual = regm.idUsuario )  do
					begin
					
						{ sumar horas }
						horasID := horasID + regm.tiempo;
						
						{ leer proximo empleado  }
						leer( maestro , regm );
					
					end;
				
					horasDia := horasDia + horasID;
					
					writeln('   - idUsuario ' , idActual , ': Tiempo Total de acceso en el dia ' , diaActual , ' mes ' , mesActual , ': ' , horasID );
				
				end;
				
				horasMes := horasMes + horasID;
				
				writeln('   Tiempo total acceso dia '  , diaActual , ' mes ' , mesActual , ': ' , horasDia );
				writeln;
				
			end;
			
			horasAnio := horasAnio + horasMes;
			
			writeln;
			writeln('  Total tiempo de acceso mes ' , mesActual , ': ' , horasMes );
			writeln;
		
		end;

		writeln('======================================================================');
		writeln(' Total tiempo de acceso anio ' , anioActual , ': ' , horasAnio );
		writeln('======================================================================');
		
	end;

	{ cerrar maestro }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure crearMaestro( var maestro:archivo_maestro );

	procedure leerAcceso( var a:acceso );
	begin
		with a do
		begin
			writeln('-----------------------');
			write('anio: ');
			readln(anio);
			if ( anio <> -1 ) then 
			begin
				write('mes: ');
				readln(mes);
				write('dia: ');
				readln(dia);
				write('idUsuario: ');
				readln(idUsuario);
				write('tiempo de acceso: ');
				readln(tiempo);
			end;
		end;
	end;

var
	a : acceso;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primer aceeso }
	leerAcceso(a);
	
	while ( a.anio <> -1 ) do 
	begin
	
		{ agregar aceeso al archivo maestro }
		write( maestro , a );
	
		{ leer proximo aceeso }
		leerAcceso(a);
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure mostrarMaestro( var maestro:archivo_maestro );
		
	procedure imprimirAcceso( a:acceso );
	begin
		with a do 
		begin
			writeln('------------------------');
			writeln('anio: ', anio);
			writeln('mes: ', mes);
			writeln('dia: ', dia);
			writeln('idUsuario: ', idUsuario);
			writeln('tiempo de acceso: ', tiempo);
		end;
	end;

var
	a : acceso;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer aceeso del maestro }
		read( maestro , a );
		
		{ mostrar aceeso en consola }
		imprimirAcceso(a);
		
	end;
	
	{ cerrar archivo }
	close( maestro );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	maestro : archivo_maestro;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( maestro , 'archivo_maestro');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 4 ) do 
	begin
		menu( opcion );
		case opcion of
			1: informarHorasExtras( maestro );
			2: crearMaestro( maestro );
			3: mostrarMaestro( maestro );
			4: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
