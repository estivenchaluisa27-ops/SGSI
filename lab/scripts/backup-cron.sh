#!/bin/bash
# PATCH NC-4: Backup automático Odoo (Postgres) → Minio
# A.8.13 (backup diario) + A.8.14 (redundancia — copia local extra)
# Ejecutar via cron: 0 2 * * * /home/kali/SGSI/lab/scripts/backup-cron.sh
#===========================================================

LAB_DIR="/home/kali/SGSI/lab"
source "$LAB_DIR/.env"

BACKUP_DIR="$LAB_DIR/backups"
MINIO_BUCKET="backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ODOO_DUMP="odoo_db-${TIMESTAMP}.sql"
CCTV_DUMP="postgres_cctv-${TIMESTAMP}.sql"

mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando backup..." >> "$BACKUP_DIR/backup-cron.log"

# 1. Dump Odoo DB (A.8.13)
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" pg_dump -h localhost -U odoo -d odoo_db > "$BACKUP_DIR/$ODOO_DUMP" 2>> "$BACKUP_DIR/backup-cron.log"
gzip "$BACKUP_DIR/$ODOO_DUMP"
echo "  Odoo DB dump: $ODOO_DUMP.gz ($(wc -c < "$BACKUP_DIR/$ODOO_DUMP.gz") bytes)" >> "$BACKUP_DIR/backup-cron.log"

# 2. Dump CCTV DB
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" pg_dump -h localhost -U odoo -d postgres_cctv > "$BACKUP_DIR/$CCTV_DUMP" 2>> "$BACKUP_DIR/backup-cron.log"
gzip "$BACKUP_DIR/$CCTV_DUMP"
echo "  CCTV DB dump: $CCTV_DUMP.gz ($(wc -c < "$BACKUP_DIR/$CCTV_DUMP.gz") bytes)" >> "$BACKUP_DIR/backup-cron.log"

# 3. Subir a Minio (copia externa — A.8.14) via docker mc
mc_upload() { docker run --rm --network=host -e "MC_HOST_local=http://${MINIO_ROOT_USER}:${MINIO_ROOT_PASSWORD}@localhost:9000" -v "${BACKUP_DIR}:/backups" minio/mc:latest cp "/backups/$1" "local/$MINIO_BUCKET/"; }
mc_upload "$ODOO_DUMP.gz" 2>> "$BACKUP_DIR/backup-cron.log"
mc_upload "$CCTV_DUMP.gz" 2>> "$BACKUP_DIR/backup-cron.log"
echo "  Subido a Minio bucket '$MINIO_BUCKET'" >> "$BACKUP_DIR/backup-cron.log"

# 4. Retención local: mantener últimos 7 dumps
ls -t "$BACKUP_DIR"/odoo_db-*.sql.gz 2>/dev/null | tail -n +8 | xargs -r rm
ls -t "$BACKUP_DIR"/postgres_cctv-*.sql.gz 2>/dev/null | tail -n +8 | xargs -r rm

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completado." >> "$BACKUP_DIR/backup-cron.log"
echo "---" >> "$BACKUP_DIR/backup-cron.log"
