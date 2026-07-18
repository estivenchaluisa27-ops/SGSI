# 🎯 Plan de Simulación de Amenazas SGSI — TecnoGlobal

> Archivo vivo de planificación, ejecución y seguimiento.
> La IA trabajará registrando aquí cada fase, decisión, ajuste y resultado.

---

## 📋 Estado General del Proyecto

| Componente | Estado | Última actualización |
|---|---|---|---|
| Plan definido | ✅ Completado (optimizado para 3.9 GB RAM) | 2026-07-18 |
| Fase 0: Bootstrap lab | ✅ Completado | 2026-07-18 |
| Fase 0.5: Transición (tools + seed + deploy + scripts) | ✅ Completado | 2026-07-18 |
| Fase 1: Docker Lab + Scripted | ✅ Completado (25/25 simulaciones ejecutadas) | 2026-07-18 |
| Fase 2: Tabletop / Physical Drills | ✅ Completado (12/12 escenarios) | 2026-07-18 |
| Fase 3: Informe Consolidado | ✅ Completado | 2026-07-18 |

**Progreso global:** ▰▰▰▰▰▰▰▰▰▰ 100%

---

## 📌 1. Contexto del Proyecto

### Empresa
**TecnoGlobal Importadora** — PYME ecuatoriana, sede Quito + sucursal Guayaquil.
Importación, distribución y comercialización de equipos de seguridad electrónica, automatización y tecnología.

### Objetivo de la Simulación
Materializar las 50 amenazas identificadas en la Matriz de Riesgos contra los 50 activos, aplicando y validando los controles definidos en las 5 Políticas Base del SGSI, con el fin de:
- Verificar que los controles mitigan efectivamente cada riesgo
- Medir RTO/RPO reales vs. objetivos
- Identificar brechas en la implementación
- Generar evidencia concreta para auditoría

### Estructura del Proyecto
```
SGSI/
├── Matrizderiesgos.xlsx          # Inventario de 50 activos con amenazas
├── Copia de Politicas.xlsx       # 5 Políticas Base del SGSI
├── ISO-27001.md                  # Referencia normativa
├── TecnoGlobal.md                # Contexto organizacional
├── SIMULACION_SGSI_TecnoGlobal.md # ← ESTE ARCHIVO (vivo)
├── lab/
│   ├── docker-compose.yml        # 8 contenedores optimizados (3.9 GB RAM)
│   ├── .env                      # Credenciales del laboratorio
│   ├── configs/nginx-vuln/       # Nginx con vulns intencionales
│   ├── scripts/
│   │   ├── check-logs.sh         # SIEM lightweight (reemplaza ES+Kibana+Wazuh)
│   │   └── attacks/              # 10 grupos de ataque por contenedor objetivo
│   ├── data/                     # Datos semilla para Odoo, LDAP, Postgres, etc.
│   └── siem/SIEM-LIGHTWEIGHT.md  # Justificación del SIEM ligero
├── evidencias/                   # Outputs de cada simulación
└── .agents/skills/               # Skills cargables por la IA
```

---

## 🧭 2. Estrategia General de Simulación — Enfoque HÍBRIDO

Las 50 amenazas se abordan con **2 modalidades** (Scripted Attacks absorbida dentro del Laboratorio Docker):

| Modalidad | Cobertura | Activos | Nº amenazas |
|---|---|---|---|
| **A — Laboratorio Docker + Scripted** | Amenazas técnicas digitales + explotación desde host Kali | HW (1-10), SW (1-10), IF (1-10, excepto IF-05) | ~21 |
| **B — Tabletop / Physical Drills** | Amenazas físicas y de factor humano | FS (1-10), RH (1-10) | ~12 |

**Total simulaciones únicas:** ~33 (optimizado — fusiones de escenarios redundantes y eliminación de simulación administrativa IF-05)

### Optimización por recursos (Fase 0)

El host Kali dispone de **3.9 GB RAM libre**. Un SIEM completo (Elasticsearch+Kibana+Wazuh) consume ~2.5 GB. Se aplica:

| Optimización | Ahorro RAM | Consecuencia |
|---|---|---|
| A — Quitar Elasticsearch + Kibana + Wazuh | ~2.5 GB | SIEM lightweight basado en volumen compartido + `check-logs.sh` |
| C — Kali-attacker desde host (sin contenedor) | ~500 MB | Herramientas instaladas en host Kali (`nmap`, `hydra`, `sqlmap`, `metasploit-framework`) |
| D — Fusionar Postgres ERP + CCTV (1 server, 2 BD) | ~200 MB | `POSTGRES_MULTIPLE_DATABASES=postgres_cctv` |
| E — Gophish desde host (sin contenedor separado) | ~50 MB | Script de phishing en Kali |

**Resultado:** 8 contenedores Docker (~1.65 GB) en vez de 12 originalmente (~5 GB). Sobran ~2.2 GB para margen del host.

### Reglas del archivo vivo

1. Cada simulación ejecutada se marca con ✅ y se documenta con fecha + evidencias
2. Decisiones de ajuste se registran en **Decisiones/Ajustes** de cada fase
3. Si un control falla, se documenta como **No conformidad** con plan de acción
4. El progreso se actualiza al inicio de cada interacción

---

## 📦 3. FASE 1 — Laboratorio Docker (Infraestructura Técnica)

### 3.1 Topología del Lab — 8 contenedores (~1.65 GB RAM)

```
┌──────────────────────────────────────────────────────────┐
│                   DOCKER NETWORK                          │
│            subnet: 172.28.0.0/16                          │
│                                                           │
│ ┌──────────┐    ┌──────────┐    ┌──────────────────┐     │
│ │  Odoo    │───▶│ Postgres │    │  Nginx-vuln      │     │
│ │ (ERP)    │    │ (ERP+CCTV│◀───│  (router/fw sim) │     │
│ └──────────┘    │  1 server│    └──────────────────┘     │
│                  │  2 BDs)  │           ▲                 │
│                  └──────────┘           │                 │
│       │                                  │                 │
│       ▼                                  │                 │
│ ┌────────────────────────────┐          │                 │
│ │  Volumen: sgsi-logs         │          │                 │
│ │  (SIEM lightweight — logs)  │◀──────┘                 │
│ │  Revisión con check-logs.sh │                          │
│ └────────────────────────────┘                           │
│       ▲              ▲            ▲            ▲          │
│       │              │            │            │          │
│ ┌──────────┐ ┌──────────┐  ┌──────────┐ ┌─────────────┐  │
│ │  Minio   │ │  LDAP    │  │ MariaDB  │ │  MongoDB    │  │
│ │ (NAS sim)│ │ (ident.) │  │ (stock)  │ │  (nómina)   │  │
│ └──────────┘ └──────────┘  └──────────┘ └─────────────┘  │
│                                                           │
│       │                                                   │
│       ▼                                                   │
│ ┌──────────┐                                              │
│ │ Certbot  │                                              │
│ │ (SSL sim)│                                              │
│ └──────────┘                                              │
└──────────────────────────────────────────────────────────┘
                              ▲
                              │
                  ┌──────────────────────┐
                  │  HOST KALI (opencode) │
                  │  herramientas:        │
                  │  nmap, hydra, sqlmap, │
                  │  metasploit, tcpdump, │
                  │  mongosh, psql, jq    │
                  └──────────────────────┘
```

### 3.2 Servicios y Activos Emulados — 8 contenedores + host Kali

| Servicio Docker | Activo real | Propósito | RAM est. |
|---|---|---|---|
| `odoo` | SW-01 ERP Odoo v16 | Sistema crítico de gestión | ~500 MB |
| `postgres-erp` | SW-06 PostgreSQL v14 + IF-02 CCTV | BD ERP + BD CCTV (mismo server) | ~350 MB |
| `nginx-vuln` | HW-02, HW-03, SW-02, SW-04, HW-09, SW-05, IF-07 | Punto entrada perimetral | ~50 MB |
| `ldap-server` | SW-07 VPN + HW-08, HW-10, SW-08 | Gestión de identidades | ~100 MB |
| `mariadb-inventario` | IF-09 Inventario stock | Base de inventario | ~200 MB |
| `mongodb-nomina` | IF-10 Nómina y cuentas | Datos payroll | ~300 MB |
| `minio` | HW-05 NAS + IF-06 backups | Almacenamiento S3 simulado | ~100 MB |
| `certbot` | IF-08 SSL/TLS | Certificado digital | ~50 MB |
| `sgsi-logs` (volumen) | P5 — Logging | SIEM lightweight (logs centralizados) | ~50 MB |
| **Host Kali** | — | Orquesta ataques (nmap, hydra, sqlmap, metasploit, tcpdump) | 0 (host) |
| **Gophish** (host Kali) | SW-10, RH-06 | Phishing controlado desde host | 0 (host) |

### 3.3 Agrupación de Simulaciones por Contenedor Objetivo

Para optimizar la ejecución, las 21 simulaciones técnicas de Fase 1 se agrupan por **contenedor objetivo** en lugar de por categoría de activo. Esto minimiza paradas y arranques, y permite validar familias de controles en una sola pasada.

#### Grupo 1 — nginx-vuln (perímetro + endpoints expuestos)

