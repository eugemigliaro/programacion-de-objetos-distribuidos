# Preguntas de repaso

Intentá responder sin mirar el apunte. Las respuestas breves y trazables están al final.

## Concurrencia y threads

1. ¿Por qué concurrencia y paralelismo no son sinónimos?
2. ¿Qué recursos comparten los threads de un proceso y qué costo evitan frente a procesos separados?
3. ¿Qué diferencia práctica hay entre llamar `run()` y `start()`?
4. ¿Cuándo elegirías `Callable` en lugar de `Runnable`?
5. ¿Qué responsabilidades quedan al cerrar un `ExecutorService`?
6. En el ejercicio que imprime `A`, `B`, `1`, `2`, ¿qué orden debe conservar cada thread aunque el resultado global varíe? [PC-P01, p. 1]

## Thread safety y coordinación

7. ¿Cuáles son los tres grupos de problemas concurrentes que presenta la cátedra?
8. ¿Por qué `volatile int count` no vuelve seguro a `count++`?
9. ¿Qué relación de *happens-before* introduce un monitor?
10. ¿En qué se distinguen deadlock, livelock y starvation?
11. ¿Qué elegirías para esperar un único fin (`join`), `n` eventos (`CountDownLatch`) o el encuentro reiterado de `n` workers (`CyclicBarrier`)?
12. ¿Por qué conviene que un `unlock()` esté en `finally`?

## Alternativas y futuros componibles

13. ¿Por qué un objeto inmutable puede compartirse sin sincronizar su estado?
14. ¿Qué problema resuelve la copia defensiva en constructor y getter?
15. ¿Cómo desacopla pub/sub a productores y consumidores?
16. ¿Qué condición vuelve particionable una tarea?
17. ¿Por qué una operación de un stream paralelo no debería tener estado ni efectos laterales?
18. ¿Cómo se diferencian `thenApply`, `thenCompose` y `thenCombine`?
19. ¿Qué diferencia temporal hay entre `scheduleAtFixedRate` y `scheduleWithFixedDelay`?

## Sistemas distribuidos y gRPC

20. ¿Qué responsabilidades oculta el middleware RPC a la aplicación?
21. ¿Qué funciones cumplen el stub, el skeleton y el servant?
22. ¿Qué aporta Protocol Buffers como IDL y como formato de serialización?
23. ¿Por qué cada método `.proto` necesita exactamente un mensaje de entrada y uno de salida?
24. ¿Qué reglas deben cumplir los números de campo y el primer valor de un enum?
25. ¿Para qué sirven `google.protobuf.Empty` y los wrappers?
26. ¿Qué responsabilidades separan los módulos `api`, `client` y `server`?
27. ¿En qué se diferencian `BlockingStub`, `FutureStub` y `Stub`?
28. ¿Qué debería hacer el servidor con el trabajo interno cuando el cliente vence su deadline?

## Streaming y errores

29. ¿Cuáles son las cardinalidades de los cuatro patrones gRPC?
30. ¿Por qué `stream` y `repeated` no representan lo mismo?
31. ¿Cómo entrega el servidor varias respuestas en server streaming?
32. ¿Qué observers intervienen del lado cliente en client streaming?
33. ¿Puede un servidor bidireccional responder antes de que el cliente cierre su stream?
34. ¿Qué ocurre si una excepción del servant escapa sin mapear?
35. ¿Por qué un error por mensaje puede formar parte de la respuesta en un stream largo?
36. ¿Qué problema resuelve un interceptor de servidor con `GrpcExceptionHandler`?

## TPE1

37. ¿Cuál es el recorrido posible de un equipaje desde la estación hasta el avión?
38. ¿Qué condiciones deben cumplirse para finalizar el bag-drop de un vuelo?
39. ¿Qué artefactos exactos debe contener la entrega?

## Sistemas distribuidos y big data

40. ¿Qué costo introduce agregar un cache para soportar muchas lecturas sobre una RDBMS?
41. ¿Por qué las queries de agregación rinden mal en una RDBMS orientada a filas?
42. ¿Qué limitación del esquema DW/OLAP impide hacer preguntas nuevas sobre datos viejos?
43. ¿Cuáles son las 3 V de big data y qué significa cada una?
44. ¿Qué tres tipos de tareas se reparten en un sistema distribuido?
45. ¿Qué diferencia hay entre las transparencias de migración y de reubicación?

