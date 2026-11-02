# MapReduce con Hazelcast

## El modelo

**MapReduce** es un modelo de programación para procesar grandes volúmenes de datos de forma paralela y distribuida a partir de primitivas simples. Fue una piedra fundacional del movimiento big data. [HZ-T02, p. 2] Proviene del paper de Dean y Ghemawat en Google, surgido de mejorar los tiempos de PageRank, y se apoya en tres ideas: [HZ-T02, p. 3]

- las primitivas funcionales `map` y `reduce`;
- subdividir los datos para procesarlos en forma distribuida (*divide & conquer*);
- trabajar lo más posible con los datos locales al nodo y evitar moverlos por la red (*data locality*).

Cada dato de entrada y salida es un par **clave/valor**, y cada etapa es una función `[k2, v2] = F(k1, v1)`. [HZ-T02, p. 4]

| Etapa | Entrada → salida | Quién la provee |
|---|---|---|
| Map | `(k1, v1)` → `(k2, v2)` | Se programa |
| Sort/shuffle | pares `(k2, v2)` → `(k2, [v2, v2, ...])` | El framework |
| Reduce | `(k2, [v2, ...])` → `(k3, v3)` | Se programa |

Fuente: [HZ-T02, p. 5] El ejemplo canónico es el **word count**. [HZ-T02, p. 6]

### Map

Transforma los datos iniciales en información útil para la operación final: **filtra** registros innecesarios, **proyecta** sólo los valores necesarios, **expande** con información externa y **multiplica** cuando un dato origina varios (un país → una emisión por provincia, una frase → una emisión por palabra). Recibe un par y emite cero, uno o más pares. [HZ-T02, p. 7]

### Sort/shuffle

Lo resuelve el framework: agrupa por clave los valores emitidos por todos los mappers y los envía al reducer de cada clave. Es una parte delicada de la implementación, porque hay que conservar los pares hasta que el reducer los consuma y transmitirlos al nodo correspondiente. [HZ-T02, p. 11]

### Reduce

Se crea (o reutiliza) un reducer por cada clave emitida. Recibe todos los valores de esa clave y produce su valor final. [HZ-T02, p. 12]

### MapReduce como alternativa a SQL

| SQL | MapReduce |
|---|---|
| `SELECT` (proyección) y `WHERE` (filtro) | Mapper |
| `GROUP BY` | Sort/shuffle |
| Proyección definitiva, agregaciones y `HAVING` | Reducer |

No hay ordenamiento global dentro del modelo porque el reducer emite por clave. Eso, y otras consultas complejas, se resuelve con post-procesamiento o encadenando un segundo MapReduce. [HZ-T02, p. 24]

## API de Hazelcast

Hazelcast ofrece una implementación de MapReduce con un DSL basado en el patrón Builder. [HZ-T02, p. 17]

| Pieza | Interfaz | Responsabilidad |
|---|---|---|
| Mapper | `Mapper<KeyIn, ValueIn, KeyOut, ValueOut>` | `map(key, value, context)` emite con `context.emit(k, v)`. [HZ-T02, p. 8] |
| Reducer | `ReducerFactory<KeyIn, ValueIn, ValueOut>` y `Reducer<ValueIn, ValueOut>` | La factory crea un reducer por clave; el reducer implementa `beginReduce`, `reduce` y `finalizeReduce`. [HZ-T02, p. 13] |
| Fuente | `KeyValueSource` | Itera una colección distribuida: `fromMap`, `fromList`, etc. Para colecciones sin clave, la clave es el nombre de la colección. [HZ-T02, p. 18] |
| Entrada | `JobTracker` | Se obtiene con `hazelcastInstance.getJobTracker("nombre")`, sea desde un cliente o desde un member. [HZ-T02, p. 17] |
| Job | `Job<K, V>` | Builder obtenido con `jobTracker.newJob(source)`; se configura y se envía con `submit()`. [HZ-T02, p. 19] |
| Filtro previo | `KeyPredicate<Key>` | `evaluate(key)` descarta pares antes del map. [HZ-T03, p. 4] |
| Combiner | `CombinerFactory` y `Combiner` | Agregación parcial del lado del mapper. [HZ-T03, p. 10] |
| Post-proceso | `Collator<ValueIn, ValueOut>` | `collate(Iterable<ValueIn>)` transforma el resultado final. [HZ-T03, p. 15] |