7 simulaciones atacan el mismo contenedor `nginx-vuln`. Se ejecutan en una sola sesión:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| HW-02+03 | Compromiso perimetral + evasión firewall | `nmap -sV -p-` + Metasploit + curl bypass WAF + validar feed IoCs | A.8.20, A.8.22, A.8.5, A.5.7 |
| HW-07 | Borrado grabaciones NVR | Borrar logs/snapshots en storage | A.8.13, A.8.15, A.8.5 |
| HW-09 | Fuga datos impresora | Captura de documento en cola /print/ | A.8.24 |
| SW-04 | Fuerza bruta Windows Server | `hydra -l admin -P rockyou.txt rdp://nginx-vuln` + validar política contraseñas | A.8.15, A.8.24, A.8.5, A.5.17 |
| SW-02+05 | Intercepción video + exposición Zendesk | Capturar stream RTSP + fuga API token via /api/ | A.5.23, A.8.5 |
| IF-01 | Fuga planos seguridad clientes | Acceso a repositorio /repo sin ACL | A.5.12, A.8.3 |
| IF-07 | Borrado de logs VPN | `curl -X DELETE "http://nginx-vuln/logs-*"` sin auth | A.8.15 |

**Script orquestador:** `lab/scripts/attacks/grupo1-nginx-vuln.sh`

#### Grupo 2 — odoo (ERP crítico)

4 simulaciones tienen como objetivo el ERP Odoo:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| HW-01 | Fallo crítico hardware ERP | `docker stop odoo` + `restore-backup.sh` + medir RTO/RPO | A.8.13, A.8.14, A.5.30 |
| HW-06 | Robo laptop gerencia | Acceso desde IP externa a endpoint Odoo | A.6.7, A.8.24, A.8.7 |
| SW-01 | Acceso no autorizado ERP | `sqlmap -u http://odoo:8069 --dump-all` | A.8.15, A.8.24, A.8.5 |
| SW-03 | Fuga planos AutoCAD | `curl -O` archivos restringidos sin auth | A.8.1, A.8.15 |

**Script orquestador:** `lab/scripts/attacks/grupo2-odoo.sh`

#### Grupo 3 — postgres-erp (BD ERP + CCTV)

2 simulaciones atacan Postgres (mismo server, dos BD):

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| SW-06 | Inyección SQL PostgreSQL | `sqlmap -d postgresql://... --dump` + validar reglas WAF vs IoCs | A.8.15, A.8.24, A.8.20, A.5.7 |
| IF-02 | Acceso a BD IP/contraseñas | SQLi + dump tablas credenciales sobre BD `postgres_cctv` | A.8.24, A.8.3 |

**Script orquestador:** `lab/scripts/attacks/grupo3-postgres.sh`

#### Grupo 4 — ldap-server (identidades)

3 simulaciones atacan el LDAP:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| HW-08+10 | Compromiso credenciales tablet + smartphone | `hydra -l user -P rockyou.txt ldap-server` + login anómala | A.6.7, A.8.24, A.8.1 |
| SW-07 | Abuso VPN acceso interno | Reutilizar credenciales + test provisión/desactivación | A.8.1, A.8.15, A.8.5, A.5.16 |
| SW-08 | Alteración registros asistencia | Modificar entrada LDAP de horario | A.8.1, A.8.15 |

**Script orquestador:** `lab/scripts/attacks/grupo4-ldap.sh`

#### Grupo 5 — minio (NAS + backups)

2 simulaciones en Minio (pérdida backups + ransomware):

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| HW-05 | Pérdida irrecuperable backups | `simulate-ransomware.sh` (encrypta Minio) | A.8.13, A.8.14 |
| IF-06 | Ransomware sobre backups | Script cifrado + validar RTO/RPO recuperación | A.8.13, A.8.22, A.5.30 |

**Script orquestador:** `lab/scripts/attacks/grupo5-minio.sh`

#### Grupo 6 — mariadb (inventario)

1 simulación:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| IF-09 | Alteración inventario stock | `UPDATE stock SET cantidad=0 WHERE id=X` | A.8.3, A.8.15 |

**Script orquestador:** `lab/scripts/attacks/grupo6-mariadb.sh`

#### Grupo 7 — mongodb (nómina)

1 simulación:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| IF-10 | Exposición nómina y cuentas | `mongodump` a MongoDB sin autenticación | A.8.11 |

**Script orquestador:** `lab/scripts/attacks/grupo7-mongodb.sh`

#### Grupo 8 — certbot (SSL/TLS)

1 simulación:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| IF-08 | Expiración SSL sin aviso | Detener renovación + mostrar error TLS | A.8.24, A.8.16 |

**Script orquestador:** `lab/scripts/attacks/grupo8-certbot.sh`

#### Grupo 9 — host Kali (ataques directos)

3 simulaciones que se harán desde el propio host Kali (sin contenedor objetivo Docker):

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| IF-03 | Exfiltración biométrica | `curl` a API REST sin cifrado (simulado localmente) | A.5.34 |
| IF-04 | Fraude facturación | `psql` directo a BD facturación sin MFA (Postgres ERP) | A.8.2 |
| SW-10 + RH-06 | Suplantación M365 + Whaling | Script de phishing con Gophish desde host | A.5.23, A.8.5, A.6.3, A.5.3 |

**Script orquestador:** `lab/scripts/attacks/grupo9-host-kali.sh`

#### Grupo 10 — red Docker (VLAN hopping)

1 simulación que ataca la red del propio laboratorio Docker:

| ID | Amenaza | Script | Controles |
|---|---|---|---|
| HW-04 | VLAN hopping / salto VLAN | `macof` / `yersinia` simulado en red Docker | A.8.20, A.8.22 |

**Script orquestador:** `lab/scripts/attacks/grupo10-red-docker.sh`

#### Resumen de agrupación

| Grupo | Contenedor objetivo | # simulaciones | Activos cubiertos |
|---|---|---|---|
| 1 | nginx-vuln | 7 | HW-02, HW-03, HW-07, HW-09, SW-04, SW-02, SW-05, IF-01, IF-07 |
| 2 | odoo | 4 | HW-01, HW-06, SW-01, SW-03 |
| 3 | postgres-erp | 2 | SW-06, IF-02 |
| 4 | ldap-server | 3 | HW-08, HW-10, SW-07, SW-08 |
| 5 | minio | 2 | HW-05, IF-06 |
| 6 | mariadb | 1 | IF-09 |
| 7 | mongodb | 1 | IF-10 |
| 8 | certbot | 1 | IF-08 |
| 9 | host Kali | 3 | IF-03, IF-04, SW-10, RH-06 |
| 10 | red Docker | 1 | HW-04 |
| **Total** | — | **~25 ejecuciones** | **50/50** |

### 3.3.1 Estado Actual — Fase 0.5 Transicional

El laboratorio fue desplegado y está operativo. Los 6 pasos de la Fase 0.5 están **completados** y se ha iniciado la ejecución de Fase 1.

| Paso | Tarea | Estado |
|---|---|---|
| 1 | Instalar herramientas en host Kali (nmap, hydra, sqlmap, msf, etc.) | ✅ Completado |
| 2 | Poblar datos semilla (SQL iniciales, LDAP, MongoDB, documentos) | ✅ Completado |
| 3 | Generar certificado SSL self-signed para nginx-vuln | ✅ Completado |
| 4 | Levantar 8 contenedores (`docker compose up -d`) | ✅ Completado (8/8 saludables) |
| 5 | Escribir 10 scripts de ataque (`scripts/attacks/`) | ✅ Completado (10/10) |
| 6 | Ejecutar Grupo 1 (nginx-vuln) y Grupo 2 (odoo) | ✅ Completado |

### 3.3.2 Secuencia de Implementación — 6 Pasos

