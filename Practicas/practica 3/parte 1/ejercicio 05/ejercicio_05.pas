{
	
	5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:

	// Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente
	procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);

}
program practica03_ejercicio05;
const
	valorAlto = 9999;
type
	reg_flor = record
		nombre : String[45];
		codigo : integer;
	end;
	
	tArchFlores = file of reg_flor;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Crear archivo de flores');
	writeln('2. Listar archivo de flores');
	writeln('3. Dar de alta una flor');
	writeln('4. Dar de baja una flor');
	writeln('5. Eliminar una flor ingresada');
	writeln('6. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure leer ( var archivo_logico:tArchFlores ; var dato:reg_flor );
begin
	if ( not eof (archivo_logico) ) then
		read ( archivo_logico , dato )
	else
		dato.codigo := valorAlto;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leerFlor( var f:reg_flor );
begin

	with f do
	begin
		writeln('-----------------------');
		write('codigo: ');
		readln( codigo );
		if ( codigo <> -1 ) then
		begin
			write('nombre: ');
			readln( nombre );
		end;
	end;
	
end;

procedure crearArchivo( var archivo_logico:tArchFlores );
var
	f : reg_flor;
begin

	{ crear archivo }
	rewrite( archivo_logico );

	{ agregar cabecera de la lista }
	f.codigo := 0;
	write( archivo_logico , f );
	
	{ leer primera flor }
	leerFlor( f );
	
	while ( f.codigo <> -1 ) do
	begin
	
		{ agregar flor al archivo }
		write( archivo_logico , f );
	
		{ leer proxima flor }
		leerFlor( f );
	
	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure imprimirFlor( f:reg_flor );
begin

	with f do
	begin
		writeln('-----------------------');
		writeln('codigo:' , codigo );
		writeln('nombre:' , nombre );
	end;
	
end;


procedure listarFlores( var archivo_logico:tArchFlores );
var
	f : reg_flor;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ reubicarse en la posicion 1 , ya que en la 0 esta el registro cabecera }
	seek( archivo_logico , 1 );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo_logico) ) do begin
	
		{ leer flor del archivo }
		read( archivo_logico , f );
		
		{ mostrar flor en consola }
		if ( f.codigo > 0 ) then
			imprimirFlor(f);
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure agregarFlor ( var archivo_logico:tArchFlores ; nombre:string ; codigo:integer );
var
	f , indice : reg_flor;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer registro cabecera }
	leer( archivo_logico , f );
	
	if ( f.codigo < 0 ) then
	begin
	
		{ nos posicionamos en la ubicacion donde hay espacio libre }
		seek( archivo_logico , abs(f.codigo) );
		
		{ obtenemos el indice de ese registro }
		read( archivo_logico , indice );
		
		{ reubicamos el puntero }
		seek ( archivo_logico , filePos(archivo_logico)-1 );
	
		{ agregar datos del registro }	
		f.nombre := nombre;
		f.codigo := codigo;

		{ agregamos el registro al archivo }
		write( archivo_logico , f );
		
		{ nos posicionamos en la cabecera }
		seek( archivo_logico , 0 );
		
		{ guardamos el indice }
		write( archivo_logico , indice );
		
		writeln ('Se agrego el registro con exito');
	end
	else
		writeln ('No hay espacio disponible');
	
	{ cerrar archivo }
	close( archivo_logico );

end;

procedure altaFlor( var archivo_logico:tArchFlores );
var
	codigo : integer;
	nombre : string;
begin

	write('codigo: ');
	readln( codigo );
	write('nombre: ');
	readln( nombre );
			
	agregarFlor( archivo_logico , nombre , codigo );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure bajaFlor( var archivo_logico:tArchFlores );
var
	codigo : integer;
	encontrado : boolean;
	f, indice : reg_flor;
begin

	encontrado := false;
	
	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer codigo a buscar }
	write('Ingrese codigo de la flor que quiere eliminar: '); 
	readln(codigo);
	
	{ leer registro cabecera }
	leer( archivo_logico , indice );
	
	{ leer primer novela }
	leer( archivo_logico , f );


	while ( f.codigo <> valorAlto ) and ( not(encontrado) ) do 
	begin
	
		{ si se encuentra la novela, la eliminamos }
		if ( f.codigo = codigo ) then 
		begin
		
			encontrado := true;

			{ reemplazar el codigo del registro con el valor negativo del indice }
			f.codigo := indice.codigo;
			
			{ reposicionar puntero }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			
			{ guardar posicion del registro a borrar y convertir el índice a negativo }
			indice.codigo := filepos(archivo_logico) * -1;
			
			{ escribir el registro modificado en el archivo }
			write( archivo_logico , f );	

			{ escribir el nuevo índice en el registro cabecera }
			seek( archivo_logico , 0 );
			write( archivo_logico , indice );	
	
		end else
			leer( archivo_logico , f );
		
	end;
	
	if ( encontrado ) then 
		writeln ('se elimino con exito')
	else
		writeln ('no se encontro la flor con codigo ' , codigo );
		
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure eliminarFlor ( var archivo_logico:tArchFlores ; flor:reg_flor );
var
	encontrado : boolean;
	f, indice : reg_flor;
begin

	encontrado := false;
	
	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer registro cabecera }
	leer( archivo_logico , indice );
	
	{ leer primer novela }
	leer( archivo_logico , f );


	while ( f.codigo <> valorAlto ) and ( not(encontrado) ) do 
	begin
	
		{ si se encuentra la novela, la eliminamos }
		if ( f.codigo = flor.codigo ) then 
		begin
		
			encontrado := true;

			{ reemplazar el codigo del registro con el valor negativo del indice }
			f.codigo := indice.codigo;
			
			{ reposicionar puntero }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			
			{ guardar posicion del registro a borrar y convertir el índice a negativo }
			indice.codigo := filepos(archivo_logico) * -1;
			
			{ escribir el registro modificado en el archivo }
			write( archivo_logico , f );	

			{ escribir el nuevo índice en el registro cabecera }
			seek( archivo_logico , 0 );
			write( archivo_logico , indice );	
	
		end else
			leer( archivo_logico , f );
		
	end;
	
	if ( encontrado ) then 
		writeln ('se elimino con exito')
	else
		writeln ('no se encontro la flor con codigo ' , flor.codigo );
		
	{ cerrar archivo }
	close( archivo_logico );
	
end;

procedure buscarYBorrarFlor( var archivo_logico:tArchFlores );
var
	flor : reg_flor;
	codigo : integer;
begin
	
	write('Ingrese codigo de la flor a eliminar');
	readln( codigo );
	
	flor.codigo := codigo;

	eliminarFlor( archivo_logico , flor );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : tArchFlores;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_logico , 'flores');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 6 ) do 
	begin
		menu( opcion );
		case opcion of
			1: crearArchivo( archivo_logico );
			2: listarFlores( archivo_logico );
			3: altaFlor( archivo_logico );
			4: bajaFlor( archivo_logico );
			5: buscarYBorrarFlor( archivo_logico );
			6: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
