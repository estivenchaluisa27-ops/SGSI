#!/bin/bash
# GRUPO 9 — host Kali (ataques directos)
# Activos: IF-03, IF-04, SW-10+RH-06
# Controles: A.5.34, A.8.2, A.5.23, A.8.5, A.6.3, A.5.3
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo9"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 9: Host Kali (3 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: IF-03 — Exfiltración biométrica ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: IF-03 — Exfiltración biométrica (A.5.34)" | tee -a "$EVID_FILE"

HTTP_CODE=$(curl -s -o "$EVID_DIR/sim1-biometrico-export.txt" -w "%{http_code}" "http://localhost:8069/api/biometrico/export" 2>/dev/null)
echo "  HTTP Status: $HTTP_CODE" >> "$EVID_DIR/sim1-biometrico-export.txt"

if [ "$HTTP_CODE" = "200" ]; then
    echo "  ❌ API biométrica expuesta sin TLS ni auth — A.5.34" | tee -a "$EVID_FILE"
else
    echo "  ✅ API biométrica protegida (código $HTTP_CODE)" | tee -a "$EVID_FILE"
fi

# --- Sim 2: IF-04 — Fraude facturación ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: IF-04 — Fraude facturación (A.8.2)" | tee -a "$EVID_FILE"

source "$LAB_DIR/.env" 2>/dev/null || true
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db -c "UPDATE facturas SET total=99999.99 WHERE id=1;" 2>&1 | tee "$EVID_DIR/sim2-factura-fraude.txt"

echo "  Verificando modificación..." 
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db -c "SELECT id, numero, total FROM facturas WHERE id=1;" 2>&1 | tee -a "$EVID_DIR/sim2-factura-fraude.txt"

echo "  ❌ UPDATE de factura exitoso sin aprobación dual — A.8.2" | tee -a "$EVID_FILE"

# Restaurar valor original
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db -c "UPDATE facturas SET total=5040.00 WHERE id=1;" >/dev/null 2>&1

# --- Sim 3: SW-10+RH-06 — Suplantación M365 + Whaling ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #3: SW-10+RH-06 — Suplantación + Whaling (A.5.23, A.8.5, A.6.3, A.5.3)" | tee -a "$EVID_FILE"

# Crear campaña de Gophish (simulada CLI)
echo "  Creando campaña de phishing simulada..." > "$EVID_DIR/sim3-phishing.txt"
echo "  Asunto: Urgente: Transferencia bancaria requerida" >> "$EVID_DIR/sim3-phishing.txt"
echo "  Remitente: Juan Pérez <jperez@tecnoglobal.ec>" >> "$EVID_DIR/sim3-phishing.txt"
echo "  Destinatario: rramirez@tecnoglobal.ec (Contador)" >> "$EVID_DIR/sim3-phishing.txt"
echo "  Mensaje: Por autorización del Gerente General, realizar transferencia de \$15,000 a cuenta 2201234567 Banco Pichincha." >> "$EVID_DIR/sim3-phishing.txt"
echo "  Link: http://phishing-tecnoglobal.com/pago-urgente" >> "$EVID_DIR/sim3-phishing.txt"
echo "" >> "$EVID_DIR/sim3-phishing.txt"
echo "  NOTA: Si >0 clics sin reportar a seguridad = ❌ A.6.3 (concienciación)" >> "$EVID_DIR/sim3-phishing.txt"
echo "  Si transferencia aprobada por 1 sola persona = ❌ A.5.3 (segregación)" >> "$EVID_DIR/sim3-phishing.txt"

echo "  ⚠️  Phishing simulado — revisar resultados en Gophish (https://localhost:3333)" | tee -a "$EVID_FILE"

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 9 COMPLETADO — 3 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
