#!/bin/bash
# GRUPO 9 — Host Kali (ataques locales)
# Activos: HW-08, SW-10, PH-01
# Controles: A.8.11, A.8.3, A.8.15, A.5.7, A.8.7, A.8.24
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo9"
EVID_FILE="$EVID_DIR/no-conformidades.txt"
mkdir -p "$EVID_DIR"
export $(grep -v '^#' "$LAB_DIR/.env" | xargs -d '\n') 2>/dev/null || true

echo "========================================="
echo " FASE 1 - GRUPO 9: Host Kali (3 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
> "$EVID_FILE"

# --- Sim 1: HW-08 — Exfiltración datos biométricos Postgres (A.8.11) ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-08 — Exfiltración datos biométricos (A.8.11)" | tee -a "$EVID_FILE"

PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d postgres_cctv \
  -c "SELECT id, nombre, ip_address, usuario, contrasena FROM cameras;" \
  2>&1 | tee "$EVID_DIR/sim1-biometric-exfil.txt"

if grep -q "10 rows" "$EVID_DIR/sim1-biometric-exfil.txt" 2>/dev/null; then
    echo "  ❌ Datos CCTV exportados desde host Kali — A.8.11 (exfiltración)" | tee -a "$EVID_FILE"
else
    echo "  ✅ Acceso bloqueado a datos CCTV" | tee -a "$EVID_FILE"
fi

# --- Sim 2: SW-10 — Fraude facturación Odoo (A.8.3, A.8.15, A.5.7) ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: SW-10 — Fraude facturación (A.8.3, A.8.15, A.5.7)" | tee -a "$EVID_FILE"

PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db \
  -c "INSERT INTO facturas (cliente_id, numero, subtotal, iva, total, estado) VALUES (3, 'FRAUDE-99999', 84995.00, 15000.00, 99999.00, 'emitida'); UPDATE facturas SET total = total * 1.5 WHERE cliente_id = 1 AND estado = 'emitida';" \
  2>&1 | tee "$EVID_DIR/sim2-factura-fraude.txt"

echo "  Verificando transacciones fraudulentas..." | tee -a "$EVID_FILE"
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d odoo_db \
  -c "SELECT id, cliente_id, numero, total, estado FROM facturas ORDER BY id DESC LIMIT 5;" \
  2>&1 | tee -a "$EVID_DIR/sim2-factura-fraude.txt"

if grep -q "99999.00" "$EVID_DIR/sim2-factura-fraude.txt" 2>/dev/null; then
    echo "  ❌ Factura fraudulenta creada sin detección — A.8.3 (acceso no autorizado)" | tee -a "$EVID_FILE"
else
    echo "  ✅ Controles previenen facturación fraudulenta" | tee -a "$EVID_FILE"
fi

# --- Sim 3: PH-01 — Phishing simulado Gophish (A.8.7, A.8.24) ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #3: PH-01 — Phishing Gophish (A.8.7, A.8.24)" | tee -a "$EVID_FILE"

# Verificar si Gophish está instalado/corriendo
if command -v gophish &>/dev/null || [ -f /usr/bin/gophish ]; then
    echo "  Gophish detectado — ejecutando simulación..." | tee -a "$EVID_FILE"
    gophish --config /etc/gophish/config.json 2>&1 &
    GOPHISH_PID=$!
    sleep 3
    curl -s -k -X POST "https://localhost:3333/api/login" \
      -H "Content-Type: application/json" \
      -d '{"username":"admin","password":"gophish_admin_2026"}' 2>&1 | tee "$EVID_DIR/sim3-gophish-api.txt"
    kill $GOPHISH_PID 2>/dev/null
    echo "  ❌ Campaña de phishing podría ser lanzada — A.8.7 (concienciación)" | tee -a "$EVID_FILE"
else
    echo "  Gophish no instalado — simulando acceso a panel de phishing" | tee -a "$EVID_FILE"
    echo "  (Simulado: correo de phishing con enlace a /print/)"
    # Simular envío de correo de prueba local
    echo "Subject: Notificacion de nomina" > /tmp/phishing_email.txt
    echo "From: rrhh@tecnoglobal.ec" >> /tmp/phishing_email.txt
    echo "To: empleados@tecnoglobal.ec" >> /tmp/phishing_email.txt
    echo "" >> /tmp/phishing_email.txt
    echo "Estimado empleado, su nomina ha sido actualizada." >> /tmp/phishing_email.txt
    echo "Ingrese a http://localhost:8080/print/ para revisar su recibo." >> /tmp/phishing_email.txt
    cat /tmp/phishing_email.txt | tee "$EVID_DIR/sim3-phishing-email.txt"
    echo "  ❌ Vector de phishing viable — A.8.7 (concienciación deficiente)" | tee -a "$EVID_FILE"
fi

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 9 COMPLETADO — 3 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
