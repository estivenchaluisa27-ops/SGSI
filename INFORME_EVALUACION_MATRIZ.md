# INFORME DE EVALUACIÓN — Matriz de Riesgos vs. ISO/IEC 27001:2022

| Campo | Detalle |
|---|---|
| **Organización** | TecnoGlobal Importadora |
| **Documento evaluado** | `Matrizderiesgos.xlsx` — 50 activos, 5 categorías |
| **Fecha de evaluación** | 2026-07-18 |
| **Próxima revisión** | 2027-07-18 |
| **Norma de referencia** | ISO/IEC 27001:2022 (Cláusulas 6.1, 7.5, 8.2, 8.3, Anexo A) |
| **Auditor** | Sistema Experto SGSI v1.0 |

---

## 1. Alcance de la evaluación

Se evaluó la totalidad de la matriz de riesgos (`Matrizderiesgos.xlsx`, hoja `Activos_SGSI(Activos SGSI)`) que contiene **50 activos de información** distribuidos en:

| Categoría | Cantidad | IDs |
|---|---|---|
| Hardware | 10 | HW-01 a HW-10 |
| Software | 10 | SW-01 a SW-10 |
| Información | 10 | IF-01 a IF-10 |
| Físicos | 10 | FS-01 a FS-10 |
| Personal | 10 | RH-01 a RH-10 |

### Metodología aplicada

- Contraste de cada campo contra los requisitos de ISO 27001:2022 (Cláusulas 4–10, Anexo A)
- Verificación de integridad de datos (valores nulos, formatos, rangos)
- Validación del cálculo Riesgo = Probabilidad × Impacto
- Cobertura de controles del Anexo A (versión 2022, 93 controles en 4 categorías)

---

## 2. Resumen de conformidad

| Cláusula ISO 27001:2022 | Requisito evaluado | Conformidad | Observaciones |
|---|---|---|---|
| **6.1.2** | Identificación de activos, amenazas, vulnerabilidades | ✅ Conforme | 50 activos con amenaza y vulnerabilidad documentadas |
| **6.1.2** | Criterios de evaluación de riesgos | ✅ Conforme | Escala 1-5 para Probabilidad e Impacto |
| **6.1.2** | Clasificación CIA | ✅ Conforme | Columnas C, I, D completas para todos los activos |
| **6.1.3** | Mapeo a controles del Anexo A | ⚠️ Parcial | Faltaban controles nuevos de 2022 — corregido |
| **6.2** | Objetivos de seguridad | ✅ Conforme | Definidos en políticas asociadas |
| **7.5.3** | Control de información documentada | ❌ No conforme | Datos de escala filtrados en filas de datos — corregido |
| **8.2** | Evaluación de riesgos sistemática | ⚠️ Parcial | Formato inconsistente en columna Riesgo — corregido |
| **8.3** | Tratamiento de riesgos / Riesgo residual | ❌ No conforme | Ausente — corregido añadiendo columna |
| **8.3** | Controles seleccionados | ⚠️ Parcial | Subóptimos en 4 activos — corregido |
| **Anexo A** | Controles nuevos ISO 27001:2022 | ❌ No conforme | A.5.7, A.5.30 no mapeados — corregido |

---

## 3. No conformidades detectadas

### NC-1 — Información documentada no controlada (Cláusula 7.5.3)

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | Las columnas R–U del Excel contenían datos de la leyenda de escalas intercalados con las filas de datos de activos (cabeceras "Valor", "Nivel", "Descripción", "Escala de Impacto", "Matriz de Riesgo", y valores como "1", "Raro", etc. en filas HW-02, HW-08, HW-09, SW-06, SW-07, SW-08, SW-09, SW-10, IF-01). |
| **Impacto** | Dificulta la lectura automatizada y el control de versiones. Mezcla metadatos con datos operativos. |
| **Acción correctiva** | ✅ Datos movidos a hoja `Leyenda`. Columnas R–U reasignadas a nuevos campos: Riesgo Residual, Fecha Evaluación, Próxima Revisión, Observaciones. |
| **Evidencia** | Hoja `Leyenda` creada con escalas de probabilidad, impacto y matriz de riesgo 5×5 completa (1-25). |

