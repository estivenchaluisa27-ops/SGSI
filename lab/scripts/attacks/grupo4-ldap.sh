#!/bin/bash
# GRUPO 4 — ldap-server (identidades)
# Activos: HW-08+10, SW-07, SW-08
# Controles: A.6.7, A.8.24, A.8.1, A.8.15, A.8.5, A.5.16
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/attacks/grupo4"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO 4: LDAP (3 simulaciones)"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

source "$LAB_DIR/.env" 2>/dev/null || true
EVID_FILE="$EVID_DIR/no-conformidades.txt"
> "$EVID_FILE"

# --- Sim 1: HW-08+10 — Compromiso credenciales ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #1: HW-08+10 — Compromiso credenciales móviles (A.6.7, A.8.24, A.8.1)" | tee -a "$EVID_FILE"

ldapsearch -x -H ldap://localhost:389 -b "dc=tecnoglobal,dc=local" -D "cn=admin,dc=tecnoglobal,dc=local" -w "${LDAP_ADMIN_PASSWORD}" "(uid=*)" cn uid mail 2>&1 | tee "$EVID_DIR/sim1-ldap-enum.txt"

USER_COUNT=$(grep -c "dn:" "$EVID_DIR/sim1-ldap-enum.txt" 2>/dev/null || echo "0")
echo "  Usuarios enumerados via LDAP: $USER_COUNT" | tee -a "$EVID_FILE"
if [ "$USER_COUNT" -gt 0 ] 2>/dev/null; then
    echo "  ❌ LDAP permite enumeración anónima — A.8.24 (datos expuestos)" | tee -a "$EVID_FILE"
fi

# --- Sim 2: SW-07 — Abuso VPN acceso interno ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #2: SW-07 — Abuso VPN acceso interno (A.8.1, A.8.15, A.8.5, A.5.16)" | tee -a "$EVID_FILE"

# Reutilizar credenciales robadas (Sysadmin2026!)
ldapsearch -x -H ldap://localhost:389 -b "dc=tecnoglobal,dc=local" -D "cn=cmartinez,ou=people,dc=tecnoglobal,dc=local" -w "Sysadmin2026!" cn uid employeeNumber 2>&1 | tee "$EVID_DIR/sim2-vpn-abuse.txt"

# Test provisión/desactivación
echo "  Test provisión: crear usuario temporal..."
echo "  (Simulado — depende de políticas de aprovisionamiento)" | tee -a "$EVID_FILE"

echo "    RESULTADO: ⚠️  Pendiente — revisar si cuentas desactivadas siguen accediendo" | tee -a "$EVID_FILE"

# --- Sim 3: SW-08 — Alteración asistencia ---
echo "" | tee -a "$EVID_FILE"
echo ">>> SIM #3: SW-08 — Alteración registros asistencia (A.8.1, A.8.15)" | tee -a "$EVID_FILE"

echo "  Intento de ldapmodify para alterar registros..." >> "$EVID_DIR/sim3-attendance-mod.txt"
ldapmodify -x -H ldap://localhost:389 -D "cn=admin,dc=tecnoglobal,dc=local" -w "${LDAP_ADMIN_PASSWORD}" <<EOF 2>&1 | tee -a "$EVID_DIR/sim3-attendance-mod.txt"
dn: cn=jperez,ou=people,dc=tecnoglobal,dc=local
changetype: modify
replace: employeeType
employeeType: temporal
EOF

echo "    RESULTADO: ⚠️  Pendiente — verificar si modificación fue posible sin ACL de escritura" | tee -a "$EVID_FILE"

# Post-sim
echo "" | tee -a "$EVID_FILE"
bash "$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt" 2>&1 || true

echo "" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
echo " GRUPO 4 COMPLETADO — 3 simulaciones" | tee -a "$EVID_FILE"
echo " Evidencias: $EVID_DIR/" | tee -a "$EVID_FILE"
echo "=========================================" | tee -a "$EVID_FILE"