## Almacenamiento distribuido y Hazelcast

46. ¿Qué tres momentos posibles hay para considerar escrito un dato replicado y cuándo conviene esperar a todas las réplicas?
47. ¿Qué garantiza la consistencia eventual y qué no garantiza?
48. ¿Por qué el Name Node de HDFS era un problema y cómo se resolvió?
49. ¿Cómo elige Hazelcast al coordinador y qué pasa si se cae?
50. ¿En qué partición cae una clave y qué ocurre con esa partición si cae su *owner*?
51. Con tres nodos y un backup, ¿cuántas particiones primarias y de backup tiene aproximadamente cada nodo?
52. ¿Qué se gana y qué se arriesga con réplicas asincrónicas?
53. ¿Para qué sirve el `<group>` de la configuración si dos clusters comparten el mecanismo de discovery?
54. ¿Por qué no se recomienda multicast en producción?
55. ¿Qué pasos sigue Hazelcast para resolver un split brain?
56. ¿Qué necesita una clase para guardarse en una colección distribuida, y qué más si se usa como clave?

## MapReduce

57. ¿Qué etapas se programan y cuál provee el framework?
58. ¿Qué cuatro operaciones puede realizar un mapper sobre los datos?
59. ¿Por qué el reducer de Hazelcast se crea mediante una factory?
60. ¿Qué cláusulas SQL se corresponden con el mapper, el sort/shuffle y el reducer?
61. ¿Por qué MapReduce no puede producir un ordenamiento global y cómo se resuelve?
62. ¿Qué problema resuelve el combiner y qué restricción de tipos impone?
63. ¿En qué se diferencia el ciclo de vida de un combiner del de un reducer?
64. ¿Dónde se ejecuta el collator y qué consecuencia práctica tiene?
65. ¿Qué tienen que tener todos los nodos para ejecutar un job?
66. ¿Qué costo se intercambia al usar `HazelcastInstanceAware` en un mapper?

## APIs alternativas

67. ¿Qué tiene que documentar una API de tira de bytes que otros estilos expresan en un contrato?
68. ¿Qué parte de un mensaje SOAP es obligatoria y dónde viajan los errores?
69. ¿Qué responde un WSDL y qué responde un XSD?
70. ¿Por qué el principio stateless de REST favorece la escalabilidad?
71. ¿Cómo se identifican una colección, un singleton y una subcolección en una URI REST?
72. ¿Qué es HATEOAS?
73. ¿Qué desventaja de REST ataca GraphQL?
74. ¿Qué es el problema N+1 en GraphQL y cómo lo mitiga un batch loader?
75. ¿Qué diferencia a un WebSocket de Server-Sent Events?
76. ¿Por qué un broker de mensajería desacopla productores y consumidores?

## TPE2

77. En la query 1, ¿cómo se tratan las demoras negativas y qué estaciones no se listan?
78. En la query 3, ¿de qué campo sale el día de la semana y de cuál la hora?
79. ¿Cómo se calcula el cuadrante de una estación y en cuál cae Zürich HB con q = 0.1?
80. En la query 4, ¿el puesto en el ranking se calcula antes o después de truncar la media?
81. Un tren para en A (llegada 60 s, salida 60 s), B (180 s, 120 s) y C (300 s, 300 s). ¿Cuál es su efecto bola de nieve?
82. ¿Qué momentos registra `timeX.txt` y con qué formato?
83. ¿Cómo deben llamarse el cluster y las colecciones de Hazelcast, y por qué?
84. ¿Qué tres análisis de tiempos pide el informe?

## Respuestas breves

