#!/bin/bash
# GRUPO 8 — certbot (SSL/TLS)
# Activos: IF-08
# Controles: A.8.24, A.8.16
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo8"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 8: Certbot SSL (1 simulación)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: IF-08 — Expiración SSL sin aviso (A.8.24, A.8.16)" | tee -a "$EVID_FILE"

# Forzar expiración simulada moviendo/borrando cert
echo "  Simulando expiración de certificado SSL..."
docker exec sgsi-nginx-vuln rm -f /etc/nginx/ssl/self-signed.crt 2>&1
docker exec sgsi-nginx-vuln nginx -s reload 2>&1 || true

# Verificar TLS
echo "  Verificando conexión HTTPS..."
curl -k -v "https://localhost/" 2>&1 | tee "$EVID_DIR/sim1-ssl-expired.txt" || true

if grep -q "error\|SSL\|certificate\|handshake\|alert" "$EVID_DIR/sim1-ssl-expired.txt" 2>/dev/null; then
    echo "  ❌ Error TLS detectado — certificado expirado/no encontrado" | tee -a "$EVID_FILE"
    echo "  ❌ No hay monitoreo de expiración SSL — A.8.16" | tee -a "$EVID_FILE"
else
    echo "  ✅ HTTPS funcionando aún con certificado expirado (posible downgrade)" | tee -a "$EVID_FILE"
fi

# Restaurar certificado
echo "  Restaurando certificado..."
docker cp "$LAB_DIR/data/nginx-ssl/self-signed.crt" sgsi-nginx-vuln:/etc/nginx/ssl/ 2>&1
docker exec sgsi-nginx-vuln nginx -s reload 2>&1 || true

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 8 COMPLETADO" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
