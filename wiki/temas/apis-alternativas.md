# APIs alternativas: bytes, SOAP, REST, GraphQL y eventos

gRPC sirvió para analizar por dentro una forma de comunicación. Esta unidad recorre los estándares alternativos más populares para exponer servicios. [API-T01, p. 3] La comparación con gRPC está en [Fundamentos de sistemas distribuidos y gRPC](grpc-fundamentos-y-patrones.md).

## Criterios para elegir

La forma de la API define la semántica y las operaciones posibles al consumir un servicio. [API-T01, p. 4] Casi cualquier estilo puede resolver casi cualquier API, pero la elección se guía por: [API-T01, p. 5]

- formas de comunicación y periodicidad;
- transporte;
- diversidad de clientes, lenguajes y tecnologías;
- manera de describir las operaciones;
- diversidad de los payloads.

## Servicio de ejemplo

Todas las variantes exponen el mismo dominio de autores y posts. Hay tablas `AUTHORS` (`id`, `name`) y `POSTS` (`id`, `title`, `content`, `author_id`), comandos para crear autores y posts, y consultas para listar u obtener por id. [API-T01, p. 7] [API-T01, p. 8]

La arquitectura comparte un backend de casos de uso (`AuthorService`/`PostService`), puertos de salida (`AuthorRepository`/`PostRepository`) y adaptadores JPA sobre PostgreSQL. Cuatro procesos lo exponen: bytes por TCP crudo en el puerto 9090, SOAP sobre HTTP en el 8082, REST sobre HTTP en el 8081 y GraphQL sobre HTTP más WebSocket. [API-T01, p. 9] El backend es una dependencia compartida, no un proceso propio.

## Tira de bytes

Es la forma más primitiva: se abre un socket y se acuerda por documentación cómo se codifican request y response. Fue la única opción durante mucho tiempo y todavía aparece en APIs *legacy*. [API-T01, p. 11] [API-T01, p. 12]

En el ejemplo, el primer byte del request es un *opcode* (`CREATE_AUTHOR` 0x01, `CREATE_POST` 0x02, `LIST_AUTHORS` 0x03, `LIST_POSTS` 0x04), seguido de sus campos en orden. El primer byte de la respuesta es un status (0x00 OK, 0x01 ERROR), seguido de un mensaje UTF si hubo error o del payload de la operación si no. [API-T01, p. 13] [API-T01, p. 14] [API-T01, p. 15] [API-T01, p. 16] Todo el contrato vive en la documentación; es exactamente el trabajo que el middleware RPC le quita a la aplicación (**inferencia** a partir de [GR-T01, p. 22] [GR-T01, p. 23]).

## SOAP

**SOAP** (*Simple Object Access Protocol*) es un protocolo estándar que intercambia datos en XML; los servicios también se definen en XML. [API-T01, p. 18] [API-T01, p. 19] Tiene tres características: [API-T01, p. 20]

- **Extensibilidad:** permite construir servicios complejos o agregar seguridad y ruteo.
- **Neutralidad:** usa TCP y admite distintos protocolos de aplicación, como HTTP, SMTP o JMS.
- **Independencia:** al definirse en XML admite cualquier lenguaje y paradigma.

Un mensaje tiene un `Envelope` que lo engloba, un `Header` opcional (por ejemplo, para autenticación), un `Body` obligatorio y un `Fault` con los errores, si los hubo. [API-T01, p. 21] [API-T01, p. 22] El ejemplo muestra `createAuthorRequest`, su respuesta y un `Fault` con `faultcode` `soapenv:Client` cuando el autor no existe. [API-T01, p. 23] [API-T01, p. 24] [API-T01, p. 25]

### WSDL y XSD

El contrato es un **WSDL** (*Web Services Description Language*) que especifica operaciones, tipos de datos y ubicación del servidor. [API-T01, p. 26]

