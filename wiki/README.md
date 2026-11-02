# Wiki de la materia

Este es el índice del conocimiento canónico compilado de Programación de Objetos Distribuidos. El material incorporado cubre programación concurrente con Java, fundamentos de sistemas distribuidos, gRPC, Protocol Buffers, streaming, el TPE1 de gestión de equipajes, almacenamiento distribuido con Hazelcast, MapReduce, el TPE2 de servicios de trenes y estilos alternativos de API.

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
- [Sistemas distribuidos: de la RDBMS al escalamiento horizontal](temas/sistemas-distribuidos-y-big-data.md): límites de la RDBMS, BI/OLAP/ETL, big data y las 3 V, características de un sistema distribuido, RM-ODP y transparencias.
- [Almacenamiento distribuido y HDFS](temas/almacenamiento-distribuido-y-hdfs.md): particionado, replicación, consistencia, elasticidad, tolerancia a fallos y HDFS.
- [Hazelcast: cluster, configuración y estructuras](temas/hazelcast-cluster-y-estructuras.md): nodos, coordinador, 271 particiones, réplicas, configuración XML y Java, split brain, serialización y estructuras distribuidas.
- [MapReduce con Hazelcast](temas/mapreduce-con-hazelcast.md): modelo map/sort/reduce, API de jobs, key predicate, combiner, collator, `HazelcastInstanceAware` y ejercicios.
- [TPE2: servicios de trenes](temas/tpe2-servicios-de-trenes.md): datasets de Suiza y Bélgica, las seis queries MapReduce, invocación, informe, entrega y cronograma.
- [APIs alternativas](temas/apis-alternativas.md): tira de bytes, SOAP/WSDL, REST/HATEOAS, GraphQL con resolvers y batch loaders, y APIs de eventos.

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
| `SD-T01` | Teoría | Sistemas distribuidos | Límites de la RDBMS, BI, big data, características y RM-ODP, 62 páginas. |
| `HZ-T01` | Teoría | Store distribuido | Particionado, replicación, consistencia, HDFS y Hazelcast con ejercicios 1 a 4, 83 páginas. |
| `HZ-G01` | Guía | Configuración Java de Hazelcast | Server, cliente, tests y Management Center; documento rotulado 2023, 6 páginas. |
| `HZ-C01` | Código de apoyo | `hazelcast.xml` | Configuración por defecto de 3.8 que el ejercicio 3 pide modificar. |
| `HZ-C02` | Herramienta | `hazelcast-all-3.8.6.jar` | Distribución de Hazelcast indicada por la cátedra; binario preservado sin extraer. |
| `HZ-T02` | Teoría | MapReduce I | Modelo, mapper, reducer, job tracker y word count, 26 páginas. |
| `HZ-T03` | Teoría | MapReduce II | Key predicate, combiner, collator, alquiler de bicicletas y `HazelcastInstanceAware`, 37 páginas. |
| `HZ-R01` | Referencias | Repositorio `hz-store` | Enlace del ejercicio 4 de Hazelcast, sin descargar. |
| `HZ-R02` | Referencias | Repositorio `word-count` | Template de MapReduce I, sin descargar. |
| `HZ-R03` | Referencias | Repositorio `bike-rentals` | Template de MapReduce II, sin descargar. |
| `HZ-E01` | Entrega | TPE2: servicios de trenes | Consigna evaluada en Markdown, con seis queries MapReduce sobre Hazelcast; sin páginas. |
| `HZ-D01` | Dataset | `stationsCH(in).csv` | 1539 estaciones de Suiza; la copia tiene las coordenadas dañadas. |
| `HZ-D02` | Dataset | `stationsBE(in).csv` | 538 estaciones de Bélgica. |
| `HZ-R04` | Referencias | Repositorio `tpe2-26Q2-g0` | Enlace al template del TPE2, sin descargar. |
| `API-T01` | Teoría | APIs alternativas 1 | Tira de bytes, SOAP y REST sobre un servicio común, 63 páginas. |
| `API-T02` | Teoría | APIs alternativas 2 | GraphQL y APIs de eventos, 35 páginas. |
| `API-C01` | Código de apoyo | Proyecto `graphql-intro` | Spring for GraphQL con esquema, DAOs en memoria y controladores para los ejercicios. |

Los PDFs están disponibles como originales preservados y como texto extraído página por página. Los ZIP se preservan como originales y tienen una copia descomprimida regenerable en `material/extraido/` para permitir búsquedas sobre el código. Los listados y archivos de enlaces se mantienen como fuentes textuales oficiales; su contenido remoto no fue incorporado. El archivo `hazelcast.xml` ya es buscable como texto. El jar de Hazelcast es una biblioteca binaria: se preserva con su checksum, pero no tiene derivado. La copia descomprimida de `graphql-intro` omite el wrapper de Maven y el `.gitignore` del proyecto.

La consigna del TPE2 es un Markdown con la foto de portada embebida en base64; `material/extraido/HZ-E01.txt` es una copia sin esa imagen, para que las búsquedas no devuelvan ruido. Los CSV de estaciones del TPE2 se versionan porque son chicos. Los ZIP de servicios (`trainsCH.csv.zip`, `trainsBE.csv.zip`) no se versionan ni se catalogan: viven en `laboratorio/tpe2/data/`, ignorado por git, y `laboratorio/tpe2/README.md` registra su procedencia y sus checksums.
