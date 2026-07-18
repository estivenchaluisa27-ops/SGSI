#!/bin/bash
# GRUPO 10 — red Docker (VLAN hopping)
# Activos: HW-04
# Controles: A.8.20, A.8.22
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo10"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 10: Red Docker (1 simulación)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-04 — VLAN hopping / salto de segmento (A.8.20, A.8.22)" | tee -a "$EVID_FILE"

echo "  Iniciando contenedor atacante en red sgsi-lab..."
docker run --rm --network sgsi-lab alpine ping -c 2 sgsi-postgres 2>&1 | tee "$EVID_DIR/sim1-vlan-hopping.txt" || true

if grep -q "bytes from\|64 bytes" "$EVID_DIR/sim1-vlan-hopping.txt" 2>/dev/null; then
    echo "  ❌ Contenedor atacante alcanzó Postgres en la misma red — A.8.22 (sin segmentación VLAN)" | tee -a "$EVID_FILE"
    echo "  ❌ Tráfico entre Odoo y Postgres visible desde tercer contenedor en red bridge" | tee -a "$EVID_FILE"
else
    echo "  ✅ Segmentación de red impide comunicación cross-contenedor" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 10 COMPLETADO" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
