# 🎯 Plan de Simulación de Amenazas SGSI — TecnoGlobal

> Archivo vivo de planificación, ejecución y seguimiento.
> La IA trabajará registrando aquí cada fase, decisión, ajuste y resultado.

---

## 📋 Estado General del Proyecto

| Componente | Estado | Última actualización |
|---|---|---|
| Plan definido | ✅ Completado (optimizado) | 2026-07-18 |
| Fase 1: Docker Lab + Scripted | ⏳ Pendiente | — |
| Fase 2: Tabletop / Physical Drills | ⏳ Pendiente | — |
| Fase 3: Informe Consolidado | ⏳ Pendiente | — |

**Progreso global:** ▰▰▰▰▰▰▰▰▰▰ 0%

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
├── .agents/skills/               # Skills cargables por la IA
└── SIMULACION_SGSI_TecnoGlobal.md # ← ESTE ARCHIVO (vivo)
```

---

## 🧭 2. Estrategia General de Simulación — Enfoque HÍBRIDO

Las 50 amenazas se abordan con **2 modalidades** (Scripted Attacks absorbida dentro del Laboratorio Docker):

| Modalidad | Cobertura | Activos | Nº amenazas |
|---|---|---|---|
| **A — Laboratorio Docker + Scripted** | Amenazas técnicas digitales + explotación desde Kali | HW (1-10), SW (1-10), IF (1-10, excepto IF-05) | ~21 |
| **B — Tabletop / Physical Drills** | Amenazas físicas y de factor humano | FS (1-10), RH (1-10) | ~12 |

**Total simulaciones únicas:** ~33 (optimizado — fusiones de escenarios redundantes y eliminación de simulación administrativa IF-05)

### Reglas del archivo vivo

1. Cada simulación ejecutada se marca con ✅ y se documenta con fecha + evidencias
2. Decisiones de ajuste se registran en **Decisiones/Ajustes** de cada fase
3. Si un control falla, se documenta como **No conformidad** con plan de acción
4. El progreso se actualiza al inicio de cada interacción

---

## 📦 3. FASE 1 — Laboratorio Docker (Infraestructura Técnica)

### 3.1 Topología del Lab

```
┌─────────────────────────────────────────────────────────┐
│                     DOCKER NETWORK                       │
│                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐     │
│  │  Kali     │   │  Odoo    │   │  PostgreSQL       │     │
│  │ (attacker)│──▶│ (ERP)    │──▶│  (BD Odoo)        │     │
│  └──────────┘   └──────────┘   └──────────────────┘     │
│       │                                                  │
│       ▼                                                  │
│  ┌─────────────────────────────────────────────────┐     │
│  │  SIEM Layer (Elasticsearch + Kibana + Wazuh)     │     │
│  │  Recibe logs de todos los contenedores           │     │
│  └─────────────────────────────────────────────────┘     │
│                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐     │
│  │  Minio   │   │  Nginx-  │   │  LDAP/            │     │
│  │ (NAS sim)│   │  vuln    │   │  Simula-VPN       │     │
│  └──────────┘   └──────────┘   └──────────────────┘     │
│                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐     │
│  │  MariaDB │   │  MongoDB │   │  Certbot          │     │
│  │(invent.)│   │ (nómina) │   │  (SSL sim)        │     │
│  └──────────┘   └──────────┘   └──────────────────┘     │
└─────────────────────────────────────────────────────────┘
```

### 3.2 Servicios y Activos Emulados

| Servicio Docker | Activo real | Propósito |
|---|---|---|
| `odoo` | SW-01 ERP Odoo v16 | Sistema crítico de gestión |
| `postgres-erp` | SW-06 PostgreSQL v14 | Base de datos del ERP |
| `nginx-vuln` | HW-02/HW-03 (router/firewall sim) | Punto de entrada perimetral |
| `postgres-cctv` | IF-02 BD contraseñas CCTV | Datos sensibles de clientes |
| `minio` | HW-05 NAS Synology | Almacenamiento de backups |
| `ldap-server` | SW-07 VPN FortiClient sim | Gestión de identidades |
| `mariadb-inventario` | IF-09 Inventario stock | Base de inventario |
| `mongodb-nomina` | IF-10 Nómina y cuentas | Datos payroll |
| `elasticsearch` + `kibana` | Política 5 (SIEM) | Centralización de logs |
| `wazuh` | Política 5 (EDR/HIDS) | Detección de amenazas |
| `certbot` | IF-08 SSL/TLS | Certificado digital |
| `kali-attacker` | — | Orquesta ataques (Hydra, SQLmap, Metasploit, nmap) |

### 3.3 Mapeo Amenaza → Docker → Script

| ID | Amenaza | Activo Docker | Script de ataque | Control a validar |
|---|---|---|---|---|---|
| HW-01 | Fallo crítico de hardware ERP | `odoo` | `docker stop odoo` + `restore-backup.sh` + medir RTO/RPO | A.8.13, A.8.14, A.5.30 |
| HW-02+03 | Compromiso perimetral + evasión firewall | `nginx-vuln` | `nmap -sV -p-` + `metasploit` + curl bypass WAF + validar actualización reglas desde feed IoCs | A.8.20, A.8.22, A.8.5, A.5.7 |
| HW-04 | VLAN hopping / salto VLAN | Red Docker | `macof` / `yersinia` simulado | A.8.20, A.8.22 |
| HW-05 | Pérdida irrecuperable backups | `minio` | `simulate-ransomware.sh` (borra/encrypta) | A.8.13, A.8.14 |
| HW-06 | Robo laptop gerencia | `odoo` (datos) | Simular acceso desde IP externa tras robo | A.6.7, A.8.24, A.8.7 |
| HW-07 | Borrado grabaciones NVR | `nginx-vuln` | Borrar logs/snapshots en storage | A.8.13, A.8.15, A.8.5 |
| HW-08+10 | Compromiso credenciales tablet + smartphone | `ldap-server` | `hydra -l user -P rockyou.txt ldap-server` + login desde ubicación anómala | A.6.7, A.8.24, A.8.1 |
| HW-09 | Fuga datos impresora | `nginx-vuln` (spool) | Simular captura de documento en cola | A.8.24 |
| SW-01 | Acceso no autorizado ERP | `odoo` | `sqlmap -u http://odoo:8069 --dump-all` | A.8.15, A.8.24, A.8.5 |
| SW-02+05 | Intercepción video + exposición datos Zendesk | `nginx-vuln` (RTSP sim + API key) | Capturar stream con ffplay/tcpdump + fuga de API token | A.5.23, A.8.5 |
| SW-03 | Fuga planos AutoCAD | `odoo` (file share) | `curl -O` archivos restringidos sin auth | A.8.1, A.8.15 |
| SW-04 | Fuerza bruta Windows Server | `nginx-vuln` (RDP sim) | `hydra -l admin -P rockyou.txt rdp://nginx-vuln` + validar política de contraseñas | A.8.15, A.8.24, A.8.5, A.5.17 |
| SW-06 | Inyección SQL PostgreSQL | `postgres-erp` | `sqlmap -d postgresql://... --dump` + validar reglas WAF contra IoCs | A.8.15, A.8.24, A.8.20, A.5.7 |
| SW-07 | Abuso VPN acceso interno | `ldap-server` | Reutilizar credenciales robadas + test de provisión/desactivación de cuentas | A.8.1, A.8.15, A.8.5, A.5.16 |
| SW-08 | Alteración registros asistencia | `ldap-server` | Modificar entrada LDAP de horario | A.8.1, A.8.15 |
| SW-09 | Seguimiento GPS no autorizado | — | Tabla de trazabilidad (API call sim) | A.8.1, A.8.15 |
| SW-10 | Suplantación identidad M365 | `gophish` + `mailhog` | Campaña de phishing controlada | A.5.23, A.8.5 |
| IF-01 | Fuga planos seguridad clientes | `nginx-vuln` (repo) | Acceso a repositorio compartido sin ACL | A.5.12, A.8.3 |
| IF-02 | Acceso a BD IP/contraseñas | `postgres-cctv` | SQLi + dump tablas credenciales | A.8.24, A.8.3 |
| IF-03 | Exfiltración biométrica | `kali-attacker` | `curl` a API REST sin cifrado — extraer datos biométricos | A.5.34 |
| IF-04 | Fraude facturación | `kali-attacker` | `psql` directo a BD facturación sin MFA | A.8.2 |
| IF-06 | Ransomware sobre backups | `minio` | Script que simula cifrado + validar RTO/RPO de recuperación | A.8.13, A.8.22, A.5.30 |
| IF-07 | Borrado de logs VPN | `elasticsearch` | `curl -X DELETE "es:9200/logs-*"` sin auth | A.8.15 |
| IF-08 | Expiración SSL sin aviso | `certbot` | Detener renovación + mostrar error TLS | A.8.24, A.8.16 |
| IF-09 | Alteración inventario stock | `mariadb-inventario` | `UPDATE stock SET cantidad=0 WHERE id=X` | A.8.3, A.8.15 |
| IF-10 | Exposición nómina y cuentas | `kali-attacker` | `mongodump` a MongoDB nómina sin autenticación | A.8.11 |

