4 - Dado el siguiente algoritmo de búsqueda en un árbol B:

```pascal

procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var 
    clave_encontrada: boolean;
begin

    if (nodo = null)
        resultado := false; {clave no encontrada}
    else
        posicionarYLeerNodo(A, nodo, NRR);

    claveEncontrada(A, nodo, clave, pos, clave_encontrada);
    
    if (clave_encontrada) then 
    begin
        NRR_encontrado := NRR; { NRR actual }
        pos_encontrada := pos; { posicion dentro del array }
        resultado := true;
    end
    else
        buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada,
        resultado)
end;

```

Asuma que para la primera llamada, el parámetro NRR contiene la posición de la raíz
del árbol. Responda detalladamente:


<br>

---

<br>


z - ¿Qué chota hace el algoritmo?

    1. Inicio en la Raiz:
    La búsqueda comienza en la raíz del árbol. NRR inicialmente contiene la posición 
    de la raíz.
    
    2. Leer Nodo:
    *posicionarYLeerNodo()* mueve el puntero del archivo al nodo especificado por NRR 
    y lee su contenido.
    
    3 . Encontramos la Clave:
    *claveEncontrada()* verifica si la clave buscada está en el nodo. Si se encuentra, 
    se actualizan las variables NRR_encontrado y pos_encontrada, y resultado se 
    establece en true.
    
    4. Descenso en el Árbol:
    Si la clave no se encuentra, el algoritmo desciende al hijo correspondiente y repite 
    el proceso.


<br>

---

<br>

a - *PosicionarYLeerNodo()*: Indique qué hace y la forma en que deben ser enviados 
los parámetros (valor o referencia). Implemente este módulo en Pascal.

    El procedimiento *posicionarYLeerNodo()* se encarga de mover el puntero del archivo 
    al nodo especificado y leer su contenido. Los parámetros deben ser enviados por
    referencia para permitir la modificación de los datos dentro de la función.


```pascal
procedure posicionarYLeerNodo( var A:arbolB ; var nodo:TNodo ; NRR:integer );
begin
    { Mover el puntero del archivo 'A' a la posición 'NNR' del nodo }
    seek(A, NRR);
    { Lee el nodo en la posición actual del puntero del archivo A 'NNR'
    y almacena sus datos en la variable nodo. }
    read(A, nodo);
end;
```



<br>

---

<br>


b - *claveEncontrada()*: Indique qué hace y la forma en que deben ser enviados los
parámetros (valor o referencia). ¿Cómo lo implementaría?

    El procedimiento *claveEncontrada()* se encarga de buscar una clave específica dentro 
    de un nodo del árbol B y determinar si la clave existe en el nodo. Si la clave se 
    encuentra, se devuelve su posición dentro del nodo.


```pascal
procedure claveEncontrada( var A:arbolB ; nodo:TNodo ; clave:longint ; var pos:integer ; 
                           var clave_encontrada:boolean );
begin
    clave_encontrada := false;
    pos := 1;
    
    while ( pos <= nodo.cant_claves ) and ( not clave_encontrada ) do
    begin
        if ( nodo.claves[pos] = clave ) then
        begin
            clave_encontrada := true;
        end
        else if ( nodo.claves[pos] > clave ) then
        begin
            // Si encontramos una clave mayor, no necesitamos seguir buscando
            break;
        end
        else
        begin
            pos := pos + 1;
        end;
    end;

    // Si la clave no es encontrada y todas las claves en el nodo son menores
    if not clave_encontrada then
        pos := pos - 1; // Posición para el siguiente nodo hijo
end;
```


<br>

---

<br>


