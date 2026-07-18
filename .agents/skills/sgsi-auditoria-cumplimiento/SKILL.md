---
name: sgsi-auditoria-cumplimiento
description: Ejecuta auditorías internas y evalúa el nivel de cumplimiento del SGSI contra ISO 27001:2022. Genera checklists cláusula por cláusula, verifica cobertura del Anexo A, identifica no conformidades, calcula nivel de madurez CMMI y produce informes de auditoría con plan de acciones correctivas.
---

# Skill: Auditoría y Verificación de Cumplimiento del SGSI

## Propósito
Esta skill ejecuta el proceso de auditoría interna del SGSI conforme a la **Cláusula 9.2** de ISO 27001:2022, evalúa el cumplimiento con los requisitos de la norma y genera planes de acción correctiva según la **Cláusula 10.1**.

## Cuándo Usar Esta Skill
- Para ejecutar una auditoría interna planificada del SGSI
- Para evaluar el nivel de cumplimiento antes de una auditoría de certificación
- Para realizar un gap analysis inicial
- Para verificar la implementación de acciones correctivas

## Instrucciones

### Paso 1: Preparar la Auditoría
Definir el alcance y criterios de la auditoría:

```markdown
## Plan de Auditoría Interna

**Auditoría #**: [NNN]
**Tipo**: [Completa / Parcial / Seguimiento]
**Fecha**: [DD/MM/AAAA]
**Auditor**: [Nombre]
**Alcance**: [Cláusulas y controles a auditar]
**Criterios**: ISO/IEC 27001:2022, políticas internas, requisitos legales
```

### Paso 2: Checklist de Cumplimiento — Cláusulas 4 a 10
Evaluar cada cláusula con el siguiente formato:

| Cláusula | Requisito | Evidencia Esperada | Estado | Hallazgo |
|----------|-----------|-------------------|--------|----------|
| 4.1 | Comprensión del contexto | Documento de análisis PESTEL/FODA | ✅/⚠️/❌ | [Detalle] |
| 4.2 | Partes interesadas | Matriz de partes interesadas | ✅/⚠️/❌ | [Detalle] |
| 4.3 | Alcance del SGSI | Documento de alcance aprobado | ✅/⚠️/❌ | [Detalle] |
| 4.4 | SGSI | Documentación del sistema | ✅/⚠️/❌ | [Detalle] |
| 5.1 | Liderazgo y compromiso | Actas de reunión, asignación de recursos | ✅/⚠️/❌ | [Detalle] |
| 5.2 | Política de seguridad | Política aprobada y comunicada | ✅/⚠️/❌ | [Detalle] |
| 5.3 | Roles y responsabilidades | Organigrama de seguridad | ✅/⚠️/❌ | [Detalle] |
| 6.1 | Acciones para abordar riesgos | Metodología de evaluación de riesgos | ✅/⚠️/❌ | [Detalle] |
| 6.2 | Objetivos de seguridad | Objetivos medibles documentados | ✅/⚠️/❌ | [Detalle] |
| 6.3 | Planificación de cambios | Procedimiento de gestión de cambios | ✅/⚠️/❌ | [Detalle] |
| 7.1 | Recursos | Evidencia de asignación de recursos | ✅/⚠️/❌ | [Detalle] |
| 7.2 | Competencia | Registros de capacitación | ✅/⚠️/❌ | [Detalle] |
| 7.3 | Concienciación | Programa de concienciación | ✅/⚠️/❌ | [Detalle] |
| 7.4 | Comunicación | Plan de comunicación | ✅/⚠️/❌ | [Detalle] |
| 7.5 | Información documentada | Control de documentos | ✅/⚠️/❌ | [Detalle] |
| 8.1 | Planificación operacional | Planes y controles operacionales | ✅/⚠️/❌ | [Detalle] |
| 8.2 | Evaluación de riesgos | Resultados de evaluación | ✅/⚠️/❌ | [Detalle] |
| 8.3 | Tratamiento de riesgos | Plan de tratamiento, SoA | ✅/⚠️/❌ | [Detalle] |
| 9.1 | Monitoreo y medición | Métricas y dashboards | ✅/⚠️/❌ | [Detalle] |
| 9.2 | Auditoría interna | Programa y resultados de auditoría | ✅/⚠️/❌ | [Detalle] |
| 9.3 | Revisión por la dirección | Actas de revisión gerencial | ✅/⚠️/❌ | [Detalle] |
| 10.1 | No conformidad y acción correctiva | Registros de NC y acciones | ✅/⚠️/❌ | [Detalle] |
| 10.2 | Mejora continua | Evidencia de mejora | ✅/⚠️/❌ | [Detalle] |