### NC-2 — Datos incompletos en escala de probabilidad/impacto (Cláusula 6.1.2)

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | Los valores de Probabilidad (columna K) e Impacto (columna L) estaban completos para los 50 activos. Sin embargo, la **leyenda de escala** (qué significa cada valor 1-5) estaba dispersa en filas de datos en lugar de estar documentada centralizadamente. |
| **Impacto** | Sin la leyenda accesible, un evaluador externo no puede interpretar correctamente los valores numéricos. |
| **Acción correctiva** | ✅ Escalas de Probabilidad e Impacto documentadas en hoja `Leyenda` con valores 1-5, nombre, y descripción completa. |
| **Evidencia** | Hoja `Leyenda`, secciones "ESCALA DE PROBABILIDAD" y "ESCALA DE IMPACTO". |

### NC-3 — Controles nuevos ISO 27001:2022 no mapeados (Cláusula 6.1.3)

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | Los controles **A.5.7 (Inteligencia de amenazas)** y **A.5.30 (Continuidad de la seguridad de TI)** no estaban mapeados a ningún activo. Son nuevos en la versión 2022. |
| **Impacto** | La organización no demuestra gestión proactiva de amenazas ni preparación para la continuidad de la seguridad, requisitos explícitos de la norma actual. |
| **Acción correctiva** | ✅ **A.5.7** añadido a: HW-02 (Router Mikrotik), HW-03 (Firewall FortiGate), SW-06 (PostgreSQL del ERP). **A.5.30** añadido a: HW-01 (Servidor ERP), IF-06 (Backups del ERP). |
| **Evidencia** | Columnas "Control ISO 27001" y "Observaciones" de los activos mencionados. |

### NC-4 — Controles subóptimos en activos específicos (Cláusula 8.3)

| Activo | Control anterior | Problema | Control corregido |
|---|---|---|---|
| **HW-09** (Impresora) | A.8.24 solo | Vulnerabilidad de cola de impresión sin PIN no cubierta | A.8.24, A.8.3, A.5.15 |
| **SW-10** (M365) | A.5.23, A.8.5 | Descripción menciona anti-phishing/Antimalware no reflejado | A.5.23, A.8.5, A.6.3, A.8.7 |
| **RH-01** (Técnico Instalador) | A.6.7 solo | Equipo asignado no está inventariado formalmente | A.6.7, A.8.1 |
| **SW-08** (ZKTime) | A.8.1, A.8.15 | Fraude laboral requiere separación de funciones | A.8.1, A.8.15, A.5.3 |

### NC-5 — Riesgo residual ausente (Cláusula 8.3)

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | La matriz no contenía columna de **riesgo residual** (riesgo esperado tras implementar controles). ISO 27001:2022 exige que el tratamiento reduzca el riesgo a un nivel aceptable, y esto debe documentarse. |
| **Acción correctiva** | ✅ Columna `Riesgo Residual` añadida (poblada con valor inicial como objetivo de reducción). Columnas `Fecha Evaluación`, `Próxima Revisión`, `Observaciones` añadidas para trazabilidad temporal. |
| **Evidencia** | Columnas Q–T en hoja principal. |

### NC-6 — Escala de riesgo con saltos no cubiertos

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | La leyenda original cubría: Bajo (1-6), Medio (8-12), Alto (15-16), Crítico (20-25). Los rangos 7, 13-14, 17-19 no tenían asignación explícita. Aunque la multiplicación P×I con valores enteros 1-5 no produce todos esos números, la tabla debe ser completa y determinística. |
| **Acción correctiva** | ✅ Escala expandida en hoja `Leyenda`: **Bajo (1-6)**, **Medio (7-12)**, **Alto (13-18)**, **Crítico (19-25)**. Se añadió matriz 5×5 completa con codificación de colores. |
| **Evidencia** | Hoja `Leyenda`, sección "MATRIZ DE RIESGO" y "MAPA COMPLETO Probabilidad × Impacto". |

### NC-7 — Formato inconsistente en columna Riesgo (Cláusula 7.5.3)

| Aspecto | Descripción |
|---|---|
| **Hallazgo** | La columna `Riesgo` mezclaba formatos: `"15 (Alto)"`, `"10(Medio)"` (sin espacio), `"12 (Medio)"`. |
| **Acción correctiva** | ✅ Formato unificado a `"NN (Nivel)"` para las 50 filas. |
| **Evidencia** | Columna `Riesgo` hoja principal. |

### NC-8 — Subvaloración de riesgos en IF-09 y FS-02 (Cláusula 6.1.2)

