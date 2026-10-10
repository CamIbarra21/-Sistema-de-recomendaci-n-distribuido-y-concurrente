#!/usr/bin/env bash
# Verifica los modelos Promela con Spin. Usa Spin + gcc locales si existen;
# si no, usa Docker (imagen "spin-verif", se construye con promela/Dockerfile).
#
#   ./verificar.sh              # verificación completa con 2 workers (rápida)
#   ./verificar.sh --3workers   # además main.pml con 3 workers (pesada: decenas de millones de estados)
#
# Todo se compila en un directorio temporal: no se generan archivos pan.* en el repositorio.
set -u
cd "$(dirname "$0")"

EXTRA=0
[ "${1:-}" = "--3workers" ] && EXTRA=1

CMDS='
set -u
# El modelo tiene LTL: se usa -DNOCLAIM para que Spin SÍ revise estados finales inválidos (deadlock).
titulo() { echo; echo "=== $*"; }
resumen() { grep -E "errors:|assertion violated|acceptance cycle|invalid end state|states, stored" ; }

titulo "main.pml - deadlock y aserciones (2 workers)"
spin -a main.pml >/dev/null && gcc -O2 -DNOCLAIM -o pan_s pan.c && ./pan_s | resumen
gcc -O2 -o pan pan.c
for p in todos_los_workers_terminan exclusion_mutua_resultados resultados_completos; do
    titulo "main.pml - LTL $p (equidad debil)"; ./pan -a -f -N $p | resumen
done

titulo "progreso.pml - CON lock: deadlock y aserciones"
spin -a progreso.pml >/dev/null && gcc -O2 -DNOCLAIM -o pan_p pan.c && ./pan_p | resumen
gcc -O2 -o pan_pl pan.c
for p in exclusion_mutua sin_actualizaciones_perdidas lectores_son_exclusivos; do
    titulo "progreso.pml - LTL $p"; ./pan_pl -a -N $p | resumen
done

titulo "progreso.pml - SIN lock (control negativo: debe FALLAR)"
spin -a -DSIN_LOCK progreso.pml >/dev/null && gcc -O2 -DNOCLAIM -DSIN_LOCK -o pan_n pan.c && ./pan_n | resumen
'
if [ "$EXTRA" = 1 ]; then
CMDS="$CMDS"'
titulo "main.pml - 3 workers (COLLAPSE): deadlock y aserciones"
spin -a -DCANTIDAD_WORKERS=3 main.pml >/dev/null && gcc -O2 -DCOLLAPSE -DNOCLAIM -DCANTIDAD_WORKERS=3 -o pan_3 pan.c && ./pan_3 | resumen
'
fi

if command -v spin >/dev/null 2>&1 && command -v gcc >/dev/null 2>&1; then
    tmp="$(mktemp -d)"
    cp src/*.pml "$tmp/"
    (cd "$tmp" && bash -c "$CMDS")
    rm -rf "$tmp"
else
    docker image inspect spin-verif >/dev/null 2>&1 || docker build -q -t spin-verif .
    src="$(cd src && (pwd -W 2>/dev/null || pwd))"
    MSYS_NO_PATHCONV=1 docker run --rm -v "$src:/in:ro" spin-verif \
        bash -c "mkdir /w && cp /in/*.pml /w && cd /w && $CMDS"
fi
