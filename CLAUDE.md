# Course Wiki

Leé y cumplí `AGENTS.md`; es la política canónica compartida con Codex y otros agentes. Leé también `materia.yaml` para conocer la materia, el idioma, el modo pedagógico y el laboratorio.

Comandos disponibles:

- `/crear-materia`
- `/estudiar-materia`
- `/incorporar-material`
- `/procesar-notas`
- `/resolver-practica`

Aplicá el mismo flujo cuando el usuario use lenguaje natural sin invocar un comando.

## Entregas con repositorio propio

Algunas entregas viven en su propio repositorio git clonado dentro de `entregas/`
e ignorado por este repositorio. Se entregan solas, así que **su contenido nunca
debe citar ni referenciar material de este repositorio**: ni rutas, ni IDs de
fuentes catalogadas, ni citas del tipo `[GR-E01, p. N]`.

Trabajar siempre **desde la raíz de este repositorio**, no desde adentro de la
entrega: es lo que te deja ver a la vez el material de la cátedra y el código.
Por la misma razón, la entrega no lleva configuración de agentes propia.

Antes de tocar el código de una entrega, leer `entregas/README.md` (estado,
reparto y cómo replicar el entorno) y el documento de decisiones de diseño que
cada entrega mantiene en su propio `doc/`. Respetar esas decisiones en lugar de
reintroducir criterios nuevos.

Cada repositorio se commitea por separado.
