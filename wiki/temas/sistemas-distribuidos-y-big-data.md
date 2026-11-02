# Sistemas distribuidos: de la RDBMS al escalamiento horizontal

Esta unidad explica por qué el par cliente/servidor con una base relacional dejó de alcanzar y qué se espera de un sistema distribuido. Complementa la definición inicial vista con gRPC en [Fundamentos de sistemas distribuidos y gRPC](grpc-fundamentos-y-patrones.md#del-sistema-distribuido-al-servicio).

## El punto de partida: cliente/servidor con RDBMS

Un sistema con sólo un cliente y un servidor es raro; en general la persistencia se separa y, como mínimo, incluye una base de datos y archivos de logs. [SD-T01, p. 2] [SD-T01, p. 3]

Una **RDBMS** crea, modifica y administra bases relacionales. [SD-T01, p. 5] Sus beneficios, según la cátedra:

- **Modelo relacional:** tablas con filas (registros) y columnas (atributos), *primary keys* posiblemente compuestas, relaciones por *foreign keys* y *constraints* que validan unicidad y relaciones. [SD-T01, p. 6]
- **Esquema:** tipos por atributo, *constraints*, optimizaciones de guardado e índices para buscar y filtrar. [SD-T01, p. 7]
- **Transacciones ACID:** atomicidad (todo o nada), consistencia (sólo se escribe información válida según las restricciones), aislamiento (las transacciones concurrentes no se afectan) y durabilidad (lo escrito persiste y se lee en lo sucesivo). [SD-T01, p. 8]
- **SQL:** lenguaje de dominio específico con sublenguajes DDL, DML y DCL más un lenguaje de consulta; se volvió estándar ANSI/ISO del modelo de Codd y casi sinónimo de RDBMS. [SD-T01, p. 9] [SD-T01, p. 10] [SD-T01, p. 11]

Mientras el problema es de *book keeping*, esta solución resulta simple de aprender, usar y mantener: "una herramienta para todo". [SD-T01, p. 12] El problema aparece cuando se fuerza el mismo modelo sobre necesidades nuevas. [SD-T01, p. 13]

## Problema 1: crecimiento orgánico

La presentación describe una secuencia típica de escalamiento y el costo de cada parche: [SD-T01, p. 15] [SD-T01, p. 16] [SD-T01, p. 17] [SD-T01, p. 18] [SD-T01, p. 19]

| Síntoma | Parche | Costo |
|---|---|---|
| Muchas lecturas | Cache (memcache) o réplicas | Las lecturas cacheadas dejan de ser ACID y hay que expirar el cache; las réplicas suman infraestructura y mantenimiento. |
| Muchas escrituras | Escalar verticalmente | Gastar en mejores componentes. |
| Queries con demasiados *joins* | Desnormalizar | Mantener redundancia, más capacidad y actualizaciones más complejas. |
| Mucho volumen, escrituras cada vez más lentas | Eliminar triggers e índices secundarios | Se renuncia a esos mecanismos para recuperar velocidad de escritura. |

La conclusión: la RDBMS es rígida para estos escenarios, no es ideal para datos no estructurados, cuesta escalarla con millones de registros y sus estructuras están optimizadas para lecturas con poca memoria. [SD-T01, p. 20]

## Problema 2: BI y consultas analíticas

Las empresas empezaron a buscar "nuevo conocimiento" en sus datos con preguntas del tipo *¿cuántos?*, *¿cuánto cuesta?* o *¿cuál es el promedio?*, calculadas combinando dimensiones. [SD-T01, p. 22] [SD-T01, p. 23] Son **queries de agregación**, y en una RDBMS rinden mal: el modelo por fila no es óptimo para agregar, agregar por dimensiones no indexadas exige *full scans*, los locks se sostienen más tiempo y todo eso perjudica también a las queries concurrentes. [SD-T01, p. 24]

- **OLAP** mantiene la información organizada por dimensiones para agregarla fácilmente, conceptualmente como un "cubo" sobre el que se aplican *drill down*, *roll up*, *slice*, *dice* y *pivot*. [SD-T01, p. 25] [SD-T01, p. 26] La lámina define *drill down* como agregar y *roll up* como desagregar; esa definición está registrada en [Dudas y conflictos](../dudas-y-conflictos.md).
- **Data warehouse:** el sistema que lleva los datos de las RDBMS a los modelos OLAP mediante un pipeline de extracción, transformación y carga (**ETL**), con posibles stores intermedios. [SD-T01, p. 27]

Las limitaciones del esquema DW/OLAP son el ETL batch periódico y lento, que no se guarda historia granular sino lo mínimo agregado, y que por eso las preguntas quedan predefinidas: no se pueden hacer preguntas nuevas sobre datos del año pasado. [SD-T01, p. 29]

## Problema 3: big data

La presentación recoge varias definiciones: guardar todo lo que la instrumentación de un sistema puede capturar al nivel más granular, o datos que una sola máquina no puede manejar. El "problema de big data" aparece en 1997 en un paper de la NASA, cuando los datos no entran en memoria ni en disco local. [SD-T01, p. 31] [SD-T01, p. 32]

La definición de las **3 V** (Doug Laney, 2001): [SD-T01, p. 33] [SD-T01, p. 34] [SD-T01, p. 35] [SD-T01, p. 36]

| V | Significado |
|---|---|
| Volumen | La cantidad de datos crece de manera geométrica. |
| Velocidad | Crece la velocidad con la que se generan los datos. |
| Variedad | Aparecen datos estructurados (esquema fijo, replicable en una RDBMS), semiestructurados (JSON, XML) y no estructurados (mails, documentos, imágenes). |

Las nuevas fuentes son datos organizacionales, máquinas (sensores, satélites, logs, IoT) y personas (redes sociales, fotos, videos). [SD-T01, p. 37] Como big data excede por definición a una máquina, cada paso de la cadena exige estrategias nuevas: adquisición con *buffering*, procesamiento en tiempo útil (quizás particionado por prioridad y complejidad), guardado acorde a los datos y vistas útiles para los usuarios. [SD-T01, p. 38]

## Sistemas distribuidos

Estos problemas muestran que escalar "poniendo fierros más grandes" (escalamiento vertical) tiene un límite, y que conviene buscar sistemas que escalen horizontalmente. [SD-T01, p. 40]

Un **sistema distribuido** reparte sus componentes en distintas computadoras que se comunican mediante mensajes por una red y se presenta ante los usuarios como un único sistema coherente. Sus componentes coordinan recursos para completar una tarea más eficientemente que una sola computadora. [SD-T01, p. 41] [SD-T01, p. 42]

Las tareas que se particionan entre las partes del sistema son de tres tipos: [SD-T01, p. 43]

- **Almacenamiento:** guardar elementos o volúmenes que no entran en un nodo.
- **Procesamiento:** subdividir una tarea y obtener resultados parciales por subconjunto.
- **Responsabilidades:** dividir una tarea en partes lógicas con sentido semántico propio.

Características: hay más de un **nodo** (computadora, VM, dispositivo); cada uno es autónomo y débilmente acoplado; cada proceso tiene su propio espacio de direcciones; se comunican por red; y cada nodo ofrece sus recursos mediante **servicios**. [SD-T01, p. 44]

Las fallas inherentes a la distribución pueden estar en los componentes lógicos (bugs, falta de memoria), en los nodos (hardware o recursos), en la red (los nodos funcionan pero no se comunican) o en la coordinación (mensajes perdidos, tareas mal repartidas). [SD-T01, p. 45]

## Modelo de referencia RM-ODP

La ISO definió el modelo de referencia para procesamiento abierto distribuido (**RM-ODP**), que reúne conceptos y buenas prácticas para simplificar la especificación de sistemas distribuidos. [SD-T01, p. 47] Tiene cuatro elementos: modelado de objetos, *viewpoints*, transparencias y un framework de conformidad basado en pruebas o revisión de requisitos. [SD-T01, p. 48]

- **Modelado de objetos:** el análisis y diseño orientado a objetos se considera el modo más natural de describir elementos independientes que interactúan. [SD-T01, p. 49]
- **Viewpoints:** descripciones parciales con objetivo y audiencia propios, de forma libre (texto, diagramas, UML). [SD-T01, p. 50] El diagrama asocia *enterprise* con propósito, *information* con semántica, *computational* con descomposición funcional, *engineering* con mecanismos de distribución y *technology* con selección de tecnologías. [SD-T01, p. 51]

### Transparencias

Una transparencia se cumple cuando un problema de la distribución queda oculto para el cliente; cumplirlas todas es un ideal difícil. [SD-T01, p. 52]

| Transparencia | Qué oculta |
|---|---|
| Acceso | La invocación remota y la heterogeneidad de representación; se accede a todos los componentes de manera uniforme. |
| Fallas | Errores, reintentos y recuperaciones. |
| Ubicación | La ubicación física; el acceso es lógico. |
| Migración | Que un objeto cambie de ubicación entre usos. |
| Reubicación | Que un objeto cambie de ubicación mientras se usa. |
| Replicación | Que un componente esté replicado en varios nodos. |
| Transacción | La interacción de varios objetos detrás de una operación transaccional. |

Fuentes: [SD-T01, p. 53] [SD-T01, p. 54] [SD-T01, p. 55]

Al escalar horizontalmente se sigue buscando mantener las transparencias, sobre todo la de acceso: usar un servicio sin saber, o sabiendo lo mínimo, que es distribuido. Se habla de "sistemas" porque suele tratarse de varios sistemas que cooperan, no de una sola aplicación distribuida. [SD-T01, p. 56] Los ejemplos finales muestran la arquitectura de microservicios de LinkedIn antes de Kafka, el stack de Hadoop, un pipeline analítico con Twitter como fuente y el stack de Flowics. [SD-T01, p. 58] [SD-T01, p. 59] [SD-T01, p. 60] [SD-T01, p. 61]

## Relación con las unidades siguientes

- El almacenamiento distribuido (particionado, replicación, consistencia) se desarrolla en [Almacenamiento distribuido y HDFS](almacenamiento-distribuido-y-hdfs.md).
- La transparencia de acceso explica por qué Hazelcast respeta las interfaces de colecciones de Java: [Hazelcast](hazelcast-cluster-y-estructuras.md#modelo-de-datos).
- El procesamiento distribuido se desarrolla en [MapReduce con Hazelcast](mapreduce-con-hazelcast.md).
