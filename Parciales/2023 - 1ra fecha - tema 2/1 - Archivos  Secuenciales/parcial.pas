program parcial;

	str15 = string[15];
	str50 = string[50];
	
	empleado = record;
		dni : string[8]
		nombre : str15;
		apellido : str15;
		edad : integer;
		domicilio : str50:
		nacimiento : str15;
	end;

	archivo = file of empleado;


// Agregar empleado: 
// solicita al usuario que ingrese los datos del empleado y lo agrega al
// archivo sólo si el dni ingresado no existe. Suponga que existe una función llamada
// existeEmpleado que recibe un dni y un archivo y devuelve verdadero si el dni existe en el
// archivo o falso en caso contrario. La función existeEmpleado no debe implementarla. Si el
// empleado ya existe, debe informarlo en pantalla
procedure leer( var a:archivo ; var dato:empleado );
begin
	if ( not eof(a) ) then
		read( a, dato )
	else
		dato.dni := valoralto;
end;

function existeEmpleado( var archivo_logico:archivo ; dni:string ): boolean;
var
	aux: empleado;
begin

	leer( archivo_logico , aux );
	
	while( aux.dni <> valoralto ) and ( aux.dni <> dni ) do
		leer( archivo_logico , aux );
		
	existeEmpleado:= aux.dni = dni;
	
end;


procedure leerEmpleado( var e:empleado );
begin
	with e do
	begin
		write('DNI: ');
		readln(dni);
		write('nombre: ');
		readln(nombre);
		write('apellido: ');
		readln(apellido);
		write('edad: ');
		readln(edad);
		write('domicilio: ');
		readln(domicilio);
		write('nacimiento: ');
		readln(nacimiento);
	end;
end;

procedure altaEmpleado( var archivo_logico:archivo );
var
	e : empleado;
	cabecera : empleado;
	indice : empelado;
begin

	{ abrir archivo }
	reset( archivo_logico );

	{ leer el registro cabecera }
	leer( archivo_logico , cabecera );
	
	{ verificar si tiene un valor negrativo  }
	if ( n.codigo < 0 ) then 
	begin

		{ ir a la posicion donde hay espacio libre }
		seek( archivo_logico , abs(n.codigo) );
		
		{ leer y guardar el indice de esa posicion }
		read( archivo_logico , indice );

		{ reposicionarse }
		seek( archivo_logico , filepos(archivo_logico)-1 );
		
		{ dar alta a el registro }
		leerEmpleado( e );
		write( archivo_logico , e )
		
		{ volver al registro cabecera }
		seek( archivo_logico , 0 );
		
		{ agregar nuevo indice }
		write( archivo_logico , indice )
		
	end else begin
	
	    { posicionarse al final del archivo }
		seek( archivo_logico , fileSize(archivo_logico) );
		
		{ escribir nuevo registro al final del archivo }
		leerNovela(n);
		write( archivo_logico , n );
		
	end;
	
	{ cerrar archivo }
	close( a );

end;


// Quitar empleado: 
// solicita al usuario que ingrese un dni y lo elimina del archivo solo si este
// dni existe. Debe utilizar la función existeEmpleado. En caso de que el empleado no exista
// debe informarse en pantalla
procedure bajaEmpleado( var archivo_logico:archivo );
begin

end;



var
	archivo_logico : archivo;
	archivo_texto : Text;
begin
	assign( archivo_logico , 'novelas' );
	altaEmpleado( archivo_logico );
	bajaEmpleado( archivo_logico );
end.
