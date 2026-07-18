# Guía para Presentación en Vivo — Demo SGSI TecnoGlobal

## 🎯 Objetivo
Demostrar en vivo la implementación de las 5 políticas del SGSI con evidencia técnica ejecutable en Kali Linux.

## 📊 Cobertura Actual
| Categoría | Total | Demo en vivo | Tabletop | Eliminado |
|---|---|---|---|---|
| HW (Hardware) | 8 | 8 (100%) ✅ | 0 | 0 |
| SW (Software) | 10 | 10 (100%) ✅ | 0 | 0 |
| IF (Información) | 10 | 9 (90%) ✅ | 0 | IF-05 |
| FS (Físicos) | 10 | 3 (30%)* ✅ | 7 | 0 |
| RH (Personal) | 10 | 10 (100%) ✅ | 0 | 0 |
| **TOTAL** | **50** | **42 (84%)** | **7 (14%)** | **1** |

*FS: 3 activos simulados narrativamente (biométrico, DC, infraestructura crítica), 7 tabletop.

## 🚀 Instrucciones para Ejecutar

1. Abre una terminal grande (fuente >14pt para que el profesor vea).
2. Ejecuta:
   ```bash
   cd /home/kali/SGSI/lab/scripts/demo
   ./DEMO-MAESTRA.sh
   ```
3. Selecciona la política que el profesor pida (1-5) o "A" para todas.

## 📌 Guión para Narrar en Vivo

### Estructura para cada control (20-30 segundos):
```markdown
1. **Contexto (5s):**
   "Este control cubre [A.X.X] del Anexo A de ISO 27001:2022, que exige [descripción breve]."

2. **Demostración (10s):**
   "Ahora ejecutamos [comando en pantalla]. Como pueden ver, el output muestra [resultado clave]."

3. **Interpretación (10s):**
   "Antes (❌) teníamos [problema detectado en NC-X]. Después del parche (✅), [resultado actual]."

4. **Cierre (5s):**
   "Resultado: [✅/⚠️/❌] — [mensaje final]."
```

### Ejemplo para P2 (Acceso):
```markdown
[Control A.8.3 — ACLs]
1. "Este control cubre A.8.3 del Anexo A, que exige control de acceso a recursos sensibles."
2. "Ejecutamos curl a /print/ sin auth. Como ven, devuelve 401 (no autorizado)."
3. "Antes (❌) el endpoint estaba expuesto (NC-1). Después del parche (✅), auth_basic bloquea el acceso."
4. "Resultado: ✅ — ACLs funcionando en /print/ y /repo/."
```

## 📋 Mapeo de Políticas a Scripts

| Política | Script | Controles clave | Tiempo estimado |
|---|---|---|---|
| **P1 — General** | `demo-p1-general.sh` | A.6.7, A.5.12, A.5.3 | 2 min |
| **P2 — Acceso** | `demo-p2-acceso.sh` | A.5.17, A.8.2, A.8.3, A.8.11, A.5.23 | 2.5 min |
| **P3 — Redes/Física** | `demo-p3-redes.sh` | A.8.13, A.8.14, A.8.22, A.5.30, A.7.9, A.7.2, A.7.6, A.7.8, A.7.11, A.7.5 | 3 min |
| **P4 — Activos/RRHH** | `demo-p4-activos.sh` | A.8.1, A.6.2, A.6.3, A.5.15 | 2.5 min |
| **P5 — Técnica** | `demo-p5-tecnica.sh` | A.8.7, A.8.15, A.8.16, A.5.17 | 2 min |

## 💡 Tips para la Presentación

1. **Practica 2 veces** cada política antes del día real.
2. **Habla mientras el script corre** — no esperes a que termine para explicar.
3. **Señala los números en pantalla** (ej: "Miren el 401", "Miren los 4 backups").
4. **Usa colores** (✅ verde, ❌ rojo, ⚠️ amarillo) para destacar resultados.
5. **Si el profesor interrumpe**, di: *"Permítame mostrarle la evidencia en [archivo] después de la demo."*
6. **Tiempo total:** 10-12 min para las 5 políticas (2-3 min por política).

## 🗣️ Respuestas a Preguntas Frecuentes

| Pregunta del profesor | Respuesta recomendada |
|---|---|
| *"¿Cómo saben que el control realmente funciona?"* | "Lo demostramos en vivo con [comando]. Antes (❌) [problema], después (✅) [resultado]. La evidencia está en [archivo de logs/evidencias]." |
| *"¿Qué pasa si falla el control?"* | "Detectamos fallas en la Fase 1 (ej: NC-01). Las parchamos y verificamos en esta demo. Si fallara ahora, lo registraríamos como una nueva NC." |
| *"¿Cómo aplican esto a los activos físicos?"* | "Los activos FS (bodega, DC, camión) no tienen hardware real, pero los simulamos como tabletop. La evidencia está en `evidencias/tabletop/` y en esta demo mostramos 3 controles FS narrativos (biométrico, DC, infraestructura crítica)." |
| *"¿Dónde está la documentación?"* | "Todo está en el informe consolidado (`evidencias/informe-final.md`) y en el archivo vivo (`SIMULACION_SGSI_TecnoGlobal.md`)." |
| *"¿Cómo garantizan que esto se cumple en producción?"* | "Los controles técnicos (ej: auth_basic, backups) se aplican en el lab y son replicables en producción. Los controles físicos/personales requieren tabletop + capacitación, que también documentamos." |