`submit()` devuelve un `ICompletableFuture`. El resultado puede esperarse con `future.get()` o recibirse con un `ExecutionCallback` registrado mediante `andThen`, que implementa `onResponse` y `onFailure`. [HZ-T02, p. 19] [HZ-T02, p. 20] Es la misma idea de futuros vista en [Alternativas y futuros componibles](alternativas-y-completable-future.md).

### Mappers en el cluster

A cada mapper se le asigna una partición del nodo donde corre para aprovechar *data locality*. Un nodo con varias particiones puede tener varias instancias de mapper, y un mapper que termina puede recibir otra partición del nodo. Por su forma, la operación map es naturalmente *thread safe*. [HZ-T02, p. 10]

### Ciclo de vida del reducer

1. Cuando llega una clave sin reducer asignado, la factory crea uno: por eso hace falta una factory. [HZ-T02, p. 15]
2. Se llama a `beginReduce` una vez.
3. Se llama a `reduce` por cada valor de la clave.
4. Se llama a `finalizeReduce` para obtener el valor final.

Como los valores llegan por *chunks*, un reducer puede quedar suspendido hasta recibir más valores y reanudarse en otro thread. Antes de Hazelcast 3.3 no había garantías de visibilidad entre threads y había que declarar `volatile` las variables de instancia. [HZ-T02, p. 16] Véase *happens-before* en [Thread safety](thread-safety-y-coordinacion.md).

### Requisitos de ejecución

Todos los nodos deben tener en el CLASSPATH el mapper, el reducer, las clases usadas como claves o valores y cualquier clase de apoyo, porque no hay carga dinámica de clases. Además deben compartir el mismo `hazelcast.xml` o la misma configuración programática. El cliente puede ser parte del cluster o no según cómo se instancie la `HazelcastInstance`. [HZ-T02, p. 21]

## Etapas opcionales

En la práctica hay tres etapas más, todas opcionales: una preliminar de carga y selección de datos, un **combiner** post-mapper y un post-procesado final. [HZ-T03, p. 2]

### KeyPredicate

Preselecciona qué pares se procesan: si `evaluate` devuelve `false`, el par no se procesa. Se agrega con `.keyPredicate(...)`. La condición se evalúa al recorrer las particiones en cada miembro; sólo un `KeyValueSource` propio que implemente `getAllKeys` permite filtrar las claves de antemano al iniciar el job. [HZ-T03, p. 4] [HZ-T03, p. 6] En el word count, la clave es el número de línea, así que un predicado `Integer.parseInt(key) < 100` limita el job a las primeras 100 líneas. [HZ-T03, p. 5]

### Combiner

Si un mapper emite un millón de pares `{"the", 1}`, todos viajan por la red al reducer y la congestionan. Un **combiner** actúa como un reducer en el nodo del mapper y acumula valores antes de emitirlos. [HZ-T03, p. 8] [HZ-T03, p. 9] Se instancia uno por clave y por mapper (por eso requiere factory), y su tipo de salida debe coincidir con el tipo de entrada del reducer. [HZ-T03, p. 9]

A diferencia del reducer, no espera a todos los valores: acumula hasta completar un **chunk** y emite un resultado parcial. Ciclo de vida: [HZ-T03, p. 12]

1. la factory crea el combiner cuando aparece una clave nueva;
2. `beginCombine` se llama una sola vez;
3. `combine` se llama por cada valor;
4. al terminar el chunk, `finalizeChunk` entrega el resultado parcial al reducer;
5. después de cada `finalizeChunk`, `reset` reinicia el acumulador;
6. `finalizeCombine` se llama una sola vez al final.

Se agrega con `.combiner(...)`. [HZ-T03, p. 13] El `hazelcast.xml` provisto fija `chunk-size` 1000 para el `jobtracker` por defecto. [HZ-C01]

