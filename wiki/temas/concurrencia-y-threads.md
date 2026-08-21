# Concurrencia y threads

## Idea central

Un programa es una secuencia estática de instrucciones; un proceso es ese programa en ejecución, con memoria y recursos asignados por el sistema operativo. [PC-T01, p. 3] En un procesador único, el *time slicing* y el cambio de contexto intercalan procesos para mejorar el tiempo de respuesta percibido, aunque un proceso aislado no se acelera por ese mero intercalado. [PC-T01, p. 12] [PC-T01, p. 16]

La programación concurrente separa un algoritmo en zonas que pueden avanzar de manera independiente mediante threads. Si el hardware tiene varios núcleos, algunas de esas zonas pueden además ejecutarse en paralelo; por eso **concurrente** y **paralelo** no significan lo mismo. [PC-T01, p. 18]

## Proceso frente a thread

| Aspecto | Proceso | Thread |
|---|---|---|
| Unidad | Programa en ejecución. | Subunidad de ejecución dentro de un proceso. |
| Memoria y recursos | Tiene recursos asignados por el sistema operativo. | Comparte memoria, descriptores y otros recursos del proceso. |
| Comunicación | Requiere mecanismos de IPC para comunicarse con otros procesos. | Puede comunicarse mediante el estado compartido del proceso. |
| Costo | Crear y cambiar procesos tiene mayor sobrecarga. | Crear y cambiar threads requiere menos tiempo y recursos. |
| Gestión | El sistema operativo administra su ejecución. | El programa debe controlar inicio y finalización. |

La comparación corresponde al modelo presentado por la cátedra. [PC-T01, p. 19] [PC-T01, p. 20]

## Threads en Java

Hay dos formas introductorias de expresar una tarea:

- Extender `Thread` e implementar `run()`. Limita la herencia disponible y por eso es la opción menos general. [PC-T01, p. 21]
- Implementar `Runnable`, construir un `Thread` con esa tarea y llamar a `start()`. [PC-T01, p. 22]

`start()` inicia la ejecución concurrente; `run()` contiene el trabajo. Entre las operaciones estáticas relevantes aparecen `currentThread()`, `sleep()`, `interrupted()`, `yield()` y `holdsLock()`. Entre las de instancia aparecen `interrupt()`, `isAlive()` y `join()`: esta última bloquea al thread invocante hasta que finaliza el thread observado. [PC-T01, p. 23] [PC-T01, p. 25]

La figura de ciclo de vida muestra la progresión conceptual desde creación y estado nuevo hacia listo/ejecutando, con desvíos por espera, sueño o bloqueo, y una terminación final. [PC-T01, p. 29] La correspondencia exacta de los rótulos del diagrama con `Thread.State` quedó registrada en [Dudas y conflictos](../dudas-y-conflictos.md).

## Tareas con resultado y ejecutores

Java incorpora tres abstracciones que separan la tarea de cómo se ejecuta: [PC-T01, p. 32]

- `Callable<V>` representa trabajo que devuelve un valor y puede lanzar una excepción. [PC-T01, p. 33]
- `Future<V>` representa el estado y resultado eventual de una tarea: permite consultar finalización, cancelar y obtener mediante `get()`, incluso con timeout. [PC-T01, p. 34]
- `ExecutorService` recibe `Runnable` o `Callable`, entrega `Future`, puede ejecutar colecciones de tareas y administra el ciclo de vida del ejecutor. [PC-T01, p. 35] [PC-T01, p. 36] [PC-T01, p. 37]

Un *thread pool* reutiliza threads ya creados para varias tareas. `Executors` ofrece, entre otros, pools cacheados, fijos, de un solo thread y programados. [PC-T01, p. 39] [PC-T01, p. 40]

El patrón de cierre mostrado es: solicitar `shutdown()`, esperar con `awaitTermination` y, si vence el plazo o el thread que espera es interrumpido, invocar `shutdownNow()`. [PC-T01, p. 38] La precisión semántica entre ambas operaciones quedó marcada como punto a verificar.

## Práctica asociada

El TP propone:

1. Enumerar intercalados posibles de dos tareas respetando el orden interno `A → B` y `1 → 2`. [PC-P01, p. 1]
2. Observar estados alrededor de `start`, `sleep`, `wait`, `notifyAll` y `join`. [PC-P01, p. 2]
3. Comparar pools cacheados, fijos, unitarios y una política de rechazo. [PC-P01, p. 3]
4. Construir una simulación de atención con recepcionistas y empleados modelados como `Callable`, colas por prioridad y varios threads. [PC-P01, p. 4] [PC-P01, p. 5]

El proyecto de apoyo `PC-C01` aporta un `GenericService`, tests iniciales y esqueletos incompletos para continuar los ejercicios. [PC-C01]

## Conexiones

- El estado compartido entre threads conduce a los problemas de [thread safety y coordinación](thread-safety-y-coordinacion.md).
- `Future` se extiende con composición y encadenamiento en [Alternativas y futuros componibles](alternativas-y-completable-future.md#completablefuture).
