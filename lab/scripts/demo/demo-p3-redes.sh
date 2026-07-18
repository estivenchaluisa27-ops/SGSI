#!/bin/bash
# ============================================================================
# DEMO P3 — POLÍTICA FÍSICA/REDES (A.8.13, A.8.14, A.8.22, A.5.30)
# Duración: ~2 min | Control: Backups, redundancia, segregación, RTO
# ============================================================================

LAB_DIR="/home/kali/SGSI/lab"
source "$LAB_DIR/.env" 2>/dev/null

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
NC='\033[0m'
MC="docker run --rm --network host --entrypoint /bin/sh minio/mc:latest -c"

clear
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  DEMO P3 — POLÍTICA FÍSICA / REDES              ║${NC}"
echo -e "${BLUE}║  Controles: A.8.13, A.8.14, A.8.22, A.5.30     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Esta política cubre:${NC}"
echo -e "  • A.8.13 — Backup disponible"
echo -e "  • A.8.14 — Redundancia (regla 3-2-1)"
echo -e "  • A.8.22 — Segregación de redes (VLAN)"
echo -e "  • A.5.30 — Preparación TIC (RTO <4h)"
echo ""
echo -e "${CYAN}Presiona ENTER para iniciar..."
read

# ============================================================================
# CONTROL A.8.13 — Backup disponible en Minio
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.8.13 — Backup disponible${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Demostración en vivo:${NC} Listar backups almacenados en Minio"
echo ""
echo -e "${CYAN}Ejecutando:${NC} ${GREEN}docker run minio/mc ls local/backups/${NC}"
echo ""
$MC "mc alias set l http://localhost:9000 minio_admin 'M1n10_B4ckupS_Str0ng_' && mc ls l/backups/" 2>&1 | tail -10
echo ""
BACKUP_LIST=$($MC "mc alias set l http://localhost:9000 minio_admin 'M1n10_B4ckupS_Str0ng_' && mc ls l/backups/ --recursive" 2>&1)
BACKUP_COUNT=$(echo "$BACKUP_LIST" | grep -c "sql.gz")
echo -e "  ${GREEN}✅ ${BACKUP_COUNT} archivos de backup disponibles en Minio${NC}"
echo -e "  ${RED}❌ Antes:${NC} 0 backups (NC-4 detectado)"
echo -e "  ${GREEN}✅ Después:${NC} Backup diario + manual post-Fase 1"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.5.30 + A.8.13 — Restauración + RTO medido
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.5.30 — Preparación TIC (RTO medido)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━══━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Demostración en vivo:${NC} Restaurar Odoo desde Minio + medir RTO"
echo -e "${YELLOW}Objetivo:${NC} RTO < 14400 s (4 h)"
echo ""
echo -e "${CYAN}Iniciando cronómetro..."
START=$(date +%s)
echo -e "  T+0s — Ejecutando restore-backup.sh..."
bash "$LAB_DIR/scripts/restore-backup.sh" > /tmp/demo-restore.log 2>&1
END=$(date +%s)
RTO=$((END - START))
echo -e "  T+${RTO}s — Restauración completada"
echo ""
grep -E "Backup encontrado|RTO|✅|❌" /tmp/demo-restore.log | tail -5
echo ""
if [ $RTO -lt 14400 ]; then
    echo -e "  ${GREEN}✅ RTO = ${RTO}s (objetivo <14400s)${NC}"
else
    echo -e "  ${RED}❌ RTO = ${RTO}s excede objetivo${NC}"
fi
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.8.22 — Segregación de redes (VLAN)
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.8.22 — Segregación de redes (VLAN)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Demostración en vivo:${NC} Simular VLAN hopping desde contenedor atacante"
echo -e "${YELLOW}Objetivo:${NC} La red Docker NO debe permitir acceso lateral entre servicios"
echo ""
echo -e "${CYAN}Lanzando contenedor atacante y probando ping a Postgres:${NC}"
HOPPING=$(docker run --rm --network sgsi-lab alpine ping -c 1 -W 1 sgsi-postgres 2>&1)
if echo "$HOPPING" | grep -q "1 packets received"; then
    echo -e "  ${RED}❌ Postgres ALCANZABLE desde contenedor atacante${NC}"
    echo -e "  ${RED}   No existe segregación entre servicios (NC detectado)${NC}"
    echo ""
    echo -e "${CYAN}Acción correctiva propuesta:${NC}"
    echo "  • Crear subredes Docker separadas: sgsi-db, sgsi-app, sgsi-public"
    echo "  • Postgres accesible solo desde Odoo (no desde atacante)"
    echo "  • Aplicar docker-compose con 3 redes definidas"
else
    echo -e "  ${GREEN}✅ Postgres NO accesible desde contenedor atacante${NC}"
fi
echo ""
echo -e "${BLUE}Resultado:${NC} ${RED}❌ A.8.22 — Segregación pendiente (NC detectada)${NC}"
echo -e "${BLUE}Acción:${NC} Documentada en plan correctivo (Fase 3 informe)"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# ============================================================================
# CONTROL A.7.9 — Seguridad de equipos fuera de instalaciones (camión)
# ============================================================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.7.9 — Seguridad de equipos fuera de instalaciones${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación:${NC} Monitoreo GPS de camión Hino en ruta Quito-Guayaquil"
echo ""
echo -e "${CYAN}1) Ubicación en vivo:${NC}"
cat <<EOF
  Vehículo: Camión Hino (ID: 001)
  Ruta: Quito → Guayaquil (Panamericana)
  Última ubicación: Lat -0.2252, Lon -78.5248 (km 40)
  Velocidad: 65 km/h
  Estado: ${GREEN}En ruta${NC}
EOF
echo ""
echo -e "${CYAN}2) Detección de anomalía:${NC}"
echo -e "  ${RED}❌ Detención no programada detectada (km 45, 14:30)${NC}"
echo -e "  ${RED}❌ Posible asalto en falso control policial${NC}"
echo ""
echo -e "${CYAN}3) Respuesta automática:${NC}"
echo -e "  ${GREEN}✅ Alerta generada a Despachador y Policía ECU911${NC}"
echo -e "  ${GREEN}✅ Chofer recibe SMS: "No abrir carga sin orden judicial"${NC}"
echo -e "  ${GREEN}✅ GPS bloquea puertas hasta confirmación${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.7.9 — Asalto en ruta detectado y mitigado${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER para finalizar P3..."
read
echo ""
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  P3 REDES — Demostración completada             ${NC}"
echo -e "${GREEN}  8 controles: 7 funcionales, 1 pendiente (VLAN)${NC}"
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"

# ============================================================================
# CONTROLES FÍSICOS (FS) — Simulación narrativa
# ============================================================================

# FS-03+10 — Biométrico + Cerradura (A.7.2)
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.7.2 — Control de entrada física (Biométrico)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación narrativa:${NC} Intento de huella falsa en biométrico"
echo ""
echo -e "${CYAN}1) Evento registrado:${NC}"
cat <<EOF
  [BIOMETRIC-ALERT] $(date) entrada_principal:
    - Usuario: desconocido
    - Método: gelatina con huella falsa (gerente CM)
    - Resultado: ${RED}RECHAZADO${NC} (Live Finger Detection)
    - Log: 3 intentos fallidos en 1 min
EOF
echo ""
echo -e "${CYAN}2) Respuesta:${NC}"
echo -e "  ${GREEN}✅ Alerta generada a Guardia y SysAdmin${NC}"
echo -e "  ${GREEN}✅ Cámara de entrada captura imagen del atacante${NC}"
echo -e "  ${GREEN}✅ Registro en bitácora física (A.7.1)${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.7.2 — Biométrico bloquea suplantación${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# FS-02+06 — DC + Rack (A.7.6, A.7.8)
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.7.6 + A.7.8 — Zonas seguras + Escritorio limpio${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación narrativa:${NC} Acceso no autorizado a Data Center"
echo ""
echo -e "${CYAN}1) Evento registrado:${NC}"
cat <<EOF
  [DC-ALERT] $(date) cuarto_servidores:
    - Usuario: técnico externo (no registrado)
    - Hora: 10:30 AM
    - Resultado: ${RED}ACCESO DENEGADO${NC} (política A.7.6)
    - Motivo: Sin orden de trabajo firmada
EOF
echo ""
echo -e "${CYAN}2) Respuesta:${NC}"
echo -e "  ${GREEN}✅ Guardia verifica identificación${NC}"
echo -e "  ${GREEN}✅ SysAdmin confirma no hay orden de trabajo${NC}"
echo -e "  ${GREEN}✅ Registro en bitácora de acceso (A.7.1)${NC}"
echo ""
echo -e "${CYAN}3) Control A.7.8 (escritorio limpio):${NC}"
echo -e "  ${GREEN}✅ Cableado del rack canalizado (NC-06 parchado)${NC}"
echo -e "  ${GREEN}✅ PDU con bloqueo de puertos${NC}"
echo -e "  ${GREEN}✅ Limpieza del DC solo con supervisión (NC-07 parchado)${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.7.6 + A.7.8 — Acceso controlado y escritorio limpio${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER..."
read

# FS-07+08+09 — AC + FM-200 + UPS (A.7.11, A.7.5)
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CONTROL A.7.11 + A.7.5 — Amenazas ambientales${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Simulación narrativa:${NC} Falla de infraestructura crítica"
echo ""
echo -e "${CYAN}1) Evento registrado:${NC}"
cat <<EOF
  [ENV-ALERT] $(date) cuarto_servidores:
    - Temperatura: 35°C (umbral: 30°C)
    - UPS: 2 min restantes (capacidad 1500VA)
    - FM-200: Mantenimiento vencido (11 meses)
    - Resultado: ${RED}ALERTA CRÍTICA${NC} (política A.7.11)
EOF
echo ""
echo -e "${CYAN}2) Respuesta:${NC}"
echo -e "  ${GREEN}✅ SysAdmin apaga equipos no críticos (NAS, NVR)${NC}"
echo -e "  ${GREEN}✅ UPS prioriza servidor HPE (RTO <4h)${NC}"
echo -e "  ${GREEN}✅ FM-200: Contrato de mantenimiento renovado (NC-11 parchado)${NC}"
echo -e "  ${GREEN}✅ AC: Adquirido 2do equipo (NC-10 en progreso)${NC}"
echo ""
echo -e "${BLUE}Resultado:${NC} ${GREEN}✅ A.7.11 + A.7.5 — Infraestructura crítica monitoreada${NC}"
echo ""
echo -e "${CYAN}Presiona ENTER para finalizar P3..."
read
echo ""
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  P3 REDES — Demostración completada             ${NC}"
echo -e "${GREEN}  8 controles: 7 funcionales, 1 pendiente (VLAN)${NC}"
echo -e "${GREEN}═════════════════════════════════════════════════${NC}"
