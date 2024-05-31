2 - Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.


---

a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.

```pascal

const 
  M = 5; // Orden del árbol B

type 

    // 1. Archivo de Datos de Alumnos
    alumno = record
        nombre: string[20];
        apellido: string[20];
        dni: integer;
        legajo: integer;
        anio: integer;
    end;

    archivoAlumnos = file of alumno;

    // 2. Índice de Alumnos en un Árbol B
    clave = record
        dni: integer;
        pos: integer; // Posición en el archivo de datos
    end;

    nodoPtr = ^nodo;
        nodo = record
        claves: array[1..M-1] of clave;
        hijos: array[0..M] of nodoPtr;
        cantClaves: integer;
        esHoja: boolean;
    end;

    arbolB = file of nodo;

var
    arbol: arbolB;  // Variable para el archivo del árbol B (índice)
    raiz: nodoPtr;  // Puntero a la raíz del árbol B (índice)
    datosAlumnos: archivoAlumnos;  // Variable para el archivo de datos de los alumnos

```

<br>

---

<br>


b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.


    - N es el tamaño del nodo (512 bytes),
    - 𝐴 es el tamaño de cada clave (tamaño del DNI más la posición en el
      archivo de datos 4 + 4 = 8 bytes ),
    - 𝐵 es el tamaño de cada puntero a un hijo ( 4 bytes ),
    - 𝐶 es el tamaño que ocupa el campo que almacena la cantidad de claves ( 4 bytes ).
    - Usamos la siguiente formula "N = (M−1) × A + M × B + C"

          N = ( M − 1 ) × A + M × B + C
        512 = ( M − 1 ) × 8 + M × 4 + 4     // reemplazamos lso valores
        512 = 8M − 8 + 4M + 4               // distribuimos las multiplicaciones
        512 = 12M − 4                       // simplificamos
        516 = 12M                           // pasamos la resa como suma
          M = 516/12                        // despejamos M y dividimo
          M ≈ 43

     el orden del árbol B, 𝑀 es 43.



<br>

---

<br>


c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?

    Que el orden del árbol B es mayor hace que cada nodo pueda almacenar más claves. 
    Esto implica que se van a necesitar menos accesos a disco para encontrar un registro


<br>

---

<br>


d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.

    El proceso de busqueda es el mismo que en el ejercicio 01 con una diferencia. 
    Cuando encontramos esa clave en el árbol, no obtenemos directamente la información 
    del alumno del nodo. En su lugar, utilizamos el NRR (Número de Registro Relativo)
    guardado en el enlace correspondiente a esa clave para buscar el registro en el 
    archivo donde se guarda toda la información de los alumnos.


<br>

---

<br>


e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?


    No tiene sentido usar este indice buscando por legajo, el índice organizado por DNI 
    no está diseñado para buscar por número de legajo.

    Esto significa que no podemos usar las claves del indice directamente para buscar 
    por legajo, necesitariamos otro indice que se maneje por numero de legajo o hacer 
    un recorrido por niveles para encontrar el legajo que queremos.

    usar un índice diseñado para un tipo de búsqueda diferente es menos eficiente.


<br>

---

<br>


f. Suponga que desea buscar los alumnas que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?

    El arbol B no está hecho para buscar por rangos, esto significa que
    si quisieramos buscar algunos entre 2 valores, lo mas probable es que
    tengamos que recorrer el arbol varias veces.
    Sería más adecuado usar un arbol B+, es mas facil hacer busquedas de
    rangos por su estructura de nodos hoja enlazados.
