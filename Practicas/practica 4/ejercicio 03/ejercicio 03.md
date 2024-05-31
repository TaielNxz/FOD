3 - Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
considere que por un lado se tiene el archivo que contiene la información de los
alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
siguientes incisos:


---

a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
encuentran en los nodos internos y que elementos se encuentran en los nodos
hojas?

    En un árbol B+, las claves se organizan de manera parecida a un árbol B,
    pero con algunas diferencias"

    **Nodos Internos**
    - Los nodos internos contienen claves que actúan como puntos de 
      referencia para dirigir la búsqueda hacia el nodo hoja adecuado.
    - Estos nodos no almacenan los datos directamente, sino que solo 
      tienen referencias a los nodos hoja.
    - Los nodos no terminales funcionan como separadores.

    **Nodos Hoja**
    - Los nodos hoja contienen las claves y los datos asociados, como 
      los registros del archivo de datos.
    - Las claves en los nodos hoja están ordenadas secuencialmente
    - Los nodos hoja están enlazados entre sí para permitir un recorrido
      secuencial rápido de todos los registros.


<br>

---

<br>


b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por qué?

    Los nodos hoja de un árbol B+ presentan la característica de estar 
    enlazados secuencialmente entre sí. Esto significa que cada nodo 
    hoja tiene un puntero que apunta al siguiente nodo hoja en la secuencia. 



<br>

---

<br>


c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño

```pascal

const 
    M = 5; {orden del árbol B+}
type
    

    TDato = record
        nombre: string[20];
        apellido: string[20];
        dni: integer;
        legajo: integer;
        anio: integer;
    end;


    TNodo = record
        esHoja: boolean;
        cant_claves: integer;
        claves: array[1..M-1] of integer;  // Claves (DNIs) en el nodo
        enlaces: array[1..M-1] of integer; // Enlaces a los registros del archivo de datos
        hijos: array[0..M] of integer;     // Punteros a los hijos (para nodos internos)
        siguiente: integer;                // Puntero al siguiente nodo hoja (para nodos hoja)
    end;

    // archivo de datos de alumnos
    TArchivoDatos = file of TDato;

    // archivo del índice basado en árbol B+
    arbolBPlus = file of TNodo;

var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolBPlus;

```


<br>

---

<br>


d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI específico 
haciendo uso de la estructura auxiliar (índice) que se organiza como un árbol B+. ¿Qué 
diferencia encuentra respecto a la búsqueda en un índice estructurado como un árbol B?

    El proceso de busqueda es muy similar al del arbol B, la unica diferencia es 
    que siempre se llega en un nodo hoja, no podemos terminar en un nodo interno, 
    una vez llegamos ahi verificamos la existencia de la clave y la tomamos en 
    caso de exisitir.

    1. Inicio en la Raíz:
        - Se comienza recorriendo las claves del nodo raíz.
    
    2. Recorrido de Nodos Internos:
        - Se comparan las claves del nodo actual con la clave buscada (DNI).
        - Se busca la clave más cercana que sea mayor o igual al DNI buscado 
          y se sigue el puntero al hijo.

    3. Hoja
        - Cuando se llega a un nodo hoja, se revisan las claves sus claves.
        - Si la clave está en el nodo hoja, se usa el enlace para acceder 
          directamente al registro en el archivo de datos.
        - Si la clave NO está en el nodo hoja, se determina que el DNI no está 
          en el indice.


<br>

---

<br>


e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
búsquedas en un árbol B?

    **Explicacion del Recorrido**
    El proceso de busqueda consiste en bajar atravez de los nodos internos 
    hasta que se llega a un nodo hoja cuyas claves estan muy cerca del valor 
    40000000, la clave mas cercana tiene que ser igual o mayor a 40000000.
    Una vez ahi se recorre de forma secuencial los nodos hoja enlazados y
    se recopilan todas las claves que tengan un valor entre 40000000 y 45000000
    Esta búsqueda se detiene cuando encuentra una clave mayor a 45000000 o 
    se quedan sin nodos hoja.

    **Pseudocodigo choreado**
        1- Quedan claves por leer en el nodo? Si->2 No-> 4
        2- Leo la proxima clave. Es menor o igual a 50000000? Si->3 No->6
        3- Tomo la clave. -> 1
        4- Quedan nodos hoja? Si->5 No->6
        5- Leo el proximo nodo. -> 1
        6- Termine el recorrido.
    
    **Ventajas respecto al Árbol B**
    - Recorrido Secuencial Eficiente: gracias a que los nodos hoja estan 
      enlazados de forma secuencial.
    - Menos Accesos a Disco: evitamos la necesidad de regresar a nodos 
      internos y repetir lecturas a nodos internos.

<br>

---

<br>
