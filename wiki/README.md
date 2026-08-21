# Wiki de la materia

Este es el índice del conocimiento canónico compilado de Programación de Objetos Distribuidos. La primera unidad incorporada cubre programación concurrente con Java, desde threads y ejecutores hasta seguridad, coordinación y alternativas a la sincronización.

## Navegación

- [Glosario](glosario.md)
- [Dudas y conflictos](dudas-y-conflictos.md)
- [Preguntas de repaso](repaso/preguntas.md)

## Temas

- [Concurrencia y threads](temas/concurrencia-y-threads.md): procesos, concurrencia frente a paralelismo, ciclo de vida, `Runnable`, `Callable`, `Future` y `ExecutorService`.
- [Thread safety y coordinación](temas/thread-safety-y-coordinacion.md): memoria compartida, *happens-before*, monitores, locks, atómicos, colecciones concurrentes y problemas de *liveness*.
- [Alternativas y futuros componibles](temas/alternativas-y-completable-future.md): inmutabilidad, pub/sub, particionado, streams paralelos, tareas programadas y `CompletableFuture`.

## Material incorporado

| ID | Clase | Contenido | Relación |
|---|---|---|---|
| `PC-T01` | Teoría | Programación concurrente y threads | Base conceptual de la unidad, 47 páginas. |
| `PC-P01` | Práctica | TP de threads | Cuatro ejercicios de intercalado, estados, ejecutores y simulación. |
| `PC-C01` | Código de apoyo | Proyecto `concurrency` | Esqueleto Java/Maven asociado a la primera presentación. |
| `PC-T02` | Teoría | Thread safety | Coordinación, consistencia, sincronización y liveness, 35 páginas. |
| `PC-P02` | Práctica | TP de thread safety | Cinco ejercicios de diagnóstico e implementación. |
| `PC-C02` | Código de apoyo | Proyecto `thread-safety` | Ejemplos Java/Maven de locks, atómicos, coordinación y liveness. |
| `PC-T03` | Teoría | Alternativas a la sincronización | Inmutabilidad, pub/sub, particionado y futuros, 43 páginas. |
| `PC-P03` | Práctica | TP de alternativas | Dos ejercicios con streams paralelos y `CompletableFuture`. |
| `PC-C03` | Código de apoyo | Proyecto `concurrency-iii` | Ejercicios base de inmutabilidad, pub/sub, ordenamiento y scheduling. |

Los PDFs están disponibles como originales preservados y como texto extraído página por página. Los ZIP se preservan como originales y tienen una copia descomprimida regenerable en `material/extraido/` para permitir búsquedas sobre el código.
