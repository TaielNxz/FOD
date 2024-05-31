5 - Defina los siguientes conceptos:
- Overflow
- Underflow
- Redistribución
- Fusión o concatenación

En los dos últimos casos, ¿cuándo se aplica cada uno?

---

**Overflow**
El Overflow ocurre cuando se quiere insertar una clave en un nodo de un árbol B o B+ que ya
esta lleno, esto provoca que tengamos que dividir el nodo, a clave central se promueve al
nodo padre, dividiendo el nodo lleno en dos nodos hijos.

---

**Underflow**
El Underflow en un árbol B o B+ ocurre cuando un nodo tiene menos claves de las 
mínimas permitidas, en otras palabras, si el nodo como minimo debe tener 3 claves y al
eliminar hacer una eliminacion, el nodo se queda con 2 claves, se produce un Underflow.
En este caso se de hacer una operación de reestructuración que puede ser una 
redistribución o una fusión.

---

**Redistribución**
Redistribución es cuando un nodo con underflow toma prestada una clave de un nodo hermano
que tiene más del mínimo requerido de claves. La clave del nodo padre se ajusta en consecuencia.
Cuándo se aplica:
Se aplica cuando un nodo hermano tiene suficientes claves para prestar.


---

**Fusión o Concatenación**
Fusión es cuando un nodo con underflow se combina con un nodo hermano y una clave del nodo
padre para formar un solo nodo. Esto puede afectar al nodo padre, que puede necesitar más
ajustes.

Cuándo se aplica:
Se aplica cuando ningún nodo hermano tiene suficientes claves para redistribuir.