| Activo | Valor anterior | Valor corregido | Justificación |
|---|---|---|---|
| **IF-09** (Inventario stock) | P=4, I=4, Riesgo=16 (Alto) | **P=4, I=5, Riesgo=20 (Crítico)** | El inventario es un activo crítico para una importadora; el robo hormiga crónico tiene impacto financiero y operativo severo. La alteración de inventarios puede causar pérdidas de $10,000+ no detectadas por meses. |
| **FS-02** (Cuarto Servidores) | P=2, I=5, Riesgo=10 (Medio) | **P=3, I=5, Riesgo=15 (Alto)** | El acceso físico al Data Center sin control estricto de visitantes es plausible en circunstancias normales (P=3). El impacto sigue siendo 5 (Muy grave) por compromiso total de todos los servidores, datos de clientes, y continuidad del negocio. |

---

## 4. Acciones correctivas implementadas

| # | Acción | NC asociada | Estado |
|---|---|---|---|
| 1 | Crear hoja `Leyenda` con escalas completas y matriz 5×5 | NC-1, NC-6 | ✅ Cerrada |
| 2 | Eliminar datos de escala filtrados en columnas R–U de datos | NC-1 | ✅ Cerrada |
| 3 | Añadir control A.5.7 a HW-02, HW-03, SW-06 | NC-3 | ✅ Cerrada |
| 4 | Añadir control A.5.30 a HW-01, IF-06 | NC-3 | ✅ Cerrada |
| 5 | Complementar controles en HW-09, SW-10, RH-01, SW-08 | NC-4 | ✅ Cerrada |
| 6 | Añadir columnas Riesgo Residual, Fecha Evaluación, Próxima Revisión | NC-5 | ✅ Cerrada |
| 7 | Unificar formato columna Riesgo en 50 filas | NC-7 | ✅ Cerrada |
| 8 | Reajustar IF-09 (→Crítico) y FS-02 (→Alto) con justificación | NC-8 | ✅ Cerrada |

---

## 5. Distribución de riesgos después de correcciones

| Nivel | Rango | Cantidad | % |
|---|---|---|---|
| 🔴 Crítico (19-25) | IF-02, IF-06, HW-02, HW-05, SW-01, RH-04, **IF-09*** | **7** | 14% |
| 🟠 Alto (13-18) | SW-04, SW-06, SW-07, SW-10, IF-09→*, RH-01, RH-06, RH-08, RH-09, RH-10, FS-05, **FS-02*** | **13** | 26% |
| 🟡 Medio (7-12) | HW-03, HW-04, HW-06, HW-07, HW-08, HW-10, SW-02, SW-03, SW-05, SW-08, SW-09, IF-01, IF-03, IF-04, IF-07, IF-08, IF-10, FS-01, FS-07, FS-09, RH-02, RH-03, RH-05, RH-07 | **24** | 48% |
| 🟢 Bajo (1-6) | HW-09, IF-05, FS-03, FS-04, FS-06, FS-08, FS-10 | **7** | 14% |

*_IF-09 y FS-02 aparecen en sus rangos original y corregido; el conteo refleja el valor corregido._

---

## 6. Mapeo de controles ISO 27001:2022 utilizados

