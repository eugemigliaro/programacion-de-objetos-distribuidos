# Almacenamiento distribuido y HDFS

El almacenamiento distribuido guarda información que no entra en un nodo servidor, ya sea porque un elemento solo no entra o porque la suma de los elementos excede la capacidad de los nodos. [HZ-T01, p. 2] Hay stores distribuidos de distintos tipos: file systems, bases de datos y colecciones de objetos. [HZ-T01, p. 3]

Esta página resume los conceptos generales. La implementación concreta que usa la materia está en [Hazelcast](hazelcast-cluster-y-estructuras.md).

## Particionado

El primer problema es cómo repartir la información en el cluster. Lo natural es dividir la tarea de almacenar entre los nodos, es decir, **particionar** los datos. [HZ-T01, p. 4]

Una buena partición acelera las escrituras y el *lookup*. Como contrapartida, hay que coordinar el cluster para saber dónde está cada partición y a qué partición va cada valor, y una mala estrategia deja los datos sesgados en pocos servidores y sobrecarga esos nodos. [HZ-T01, p. 5]

## Replicación

Con una única copia por partición, la caída de un nodo hace desaparecer esa partición. Por eso cada partición se **replica** en otros nodos, con una o más réplicas según las necesidades del sistema. [HZ-T01, p. 6]

## Consistencia

Con particionado y replicación hay que decidir cuándo se considera escrito un dato y cuándo puede leerse: [HZ-T01, p. 7]

1. al escribirse en la partición principal;
2. al escribirse la partición y al menos una réplica;
3. al escribirse todas las réplicas.

También hay que decidir si se puede leer o escribir en las réplicas. Si se necesita mucha capacidad de lectura con datos consistentes (similar a ACID), corresponde la opción 3; en otro caso, 1 y 2 son válidas. [HZ-T01, p. 7] [HZ-T01, p. 8]

Dos parámetros expresan esta preferencia: [HZ-T01, p. 9]

- **Consistencia en escritura:** cuántas copias deben confirmar la escritura antes de informarle al cliente que terminó.
- **Consistencia en lectura:** cuántas copias deben reportar el mismo valor antes de devolverlo como cierto. La lámina dice "particiones"; por contexto se refiere a las copias de una partición.

### Modelos de consistencia

Un modelo de consistencia fija reglas de lectura y escritura que, si se respetan, garantizan lecturas consistentes con las escrituras. Se usan en stores distribuidos y en memoria distribuida compartida (DSM). [HZ-T01, p. 10] Los dos más comunes en store distribuido son: [HZ-T01, p. 11] [HZ-T01, p. 12]

- **Estricto:** toda escritura queda disponible inmediatamente para todos y se respeta un orden global de las operaciones. Es el modelo ideal.
- **Eventual:** si no hay escrituras nuevas, después de cierto tiempo todas las lecturas reflejan el último valor escrito.

## Elasticidad y tolerancia a fallos

**Elasticidad** es la capacidad del cluster de cambiar su cantidad de nodos sin quedar completamente offline. En un cluster de storage requiere detectar el nodo nuevo, asignarle particiones primarias y de backup, coordinar la transferencia y marcarlo disponible. [HZ-T01, p. 13]

**Tolerancia a fallos:** si un nodo cae, sus particiones primarias y de backup deben reasignarse. En general hay un nodo master o coordinador; lo que cambia entre diseños es si ese master es un nodo especial o si cualquier nodo puede asumir el rol. [HZ-T01, p. 14]

## HDFS

Hadoop tiene tres componentes: HDFS (file system distribuido), Hadoop MapReduce (procesamiento distribuido) y YARN (manejo de recursos y tareas distribuidas). [HZ-T01, p. 16]

**HDFS** está modelado a partir del paper de Google File System, está optimizado para *high throughput* sobre archivos muy grandes (del orden de gigas o más), usa bloques muy grandes, replica para lograr tolerancia a fallos y está pensado para *commodity hardware*. [HZ-T01, p. 17]

| Componente | Responsabilidad |
|---|---|
| Bloque | Unidad de partición de archivos, de 128 MB por defecto y configurable. Cada bloque se replica en varios nodos; un archivo menor que un bloque ocupa sólo su tamaño real. [HZ-T01, p. 19] |
| Name Node | Administra el namespace y el acceso de los clientes, mantiene la metadata de carpetas y archivos, relaciona archivos con bloques, conoce el estado de los Data Nodes y responde búsquedas y escrituras de bloques. [HZ-T01, p. 20] Persiste su estado con una `FsImage` (snapshot periódico) y un *transaction log* de las escrituras posteriores. [HZ-T01, p. 21] |
| Data Node | Guarda los bloques, se reporta al Name Node periódicamente (cada 3 segundos por defecto) con los bloques que tiene y se comunica con otros Data Nodes para replicar. [HZ-T01, p. 22] |

Problemas conocidos: [HZ-T01, p. 23]

- el Name Node es un **SPOF**; HDFS 2.x lo mitigó con federación y 3.x lo resolvió con alta disponibilidad;
- el acceso aleatorio dentro de un archivo es ineficiente porque HDFS lee por bloque; por eso surgieron bases como HBase sobre HDFS;
- muchos archivos pequeños degradan la performance, así que conviene combinarlos o particionarlos.

Los comandos se invocan como `hadoop fs -<comando> <args>`; la lámina muestra `-get`, `-put`, `-cp`, `-mv`, `-mkdir`, `-ls`, `-rm`, `-rmdir`, `-tail` y `-getmerge`. [HZ-T01, p. 24]

## Vínculos

- Hazelcast aplica estos conceptos con 271 particiones, réplicas sincrónicas o asincrónicas y un coordinador sin master fijo: [Hazelcast](hazelcast-cluster-y-estructuras.md#particionado-y-réplicas).
- El particionado local de datos es la base de *data locality* en [MapReduce](mapreduce-con-hazelcast.md).
