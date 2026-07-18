# SGSI TecnoGlobal — Proyecto académico ISO 27001:2022

Sistema de Gestión de Seguridad de la Información para **TecnoGlobal** (importadora ecuatoriana de equipos de seguridad electrónica). Dos bloques: **documental** (matriz de riesgos, inventario 50 activos, 5 políticas) y **laboratorio Docker** (8 contenedores con vulns intencionales atacados desde Kali).

---

## Arquitectura del laboratorio (`lab/docker-compose.yml`)

| Contenedor | Servicio | Puerto | Rol SGSI |
|---|---|---|---|
| sgsi-odoo | Odoo 16 | 8069 | ERP (SW-01) |
| sgsi-postgres | PostgreSQL 14 | 5432 | BD ERP + CCTV |
| sgsi-nginx-vuln | Nginx Alpine | 80, 443 | Perímetro con vulns intencionales |
| sgsi-minio | MinIO | 9000, 9001 | NAS + backups |
| sgsi-ldap | OpenLDAP 1.5 | 389 | Identidad |
| sgsi-mariadb | MariaDB 10 | 3306 | Inventario (IF-09) |
| sgsi-mongodb | Mongo 4.4 | 27017 | Nómina (IF-10) |
| sgsi-certbot | Certbot | — | SSL/TLS (manual) |

Red `sgsi-lab` (172.28.0.0/16), ~1.65 GB RAM. SIEM lightweight por volumen `sgsi-logs`. Atacante = host Kali.

---

## Estructura del repo

```
SGSI/
├── .agents/                    Skills del agente (7 flujos SGSI)
├── TecnoGlobal.md              Contexto de la empresa
├── ISO-27001.md                Norma completa (referencia)
├── Matrizderiesgos.xlsx        Matriz de riesgos 50 activos
├── Copia de Politicas.xlsx     5 políticas SGSI
├── INFORME_EVALUACION_MATRIZ.md
├── SIMULACION_SGSI_TecnoGlobal.md   Planificación viva
└── lab/
    ├── docker-compose.yml      8 servicios
    ├── .env                    Credenciales robustas
    ├── configs/nginx-vuln/     default.conf con vulns
    ├── data/                   Init scripts SSL, print, repo, auth
    ├── scripts/attacks/        10 scripts grupoN-*.sh (Fase 1)
    ├── scripts/demo/           DEMO-MAESTRA.sh + demo-p1..p5.sh
    ├── scripts/{backup,restore,check-logs,ransomware}*.sh
    └── evidencias/             attacks/ tabletop/ informe-final.md
```

---

## Pre-requisitos (host Kali)

```bash
sudo apt update && sudo apt install -y docker.io docker-compose-plugin \
  nmap hydra sqlmap metasploit-framework tcpdump jq ldap-utils \
  mongosh postgresql-client default-mysql-client curl
```

Mínimo 4 GB RAM (recomendado 8 GB para Wazuh+Elastic, actualmente deshabilitado).

---

## Ejecución paso a paso

```bash
# 1. Clonar e inspeccionar
git clone <repo> SGSI && cd SGSI

# 2. Levantar el laboratorio
cd lab && docker compose up -d
docker compose ps                       # todos en "healthy"

# 3. (Opcional) Ejecutar los 10 ataques de la Fase 1
cd scripts/attacks && chmod +x grupo*.sh
./grupo1-nginx-vuln.sh && ./grupo2-odoo.sh && ./grupo3-postgres.sh
./grupo4-ldap.sh && ./grupo5-minio.sh && ./grupo6-mariadb.sh
./grupo7-mongodb.sh && ./grupo8-certbot.sh && ./grupo9-host-kali.sh && ./grupo10-red-docker.sh
# Evidencias en lab/evidencias/attacks/grupoN/

# 4. Demo maestra (presentación en vivo, 5 políticas)
cd ../demo && ./DEMO-MAESTRA.sh          # elegir 1-5 o A (todas, ~12 min)

# 5. Operaciones (backups, restore, logs, ransomware)
cd lab/scripts
./backup-cron.sh && ./check-logs.sh && ./simulate-ransomware.sh

# 6. Consultar entregables
less lab/evidencias/informe-final.md
```