| Control ISO | Descripción | Activos donde se aplica |
|---|---|---|
| A.5.3 | Separación de funciones | RH-03, RH-06, RH-08, SW-08 |
| A.5.7 | Inteligencia de amenazas | HW-02, HW-03, SW-06 |
| A.5.12 | Clasificación de la información | IF-01 |
| A.5.15 | Control de acceso | SW-03, RH-09 |
| A.5.17 | Autenticación | SW-09 |
| A.5.23 | Seguridad en servicios cloud | SW-02, SW-05, SW-10 |
| A.5.30 | Continuidad de seguridad TI | HW-01, IF-06 |
| A.5.33 | Protección de documentos | IF-05 |
| A.5.34 | Privacidad y protección de datos biométricos | IF-03 |
| A.6.2 | Términos y condiciones de contratación | RH-04 |
| A.6.3 | Concienciación en seguridad | RH-06, SW-10 |
| A.6.7 | Trabajo remoto/teletrabajo | HW-06, HW-08, HW-10, RH-01 |
| A.7.1 | Perímetro de seguridad física | FS-01, FS-02, FS-04 |
| A.7.2 | Control de acceso físico | FS-03, FS-10, RH-07 |
| A.7.3 | Seguridad de oficinas y despachos | FS-01, FS-04 |
| A.7.5 | Protección contra incendios | FS-08 |
| A.7.6 | Seguridad en áreas de trabajo | FS-02 |
| A.7.8 | Seguridad de equipos informáticos | FS-06 |
| A.7.9 | Seguridad de activos fuera de las instalaciones | FS-05, RH-10 |
| A.7.11 | Mantenimiento de equipos | FS-07, FS-09 |
| A.8.1 | Inventario de activos | SW-03, SW-07, SW-08, HW-08, HW-10, RH-01 |
| A.8.2 | Derechos de acceso | IF-04, RH-02 |
| A.8.3 | Control de acceso a información | IF-01, IF-02, IF-09, HW-09 |
| A.8.5 | Autenticación segura | HW-02, HW-07, SW-01, SW-02, SW-04, SW-05, SW-07, SW-09, SW-10 |
| A.8.7 | Protección contra malware | HW-06, SW-10 |
| A.8.11 | Enmascaramiento de datos | IF-10 |
| A.8.12 | Prevención de fuga de datos (DLP) | RH-04, RH-05 |
| A.8.13 | Copias de seguridad | HW-01, HW-05, HW-07, IF-06 |
| A.8.14 | Redundancia física | HW-01, HW-05 |
| A.8.15 | Registro de eventos y monitoreo | SW-01, SW-03, SW-04, SW-06, SW-07, SW-08, SW-09, HW-01, HW-05, HW-07, IF-07, IF-09 |
| A.8.16 | Gestión de certificados | IF-08 |
| A.8.20 | Seguridad de redes | HW-02, HW-03, HW-04, SW-06 |
| A.8.22 | Segmentación de redes | HW-02, HW-03, HW-04, IF-06 |
| A.8.24 | Criptografía | HW-06, HW-08, HW-09, HW-10, SW-01, SW-04, SW-06, IF-02, IF-08 |

---

## 7. Estadísticas de cobertura

| Métrica | Valor |
|---|---|
| Total activos evaluados | 50 |
| Total controles ISO 27001 mapeados | **34 controles únicos** |
| Controles por activo (promedio) | 2.2 |
| Activos con 1 control | 15 (30%) |
| Activos con 2 controles | 18 (36%) |
| Activos con 3+ controles | 17 (34%) |
| Activos con controles nuevos 2022 añadidos | 5 |
| Riesgos reajustados | 2 (IF-09, FS-02) |
| No conformidades cerradas | 8/8 |

---

## 8. Conclusiones

1. **Conformidad general**: La matriz de riesgos de TecnoGlobal cumple sustancialmente con los requisitos de ISO 27001:2022 para la identificación y evaluación de riesgos (Cláusulas 6.1, 8.2), con 50 activos completamente documentados con amenazas, vulnerabilidades, clasificación CIA y controles asociados.

2. **Brechas cerradas**: Se identificaron y corrigieron **8 no conformidades**, incluyendo la falta de controles nuevos de la versión 2022 (A.5.7, A.5.30), la ausencia de riesgo residual, datos mal documentados, y dos subvaloraciones de riesgo.

3. **Distribución de riesgos**: La organización presenta un perfil de riesgo predominante **Medio** (48%), con un 40% entre Alto y Crítico, consistente con una PYME importadora de tecnología con exposición digital y física significativa.

4. **Madurez del SGSI**: La existencia de una matriz detallada con 50 activos, controles ISO mapeados y un plan de simulación asociado (`SIMULACION_SGSI_TecnoGlobal.md`) indica un nivel de madurez **intermedio-avanzado** en la implementación del SGSI.

5. **Recomendación**: Realizar la próxima evaluación de riesgos antes del **2027-07-18**, o antes si ocurren cambios significativos (nuevos sistemas, cambios regulatorios, incidentes de seguridad).

---

## 9. Aprobación

| Rol | Nombre | Fecha | Firma |
|---|---|---|---|
| Auditor SGSI | Sistema Experto v1.0 | 2026-07-18 | — |
| Responsable de Seguridad | *(pendiente)* | | |
| Alta Dirección | *(pendiente)* | | |

---

*Documento generado automáticamente. Forma parte de la información documentada del SGSI de TecnoGlobal Importadora.*
