---
name: sgsi-plan-tratamiento
description: Define controles y estrategias de tratamiento para cada riesgo identificado en el SGSI. Selecciona controles del Anexo A de ISO 27001:2022, genera la Declaración de Aplicabilidad (SoA), calcula riesgo residual y produce un cronograma de implementación priorizado.
---

# Skill: Plan de Tratamiento de Riesgos del SGSI

## Propósito
Esta skill genera el plan de tratamiento de riesgos conforme a las **Cláusulas 6.1.3 y 8.3** de ISO 27001:2022. Selecciona controles del **Anexo A** y produce la **Declaración de Aplicabilidad (SoA)**.

## Cuándo Usar Esta Skill
- Después de completar la evaluación de riesgos
- Para generar o actualizar la Declaración de Aplicabilidad (SoA)
- Cuando se necesita definir controles específicos para un riesgo nuevo
- Para estimar riesgo residual post-tratamiento

## Instrucciones

### Paso 1: Cargar Resultados de Evaluación de Riesgos
Leer la matriz de riesgos y el inventario de activos con sus riesgos calculados.

### Paso 2: Seleccionar Estrategia de Tratamiento
Para cada riesgo, seleccionar una de las 4 estrategias:

| Estrategia | Cuándo Aplicar | Ejemplo TecnoGlobal |
|-----------|----------------|---------------------|
| **Mitigar** | El riesgo puede reducirse con controles razonables | Implementar MFA en el ERP Odoo (SW-01) |
| **Transferir** | El riesgo puede pasarse a un tercero (seguro, outsourcing) | Contratar ciberseguro para riesgos de ransomware |
| **Aceptar** | El costo de mitigar supera el impacto potencial | Aceptar riesgo de robo de impresora (HW-09, Riesgo=6) |
| **Evitar** | Eliminar la actividad que genera el riesgo | Dejar de almacenar contraseñas de clientes en texto plano |

**Reglas de decisión**:
- Riesgo **Crítico (≥20)**: NUNCA aceptar. Mitigar o evitar obligatoriamente
- Riesgo **Alto (15-19)**: Mitigar es la opción preferida. Transferir si es viable
- Riesgo **Medio (9-14)**: Mitigar o transferir. Aceptar solo con justificación documentada
- Riesgo **Bajo (1-8)**: Aceptar es válido con aprobación del responsable

### Paso 3: Mapear Controles del Anexo A
Para cada riesgo a mitigar, seleccionar controles del Anexo A de ISO 27001:2022. Consultar la referencia en `references/controles-anexo-a.md`.

Para cada control seleccionado, documentar:
1. **ID del control** (ej. A.8.5)
2. **Nombre del control**
3. **Justificación** de por qué se selecciona
4. **Descripción de implementación** específica para TecnoGlobal
5. **Responsable** de la implementación
6. **Plazo estimado**
7. **Costo estimado** (si aplica)

### Paso 4: Calcular Riesgo Residual
Después de aplicar controles, estimar el riesgo residual:

```
Riesgo Residual = Probabilidad Residual × Impacto Residual
```

**Regla**: El riesgo residual debe ser ≤ nivel de riesgo aceptable de la organización (generalmente ≤ 8 para TecnoGlobal como PYME).

Si el riesgo residual sigue siendo inaceptable, proponer controles adicionales o escalar a dirección.

### Paso 5: Generar Declaración de Aplicabilidad (SoA)
Producir la SoA completa con los 93 controles del Anexo A:

```markdown
## Declaración de Aplicabilidad (SoA)

| # | Control ISO 27001 | Nombre | Aplicable | Justificación | Estado | Activos Relacionados |
|---|-------------------|--------|-----------|---------------|--------|---------------------|
| 1 | A.5.1 | Políticas de seguridad de la información | ✅ Sí | Requisito base del SGSI | Pendiente | Todos |
| 2 | A.5.2 | Roles y responsabilidades | ✅ Sí | Necesario para gobernanza | Parcial | RH-01 a RH-10 |
| ... | ... | ... | ... | ... | ... | ... |
| 93 | A.8.34 | Protección de sistemas de información durante auditoría | ❌ No | No se realizan auditorías de sistemas en producción | N/A | N/A |
```

**Estados válidos**: Implementado, Parcial, Pendiente, N/A

### Paso 6: Generar Cronograma de Implementación
Ordenar las acciones por prioridad:

```markdown
## Cronograma de Implementación

### Fase 1 — Acciones Inmediatas (Mes 1-2)
Riesgos Críticos (≥20)

| Prioridad | Activo | Riesgo | Acción | Responsable | Plazo |
|-----------|--------|--------|--------|-------------|-------|
| 1 | HW-02 | 20 | Restringir Winbox/SSH, habilitar MFA | Sebastián | Semana 1-2 |
| 2 | HW-05 | 20 | Mover NAS a VLAN aislada, snapshots inmutables | Sebastián | Semana 2-3 |
| ... | ... | ... | ... | ... | ... |

### Fase 2 — Acciones Prioritarias (Mes 3-4)
Riesgos Altos (15-19)

### Fase 3 — Acciones Planificadas (Mes 5-8)
Riesgos Medios (9-14)

### Fase 4 — Monitoreo Continuo (Mes 9+)
Riesgos Bajos (1-8)
```

### Formato de Salida
```
# Plan de Tratamiento de Riesgos — [Nombre de la Empresa]
## 1. Metodología de Tratamiento
## 2. Decisiones de Tratamiento por Activo
## 3. Controles Seleccionados del Anexo A
## 4. Riesgo Residual Post-Tratamiento
## 5. Declaración de Aplicabilidad (SoA)
## 6. Cronograma de Implementación
## 7. Presupuesto Estimado
## 8. Aprobación
```
