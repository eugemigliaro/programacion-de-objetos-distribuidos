#!/usr/bin/env bash
# Calcula la salida esperada de la query 5 del TPE2 sin Hazelcast, para comparar
# contra la del TP. Escribe el CSV sin encabezado por stdout.
#
# Uso: query5.sh CH|BE DIRECTORIO minServices > esperado.csv
#      cmp esperado.csv <(tail -n +2 query5.csv)
#
# A diferencia del TP, que reagrupa la suma y guarda sólo los extremos de cada
# recorrido, este cálculo hace lo que dice el enunciado al pie de la letra: ordena
# todas las paradas de cada (fecha, tren, operador) por llegada prevista, salida
# prevista y nombre de estación, y suma las diferencias entre paradas consecutivas.
# El orden es el de bytes (LC_ALL=C), que para estos datos coincide con el natural
# de java.lang.String. Necesita espacio temporal para ordenar: usa TMPDIR.
set -euo pipefail

country="${1:?Uso: query5.sh CH|BE DIRECTORIO minServices}"
dir="${2:?Uso: query5.sh CH|BE DIRECTORIO minServices}"
min="${3:?Uso: query5.sh CH|BE DIRECTORIO minServices}"

case "$country" in
  CH|BE) ;;
  *) echo "País desconocido: $country" >&2; exit 2 ;;
esac

# 1. Una línea por parada de estación conocida, con fechas ordenables:
#    fecha  tren  operador  llegada  salida  estación  demora_llegada  demora_salida
awk -F';' -v country="$country" '
  BEGIN {
    split("JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC", m, " ")
    for (i = 1; i <= 12; i++) month[m[i]] = sprintf("%02d", i)
    OFS = "\t"
  }
  function be_date(d) { return substr(d, 6, 4) "-" month[toupper(substr(d, 3, 3))] "-" substr(d, 1, 2) }
  function be_time(t) { return (length(t) == 7 ? "0" t : t) }
  FNR == 1 { next }
  NR == FNR { name[$1] = $2; next }
  country == "CH" && ($3 in name) { print $1, $2, $4, $6, $7, name[$3], $8, $9 }
  country == "BE" && ($5 in name) {
    print be_date($1), $2, $3, be_date($6) " " be_time($7), be_date($8) " " be_time($9), name[$5], $10, $11
  }
' "$dir/stations$country.csv" "$dir/trains$country.csv" \
  | LC_ALL=C sort -t$'\t' -k1,1 -k2,2 -k3,3 -k4,4 -k5,5 -k6,6 -S 2G \
  | LC_ALL=C awk -F'\t' -v min="$min" '
      # 2. Recorre cada recorrido en orden y suma llegada(i+1) - salida(i).
      function close_journey() {
        if (count >= min && effect > 0) {
          if (!(day in best) || effect > best[day] || (effect == best[day] && train < winner[day])) {
            best[day] = effect; winner[day] = train; services[day] = count
          }
        }
      }
      {
        key = $1 SUBSEP $2 SUBSEP $3
        if (key != current) {
          if (NR > 1) close_journey()
          current = key; day = $1; train = $2; count = 0; effect = 0
        } else {
          effect += $7 - previousDeparture
        }
        count++
        previousDeparture = $8
      }
      END {
        close_journey()
        for (d in best) printf "%s\t%s;%s;%d;%d\n", d, substr(d, 9, 2) "/" substr(d, 6, 2) "/" substr(d, 1, 4), winner[d], services[d], best[d]
      }
    ' \
  | LC_ALL=C sort -t$'\t' -k1,1 \
  | cut -f2
