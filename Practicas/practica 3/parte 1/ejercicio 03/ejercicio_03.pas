{
	3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
	año. De cada novela se registra: código, género, nombre, duración, director y precio.
	El programa debe presentar un menú con las siguientes opciones:

	a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
	utiliza la técnica de lista invertida para recuperar espacio libre en el
	archivo. Para ello, durante la creación del archivo, en el primer registro del
	mismo se debe almacenar la cabecera de la lista. Es decir un registro
	ficticio, inicializando con el valor cero (0) el campo correspondiente al
	código de novela, el cual indica que no hay espacio libre dentro del
	archivo.
	
	b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
	inciso a., se utiliza lista invertida para recuperación de espacio. En
	particular, para el campo de ´enlace´ de la lista, se debe especificar los
	números de registro referenciados con signo negativo, (utilice el código de
	novela como enlace).Una vez abierto el archivo, brindar operaciones para:
	
		i.Dar de alta una novela leyendo la información desde teclado. Para
		esta operación, en caso de ser posible, deberá recuperarse el
		espacio libre. Es decir, si en el campo correspondiente al código de
		novela del registro cabecera hay un valor negativo, por ejemplo -5,
		se debe leer el registro en la posición 5, copiarlo en la posición 0
		(actualizar la lista de espacio libre) y grabar el nuevo registro en la
		posición 5. Con el valor 0 (cero) en el registro cabecera se indica
		que no hayespacio libre.
		
		ii.	Modificar los datos de una novela leyendo la información desde
		teclado. El código de novela no puede ser modificado.
		
		iii.Eliminar una novela cuyo código es ingresado por teclado. Por
		ejemplo, si se da de baja un registro en la posición 8, en el campo
		código de novela del registro cabecera deberá figurar-8, y en el
		registro en la posición 8 debe copiarse el antiguo registro cabecera.
	
	c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
	representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
	
	NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
	proporcionado por el usuario.
}
program practica03_ejercicio03;
const
	valorAlto = 9999;
type
	
	novela = record
		codigo : integer;
		genero : string;
		nombre : string;
		duracion : string;
		director : string;
		precio : integer;
	end;
	
	archivo_novelas = file of novela;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Crear archivo de novelas');
	writeln('2. Listar archivo de novelas');
	writeln('3. Dar de alta una novela');
	writeln('4. Editar una novela');
	writeln('5. Dar de baja una novela');
	writeln('6. Exportar a texto');
	writeln('7. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure leer ( var archivo_logico:archivo_novelas ; var dato:novela );
begin
	if ( not eof (archivo_logico) ) then
		read ( archivo_logico , dato )
	else
		dato.codigo := valorAlto;
end;
{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
procedure leerNovela( var n:novela );
begin

	with n do
	begin
		writeln('-----------------------');
		write('codigo de novela: ');
		readln( codigo );
		if ( codigo <> -1 ) then
		begin
			write('genero: ');
			readln( genero );
			write('nombre: ');
			readln( nombre );
			write('duracion: ');
			readln( duracion );
			write('director: ');
			readln( director );
			write('precio: ');
			readln( precio );
		end;
	end;
	
end;

procedure crearArchivo( var archivo_logico:archivo_novelas );
var
	n : novela;
begin

	{ crear archivo }
	rewrite( archivo_logico );
	
	{ agregar cabecera de la lista }
	n.codigo := 0;
	write( archivo_logico , n );
	
	{ leer primera novela }
	leerNovela( n );
	
	
	while ( n.codigo <> -1 ) do
	begin
	
		{ agregar novela al archivo }
		write( archivo_logico , n );
		
		{ leer proxima novela }
		leerNovela( n );

	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure imprimirNovela( n:novela );
begin

	with n do
	begin
		writeln('-----------------------');
		writeln('codigo de novela:' , codigo );
		writeln('genero:' , genero );
		writeln('nombre:' , nombre );
		writeln('duracion:' , duracion );
		writeln('director:' , director );
		writeln('precio:' , precio );
	end;
	
end;


procedure listarNovelas( var archivo_logico:archivo_novelas );
var
	n : novela;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ reubicarse en la posicion 1 , ya que en la 0 esta el registro cabecera }
	seek( archivo_logico , 1 );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo_logico) ) do begin
	
		{ leer novela del archivo }
		read( archivo_logico , n );
		
		{ mostrar novela en consola }
		if ( n.codigo > 0 ) then
			imprimirNovela(n);
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure altaNovela( var archivo_logico:archivo_novelas );
var
	n : novela;
	indice : novela;
