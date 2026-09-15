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
