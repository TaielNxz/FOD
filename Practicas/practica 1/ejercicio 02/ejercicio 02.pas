{
	2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
	creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
	promedio de los números ingresados. El nombre del archivo a procesar debe ser
	proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
	contenido del archivo en pantalla.
}

program practica01_ejercicio02;

TYPE
	archivoEnteros = file of integer;
	cadena50 = string[50];

VAR
	archivo_logico : archivoEnteros;
	archivo_fisico : cadena50;
	num : integer;
	cantidad : integer;
	cantMenor : integer;
	total : integer;
	promedio : real;
	
BEGIN

	cantidad := 0;
	cantMenor := 0;
	total := 0;
	promedio := 0;

	{ Nombre del archivo a leer }
	write('Nombre del archivo a procesar: ');
	readln( archivo_fisico );
	
	{ Asignar }
	assign( archivo_logico , archivo_fisico );

	{ Leer archivo binario de numeros }
	reset( archivo_logico );
	
	{ Recorrer todo el archivo binario de numeros }
	while( not eof(archivo_logico) ) do
    begin
        cantidad := cantidad+1;
        
        { Leer numero y guardar en la varialbe 'num' }
		read( archivo_logico , num );
		
		{ Sumar valores }
		total := total + num;
		 
		{ Contar numero menor a 1500 }
        if ( num < 1500 ) then
            cantMenor := cantMenor + 1;
        
    end;
    
    { Cerrar archivo binario de numeros }
    close( archivo_logico );

	{ Imprimir datos }
    promedio := total/cantidad;
    writeln('Cantidad de numeros menores a 1500: ' , cantMenor );
    writeln('Promedio e numeros ingresados: ' , promedio:5:1 )
	
END.