> **Inferencia a partir del ciclo de vida:** si el combiner no reinicia su acumulador en `reset`, cada chunk arrastra la suma del anterior y el reducer termina contando valores más de una vez. El ejemplo de la cátedra pone `sum = 0` en `reset`. [HZ-T03, p. 11] [HZ-T03, p. 12]

### Collator

Post-procesa el resultado final sobre un `Iterable` con todas las salidas: para un job MapReduce, `ValueIn` es `Map.Entry<K, V>` y `ValueOut` puede ser cualquier tipo, desde un mapa hasta un único objeto. **Se ejecuta en el nodo cliente.** [HZ-T03, p. 15] [HZ-T03, p. 16] Se pasa como parámetro de `submit(collator)`. [HZ-T03, p. 18] Sirve, por ejemplo, para devolver una lista ordenada por cantidad descendente y luego alfabéticamente, algo que el modelo no hace por sí mismo. [HZ-T03, p. 17]

## `HazelcastInstanceAware`

Un mapper, una `ReducerFactory` o una `CombinerFactory` pueden implementar `HazelcastInstanceAware` para consultar otras estructuras distribuidas. La instancia se guarda como `transient` para que no se serialice; la factory se la pasa por constructor al reducer o combiner que crea. [HZ-T02, p. 8] [HZ-T03, p. 33] [HZ-T03, p. 35]

Es un intercambio de costos: emitir IDs enteros en lugar de nombres reduce el tráfico, pero cada búsqueda en el mapa auxiliar puede consultar una partición remota. Hay que medir si el ahorro compensa. [HZ-T03, p. 31] Como el collator corre en el cliente, en cambio, puede recibir la colección auxiliar directamente por constructor. [HZ-T03, p. 34]

## Práctica asociada

### Word count

Sobre el template `word-count`: cambiar el legajo `l12345` por el propio, implementar `TokenizerMapper` y `WordCountReducerFactory` y correr el cliente con un cluster de al menos dos nodos (`run-node.sh` y `run-client.sh mobydick.txt`). [HZ-T02, p. 22] [HZ-R02]

- **Ejercicio 2 (MR I):** para cada letra, la palabra más larga que empiece con ella; si hay empate de longitud, la menor alfabéticamente. Sólo se consideran palabras con `[a-z]+`. [HZ-T02, p. 23]
- **Ejercicio 1 (MR II):** agregar un `KeyPredicate` de 100 líneas, un combiner y un collator que ordene la salida, y quitar el ordenamiento que hacía el cliente. [HZ-T03, p. 19]

### Alquiler de bicicletas

El dataset BIXI Montréal tiene una fila por viaje con `startStation`, `startDate`, `endStation`, `endDate` e `isMember`, separadas por `;`. [HZ-T03, p. 20] [HZ-T03, p. 21] El template `bike-rentals` carga un `MultiMap` cuya clave es la estación de inicio y cuyos valores son `BikeRentalRow`. [HZ-T03, p. 22] [HZ-R03]

- **Ejercicio 2:** al correrlo falla con `HazelcastSerializationException` porque `BikeRentalRow` viaja por la red sin ser serializable. La corrección es implementar `DataSerializable` con un constructor sin parámetros. [HZ-T03, p. 23] [HZ-T03, p. 24]
- **Ejercicio 3:** contar los viajes entre pares de estaciones hechos por miembros, ordenados por total descendente y luego por estación de inicio. La solución propuesta es un mapper que filtra a los no miembros y emite `{StationPair(S1, S2), 1}`, donde S1→S2 y S2→S1 son pares distintos; un reducer que suma; y un collator que devuelve un `SortedSet<RentalsBetweenStationsResult>`. [HZ-T03, p. 25] [HZ-T03, p. 26] [HZ-T03, p. 27] [HZ-T03, p. 29] [HZ-T03, p. 30]

Una clase usada como **clave** de emisión, como `StationPair`, necesita `DataSerializable` y constructor sin parámetros porque viaja por la red, y `equals`/`hashCode` porque se compara con otras claves. [HZ-T03, p. 27] [HZ-T03, p. 28]

Los enlaces a ambos templates se preservaron sin descargar su contenido. [HZ-R02] [HZ-R03]
