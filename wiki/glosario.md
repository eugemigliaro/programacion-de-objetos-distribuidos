# Glosario

Definiciones breves de la primera unidad. Los enlaces llevan al apunte temático donde se desarrolla cada concepto.

- **Acción atómica:** operación sin estado intermedio observable; `++` no es atómica aunque la variable sea `volatile`. [PC-T02, p. 15] Véase [Thread safety y coordinación](temas/thread-safety-y-coordinacion.md#accesos-compartidos-y-happens-before).
- **Bloqueo (*lock*):** mecanismo de exclusión que permite que un solo thread posea un recurso protegido; los monitores de Java son reentrantes para su dueño. [PC-T02, p. 17]
- **`Callable<V>`:** tarea que produce un valor y puede lanzar una excepción. [PC-T01, p. 33]
- **Concurrencia:** composición de tareas cuyos avances pueden superponerse; en la materia se implementa identificando zonas ejecutables por threads. No implica por sí sola ejecución paralela. [PC-T01, p. 18]
- **`CountDownLatch`:** coordinador que permite esperar hasta que se hayan informado `n` eventos o llegadas. [PC-T02, p. 30]
- **`CyclicBarrier`:** punto de encuentro reutilizable en el que `n` threads esperan a que todos hayan llegado. [PC-T02, p. 30]
- **Deadlock:** espera circular en la que cada thread conserva un lock que el otro necesita. [PC-T02, p. 26]
- **`ExecutorService`:** abstracción que recibe tareas, devuelve `Future` y administra su ejecución y ciclo de vida. [PC-T01, p. 35] [PC-T01, p. 37]
- **`Future<V>`:** representación de una tarea asincrónica que permite consultar, cancelar y obtener su resultado. [PC-T01, p. 34]
- **Happens-before:** relación de orden y visibilidad entre acciones; el orden del programa, los monitores, `volatile`, `start` y `join` establecen casos relevantes. [PC-T02, p. 13] [PC-T02, p. 14]
- **Inmutabilidad:** propiedad de un objeto cuyo estado no cambia tras construirse; evita interferencia sobre ese estado compartido. [PC-T03, p. 4] [PC-T03, p. 5]
- **Interferencia:** pérdida o corrupción de actualizaciones cuando threads escriben sobre estado compartido sin la coordinación necesaria. [PC-T02, p. 11]
- **Livelock:** actividad sin progreso donde los threads ceden y reintentan indefinidamente. [PC-T02, p. 27] [PC-T02, p. 28]
- **Paralelismo:** ejecución simultánea posible cuando hay múltiples unidades de procesamiento; es distinto de concurrencia. [PC-T01, p. 18]
- **Proceso:** programa en ejecución con recursos asignados por el sistema operativo. [PC-T01, p. 3]
- **Pub/sub:** coordinación desacoplada donde productores publican mensajes en una cola y consumidores los toman para continuar su trabajo. [PC-T03, p. 9] [PC-T03, p. 10]
- **`Runnable`:** tarea sin valor de retorno que puede entregarse a un `Thread` o ejecutor. [PC-T01, p. 22]
- **Starvation:** falta indefinida de acceso de un thread a un lock o recurso dominado por otros. [PC-T02, p. 29]
- **`synchronized`:** construcción que adquiere el monitor de un objeto, excluye competidores sobre ese monitor y aporta visibilidad entre liberación y adquisición. [PC-T02, p. 16] [PC-T02, p. 17]
- **Thread:** subunidad de ejecución de un proceso que comparte con otros threads su memoria y recursos. [PC-T01, p. 19]
- **Thread pool:** conjunto de threads reutilizables a los que se asignan nuevas tareas, evitando recrearlos en cada operación. [PC-T01, p. 39]
- **Time slice:** intervalo de CPU que el sistema operativo reparte entre procesos o threads mediante cambios de contexto. [PC-T01, p. 12]
- **Volátil (`volatile`):** campo cuyas lecturas y escrituras son atómicas y cuya escritura establece visibilidad para lecturas posteriores del mismo campo; no vuelve atómicas las operaciones compuestas. [PC-T02, p. 14] [PC-T02, p. 15]

## Sistemas distribuidos y gRPC

- **Cliente:** proceso que solicita la ejecución de una operación ofrecida por un servicio remoto. [GR-T01, p. 10]
- **Deadline:** límite hasta el cual un cliente está dispuesto a esperar una respuesta RPC. [GR-T02, p. 15]
- **IDL:** lenguaje de definición de interfaces; describe contratos remotos con independencia de la implementación. Protocol Buffers cumple este rol en gRPC. [GR-T01, p. 14] [GR-T01, p. 33]
- **Interceptor:** componente que envuelve llamadas gRPC para agregar funciones transversales como métricas, logs, autenticación, autorización o manejo de errores. [GR-T03, p. 33] [GR-T03, p. 34]
- **Middleware:** capa que abstrae de la aplicación los detalles necesarios para comunicarse por la red. [GR-T01, p. 23]
- **Protocol Buffers:** IDL y formato binario tipado de serialización usado por gRPC. [GR-T01, p. 32] [GR-T01, p. 33] [GR-T01, p. 34]
- **RPC:** modelo que traduce una invocación a un método y sus parámetros a mensajes de red para ejecutar una operación remota. [GR-T01, p. 25] [GR-T01, p. 26]
- **RPC unario:** método que recibe un request y devuelve un response. [GR-T03, p. 5]
- **Server streaming:** método que recibe un request y devuelve varios mensajes de respuesta. [GR-T03, p. 11]
- **Client streaming:** método que recibe varios mensajes de request y devuelve un response. [GR-T03, p. 16]
- **Streaming bidireccional:** método donde cliente y servidor envían varios mensajes durante la misma comunicación. [GR-T03, p. 21]
- **Servicio:** componente que administra recursos y ofrece un conjunto acotado de operaciones mediante una API. [GR-T01, p. 9]
- **Servant:** implementación de la lógica remota en el servidor; en Spring gRPC extiende la clase base generada para el servicio. [GR-T01, p. 37] [GR-T01, p. 51]
- **Skeleton:** middleware servidor que interpreta el pedido, deserializa sus parámetros e invoca al servant. [GR-T01, p. 29] [GR-T01, p. 37]
- **StreamObserver:** interfaz de callbacks que entrega valores con `onNext` y finaliza con `onCompleted` o `onError`. [GR-T01, p. 53]
- **Stub:** proxy cliente generado para invocar el servicio remoto. [GR-T01, p. 28] [GR-T01, p. 40]

## Sistemas distribuidos y big data

- **3 V:** volumen, velocidad y variedad, la caracterización de big data atribuida a Doug Laney. [SD-T01, p. 33] Véase [Sistemas distribuidos](temas/sistemas-distribuidos-y-big-data.md#problema-3-big-data).
- **ACID:** atomicidad, consistencia, aislamiento y durabilidad de una transacción. [SD-T01, p. 8]
- **Data warehouse:** sistema que lleva datos de las RDBMS a modelos OLAP mediante extracción, transformación y carga. [SD-T01, p. 27]
- **ETL:** extracción, transformación y carga; en el esquema DW/OLAP se ejecuta en batch periódico. [SD-T01, p. 27] [SD-T01, p. 29]
- **Escalamiento horizontal:** crecer agregando nodos en lugar de máquinas más grandes (escalamiento vertical). [SD-T01, p. 40]
- **Nodo:** elemento computacional autónomo y débilmente acoplado de un sistema distribuido; ofrece sus recursos mediante servicios. [SD-T01, p. 44]
- **OLAP:** software que mantiene la información por dimensiones para agregarla fácilmente, conceptualmente como un cubo. [SD-T01, p. 25] [SD-T01, p. 26]
- **RM-ODP:** modelo de referencia ISO para procesamiento abierto distribuido, basado en objetos, *viewpoints*, transparencias y conformidad. [SD-T01, p. 47] [SD-T01, p. 48]
- **Transparencia:** propiedad que se cumple cuando un problema propio de la distribución queda oculto para el cliente. [SD-T01, p. 52]
- **Viewpoint:** descripción parcial de un sistema con objetivo y audiencia propios. [SD-T01, p. 50]

## Almacenamiento distribuido y Hazelcast

- **Consistencia eventual:** si no hay escrituras nuevas, pasado cierto tiempo todas las lecturas reflejan el último valor escrito. [HZ-T01, p. 11]
- **Consistencia estricta:** toda escritura queda disponible inmediatamente para todos, con orden global de las operaciones. [HZ-T01, p. 11]
- **Coordinador (Hazelcast):** miembro más antiguo del cluster; mantiene y distribuye la tabla de particiones. [HZ-T01, p. 33] [HZ-T01, p. 34]
- **`DataSerializable`:** interfaz de Hazelcast que serializa con `writeData` y `readData`; la cátedra la recomienda junto con `IdentifiedDataSerializable`. [HZ-T01, p. 70] [HZ-T01, p. 71]
- **Elasticidad:** capacidad de un cluster de cambiar su cantidad de nodos sin quedar completamente offline. [HZ-T01, p. 13]
- **Entry processor:** procesamiento atómico sobre una entrada de un `IMap`, invocado con `executeOnKey`. [HZ-T01, p. 76]
- **HDFS:** file system distribuido de Hadoop, basado en GFS, con bloques grandes replicados, un Name Node y Data Nodes. [HZ-T01, p. 17] [HZ-T01, p. 19] [HZ-T01, p. 20] [HZ-T01, p. 22]
- **Lite member:** nodo Hazelcast que no guarda datos y sirve para lanzar tareas o registrar listeners. [HZ-T01, p. 32]
- **Particionado:** división de los datos entre los nodos del cluster. [HZ-T01, p. 4] Véase [Almacenamiento distribuido](temas/almacenamiento-distribuido-y-hdfs.md#particionado).
- **Partición (Hazelcast):** una de las 271 porciones en que se divide cada estructura; se elige con `hash(objeto) % 271`. [HZ-T01, p. 35] [HZ-T01, p. 36]
- **Réplica (backup):** copia de una partición en otro nodo; en Hazelcast es sincrónica por defecto y puede configurarse asincrónica. [HZ-T01, p. 6] [HZ-T01, p. 39] [HZ-T01, p. 43]
- **SPOF:** *single point of failure*; el Name Node de HDFS lo era hasta la alta disponibilidad de 3.x. [HZ-T01, p. 23]
- **Split brain:** división del cluster en dos partes autónomas por una falla de comunicación. [HZ-T01, p. 49]

## MapReduce

- **Collator:** post-procesamiento del resultado final de un job; corre en el cliente. [HZ-T03, p. 15] [HZ-T03, p. 16]
- **Combiner:** reducción parcial por chunk en el nodo del mapper, que reduce el tráfico hacia los reducers. [HZ-T03, p. 9] [HZ-T03, p. 12]
- **Data locality:** procesar con los datos locales al nodo y evitar moverlos por la red. [HZ-T02, p. 3]
- **`JobTracker`:** punto de entrada de la API MapReduce de Hazelcast; crea jobs a partir de un `KeyValueSource`. [HZ-T02, p. 17] [HZ-T02, p. 19]
- **`KeyPredicate`:** filtro previo que descarta pares por su clave antes del map. [HZ-T03, p. 4]
- **`KeyValueSource`:** fuente que permite a un job iterar una colección distribuida. [HZ-T02, p. 18]
- **Mapper:** función que recibe un par clave/valor y emite cero, uno o más pares. [HZ-T02, p. 7]
- **MapReduce:** modelo de procesamiento paralelo y distribuido basado en `map`, sort/shuffle y `reduce`. [HZ-T02, p. 2] [HZ-T02, p. 5] Véase [MapReduce con Hazelcast](temas/mapreduce-con-hazelcast.md).
- **Reducer:** transforma todos los valores emitidos para una clave en un valor final; Hazelcast crea uno por clave mediante una factory. [HZ-T02, p. 12] [HZ-T02, p. 15]
- **Sort/shuffle:** etapa provista por el framework que agrupa por clave los valores emitidos y los envía al reducer correspondiente. [HZ-T02, p. 11]

## TPE2: servicios de trenes

- **Cuadrante (TPE2):** celda de una grilla de q grados de lado; para una coordenada es (⌊lat / q⌋, ⌊lon / q⌋). [HZ-E01] Véase [TPE2: servicios de trenes](temas/tpe2-servicios-de-trenes.md#query-4-top-n-estaciones-por-demora-media-de-llegada-por-cuadrante).
- **Demora media de llegada:** suma de las demoras de llegada de una estación, incluidos adelantos y ceros, dividida por su cantidad de servicios. [HZ-E01]
- **Demora neta:** demora de salida menos demora de llegada de un servicio en una estación. [HZ-E01]
- **Efecto bola de nieve:** suma, entre paradas consecutivas de un tren, de la demora de llegada a la siguiente menos la demora de salida de la anterior. [HZ-E01]
- **Fecha operativa:** fecha a la que pertenece el servicio de un tren (`fecha` en Suiza, `DATDEP` en Bélgica). [HZ-E01]
- **Salida demorada:** servicio cuya demora de salida es mayor que cero. [HZ-E01]
- **YTD (*year to date*):** acumulado desde enero hasta el mes indicado, inclusive; se reinicia cada año. [HZ-E01]

## APIs alternativas

- **Batch loader:** mecanismo de GraphQL que agrupa los pedidos a un campo y los resuelve en un único llamado con N elementos. [API-T02, p. 21]
- **GraphQL:** lenguaje de consulta y manipulación de datos para APIs, con esquema tipado, en el que el cliente elige los campos de la respuesta. [API-T02, p. 4] [API-T02, p. 5]
- **HATEOAS:** hipermedia como motor del estado de la aplicación; las respuestas incluyen links para recorrer el servicio. [API-T01, p. 50] [API-T01, p. 57]
- **N+1 queries:** problema de hacer una consulta adicional por cada elemento de un listado. [API-T02, p. 20]
- **Resolver:** elemento que responde una query, mutación, subscripción o campo de GraphQL. [API-T02, p. 13]
- **REST:** estilo arquitectónico de Fielding; en uso corriente, una interfaz basada en recursos sobre HTTP. [API-T01, p. 43] [API-T01, p. 44]
- **Server-Sent Events:** conexión permanente unidireccional por la que el servidor envía actualizaciones al cliente. [API-T02, p. 32]
- **SOAP:** protocolo estándar de intercambio de mensajes XML con `Envelope`, `Header`, `Body` y `Fault`. [API-T01, p. 18] [API-T01, p. 21]
- **Webhook:** callback HTTP que un sistema dispara hacia una URL configurada cuando ocurre un evento. [API-T02, p. 30]
- **WebSocket:** conexión permanente y *full duplex* entre cliente y servidor. [API-T02, p. 31]
- **WSDL:** contrato XML de un servicio SOAP: tipos, mensajes, `portType`, `binding` y `service`. [API-T01, p. 26] [API-T01, p. 27]
- **XSD:** esquema XML que define los campos, tipos y restricciones de los mensajes. [API-T01, p. 29]