**Leyenda de estados**:
- ✅ **Conforme**: Cumple completamente con el requisito
- ⚠️ **No conformidad menor**: Cumple parcialmente, requiere mejora
- ❌ **No conformidad mayor**: No cumple, requiere acción correctiva inmediata

### Paso 3: Verificación del Anexo A
Para cada control del Anexo A presente en la SoA, verificar:

| Control | Nombre | Aplicable | Implementado | Efectivo | Evidencia | Hallazgo |
|---------|--------|-----------|-------------|----------|-----------|----------|
| A.5.1 | Políticas de SI | ✅ | ✅/⚠️/❌ | ✅/❌ | [Tipo] | [Detalle] |

### Paso 4: Clasificar No Conformidades
Para cada hallazgo negativo, clasificar:

```markdown
## No Conformidad NC-[NNN]

**Tipo**: [Mayor / Menor / Observación / Oportunidad de Mejora]
**Cláusula/Control**: [Ej. 5.2 / A.8.5]
**Descripción**: [Qué se encontró]
**Evidencia**: [Cómo se detectó]
**Requisito incumplido**: [Texto del requisito de la norma]
**Riesgo asociado**: [Impacto de no corregir]
**Acción correctiva propuesta**: [Qué hacer]
**Responsable**: [Nombre]
**Plazo**: [Fecha límite]
**Estado**: [Abierta / En proceso / Cerrada / Verificada]
```

**Criterios de clasificación**:
| Tipo | Criterio |
|------|----------|
| **NC Mayor** | Ausencia total de un requisito de la norma, o fallo sistémico que compromete la eficacia del SGSI |
| **NC Menor** | Cumplimiento parcial, desviación puntual que no compromete la eficacia global |
| **Observación** | Área de mejora identificada, no es un incumplimiento formal |
| **Oportunidad de Mejora** | Sugerencia para optimizar un proceso que ya cumple |

### Paso 5: Calcular Nivel de Madurez
Evaluar la madurez del SGSI usando escala CMMI adaptada:

| Nivel | Nombre | Descripción | Score |
|-------|--------|-------------|-------|
| 1 | **Inicial** | Procesos inexistentes o ad hoc, sin documentación | 0-20% |
| 2 | **Repetible** | Procesos básicos documentados pero inconsistentes | 21-40% |
| 3 | **Definido** | Procesos estandarizados, documentados y comunicados | 41-60% |
| 4 | **Gestionado** | Procesos medidos y monitoreados con métricas | 61-80% |
| 5 | **Optimizado** | Mejora continua basada en datos, benchmarking | 81-100% |

Calcular el nivel para cada dominio:
- Gobernanza y Liderazgo (Cláusulas 4-5)
- Gestión de Riesgos (Cláusula 6, 8)
- Operación y Controles (Anexo A)
- Monitoreo y Mejora (Cláusulas 9-10)

### Paso 6: Generar Informe de Auditoría

```markdown
# Informe de Auditoría Interna del SGSI
## [Nombre de la Empresa]

### 1. Datos de la Auditoría
### 2. Resumen Ejecutivo
### 3. Resultados por Cláusula
### 4. Resultados del Anexo A
### 5. No Conformidades Identificadas
   5.1 No Conformidades Mayores
   5.2 No Conformidades Menores
   5.3 Observaciones
   5.4 Oportunidades de Mejora
### 6. Nivel de Madurez del SGSI
### 7. Gap Analysis (Brecha vs. Objetivo)
### 8. Plan de Acciones Correctivas
### 9. Conclusiones
### 10. Próximos Pasos
### 11. Firma del Auditor
```

### Consideraciones para TecnoGlobal
- Al ser un **proyecto académico inicial**, el nivel de madurez esperado es 1-2 (Inicial a Repetible)
- Enfocarse en identificar las **brechas más críticas** primero (activos con riesgo ≥20)
- Verificar especialmente los controles relacionados con los **5 riesgos críticos** identificados en el inventario
- Considerar que la empresa **no tiene un SGSI previo** — el gap analysis mostrará muchos controles pendientes
