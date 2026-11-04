#!/usr/bin/env bash
# Calcula la salida esperada de la query 1 del TPE2 sin Hazelcast, para comparar
# contra la del TP. Escribe el CSV sin encabezado por stdout.
#
# Uso: query1.sh CH|BE DIRECTORIO_DE_ENTRADA > esperado.csv
#      cmp esperado.csv <(tail -n +2 query1.csv)
#
# El orden replica el de la consigna: servicios descendente y, si empatan, nombre
# de estación en el orden natural de java.lang.String. Para los nombres del
# dataset (todos en el plano básico de Unicode) ese orden coincide con el de bytes
# de UTF-8, que es lo que hace LC_ALL=C sort. La clave de desempate tiene que ser
# sólo el nombre: si se compara la fila entera, el ';' que sigue a "Zufikon" queda
# después del espacio de "Zufikon Hammergut" y el orden se invierte.
set -euo pipefail

country="${1:?Uso: query1.sh CH|BE DIRECTORIO}"
dir="${2:?Uso: query1.sh CH|BE DIRECTORIO}"

case "$country" in
  CH) station=3; arrival=8; departure=9 ;;
  BE) station=5; arrival=10; departure=11 ;;
  *) echo "País desconocido: $country" >&2; exit 2 ;;
esac

awk -F';' -v country="$country" -v S="$station" -v A="$arrival" -v D="$departure" '
  FNR == 1 { next }
  NR == FNR {
    area = $3
    if (country == "BE") area = substr($3, index($3, "-") + 1)
    name[$1] = $2; areas[$1] = area
    next
  }
  ($S in name) {
    services[$S]++
    arrivalDelay[$S] += ($A > 0 ? $A : 0)
    departureDelay[$S] += ($D > 0 ? $D : 0)
  }
  END {
    for (id in services)
      printf "%d\t%s\t%s;%s;%d;%d;%d\n", services[id], name[id], name[id], areas[id],
             services[id], arrivalDelay[id], departureDelay[id]
  }
' "$dir/stations$country.csv" "$dir/trains$country.csv" \
  | LC_ALL=C sort -t$'\t' -k1,1nr -k2,2 \
  | cut -f3
