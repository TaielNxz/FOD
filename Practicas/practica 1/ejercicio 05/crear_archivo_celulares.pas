{
	5. Realizar un programa para una tienda de celulares, que presente un menú con
	opciones para:
	
		a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
		ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
		correspondientes a los celulares deben contener: código de celular, nombre,
		descripción, marca, precio, stock mínimo y stock disponible.
		
		b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
		stock mínimo.
		
		c. Listar en pantalla los celulares del archivo cuya descripción contenga una
		cadena decaracteres proporcionada por el usuario.
		
		d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
		“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
		podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
		debería respetar el formato dado para este tipo de archivos en la NOTA 2.
		
	NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
	
	NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
	tres líneas consecutivas. 
	En la primera se especifica: código de celular, el precio y marca, 
	en la segunda el stock disponible, stock mínimo y la descripción 
	y en la tercera nombre en ese orden. 
	Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
}
program practica01_ejercicio05_crear_txt;
TYPE

	celular = record
		codigo : integer;
		nombre : string;
		marca : string;
		precio : real;
		stock_minimo : integer;
		stock_disponible : integer;
		descripcion : string;
	end;
	
	archivo_celulares = file of celular;
	

procedure leerCelular( var c : celular );
begin
	writeln('------------------------------');
	with c do
	begin
		write('Codigo: ');
		readln( c.codigo );
		if ( c.codigo <> 0 ) then
		begin
			write('nombre: ');
			readln( c.nombre );
			write('marca: '); 
			readln( c.marca );
			write('precio: '); 
			readln( c.precio );
			write('stock_minimo: '); 
			readln( c.stock_minimo );
			write('stock_disponible: '); 
			readln( c.stock_disponible );
			write('descripcion: ');
			readln( c.descripcion );
		end;	
	end;
end;

procedure crearArchivoCelularesTxt( var archivo_texto : Text );
var
	c : celular;
begin
	
	{ crear archivo de texto }
	rewrite( archivo_texto );
	
	{ mostrar mensaje }
	writeln('creando "celulares.txt"... ( finalizar ingresando "0" )');
	
	{ leer datos de celular }
    leerCelular( c );
    
    { seguir leyendo registros hasta ingresar codigo 999 }
	while( c.codigo <> 0 ) do
	begin
	
		{ escribir datos en el archivo de texto }
		with c do begin
			writeln( archivo_texto, codigo , ' ' , precio:1:1 , ' ' , marca );
			writeln( archivo_texto, stock_disponible , ' ' , stock_minimo , ' ' , descripcion );
			writeln( archivo_texto, nombre );
		end;
		
		{ leer datos de celular }
		leerCelular( c );
		
	end; 
    
    { cerrar archivo }
    close( archivo_texto );

end;

VAR
	archivo_texto : Text;
BEGIN

	{ asignar espacio fisico }
	assign( archivo_texto , 'celulares.txt'); 

	{ crear archivo de texto }
	crearArchivoCelularesTxt( archivo_texto );

END.
