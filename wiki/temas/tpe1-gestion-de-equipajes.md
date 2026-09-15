# TPE1: gestión de equipajes en aeropuertos

## Objetivo y modelo del dominio

El TPE1 pide implementar en grupo un sistema remoto multithreaded y thread-safe que siga un equipaje desde su despacho en una estación de *bag-drop* hasta su carga en el avión. [GR-E01, p. 3]

El recorrido normal es:

`estación de bag-drop → baggage room → pier → cart → avión`

Si el vuelo ya tiene un pier asignado, los nuevos equipajes aceptados van directamente al pier. Un vuelo admite un solo pier; un cart puede hacer varios viajes para el mismo pier y vuelo. [GR-E01, p. 3] Las imágenes de la terminología confirman qué representan la estación, el bag-tag, el pier, la cinta y el cart. [GR-E01, p. 4]

## Servicios y clientes

La separación entre cliente y servicio es parte de la consigna: la lógica debe ubicarse donde corresponda y cada servicio podría tener consumidores implementados con tecnologías distintas. [GR-E01, p. 5]

| Área | Cliente | Operaciones principales |
|---|---|---|
| Administración de equipajes | `bagAdmin.sh` | agregar piers y carts; asignar un pier a un vuelo |
| Gestión de vuelos | `flightManagement.sh` | agregar vuelos; iniciar/finalizar bag-drop; encender/apagar estaciones |
| Despacho | `bagDrop.sh` | consultar franquicia; despachar; consultar ubicación por bag-tag |
| Rampa | `ramp.sh` | asignar/liberar carts; cargar desde pier; descargar al avión |
| Seguimiento | `track.sh` | iniciar/finalizar seguimiento; listar equipajes cargados o pendientes; dashboards |

La tabla sintetiza las cinco áreas y sus scripts obligatorios. [GR-E01, p. 5] [GR-E01, p. 6] [GR-E01, p. 10] [GR-E01, p. 15] [GR-E01, p. 18]

## Estados e invariantes centrales

- Un vuelo nace sin pier y con el bag-drop no iniciado. El manifiesto fija pasajeros y, para cada uno, cantidad y peso máximo por equipaje. [GR-E01, p. 6] [GR-E01, p. 7]
- El bag-drop de un vuelo progresa `NOT_STARTED → STARTED → ENDED`; no se reinicia. Para finalizarlo, el vuelo debe tener pier y no deben quedar equipajes del vuelo ni en el baggage room ni en ese pier. Al finalizar se libera el pier, pero los carts conservan su asignación. [GR-E01, p. 7] [GR-E01, p. 8]
- Cada estación encendida recibe un UUID v4 y publica en tiempo real los bag-tags aceptados. No puede apagarse ni compartirse mientras una operación de despacho la está usando. [GR-E01, p. 8] [GR-E01, p. 9]
- Los bag-tags usan una numeración incremental compartida por todas las estaciones. Un despacho valida vuelo, pasajero, estación, estado del bag-drop, franquicia y peso. [GR-E01, p. 11]
- La consulta de un bag-tag muestra una única ubicación actual entre baggage room, pier, cart y avión. [GR-E01, p. 13] [GR-E01, p. 14] [GR-E01, p. 15]
- Un cart solo mueve equipajes compatibles con su asignación y capacidad; la descarga al avión actualiza la ubicación de cada bag-tag. [GR-E01, p. 16] [GR-E01, p. 17] [GR-E01, p. 18]
- El seguimiento informa eventos del vuelo hasta que se lo finaliza. Los reportes distinguen equipajes cargados y pendientes; dos dashboards adicionales aplican solo a grupos de cinco integrantes. [GR-E01, p. 18] [GR-E01, p. 21] [GR-E01, p. 22] [GR-E01, p. 23] [GR-E01, p. 24]

Las condiciones de error y los formatos de salida son parte del contrato observable. Antes de implementar una operación hay que releer su sección completa en la fuente, porque este resumen no reemplaza las validaciones ni los ejemplos de consola.

## Restricciones técnicas

La entrega exige Spring gRPC 1.0.2, Java 25 LTS, atención concurrente de clientes y cinco aplicaciones de consola con scripts Bash independientes. Los nombres de scripts, parámetros y formatos de salida deben respetarse exactamente. Todos los `pom.xml` deben usar el nombre `tpe1-gX-Z`, donde `Z` es `parent`, `api`, `server` o `client`. [GR-E01, p. 26]

No se requiere persistencia entre ejecuciones y los parámetros de cliente no contienen espacios. Ante una falla, cada cliente debe capturar el error y mostrar un mensaje apropiado en la salida estándar. [GR-E01, p. 26]

El informe debe justificar decisiones de diseño, explicar cómo se protegieron las secciones concurrentes y qué alternativas se descartaron, y proponer mejoras sin usar persistencia ni tests como sugerencias. [GR-E01, p. 27]

## Entrega y aprobación

El archivo compactado debe incluir:

- código fuente Maven separado en `api`, `client` y `server`, sin binarios;
- `README.md` con build y ejemplos para ejecutar servidor y los cinco clientes;
- el directorio `.git/` con la historia real de trabajo;
- `doc/Informe.pdf` con carátula e integrantes. [GR-E01, p. 28]

La falta de alguno de esos elementos, una compilación fallida, servicios o clientes que no inician siguiendo el README, una entrega fuera de término o un historial reducido a un único commit total impiden la aprobación. Luego se evalúan funcionalidad, pruebas y coloquio, aplicación de concurrencia y gRPC, diseño, modularización, reutilización e informe. [GR-E01, p. 28]

El cronograma impreso indica presentación el 9 de septiembre, entrega el 24 de septiembre a las 23:59, coloquio el 30 de septiembre y recuperatorio el 25 de noviembre. [GR-E01, p. 29] El pie de página dice `2026 1C`, mientras el listado de repositorios nombra el template `tpe1-26Q2-g0`; la discrepancia está registrada en [Dudas y conflictos](../dudas-y-conflictos.md). [GR-R01]

## Referencia disponible

La cátedra proveyó un enlace al repositorio template `tpe1-26Q2-g0`. Se catalogó el listado que contiene ese enlace, pero no se descargó ni se inspeccionó el repositorio remoto. [GR-R01]

