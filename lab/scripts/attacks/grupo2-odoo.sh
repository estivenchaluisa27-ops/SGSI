#!/bin/bash
# GRUPO 2 — odoo (ERP crítico)
# Activos: HW-01, HW-06, SW-01, SW-03
# Controles: A.8.13, A.8.14, A.5.30, A.6.7, A.8.24, A.8.7, A.8.15, A.8.5, A.8.1
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo2"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 2: Odoo ERP (4 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

TARGET="localhost"
EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: HW-01 — Fallo crítico hardware ERP ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-01 — Fallo crítico hardware ERP (A.8.13, A.8.14, A.5.30)" | tee -a "$EVID_FILE"

RTO_START=$(date +%s)
echo "  Parando contenedor Odoo..."
docker stop sgsi-odoo 2>&1 | tee "$EVID_DIR/sim1-hw01-stoppp.log"
sleep 5

echo "  Intentando restaurar desde backup..."
bash "$LAB_DIR/scripts/restore-backup.sh" 2>&1 | tee "$EVID_DIR/sim1-restore.log"

echo "  Re-iniciando Odoo..."
docker start sgsi-odoo 2>&1 | tee -a "$EVID_DIR/sim1-hw01-stoppp.log"
RTO_END=$(date +%s)
RTO=$((RTO_END - RTO_START))

echo "  RTO real: ${RTO}s" > "$EVID_DIR/sim1-hw01-timestamps.txt"
echo "  RPO objetivo: 1h (simulado)" >> "$EVID_DIR/sim1-hw01-timestamps.txt"

if [ "$RTO" -lt 14400 ]; then
    echo "  ✅ RTO dentro del objetivo (${RTO}s < 14400s)" | tee -a "$EVID_FILE"
else
    echo "  ❌ RTO excede objetivo (${RTO}s >= 14400s) — A.5.30" | tee -a "$EVID_FILE"
fi

# --- Sim 2: HW-06 — Robo laptop gerencia ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: HW-06 — Robo laptop gerencia (A.6.7, A.8.24, A.8.7)" | tee -a "$EVID_FILE"

curl -s -H "X-Forwarded-For: 203.0.113.1" "http://$TARGET:8069/web/login" 2>/dev/null | head -30 | tee "$EVID_DIR/sim2-ip-externa-login.txt"

if grep -q "session_id\|token\|logged" "$EVID_DIR/sim2-ip-externa-login.txt" 2>/dev/null; then
    echo "  ❌ Login exitoso desde IP externa sin MFA — A.6.7" | tee -a "$EVID_FILE"
else
    echo "  ✅ Login desde IP externa bloqueado o requiere MFA" | tee -a "$EVID_FILE"
fi

# --- Sim 3: SW-01 — Acceso no autorizado ERP ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #3: SW-01 — Acceso no autorizado ERP (A.8.15, A.8.24, A.8.5)" | tee -a "$EVID_FILE"

sqlmap -u "http://$TARGET:8069/web/login" --data "login=admin&password=admin" --batch --time-sec 2 2>&1 | tail -30 | tee "$EVID_DIR/sim3-sqlmap-output.txt" || true

if grep -q "Parameter.*GET\|POST.*vulnerable\|injectable" "$EVID_DIR/sim3-sqlmap-output.txt" 2>/dev/null; then
    echo "  ❌ SQL injection detectada — A.8.15" | tee -a "$EVID_FILE"
else
    echo "  ✅ No se detectó inyección SQL" | tee -a "$EVID_FILE"
fi

# --- Sim 4: SW-03 — Fuga planos AutoCAD ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #4: SW-03 — Fuga planos AutoCAD (A.8.1, A.8.15)" | tee -a "$EVID_FILE"

HTTP_CODE=$(curl -s -o "$EVID_DIR/sim4-planos-cad.txt" -w "%{http_code}" "http://$TARGET:8069/web/content/plano.dwg" 2>/dev/null)
echo "  HTTP Status: $HTTP_CODE" >> "$EVID_DIR/sim4-planos-cad.txt"

if [ "$HTTP_CODE" = "200" ]; then
    echo "  ❌ Archivo descargado sin autenticación — A.8.1" | tee -a "$EVID_FILE"
else
    echo "  ✅ Acceso denegado (código $HTTP_CODE)" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
echo ">>> POST-SIM: Revisión SIEM" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 2 COMPLETADO — 4 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
