# Thread safety y coordinación

## El problema del estado compartido

Los threads de un proceso se comunican naturalmente mediante variables de instancia o estáticas compartidas. Esa eficiencia abre tres frentes: coordinación, consistencia/sincronización y disponibilidad o *liveness*. [PC-T02, p. 4] [PC-T02, p. 5]

`Thread#join` permite esperar el fin de otro thread. Comunicar una bandera o un resultado mediante memoria compartida parece más flexible, pero exige garantías explícitas de visibilidad y atomicidad. [PC-T02, p. 6] [PC-T02, p. 7] [PC-T02, p. 9]

## Accesos compartidos y happens-before

Hay dos fallas fundamentales:

- **Interferencia:** dos threads pisan o pierden actualizaciones sobre el mismo estado. [PC-T02, p. 11]
- **Visibilidad:** una lectura puede no observar lo escrito por otro thread aunque parezca anterior en el tiempo. [PC-T02, p. 12]

La relación *happens-before* establece el orden relevante. La cátedra enumera estas garantías: el orden del programa dentro de un thread; liberar y luego adquirir el mismo monitor; escribir y luego leer el mismo campo `volatile`; llamar a `start()` antes de las acciones del thread iniciado; y terminar un thread antes de que continúe otro que hizo `join()`. [PC-T02, p. 13] [PC-T02, p. 14]

Las lecturas/escrituras simples indicadas como atómicas no vuelven atómica una operación compuesta. En particular, `++` sigue siendo una secuencia de leer, incrementar y escribir, incluso sobre un campo `volatile`. [PC-T02, p. 15]

## Exclusión y estructuras seguras

Un bloque `synchronized(lock)` adquiere el monitor asociado a `lock`; otro thread que necesite ese mismo monitor queda bloqueado. Al liberarlo y readquirirlo se crea una relación *happens-before*. Los monitores son reentrantes para el thread propietario. [PC-T02, p. 16] [PC-T02, p. 17]

Un método de instancia `synchronized` equivale a sincronizar su cuerpo sobre `this`; para estado estático debe considerarse el monitor del objeto `Class`. Conviene mantener pequeña la sección crítica. [PC-T02, p. 18] [PC-T02, p. 19]

Herramientas de mayor nivel:

- `Lock`, `ReentrantLock`, `ReadWriteLock`, `ReentrantReadWriteLock` y `StampedLock` permiten semánticas más ricas; la liberación debe protegerse normalmente con `finally`. [PC-T02, p. 21]
- `AtomicInteger`, `AtomicLong`, acumuladores y referencias atómicas ofrecen operaciones thread-safe sin locks explícitos. [PC-T02, p. 22]
- Colas bloqueantes y colecciones como `ConcurrentHashMap` o `CopyOnWriteArrayList` evitan reinventar sincronización básica. [PC-T02, p. 23] [PC-T02, p. 24]

## Liveness

| Problema | Qué ocurre | Señal característica |
|---|---|---|
| Deadlock | Dos threads conservan locks cruzados y esperan el que posee el otro. | Ninguno puede continuar ni liberar lo que ya tomó. [PC-T02, p. 26] |
| Livelock | Los threads liberan, revierten y reintentan para evitar bloquearse. | Hay actividad, pero el sistema no progresa. [PC-T02, p. 27] [PC-T02, p. 28] |
| Starvation | Un thread no consigue el recurso porque otros lo acaparan o reciben prioridad. | Algún participante queda postergado indefinidamente. [PC-T02, p. 29] |

Los timeouts acotan esperas potencialmente infinitas. El material recomienda variantes bloqueantes con plazo y una política explícita de reintentos y error. [PC-T02, p. 33]

## Coordinadores

- `Semaphore` limita el acceso mediante una cantidad de permisos. [PC-T02, p. 30] [PC-T02, p. 31]
- `Condition` permite esperar una condición asociada a un lock. [PC-T02, p. 30]
- `CountDownLatch` libera al que espera cuando el contador llega a cero. [PC-T02, p. 30] [PC-T02, p. 32]
- `CyclicBarrier` hace que `n` threads se encuentren en un punto común y puede reutilizarse en nuevas fases. [PC-T02, p. 30]

El proyecto `PC-C02` contiene implementaciones y tests para contadores sincronizados y atómicos, `ReentrantReadWriteLock`, `CountDownLatch`, `CyclicBarrier`, semáforos, condiciones, deadlock, livelock y starvation. [PC-C02]

## Práctica asociada

El TP pide justificar la equivalencia entre un método estático `synchronized` y un bloque sobre `A.class`, reproducir y corregir una pila insegura, y diagnosticar varios diseños concurrentes. [PC-P02, p. 1] [PC-P02, p. 2] [PC-P02, p. 3] El último ejercicio paraleliza el conteo de líneas de un directorio usando una tarea por archivo y combina los resultados al final. [PC-P02, p. 4]

Como criterio transversal, no alcanza con preguntar “¿hay un lock?”: hay que verificar que todos los accesos al mismo invariante usen el mismo mecanismo, que el monitor no cambie de identidad, que el orden de adquisición sea consistente y que ninguna espera pueda quedar sin salida.

## Conexiones

- Los mecanismos básicos de ejecución están en [Concurrencia y threads](concurrencia-y-threads.md).
- Inmutabilidad, colas y particiones reducen la necesidad de compartir estado mutable; véase [Alternativas y futuros componibles](alternativas-y-completable-future.md).
