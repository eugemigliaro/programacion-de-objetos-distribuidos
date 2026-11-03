# TPE2: servicios de trenes

La consigna es un Markdown sin páginas, así que las citas `[HZ-E01]` remiten a la sección que se nombra en el texto. Antes de implementar una query, leé su sección completa en el original o en `material/extraido/HZ-E01.txt`. Este resumen no reemplaza las reglas de desempate ni las salidas de ejemplo, que son contrato.

## Objetivo

El TPE2 pide una aplicación de consola que use el modelo MapReduce sobre Hazelcast para procesar datos reales de servicios de trenes de Suiza y Bélgica. [HZ-E01] Las estadísticas tienen que salir de los archivos leídos en cada ejecución: no se aceptan implementaciones con datos fijos, y la aplicación debe funcionar con datos de cualquier otro país que respeten la misma estructura. [HZ-E01]

Todos los registros corresponden a paradas no canceladas, con horarios previstos y reales completos. [HZ-E01] El trabajo se hace con los mismos grupos del TPE1. [HZ-E01] Para la teoría que aplica, ver [MapReduce con Hazelcast](mapreduce-con-hazelcast.md) y [Hazelcast: cluster, configuración y estructuras](hazelcast-cluster-y-estructuras.md).

## Datos de entrada

Cada país tiene dos archivos con encabezado y campos separados por `;`. En el de servicios, cada línea es el servicio de un tren en una estación; en el de estaciones, cada línea es una estación. [HZ-E01] La consigna indica descargarlos desde los enlaces de la cátedra y no desde los portales de origen. [HZ-E01]

