#!/bin/bash
# GRUPO 6 — mariadb (inventario)
# Activos: IF-09
# Controles: A.8.3, A.8.15
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo6"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 6: MariaDB (1 simulación)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: IF-09 — Alteración inventario stock (A.8.3, A.8.15)" | tee -a "$EVID_FILE"

source "$LAB_DIR/.env" 2>/dev/null || true
mysql -h 127.0.0.1 -u inventario -p"${MARIADB_PASSWORD}" --ssl=0 inventario_stock -e "UPDATE stock SET cantidad=0 WHERE id=1;" 2>&1 | tee "$EVID_DIR/sim1-mariadb-update.txt"

# Verificar si se pudo hacer el UPDATE
if mysql -h 127.0.0.1 -u inventario -p"${MARIADB_PASSWORD}" --ssl=0 inventario_stock -e "SELECT id, codigo, nombre, cantidad FROM stock WHERE id=1;" 2>&1 | tee -a "$EVID_DIR/sim1-mariadb-update.txt"; then
    echo "  ❌ UPDATE ejecutado sin registro de auditoría — A.8.15 (logging)" | tee -a "$EVID_FILE"
else
    echo "  ✅ UPDATE bloqueado por controles de integridad" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 6 COMPLETADO" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
