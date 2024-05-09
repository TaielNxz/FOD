{

	8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
	existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
	versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
	distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
	lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

	Escriba la definición de las estructuras de datos necesarias y los siguientes
	procedimientos:
	
	a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
	verdadero si la distribución existe en el archivo o falso en caso contrario.
	
	b. AltaDistribución: módulo que lee por teclado los datos de una nueva
	distribución y la agrega al archivo reutilizando espacio disponible en caso
	de que exista. (El control de unicidad lo debe realizar utilizando el módulo
	anterior). En caso de que la distribución que se quiere agregar ya exista se
	debe informar “ya existe la distribución”.
	
	c. BajaDistribución: módulo que da de baja lógicamente una distribución 
	cuyo nombre se lee por teclado. Para marcar una distribución como
	borrada se debe utilizar el campo cantidad de desarrolladores para
	mantener actualizada la lista invertida. Para verificar que la distribución a
	borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
	se debe informar “Distribución no existente”.
	
}
program practica03_ejercicio8;
const
	valorAlto = 'ZZZZ';
type
	
	distribucion = record
		nombre : string;
		anio : integer;
		version : integer;
		cant : integer;
		descripcion : string;
	end;
	
	archivo = file of distribucion;

{ ======================================================================================================================== }
{                                                      PROCEDIMIENTOS                                                      }
{ ======================================================================================================================== }
procedure menu( var opcion : integer );
begin
	writeln;
	writeln('========================================================================');
	writeln('1. Dar de alta una distribucion');
	writeln('2. Dar de baja una distribucion');
	writeln('3. Crear archivo');
	writeln('4. Listar archivo');
	writeln('5. Salir');
	writeln('========================================================================');
	write('opcion: ');
	readln( opcion );
	writeln;
end;

procedure leer( var archivo_logico:archivo ; var dato:distribucion );
begin
	if ( not eof (archivo_logico) ) then
		read ( archivo_logico , dato )
	else
		dato.nombre := valorAlto;
end;

{ ======================================================================================================================== }
{                                                         OPCION 1                                                         }
{ ======================================================================================================================== }
function ExisteDistribucion( var archivo_logico:archivo ; nombre:string ):boolean;
var
	encontrado : boolean;
	d : distribucion;
begin
	encontrado := false;

	{ abrir archivo }
	reset( archivo_logico );
	
	{ saltear registro cabecera }
	seek( archivo_logico , 1 );

	{ leer primer registro }
	leer( archivo_logico , d );

	while ( d.nombre <> valorAlto ) and ( not encontrado ) do
	begin
	
		if ( d.nombre = nombre ) then
			encontrado := true;

		leer( archivo_logico , d )

	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
	ExisteDistribucion := encontrado;
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 2                                                         }
{ ======================================================================================================================== }
procedure Alta( var archivo_logico:archivo ; nuevo:distribucion );
var
	d , indice : distribucion;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ leer registro cabecera }
	read( archivo_logico , d );
	
	if ( d.cant < 0 ) then
	begin
	
		{ voy a la posicion donde hay espacio libre y leo el indice } 
		seek( archivo_logico , abs(d.cant) );
		read( archivo_logico , indice );
		
		{ agrego el nuevo registro en el espacio libre }
		seek( archivo_logico , filepos(archivo_logico)-1 );
		write( archivo_logico , nuevo );
		
		{ escribimos en el registro cabecera el indice del archivo que dimos de alta }
		seek( archivo_logico , 0 );
		write( archivo_logico , indice );

	end else
		writeln('No hay espacio');
	

	{ cerrar archivo }
	close( archivo_logico );
	
	
	writeln('el registro fue creado correctamente');

end;

procedure AltaDistribucion( var archivo_logico:archivo );
var
	d : distribucion;
begin

	write('nombre de la disctribucion a crear: ');
	readln( d.nombre );
	
	if ( not ExisteDistribucion( archivo_logico , d.nombre ) ) then
	begin
	
		{ completar los datos }
		write('anio: ');
		readln( d.anio );
		write('version: ');
		readln( d.version );
		write('cantidad de desarrolladores: ');
		readln( d.cant );
		write('descripcion: ');
		readln( d.descripcion );		
	
		{ dar de alta }
		Alta( archivo_logico , d )
		
	end else
		writeln('la distribucion "' , d.nombre , '" ya existe' );
	
end;
{ ======================================================================================================================== }
{                                                         OPCION 3                                                         }
{ ======================================================================================================================== }
procedure Baja( var archivo_logico:archivo ; nombre:string );
var
	d, indice : distribucion;
	encontrado : boolean;
