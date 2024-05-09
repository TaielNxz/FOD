{
	7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
	de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
	descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
	un programa que elimine especies de aves, para ello se recibe por teclado las
	especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
	todos los procedimientos que requiera y una alternativa para borrar los registros. Para
	ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
	posteriormente otro procedimiento que compacte el archivo, quitando los registros
	marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
	posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
	de evitar registros duplicados.
	
	Nota: Las bajas deben finalizar al recibir el código 500000
}
program practica03_ejercicio07;
const
	valorAlto = 9999;
type
	
	ave = record
		codigo : integer;
		nombre : string;
		familia : string;
		descripcion : string;
		zona : integer;
	end;
	
	archivo_maestro = file of ave;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Eliminar aves del maestro');
	writeln('2. Compactar archivo');
	writeln('3. Crear maestro');
	writeln('4. Listar maestro');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leer ( var maestro:archivo_maestro ; var dato:ave );
begin
	if ( not eof (maestro) ) then
		read ( maestro , dato )
	else
		dato.codigo := valorAlto;
end;

procedure bajaLogicaAve( var maestro:archivo_maestro ; cod:integer );
var
	a : ave;
	encontrado : boolean;
begin
	encontrado := false;

	{ abrir archivo }
	reset( maestro );
	
	{ leer primera ave }
	leer( maestro , a );
	
	
	while ( a.codigo <> valorAlto ) and ( not encontrado ) do
	begin
	
		{ si es encontro el codigo, lo eliminamos logicamente }
		if ( a.codigo = cod ) then
		begin
		
			encontrado := true;
			
			{ modificar campo del registro}
			a.nombre := '@eliminado';
			
			{ actualizar regtistro del maestro }
			seek( maestro , filepos(maestro)-1 );
			write( maestro , a );
			
		end else
			leer( maestro , a );
	
	end;
	
	{ notificar resultado de la operacion... }
	writeln;
	if ( encontrado ) then
		writeln('Registro eliminado correctamente')
	else
		writeln('No se encontro el registro con codigo ', cod );
	writeln;
	
	{ cerrar archivo }
	close( maestro );

end;

procedure eliminarRegistros( var maestro:archivo_maestro );
var
	cod : integer;
begin

	write('Codigo de ave a eliminar (finalizar con 5000): '); 
	readln( cod );
	
	while ( cod <> 5000 ) do begin
	
		bajaLogicaAve( maestro , cod );
		
		write('Codigo de ave a eliminar: '); 
		readln( cod );
	
	end;

end;
{ ======================================================================================================================== }
{                                                        OPCION 2                                                          }
{ ======================================================================================================================== }
procedure compactar( var maestro:archivo_maestro );
var
	a : ave;
	pos : integer;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer primera ave }
	leer( maestro , a );
	
	
	while ( a.codigo <> valorAlto ) do
	begin
	
		if ( a.nombre = '@eliminado' ) then 
		begin
			
			{ guardamos la posicion del registro a eliminar }
			pos := ( filepos(maestro)-1 );
			
			{ leemos y copiamos el ultimo elemento del archivo ( no debe tener la etiqueta '@eliminado' ) }
			seek( maestro, filesize(maestro) );
			write( maestro , a );
			
			{ borramos todos los elementos con etiqueta '@eliminado' que esten al final del archivo }
			while ( a.nombre = '@eliminado' ) do 
			begin
			
				{ borramos el ultimo elemento del archivo }
				seek( maestro, filesize(maestro)-1 );
				truncate(maestro);
				
				{ leemos el "nuevo ultimo elemento" del archivo }
				seek( maestro, filesize(maestro)-1 );
				read( maestro , a );
				
			end;
			
			{ nos posicionamos en el registro a eliminar y lo reemplazamos con el registro que acabamos de copiar }
			seek( maestro, pos );
			write( maestro , a );
			
			{ eliminamos el ultimo elemento del archivo para evitar duplicados }
			seek( maestro, filesize(maestro)-1 );		
			truncate(maestro);
			
			{ volvemos a la posicion del registro para continuar el recorrido del archivo }
			seek( maestro, pos );
			
		end;
		
		{ leer proxima ave }
		leer( maestro , a )
	
	end;
	
	{ cerrar archivo }
	close( maestro );
	
	{ notificar exito... }
	writeln('se compacto con exito...');

end;
{ ======================================================================================================================== }
{                                                        OPCION 3                                                          }
{ ======================================================================================================================== }
procedure leerAve( var a:ave );
begin

	with a do
	begin
		writeln('-----------------------');
		write('codigo de ave: ');
		readln( codigo );
		if ( codigo <> -1 ) then
		begin
			write('nombre: ');
			readln( nombre );
			write('familia: ');
			readln( familia );
			write('descripcion: ');
			readln( descripcion );
			write('zona: ');
			readln( zona );		
		end;
	end;

end;

procedure crearMaestro( var maestro:archivo_maestro );
var
	a : ave;
begin

	{ crear archivo }
	rewrite( maestro );
	
	{ leer primera ave }
	leerAve( a );
	
	while ( a.codigo <> -1 ) do
	begin
	
		{ agregar ave al archivo }
		write( maestro , a );
	
		{ leer proxima ave }
		leerAve( a );
	
	end;
	
	{ cerrar archivo }
	close( maestro );

end;
{ ======================================================================================================================== }
{                                                        OPCION 4                                                          }
{ ======================================================================================================================== }
procedure imprimirAve( a:ave );
begin

	with a do
	begin
		writeln('-----------------------');
		writeln('codigo de ave: ' , codigo );
		writeln('nombre: ' , nombre );
		writeln('familia: ' , familia );
		writeln('descripcion: ' , descripcion );
		writeln('zona: ' , zona );
	end;
	
end;


procedure listarMaestro( var maestro:archivo_maestro );
var
	a : ave;
begin

	{ abrir archivo }
	reset( maestro );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(maestro) ) do begin
	
		{ leer ave del archivo }
		read( maestro , a );
		
		{ mostrar ave en consola }
		if ( a.codigo > 0 ) then
			imprimirAve(a);
		
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
	while ( opcion <> 5 ) do 
	begin
		menu( opcion );
		case opcion of
			1: eliminarRegistros( maestro );
			2: compactar( maestro );
			3: crearMaestro( maestro );
			4: listarMaestro( maestro );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