1. La concurrencia permite avances solapados; el paralelismo exige ejecución simultánea, normalmente sobre varios núcleos. [PC-T01, p. 18]
2. Comparten memoria, descriptores y recursos del proceso; su creación y cambio de contexto cuestan menos que los de procesos separados. [PC-T01, p. 19] [PC-T01, p. 20]
3. `start()` inicia un nuevo thread que ejecutará `run()`; invocar `run()` directamente es una llamada común en el thread actual. La presentación insiste en implementar `run` y ejecutar con `start`. [PC-T01, p. 21] [PC-T01, p. 22]
4. Cuando la tarea debe producir un valor o propagar una excepción; `Runnable` no devuelve resultado. [PC-T01, p. 33]
5. Dejar de aceptar tareas, esperar un tiempo acotado y escalar la cancelación si no termina; también hay que tratar la interrupción del thread que espera. [PC-T01, p. 37] [PC-T01, p. 38]
6. Siempre `A` antes que `B` y `1` antes que `2`; el scheduler puede intercalar ambos pares. [PC-P01, p. 1]
7. Coordinación, consistencia/sincronización y disponibilidad o *liveness*. [PC-T02, p. 4]
8. Porque `count++` combina lectura, cálculo y escritura, y esa secuencia no es atómica. [PC-T02, p. 15]
9. Liberar un monitor ocurre antes que una adquisición posterior del mismo monitor, aportando orden y visibilidad. [PC-T02, p. 14] [PC-T02, p. 16]
10. Deadlock es espera circular; livelock es reintento activo sin progreso; starvation es postergación indefinida por falta de acceso al recurso. [PC-T02, p. 26] [PC-T02, p. 27] [PC-T02, p. 29]
11. `join`, `CountDownLatch` y `CyclicBarrier`, respectivamente. [PC-T02, p. 6] [PC-T02, p. 30]
12. Para liberar el lock incluso si el cuerpo protegido termina con una excepción; la propia diapositiva lo advierte. [PC-T02, p. 21]
13. Porque ningún thread puede alterar ese estado después de la construcción, eliminando interferencia sobre él. [PC-T03, p. 4]
14. Evita que una referencia mutable recibida o devuelta permita modificar indirectamente el estado interno. [PC-T03, p. 5] [PC-T03, p. 7]
15. Ambos extremos comparten una cola: el productor publica y el consumidor toma el mensaje, reduciendo dependencia directa y espera activa. [PC-T03, p. 9] [PC-T03, p. 10]
16. Que los datos puedan dividirse en particiones independientes, producir resultados parciales y combinarse al final. [PC-T03, p. 18] [PC-T03, p. 19]
17. Porque el orden de ejecución no está garantizado y el estado compartido reintroduce interferencia y dependencia del orden. [PC-T03, p. 25]
18. `thenApply` transforma un valor; `thenCompose` encadena una función que devuelve otro futuro; `thenCombine` combina los resultados de dos futuros. [PC-T03, p. 36] [PC-T03, p. 39]
19. La tasa fija intenta conservar el período desde el inicio; el delay fijo espera el intervalo después de que termina cada ejecución. [PC-T03, p. 30]
20. El establecimiento de la comunicación, la serialización, el envío por red, la selección del método remoto, la deserialización y el retorno de la respuesta. [GR-T01, p. 26] [GR-T01, p. 37]
21. El stub representa el servicio en el cliente; el skeleton interpreta y deserializa en el servidor; el servant implementa la lógica de negocio invocada. [GR-T01, p. 28] [GR-T01, p. 29] [GR-T01, p. 37]
22. Define contratos independientes del lenguaje y representa los mensajes como datos binarios tipados con código de serialización generado. [GR-T01, p. 33] [GR-T01, p. 34]
23. Porque el contrato gRPC modela cada método como una comunicación entre mensajes; si no hay datos se usa igualmente un mensaje vacío. [GR-T01, p. 43] [GR-T01, p. 44]
24. Cada campo usa un número positivo único dentro del mensaje; un enum reserva el ordinal `0` para un valor `..._UNSPECIFIED`. [GR-T02, p. 22] [GR-T02, p. 24] [GR-S01, p. 1]
25. Reutilizan mensajes estándar vacíos o de un único valor escalar y evitan duplicar definiciones. [GR-T02, p. 26] [GR-S01, p. 2]
26. `api` concentra contrato y código generado compartido; `client` contiene la invocación y `server` la implementación. [GR-T02, p. 3] [GR-T02, p. 4]
27. `BlockingStub` espera sincrónicamente; `FutureStub` devuelve un futuro; `Stub` usa observers asincrónicos. [GR-T01, p. 45] [GR-T02, p. 29]
28. Consultar la cancelación y detener las tareas internas que ya no producen una respuesta útil. [GR-T02, p. 16]
29. Uno/uno, uno/varios, varios/uno y varios/varios para unario, server streaming, client streaming y bidireccional. [GR-T03, p. 3]
30. `stream` multiplica mensajes de entrada o salida durante una llamada; `repeated` agrupa varios valores dentro de un campo de un solo mensaje. [GR-T03, p. 7] [GR-T03, p. 8]
31. Invoca `onNext` por cada elemento y termina la secuencia con `onCompleted`. [GR-T03, p. 12]
32. Un observer recibe la respuesta y el stub entrega otro observer usado para enviar los requests. [GR-T03, p. 18]
33. Sí. Puede emitir respuestas a medida que procesa requests; no necesita esperar todos los elementos. [GR-T03, p. 22]
34. El cliente recibe una `StatusRuntimeException` con código `UNKNOWN` y no obtiene el detalle original. [GR-T03, p. 28]
35. Porque `onError` corta el stream completo; modelar el fallo en una respuesta permite continuar con los demás mensajes. [GR-T03, p. 31]
36. Centraliza la traducción de excepciones del dominio a códigos y mensajes gRPC significativos. [GR-T03, p. 41] [GR-T03, p. 42] [GR-T03, p. 43]
37. Estación de bag-drop, baggage room, pier, cart y avión; si ya hay pier asignado puede omitir el baggage room. [GR-E01, p. 3]
38. El bag-drop debe estar iniciado, el vuelo debe tener un pier y no deben quedar equipajes del vuelo en el baggage room ni en ese pier. [GR-E01, p. 7] [GR-E01, p. 8]
39. Código Maven sin binarios, README de ejecución, `.git/` con historia e `doc/Informe.pdf` con carátula. [GR-E01, p. 28]
40. Las lecturas cacheadas dejan de cumplir ACID y el cache debe expirarse. [SD-T01, p. 16]
41. El modelo por fila no es óptimo para agregar, las dimensiones no indexadas exigen full scans y los locks se sostienen más tiempo, perjudicando además a las queries concurrentes. [SD-T01, p. 24]
42. No se guarda la historia granular sino sólo lo agregado para los modelos, así que las preguntas quedan predefinidas. [SD-T01, p. 29]
43. Volumen (crecimiento geométrico), velocidad (de generación) y variedad (datos estructurados, semiestructurados y no estructurados). [SD-T01, p. 33] [SD-T01, p. 36]
44. Almacenamiento, procesamiento y responsabilidades. [SD-T01, p. 43]
45. La migración oculta un cambio de ubicación entre usos; la reubicación, un cambio mientras el objeto se está usando. [SD-T01, p. 54]
46. Al escribirse la partición principal, al escribirse la partición y al menos una réplica, o al escribirse todas las réplicas. La última conviene cuando se necesita mucha lectura con datos consistentes, similar a ACID. [HZ-T01, p. 7] [HZ-T01, p. 8]
47. Que, sin escrituras nuevas, todas las lecturas reflejarán el valor escrito después de cierto tiempo; no garantiza que una lectura inmediata lo vea. [HZ-T01, p. 11] [HZ-T01, p. 43]
48. Era un SPOF; HDFS 2.x lo mitigó con federación y 3.x lo resolvió con alta disponibilidad. [HZ-T01, p. 23]
49. Es el miembro más antiguo; si cae, asume el siguiente más viejo y recalcula la tabla de particiones. [HZ-T01, p. 33] [HZ-T01, p. 34]
50. En `hash(clave) % 271`; si cae su *owner*, el nodo con la réplica pasa a ser *owner* y otro nodo recibe una réplica nueva. [HZ-T01, p. 36] [HZ-T01, p. 40]
51. Aproximadamente 271/3 primarias y 271/3 de backup de los otros nodos. [HZ-T01, p. 38]
52. Se gana velocidad de escritura; se arriesga leer datos desactualizados, porque sólo hay consistencia eventual. [HZ-T01, p. 43]
53. Para separar clusters independientes, ya que sólo se unen los nodos con el mismo nombre y password de grupo. [HZ-T01, p. 47] [HZ-T01, p. 61]
54. Porque la comunicación por UDP puede ser problemática y suele estar bloqueada. [HZ-T01, p. 46]
55. Elegir como líder al más viejo de los dos líderes, decidir qué cluster se integra y, por cada miembro de ese cluster, pausar, desconectarse, unirse al otro, combinar sus mapas según la política y reanudar. [HZ-T01, p. 50]
56. Ser serializable, preferentemente con `DataSerializable` y constructor sin parámetros; como clave, además, `equals` y `hashCode`. [HZ-T01, p. 70] [HZ-T03, p. 23] [HZ-T03, p. 27]
57. Se programan map y reduce; sort/shuffle lo provee el framework. [HZ-T02, p. 5]
58. Filtrar, proyectar, expandir y multiplicar. [HZ-T02, p. 7]
59. Porque se instancia un reducer por cada clave única emitida, y la clave es el parámetro de `newReducer`. [HZ-T02, p. 15]
60. El mapper se corresponde con `SELECT` y `WHERE`; el sort/shuffle, con `GROUP BY`; el reducer, con la proyección final, las agregaciones y `HAVING`. [HZ-T02, p. 24]
61. Porque cada reducer emite por clave; se resuelve con post-procesamiento (por ejemplo, un collator) o con un segundo MapReduce encadenado. [HZ-T02, p. 24] [HZ-T03, p. 15]
62. Evita enviar por la red muchos pares similares acumulándolos en el nodo del mapper; su tipo de salida debe coincidir con el de entrada del reducer. [HZ-T03, p. 8] [HZ-T03, p. 9]
63. El combiner emite resultados parciales por chunk con `finalizeChunk` y `reset`; el reducer espera todos los valores de su clave antes de `finalizeReduce`. [HZ-T02, p. 15] [HZ-T03, p. 12]
64. En el nodo cliente; por eso puede recibir colecciones auxiliares directamente por constructor. [HZ-T03, p. 16] [HZ-T03, p. 34]
65. Las clases del job en el CLASSPATH, porque no hay carga dinámica de clases, y la misma configuración para formar el cluster. [HZ-T02, p. 21]
66. Menos tráfico al emitir ids, a cambio de búsquedas que pueden consultar particiones en otros nodos. [HZ-T03, p. 31]
67. Los opcodes, el orden y tipo de cada campo del request y el formato del status y del payload de la respuesta. [API-T01, p. 13] [API-T01, p. 14] [API-T01, p. 15] [API-T01, p. 16]
68. El `Body`; los errores viajan en un `Fault`. [API-T01, p. 21] [API-T01, p. 25]
69. El WSDL responde a qué URL se envía el pedido y qué funciones existen; el XSD, qué campos lleva cada XML y de qué tipo son. [API-T01, p. 29]
70. Porque el cliente envía todo el contexto y distintas instancias del servicio pueden atender llamadas sucesivas del mismo cliente. [API-T01, p. 46] [API-T01, p. 61]
71. `/movies/`, `/movies/{id}` y `/movies/{id}/actors`, respectivamente. [API-T01, p. 53]
72. Hipermedia como motor del estado: las respuestas incluyen links que permiten navegar el servicio desde el primer request. [API-T01, p. 57]
73. Que distintos clientes necesiten distintas facetas de un recurso: en GraphQL el cliente elige qué campos recibir. [API-T01, p. 62] [API-T02, p. 6]
74. Resolver un campo con una consulta por cada elemento de un listado; el batch loader agrupa los pedidos y hace un único llamado con N elementos. [API-T02, p. 20] [API-T02, p. 21]
75. WebSocket es full duplex; SSE es unidireccional del servidor al cliente y se reconecta solo. [API-T02, p. 31] [API-T02, p. 32]
76. Porque el productor deja el mensaje en el broker y se desentiende; el mensaje persiste hasta que un consumidor lo procesa, aunque algún servicio se caiga. [API-T02, p. 33]
77. Los adelantos cuentan como 0 s y no compensan los atrasos. No se listan las estaciones ausentes del archivo de estaciones ni las que no tienen servicios. [HZ-E01]
78. El día sale de la fecha operativa y la hora, de la salida prevista. [HZ-E01]
79. Es (⌊lat / q⌋, ⌊lon / q⌋); Zürich HB cae en (473, 85). [HZ-E01]
80. Antes: la posición se calcula con el valor completo y después se trunca a dos decimales. [HZ-E01]
81. (180 − 60) + (300 − 120) = 300 s. [HZ-E01]
82. Inicio y fin de la lectura (el fin incluye la subida al cluster) e inicio y fin de cada job (el fin del último incluye la escritura de la respuesta), con formato `dd/MM/yyyy HH:mm:ss:SSS`. [HZ-E01]
83. Deben empezar con `g` y el número de grupo, para no chocar con las colecciones de otros grupos que prueban en la misma red. [HZ-E01]
84. Tiempos según la cantidad de nodos (hasta cinco), con y sin combiner, y con y sin una optimización elegida por el grupo. [HZ-E01]