begin
	encontrado := false;
	
	{ abrir archivo }
	reset( archivo_logico );

	{ leer indice el registro cabecera }
	read( archivo_logico , indice );
	
	{ leer priera distribucion }
	read( archivo_logico , d );
	
	while ( d.nombre <> valorAlto ) and ( not encontrado ) do
	begin
	
		if ( d.nombre = nombre ) then
		begin
		
			encontrado := true;
		
			{ copio el indice en el registro a eliminar }
			d.cant := indice.cant;
		
			{ guardo la posicion del registro a eliminar en el indice y lo paso a negativo }
			seek( archivo_logico , filepos(archivo_logico)-1 );			
			indice.cant := filepos(archivo_logico) * -1;
			 
			{ elimianos logicamente }
			write( archivo_logico , d );
			
			{ reemplazamos el registro cabecera con el nuevo indice }
			seek( archivo_logico , 0 );
			write( archivo_logico , indice );
		
		end else
			leer( archivo_logico , d )
	
	end;

	{ cerrar archivo }
	close( archivo_logico );

	writeln('se elimino con exito...');
	
end;


procedure BajaDistribucion( var archivo_logico:archivo );
var
	nombre : string;
begin

	write('Nombre de la distribucion a eliminar: ');
	readln( nombre );
	
	if ( ExisteDistribucion( archivo_logico , nombre ) ) then
		Baja( archivo_logico , nombre )
	else
		writeln('la distribucion "' , nombre , '" NO existe' );
end;
{ ======================================================================================================================== }
{                                                         OPCION 4                                                         }
{ ======================================================================================================================== }
procedure leerDistribucion( var d:distribucion );
begin
	
	with d do
	begin
		writeln('-----------------------');
		write('nombre de disctribucion: ');
		readln( nombre );
		if ( nombre <> 'fin' ) then
		begin
			write('anio: ');
			readln( anio );
			write('version: ');
			readln( version );
			write('cantidad de desarrolladores: ');
			readln( cant );
			write('descripcion: ');
			readln( descripcion );		
		end;
	end;

end;

procedure crearArchivo( var archivo_logico:archivo );
var
	d : distribucion;
begin

	{ crear archivo }
	rewrite( archivo_logico );
	
	{ agregar registro cabecera }
	d.cant := 0;
	write( archivo_logico , d );
	
	{ leer primera distribucion }
	leerDistribucion( d );
	
	while ( d.nombre <> 'fin' ) do
	begin
	
		{ agregar distribucion al archivo }
		write( archivo_logico , d );
	
		{ leer proxima distribucion }
		leerDistribucion( d );
	
	end;
	
	{ cerrar archivo }
	close( archivo_logico );

end;
{ ======================================================================================================================== }
{                                                        OPCION 5                                                          }
{ ======================================================================================================================== }
procedure imprimirDistribucion( d:distribucion );
begin

	with d do
	begin
		writeln('-----------------------');
		writeln('nombre de disctribucion: ' , nombre );
		writeln('anio: ' , anio );
		writeln('version: ' , version );
		writeln('cantidad de desarrolladores: ' , cant );
		writeln('descripcion: ' , descripcion );
	end;

end;


procedure listarArchivo( var archivo_logico:archivo );
var
	d : distribucion;
begin

	{ abrir archivo }
	reset( archivo_logico );
	
	{ saltear el registro cabecera }
	seek( archivo_logico , 1 );
	
	{ leer e imprimir hasta haber recorrido todo el archivo }
	while ( not eof(archivo_logico) ) do begin
	
		{ leer distribucion del archivo }
		read( archivo_logico , d );
		
		{ mostrar distribucion en consola }
		if ( d.cant > 0 ) then
			imprimirDistribucion(d);
		
	end;
	
	{ cerrar archivo }
	close( archivo_logico );
	
end;
{ ======================================================================================================================== }
{                                                    PROGRAMA PRINCIPAL                                                    }
{ ======================================================================================================================== }
VAR
	archivo_logico : archivo;
	opcion : integer;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_logico , 'distribuciones');
	

	{ menu de opciones... }
	opcion := 0;
	while ( opcion <> 5 ) do 
	begin
		menu( opcion );
		case opcion of
			1: AltaDistribucion( archivo_logico );
			2: BajaDistribucion( archivo_logico );
			3: crearArchivo( archivo_logico );
			4: listarArchivo( archivo_logico );
			5: writeln('fin del programa');
		else
			writeln('opcion invalida');
		end;
	end;
	
END.