| Elemento WSDL | Define |
|---|---|
| `types` | Tipos y estructuras XML, normalmente mediante XSD. |
| `message` | Datos intercambiados; separa entrada y salida de cada operación. Spring-WS envuelve cada elemento del XSD en un `wsdl:message` con una única `part`. |
| `portType` | Interfaz abstracta: operaciones y mensajes de entrada/salida. |
| `binding` | Cómo viajan los mensajes: transporte (SOAP sobre HTTP) y estilo de serialización (`document`/`literal`). |
| `service`/`port` | Endpoint concreto: une `portType` con `binding` y le da una URL. |

Fuentes: [API-T01, p. 27] [API-T01, p. 32] [API-T01, p. 33] [API-T01, p. 34] [API-T01, p. 35]

El **XSD** puede separarse del WSDL. El WSDL es el nivel macro (qué funciones existen y a qué URL se envían); el XSD es el nivel micro (qué campos lleva cada mensaje, de qué tipo y con qué restricciones), con tipos complejos reutilizables y los elementos de request/response. [API-T01, p. 29] [API-T01, p. 30] [API-T01, p. 31]

### Código

Los lenguajes ofrecen compiladores que generan clases de servicio y stubs a partir del XML, o el XML a partir del código; el proceso es similar al de gRPC. En Java hay Spring WS, CXF, Axis y JAX-WS. [API-T01, p. 36] [API-T01, p. 37] En Spring WS el endpoint se anota con `@PayloadRoot`, `@ResponsePayload` y `@RequestPayload`, traduce el dominio a las clases XML generadas y convierte excepciones del dominio en *SOAP faults*. [API-T01, p. 38] [API-T01, p. 39]

### Balance

SOAP fue durante mucho tiempo el sistema de web services más popular por su extensibilidad y su soporte multilenguaje. Sus contras son lo verboso del XML y lo complejo que resulta definir incluso servicios simples. Así surgió una dicotomía: REST para servicios web simples y B2C; SOAP para servicios complejos con más necesidades de seguridad, como finanzas y B2B. [API-T01, p. 40] [API-T01, p. 41]

## REST

Según la tesis de Roy T. Fielding, **REST** (*representational state transfer*) es un estilo arquitectónico para sistemas distribuidos de hipermedia. Por su vínculo con HTTP, hoy se lo usa informalmente para nombrar una interfaz remota basada en **recursos** sobre HTTP, con representaciones como JSON, XML o binario. La diferencia central con RPC es que modela sustantivos (recursos) en lugar de verbos (acciones). [API-T01, p. 43] [API-T01, p. 44]

### Principios

1. **Cliente-servidor:** separa responsabilidades; como la dependencia pasa por el mensaje, cambiar un lado no debería afectar al otro. [API-T01, p. 45]
2. **Stateless:** el cliente mantiene el estado de la petición y el servidor recibe todo con cada pedido, así distintas instancias pueden atender llamadas sucesivas del mismo cliente. [API-T01, p. 46]
3. **Cacheable:** los recursos deben poder cachearse mientras tenga sentido. [API-T01, p. 47]
4. **Sistema en capas:** el cliente sólo conoce la capa con la que habla. [API-T01, p. 48]
5. **Code on demand:** opcional y en desuso; ejecutar código en el cliente (o desde el cliente) mediante scripts o applets. [API-T01, p. 49]
6. **Interfaz uniforme:** identificación unívoca de recursos; manipulación mediante representaciones que contienen lo necesario para modificarlos o borrarlos; mensajes autodescriptivos; e hipermedia como motor del estado de la aplicación. [API-T01, p. 50]

### Recursos y URIs

Un recurso puede ser una **colección** (sustantivo, generalmente en plural), un **singleton** o documento (una instancia identificada) o una **subcolección** subordinada a un elemento. [API-T01, p. 51] [API-T01, p. 52] Las URIs se arman jerárquicamente a partir de la URI del servicio, con contexto y versión opcionales: `/movies/`, `/movies/{id}`, `/movies/{id}/actors`. [API-T01, p. 53] HTTP completa el pedido con *status codes*, *content types* para negociar la representación y *query params* para búsqueda o paginación. [API-T01, p. 54]

