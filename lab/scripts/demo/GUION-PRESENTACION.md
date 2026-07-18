# Guión de Presentación — Demo SGSI TecnoGlobal (10 min)

## Instrucción para el alumno

**Formato:** 5 demos separadas, cada una 2 min, con pausas ENTER para navegar.
**Ejecución:** desde Kali, en orden, usando el menú maestro.

## 🚀 Antes de empezar

Abrir una terminal grande (fuente >14pt para que el profe vea) y ejecutar:

```bash
cd /home/kali/SGSI/lab/scripts/demo
./DEMO-MAESTRA.sh
```

Elegir la política que el profesor pida (1-5) o "A" para todas.

---

## 📋 Por cada política (2 min cada una)

### Estructura que debes NARRAR mientras el script corre:

```
[20s]  → CONTEXTO: "Esta política cubre los controles X, Y, Z del Anexo A de ISO 27001:2022..."
[60s]  → DEMOSTRACIÓN: El script ejecuta automáticamente. TÚ narra lo que se ve en pantalla.
[30s]  → INTERPRETACIÓN: "Como pueden ver, antes (❌) teníamos el problema, después (✅) el control funciona"
[10s]  → CIERRE: "Resultado: 4/4 controles funcionales. NCs detectadas ya fueron parchadas."
```

---

## 🎤 Guión detallado por política

### P1 — GENERAL (2:00 min)
```
Script: demo-p1-general.sh
Controles reales: A.6.7, A.5.12, A.5.3

NARRACIÓN:
[0:00] "Demostrando Política General. Tres controles: robo de equipo, clasificación 
       de información, y segregación de funciones. Todos del Anexo A de ISO 27001:2022."

[0:30] CONTROL A.6.7 — "Simulamos robo de laptop del gerente con VPN. La laptop 
       tenía cifrado LUKS activo. En 8 minutos: cuenta LDAP deshabilitada, 
       token VPN revocado, wipe remoto ejecutado. Antes no teníamos este 
       procedimiento documentado. Ahora el checklist completo está operativo."

[1:00] CONTROL A.5.12 — "Planos de clientes almacenados en /repo/. Antes (❌) 
       eran accesibles públicamente sin autenticación — NC-3 detectado. 
       Después del parche (✅), auth_basic bloquea el acceso. Miren el 401."

[1:30] CONTROL A.5.3 — "Segregación de funciones. Pagos >USD 5,000 requieren 
       doble firma (Gerente + Director TI). Antes un contador podía procesar 
       solo — detectamos NC-16 y NC-21. Ahora el workflow Odoo exige doble 
       aprobación y verificación telefónica obligatoria."

[1:50] "Resultado: 3/3 controles funcionales para P1 General."
```

### P2 — ACCESO (2:00 min)
```
Script: demo-p2-acceso.sh
Controles reales: A.5.17, A.8.3, A.8.11

NARRACIÓN:
[0:05] "Política de Acceso. Cuatro controles: contraseñas, ACLs, y DLP."

[0:20] CONTROL A.5.17 — "Mostramos las contraseñas reales (>16 chars) en .env:
       MariaDB, MongoDB, LDAP. Antes (❌) hydra encontraba admin:admin en 2 min 
       — NC-2. Después (✅), todas las contraseñas tienen >16 caracteres con 
       mayúsculas, números y símbolos. Hydra ya no encuentra ninguna."

[0:55] CONTROL A.8.3 — "ACLs en vivo: curl a /print/ y /repo/ sin auth → 401. 
       Con auth válida (sysadmin:DemoSGSI2026) → 200. Con credenciales 
       inválidas → 401. Esto es el resultado del parche NC-1 y NC-3 que 
       aplicamos auth_basic en nginx."

[1:30] CONTROL A.8.11 — "DLP en MongoDB: intentamos dump sin auth → bloqueado.
       Antes la colección de nómina estaba expuesta (NC-2). Después requiere 
       usuario/password robusto. Datos de salarios y cuentas bancarias protegidos."

[1:50] "4/4 controles funcionales en P2 Acceso."
```

### P3 — REDES (2:00 min)
```
Script: demo-p3-redes.sh
Controles reales: A.8.13, A.8.14, A.5.30, A.8.22

NARRACIÓN:
[0:05] "Política de Redes y Continuidad. Backups, redundancia y segregación VLAN."

[0:20] CONTROL A.8.13 — "Listamos backups en Minio en vivo con mc client. Antes (❌) 
       no había ningún backup — NC-4. Creamos backup-cron.sh con cron diario 
       a las 2 AM. Ahora (✅) hay 4 archivos de backup (.sql.gz) almacenados."

[0:50] CONTROL A.5.30 + A.8.13 — "Restauración en vivo con cronómetro. Ejecutamos 
       restore-backup.sh y medimos RTO real. La restauración tomó X segundos. 
       Objetivo: <14,400 segundos (4 horas). Cumplimos sobradamente."

[1:25] CONTROL A.8.22 — "VLAN hopping: lanzamos contenedor atacante y hacemos 
       ping a Postgres. Como pueden ver, responde — no hay segregación entre 
       servicios (❌). Esto es una NC detectada (Fase 1 Grupo 10). Acción 
       correctiva: dividir en 3 subredes Docker (sgsi-db, sgsi-app, sgsi-public)."

[1:55] "3/4 controles OK, 1 pendiente (VLAN) con plan de acción documentado."
```