### 3.4 Decisiones y Ajustes — Fase 1

| Fecha | Decisión / Ajuste | Motivo |
|---|---|---|
| — | — | — |
| — | — | — |

### 3.5 Progreso — Simulaciones Fase 1

| # | ID Activo | Script | Fecha ejecución | Resultado | Evidencia |
|---|---|---|---|---|---|
| — | — | — | — | — | — |

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
| — | — | — |

### 4.5 Progreso — Simulaciones Fase 2

| # | ID Activo | Escenario | Fecha | Participantes | Resultado |
|---|---|---|---|---|---|
| — | — | — | — | — | — |

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
| Fase 1 — Docker Lab + Scripted | ~21 | 0 | 21 | 0 | 0% |
| Fase 2 — Tabletop/Drills | ~12 | 0 | 12 | 0 | 0% |
| Fase 3 — Informe | 1 | 0 | 1 | 0 | 0% |
| **Total** | **~34** | **0** | **34** | **0** | **0%** |

---

## 🗂️ 9. Evidencias Generadas (índice)

| Tipo | Ruta esperada | Descripción |
|---|---|---|
| Logs SIEM | `evidencias/siem/` | Capturas de detección en Kibana |
| Output attacks | `evidencias/attacks/` | Salidas de scripts de ataque |
| Screenshots | `evidencias/screenshots/` | Pantallazos de cada simulación |
| Reportes tabletop | `evidencias/tabletop/` | Actas de cada drill |
| Dashboard | `evidencias/informe-final.md` | Informe consolidado |

---

*Última actualización: 2026-07-18*
*Próxima acción: Iniciar Fase 1 — Desplegar docker-compose.yml del laboratorio (21 simulaciones técnicas)*
