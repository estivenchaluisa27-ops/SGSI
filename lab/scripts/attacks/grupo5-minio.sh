#!/bin/bash
# GRUPO 5 — minio (NAS + backups)
# Activos: HW-05, IF-06
# Controles: A.8.13, A.8.14, A.8.22, A.5.30
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo5"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 5: Minio (2 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: HW-05 — Pérdida irrecuperable backups ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-05 — Pérdida backups (A.8.13, A.8.14)" | tee -a "$EVID_FILE"

echo "  Borrando backups en Minio..."
docker run --rm --network host --entrypoint /bin/sh minio/mc:latest \
  -c "mc alias set local http://localhost:9000 minio_admin 'M1n10_B4ckupS_Str0ng_' && mc rm --recursive --force local/backups/" \
  2>&1 | tee "$EVID_DIR/sim1-backup-delete.txt"

echo "  Intentando restaurar..."
bash "$LAB_DIR/scripts/restore-backup.sh" 2>&1 | tee "$EVID_DIR/sim1-restore-attempt.txt" || true

if grep -q "fallida\|No conformidad\|no disponible" "$EVID_DIR/sim1-restore-attempt.txt" 2>/dev/null; then
    echo "  ❌ Restauración fallida — A.8.14 (redundancia no implementada)" | tee -a "$EVID_FILE"
else
    echo "  ✅ Restauración exitosa — regla 3-2-1 funciona" | tee -a "$EVID_FILE"
fi

# --- Sim 2: IF-06 — Ransomware sobre backups ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: IF-06 — Ransomware sobre backups (A.8.13, A.8.22, A.5.30)" | tee -a "$EVID_FILE"

bash "$LAB_DIR/scripts/simulate-ransomware.sh" 2>&1 | tee "$EVID_DIR/sim2-ransomware.txt"

if grep -q "cifrados" "$EVID_DIR/sim2-ransomware.txt" 2>/dev/null; then
    echo "  ❌ Ransomware exitoso — A.8.22 (segregación no implementada)" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 5 COMPLETADO — 2 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
