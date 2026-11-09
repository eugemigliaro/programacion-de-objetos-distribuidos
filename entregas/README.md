# Entregas

Trabajos evaluados, finales o grupales. No copiar automáticamente aquí las guías
de `practica/`: primero verificar la consigna y la configuración de la materia.

Para cada entrega conviene conservar consigna, decisiones, código o documento
fuente, instrucciones de reproducción y versión final.

Las entregas que tienen su propio repositorio git se clonan acá y quedan
ignoradas por este repositorio (ver `.gitignore`). Se entregan por separado, así
que **su contenido no debe citar ni referenciar material de este repositorio**.

## TPE2 — Servicios de Trenes

- **Repositorio:** `eugemigliaro/tpe2-26Q2-g05` (privado, creado el 03/11 desde
  el template de la cátedra `POD-ITBA/tpe2-26Q2-g0`). Invitados con escritura:
  `andresgarbarz`, `FrancoBrandaa` y `Pablo-Goros`.
- **Integrantes:** Eugenio Migliaro, Andrés Garbarz, Franco Branda, Pablo
  Gorostiaga
- **Entrega:** jueves 12/11 23:59 · **Coloquio:** miércoles 18/11
- **Alcance:** somos cuatro, así que entran las queries 1 a 5. La 6 es sólo para
  grupos de cinco.

### Cómo replicar el entorno

```shell
cd programacion-de-objetos-distribuidos/entregas
git clone git@github.com:eugemigliaro/tpe2-26Q2-g05.git
```

El template fija Java 25 y trae `mvnw`; Hazelcast 3.8.6 llega por Maven. Los
datasets de servicios no se versionan: cómo bajarlos y armar el directorio de
entrada está en `laboratorio/tpe2/README.md`.

En los commits de este repo figura sólo el integrante que commitea: no se agregan
líneas de coautoría de agentes.

### Dónde está cada cosa

| Qué | Dónde |
|---|---|
| Enunciado | `material/catedra/practica/TPE2 Servicios de Trenes.md` (texto en `material/extraido/HZ-E01.txt`) |
| Resumen de la consigna | `wiki/temas/tpe2-servicios-de-trenes.md` |
| Teoría de MapReduce y Hazelcast | `wiki/temas/mapreduce-con-hazelcast.md`, `wiki/temas/hazelcast-cluster-y-estructuras.md` |
| Datos | `laboratorio/tpe2/` |
| Decisiones de diseño del TP | `entregas/tpe2-26Q2-g05/doc/decisiones-de-diseno.md` |

Antes de implementar una query, **leer su sección completa en la consigna**: los
desempates y el formato de las salidas de ejemplo son contrato. Los números de esos
ejemplos, en cambio, **no** salen de los datasets completos (ver
`wiki/dudas-y-conflictos.md`). Para validar con los datos completos hay que
compararse contra un cálculo independiente, como `laboratorio/tpe2/oraculo/`.

### Decisiones tomadas el 03/11

El detalle y las mediciones que las respaldan están en el documento de
decisiones del TP. En resumen:

- Identificador **`g05`** en los pom, el cluster y las colecciones.
- Los servicios se suben en **lotes de filas por entrada** del `IMap`. Con un
  tamaño de lote 1 se reproduce la versión sin optimizar, y esa comparación es la
  optimización particular del informe.
- Cada query sube **sólo sus campos**. Al cargar se filtra por estación
  (desconocidas, áreas de la Q3, rectángulo de la Q4). Las condiciones por fila y
  la agregación quedan en el job.
- En el cluster, una estación viaja como su **posición alfabética**: comparar
  enteros equivale a comparar nombres.
- **Q4:** el top n por cuadrante se resuelve en el collator.
- **Q5:** un solo job con clave fecha operativa; el reducer devuelve sólo al
  ganador.
- **Informe:** el análisis de combiner se hace con la Q1.

### Estado

Al 03/11: el repositorio está creado y clonado, `g05` ya está aplicado sobre el
template y las decisiones de diseño están registradas.

Al 04/11 la base común está en `main`: el contrato de las queries, la carga en
lotes, los formatos de los dos países, versiones mínimas de las piezas de
infraestructura y la query 1 completa como referencia. La query 1 coincide fila por
fila con el oráculo sobre los dos datasets completos. La estructura, la receta
para agregar una query y los tiempos medidos están en el documento de decisiones
del TP.

