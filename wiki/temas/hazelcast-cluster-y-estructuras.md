# Hazelcast: cluster, configuración y estructuras distribuidas

Hazelcast es un grid de datos en memoria, distribuido y open source, escrito en Java con dependencias mínimas. Puede correr embebido o en una arquitectura cliente/servidor. [HZ-T01, p. 26] La materia usa la versión **3.8.6**; la cátedra distribuye el jar `hazelcast-all-3.8.6.jar` y la guía de configuración pide explícitamente esa versión. [HZ-T01, p. 29] [HZ-G01, p. 4] [HZ-C02]

Los conceptos generales de particionado, replicación y consistencia están en [Almacenamiento distribuido y HDFS](almacenamiento-distribuido-y-hdfs.md).

## Modelo de datos

Hazelcast redefine estructuras de datos respetando las interfaces de Java: `IMap`, `IList`, `IQueue`, `ITopic`, entre otras. Para que los datos se distribuyan hay que usar estas estructuras; una colección tradicional sólo existe en el nodo que la declara. [HZ-T01, p. 27]

Cuando el tipo tiene equivalente en el lenguaje, se intenta conservar su semántica. Por ejemplo, `IMap<K, V>` extiende `ConcurrentMap<K, V>`, así que se puede usar como si no fuera distribuido. [HZ-T01, p. 74] Este es un ejemplo concreto de la transparencia de acceso de RM-ODP descrita en [Sistemas distribuidos](sistemas-distribuidos-y-big-data.md#transparencias) (**inferencia** que conecta ambas unidades).

Los tipos distribuidos que lista la cátedra son Map, MultiMap, Cache, Queue, Ringbuffer, Set, List, Replicated Map, Cardinality Estimator, Topic, Lock, Semaphore, AtomicLong, AtomicReference, IdGenerator y CountDownLatch. [HZ-T01, p. 73] Los casos de uso señalados incluyen data grid en memoria, caching, microservicios, *clustering* de sesiones web, mensajería, NoSQL en memoria, escalado de aplicaciones y procesamiento distribuido. [HZ-T01, p. 28]

## Tipos de nodo

| Tipo | Guarda datos | Rol |
|---|---|---|
| Member (*node member*) | Sí | Tipo por defecto: guarda datos distribuidos y ejecuta tareas distribuidas. |
| Lite member | No | Lanza tareas y otras acciones, como registrar *listeners*. |
| Native client | No es nodo del cluster | Se conecta al cluster en modo cliente/servidor para poner datos o pedir ejecuciones. |

Fuente: [HZ-T01, p. 32]

## Coordinación

El cluster es *peer-to-peer*: no hay un master fijo y cualquier nodo puede asumir el control, lo que elimina el *single point of failure*. El nodo más antiguo actúa como **coordinador**. [HZ-T01, p. 33] El coordinador mantiene la tabla de particiones (qué nodo es *owner* o *backup* de cada partición) y la distribuye a todos; la actualiza y redistribuye cuando entra o sale un nodo. Si cae, el siguiente nodo más viejo toma el rol y recalcula la tabla. [HZ-T01, p. 34]

## Particionado y réplicas

Cada estructura se divide en **271 particiones** repartidas entre los nodos. Aunque los datos estén distribuidos, cualquier nodo puede acceder a la totalidad pidiéndole a otros nodos lo que no tiene. [HZ-T01, p. 35]

La partición de un objeto se calcula como `hash(objeto) % 271`. [HZ-T01, p. 36] La lámina llama a esto *consistent hashing*, una denominación registrada en [Dudas y conflictos](../dudas-y-conflictos.md). El ejemplo inserta tres materias y muestra que dos claves pueden caer en la misma partición. [HZ-T01, p. 37]

Réplicas:

- Con un solo nodo no hay backup. Con dos nodos y backup, cada uno tiene aproximadamente 271/2 particiones primarias y 271/2 de backup del otro; con tres, aproximadamente 271/3 de cada clase. [HZ-T01, p. 38]
- Las réplicas se actualizan **sincrónicamente** con la partición principal. Por defecto hay una sola, porque ese sincronismo cuesta performance, pero la cantidad es configurable. [HZ-T01, p. 39] El `hazelcast.xml` provisto usa `backup-count` 1 y `async-backup-count` 0 para el mapa por defecto. [HZ-C01]
- Si cae el *owner* de una partición, el nodo con la réplica pasa a ser *owner* y otro nodo recibe una réplica nueva. Al entrar o salir nodos se migran particiones para que principal y réplica nunca queden en el mismo nodo. [HZ-T01, p. 40] [HZ-T01, p. 41] [HZ-T01, p. 42]
- Las **réplicas asincrónicas** responden más rápido a las escrituras, pero sólo garantizan consistencia eventual y permiten leer datos desactualizados (*stale*). [HZ-T01, p. 43]

## Configuración

El cluster puede configurarse de forma declarativa con `hazelcast.xml`, programáticamente desde Java, con propiedades del sistema o con un contexto de Spring. [HZ-T01, p. 45] [HZ-G01, p. 1]

### Declarativa: `hazelcast.xml`

- **Member discovery:** multicast, TCP/IP, frameworks como Zookeeper o Consul, o clouds como AWS y Azure. No se recomienda multicast en producción porque la comunicación por UDP suele ser problemática y bloquearse. [HZ-T01, p. 46]
- **Grupo:** con la misma configuración de discovery pueden convivir clusters independientes si cada uno define un `<group>` con nombre y password; esto también da cierta seguridad para unirse. [HZ-T01, p. 47]
- **Colecciones:** cada colección o el executor service puede configurarse por nombre. El ejemplo fija `backup-count`, `async-backup-count` y `read-backup-data` para el mapa `default` y para el mapa `materias`. [HZ-T01, p. 48]

El archivo provisto parte de la configuración por defecto de 3.8: grupo `dev`/`dev-pass`, puerto 5701 con autoincremento, multicast y TCP/IP **deshabilitados**, interfaz `10.10.1.*` habilitada y valores por defecto para mapas, colas, multimaps (`value-collection-type` `SET`), listas, sets, semáforos, ringbuffers y el `jobtracker` de MapReduce (`chunk-size` 1000, `topology-changed-strategy` `CANCEL_RUNNING_OPERATION`). [HZ-C01] El ejercicio 3 pide modificarlo para hacer discovery por TCP sólo en la máquina local y usar un grupo propio basado en el legajo. [HZ-T01, p. 52]

### Programática en Java

Tanto el servidor como el cliente reciben un objeto de configuración que se completa con setters. [HZ-T01, p. 58]

| Clase | Lado | Uso |
|---|---|---|
| `Config` | Servidor | Encapsula la configuración del cluster; se pasa a `Hazelcast.newHazelcastInstance(config)`. [HZ-T01, p. 59] [HZ-G01, p. 1] |
| `GroupConfig` | Ambos | Nombre y password del grupo; sólo los nodos del mismo grupo forman cluster. [HZ-T01, p. 61] |
| `NetworkConfig` | Servidor | Cómo se conforma el cluster. [HZ-T01, p. 62] |
| `JoinConfig` | Servidor | Cómo se encuentran los nodos: `MulticastConfig` o `TcpIpConfig`; esta última, más segura, lista los miembros posibles. [HZ-T01, p. 63] [HZ-G01, p. 1] |
| `InterfacesConfig` | Servidor | Máscara de la interfaz de red a usar, por ejemplo `192.168.1.*`. [HZ-T01, p. 64] |
| `ManagementCenterConfig` | Servidor | Opcional; habilita la webapp de monitoreo. [HZ-T01, p. 67] |
| `ClientConfig` y `ClientNetworkConfig` | Cliente | Encapsulan la configuración del cliente; la red debe indicar al menos una dirección de un nodo. [HZ-T01, p. 66] [HZ-G01, p. 1] |

Otras opciones de red mencionadas, no todas configurables por código, son *public address*, puerto, puertos salientes, *reuse address*, el SPI *Member Address Provider* y la configuración avanzada de red. [HZ-T01, p. 65]

La guía muestra un servidor y un cliente completos con grupo `g0`. El cliente escribe con `IMap#set` y luego lee la misma clave. [HZ-G01, p. 1] [HZ-G01, p. 2] [HZ-G01, p. 3] Para tests unitarios usa `TestHazelcastFactory`, que crea un member y un cliente en el mismo proceso, junto con las dependencias `hazelcast` y `hazelcast-client` con *classifier* `tests`. [HZ-G01, p. 3] [HZ-G01, p. 4]

### Management Center

Debe coincidir con la versión de Hazelcast: para 3.8.6 se usa el WAR de Management Center 3.8.5 desplegado en un Tomcat con JDK 8. Los nodos necesitan los flags `--add-opens java.management/sun.management=ALL-UNNAMED` y `--add-opens jdk.management/com.sun.management.internal=ALL-UNNAMED`. La herramienta admite hasta dos nodos; se configura con el nombre y la password del grupo y permite explorar mapas desde *Map Browser*. [HZ-G01, p. 4] [HZ-G01, p. 5]

## Instanciación y consola

Para correr un nodo hay que agregar la dependencia, disponer la configuración e instanciar `Hazelcast.newHazelcastInstance()` (member) o `HazelcastClient.newHazelcastClient()` (cliente). Luego se obtiene la colección desde la instancia. [HZ-T01, p. 54] Al terminar se usa `hz.shutdown()` en el servidor o `HazelcastClient.shutdownAll()` en el cliente. [HZ-T01, p. 59] [HZ-T01, p. 60]

Desde la consola (`java -jar hazelcast-all-3.8.6.jar` o `com.hazelcast.console.ConsoleApp`) se ven los miembros que se van uniendo. `help` lista los comandos, `[default]` indica el namespace actual, `ns <nombre>` lo cambia, y `m.put`, `m.get`, `m.size` y `m.iterator` operan sobre el mapa. [HZ-T01, p. 29] [HZ-T01, p. 30] [HZ-T01, p. 31] [HZ-T01, p. 55]

## Split brain

Un **split brain** ocurre cuando una falla de comunicación divide el cluster en dos partes autónomas. Ambas siguen funcionando, pueden recibir actualizaciones en conflicto para la misma clave y, al reconectarse, hay que decidir cómo combinar los datos. [HZ-T01, p. 49]

Para resolverlo, Hazelcast elige como líder al más viejo de los dos líderes y decide qué cluster se integra al otro (el más chico o según una función). Cada miembro del cluster que se integra pausa su operación, cierra su conexión, se une al otro cluster, pide combinar los mapas de los que es dueño según la política configurada y reanuda su operación. Las otras colecciones no se combinan: se conserva una de las dos versiones. [HZ-T01, p. 50]

La política se configura con `<merge-policy>` en cada mapa. Hay políticas incorporadas (`PassThroughMergePolicy`, `PutIfAbsentMapMergePolicy`, `HigherHitsMapMergePolicy`, `LatestUpdateMapMergePolicy`). [HZ-T01, p. 51] [HZ-C01] La política por defecto y la semántica de `PassThroughMergePolicy` difieren entre la lámina y el XML provisto: ver [Dudas y conflictos](../dudas-y-conflictos.md).

## Serialización

Todo objeto guardado en una colección distribuida viaja por la red, así que debe **serializarse**. [HZ-T01, p. 69] Las opciones son `Serializable` o `Externalizable` de Java, `DataSerializable`, `IdentifiedDataSerializable` o `Portable` de Hazelcast, y serializadores propios. Se recomiendan `DataSerializable` o `IdentifiedDataSerializable` porque usan Java NIO para serializar más eficientemente. [HZ-T01, p. 70]

`DataSerializable` exige implementar `writeData(ObjectDataOutput)` y `readData(ObjectDataInput)`, escribiendo y leyendo los campos en el mismo orden, y ofrecer un constructor sin parámetros. Un campo que también es `DataSerializable` puede delegar en sus propios métodos. [HZ-T01, p. 71] [HZ-T03, p. 23] [HZ-T03, p. 24]

## Operaciones sobre estructuras

- **Mapa:** `put`, `get` y los métodos de `ConcurrentMap` como `putIfAbsent` y `replace`. [HZ-T01, p. 75]
- **Entry processor:** `executeOnKey` aplica atómicamente un procesamiento sobre una entrada, por ejemplo incrementar un valor. [HZ-T01, p. 76]
- **Queries:** `values(predicate)` con un `SqlPredicate` en sintaxis tipo SQL o con criterios armados con `Predicates`. [HZ-T01, p. 77]
- **Cola:** se obtiene como `BlockingQueue` y admite `offer` y `poll` con o sin timeout, y `put`/`take` bloqueantes. [HZ-T01, p. 78]
- **Tópico:** `ITopic` implementa pub/sub con `addMessageListener` y `publish`. [HZ-T01, p. 79] Es la versión distribuida del patrón visto en [Alternativas y futuros componibles](alternativas-y-completable-future.md).
- **Locks distribuidos:** `hz.getLock(...)` devuelve un `Lock` con `lock`/`unlock` en `finally` o `tryLock` con timeout; un `IMap` también permite `lock(key)` y `unlock(key)` por clave. [HZ-T01, p. 80] [HZ-T01, p. 81] La disciplina de liberar en `finally` es la misma que en [Thread safety](thread-safety-y-coordinacion.md).

## Práctica asociada

| Ejercicio | Consigna |
|---|---|
| 1 | Levantar un cluster de dos nodos con el jar. [HZ-T01, p. 29] |
| 2 | Usar la consola: guardar el legajo bajo la clave `alumno` y repetir en un namespace propio. [HZ-T01, p. 31] |
| 3 | Modificar `hazelcast.xml` para discovery TCP local y grupo por legajo. [HZ-T01, p. 52] [HZ-C01] |
| 4 | Clonar el repositorio del ejercicio, ajustar el `hazelcast.xml` del módulo server y comprobar el cluster. [HZ-T01, p. 56] [HZ-R01] |

El enlace al repositorio del ejercicio 4 se preservó sin descargar su contenido. [HZ-R01]
