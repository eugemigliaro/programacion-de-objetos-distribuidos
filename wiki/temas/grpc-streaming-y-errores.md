# gRPC: streaming, errores e interceptores

## Cuatro patrones de comunicación

Los métodos gRPC se clasifican por cuántos mensajes envía cada extremo. El diagrama introductorio de la fuente distingue estas cuatro cardinalidades. [GR-T03, p. 3]

| Patrón | Request | Response | Cliente mostrado |
|---|---:|---:|---|
| Unario | uno | uno | `BlockingStub` o `Stub` |
| Server streaming | uno | varios | `BlockingStub` como iterador o `Stub` con observer |
| Client streaming | varios | uno | `Stub` |
| Bidireccional | varios | varios | `Stub` |

La cardinalidad y los clientes se desprenden de los contratos, diagramas y ejemplos de implementación de la presentación. [GR-T03, p. 4] [GR-T03, p. 10] [GR-T03, p. 13] [GR-T03, p. 15] [GR-T03, p. 20] [GR-T03, p. 24]

## `stream` frente a `repeated`

`stream` modifica la entrada o salida de un método para transmitir varios mensajes a lo largo de la comunicación. `repeated` modifica un campo dentro de un único mensaje para transportar una lista. La guía propone `repeated` cuando la lista está disponible de inmediato y streaming cuando los valores aparecen progresivamente. [GR-T03, p. 7] [GR-T03, p. 8]

El streaming aprovecha conexiones HTTP/2 de larga duración y multiplexadas: cliente y servidor pueden permanecer conectados e ir enviando valores conforme se producen. [GR-T03, p. 9]

## Server streaming

El cliente envía un request y el servidor responde con una secuencia. El contrato coloca `stream` delante del mensaje de respuesta. El servant llama varias veces a `onNext` y finalmente a `onCompleted`. [GR-T03, p. 11] [GR-T03, p. 12]

Con `BlockingStub`, el cliente recibe un iterador cuyo `hasNext()` espera la próxima respuesta. Como alternativa, puede usar el stub asincrónico y un `StreamObserver`. [GR-T03, p. 13]

## Client streaming

El cliente envía varios mensajes y el servidor produce una respuesta. El método del servant devuelve un `StreamObserver` para consumir requests: procesa cada `onNext`, atiende `onError` y arma la respuesta al recibir `onCompleted`. [GR-T03, p. 16] [GR-T03, p. 17]

El cliente crea el observer de respuesta, obtiene del stub el observer de requests, envía los elementos con `onNext` y cierra su lado con `onCompleted`. [GR-T03, p. 18]

## Streaming bidireccional

Ambos extremos transmiten varios mensajes. El servidor puede emitir respuestas mientras siguen llegando requests; no tiene que esperar el cierre del lado cliente. [GR-T03, p. 21] [GR-T03, p. 22]

El cliente mantiene un observer de respuestas y otro de requests. Una vez enviados sus mensajes, cierra el request stream y espera la terminación del response stream cuando el flujo de la aplicación lo requiere. [GR-T03, p. 23] [GR-T03, p. 24]

## Errores

Cada llamada termina con un valor o con un error representado por un status. La presentación distingue `io.grpc.Status`, con los códigos básicos, y `com.google.rpc.Status`, que puede adjuntar detalles estructurados. [GR-T03, p. 27] [GR-T03, p. 29]

El servant debe comunicar fallas mediante `responseObserver.onError(...)`. Si una excepción sin mapear escapa del servant, el cliente recibe `StatusRuntimeException` con código `UNKNOWN`, perdiendo el detalle original. [GR-T03, p. 28]

En un stream, `onError` finaliza toda la comunicación. Si un mensaje individual puede fallar y el stream debe continuar, la recomendación de la cátedra es modelar ese resultado como parte del mensaje de respuesta. [GR-T03, p. 31]

## Interceptores y mapeo global

Los interceptores agregan comportamiento transversal alrededor de las llamadas: métricas, logs, autenticación, autorización, manejo de errores y metadata. Pueden encadenarse y ordenarse. [GR-T03, p. 33] [GR-T03, p. 34]

Un `ClientInterceptor` puede observar la invocación y envolver la respuesta; Spring lo registra globalmente con `@GlobalClientInterceptor`. [GR-T03, p. 35] [GR-T03, p. 36] [GR-T03, p. 37] El equivalente servidor implementa `ServerInterceptor` y se registra con `@GlobalServerInterceptor`; una errata en el texto de la lámina quedó anotada en [Dudas y conflictos](../dudas-y-conflictos.md). [GR-T03, p. 38] [GR-T03, p. 39] [GR-T03, p. 40]

`GrpcExceptionHandler` permite centralizar la traducción de excepciones del dominio a statuses gRPC. El ejemplo mapea `IllegalArgumentException` a `INVALID_ARGUMENT`, evitando que llegue como `UNKNOWN`. [GR-T03, p. 41] [GR-T03, p. 42] [GR-T03, p. 43]

## Práctica asociada

El TP gRPC III combina el contrato remoto con estado concurrente:

- una biblioteca con stock de ejemplares, préstamos y devoluciones, cliente bloqueante, módulos `api/server/client`, interfaz inmodificable y estado en memoria; [GR-P02, p. 1] [GR-P02, p. 2] [GR-P02, p. 3]
- un sistema de recitales donde `TicketsService` usa server streaming para notificar reserva, confirmación VIP o regular, agotamiento y cancelación; exige un repositorio compartido por dos servants y un interceptor servidor para mapear errores esperados. [GR-P02, p. 3] [GR-P02, p. 4] [GR-P02, p. 5]

El repositorio `tickets` está incluido en el listado de referencias de la cátedra; se preservó el enlace sin acceder al contenido remoto. [GR-R01]

