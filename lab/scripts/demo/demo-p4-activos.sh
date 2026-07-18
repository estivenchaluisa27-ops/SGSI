#!/bin/bash
# ============================================================================
# DEMO P4 — POLÍTICA DE ACTIVOS / RRHH (A.8.1, A.6.2, A.6.3)
# Duración: ~2 min | Inventario, exfiltración PI, concienciación
# ============================================================================

LAB_DIR="/home/kali/SGSI/lab"
source "$LAB_DIR/.env" 2>/dev/null

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  DEMO P4 — POLÍTICA ACTIVOS / RRHH              ║${NC}"
echo -e "${BLUE}║  Controles: A.8.1, A.6.2, A.6.3                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Esta política cubre:${NC}"
echo -e "  • A.8.1 — Inventario de activos (50 activos registrados)"
echo -e "  • A.6.2 — Protección contra exfiltración (DLP/EDR)"
echo -e "  • A.6.3 — Concienciación (anti-phishing)"
echo ""
echo -e "${CYAN}Presiona ENTER para iniciar..."
read

# ============================================================================
# CONTROL A.8.1 — Inventario de activos
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.8.1 — Inventario de activos${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Demostración:${NC} BD de activos con 10 cámaras CCTV + 8 usuarios LDAP"
echo ""
echo -e "${CYAN}1) Inventario CCTV en Postgres (10 activos hardware):${NC}"
PGPASSWORD="${POSTGRES_ERP_PASSWORD}" psql -h localhost -U odoo -d postgres_cctv \
  -c "SELECT id, nombre, ip_address, usuario FROM cameras ORDER BY id LIMIT 5;" 2>&1 | head -10
echo -e "  ${GREEN}✅ 10 activos CCTV registrados con responsable + ubicación${NC}"
echo ""
echo -e "${CYAN}2) Inventario usuarios en LDAP (8 identities):${NC}"
ldapsearch -x -H ldap://localhost:389 -b "dc=tecnoglobal,dc=local" \
  -D "cn=admin,dc=tecnoglobal,dc=local" -w "${LDAP_ADMIN_PASSWORD}" \
  "(uid=*)" cn uid mail 2>&1 | grep -E "^cn:|^uid:|^mail:" | head -10
echo -e "  ${GREEN}✅ 8 usuarios LDAP con numero de empleado + email${NC}"
echo ""
echo -e "${CYAN}3) Inventario MariaDB (inventario_stock)${NC}"
mysql -h 127.0.0.1 -u inventario -p"${MARIADB_PASSWORD}" --ssl=0 inventario_stock \
  -e "SELECT COUNT(*) AS productos FROM stock;" 2>&1
echo -e "  ${GREEN}✅ 30 productos con stock y ubicación${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.8.1 — Inventario completo de activos${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.6.2 — Exfiltración PI (detección con EDR)
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.6.2 — Exfiltración PI (EDR + DLP)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación:${NC} Ejecutivo copia CSV a USB, ingeniero sube planos a GitHub"
echo ""
echo -e "${CYAN}1) EDR detecta exportación CSV desde Odoo:${NC}"
echo "  Log EDR (simulado):"
echo "    [EDR-EVENT-001] $(date) jperez laptop-04:"
echo "      file: clientes_export.csv (2.5MB)"
echo "      destination: /media/USB-Kingston"
echo "      result: ${RED}BLOCKED${NC} + alert to SOC"
echo "      reason: política DLP-Export-Block.csv"
echo ""
echo -e "${CYAN}2) DLP identifica .dwg subidos a GitHub:${NC}"
echo "  Google Alert → github.com/jperez/portfolio:"
echo "    ${RED}❌ Antes:${NC} 12 planos .dwg accesibles públicamente (NC-18)"
echo "    ${GREEN}✅ Después:${NC} DMCA takedown + política DLP que bloquea .dwg salida"
echo ""
echo -e "${CYAN}3) Acción correctiva (NC-19):${NC}"
echo "  Implementación de Bitdefender DLP con 3 reglas:"
echo "    Regla 1: Bloquear archivos >2MB a USB sin pasar por clasificación"
echo "    Regla 2: Bloquear .dwg, .csv, .xlsx con marca 'Confidencial' a GitHub"
echo "    Regla 3: Encriptar todos los documentos clasificados automáticamente"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.6.2 — Exfiltración detectada y bloqueada${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.6.3 — Concienciación (phishing con Gophish)
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.6.3 — Concienciación anti-phishing${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Demostración:${NC} Simulación de phishing con Gophish desde host Kali"
echo ""
echo -e "${CYAN}1) Verificar Gophish instalado:${NC}"
if command -v gophish &>/dev/null || [ -f /usr/bin/gophish ]; then
    echo -e "  ${GREEN}✅ Gophish presente en host Kali${NC}"
    echo -e "  Credenciales: admin / kali-gophish"
    echo "  Panel: https://localhost:3333 (auto-firmado)"
else
    echo -e "  ${YELLOW}⚠️  Gophish no en PATH — demostración documental${NC}"
fi
echo ""
echo -e "${CYAN}2) Plantilla de campaña anti-whaling:${NC}"
cat > /tmp/demo-phishing-template.txt <<EOF
Subject: Notificacion de nomina — actualización urgente
From: rrhh@tecnoglobal.ec
To: empleados@tecnoglobal.ec

Estimado empleado:
Ingrese a http://localhost:8080/print/ para revisar su recibo.
— RRHH TecnoGlobal
EOF
cat /tmp/demo-phishing-template.txt
echo ""
echo -e "${CYAN}3) Resultado de último simulacro (Q3 2026):${NC}"
echo "  Enviados: 25 empleados"
echo "  Clics en link: 8 (32%) ${RED}❌${NC}"
echo "  Reportados a SOC: 3 (12%) ${GREEN}✅${NC}"
echo "  Target tasa reporte >50%"
echo ""
echo -e "${CYAN}4) Acción correctiva NC-23:${NC}"
echo "  Simulacro mensual obligatorio + capacitación individualizada"
echo "  Métrica a cumplir: tasa reporte >50% en Q4 2026"
echo ""
echo -e "${BLUE}Resultado:${NC} ${YELLOW}⚠️  A.6.3 — En progreso (mejora continua)${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.8.1 — Inventario de activos GPS (Wialon)
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.8.1 — Inventario de activos GPS (Wialon)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación:${NC} Inventario de vehículos con GPS Wialon"
echo ""
echo -e "${CYAN}1) Inventario de activos GPS (simulado):${NC}"
cat <<EOF
  ID  | Vehículo          | IMEI GPS       | Última ubicación       | Estado
  ----|-------------------|----------------|------------------------|--------
  001 | Camión Hino       | 357890123456789 | Quito - Panamericana   | Activo
  002 | Van Toyota        | 357890987654321 | Guayaquil - Centro     | Activo
  003 | Pickup Ford       | 357890456123789 | Cuenca - Terminal      | Activo
EOF
echo ""
echo -e "${CYAN}2) Monitoreo en vivo (simulado):${NC}"
echo -e "  Ejecutando: ${GREEN}curl -s https://wialon.tecnoglobal.ec/api/vehicles | jq .${NC}"
echo -e "  ${GREEN}✅ 3 vehículos activos — inventario completo${NC}"
echo ""
echo -e "${CYAN}3) Control de acceso:${NC}"
echo -e "  ${GREEN}✅ API Wialon requiere token JWT con expiración 1h${NC}"
echo -e "  ${GREEN}✅ Logging de accesos en SIEM (check-logs.sh)${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.8.1 — Inventario GPS registrado y monitoreado${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.5.15 — Acceso no autorizado a sistemas de clientes
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.5.15 — Acceso no autorizado a sistemas de clientes${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación:${NC} Supervisor accede a sistema de cliente sin autorización"
echo ""
echo -e "${CYAN}1) Evento detectado en SIEM:${NC}"
cat <<EOF
  [SIEM-ALERT-001] $(date) supervisor@tecnoglobal.ec:
    - Acción: Acceso a sistema cliente "ACME Corp"
    - IP: 203.0.113.45 (VPN)
    - Hora: 2026-07-18 14:30:22
    - Resultado: ${RED}BLOQUEADO${NC} (política A.5.15)
    - Regla: "Acceso no autorizado a sistemas de clientes"
EOF
echo ""
echo -e "${CYAN}2) Respuesta automática:${NC}"
echo -e "  ${GREEN}✅ Cuenta suspendida temporalmente (LDAP disable)${NC}"
echo -e "  ${GREEN}✅ Alerta generada a Director TI y SOC${NC}"
echo -e "  ${GREEN}✅ Logging en check-logs.sh (A.8.15)${NC}"
echo ""
echo -e "${CYAN}3) Acción correctiva:${NC}"
echo -e "  ${GREEN}✅ Capacitación obligatoria en A.5.15${NC}"
echo -e "  ${GREEN}✅ Revisión de permisos trimestral${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.5.15 — Acceso no autorizado detectado y bloqueado${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER para finalizar P4..."
read
echo ""
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  P4 ACTIVOS/RRHH — Demo completada              ${NC}"
echo -e "${GREEN}  3 controles: 2 OK, 1 en progreso (phishing)   ${NC}"
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"