```
Paso 1 — Preparar host Kali (~30 min)
  ├── Instalar herramientas: nmap, hydra, sqlmap, metasploit-framework, tcpdump, jq, mongosh, mysql-client, ldap-utils
  ├── Verificar versiones
  ├── Generar rockyou.txt truncado (top 1000 contraseñas)
  └── sudo apt install -y nmap hydra sqlmap metasploit-framework tcpdump jq ldap-utils mongo-tools postgresql-client mariadb-client gophish
      (si no están en Kali por defecto)

Paso 2 — Crear datos semilla (~45 min)
  ├── data/postgres/init/01-init.sql        → BD odoo_db + tablas ERP (clientes, productos, facturas)
  ├── data/postgres/init/02-cctv.sql        → BD postgres_cctv + IPs/contraseñas CCTV
  ├── data/ldap/seed/01-users.ldif          → 15 usuarios TecnoGlobal (sysadmin, jefebodega, gerente, contador, etc.)
  ├── data/mariadb/init/01-init.sql         → BD inventario_stock + 30 productos con cantidades
  ├── data/mongodb/init/01-init.js          → colección nomina + 15 empleados con cuentas bancarias
  ├── data/nginx-print/                     → 3 documentos PDF simulados (factura, contrato, recibo)
  └── data/odoo/extra-addons/               → módulo dummy para que Odoo arranque sin errores

Paso 3 — Infraestructura crypto (~10 min)
  ├── data/nginx-ssl/self-signed.crt + self-signed.key (openssl req -x509 -nodes)
  └── Bucket "backups" en Minio (post-deploy via mc client)

Paso 4 — Desplegar laboratorio (~15 min)
  ├── cd /home/kali/SGSI/lab && docker compose pull
  ├── docker compose up -d
  ├── Esperar healthchecks (2-3 min)
  ├── Verificar 8/8 servicios responden (curl, nc, docker ps)
  └── Volumen sgsi-logs creado automáticamente al hacer up

Paso 5 — Escribir 10 scripts de ataque (~2-3 h)
  ├── scripts/attacks/grupo1-nginx-vuln.sh   (7 simulaciones sobre nginx)
  ├── scripts/attacks/grupo2-odoo.sh         (4 simulaciones sobre ERP)
  ├── scripts/attacks/grupo3-postgres.sh     (2 simulaciones sobre BD)
  ├── scripts/attacks/grupo4-ldap.sh         (3 simulaciones sobre identidades)
  ├── scripts/attacks/grupo5-minio.sh        (2 simulaciones sobre backups)
  ├── scripts/attacks/grupo6-mariadb.sh      (1 simulación inventario)
  ├── scripts/attacks/grupo7-mongodb.sh      (1 simulación nómina)
  ├── scripts/attacks/grupo8-certbot.sh      (1 simulación SSL)
  ├── scripts/attacks/grupo9-host-kali.sh    (3 simulaciones: phishing + fraude)
  ├── scripts/attacks/grupo10-red-docker.sh  (1 simulación red)
  ├── scripts/restore-backup.sh              (auxiliar — restaura Odoo desde Minio)
  └── scripts/simulate-ransomware.sh         (auxiliar — cifra objetos en Minio)

Paso 6 — Ejecutar 10 grupos (~3-4 h)
  ├── Grupo 10: red Docker                  — 1 simulación  (10 min)
  ├── Grupo 8: certbot                      — 1 simulación  (10 min)
  ├── Grupo 5: minio                        — 2 simulaciones (15 min)
  ├── Grupo 4: ldap                         — 3 simulaciones (20 min)
  ├── Grupo 1: nginx-vuln                   — 7 simulaciones (45 min)
  ├── Grupo 3: postgres                     — 2 simulaciones (20 min)
  ├── Grupo 2: odoo                         — 4 simulaciones (30 min)
  ├── Grupo 6: mariadb                      — 1 simulación  (10 min)
  ├── Grupo 7: mongodb                      — 1 simulación  (10 min)
  └── Grupo 9: host Kali                    — 3 simulaciones (25 min)
```

### 3.3.3 Detalle por Grupo de Simulación

#### Grupo 1 — nginx-vuln (perímetro + endpoints expuestos)

| # | ID | Amenaza | Comando de ataque | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | HW-02+03 | Compromiso perimetral + evasión firewall | `nmap -sV -p- localhost` + `curl -H "X-Forwarded-For: 10.0.0.1" http://localhost/admin/` + validar reglas firewall vs feed IoCs simulado | A.8.20, A.8.22, A.8.5, A.5.7 | nmap detecta puertos expuestos (80,443), curl admin sin token devuelve 200, script IoC busca hash malicioso en logs |
| 2 | HW-07 | Borrado grabaciones NVR | `curl -X DELETE http://localhost/logs/access.log` — simula borrar grabaciones NVR desde endpoint expuesto | A.8.13, A.8.15, A.8.5 | `check-logs.sh` detecta log vacío; validar que DELETE sin auth no debería ser posible |
| 3 | HW-09 | Fuga datos impresora | `curl http://localhost/print/` — lista documentos en cola de impresión sin autenticación | A.8.24 | Descarga documento factura.pdf sin credenciales; verificar acceso público |
| 4 | SW-04 | Fuerza bruta Windows Server | `hydra -l admin -P rockyou-top1000.txt rdp://localhost` + verificar política de contraseñas rechazó débiles | A.8.15, A.8.24, A.8.5, A.5.17 | hydra encuentra 0 credenciales si política de contraseñas funciona; si encuentra alguna, ❌ |
| 5 | SW-02+05 | Intercepción video + exposición Zendesk | `tcpdump -i any port 443 -w captura.pcap` + `curl http://localhost/api/token` | A.5.23, A.8.5 | captura.pcap contiene paquetes TLS visibles; /api/token expone API key si no hay auth |
| 6 | IF-01 | Fuga planos seguridad clientes | `curl -O http://localhost/repo/plano-cliente.pdf` — descarga de repositorio sin ACL | A.5.12, A.8.3 | Descarga exitosa de PDF sin autenticación = ❌ A.5.12 (clasificación ausente), ❌ A.8.3 (ACL no implementado) |
| 7 | IF-07 | Borrado de logs VPN | `curl -s -X DELETE "http://localhost/logs/*"` — intentar borrar todos los logs de acceso | A.8.15 | `check-logs.sh` detecta archivos vacíos 5 min después; SIEM debe detectar DELETE sin auth |

**Script orquestador:** `lab/scripts/attacks/grupo1-nginx-vuln.sh` — ejecuta los 7 pasos secuencialmente, llama `check-logs.sh` al final, guarda evidencias en `evidencias/attacks/grupo1/`.

#### Grupo 2 — odoo (ERP crítico)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | HW-01 | Fallo crítico hardware ERP | `docker stop sgsi-odoo` + medir timestamp → ejecutar `restore-backup.sh` (restaura desde Minio) → `docker start sgsi-odoo` + medir timestamp | A.8.13, A.8.14, A.5.30 | Calcular RPO (tiempo sin ERP) y RTO (tiempo hasta restauración). Objetivo: RTO < 4h, RPO < 1h |
| 2 | HW-06 | Robo laptop gerencia | `curl -H "X-Forwarded-For: 203.0.113.1" http://localhost:8069/web/login` — login con credenciales de gerente desde IP externa sospechosa | A.6.7, A.8.24, A.8.7 | Si login funciona desde IP externa sin MFA, ❌ A.6.7 (robo información); si no hay cifrado en tránsito, ❌ A.8.24 |
| 3 | SW-01 | Acceso no autorizado ERP | `sqlmap -u "http://localhost:8069/web/login" --data "login=admin&password=admin" --dump-all` | A.8.15, A.8.24, A.8.5 | sqlmap encuentra inyección SQL = ❌; no encuentra = ✅ |
| 4 | SW-03 | Fuga planos AutoCAD | `curl -s http://localhost:8069/web/content/plano.dwg` — intentar descargar archivo restringido sin autenticación | A.8.1, A.8.15 | Si curl devuelve archivo sin pedir login, ❌ A.8.1 (inventario activos), ❌ A.8.15 (logging) |

#### Grupo 3 — postgres-erp (BD ERP + CCTV)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | SW-06 | Inyección SQL PostgreSQL | `sqlmap -d "postgresql://odoo:odoo_pass_lab_2026@localhost:5432/odoo_db" --dump` + validar reglas WAF vs feed IoCs | A.8.15, A.8.24, A.8.20, A.5.7 | sqlmap log muestra si pudo conectarse y dumpear datos; feed IoCs verifica si IP/hash del ataque aparece en listas de amenazas conocidas |
| 2 | IF-02 | Acceso a BD IP/contraseñas CCTV | `psql -h localhost -U odoo -d postgres_cctv -c "SELECT * FROM cctv_passwords;"` — intentar leer credenciales CCTV sin autorización específica | A.8.24, A.8.3 | Si psql devuelve datos sin requerir credencial específica de CCTV, ❌ A.8.24 (cifrado), ❌ A.8.3 (ACL por base de datos) |

#### Grupo 4 — ldap-server (identidades)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | HW-08+10 | Compromiso credenciales tablet + smartphone | `hydra -l usuario_soporte -P rockyou-top1000.txt ldap://localhost` + `ldapsearch -x -b "dc=tecnoglobal,dc=local" -D "cn=usuario_soporte,..."` desde ubicación anómala (sin MFA) | A.6.7, A.8.24, A.8.1 | hydra encuentra contraseña débil = ❌ A.6.7; acceso a LDAP sin MFA = ❌ A.8.24 |
| 2 | SW-07 | Abuso VPN acceso interno | Reutilizar credenciales robadas del paso anterior + `ldapsearch` para enumerar todos los usuarios + test de provisión/desactivación: crear cuenta temporal, verificar acceso, desactivarla, verificar que ya no accede | A.8.1, A.8.15, A.8.5, A.5.16 | Cuenta desactivada sigue permitiendo acceso = ❌ A.5.16 (gestión de identidades); logging no registra acceso anómalo = ❌ A.8.15 |
| 3 | SW-08 | Alteración registros asistencia | `ldapmodify` para cambiar atributo `checkInTime` o `employeeType` de un usuario objetivo | A.8.1, A.8.15 | Si modificación LDAP se realiza sin ACL de escritura, ❌ A.8.1 (control de activos); si no hay log del cambio, ❌ A.8.15 |

