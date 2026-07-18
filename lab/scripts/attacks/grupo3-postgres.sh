#!/bin/bash
# GRUPO 3 — postgres-erp (BD ERP + CCTV)
# Activos: SW-06, IF-02
# Controles: A.8.15, A.8.24, A.8.20, A.5.7, A.8.3
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo3"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 3: Postgres (2 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: SW-06 — Inyección SQL PostgreSQL ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: SW-06 — Inyección SQL PostgreSQL (A.8.15, A.8.24, A.8.20, A.5.7)" | tee -a "$EVID_FILE"

source "$LAB_DIR/.env" 2>/dev/null || true
sqlmap -d "postgresql://odoo:${POSTGRES_ERP_PASSWORD}@localhost:5432/odoo_db" --batch --dump --time-sec 2 2>&1 | tail -40 | tee "$EVID_DIR/sim1-sqlmap-postgres.txt" || true

if grep -q "Table\|Database\|dump\|entries" "$EVID_DIR/sim1-sqlmap-postgres.txt" 2>/dev/null; then
    echo "  ❌ SQLi exitosa — datos extraídos (A.8.15)" | tee -a "$EVID_FILE"
else
    echo "  ✅ SQLi no logró extraer datos — controles protegen" | tee -a "$EVID_FILE"
fi

# --- Sim 2: IF-02 — Acceso BD CCTV ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: IF-02 — Acceso BD contraseñas CCTV (A.8.24, A.8.3)" | tee -a "$EVID_FILE"

PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d postgres_cctv -c "SELECT id, nombre, ip_address, usuario, contrasena FROM cameras LIMIT 5;" 2>&1 | tee "$EVID_DIR/sim2-cctv-creds.txt"

if grep -q "cctv_pass\|admin" "$EVID_DIR/sim2-cctv-creds.txt" 2>/dev/null; then
    echo "  ❌ Acceso a BD CCTV sin autorización específica — A.8.3" | tee -a "$EVID_FILE"
else
    echo "  ✅ Acceso denegado a BD CCTV" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 3 COMPLETADO — 2 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