En el ejemplo, `POST /authors` responde `201 Created` con `Location` o `400` por validación; `GET /authors/{id}` responde `404` si no existe; y `POST /posts` responde `404` si el `authorId` no existe. [API-T01, p. 55] El mismo recurso puede pedirse como `application/json`, `application/hal+json` o `application/xml` con el header `Accept`. [API-T01, p. 56]

**HATEOAS:** la respuesta incluye links (`_links`) hacia sí misma y hacia recursos dependientes, para que el cliente pueda recorrer el servicio desde el primer request. [API-T01, p. 57] En Spring, el modelo extiende `RepresentationModel` y el controlador `@RestController` arma links con `linkTo(methodOn(...))`. [API-T01, p. 59] [API-T01, p. 60]

### Balance

Ventajas: gran soporte y conocimiento en la comunidad; escalabilidad por ser stateless, cliente-servidor y cacheable; flexibilidad de representaciones; e independencia tecnológica gracias a HTTP. [API-T01, p. 61] Desventajas: sin un estándar, cuesta modelar lo que no se describe bien como sustantivos o CRUD; y cuando distintos clientes necesitan distintas facetas de un recurso, se termina con varios endpoints o con uno que devuelve demasiado. [API-T01, p. 62]

## GraphQL

**GraphQL** es un lenguaje de consulta y manipulación de datos para APIs y un entorno de ejecución para resolver esas consultas. [API-T02, p. 4] Define APIs web con esquema tipado, agnósticas del transporte y de la fuente de datos, explorables, con operaciones de **query**, **mutation** y **subscription**, donde el cliente selecciona qué quiere recibir. Pese al nombre, no es un lenguaje para recorrer grafos. [API-T02, p. 5]

Frente a REST permite reducir llamados, pedir sólo los datos necesarios y componer datos de múltiples fuentes. [API-T02, p. 6] Responde directamente a la segunda desventaja de REST (**inferencia** que vincula [API-T01, p. 62] con [API-T02, p. 6]).

### Esquema

El esquema es fuertemente tipado y define objetos, argumentos y respuestas, con un estilo parecido a RPC. Se publica en el servicio, y todas las operaciones se ejecutan en un único endpoint mediante `POST` con distinto body. [API-T02, p. 7]

- Cada campo tiene nombre y tipo (`String`, `Int`, `Float`, `Boolean`, `ID`); `!` lo vuelve obligatorio y `[ ]` indica una lista. [API-T02, p. 8]
- `Query` es obligatorio; `Mutation` y `Subscription` son opcionales. Tienen métodos en lugar de campos y pueden agruparse en un bloque `schema`. [API-T02, p. 9]
- Cada método de `Query` tiene nombre, parámetros tipados y tipo de respuesta, por ejemplo `recentPosts(count: Int, offset: Int): [Post]!`. [API-T02, p. 10]

Una consulta se prefija con `query`, puede declarar variables (`$count`) que se envían en un objeto JSON aparte y enumera los campos esperados, incluso anidados (`author { id }`). [API-T02, p. 11] Una mutación se declara y se invoca de forma análoga. [API-T02, p. 24] [API-T02, p. 25]

### Resolvers

Los **resolvers** responden las operaciones; hay resolvers de query, mutation, subscription y campo, y esa granularidad permite completar cada campo desde fuentes distintas. [API-T02, p. 13] Cómo se generan depende de la biblioteca: hay simples middlewares, generadores de código desde el esquema y generadores de esquema desde el código. [API-T02, p. 14]

En Spring for GraphQL, el resolver es un método de un `@Controller`:

| Anotación | Resuelve |
|---|---|
| `@QueryMapping` (+ `@Argument`) | Una query. [API-T02, p. 15] |
| `@MutationMapping` | Una mutación. [API-T02, p. 26] |
| `@SchemaMapping(typeName = "Post", field = "author")` | Un campo de un tipo; permite componer la respuesta con datos de otras fuentes. [API-T02, p. 17] [API-T02, p. 18] |
| `@BatchMapping` | Un campo en lote: recibe la lista de padres y devuelve `Mono<Map<Padre, Hijo>>`. [API-T02, p. 22] |