Al 09/11 están las cinco queries: la Q2 de Andrés, la Q3 de Franco y la Q5 de
Pablo están en `main`, y la Q4 y los scripts `query1.sh` y `query4.sh` completan el
rol A. La Q1 y la Q4 coinciden con `laboratorio/tpe2/oraculo/` sobre los datasets
completos.

Pendiente del rol B: la red del nodo para varias máquinas, borrar `Client.java` y
`run-client.sh` del template y que `Server` use `ClusterNames`.

Pendiente de la Q5: correrla sobre los datasets completos. El 09/11 se sacaron de
su sección del documento de decisiones las citas a `[HZ-E01]` y a la wiki, que la
entrega no puede llevar; el hueco de paradas indistinguibles que mencionaba quedó
registrado en `wiki/dudas-y-conflictos.md`.

### Reparto

Definido el 03/11. Cada rol toma su parte de la base común y después sus queries
de punta a punta: mapper, reducer, combiner, collator, script y tests.

| Rol | Responsable | Base | Queries | Informe |
|---|---|---|---|---|
| A: datos | Eugenio | parsers CH/BE, catálogo de estaciones, subida en lotes | Q1 (referencia) y Q4 | combiner |
| B: infraestructura | Andrés | red del nodo, conexión del cliente, scripts, parámetros, `timeX.txt`, CSV | Q2 | tiempos por nodos, README |
| C: validación | Franco | fixtures y salidas esperadas de las cinco queries | Q3 | — |
| D: Q5 | Pablo | prototipo del reducer por fecha | Q5 | optimización particular |

Antes de separarse hay que acordar la interfaz común: el modelo de fila parseada,
la proyección que define cada query y cómo se registra una query. Eso es lo que
permite que C y D arranquen sin esperar a que esté la base.

## TPE1 — Gestión de Equipajes en Aeropuertos

- **Repositorio:** `eugemigliaro/tpe1-26Q2-g05` (privado, creado desde el
  template de la cátedra `POD-ITBA/tpe1-26Q2-g0`)
- **Integrantes:** Eugenio Migliaro, Andrés Garbarz, Franco Branda, Pablo
  Gorostiaga
- **Entrega:** jueves 24/09 23:59 · **Coloquio:** miércoles 30/09

### Cómo replicar el entorno

Los dos repositorios se clonan anidados: la wiki afuera, el TP dentro de
`entregas/`.

```shell
git clone git@github.com:eugemigliaro/programacion-de-objetos-distribuidos.git
cd programacion-de-objetos-distribuidos/entregas
git clone git@github.com:eugemigliaro/tpe1-26Q2-g05.git
```

Queda así:

```
programacion-de-objetos-distribuidos/     <- wiki: consigna, material, apuntes
├── material/catedra/practica/TPE1.pdf    <- el enunciado
├── wiki/temas/                           <- resúmenes de la teoría
└── entregas/
    └── tpe1-26Q2-g05/                    <- repo propio, es lo que se entrega
```

Trabajar **desde la raíz de la wiki** para que el agente vea las dos cosas: el
material de la cátedra y el código. El TP queda ignorado por la wiki, así que
cada repo se commitea por separado.

### Herramientas

Java 25 LTS. Maven no hace falta: el proyecto trae `mvnw`.

```shell
sudo apt update && sudo apt install -y openjdk-25-jdk
java -version   # debe decir 25
```

### Dónde está cada cosa

| Qué | Dónde |
|---|---|
| Enunciado | `material/catedra/practica/TPE1.pdf` (texto en `material/extraido/GR-E01.txt`) |
| Resumen de la consigna | `wiki/temas/tpe1-gestion-de-equipajes.md` |
| Teoría de gRPC y concurrencia | `wiki/temas/` |
| Decisiones de diseño del TP | `entregas/tpe1-26Q2-g05/doc/decisiones-de-diseno.md` |
| Plan y reparto | este archivo, más abajo |

Antes de implementar una operación, **leer su sección completa en el PDF**: los
resúmenes de la wiki no reemplazan las condiciones de error ni los ejemplos de
consola, que son contrato.

### Estado

Al 23/09: los cinco servicios están mergeados en `main`, el build compila, los
163 tests pasan y el flujo completo con los scripts empaquetados coincide con
los ejemplos de consola del PDF.