c - ¿Existe algún error en este código? En caso afirmativo, modifique lo que 
considere necesario.

    **Errores*

        1. Declaración de Variables y Parámetros
            * Variables 'A' y 'nodo' no están declaradas.
            * Falta declarar tipos de parámetros y su modo de paso (valor o referencia).

        2. Control de Fin de Recursión
            * Verificación incorrecta de 'nodo = null'. Debe ser 'NRR = -1' para indicar 
            un nodo inexistente.


        3. Inicialización de pos:
            * 'pos' debe inicializarse antes de ser usado en 'claveEncontrada'.

        4. Verificación de Existencia de Nodo
            * El código tiene que verificar adecuadamente si el nodo es null o no.
            * La verificación de 'nodo = null' es incorrecta. Se debe verificar 
              si NRR = -1.

        5. Declaración del Procedimiento
            * El procedimiento tiene que ser declarado con los tipos de parámetros correctos.

    **Correcciones**

        1. Declaración de Variables y Parámetros
            * Se añaden A: arbolB, nodo: TNodo y clave: longint con su modo de paso.
            * A es el archivo del árbol B, pasado por referencia (var).

        2. Control de Fin de Recursión
            * En lugar de nodo = null, se usa NRR = -1 para indicar un nodo inexistente.
            * Si NRR = -1, se establece resultado := false y se sale del procedimiento

        3. Inicialización de pos:
            * 'pos' se inicializa antes de llamar a 'claveEncontrada'.

        4. Verificación de Existencia de Nodo
            * Se verifica si 'NRR = -1' en lugar de 'nodo = null'.

        5. Declaración del Procedimiento
            * El procedimiento buscar está declarado con los tipos correctos y el paso de
              parámetros por referencia o valor según corresponda.


```pascal
procedure buscar( var A:arbolB ; NRR:integer ; clave:longint ; var NRR_encontrado:integer ;
                  var pos_encontrada:integer ; var resultado:boolean );
var 
    nodo: TNodo;
    pos: integer;
    clave_encontrada: boolean;
begin

    pos := 1;
    
    if NRR = -1 then
        resultado := false; { clave no encontrada }
    else
    begin

        posicionarYLeerNodo(A, nodo, NRR);

        claveEncontrada(nodo, clave, pos, clave_encontrada);
        
        if clave_encontrada then 
        begin
            NRR_encontrado := NRR; { NRR actual }
            pos_encontrada := pos; { posición dentro del array }
            resultado := true;
        end
        else
            buscar(A, nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);

    end;

end;
```



<br>

---

<br>


d. ¿Qué cambios son necesarios en el procedimiento de búsqueda implementado 
sobre un árbol B para que funcione en un árbol B+?


    El cambio principal que se debe realizar en el código para que funcione en un árbol B+
    es ajustar la lógica de búsqueda para que recorra los nodos del árbol B+ hasta llegar
    a una hoja.
    
    Recorrer hasta las Hojas: 
    La búsqueda debe continuar hasta llegar a una hoja, incluso si encuentra una clave igual
    en un nodo interno.

    Obtener Datos desde las Hojas: 
    Una vez en la hoja correcta, la clave encontrada debe utilizarse para recuperar el dato
    correspondiente directamente.



```pascal
procedure buscarEnBPlus( var A:arbolB ; NRR:integer ; clave:longint ; var NRR_encontrado:integer ;
                         var pos_encontrada:integer ; var resultado:boolean );
var 
    nodo: TNodo;
    pos: integer;
    clave_encontrada: boolean;
begin

    pos := 1;
    
    if NRR = -1 then
        resultado := false; { clave no encontrada }
    else
    begin

        posicionarYLeerNodo(A, nodo, NRR);

        claveEncontrada(nodo, clave, pos, clave_encontrada);
        
        if nodo.esHoja then 
        begin

            if clave_encontrada then
            begin
                NRR_encontrado := nodo.enlaces[pos]; { NRR del registro en el archivo de datos }
                pos_encontrada := pos; { posición dentro del array }
                resultado := true;
            end
            else
                resultado := false; { clave no encontrada }

        end
        else
            buscarEnBPlus(A, nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado);

    end;

end;
```