| Archivo | Registros según la consigna | Copia en este repositorio |
|---|---|---|
| `trainsCH.csv` | 42.782.820 (año 2024) | ZIP local sin versionar; ver [Datos locales](#datos-locales) |
| `stationsCH.csv` | 1539 | `stationsCH.csv` [HZ-D01] |
| `trainsBE.csv` | 20.809.934 (año 2024) | ZIP local sin versionar; ver [Datos locales](#datos-locales) |
| `stationsBE.csv` | 538 | `stationsBE.csv` [HZ-D02] |

Fuente de las cantidades: [HZ-E01]. Las dos copias de estaciones tienen la cantidad de filas esperada. [HZ-D01] [HZ-D02]

### Equivalencia de campos de servicios

Los dos países modelan lo mismo con nombres, orden de columnas y formatos distintos. Por ejemplo, el identificador de estación es la tercera columna en Suiza y la quinta en Bélgica. [HZ-E01]

| Concepto | Suiza (`trainsCH`) | Bélgica (`trainsBE`) |
|---|---|---|
| Fecha operativa | `fecha`, `yyyy-MM-dd` | `DATDEP`, `ddMMMyyyy` con el mes en inglés y en mayúsculas |
| Tren | `id_tren` (String) | `TRAIN_NO` (String) |
| Estación | `id_estacion` (int) | `PTCAR_NO` (int) |
| Operador | `operador` | `TRAIN_SERV` |
| Línea | `linea` | `RELATION` |
| Llegada prevista | `llegada_prevista`, `yyyy-MM-dd HH:mm:ss` | `PLANNED_DATE_ARR` (`ddMMMyyyy`) + `PLANNED_TIME_ARR` (`H:mm:ss`) |
| Salida prevista | `salida_prevista`, `yyyy-MM-dd HH:mm:ss` | `PLANNED_DATE_DEP` + `PLANNED_TIME_DEP` |
| Demora de llegada | `demora_llegada_s` | `DELAY_ARR` |
| Demora de salida | `demora_salida_s` | `DELAY_DEP` |

Fuente: [HZ-E01]. Las demoras están en segundos y una demora negativa indica un adelanto. [HZ-E01]

### Equivalencia de campos de estaciones

| Concepto | `stationsCH` | `stationsBE` |
|---|---|---|
| Identificador | `id_estacion` | `PTCAR ID` |
| Nombre | `nombre_estacion` | `Stopping point name` |
| Área geográfica | `canton` | `Area`, con formato `id-nombre`; el área es siempre el nombre, nunca el identificador |
| Coordenadas | `latitud` y `longitud`, en dos columnas | `Geo Point`, con latitud y longitud separadas por `", "` |

Fuente: [HZ-E01]. En la copia belga hay cinco áreas: Brussel/Bruxelles, Antwerpen, Gent, Liège y Charleroi. [HZ-D02] La copia suiza tiene 26 cantones; Bern, Vaud y Zürich son los que más estaciones tienen. [HZ-D01]

## Invocación y archivos de salida

Cada ejecución resuelve una sola query a partir de los archivos indicados en esa invocación: [HZ-E01]

```
sh queryX.sh -Daddresses='xx.xx.xx.xx:XXXX;yy.yy.yy.yy:YYYY' -Dcountry=ZZ -DinPath=XX -DoutPath=YY [params]
```

- `-Daddresses`: uno o más nodos `ip:puerto`, separados por `;`.
- `-Dcountry`: sólo `CH` o `BE`.
- `-DinPath`: directorio que contiene `trains<país>.csv` y `stations<país>.csv`. El ejemplo de la consigna lee `/afs/it.itba.edu.ar/pub/pod/trainsCH.csv` y `/afs/it.itba.edu.ar/pub/pod/stationsCH.csv`.
- `-DoutPath`: directorio donde se crean `queryX.csv` y `timeX.txt`.

Fuente: [HZ-E01].

`queryX.csv` siempre incluye el encabezado, aunque no haya resultados. Si el archivo ya existe se reemplaza, nunca se agrega al final, y tanto la entrada como la salida van en UTF-8. [HZ-E01] `timeX.txt` registra, con formato `dd/MM/yyyy HH:mm:ss:SSS` (los milisegundos van después de dos puntos), cuatro momentos: [HZ-E01]

1. el inicio de la lectura de los archivos;
2. el fin de esa lectura, que incluye la subida de los datos al cluster;
3. el inicio de cada trabajo MapReduce;
4. el fin de cada trabajo MapReduce; el fin del último incluye la escritura del archivo de respuesta.

## Queries

Reglas comunes: sólo cuentan las estaciones que están en el archivo de estaciones, y "alfabético" significa el orden natural de `java.lang.String`. [HZ-E01]

| Query | Parámetros extra | Encabezado de salida | Orden |
|---|---|---|---|
| 1. Demoras por estación | ninguno | `estacion;area;servicios;demora_llegada;demora_salida` | servicios desc., estación |
| 2. Mayor demora de llegada por operador y línea | ninguno | `operador;linea;estacion;tren;llegada;demora_llegada` | demora desc., operador, línea |
| 3. Hora con más salidas demoradas por día hábil | `areas` | `estacion;area;lunes;martes;miercoles;jueves;viernes` | estación |
| 4. Top n por demora media de llegada por cuadrante | `n`, `q`, `latMin`, `latMax`, `lonMin`, `lonMax` | `cuad_lat;cuad_lon;puesto;estacion;area;media_demora_llegada` | cuad. lat., cuad. lon., puesto |
| 5. Efecto "bola de nieve" por fecha operativa | `minServices` | `fecha;tren;servicios;efecto_bola_nieve` | fecha cronológica |
| 6. YTD de demora neta por estación | `areas`, `latMin`, `latMax`, `lonMin`, `lonMax` | `estacion;area;anio;mes;demora_ytd` | estación, año y mes |

Fuente: [HZ-E01]. La query 6 es sólo para grupos de cinco integrantes. [HZ-E01] Los parámetros de área son nombres separados por `;`. [HZ-E01]

### Query 1: demoras de llegada y salida por estación

Por estación se suman la cantidad de servicios y los segundos de demora de llegada y de salida. Los adelantos no compensan los atrasos: una demora negativa cuenta como 0. Una estación sin servicios no se lista. [HZ-E01]

### Query 2: mayor demora de llegada por operador y línea

Para cada par (operador, línea) se informa el servicio con mayor demora de llegada: estación, tren, fecha y hora prevista de llegada (`dd/MM/yyyy HH:mm:ss`) y segundos de demora. [HZ-E01]

- Si hay empate en la demora, gana la estación menor alfabéticamente, después el tren con identificador menor y, por último, la fecha operativa más reciente.
- Si ningún servicio del par tiene demora mayor que cero, el par no se lista.

Fuente: [HZ-E01].

### Query 3: hora con más salidas demoradas por día hábil

Para cada estación de las áreas pedidas y cada día de lunes a viernes, se informa la hora (0 a 23) con más **salidas demoradas**, es decir, servicios con demora de salida mayor que cero. Los feriados no se excluyen. [HZ-E01]

- El día de la semana sale de la **fecha operativa** y la hora sale de la **salida prevista**. Para un servicio que sale pasada la medianoche, esas dos fechas pueden no coincidir.
- Si hay empate entre horas, gana la menor.
- Un día sin salidas demoradas se informa como `N/A`; si los cinco días dan `N/A`, la estación no se lista.

Fuente: [HZ-E01].

### Query 4: top n estaciones por demora media de llegada por cuadrante

- **Cuadrante:** (⌊lat / q⌋, ⌊lon / q⌋), con q en (0, 1]. Con q = 0.1, Zürich HB (47.37817667422, 8.5402123491) cae en el cuadrante (473, 85).
- **Demora media de llegada:** suma de las demoras de llegada, incluidos negativos y ceros, dividida por la cantidad de servicios de la estación. Puede ser negativa.
- **Ranking:** de mayor a menor demora media y, si hay empate, por estación. El puesto se calcula antes de truncar. Si un cuadrante tiene menos de n estaciones con servicios, se listan sólo esas.
- **Formato:** truncar, sin redondear, a dos decimales; imprimir siempre dos decimales con punto.
- **Filtro:** sólo estaciones en [latMin, latMax) × [lonMin, lonMax); n debe ser mayor que 0.

Fuente: [HZ-E01].

### Query 5: tren con mayor efecto "bola de nieve" por fecha operativa

Las paradas de un tren en una fecha operativa son los servicios que comparten identificador de tren y operador. Se ordenan por llegada prevista, después por salida prevista y, por último, por estación. [HZ-E01] El efecto suma, para cada par de paradas consecutivas, la demora de llegada a la siguiente menos la demora de salida de la anterior: [HZ-E01]

| Estación | Demora de llegada (s) | Demora de salida (s) |
|---|---|---|
| A | 60 | 60 |
| B | 180 | 120 |
| C | 300 | 300 |

Efecto = (180 − 60) + (300 − 120) = 300 s. [HZ-E01]

- Sólo cuentan trenes con al menos `minServices` paradas en esa fecha, con `minServices` mayor que 1.
- Por cada fecha gana el tren con mayor efecto; si hay empate, el de identificador menor.
- Una fecha sin ningún tren que cumpla el mínimo y tenga efecto mayor que cero no se lista.
- La fecha se imprime como `dd/MM/yyyy`, y `servicios` es la cantidad de paradas del tren.

Fuente: [HZ-E01]. La agrupación usa tren y operador, pero la salida y el desempate usan sólo el identificador de tren; ese hueco está registrado en [Dudas y conflictos](../dudas-y-conflictos.md).

### Query 6: YTD de demora neta acumulada (sólo grupos de cinco)

- **Demora neta de un servicio:** demora de salida menos demora de llegada, con ambos signos.
- **Neta mensual:** suma de las netas de los servicios cuya fecha operativa cae en ese año y mes.
- **YTD de un mes:** suma de las netas mensuales desde enero hasta ese mes, inclusive. Se reinicia en cada año y hay que contemplar varios años aunque el dataset traiga sólo 2024.
- Un mes sin servicios no se lista. Filtran a la vez las áreas pedidas y el rango [latMin, latMax) × [lonMin, lonMax).

Fuente: [HZ-E01].

## Hechos asumibles

Los archivos tienen formato correcto, así que no hace falta validar columnas, tipos ni cantidad de campos. Los parámetros no contienen espacios y `;` nunca aparece dentro de un campo. [HZ-E01]

## Restricciones técnicas

Cada query se resuelve con uno o más jobs MapReduce que puedan correr distribuidos en un grid de Hazelcast, y cada cliente es una aplicación de consola con su propio script Bash. El diseño queda a criterio del grupo, pero debe funcionar correctamente en un ambiente concurrente, ser eficiente para grandes volúmenes (en particular, en tráfico de red) y respetar buenas prácticas. [HZ-E01]

Hay que respetar exactamente:

- los nombres de los scripts y de sus parámetros;
- el orden y el formato de los CSV de salida;
- el `<name>` de cada `pom.xml`, con la convención `tpe2-gX-Z`, donde `Z` es `parent`, `api`, `server` o `client`;
- la versión 3.8.6 de `hazelcast-all`;
- un nombre de cluster (`<group><name>`) y nombres de colecciones que empiecen con `g` y el número de grupo, para no chocar con otros grupos que prueban en la misma red.

Fuente: [HZ-E01].

La consigna no fija una versión de Java. Sus recomendaciones enlazan a la documentación de Java SE 25: `System.getProperty` para los parámetros, `Files.lines` y `Files.write` para leer y escribir, `DecimalFormat` con `RoundingMode.DOWN` para truncar, `DateTimeFormatter` para las fechas y `LocalDate#getDayOfWeek` para el día de la semana. [HZ-E01]

## Relación con la teoría

> **Inferencias de diseño, no requisitos de la consigna.**

- Las queries 1, 4 y 6 son sumas y conteos por clave, así que son candidatas naturales a un combiner, y el informe pide justamente medir una query con y sin combiner. El combiner reduce el tráfico hacia los reducers acumulando en el nodo del mapper. [HZ-T03, p. 8] [HZ-T03, p. 9]
- Todos los órdenes y desempates son globales, y el modelo no ordena globalmente: se resuelven con un collator o con post-procesamiento en el cliente. [HZ-T02, p. 24] [HZ-T03, p. 15]
- Las estaciones son pocas frente a los servicios. Se pueden filtrar y enriquecer al cargar, pasarle el mapa de estaciones al collator por constructor o consultarlo desde el job con `HazelcastInstanceAware`, sabiendo que emitir ids en lugar de nombres ahorra tráfico pero puede generar búsquedas en particiones remotas. [HZ-T03, p. 31] [HZ-T03, p. 34]
- La query 5 necesita reunir todas las paradas de (fecha, tren, operador) para ordenarlas antes de calcular el efecto; quedarse con el máximo por fecha es un segundo paso, ya sea otro job o el collator.
- Toda clase usada como clave de emisión necesita `DataSerializable`, un constructor sin parámetros, `equals` y `hashCode`. [HZ-T03, p. 27] [HZ-T03, p. 28] Además, todos los nodos necesitan las clases del job en el CLASSPATH. [HZ-T02, p. 21]

## Puntos delicados

> **Conocimiento general a verificar contra el runtime que use el grupo.**

- **Meses belgas en mayúsculas.** `DATDEP` usa valores como `27JUN2024`. Un `DateTimeFormatter` con patrón `ddMMMyyyy` y `Locale.ENGLISH` espera `Jun`, así que conviene construirlo con `parseCaseInsensitive()`. Las horas belgas usan `H:mm:ss`, con la hora en uno o dos dígitos. [HZ-E01]
- **Piso de una división de doubles.** `Math.floor(lat / q)` puede caer en el cuadrante anterior cuando la coordenada está justo sobre un borde, porque, por ejemplo, `0.3 / 0.1` da `2.9999999999999996` en `double`. `BigDecimal` evita el problema.
- **Truncado de negativos.** `RoundingMode.DOWN` trunca hacia cero, que es lo que pide la consigna para medias negativas.
- **Volumen.** La copia suiza descomprimida ocupa unos 5 GB y la belga unos 1,7 GB. El tiempo de lectura incluye la subida al cluster, así que proyectar sólo los campos que usa cada query y descartar pronto los servicios de estaciones desconocidas pesa directamente en las mediciones.

## Informe

El informe tiene tres secciones: [HZ-E01]

1. **Decisiones de diseño de los jobs:** cómo se diseñó cada trabajo MapReduce, con qué objetivos y qué alternativa se descartó y por qué.
2. **Análisis de tiempos:**
   - por cantidad de nodos físicos, hasta cinco en una red local, o una predicción si no se puede medir;
   - con y sin combiner, en una query donde convenga;
   - con y sin una optimización particular elegida por el grupo, en cualquier parte del proceso.
3. **Puntos de mejora o expansión:** alternativas no exploradas u operaciones útiles. Los tests no cuentan como mejora.

## Entrega y aprobación

El repositorio se crea desde el *template repository* indicado en Campus (con *Use this template*), debe ser privado y su historia tiene que mostrar la evolución grupal e individual. Una entrega con un único commit que contenga todo el código no se acepta. [HZ-E01] El template provisto es `POD-ITBA/tpe2-26Q2-g0`; el enlace se preservó, pero el repositorio no se incorporó como material. [HZ-R04] El repositorio del grupo se creó desde ese template: el estado, el reparto y las decisiones están en `entregas/README.md`.

Al Campus se sube un único archivo comprimido con: [HZ-E01]

- código fuente Maven separado en `api`, `client` y `server`, sin binarios (correr `./mvnw clean`);
- un `README.md` que explique el build, cómo levantar un ambiente de varios nodos y cómo correr cada cliente con todos sus parámetros y ejemplos;
- el directorio `.git/`;
- `doc/Informe.pdf`, con una carátula que liste a todos los integrantes;
- **ninguno** de los CSV provistos por la cátedra.

El trabajo no se aprueba si se entrega fuera de término, si falta algún material, si no compila con Maven en consola, si el cluster o los clientes no arrancan siguiendo el README o si la historia tiene un único commit con todo el código. Si nada de eso ocurre, se evalúan las queries, las pruebas y el coloquio, la aplicación de concurrencia y Hazelcast, la modularización, el diseño, el testeo, la reutilización y el informe. [HZ-E01]

## Cronograma

| Hito | Fecha |
|---|---|
| Presentación del enunciado | miércoles 28/10 |
| Entrega | jueves 12/11, 23:59, actividad "TPE 2" en Contenido / Evaluaciones del Campus |
| Coloquio | miércoles 18/11 |
| Recuperatorio | miércoles 25/11 |

Fuente: [HZ-E01]. No se aceptan entregas fuera de término, y las dudas van a los Debates del Campus. [HZ-E01]

## Datos locales

Los ZIP de servicios no están versionados: pesan 428 MB (Bélgica) y 1,08 GB (Suiza), más de lo que GitHub acepta por archivo, y la consigna prohíbe incluirlos en la entrega. Se guardan en `laboratorio/tpe2/data/`, que git ignora. En `laboratorio/tpe2/README.md` están sus checksums, cómo armar un directorio de entrada con los nombres exactos que espera `-DinPath` y cómo sumarle los archivos de estaciones.
