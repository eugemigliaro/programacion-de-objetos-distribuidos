# Entregas

Trabajos evaluados, finales o grupales. No copiar automáticamente aquí las guías
de `practica/`: primero verificar la consigna y la configuración de la materia.

Para cada entrega conviene conservar consigna, decisiones, código o documento
fuente, instrucciones de reproducción y versión final.

Las entregas que tienen su propio repositorio git se clonan acá y quedan
ignoradas por este repositorio (ver `.gitignore`). Se entregan por separado, así
que **su contenido no debe citar ni referenciar material de este repositorio**.

## TPE1 — Gestión de Equipajes en Aeropuertos

- **Repositorio:** `eugemigliaro/tpe1-26Q2-g05` (privado, creado desde el
  template de la cátedra `POD-ITBA/tpe1-26Q2-g0`)
- **Integrantes:** Eugenio Migliaro, Andrés Garbarz, Franco Branda
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
| 3. Despacho (`bagDrop.sh`) | **pendiente** — `feat/service-3` solo tiene un `plan.md` |
| 4. Rampa (`ramp.sh`) | listo, en `main` |
| 5. Seguimiento (`track.sh`) | listo en la rama `servicio-5-seguimiento`, sin mergear |
| README de la entrega | parcial — faltan las secciones 3 y 4 |
| `doc/Informe.pdf` | pendiente |

Pendientes que dejó el servicio 5 para los demás:

- **Despacho:** publicar el evento de cada equipaje aceptado dentro del lock
  del vuelo, antes de soltarlo. Es la regla de "Orden de los eventos del
  seguimiento" en `doc/decisiones-de-diseno.md`.
- **`turnOnStation`:** con Ctrl+C el cliente queda vivo 30 s por el periodo de
  gracia del canal. `TrackingClient` muestra cómo evitarlo.
- **`plan.md` de `feat/service-3`:** cita material de la wiki (`[GR-E01, p. N]`)
  y no puede llegar así al repo que se entrega.

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
