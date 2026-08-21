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
