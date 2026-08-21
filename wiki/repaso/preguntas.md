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
