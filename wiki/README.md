# Wiki de la materia

Este es el índice del conocimiento canónico compilado de Programación de Objetos Distribuidos. El material incorporado cubre programación concurrente con Java, fundamentos de sistemas distribuidos, gRPC, Protocol Buffers, streaming y el TPE1 de gestión de equipajes.

## Navegación

- [Glosario](glosario.md)
- [Dudas y conflictos](dudas-y-conflictos.md)
- [Preguntas de repaso](repaso/preguntas.md)

## Temas

- [Concurrencia y threads](temas/concurrencia-y-threads.md): procesos, concurrencia frente a paralelismo, ciclo de vida, `Runnable`, `Callable`, `Future` y `ExecutorService`.
- [Thread safety y coordinación](temas/thread-safety-y-coordinacion.md): memoria compartida, *happens-before*, monitores, locks, atómicos, colecciones concurrentes y problemas de *liveness*.
- [Alternativas y futuros componibles](temas/alternativas-y-completable-future.md): inmutabilidad, pub/sub, particionado, streams paralelos, tareas programadas y `CompletableFuture`.
- [Fundamentos de sistemas distribuidos y gRPC](temas/grpc-fundamentos-y-patrones.md): cliente/servidor, middleware, RPC, Protocol Buffers, Spring gRPC, stubs, deadlines y health checks.
- [gRPC: streaming, errores e interceptores](temas/grpc-streaming-y-errores.md): cuatro cardinalidades, `StreamObserver`, statuses, detalles de error e interceptores.
- [TPE1: gestión de equipajes en aeropuertos](temas/tpe1-gestion-de-equipajes.md): dominio, servicios, invariantes, restricciones técnicas, entrega y cronograma.

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
| `GR-T01` | Teoría | Introducción a gRPC | Sistemas distribuidos, cliente/servidor, IPC, RPC, Protobuf y Spring gRPC, 58 páginas. |
| `GR-T02` | Teoría | gRPC Communication Patterns | Módulos, empaquetado, deadlines, health, Protobuf y stubs asincrónicos, 36 páginas. |
| `GR-T03` | Teoría | gRPC Streaming | Cuatro patrones, errores, interceptores y mapeo global, 44 páginas. |
| `GR-P01` | Práctica | TP gRPC Communication Patterns | Contratos `.proto` y servicio unario, 2 páginas. |
| `GR-S01` | Solución | Solución del TP Communication Patterns | Contrato, servant, servidor y cliente de referencia, 5 páginas. |
| `GR-P02` | Práctica | TP gRPC III | Biblioteca concurrente y recitales con notificaciones, 5 páginas. |
| `GR-E01` | Entrega | TPE1: gestión de equipajes | Consigna evaluada, requisitos y cronograma, 29 páginas. |
| `GR-R01` | Referencias | Repositorios provistos por la cátedra | Enlaces preservados sin descargar su contenido. |

Los PDFs están disponibles como originales preservados y como texto extraído página por página. Los ZIP se preservan como originales y tienen una copia descomprimida regenerable en `material/extraido/` para permitir búsquedas sobre el código. El listado de enlaces se mantiene como fuente textual oficial; su contenido remoto no fue incorporado.