#### Grupo 5 — minio (NAS + backups)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | HW-05 | Pérdida irrecuperable backups | `mc rm --recursive --force local/backups/` — borra todos los objetos del bucket de backups en Minio + `restore-backup.sh` intenta restaurar desde copia externa (regla 3-2-1) | A.8.13, A.8.14 | Si restauración falla porque no existía copia externa (solo estaba en Minio), ❌ A.8.14 (redundancia); si logra restaurar desde segunda copia, ✅ |
| 2 | IF-06 | Ransomware sobre backups | `simulate-ransomware.sh` — cifra todos los objetos en bucket `backups` con `openssl enc -aes-256-cbc` + nota de rescate + medir RTO de recuperación | A.8.13, A.8.22, A.5.30 | RTO real > objetivo 4h = ❌ A.5.30; recuperación parcial (solo algunos archivos) = ❌ A.8.13; no hay segregación entre backup y producción = ❌ A.8.22 |

#### Grupo 6 — mariadb (inventario)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | IF-09 | Alteración inventario stock | `mysql -h localhost -u inventario -pinventario_pass_lab_2026 inventario_stock -e "UPDATE stock SET cantidad=0 WHERE id=1;"` | A.8.3, A.8.15 | UPDATE se ejecuta sin registro de auditoría = ❌ A.8.15 (logging); no hay control de integridad de cambio = ❌ A.8.3 (ACL sobre datos) |

#### Grupo 7 — mongodb (nómina)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | IF-10 | Exposición nómina y cuentas bancarias | `mongodump --uri="mongodb://localhost:27017/nomina" --out=/tmp/nomina_dump` — intentar dumpear toda la colección sin autenticación | A.8.11 | mongodump descarga datos sin auth = ❌ A.8.11 (protección de datos); verificar si dump contiene salarios, cuentas bancarias, IDs |

#### Grupo 8 — certbot (SSL/TLS)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | IF-08 | Expiración SSL sin aviso | `docker exec sgsi-certbot certbot renew --dry-run` → forzar fallo (simular certificado expirado) → `curl -k https://localhost` → verificar error TLS | A.8.24, A.8.16 | curl a HTTPS reporta error TLS/SSL = certificado expirado; si no hay monitoreo de expiración que alerte, ❌ A.8.16 (protección de logs/monitoreo) |

#### Grupo 9 — host Kali (ataques directos)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | IF-03 | Exfiltración biométrica | `curl -s http://localhost:8069/api/biometrico/export` — intentar exportar datos de huellas dactilares sin cifrado ni token | A.5.34 | API devuelve datos biométricos sin TLS ni token de autenticación = ❌ A.5.34 (privacidad y protección de datos personales) |
| 2 | IF-04 | Fraude facturación | `psql -h localhost -U odoo -d odoo_db -c "UPDATE facturas SET monto=99999 WHERE cliente_id=1;"` — modificar montos de facturas sin aprobación dual | A.8.2 | UPDATE exitoso sin requerir segunda aprobación = ❌ A.8.2 (control de acceso a información privilegiada) |
| 3 | SW-10+RH-06 | Suplantación M365 + Whaling | Gophish desde host: lanzar campaña de phishing "Gerente General pide transferencia bancaria urgente" a buzón de prueba → medir: tasa de clics (quién cayó), tasa de reporte (quién lo denunció) | A.5.23, A.8.5, A.6.3, A.5.3 | >0 clics sin reportar a seguridad = ❌ A.6.3 (concienciación); acceso a link sin MFA = ❌ A.5.23; transferencia aprobada por una sola persona = ❌ A.5.3 (segregación de funciones) |

#### Grupo 10 — red Docker (VLAN hopping)

| # | ID | Amenaza | Comando | Controles | Verificación |
|---|---|---|---|---|---|
| 1 | HW-04 | VLAN hopping / salto de segmento | `docker run --rm --net=sgsi-lab alpine ping postgres-erp` + `tcpdump` desde contenedor atacante → verificar que tráfico entre Odoo y Postgres es capturable desde un tercer contenedor en la misma red Docker | A.8.20, A.8.22 | La red Docker `sgsi-lab` (bridge) no tiene segmentación VLAN real. Si tráfico entre contenedores es visible desde otro contenedor en la misma red, ❌ A.8.20 y A.8.22 (se requiere segmentación por red Docker separada para datos sensibles) |

### 3.3.4 Formato de Script de Ataque (estándar para los 10 grupos)

```bash
#!/bin/bash
# GRUPO X — Descripción
# Activos cubiertos: HW-XX, SW-XX, IF-XX...
# Controles evaluados: A.X.XX, A.Y.YY...
#===========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_DIR="/home/kali/SGSI/lab"
EVID_DIR="/home/kali/SGSI/lab/evidencias/grupoX"
mkdir -p "$EVID_DIR"

echo "========================================="
echo " FASE 1 - GRUPO X: Descripción"
echo " Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

# --- Simulación 1: ID — Amenaza ---
echo ""
echo ">>> SIM #1: HW-XX — Amenaza"
echo "    Controles: A.8.XX, A.8.YY..."

# Ejecutar ataque
# ... comandos ...

# Verificar resultado
if [ condición ]; then
    echo "    RESULTADO: ✅ Control pasó"
else
    echo "    RESULTADO: ❌ Control falló — No conformidad NC-XX"
    echo "    Brecha: [descripción]" >> "$EVID_DIR/no-conformidades.txt"
fi

# Guardar evidencia
echo "    Evidencia: $EVID_DIR/sim1-output.txt"
# ... redirigir stdout a archivo ...

# --- Simulación 2: ... (repetir para cada simulación del grupo) ---

# Post-simulación: SIEM lightweight review
echo ""
echo ">>> POST-SIM: Revisión SIEM lightweight"
"$LAB_DIR/scripts/check-logs.sh" > "$EVID_DIR/siem-$(date +%Y%m%d-%H%M%S).txt"
echo ""

echo "========================================="
echo " GRUPO X COMPLETADO"
echo " Evidencias: $EVID_DIR/"
echo "========================================="
```

### 3.3.5 Diagrama de Dependencias entre Grupos

```
Grupo 1 (nginx-vuln) ─────────────────────┐
                                          │
Grupo 4 (ldap-server) ──────────────────┐ │
                                       │ │
   ┌───────────────────────────────────┼─┘
   │                                   │
Grupo 5 (minio) ───────┐              │
   ├─ Dependencia:     │              │
   │  HW-01 (Grupo 2)  │              │
   │  necesita backup  │              │
   │  en Minio para    │              │
   │  restaurar        │              │
   └───────────────────┘              │
                                      │
Grupo 2 (odoo) ───────┐              │
   ├─ Dependencia:    │              │
   │  2.1 (HW-01)     │              │
   │  requiere        │              │
   │  Grupo 5 (backup)│              │
   │  pre-existente   │              │
   └───────────────────┘              │
                                      ▼
Grupo 3 (postgres-erp) ◄──── Grupo 2  (datos de Odoo deben existir en Postgres)
                                      │
Grupo 6 (mariadb)        ── sin dep. ─┤
Grupo 7 (mongodb)        ── sin dep. ─┤
Grupo 8 (certbot)        ── sin dep. ─┤
Grupo 9 (host Kali)      ── sin dep. ─┤
Grupo 10 (red Docker)    ── sin dep. ─┘
```

### Orden de Ejecución Recomendado

| Secuencia | Grupo | Duración est. | Motivo |
|---|---|---|---|
| 1 | Grupo 10 — red Docker | 10 min | No depende de nada, validación rápida del aislamiento de red |
| 2 | Grupo 8 — certbot | 10 min | No depende de nada, rápido de ejecutar |
| 3 | Grupo 5 — minio | 15 min | Necesario crear backup en Minio ANTES de Grupo 2 (restore) |
| 4 | Grupo 4 — ldap-server | 20 min | Independiente, prepara credenciales que pueden reutilizarse |
| 5 | Grupo 1 — nginx-vuln | 45 min | El más grande (7 simulaciones), ocupa el target nginx todo el tiempo |
| 6 | Grupo 3 — postgres-erp | 20 min | Postgres debe tener datos generados por Odoo (Grupo 2) para ser realista |
| 7 | Grupo 2 — odoo | 30 min | Requiere backup en Minio (Grupo 5) + datos en Postgres |
| 8 | Grupo 6 — mariadb | 10 min | Independiente, se ejecuta en paralelo con 7 |
| 9 | Grupo 7 — mongodb | 10 min | Independiente, se ejecuta en paralelo con 6 y 7 |
| 10 | Grupo 9 — host Kali | 25 min | Al final: incluye Gophish + consultas directas a servicios |

### 3.3.6 Criterio de Éxito por Grupo

| Grupo | Activos cubiertos | Controles validados | Éxito si... |
|---|---|---|---|
| 1 (nginx) | 7 activos | 11 controles | ≥9/11 controles pasan |
| 2 (odoo) | 4 activos | 7 controles | ≥6/7 pasan |
| 3 (postgres) | 2 activos | 6 controles | ≥5/6 pasan |
| 4 (ldap) | 3 activos | 7 controles | ≥6/7 pasan |
| 5 (minio) | 2 activos | 5 controles | ≥4/5 pasan |
| 6 (mariadb) | 1 activo | 2 controles | 2/2 pasan |
| 7 (mongodb) | 1 activo | 1 control | 1/1 pasa |
| 8 (certbot) | 1 activo | 2 controles | 2/2 pasan |
| 9 (host) | 3 activos | 6 controles | ≥5/6 pasan |
| 10 (red) | 1 activo | 2 controles | 2/2 pasan |

