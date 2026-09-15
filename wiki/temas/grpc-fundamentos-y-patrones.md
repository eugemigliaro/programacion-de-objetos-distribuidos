# Fundamentos de sistemas distribuidos y gRPC

## Del sistema distribuido al servicio

Un sistema distribuido reúne componentes ubicados en distintas computadoras que se comunican mediante mensajes y se presentan al usuario como un sistema coherente. El objetivo del modelo es dividir una tarea y coordinar recursos de varios nodos. [GR-T01, p. 4] [GR-T01, p. 5]

La comunicación se organiza en pares cliente/servidor: el servidor ofrece operaciones sobre recursos y el cliente solicita su ejecución. Un **servicio** expone esas operaciones mediante una API que restringe qué puede pedir el consumidor. [GR-T01, p. 8] [GR-T01, p. 9] [GR-T01, p. 10]

La cátedra presenta dos estilos generales:

| Estilo | Interacción |
|---|---|
| Request/response | El cliente envía un pedido, el servidor lo procesa y devuelve la respuesta. |
| Basado en eventos | El cliente se registra y el servidor le comunica asincrónicamente los eventos posteriores. |

La elección depende del servicio, del cliente y de la tecnología. [GR-T01, p. 11]

## IPC, middleware y RPC

Los sockets permiten implementar IPC sobre TCP/IP o UDP/IP, pero dejan en la aplicación tareas como escuchar conexiones, codificar mensajes, atender varios clientes y administrar el protocolo. [GR-T01, p. 17] [GR-T01, p. 19] [GR-T01, p. 22]

El **middleware** introduce una capa entre la aplicación y la comunicación de red. RPC usa esa capa para convertir una invocación a un método en mensajes de red y reconstruirla del lado servidor. La intención es que el llamado remoto se parezca a uno local. [GR-T01, p. 23] [GR-T01, p. 25] [GR-T01, p. 26]

Los dos extremos del middleware son:

- **Stub:** proxy del servicio remoto en el cliente; recibe la invocación y sus parámetros, los envía y entrega el resultado al código cliente. [GR-T01, p. 28]
- **Skeleton:** recibe el pedido en el servidor, lo interpreta, invoca la implementación remota y transmite la respuesta. [GR-T01, p. 29]

En el flujo completo, el stub serializa el pedido y genera una solicitud HTTP/2; el servidor identifica el método, el skeleton deserializa el mensaje e invoca localmente al *servant*. La respuesta recorre el camino inverso. El diagrama de la fuente confirma la separación entre cliente/stub, red y skeleton/servant. [GR-T01, p. 37]

## Qué aporta gRPC

gRPC es un sistema RPC multilenguaje y multiplataforma. Usa Protocol Buffers como IDL y formato de serialización, y HTTP/2 como transporte; sobre esa base ofrece autenticación, streaming bidireccional, control de flujo, timeouts y cancelación. [GR-T01, p. 31] [GR-T01, p. 32]

Protocol Buffers define contratos independientes del lenguaje y genera código para serializar y deserializar mensajes binarios tipados. [GR-T01, p. 33] [GR-T01, p. 34] HTTP/2 aporta una conexión persistente, multiplexación de streams, compresión de headers y un formato binario. [GR-T01, p. 36]

## Contratos `.proto`

Un archivo `.proto` declara la versión de sintaxis, opciones de generación, servicios, métodos y mensajes. Cada método se declara con `rpc` y posee exactamente un mensaje de entrada y uno de salida, aunque alguno esté vacío. [GR-T01, p. 42] [GR-T01, p. 43] [GR-T01, p. 44]

Reglas destacadas por el material:

- cada campo de un mensaje tiene un número positivo único dentro de ese mensaje; el orden de declaración no determina esos números; [GR-T02, p. 22] [GR-S01, p. 1]
- los campos pueden ser escalares, enums u otros mensajes, y admiten cardinalidades como `optional`, `repeated` y `map`; [GR-T02, p. 22] [GR-T02, p. 23]
- un enum debe reservar el valor numérico `0` para una constante `..._UNSPECIFIED`, porque ese ordinal funciona como valor predeterminado; [GR-T02, p. 24] [GR-S01, p. 2] [GR-S01, p. 3]
- `google.protobuf.Empty` y los wrappers de `google/protobuf/wrappers.proto` evitan redefinir mensajes vacíos o mensajes de un solo escalar. [GR-T02, p. 26] [GR-S01, p. 2]