## 📂 Archivos Relevantes

| Archivo | Ubicación | Contenido relevante |
|---|---|---|
| **Informe consolidado** | `/home/kali/SGSI/lab/evidencias/informe-final.md` | Dashboard, NCs, recomendaciones |
| **Archivo vivo** | `/home/kali/SGSI/SIMULACION_SGSI_TecnoGlobal.md` | Planificación, ejecución, resultados |
| **Evidencias Fase 1** | `/home/kali/SGSI/lab/evidencias/attacks/` | Outputs de scripts de ataque |
| **Evidencias Fase 2** | `/home/kali/SGSI/lab/evidencias/tabletop/` | Actas de tabletop (FS y RH) |
| **.env** | `/home/kali/SGSI/lab/.env` | Contraseñas robustas (>16 chars) |

## ⚠️ Qué Hacer si el Profesor Pide Algo No Cubierto

Si pregunta por un activo o control no demostrado en vivo (ej: FS-01, SW-09), responde:

> *"Ese activo se simuló como tabletop en la Fase 2. La evidencia está documentada en `evidencias/tabletop/[acta].md`. ¿Desea que le muestre el acta o prefiere ver otro control técnico?"*

## 🎤 Ejemplo de Flujo Completo (P2 — Acceso)

```bash
# Terminal:
cd /home/kali/SGSI/lab/scripts/demo
./DEMO-MAESTRA.sh
# Selecciona "2" para P2
```

**Narración:**

> *"Voy a demostrar la Política de Acceso (P2), que cubre 5 controles del Anexo A de ISO 27001:2022.
>
> Primero, el control A.5.17: contraseñas robustas. Mostramos las contraseñas reales en .env — todas tienen más de 16 caracteres con mayúsculas, números y símbolos. Antes (❌) hydra encontraba credenciales débiles, ahora (✅) no.
>
> Segundo, el control A.8.3: ACLs en endpoints. Ejecutamos curl a /print/ y /repo/ sin auth — devuelve 401. Con auth válida (sysadmin:DemoSGSI2026) — devuelve 200. Esto parcha la NC-01.
>
> Tercero, el control A.8.11: DLP en MongoDB. Intentamos mongodump sin auth — bloqueado. Antes (❌) la nómina estaba expuesta, ahora (✅) requiere autenticación.
>
> Cuarto, el control A.5.23: protección de API tokens. Intentamos acceder a /api/zendesk — devuelve 404. Antes (❌) el token estaba expuesto, ahora (✅) el endpoint está eliminado.
>
> Resultado: 4/4 controles funcionales en P2 Acceso."*

## 📌 Cierre de la Demo

Al finalizar la política, di:

> *"Esto cubre [X] controles de la política [PX]. La cobertura total del SGSI es del 84% (42/50 activos demostrados en vivo o con simulación narrativa). ¿Desea ver otra política o profundizar en algún control?"*

## 🔐 Credenciales para la Demo

| Servicio | Usuario | Contraseña |
|---|---|---|
| /print/ y /repo/ | sysadmin | DemoSGSI2026 |
| MongoDB | nomina_admin | N0m1n@_M0ng0_S3cur3_ |
| Minio | minio_admin | M1n10_B4ckupS_Str0ng_ |
| LDAP | admin | Ld@p_Adm1n_T3cn0_SGSI_ |

## 🚨 Solución de Problemas

| Problema | Solución |
|---|---|
| Script no ejecuta | Verifica permisos: `chmod +x demo-p*.sh` |
| 404 en /repo/ | Reinicia nginx: `docker exec sgsi-nginx-vuln nginx -s reload` |
| MongoDB no responde | Verifica contenedor: `docker ps | grep mongodb` |
| Minio no lista backups | Verifica alias: `docker run --rm --network host minio/mc:latest mc alias set l http://localhost:9000 minio_admin M1n10_B4ckupS_Str0ng_` |

## 📅 Preparación Previa

1. **Practica 2 veces** cada política antes del día real.
2. **Verifica que todos los contenedores estén levantados:**
   ```bash
   docker ps --format 'table {{.Names}}\t{{.Status}}'
   ```
3. **Reinicia nginx** si los endpoints no responden:
   ```bash
   docker exec sgsi-nginx-vuln nginx -s reload
   ```
4. **Abre el informe consolidado** en otra terminal para referencia rápida:
   ```bash
   less /home/kali/SGSI/lab/evidencias/informe-final.md
   ```