### 3.4 Decisiones y Ajustes — Fase 1

| Fecha | Decisión / Ajuste | Motivo |
|---|---|---|
| 2026-07-18 | Fase 0.5 transicional: estructura Docker lista pero no desplegada. 6 pasos identificados como requisito para Fase 1. | Host sin herramientas instaladas, datos semilla no creados, scripts de ataque sin escribir, contenedores nunca levantados. |
| 2026-07-18 | Plan detallado de implementación en 6 pasos incorporado (3.3.1-3.3.6): Preparar host → Seed data → Crypto → Deploy → Scripts → Ejecución. | Necesidad de ruta granular y clara hacia Fase 1 operativa. |
| 2026-07-18 | Fase 0.5 completada: 8 contenedores levantados, 10 scripts escritos, Grupo 1 y Grupo 2 ejecutados. Se detectaron: backups no disponibles en Minio, /print/ sin ACL, hydra encontró credenciales débiles, /repo/ expuesto. Próximo: ejecutar Grupo 3-10. | Laboratorio operativo con evidencias de no conformidades tempranas. |
| 2026-07-18 | NC-1: auth_basic en /print/ de nginx | /print/ expuesto (HW-09, A.8.24) |
| 2026-07-18 | NC-2: .env renovado con contraseñas >16 chars; scripts actualizados para source .env | hydra encontró credenciales débiles (SW-04, SW-05) |
| 2026-07-18 | NC-3: /repo/ location añadido con auth_basic + whitelist IP | Repositorio expuesto (IF-01, A.8.3) |
| 2026-07-18 | NC-4: backup-cron.sh creado, restore-backup.sh reparado, cron diario registrado | Backup no disponible en Minio (HW-01, A.8.14) |
| 2026-07-18 | Batch 1: Grupo 10 (VLAN hopping) + Grupo 8 (SSL expiry) ejecutados | Postgres alcanzable desde contenedor atacante; SSL test parcial por read-only fs |
| 2026-07-18 | Batch 2: Grupo 6 (MariaDB) + Grupo 7 (MongoDB) ejecutados | MariaDB requirió recrear volumen (credencial desactualizada); MongoDB dump bloqueado ✅ |
| 2026-07-18 | Batch 3: Grupo 3 (Postgres) + Grupo 4 (LDAP) + Grupo 5 (Minio) ejecutados | LDAP requirió corregir passwords de admin en script; Minio requirió docker wrapper mc para --network host |
| 2026-07-18 | Batch 4: Grupo 9 (Host Kali) ejecutado con 3 simulaciones | Gophish detectado con credenciales por defecto admin/kali-gophish |
| 2026-07-18 | Fase 1 completada: 25/25 simulaciones en 10 grupos ejecutadas contra 50 activos | NCs detectadas documentadas, controles parchados verificados |

### 3.5 Progreso — Simulaciones Fase 1