El compilador genera una clase `<Servicio>Grpc` y clases para los mensajes. Esa clase contiene el middleware que usan cliente y servidor. [GR-T01, p. 40]

## Implementación con Spring gRPC

Spring gRPC integra gRPC Java con inyección de dependencias, starters de servidor y cliente, configuración mediante propiedades y soporte para pruebas. [GR-T01, p. 38]

En el cliente se crea un stub a partir de `GrpcChannelFactory` y un channel configurado con dirección y, cuando corresponde, TLS. La lógica de consola puede ejecutarse con un `CommandLineRunner`; `@ImportGrpcClients` permite inyectar el stub usando el channel predeterminado. [GR-T01, p. 46] [GR-T01, p. 47] [GR-T01, p. 48] [GR-T01, p. 57]

En el servidor, el *servant* extiende `<Servicio>ImplBase`, se registra como `@Service` y sobreescribe los métodos generados. Recibe el request y un `StreamObserver`: publica respuestas mediante `onNext`, termina con `onCompleted` o informa un error con `onError`. [GR-T01, p. 50] [GR-T01, p. 51] [GR-T01, p. 53] [GR-T01, p. 54]

El material distingue cuatro clientes generados: `BlockingStub`, `BlockingV2Stub`, `FutureStub` y `Stub` asincrónico con observers. [GR-T01, p. 45] Para llamados no bloqueantes, `FutureStub` devuelve un `ListenableFuture` y admite callbacks; el `Stub` recibe un `StreamObserver` como callback. [GR-T02, p. 29] [GR-T02, p. 31] [GR-T02, p. 32] [GR-T02, p. 34]

## Organización, ejecución y operación

La estructura recomendada separa tres módulos: `api` contiene el contrato y el código generado compartido, mientras `client` y `server` incorporan esa API y su lógica específica. [GR-T02, p. 3] [GR-T02, p. 4]

Para distribuir la aplicación, Maven Assembly empaqueta clases, dependencias y scripts en archivos `.tar.gz`; el build indicado es `./mvnw clean package`. [GR-T02, p. 6] [GR-T02, p. 7] La presentación también muestra imágenes separadas para cliente y servidor y una orquestación mediante Docker Compose. [GR-T02, p. 11] [GR-T02, p. 12]

Un cliente puede fijar un **deadline** con `withDeadlineAfter`; si vence, aborta la espera. El servidor debe consultar la cancelación si inició trabajo interno que también conviene detener. [GR-T02, p. 15] [GR-T02, p. 16] Hay una inconsistencia sobre el código observado por el cliente registrada en [Dudas y conflictos](../dudas-y-conflictos.md).

El servicio estándar de health check informa `SERVING`, `NOT_SERVING` o `UNKNOWN`. Spring gRPC permite administrar el estado con `HealthStatusManager` y habilitar el chequeo automático por channel en el cliente. [GR-T02, p. 18] [GR-T02, p. 19] [GR-T02, p. 20]

## Práctica asociada

El primer TP pide corregir contratos `.proto` y construir un servicio unario con operaciones `ping`, `time`, `echo`, `hello` y `fortune`, consumido mediante un stub bloqueante. [GR-P01, p. 1] [GR-P01, p. 2] La solución oficial desarrolla el contrato, el servant, el servidor y el cliente, y sirve como referencia concreta para las reglas anteriores. [GR-S01, p. 1] [GR-S01, p. 2] [GR-S01, p. 3] [GR-S01, p. 4] [GR-S01, p. 5]

Los repositorios `sockets`, `greeter` y `user` aparecen en el listado provisto por la cátedra. El archivo se preservó como referencia sin descargar ni evaluar el contenido remoto. [GR-R01]

