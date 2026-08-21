# Dudas y conflictos

Registrar aquí contradicciones entre fuentes, afirmaciones dudosas de las notas y preguntas que el material disponible todavía no permite resolver.

| Estado | Tema | Hallazgo | Evidencia | Próximo paso |
|---|---|---|---|---|
| Abierto | Estados de `Thread` | La figura usa `New`, `Ready-to-Run`, `Running`, `Sleeping`, `Waiting`, `Blocking` y `Dead`, mientras el TP observa el valor devuelto por `Thread#getState`; el material no explicita la correspondencia entre ambas nomenclaturas. | [PC-T01, p. 29]; [PC-P01, p. 2] | Confirmar qué conjunto de estados exige la cátedra en examen y documentar la equivalencia. |
| Abierto | `volatile` y *happens-before* | Una página establece correctamente una relación entre escritura y lectura del mismo campo `volatile`; la página siguiente dice “escrituras” en ambos extremos, probablemente por un error de redacción. | [PC-T02, p. 14] [PC-T02, p. 15] | Usar la formulación de la p. 14 y consultar si se publica una fe de erratas. |
| Abierto | Cierre de ejecutores | El texto agrupa `shutdown` y `shutdownNow` como señales de interrupción, pero el patrón posterior presenta `shutdownNow` como escalamiento tras esperar la terminación. El alcance de cada operación no queda explicado. | [PC-T01, p. 37] [PC-T01, p. 38] | Verificar la semántica exigida contra la versión de Java adoptada por la materia. |
| Abierto | `SynchronousQueue` | La presentación la describe como una cola que “solo acepta 1 elemento”. **Conocimiento general a verificar:** su semántica habitual es una transferencia directa sin capacidad interna. | [PC-T03, p. 11] | Confirmar con la documentación del runtime cuando se configure el laboratorio. |