### El problema N+1 y los batch loaders

Pedir una lista cuyo contenido requiere una consulta adicional por elemento produce el problema de **N+1 queries**: resolver el autor de cada post invoca al field resolver una vez por post, con costo lineal. [API-T02, p. 20] Un **batch loader** acumula los pedidos al campo y hace un único llamado con los N ids, para que la implementación los resuelva en conjunto. [API-T02, p. 21]

### Proyecto `graphql-intro`

El proyecto de apoyo es Spring Boot 3.0.5 con Java 17 y los starters de GraphQL, web y websocket; habilita GraphiQL en `/graphiql`. [API-C01] Define `blog.graphqls` con `Query.recentPosts` y `Mutation.createPost`, DAOs en memoria cargados con 10 autores y 100 posts, y un archivo `test.http` con una query simple, una con variables y la mutación. [API-C01]

`PostController` y `AuthorController` están vacíos para resolver los ejercicios. Hay dos controladores ya implementados pero deshabilitados (`//@Controller`): `BatchMappingPostController`, con `@BatchMapping`, y `RegisterPostController`, que registra un *mapped batch loader* en `BatchLoaderRegistry` y resuelve el campo con un `DataLoader`. [API-C01] **Observación del código:** los datos semilla pasan el texto en el lugar de la categoría y viceversa, por eso el ejemplo de respuesta muestra `"text": "Post category"`. [API-C01] [API-T02, p. 6]

Ejercicios: consultar posts pidiendo `id` y `title`; implementar el query resolver y agregar el autor; implementar el field resolver del autor; implementar el batch loading y comprobar el llamado optimizado; implementar la mutación de posts. [API-T02, p. 12] [API-T02, p. 16] [API-T02, p. 19] [API-T02, p. 23] [API-T02, p. 27]

## APIs de eventos

En las APIs *event driven*, la comunicación con el cliente se inicia cuando ocurre el evento. [API-T02, p. 29]

| Mecanismo | Dirección y conexión | Usos mencionados |
|---|---|---|
| Webhook | El sistema origen hace un *callback* HTTP a la URL configurada por el cliente cuando ocurre algo. | Alertas de pago, notificaciones de Git, CI/CD. [API-T02, p. 30] |
| WebSocket | Conexión "permanente" *full duplex* abierta por el cliente. | Chat, juegos online, herramientas colaborativas; una implementación de subscriptions de GraphQL. [API-T02, p. 31] |
| Server-Sent Events | Conexión permanente unidireccional servidor → cliente, liviana y con reconexión automática. | Tableros en vivo, cotizaciones, feeds. [API-T02, p. 32] |
| Pub/sub con broker | El productor escribe en una cola y el mensaje persiste hasta que un consumidor lo procesa; si un servicio cae, el dato no se pierde. | Kafka, RabbitMQ. [API-T02, p. 33] |

## Conclusiones de la cátedra

Hay muchas maneras de definir APIs; las dos corrientes principales son request/response y eventos, cada una con varias tecnologías. Muchos de los elementos discutidos con gRPC sirven para entender cómo se construyen. [API-T02, p. 34]

| Estilo | Contrato | Transporte en el ejemplo | Modela |
|---|---|---|---|
| Tira de bytes | Documentación | TCP crudo | Opcodes |
| SOAP | WSDL + XSD | SOAP sobre HTTP | Operaciones |
| REST | Convención de URIs y status | HTTP | Recursos |
| GraphQL | Esquema tipado | HTTP + WebSocket | Queries, mutaciones y subscripciones |
| gRPC | `.proto` | HTTP/2 | Métodos RPC |

La tabla resume [API-T01, p. 9], las secciones anteriores y [GR-T01, p. 32].