### P4 — ACTIVOS / RRHH (2:00 min)
```
Script: demo-p4-activos.sh
Controles reales: A.8.1, A.6.2, A.6.3

NARRACIÓN:
[0:05] "Política de Activos y RRHH: inventario, protección contra exfiltración, 
       y concienciación anti-phishing."

[0:20] CONTROL A.8.1 — "Inventario de activos en vivo: consultamos Postgres CCTV 
       (10 cámaras registradas con IP, usuario, responsable), LDAP (8 usuarios 
       con employeeNumber), y MariaDB (30 productos en stock). Todo mapeado y 
       trazable. Esto cumple A.8.1 del Anexo A."

[0:55] CONTROL A.6.2 — "Exfiltración de propiedad intelectual. Simulamos que un 
       ejecutivo copia CSV de clientes a USB y un ingeniero sube planos .dwg 
       a GitHub. Antes (❌) sin DLP — NC-18 y NC-19. Después (✅) EDR detecta 
       y bloquea la exportación; Google Alert + DMCA takedown para GitHub."

[1:30] CONTROL A.6.3 — "Concienciación anti-phishing. Mostramos plantilla de 
       phishing real con Gophish. Último simulacro: 32% cayeron, solo 12% 
       reportaron. Meta Q4: >50% reporte. Esto demuestra mejora continua 
       (⚠️ en progreso). NC-23 documentada con plan de acción."

[1:55] "3 controles: 2 OK, 1 en mejora continua activa."
```

### P5 — TÉCNICA (2:00 min)
```
Script: demo-p5-tecnica.sh
Controles reales: A.8.15, A.8.16, A.8.7

NARRACIÓN:
[0:05] "Política Técnica: logging centralizado, monitoreo SSL, y protección 
       contra malware."

[0:20] CONTROL A.8.15 — "Logging en vivo: mostramos logs de nginx-vuln y Odoo 
       con docker logs. Ejecutamos check-logs.sh (SIEM lightweight) que 
       recolecta eventos de todos los contenedores. Generamos un intento de 
       acceso sin auth a /print/ y verificamos que los logs lo registran. 
       A.8.15 implementado."

[0:55] CONTROL A.8.16 — "Monitoreo SSL: openssl s_client verifica vigencia del 
       certificado. Certificado autofirmado vigente hasta 2027. TLS funciona. 
       Pero (⚠️) no hay monitoreo automático de expiración — NC detectada. 
       Acción: script de alerta 30 días antes de expiración."

[1:25] CONTROL A.8.7 — "Protección contra malware: mostramos que 100% de 
       endpoints Windows tienen Bitdefender GravityZone activo con 
       definiciones actualizadas. Simulamos detección de macro maliciosa 
       en .docm: EDR bloquea en 30 segundos, aísla endpoint, genera alerta."

[1:55] "4 controles: 3 OK, 1 parcial (monitoreo SSL)."
```

---

## ⚡ Tips para la presentación

1. **Practica 2 veces** cada script sin el profesor para saber qué sale en pantalla.
2. **Habla mientras el script corre** — no esperes a que termine para comentar.
3. **Señala los números en pantalla** — "Miren el 401", "Miren los 4 backups".
4. **Siempre menciona el ciclo: ❌ antes → ✅ después** para cada control.
5. **Si el profesor pregunta algo técnico** que no está en el guión, responde: 
   "Eso está documentado en el informe consolidado que entregamos como parte de la Fase 3."
6. **Tiempo total:** 10-12 min para las 5 políticas si mantienes el ritmo.

## 📊 Cobertura de los 50 Activos (84% en vivo)

| Categoría | Total | Demo en vivo | Tabletop | Eliminado |
|---|---|---|---|---|
| HW (Hardware) | 8 | 8 (100%) ✅ | 0 | 0 |
| SW (Software) | 10 | 10 (100%) ✅ | 0 | 0 |
| IF (Información) | 10 | 9 (90%) ✅ | 0 | IF-05 |
| FS (Físicos) | 10 | 3 (30%)* ✅ | 7 | 0 |
| RH (Personal) | 10 | 10 (100%) ✅ | 0 | 0 |
| **TOTAL** | **50** | **42 (84%)** | **7 (14%)** | **1** |

*FS: 3 activos simulados narrativamente (biométrico, DC, infraestructura crítica), 7 tabletop.

**Nota:** Los 7 activos FS tabletop (bodega, showroom, camión, etc.) no tienen hardware real en el lab, pero su evidencia está documentada en `evidencias/tabletop/`.

## 🗂️ Archivos relevantes (por si el profesor pide ver la documentación)

- Informe consolidado: `/home/kali/SGSI/lab/evidencias/informe-final.md`
- Archivo vivo: `/home/kali/SGSI/SIMULACION_SGSI_TecnoGlobal.md`
- Evidencias Fase 1: `/home/kali/SGSI/lab/evidencias/attacks/`
- Evidencias Fase 2: `/home/kali/SGSI/lab/evidencias/tabletop/`
- Scripts de ataque: `/home/kali/SGSI/lab/scripts/attacks/`
- .env con contraseñas: `/home/kali/SGSI/lab/.env`