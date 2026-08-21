# Alternativas y futuros componibles

## Reducir la sincronización

Sincronizar todo puede introducir sobre-sincronización, bloqueos y presión sobre memoria. La tercera presentación organiza tres alternativas: objetos inmutables, comunicación pub/sub y subprocesamientos independientes. [PC-T03, p. 3]

## Inmutabilidad

Un objeto inmutable no cambia de estado después de construirse, por lo que threads competidores no pueden corromperlo mediante escrituras concurrentes. [PC-T03, p. 4]

Para conseguirlo, el material recomienda:

- campos privados y finales, sin setters;
- impedir que subclases reemplacen el comportamiento relevante;
- no modificar ni dejar escapar referencias mutables internas. [PC-T03, p. 5]

La última condición requiere copias defensivas tanto al recibir como al devolver objetos mutables. El ejemplo copia `Date` en el constructor y en el getter. [PC-T03, p. 7] El proyecto `PC-C03` incluye un `SubscriberTest` que intenta alterar la fecha y la lista de suscripciones desde fuera para guiar esa corrección. [PC-C03]

## Pub/sub con colas

Productor y consumidor comparten una cola: el productor publica al completar una tarea y el consumidor espera o toma el mensaje antes de iniciar la propia. Esto reduce el acoplamiento directo y puede evitar espera activa, `notifyAll` y locks manuales. [PC-T03, p. 9] [PC-T03, p. 10]

La elección de cola define capacidad, orden y bloqueo. El material contrasta `ArrayBlockingQueue`, `LinkedBlockingQueue`, `PriorityBlockingQueue`, `DelayQueue`, `LinkedTransferQueue`, `SynchronousQueue` y `ConcurrentLinkedQueue`. [PC-T03, p. 11] La descripción concreta de `SynchronousQueue` quedó señalada en [Dudas y conflictos](../dudas-y-conflictos.md).

El ejemplo implementa productor y consumidor como `Runnable`, usa `put`/`take` y ejecuta ambos con un pool. [PC-T03, p. 13] [PC-T03, p. 14] [PC-T03, p. 15] El proyecto asociado amplía el patrón con varios productores, consumidores, una `LinkedBlockingQueue` acotada y *poison pills* de finalización. [PC-C03]

## Particionar trabajo

Una tarea paralelizable puede dividir datos en particiones independientes, procesar cada una en un worker y combinar resultados parciales. Así se reduce la interferencia y se reutilizan workers, aunque describir correctamente la partición puede ser difícil. [PC-T03, p. 18] [PC-T03, p. 19]

La presentación ilustra esta estructura con el árbol de partición y combinación de mergesort. [PC-T03, p. 20] La misma idea se proyecta a workers en nodos distintos, anticipando programación distribuida. [PC-T03, p. 21]

Los streams paralelos delegan la división y ejecución al `ForkJoinPool`. Como el orden no está garantizado, las operaciones deberían evitar efectos laterales y estado interno. La solución genérica tampoco garantiza acelerar entradas pequeñas: el costo de dividir, coordinar y combinar puede superar el beneficio. [PC-T03, p. 22] [PC-T03, p. 24] [PC-T03, p. 25]

## Tareas programadas

`ScheduledFuture` combina las capacidades de `Future` con un delay. Se crea a través de un `ScheduledExecutorService`. [PC-T03, p. 27] [PC-T03, p. 28] [PC-T03, p. 29]

- `schedule` ejecuta una vez después del retraso.
- `scheduleAtFixedRate` intenta iniciar periódicamente según una tasa fija.
- `scheduleWithFixedDelay` espera el intervalo indicado desde el fin de una ejecución hasta la siguiente. [PC-T03, p. 29] [PC-T03, p. 30]

Las repeticiones terminan al cancelar la tarea o cerrar el ejecutor. [PC-T03, p. 30]

## CompletableFuture

`CompletableFuture` es un `Future` que puede completarse programáticamente y, por implementar `CompletionStage`, puede encadenarse y combinarse. Se puede completar con valor o excepción, construir ya resuelto, o lanzar tareas con `runAsync` y `supplyAsync`. Sin ejecutor explícito, las variantes mostradas usan el pool común de fork/join. [PC-T03, p. 33] [PC-T03, p. 34]

Operaciones centrales:

| Necesidad | Operación | Resultado |
|---|---|---|
| Ejecutar sin consumir el valor | `thenRun` | Futuro de una acción posterior. [PC-T03, p. 35] |
| Consumir el valor | `thenAccept` | Futuro que completa tras el consumidor. [PC-T03, p. 35] |
| Transformar el valor | `thenApply` | Futuro del valor transformado. [PC-T03, p. 36] |
| Encadenar una operación que ya devuelve futuro | `thenCompose` | Futuro aplanado, sin anidamiento. [PC-T03, p. 36] |
| Recuperar una excepción | `exceptionally` | Valor alternativo derivado del error. [PC-T03, p. 37] |
| Observar éxito o error | `whenComplete` | Conserva el resultado para etapas posteriores. [PC-T03, p. 38] |
| Combinar dos resultados | `thenCombine` | Futuro producido por una función de ambos valores. [PC-T03, p. 39] |
| Continuar con el primero | `applyToEither` | Futuro derivado del primer resultado disponible. [PC-T03, p. 40] |

Las variantes `Async` permiten desplazar la continuación a otro thread, usando el pool común o un ejecutor provisto. [PC-T03, p. 36]

## Práctica asociada

El TP pide paralelizar notificaciones con `parallelStream` y luego con `CompletableFuture`, manteniendo independiente la notificación a marketing. [PC-P03, p. 1] [PC-P03, p. 2] También retoma el contador de archivos: crea futuros separados para cantidad de líneas y tamaño, los combina en una línea de salida y acumula resultados al completar cada archivo. [PC-P03, p. 2]

El proyecto `PC-C03` ofrece puntos de partida para probar inmutabilidad, pub/sub, `parallelSort` y tareas programadas. [PC-C03] El proyecto previo `PC-C02` agrega ejemplos ejecutables de creación, composición, combinación y manejo de errores de `CompletableFuture`. [PC-C02]
