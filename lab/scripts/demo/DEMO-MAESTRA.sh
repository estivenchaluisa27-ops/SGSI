#!/bin/bash
# ============================================================================
# DEMO MAESTRA — SGSI TecnoGlobal (5 políticas en 10 min)
# ============================================================================

GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SGSI — DEMO MAESTRA (5 políticas)              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Seleccione la política a demostrar:${NC}"
echo "  1) P1 — General (robo equipo, clasificación, segregación)"
echo "  2) P2 — Acceso (ACLs, contraseñas, auth)"
echo "  3) P3 — Redes/Física (backup Minio, VLAN, RTO)"
echo "  4) P4 — Activos/RRHH (inventario, exfiltración, phishing)"
echo "  5) P5 — Técnica (logging, SSL, malware)"
echo "  A) Todas (~12 min)"
echo "  Q) Salir"
echo ""
read -r choice
case "$choice" in
    1) bash /home/kali/SGSI/lab/scripts/demo/demo-p1-general.sh ;;
    2) bash /home/kali/SGSI/lab/scripts/demo/demo-p2-acceso.sh ;;
    3) bash /home/kali/SGSI/lab/scripts/demo/demo-p3-redes.sh ;;
    4) bash /home/kali/SGSI/lab/scripts/demo/demo-p4-activos.sh ;;
    5) bash /home/kali/SGSI/lab/scripts/demo/demo-p5-tecnica.sh ;;
    a|A)
        bash /home/kali/SGSI/lab/scripts/demo/demo-p1-general.sh
        echo -e "${YELLOW}>>> Siguiente: P2 Access ${NC}"
        read
        bash /home/kali/SGSI/lab/scripts/demo/demo-p2-acceso.sh
        echo -e "${YELLOW}>>> Siguiente: P3 Redes ${NC}"
        read
        bash /home/kali/SGSI/lab/scripts/demo/demo-p3-redes.sh
        echo -e "${YELLOW}>>> Siguiente: P4 Activos ${NC}"
        read
        bash /home/kali/SGSI/lab/scripts/demo/demo-p4-activos.sh
        echo -e "${YELLOW}>>> Siguiente: P5 Técnica ${NC}"
        read
        bash /home/kali/SGSI/lab/scripts/demo/demo-p5-tecnica.sh
        ;;
    q|Q) echo "Chao." ;;
    *) echo "Opción no válida" ;;
esac