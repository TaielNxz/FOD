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
			writeln( archivo_texto, codigo , ' ' , nombre );
			writeln( archivo_texto, marca );
			writeln( archivo_texto, precio:1:1 , ' ' , stock_minimo , ' ' , stock_disponible );
			writeln( archivo_texto, descripcion );
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
