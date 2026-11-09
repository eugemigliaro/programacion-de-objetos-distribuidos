#!/usr/bin/env bash
# Calcula la salida esperada de la query 4 del TPE2 sin Hazelcast, para comparar
# contra la del TP. Escribe el CSV sin encabezado por stdout.
#
# Uso: query4.sh CH|BE DIRECTORIO n q latMin latMax lonMin lonMax > esperado.csv
#      cmp esperado.csv <(tail -n +2 query4.csv)
#
# awk suma servicios y demoras de llegada con signo por estación (enteros, exactos
# en awk hasta 2^53). Python arma los cuadrantes y el ranking con fracciones
# exactas: el piso de lat/q no pasa por double, el ranking compara la media exacta
# y el truncado es hacia cero. Los nombres se comparan por punto de código, que
# para los nombres del dataset coincide con el orden natural de java.lang.String.
set -euo pipefail

usage="Uso: query4.sh CH|BE DIRECTORIO n q latMin latMax lonMin lonMax"
country="${1:?$usage}"; dir="${2:?$usage}"
n="${3:?$usage}"; q="${4:?$usage}"
lat_min="${5:?$usage}"; lat_max="${6:?$usage}"; lon_min="${7:?$usage}"; lon_max="${8:?$usage}"

case "$country" in
  CH) station=3; arrival=8 ;;
  BE) station=5; arrival=10 ;;
  *) echo "País desconocido: $country" >&2; exit 2 ;;
esac

totals="$(mktemp)"
trap 'rm -f "$totals"' EXIT

awk -F';' -v S="$station" -v A="$arrival" '
  NR > 1 { services[$S]++; delay[$S] += $A }
  END { for (id in services) printf "%s\t%d\t%d\n", id, services[id], delay[id] }
' "$dir/trains$country.csv" > "$totals"

python3 -I - "$country" "$dir/stations$country.csv" "$totals" \
  "$n" "$q" "$lat_min" "$lat_max" "$lon_min" "$lon_max" <<'PYTHON'
import math
import sys
from decimal import Decimal
from fractions import Fraction

country, stations_file, totals_file = sys.argv[1:4]
n = int(sys.argv[4])
q, lat_min, lat_max, lon_min, lon_max = (Fraction(Decimal(v)) for v in sys.argv[5:10])

stations = {}
with open(stations_file, encoding="utf-8") as lines:
    next(lines)
    for line in lines:
        fields = line.rstrip("\n").split(";")
        if country == "CH":
            lat, lon, area = fields[3], fields[4], fields[2]
        else:
            lat, lon = (v.strip() for v in fields[3].split(","))
            area = fields[2].split("-", 1)[1]
        stations[fields[0]] = (fields[1], area, Fraction(Decimal(lat)), Fraction(Decimal(lon)))

quadrants = {}
with open(totals_file, encoding="utf-8") as lines:
    for line in lines:
        station_id, services, delay = line.split("\t")
        if station_id not in stations:
            continue
        name, area, lat, lon = stations[station_id]
        if not (lat_min <= lat < lat_max and lon_min <= lon < lon_max):
            continue
        quadrant = (math.floor(lat / q), math.floor(lon / q))
        quadrants.setdefault(quadrant, []).append((Fraction(int(delay), int(services)), name, area))


def truncated(mean):
    hundredths = math.trunc(mean * 100)
    sign = "-" if hundredths < 0 else ""
    return f"{sign}{abs(hundredths) // 100}.{abs(hundredths) % 100:02d}"


for quadrant in sorted(quadrants):
    ranking = sorted(quadrants[quadrant], key=lambda s: (-s[0], s[1]))
    for rank, (mean, name, area) in enumerate(ranking[:n], start=1):
        print(f"{quadrant[0]};{quadrant[1]};{rank};{name};{area};{truncated(mean)}")
PYTHON