---

## Credenciales de demo

| Servicio | Usuario | Contraseña |
|---|---|---|
| /print/ y /repo/ (nginx auth) | sysadmin | DemoSGSI2026 |
| MongoDB | nomina_admin | N0m1n@_M0ng0_S3cur3_ |
| MinIO | minio_admin | M1n10_B4ckupS_Str0ng_ |
| LDAP | admin | Ld@p_Adm1n_T3cn0_SGSI_ |

Resto en `lab/.env`.

---

## Mapeo de políticas → scripts

| Política | Script | Controles | Tiempo |
|---|---|---|---|
| P1 General | demo-p1-general.sh | A.6.7, A.5.12, A.5.3 | 2 min |
| P2 Acceso | demo-p2-acceso.sh | A.5.17, A.8.2, A.8.3, A.8.11 | 2.5 min |
| P3 Redes/Física | demo-p3-redes.sh | A.8.13, A.8.14, A.8.22, A.7.x | 3 min |
| P4 Activos/RRHH | demo-p4-activos.sh | A.8.1, A.6.2, A.6.3, A.5.15 | 2.5 min |
| P5 Técnica | demo-p5-tecnica.sh | A.8.7, A.8.15, A.8.16 | 2 min |

---

## Troubleshooting

| Problema | Solución |
|---|---|
| Contenedor `unhealthy` | `docker compose logs <svc>`; verificar healthcheck y `.env` |
| 404 en `/repo/` o `/print/` | `docker exec sgsi-nginx-vuln nginx -s reload` |
| 502 en Odoo | Esperar a que `sgsi-postgres` esté healthy; `docker compose restart odoo` |
| Puerto ocupado en host (80/443/5432…) | Cambiar bindings en `docker-compose.yml` o parar el servicio host |
| MongoDB no responde | `docker ps \| grep mongodb`; verificar `MONGO_INITDB_*` en `.env` |
| MinIO no lista backups | `docker run --rm --network host minio/mc:latest mc alias set l http://localhost:9000 minio_admin M1n10_B4ckupS_Str0ng_` |
| LDAP no arranca | Verificar `LDAP_BASE_DN=dc=tecnoglobal,dc=local` y `LDAP_ADMIN_PASSWORD` |
| Postgres no crea `postgres_cctv` | Verificar `POSTGRES_MULTIPLE_DATABASES=postgres_cctv,odoo_db` y borrar volumen `postgres-erp-data` |
| SSL vencido/error TLS | `docker compose run --rm certbot certonly --webroot -w /var/www -d localhost` |
| Scripts sin permiso | `chmod +x lab/scripts/**/*.sh` |
| RAM insuficiente | Quitar servicios no esenciales o dejar wazuh elasticsearch deshabilitado |
| Logs no aparecen (SIEM) | `docker run --rm -v sgsi-logs:/logs alpine sh -c "ls /logs && tail -f /logs/*/*.log"` |

---

## Limitaciones conocidas

- **SIEM commercial deshabilitado** por RAM; usar volumen `sgsi-logs` + `check-logs.sh`.
- **Kali-attacker** corre en el host (no en contenedor).
- **Activos FS y RH**: simulación tabletop (no técnica), evidencias en `lab/evidencias/tabletop/`.

---

## Skills del agente (opencode)

`sgsi-contexto-organizacional`, `sgsi-inventario-activos`, `sgsi-evaluacion-riesgos`, `sgsi-plan-tratamiento`, `sgsi-documentacion`, `sgsi-auditoria-cumplimiento`, `sgsi-mejora-continua`. Ver `.agents/skills/`.

---

**Contexto académico.** Credenciales y configuraciones son de laboratorio; no usar en producción.