begin
	
	{ abrir archivo }
	reset( archivo_logico );

	{ leer el registro cabecera }
	leer( archivo_logico , n );
	
	{ verificar si tiene un valor negrativo  }
	if ( n.codigo < 0 ) then 
	begin
	
		{ ir a la posicion donde hay espacio libre }
		seek( archivo_logico , abs(n.codigo) );
		
		{ leer y guardar el indice que esta en esa posicion }
		read( archivo_logico , indice ); 

		{ el ultimo 'read' nos movio una posicion adelante entonces, nos reubicamos en la posicion donde hay espacio libre }
		seek( archivo_logico , filepos(archivo_logico)-1 );
		
		{ damos de alta un registro nuevo }
		leerNovela(n);
		write( archivo_logico , n );
		
		{ volvemos al registro cabecera }
		seek( archivo_logico , 0 );
		
		{ escribimos el indice de la posicion que se acaba de dar de alta }
		write( archivo_logico , indice ); 

	end else begin
	
	    { Posiciona el puntero al final del archivo }
		seek( archivo_logico , fileSize(archivo_logico) );
		
		{ Escribir nuevo registro al final del archivo }
		leerNovela(n);
		write( archivo_logico , n );
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure editarNovela( var n:novela );
begin

	with n do
	begin
		writeln('-----------------------');
		write('genero: ');
		readln( genero );
		write('nombre: ');
		readln( nombre );
		write('duracion: ');
		readln( duracion );
		write('director: ' );
		readln( director );
		write('precio: ');
		readln( precio );
	end;
	
end;

procedure modificarNovela( var archivo_logico:archivo_novelas );
var
	codigo : integer;
	encontrado : boolean;
	n : novela;
begin

	encontrado := false;
	
	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer codigo a buscar }
	write('Ingrese codigo de la novela que quiere modifcar: '); 
	readln(codigo);
	
	{ leer registro cabecera }
	leer( archivo_logico , n );
	
	while ( n.codigo <> valorAlto ) and ( not(encontrado) ) do 
	begin
	
		{ leer primera novela }
		leer( archivo_logico , n );
		
		{ si se encuentra la novela, la editamos }
		if ( n.codigo = codigo ) then 
		begin
		
			encontrado := true;
			
			{ modificar novela }
			editarNovela(n);
			
			{ escribir cambios en el archivo }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			write( archivo_logico , n );	
	
		end;
		
	end;
	
	if ( encontrado ) then 
		writeln ('se modifico la novela con exito')
	else
		writeln ('no se encontro la novela con codigo ' , codigo );
		
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 5                                                         }
{ ======================================================================================================================== }
procedure bajaNovela( var archivo_logico:archivo_novelas );
var
	codigo : integer;
	encontrado : boolean;
	n, indice : novela;
begin

	encontrado := false;
	
	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer codigo a buscar }
	write('Ingrese codigo de la novela que quiere eliminar: '); 
	readln(codigo);
	
	{ leer registro cabecera }
	leer( archivo_logico , indice );
	
	{ leer primer novela }
	leer( archivo_logico , n );


	while ( n.codigo <> valorAlto ) and ( not(encontrado) ) do 
	begin
	
		{ si se encuentra la novela, la eliminamos }
		if ( n.codigo = codigo ) then 
		begin
		
			encontrado := true;

			{ Copiar el código del índice al registro de novela }
			n.codigo := indice.codigo;
			
			{ reposicionar puntero }
			seek( archivo_logico , filepos(archivo_logico)-1 );
			
			{ Convertir el índice a negativo }
			indice.codigo := filepos(archivo_logico) * -1;
			
			{ Escribir el registro modificado en el archivo }
			write( archivo_logico , n );	

			{ Escribir el nuevo índice en el registro cabecera }
			seek( archivo_logico , 0 );
			write( archivo_logico , indice );	
	
		end else
			leer( archivo_logico , n );
		
	end;
	
	if ( encontrado ) then 
		writeln ('se elimino con exito')
	else
		writeln ('no se encontro la novela con codigo ' , codigo );
		
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 6                                                         }
{ ======================================================================================================================== }
procedure exportarATexto( var archivo_logico:archivo_novelas ; var texto:Text );
var
	n : novela;
begin

	{ abrir archivo binario }
	reset(archivo_logico);
	
	{ crear archivo de texto }
	rewrite(texto);
	
	{ saltear la cabecera }
	seek( archivo_logico , 1 );
	
	{ leer primera novela }
	leer( archivo_logico , n );
	
	
	while ( n.codigo <> valorAlto ) do begin
	
		with n do 
		begin
			if ( codigo > 0 ) then
				writeln( texto , 'codigo: ' , codigo , ' genero: ' , genero , ' nombre: ' , nombre ,' duracion: ' , duracion ,' director: ', director ,' precio: ' , precio )
			else
				writeln( texto , '[ espacio libre ]' );
		end;

		{ leer primera novela }
		leer( archivo_logico , n );
		
	end;
	
	{ cerrar archivos }
	close(archivo_logico);
	close(texto);

end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : archivo_novelas;
	texto : Text;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_logico , 'asistentes');
	assign( texto , 'reporte.txt');

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 7 ) do 
	begin
		menu( opcion );
		case opcion of
			1: crearArchivo( archivo_logico );
			2: listarNovelas( archivo_logico );
			3: altaNovela( archivo_logico );
			4: modificarNovela( archivo_logico );
			5: bajaNovela( archivo_logico );
			6: exportarATexto( archivo_logico , texto );
			7: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
