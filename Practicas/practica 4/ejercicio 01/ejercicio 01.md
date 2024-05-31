
1 - Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
comounárbol B de orden M.  

---

a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
alumnos como un árbol B de orden M.

```pascal

const 
    M = 5; // orden del arbol

type 
    alumno = record
        nombre: string[20];
        apellido: string[20];
        dni: integer;
        legajo: integer;
        anio: integer;
    end;

    clave = alumno;

    nodoPtr = ^nodo;
        nodo = record
        claves: array[1..M-1] of clave;
        hijos: array[0..M] of nodoPtr;
        cantClaves: integer;
        esHoja: boolean;
    end;

    arbolB = file of nodo;

var
    arbol: arbolB;  // Variable para el archivo del árbol B
    raiz: nodoPtr;  // Puntero a la raíz del árbol B

```


<br>

---

<br>


b. Suponga que la estructura de datos que representa una persona (registro de
persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el
valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
(en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
el campo referido a la cantidad de claves. El objetivo es reemplazar estas
variables con los valores dados y obtener el valor de M (M debe ser un número
entero, ignorar la parte decimal).

    - N es el tamaño del nodo (512 bytes),
    - M es el orden del arbol ( desconocido ),
    - 𝐴 es el tamaño de un registro de persona (64 bytes),
    - 𝐵 es el tamaño de cada enlace a un hijo (4 bytes),
    - 𝐶 es el tamaño que ocupa el campo referido a la cantidad de claves (4 bytes).
    - Usamos la siguiente formula "N = (M−1) × A + M × B + C"

          N = ( M − 1 ) ×  A + M × B + C
        512 = ( M − 1 ) × 64 + M × 4 + 4    // reemplazamos lso valores
        512 = 64M − 64 + 4M + 4             // distribuimos las multiplicaciones
        512 = 68M − 60                      // simplificamos
        572 = 68M                           // pasamos la resa como suma
          M = 572/68                        // despejamos M y dividimos
          M ≈ 8.41

    Como 𝑀 tiene que ser un número entero, ignoramos la parte decimal y tomamos 𝑀 = 8.


<br>

---

<br>


c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
información de los alumnos como un árbol B?

    Cuando el tamaño de cada registro de alumno ocupa más espacio, el orden 
    𝑀 del árbol B disminuye. 

    **Disminución del Orden 𝑀**
    A medida que el tamaño de cada registro aumenta, el número máximo 
    de registros (claves) que un nodo puede contener se achica. Esto causa 
    una disminución del orden 𝑀 del árbol B.

    **Menos Claves por Nodo:**
    Si cada registro (clave) ocupa más espacio, caben menos registros en un 
    nodo de tamaño fijo (por ejemplo, 512 bytes). Esto reduce el valor de 𝑀, 
    ya que 𝑀 depende de cuántos registros caben en el espacio disponible.

<br>

---

<br>


d. ¿Qué dato seleccionaría como clave de identificación para organizar los
elementos (alumnos) en el árbol B? ¿Hay más de una opción?

    Una buena clave de identificacion seria el DNI.
    Otra opcion podria ser el legajo, ambos datos son buena opcion ya
    que son unicos para cada alumno. 
    
<br>

---

<br>


e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
encontrar un alumno por su clave de identificación en el peor y en el mejor de
los casos? ¿Cuáles serían estos casos?


    1. Inicio en la Raíz:
    - Se revisa que la cantidad de claves es mayor a 0
    - Se comienza recorriendo las claves del nodo raíz.
    
    2. Recorrido de Claves en el Nodo Actual:
    - Se comparan las claves del nodo actual con la clave buscada (DNI).
    - Si la clave buscada coincide, la búsqueda finaliza.
    - Si encontramos una clave mayor, descendemos al hijo anterior al que 
      contiene esa clave.
    - Si no es una hoja, se desciende al hijo correspondiente y se repite 
      el proceso.

    3. Hoja
    - Si se llega a una hoja y no se encuentra la clave buscada, entonces
      la clave no existe en el árbol.


    **Mejor Caso**
    La se encuentra en el primer nodo (raíz), lo que requiere solo una 
    lectura de nodo.


    **Peor Caso**
    La clave buscada se encuentra en una hoja, o no existe y se determina 
    en una hoja. En este caso, se deben leer tantos nodos como niveles tenga 
    el árbol.
    Esto implica que en el peor de los casos, el número de lecturas de nodos 
    es igual a la altura del árbol ℎ más uno (para incluir la raíz).


<br>

---

<br>


f. ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas
lecturas serían necesarias en el peor de los casos?

    Si se buscara un alumno por un criterio diferente en el peor caso se van a hacer N lecturas, 
    siendo N la cantidad de nodos del árbol.