| Capa | Estado |
|---|---|
| `api` — 6 protos, 5 servicios | listo |
| Modelo de dominio y locks | listo |
| Infraestructura de eventos | listo |
| Registros y `LockOrder` | listo |
| Mapper de errores | listo |
| Andamiaje de clientes y 5 scripts | listo |
| **1. Administración** (`bagAdmin.sh`) | **listo, es la referencia** |
| 2. Gestión de vuelos (`flightManagement.sh`) | listo, en `main` |
| 3. Despacho (`bagDrop.sh`) | listo, en `main` |
| 4. Rampa (`ramp.sh`) | listo, en `main` |
| 5. Seguimiento (`track.sh`) | listo, en `main` |
| README de la entrega | completo, en `main` |
| Ctrl+C en `turnOnStation` y `bagDrop` | resuelto, en `main` |
| Citas a la wiki en el TP | no quedan: se borró `doc/etapas-3-y-4-gestion-vuelos.md`, subido por error |
| `doc/Informe.pdf` | pendiente — se redacta por fuera y se agrega como PDF |

Antes de subir el comprimido al Campus:

- Agregar `doc/Informe.pdf` con carátula que liste a todos los integrantes.
- Correr `./mvnw clean`: no se entregan binarios.
- Incluir `.git/`. La descarga desde GitHub no lo trae, así que conviene
  comprimir un `git clone` limpio al que se le agrega solo lo que falte.

El historial todavía conserva citas `[GR-E01, p. N]` en commits viejos (el
`plan.md` del servicio 3 y `doc/etapas-3-y-4-gestion-vuelos.md`, ambos ya
borrados). El árbol final está limpio, y no se reescribió el historial
compartido.

Alcance: el grupo es de menos de 5 integrantes, así que **no** entran las
secciones 5.4 (`pendingBags`), 5.5 (`dashboard`) ni 5.6 (`cartBags`).

### Reparto

Cada servicio se toma end-to-end: proto, lógica, servant, cliente, script y
pruebas. La consigna evalúa la contribución individual en el historial de git,
así que conviene que cada uno commitee lo suyo.

| Servicio | Dificultad | Responsable |
|---|---|---|
| 2. Gestión de vuelos | alta — incluye el stream de `turnOnStation` | Franco |
| 3. Despacho | alta — sesión bidireccional y exclusión de la estación | Pablo |
| 4. Rampa | media — traslados todo-o-nada | Andrés |
| 5. Seguimiento | alta — eventos de los otros cuatro servicios | Eugenio |

El servicio 5 depende de que los otros publiquen sus eventos, así que conviene
arrancarlo en paralelo y no al final.

### Puntos de contacto entre servicios

Los cinco servicios son paralelizables: la base común está hecha y cada uno suma
su `.proto`, su clase de negocio, su servant y su cliente en archivos propios.
Quedan tres lugares donde dos personas se tocan.

**`AllBagsInPlane` (servicios 2 y 4) — ya resuelto.** La condición se vuelve
cierta tanto al finalizar el bag-drop como al descargar el último equipaje, y los
dos caminos son reales porque finalizar el bag-drop no exige que los carts estén
vacíos. Está concentrado en `FlightCompletionNotifier`: los dos servicios lo
invocan después de su cambio de estado y fuera de la sección crítica. **No
reimplementar la condición.**

**Ciclo de vida de la estación (servicios 2 y 3).** El 2 hace `turnOn`/`turnOff`;
el 3 hace `occupy`/`release` durante la sesión de despacho y publica en el stream
que abrió el 2. La máquina de estados ya está en `Station` con sus transiciones
CAS: leerla antes de arrancar, no agregarle un lock.

**Ruteo de un equipaje aceptado (servicio 3).** Un equipaje va al pier si el vuelo
tiene uno, y si no al baggage room del vuelo. Es el inverso exacto de lo que hace
`BagAdminService.setPier` al drenarlo, así que conviene leer ese método antes de
escribir el despacho.

El riesgo real del paralelismo no es el merge, es que nadie corra el flujo
completo hasta tarde. Conviene reservar el último tramo para integración contra
los ejemplos de consola del PDF.

### Antes de escribir código

Leer `doc/decisiones-de-diseno.md` dentro del repo del TP. Tiene el criterio de
sincronización, el orden de adquisición de locks y la receta para agregar un
servicio siguiendo el patrón ya implementado. Sin eso, cada servicio termina
resolviendo la concurrencia a su manera y el informe no cierra.