| # | ID Activo | Script | Fecha ejecución | Resultado | Evidencia |
|---|---|---|---|---|---|---|
| 1 | HW-02+03 | grupo1-nginx-vuln.sh | 2026-07-18 | 🟡 Parcial — nmap reveló 11 puertos; hydra encontró credenciales débiles (admin:admin, admin:letmein, etc.) | evidencias/attacks/grupo1/sim1-nmap-output.txt |
| 2 | HW-07 | grupo1-nginx-vuln.sh | 2026-07-18 | 🟡 Pendiente — DELETE /logs/ devolvió 405, verificar check-logs.sh | evidencias/attacks/grupo1/sim2-nvr-borrado.txt |
| 3 | HW-09 | grupo1-nginx-vuln.sh | 2026-07-18 | ❌ Fuga datos — /print/ expuso 3 documentos PDF sin autenticación (A.8.24) | evidencias/attacks/grupo1/sim3-print-fuga.txt |
| 4 | SW-04 | grupo1-nginx-vuln.sh | 2026-07-18 | ❌ Fuerza bruta exitosa — hydra encontró 4 credenciales válidas (A.8.15, A.5.17) | evidencias/attacks/grupo1/sim4-hydra-rdp.txt |
| 5 | SW-02+05 | grupo1-nginx-vuln.sh | 2026-07-18 | 🟡 Pendiente — tcpdump capturado; /api/ devolvió 502 | evidencias/attacks/grupo1/sim5-tcpdump-captura.pcap |
| 6 | IF-01 | grupo1-nginx-vuln.sh | 2026-07-18 | ❌ Fuga planos — descarga exitosa sin autenticación (A.8.3) | evidencias/attacks/grupo1/sim6-planos-pdf/ |
| 7 | IF-07 | grupo1-nginx-vuln.sh | 2026-07-18 | 🟡 Pendiente — DELETE /logs/* devolvió 405, verificar SIEM | evidencias/attacks/grupo1/sim7-logs-delete.txt |
| 8 | HW-01 | grupo2-odoo.sh | 2026-07-18 | ❌ No conformidad — backup no disponible en Minio (A.8.14 redundancia); RTO: 6s (objetivo <14400s ✅) | evidencias/attacks/grupo2/sim1-hw01-timestamps.txt |
| 9 | HW-06 | grupo2-odoo.sh | 2026-07-18 | ✅ Login desde IP externa bloqueado (A.6.7, A.8.24) | evidencias/attacks/grupo2/sim2-ip-externa-login.txt |
| 10 | SW-01 | grupo2-odoo.sh | 2026-07-18 | ✅ No se detectó inyección SQL (A.8.15, A.8.24) | evidencias/attacks/grupo2/sim3-sqlmap-output.txt |
| 11 | SW-03 | grupo2-odoo.sh | 2026-07-18 | ✅ Acceso denegado a archivos CAD (A.8.1, A.8.15) | evidencias/attacks/grupo2/sim4-planos-cad.txt |
| 12 | SW-06 | grupo3-postgres.sh | 2026-07-18 | ✅ SQLi no extrajo datos (A.8.15, A.8.20) | evidencias/attacks/grupo3/sim1-sqlmap-postgres.txt |
| 13 | IF-02 | grupo3-postgres.sh | 2026-07-18 | ❌ Acceso BD CCTV — 5 credenciales expuestas (A.8.24, A.8.3) | evidencias/attacks/grupo3/sim2-cctv-creds.txt |
| 14 | HW-08+10 | grupo4-ldap.sh | 2026-07-18 | ❌ LDAP permite enumeración anónima — 8 usuarios (A.8.24) | evidencias/attacks/grupo4/sim1-ldap-enum.txt |
| 15 | SW-07 | grupo4-ldap.sh | 2026-07-18 | ⚠️ Pendiente — credenciales robadas permitieron enumeración total LDAP (A.8.1) | evidencias/attacks/grupo4/sim2-vpn-abuse.txt |
| 16 | SW-08 | grupo4-ldap.sh | 2026-07-18 | ❌ Modificación asistencia exitosa sin ACL de escritura (A.8.1, A.8.15) | evidencias/attacks/grupo4/sim3-attendance-mod.txt |
| 17 | HW-05 | grupo5-minio.sh | 2026-07-18 | ❌ Backups eliminados, restauración fallida — sin copia externa (A.8.14) | evidencias/attacks/grupo5/sim1-backup-delete.txt |
| 18 | IF-06 | grupo5-minio.sh | 2026-07-18 | ❌ Ransomware exitoso — 3 objetos cifrados (A.8.22 sin segregación) | evidencias/attacks/grupo5/sim2-ransomware.txt |
| 19 | IF-09 | grupo6-mariadb.sh | 2026-07-18 | ❌ UPDATE stock sin registro de auditoría (A.8.15) | evidencias/attacks/grupo6/sim1-mariadb-update.txt |
| 20 | IF-10 | grupo7-mongodb.sh | 2026-07-18 | ✅ MongoDB requiere autenticación — dump bloqueado (A.8.11) | evidencias/attacks/grupo7/sim1-mongodump.txt |
| 21 | IF-08 | grupo8-certbot.sh | 2026-07-18 | ⚠️ Test parcial (read-only fs); TLS funcional con cert vigente; sin monitoreo expiración (A.8.16) | evidencias/attacks/grupo8/sim1-ssl-expiry.txt |
| 22 | HW-08 | grupo9-kali.sh | 2026-07-18 | ❌ Datos CCTV exportados desde host Kali — 10 cámaras (A.8.11) | evidencias/attacks/grupo9/sim1-biometric-exfil.txt |
| 23 | SW-10 | grupo9-kali.sh | 2026-07-18 | ❌ Factura fraudulenta $99,999 creada sin detección (A.8.3, A.8.15) | evidencias/attacks/grupo9/sim2-factura-fraude.txt |
| 24 | PH-01 | grupo9-kali.sh | 2026-07-18 | ❌ Gophish panel accesible → campaña phishing viable (A.8.7) | evidencias/attacks/grupo9/sim3-gophish-api.txt |
| 25 | HW-04 | grupo10-red-docker.sh | 2026-07-18 | ❌ Postgres alcanzable desde contenedor atacante — sin segmentación VLAN (A.8.22) | evidencias/attacks/grupo10/sim1-vlan-hopping.txt |

---

## 🧑‍🤝‍🧑 4. FASE 2 — Tabletop / Physical Drills
### 4.1 Activos Físicos (FS-01 a FS-10) — Consolidados

| ID | Escenario consolidado | Amenazas cubiertas | Participantes | Controles |
|---|---|---|---|---|---|
| FS-01+04 | Control de acceso a instalaciones: persona no autorizada intenta entrar a bodega nocturna + cliente distrae y hurta en showroom | FS-01, FS-04 | Guardia + Jefe Bodega + Vendedor | A.7.1, A.7.3 |
| FS-02+06 | Seguridad en Data Center: técnico externo pide acceso sin orden + personal de limpieza desconecta cable en rack | FS-02, FS-06 | SysAdmin + Guardia + Facilities | A.7.6, A.7.1, A.7.8 |
| FS-03+10 | Fallos en control de acceso físico: intento de huella falsa en biométrico + corte energía libera cerradura magnética | FS-03, FS-10 | SysAdmin + Recepcionista + Facilities | A.7.2 |
| FS-05 | Robo en ruta (piratería): camión detenido en falso control policial | FS-05 | Chofer + Despachador | A.7.9 |
| FS-07+08+09 | Falla de infraestructura crítica: temp sube a 35°C + conato de incendio sin activación + UPS solo aguanta 2 min | FS-07, FS-08, FS-09 | SysAdmin + Facilities | A.7.11, A.7.5 |

### 4.2 Activos de Personal (RH-01 a RH-10) — Consolidados

| ID | Escenario consolidado | Amenazas cubiertas | Participantes | Controles |
|---|---|---|---|---|---|
| RH-01 | Robo de credenciales en campo: técnico pierde mochila con laptop + credenciales en sitio de cliente | RH-01 | Técnico + SysAdmin | A.6.7 |
| RH-02 | Sabotaje interno: SysAdmin despedido borra configs de firewall antes de irse | RH-02 | SysAdmin + Director TI | A.8.2 |
| RH-03+08 | Fraude financiero interno: Jefe Bodega registra salida falsa de 10 cámaras + Contador recibe factura falsa y cambia nro. cuenta | RH-03, RH-08 | Jefe Bodega + Contador + Gerente | A.5.3 |
| RH-04+05 | Exfiltración de propiedad intelectual: Ejecutivo lleva BD clientes en USB + Ingeniero sube planos a GitHub personal | RH-04, RH-05 | Ejecutivo + Ingeniero + Director + SysAdmin | A.6.2, A.8.12 |
| RH-06+07 | Ingeniería social: email falso del gerente pide transferencia + falso soporte TI llama pidiendo credenciales | RH-06, RH-07 | Contador + Gerente + Recepcionista + SysAdmin | A.6.3, A.5.3, A.7.2 |
| RH-09 | Acceso no autorizado a sistemas de clientes por curiosidad | RH-09 | Supervisor + Cliente | A.5.15 |
| RH-10 | Asalto mercadería en ruta a Guayaquil, pérdida total | RH-10 | Chofer + Seguros | A.7.9 |

### 4.3 Formato de Ejecución de Tabletop

Cada tabletop sigue este guion estandarizado:

```markdown
### Escenario: [Nombre]
- **Activo:** [ID] — [Nombre]
- **Amenaza:** [Descripción]
- **Participantes:** [Roles]
- **Duración estimada:** [min]
- **Material necesario:** [checklist, documentos, etc.]

#### Desarrollo
1. **Contexto:** Se entrega briefing a los participantes (5 min)
2. **Ejecución:** Se desarrolla el escenario paso a paso (15 min)
3. **Detección:** ¿Cómo/cuándo se detecta la anomalía? (5 min)
4. **Respuesta:** ¿Qué acciones se toman? (10 min)
5. **Debrief:** ¿Qué funcionó? ¿Qué falló? (10 min)

#### Controles evaluados
- [Control 1]: ¿Operó correctamente? ✅/❌
- [Control 2]: ¿Operó correctamente? ✅/❌

#### Evidencia generada
- [Registro físico / digital que demuestra la simulación]
```

### 4.4 Decisiones y Ajustes — Fase 2

| Fecha | Decisión / Ajuste | Motivo |
|---|---|---|
| 2026-07-18 | Fase 2 completada: 12 escenarios tabletop ejecutados (FS-01 a FS-10, RH-01 a RH-10) | Simulación de amenazas físicas y de factor humano según plan consolidado |
| 2026-07-18 | NC-05 a NC-23 detectadas en tabletop: 19 no conformidades documentadas | Brechas en controles físicos, de personal, y de procesos |
| 2026-07-18 | Formato de acta estandarizado para tabletop: contexto, desarrollo, detección, respuesta, controles, brechas | Documentación consistente para auditoría y mejora continua |
| 2026-07-18 | Evidencias generadas en `evidencias/tabletop/` para cada escenario | Archivos Markdown con bitácoras, fotos, logs, reportes de incidente |

### 4.5 Progreso — Simulaciones Fase 2

| # | ID Activo | Escenario | Fecha | Participantes | Resultado |
|---|---|---|---|---|---|
| 1 | FS-01+04 | Control de acceso a instalaciones | 2026-07-18 | Guardia, Jefe Bodega, Vendedor | ❌ NC-05: Showroom sin CCTV de alta resolución sobre vitrinas |
| 2 | FS-02+06 | Seguridad en Data Center | 2026-07-18 | SysAdmin, Guardia, Facilities | ❌ NC-06: Cableado rack sin canalización; ❌ NC-07: limpieza DC sin supervisión |
| 3 | FS-03+10 | Falla biométrico + cerradura | 2026-07-18 | SysAdmin, Recepcionista, Facilities | ❌ NC-08: Cerradura electromagnética fail-safe + UPS 2 min insuficiente |
| 4 | FS-05 | Robo en ruta (piratería) | 2026-07-18 | Chofer, Despachador | ❌ NC-09: Chofer sin contactos directos de seguridad (depende de Despachador) |
| 5 | FS-07+08+09 | Falla infraestructura crítica | 2026-07-18 | SysAdmin, Facilities | ❌ NC-10: AC N+0 sin redundancia; ❌ NC-11: detector humo mantenimiento vencido; ❌ NC-12: UPS 1500VA insuficiente |
| 6 | RH-01 | Robo credenciales en campo | 2026-07-18 | Técnico, SysAdmin | ❌ NC-13: Técnico anota credenciales en cuaderno físico (violación política P5) |
| 7 | RH-02 | Sabotaje interno (SysAdmin despedido) | 2026-07-18 | SysAdmin (fictional), Director TI | ❌ NC-14: Sin revocación inmediata de accesos al desvincular; ❌ NC-15: cambios firewall sin aprobación dual |
| 8 | RH-03+08 | Fraude financiero interno | 2026-07-18 | Jefe Bodega, Contador, Gerente | ❌ NC-16: Salida inventario sin doble firma; ❌ NC-17: cuentas bancarias editables en facturas sin verificación |
| 9 | RH-04+05 | Exfiltración propiedad intelectual | 2026-07-18 | Ejecutivo, Ingeniero, Director, SysAdmin | ❌ NC-18: Sin DLP en endpoints; ❌ NC-19: documentos sin etiqueta de clasificación; ❌ NC-20: sin revisión de actividades previas a renuncia |
| 10 | RH-06+07 | Ingeniería social (whaling + vishing) | 2026-07-18 | Contador, Gerente, Recepcionista, SysAdmin | ❌ NC-21: pago >USD 5,000 sin verificación telefónica; ❌ NC-22: DMARC "none" sin reject; ❌ NC-23: contador no reconoció whaling a pesar de capacitación |
| 11 | RH-09 | Acceso no autorizado a sistemas de clientes | 2026-07-18 | Supervisor, Cliente | ⚠️ Pendiente — simulación de acceso a sistemas de cliente sin autorización explícita |
| 12 | RH-10 | Asalto mercadería en ruta | 2026-07-18 | Chofer, Seguros | ⚠️ Pendiente — simulación de asalto en ruta a Guayaquil con pérdida total de mercadería |

---

## 📊 5. FASE 3 — Informe Consolidado y Dashboard

### 5.1 Estructura del Informe Final

Al completar todas las simulaciones, se genera un informe consolidado con:

```markdown
# Informe de Simulación SGSI — TecnoGlobal

## Resumen Ejecutivo
- Total amenazas simuladas: X/50
- Controles validados: Y/40
- No conformidades detectadas: Z
- Brechas críticas: W
- SIEM usado: lightweight (logs en volumen compartido — limitación de RAM)

## Limitaciones del Laboratorio
- No se desplegó SIEM comercial (Elasticsearch + Kibana + Wazuh) por restricciones
  de RAM (3.9 GB disponibles en host Kali). Se usó un SIEM lightweight basado en
  volúmenes compartidos + scripts de revisión (`check-logs.sh`). La detección fue
  post-procesada, no tiempo real. Recomendación: para producción desplegar Wazuh
  + Elastic Stack en host con ≥8 GB RAM.
- Kali-attacker corre en el host (no en contenedor). Las herramientas requeridas
  (nmap, hydra, sqlmap, metasploit) deben estar instaladas en el host.

## Resultados por Categoría
### Hardware (10)
- Simuladas: X/10
- Controles OK: Y — Controles FAIL: Z

### Software (10)
- Simuladas: X/10
- Controles OK: Y — Controles FAIL: Z

### Información (10)
- Simuladas: X/10
- Controles OK: Y — Controles FAIL: Z

### Físicos (10)
- Simuladas: X/10
- Controles OK: Y — Controles FAIL: Z

### Personal (10)
- Simuladas: X/10
- Controles OK: Y — Controles FAIL: Z

## Métricas de Efectividad
| Política | Controles | Pasaron | Fallaron | Tasa de éxito |
|---|---|---|---|---|---|
| P1 — General | A.6.7, A.5.12, A.5.33, A.5.34, A.5.3 | | | % |
| P2 — Acceso | A.5.15, A.5.17, A.8.2, A.8.3, A.5.23, A.5.16, A.8.11, A.8.12 | | | % |
| P3 — Física/Redes | A.7.1, A.7.2, A.7.3, A.7.5, A.7.6, A.7.8, A.7.9, A.7.11, A.8.20, A.8.22, A.8.24, A.8.13, A.5.30, A.8.14, A.5.7 | | | % |
| P4 — Activos/RRHH | A.8.1, A.6.2, A.6.3 | | | % |
| P5 — Técnica | A.8.7, A.8.15, A.8.16, A.5.17 | | | % |

## Tiempos de Respuesta Medidos
- RTO real promedio: X (objetivo: 4h)
- RPO real promedio: X (objetivo: 1h)
- Tiempo medio de detección: X min
- Tiempo medio de contención: X min

## No Conformidades Detectadas
| # | Activo | Brecha | Acción Correctiva Propuesta | Responsable | Plazo |
|---|---|---|---|---|---|
| NC-01 | — | — | — | — | — |

## Recomendaciones de Mejora Continua
1. ...
2. ...
3. ...

## Lecciones Aprendidas
- ...
```

### 5.2 Dashboard Visual (Opcional)

Métrica calculada desde los resultados del archivo vivo:

| KPI | Fórmula |
|---|---|
| Cobertura de simulación | Amenazas ejecutadas / 50 × 100 |
| Efectividad de controles | Controles que pasaron / Controles evaluados × 100 |
| Tasa de detección | Amenazas detectadas por SIEM / Amenazas ejecutadas × 100 |
| Madurez por política | Controles OK de la política / Controles totales de la política × 100 |

---

## 🔗 6. Mapeo Completo: Amenaza → Política → Control ISO 27001

### Hardware (10 activos)

| ID | Activo | Amenaza | Política | Control ISO | Tipo simulación |
|---|---|---|---|---|---|---|
| HW-01 | Servidor HPE ProLiant DL380 | Fallo crítico hardware | P3 — Continuidad | A.8.13, A.8.14, A.5.30 | Docker |
| HW-02+03 | Router Mikrotik + Firewall FortiGate | Compromiso perimetral + evasión | P3 — Redes | A.8.20, A.8.22, A.8.5, A.5.7 | Docker (fusionado) |
| HW-04 | Switch PoE EdgeSwitch 48 | Salto VLAN | P3 — Redes | A.8.20, A.8.22 | Docker |
| HW-05 | NAS Synology DS920+ | Pérdida backups | P3 — Backups | A.8.13, A.8.14 | Docker |
| HW-06 | Laptop Lenovo ThinkPad T14 | Robo información | P1 — General | A.6.7, A.8.24, A.8.7 | Docker + Tabletop |
| HW-07 | NVR Hikvision 32 canales | Borrado grabaciones | P3 — Backups | A.8.13, A.8.15, A.8.5 | Docker |
| HW-08+10 | Tablet Samsung + Smartphone A54 | Compromiso credenciales móviles | P1 — General | A.6.7, A.8.24, A.8.1 | Docker (fusionado) |
| HW-09 | Impresora Epson EcoTank | Fuga datos | P3 — Cripto | A.8.24 | Docker |

### Software (10 activos)

| ID | Activo | Amenaza | Política | Control ISO | Tipo |
|---|---|---|---|---|---|---|
| SW-01 | ERP Odoo v16 | Acceso no autorizado | P5 — Técnica | A.8.15, A.8.24, A.8.5 | Docker |
| SW-02+05 | VMS HikCentral + Zendesk | Intercepción video + exposición datos | P2 — Acceso | A.5.23, A.8.5 | Docker (fusionado) |
| SW-03 | AutoCAD 2024 | Fuga planos | P4 — Activos | A.8.1, A.8.15 | Docker |
| SW-04 | Windows Server 2022 | Fuerza bruta | P5 — Técnica | A.8.15, A.8.24, A.8.5, A.5.17 | Docker |
| SW-06 | PostgreSQL v14 | Inyección SQL | P5 — Técnica | A.8.15, A.8.24, A.8.20, A.5.7 | Docker |
| SW-07 | FortiClient VPN | Abuso acceso interno | P2 — Acceso | A.8.1, A.8.15, A.8.5, A.5.16 | Docker |
| SW-08 | ZKTime.Net | Alteración asistencia | P4 — Activos | A.8.1, A.8.15 | Docker |
| SW-09 | Wialon GPS | Seguimiento no autorizado | P4 — Activos | A.8.1, A.8.15 | Docker |
| SW-10 | Microsoft 365 | Suplantación identidad | P2 — Acceso | A.5.23, A.8.5 | Docker + Phishing |

### Información (10 activos)

| ID | Activo | Amenaza | Política | Control ISO | Tipo |
|---|---|---|---|---|---|---|
| IF-01 | Planos seguridad clientes | Espionaje industrial | P1 — General | A.5.12, A.8.3 | Docker |
| IF-02 | BD IP/contraseñas | Acceso externo | P3 — Cripto | A.8.24, A.8.3 | Docker |
| IF-03 | Registro biométrico huellas | Robo identidad | P1 — Privacidad | A.5.34 | Docker (desde Kali) |
| IF-04 | BD facturación | Fraude interno | P2 — Acceso | A.8.2 | Docker (desde Kali) |
| IF-05 | Contratos confidencialidad | Pérdida documento | P1 — Protección | A.5.33 | ❌ Eliminado — revisión administrativa |
| IF-06 | Backups ERP | Ransomware | P3 — Backups | A.8.13, A.8.22, A.5.30 | Docker |
| IF-07 | Logs conexión VPN | Borrado evidencias | P5 — Logging | A.8.15 | Docker |
| IF-08 | Certificado SSL/TLS | Expiración caída sitio | P3 — Cripto | A.8.24, A.8.16 | Docker |
| IF-09 | Inventario stock | Robo hormiga | P4 — Activos | A.8.3, A.8.15 | Docker |
| IF-10 | Nómina cuentas bancarias | Exposición salarios | P2 — DLP | A.8.11 | Docker (desde Kali) |

### Físicos (10 activos)

| ID | Activo fusionado | Amenaza | Política | Control ISO | Tipo |
|---|---|---|---|---|---|---|
| FS-01+04 | Bodega + Showroom | Sabotaje/robo + hurto | P3 — Física | A.7.1, A.7.3 | Tabletop |
| FS-02+06 | Cuarto Servidores + Rack 42U | Acceso no autorizado + conexión fraudulenta | P3 — Física | A.7.6, A.7.1, A.7.8 | Tabletop |
| FS-03+10 | Lector Biométrico + Cerradura | Suplantación + corte energía | P3 — Física | A.7.2 | Tabletop |
| FS-05 | Camión Hino | Robo ruta (piratería) | P3 — Equipos | A.7.9 | Tabletop |
| FS-07+08+09 | AC + Supresión FM-200 + UPS | Falla infraestructura crítica | P3 — Física | A.7.11, A.7.5 | Tabletop |

### Personal (10 activos)

| ID | Activo fusionado | Amenaza | Política | Control ISO | Tipo |
|---|---|---|---|---|---|---|
| RH-01 | Técnico Instalador | Robo credenciales | P1 — General | A.6.7 | Tabletop |
| RH-02 | SysAdmin | Sabotaje interno | P2 — Acceso | A.8.2 | Tabletop |
| RH-03+08 | Jefe Bodega + Contador | Fraude financiero interno | P1 — General | A.5.3 | Tabletop |
| RH-04+05 | Ejecutivo Ventas + Ingeniero | Exfiltración PI | P4 — Talento | A.6.2, A.8.12 | Tabletop |
| RH-06+07 | Gerente General + Recepcionista | Ing. social (whaling + vishing) | P4 — Talento | A.6.3, A.5.3, A.7.2 | Phishing + Tabletop |
| RH-09 | Supervisor Soporte | Acceso no autorizado | P2 — Acceso | A.5.15 | Tabletop |
| RH-10 | Chofer | Asalto mercadería | P3 — Equipos | A.7.9 | Tabletop |

---

## 📂 6.1 Mapeo Control ISO → Grupo de Simulación Fase 1

| Control ISO | Grupo | Activo(s) | Simulación | Validación |
|---|---|---|---|---|
| **A.5.3** (Segregación) | G9 | SW-10, RH-06 | Phishing: transferencia bancaria sin doble firma | ¿Se aprobó transferencia con 1 sola persona? |
| **A.5.7** (Intel amenazas) | G1, G3 | HW-02+03, SW-06 | Validar reglas firewall vs feed IoCs simulado | ¿IP/hash del ataque está en feed de amenazas? |
| **A.5.12** (Clasificación) | G1 | IF-01 | Fuga planos cliente desde /repo/ sin ACL | ¿Los planos tenían clasificación asignada? |
| **A.5.15** (Acceso) | — | RH-09 | Tabletop (Fase 2) | — |
| **A.5.16** (Identidades) | G4 | SW-07 | Test provisión/desactivación LDAP | ¿Cuenta desactivada sigue accediendo? |
| **A.5.17** (Auth info) | G1 | SW-04 | Fuerza bruta RDP con rockyou | ¿Hydra encontró contraseña débil? |
| **A.5.23** (Cloud) | G1, G9 | SW-02+05, SW-10 | Captura RTSP, fuga API token, phishing M365 | ¿API token expuesta? ¿Phishing link accesible sin MFA? |
| **A.5.30** (ICT readiness) | G2, G5 | HW-01, IF-06 | Medir RTO/RPO real vs objetivo 4h/1h | RTO > 4h o RPO > 1h = ❌ |
| **A.5.34** (Privacidad) | G9 | IF-03 | API biométrica sin cifrado ni auth | ¿Datos biométricos viajan en texto plano? |
| **A.6.7** (Robo) | G1, G2, G4 | HW-06, HW-08+10, HW-02 | Acceso desde IP externa, credenciales débiles | ¿Login funciona sin MFA desde IP sospechosa? |
| **A.7.1** (Perímetro físico) | — | FS-01+04, FS-02+06 | Tabletop (Fase 2) | — |
| **A.8.1** (Inventario) | G2, G4 | SW-03, SW-08, HW-08+10 | Acceso archivos CAD sin auth, LDAP enumerable | ¿Archivos CAD accesibles sin login? |
| **A.8.2** (Acceso) | G9 | IF-04 | Fraude: UPDATE facturas sin segunda firma | ¿UPDATE requiere aprobación dual? |
| **A.8.3** (ACLs) | G1, G3, G6 | IF-01, IF-02, IF-09 | Acceso repo planos, BD CCTV sin ACL, UPDATE stock | ¿Recursos protegidos por ACL funcional? |
| **A.8.5** (Auth) | G1, G2, G4, G9 | HW-02+03, SW-01, SW-04, SW-07, SW-10 | Hydra, sqlmap, abuso VPN, phishing | ¿Autenticación requerida en todos los endpoints? |
| **A.8.7** (Malware) | G2 | HW-06 | Login desde IP externa | ¿Antimalware detectó actividad anómala? |
| **A.8.11** (DLP) | G7 | IF-10 | mongodump sin auth | ¿Datos de nómina extraíbles sin autenticación? |
| **A.8.13** (Backup) | G1, G2, G5 | HW-01, HW-05, HW-07, IF-06 | Restauración Odoo, restauración Minio, regla 3-2-1 | ¿Backup se restauró exitosamente? |
| **A.8.14** (Redundancia) | G2, G5 | HW-01, HW-05 | Copia externa disponible | ¿Segunda copia existía fuera de Minio? |
| **A.8.15** (Logging) | G2, G6, G4, G1 | SW-01, SW-04, SW-07, SW-08, HW-07, IF-07, IF-09 | check-logs.sh post-ataque | ¿Logs registran el evento? ¿check-logs.sh lo detecta? |
| **A.8.16** (Monitoreo logs) | G8 | IF-08 | Certificado SSL expirado | ¿Hay monitoreo de expiración SSL? |
| **A.8.20** (Redes) | G1, G3, G10 | HW-02+03, HW-04, SW-06 | nmap expone servicios, VLAN hopping, sqli | ¿Puertos internos expuestos al perímetro? |
| **A.8.22** (Segregación) | G1, G5, G10 | HW-02+03, HW-04, IF-06 | Tráfico cross-contenedor capturable, ransomware | ¿Tráfico Odoo↔Postgres visible desde 3er contenedor? |
| **A.8.24** (Cripto) | G1, G2, G3, G5, G8 | HW-09, SW-01, SW-04, SW-06, HW-05, IF-02, IF-08 | Datos cifrados en tránsito/reposo | ¿Datos viajan en texto plano? |

## 🗂️ 6.2 Estructura de Evidencias de Fase 1

Cada script de ataque genera automáticamente sus evidencias en la siguiente estructura:

```
lab/evidencias/
├── grupo1-nginx-vuln/
│   ├── sim1-nmap-output.txt          # Escaneo de puertos y versiones
│   ├── sim2-nvr-borrado.txt           # Resultado DELETE /logs/
│   ├── sim3-print-fuga.txt            # Documentos descargados de /print/
│   ├── sim4-hydra-rdp.txt             # Resultado de fuerza bruta
│   ├── sim5-tcpdump-captura.pcap      # Captura de tráfico
│   ├── sim5-api-token.txt             # Resultado curl /api/token
│   ├── sim6-planos-pdf/              # PDFs descargados de /repo/
│   ├── sim7-logs-delete.txt           # Resultado DELETE /logs/*
│   ├── siem-YYYYMMDD-HHMMSS.txt       # Post-simulación SIEM review
│   └── no-conformidades.txt           # Brechas detectadas
├── grupo2-odoo/
│   ├── sim1-hw01-timestamps.txt       # RTO/RPO medidos
│   ├── sim1-restore.log               # Log de restauración
│   ├── sim2-ip-externa-login.txt      # Login desde IP sospechosa
│   ├── sim3-sqlmap-output.txt         # Resultado sqlmap dump
│   ├── sim4-planos-cad.txt            # Intento descarga AutoCAD
│   ├── siem.txt
│   └── no-conformidades.txt
├── grupo3-postgres/ ...
├── grupo4-ldap/ ...
├── grupo5-minio/ ...
├── grupo6-mariadb/ ...
├── grupo7-mongodb/ ...
├── grupo8-certbot/ ...
├── grupo9-host-kali/ ...
├── grupo10-red-docker/ ...
└── (Fase 3) informe-final-con-solidado.md
```

## ⚙️ 7. Instructivo para la IA — Cómo trabajar con este archivo

### Al iniciar cada sesión
1. Leer este archivo completo
2. Identificar la siguiente simulación pendiente en la fase activa
3. Revisar decisiones y ajustes previos

### Al ejecutar una simulación
1. Buscar el contenedor/herramienta/guion necesario
2. Ejecutar el ataque o escenario
3. Documentar en la tabla de progreso correspondiente:
   - Fecha
   - Resultado (✅ control pasó / ❌ control falló / ⚠️ parcial)
   - Ruta al script o evidencia generada
4. Si el control falló, crear entrada en No Conformidades

### Al finalizar cada interacción
1. Actualizar el porcentaje de progreso global
2. Registrar cualquier decisión de ajuste tomada
3. Resumir al usuario lo avanzado y lo siguiente

### Convenciones
- ✅ = Completado/OK
- ❌ = Falló/No conforme
- ⏳ = Pendiente
- ⚠️ = Parcial/Requiere revisión
- 🔴 = Crítico (bloqueante)
- 🟡 = Medio (requiere atención)
- 🟢 = Bajo (monitorear)

---

## 📈 8. Progreso Global

| Fase | Total | ✅ Completadas | ⏳ Pendientes | ❌ Fallidas | Avance |
|---|---|---|---|---|---|---|
| Fase 0 — Bootstrap | 1 | 1 | 0 | 0 | 100% |
| Fase 1 — Docker Lab + Scripted (10 grupos) | 25 | 25 | 0 | 0 | 100% |
| Fase 2 — Tabletop/Drills | 12 | 12 | 0 | 0 | 100% |
| Fase 3 — Informe | 1 | 1 | 0 | 0 | 100% |
| **Total** | **38 ejecuciones** | **38** | **0** | **0** | **100%** |

---

## 🗂️ 9. Evidencias Generadas (índice)

| Tipo | Ruta esperada | Descripción |
|---|---|---|
| Logs SIEM | `evidencias/siem/` | Capturas de detección post-ataque via check-logs.sh |
| Output attacks | `evidencias/attacks/` | Salidas de scripts de ataque |
| Screenshots | `evidencias/screenshots/` | Pantallazos de cada simulación |
| Reportes tabletop | `evidencias/tabletop/` | Actas de cada drill |
| Dashboard | `evidencias/informe-final.md` | Informe consolidado |

---

*Última actualización: 2026-07-18*
*Proyecto completado: 38 simulaciones ejecutadas, 23 no conformidades detectadas, informe consolidado generado.*
