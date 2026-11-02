# Datos del TPE2

`data/` guarda los datasets del TPE2 que son demasiado pesados para versionar. Git lo ignora mediante la regla `laboratorio/**/data/` de `.gitignore`, así que cada integrante tiene que poblarlo por su cuenta.

## Por qué no se versionan

- GitHub rechaza archivos de más de 100 MB, y los ZIP pesan 428 MB y 1,08 GB. Una vez descomprimidos, superan los 6,7 GB.
- Se pueden volver a descargar desde los enlaces de la cátedra que figuran en la consigna (`material/catedra/practica/TPE2 Servicios de Trenes.md`, sección "Descripción Funcional").
- La consigna prohíbe incluir los CSV de la cátedra en la entrega, así que tampoco tienen que terminar en el repositorio del TP.

Los CSV de estaciones sí se versionan, porque son chicos, en `material/catedra/practica/`: `stationsCH.csv` (`HZ-D01`) y `stationsBE.csv` (`HZ-D02`).

## Archivos esperados

| Archivo | Tamaño | Descomprimido | Registros | SHA-256 del ZIP |
|---|---|---|---|---|
| `trainsBE.csv.zip` | 427.930.915 B | 1.697.259.255 B | 20.809.934 | `2d4bb49a0abeea07750effafd2585e5bd8f4b465d91ec1fcea86c6c8133bac67` |
| `trainsCH.csv.zip` | 1.077.105.591 B | 5.048.109.203 B | 42.782.820 | `4bf738a5bf5642a580c7688a842cc1920ac107bac48cf79b5615b9eb9ce5748a` |

Las copias descargadas el 02/11/2026 pasan `unzip -t` y tienen exactamente la cantidad de registros (sin contar el encabezado) que indica la consigna. Cada ZIP trae además una entrada `__MACOSX/` que no se usa.

Para comprobar una descarga nueva:

```shell
cd laboratorio/tpe2/data
sha256sum trainsBE.csv.zip trainsCH.csv.zip
```

## Armar el directorio de entrada

`-DinPath` apunta a un directorio que debe contener `trains<país>.csv` y `stations<país>.csv` con esos nombres exactos. Desde la raíz de la wiki:

```shell
cd laboratorio/tpe2/data
unzip -o trainsBE.csv.zip trainsBE.csv
unzip -o trainsCH.csv.zip trainsCH.csv
cp ../../../material/catedra/practica/stationsBE.csv ../../../material/catedra/practica/stationsCH.csv .
```

Después, cada query se corre con `-DinPath="$PWD"` (o con la ruta absoluta de este directorio).
