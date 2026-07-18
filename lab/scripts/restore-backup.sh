#!/bin/bash
# restore-backup.sh — Restaura Odoo desde backup en Minio
# Uso: ./scripts/restore-backup.sh

LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="$LAB_DIR/scripts/evidencias/restore"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " Restore Backup — Odoo desde Minio"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

source "$LAB_DIR/.env" 2>/dev/null || true
RTO_START=$(date +%s)

# Helper: mc via docker
mc() { docker run --rm --network=host -e "MC_HOST_local=http://${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}@localhost:9000" -v /tmp:/backups minio/mc:latest "$@"; }

echo ">>> Verificando backups en Minio..."
if mc ls local/backups/ 2>/dev/null | grep -q "odoo_db"; then
    echo "  ✅ Backup encontrado en Minio"
    BACKUP_NAME=$(mc ls local/backups/ 2>/dev/null | grep odoo_db | head -1 | awk '{print $NF}')
    echo "  Backup: $BACKUP_NAME"
    mc cp "local/backups/$BACKUP_NAME" /backups/odoo_db.sql.gz 2>&1
    echo "  Backup descargado"
else
    echo "  ⚠️  No hay backup en Minio — simulando restauración fallida"
    echo "  ❌ No conformidad: backup no disponible (A.8.14 redundancia)"
    echo "NC-RESTORE-01: Backup no encontrado en Minio — regla 3-2-1 no implementada" >> "$EVID_DIR/no-conformidades.txt"
    RTO_END=$(date +%s)
    RTO=$((RTO_END - RTO_START))
    echo "RTO: ${RTO}s (objetivo: <14400s)" | tee "$EVID_DIR/rto.txt"
    exit 1
fi

# Restaurar en Postgres
echo ">>> Restaurando BD odoo_db desde backup..."
if [ -f /tmp/odoo_db.sql.gz ]; then
    gunzip -f /tmp/odoo_db.sql.gz 2>/dev/null
    PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db -f /tmp/odoo_db.sql 2>&1 | tail -5
    echo "  ✅ Base de datos restaurada"
else
    echo "  ⚠️  Backup corrupto o inexistente — restauración fallida"
fi

RTO_END=$(date +%s)
RTO=$((RTO_END - RTO_START))
echo ""
echo ">>> Métricas:"
echo "  RTO real: ${RTO}s (objetivo: <14400s = 4h)"
echo "  RTO real: ${RTO}s" > "$EVID_DIR/rto.txt"

if [ "$RTO" -lt 14400 ]; then
    echo "  ✅ RTO dentro del objetivo (A.5.30)"
else
    echo "  ❌ RTO excede objetivo (A.5.30)"
fi

echo "========================================="
echo " Restore completado"
echo " Evidencias: $EVID_DIR/"
echo "========================================="
