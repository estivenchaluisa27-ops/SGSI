#!/bin/bash
# GRUPO 7 — mongodb (nómina)
# Activos: IF-10
# Controles: A.8.11
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo7"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 7: MongoDB (1 simulación)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: IF-10 — Exposición nómina y cuentas bancarias (A.8.11)" | tee -a "$EVID_FILE"

# Intentar dump sin autenticación
mkdir -p /tmp/nomina_dump
mongodump --uri="mongodb://localhost:27017/nomina" --out=/tmp/nomina_dump 2>&1 | tee "$EVID_DIR/sim1-mongodump.txt" || true

if ls /tmp/nomina_dump/nomina/*.bson 1>/dev/null 2>&1; then
    echo "  ❌ mongodump exitoso sin autenticación — A.8.11 (DLP no implementado)" | tee -a "$EVID_FILE"
    ls -la /tmp/nomina_dump/nomina/ | tee -a "$EVID_DIR/sim1-mongodump.txt"
else
    echo "  ✅ MongoDB requiere autenticación — dump bloqueado" | tee -a "$EVID_FILE"
fi

rm -rf /tmp/nomina_dump

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 7 COMPLETADO" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
