---
name: sgsi-documentacion
description: Genera toda la documentación obligatoria y recomendada para un SGSI basado en ISO 27001:2022. Incluye política de seguridad, alcance, procedimientos operativos, registros de evidencia y plantillas adaptadas al contexto de la organización. Produce documentos listos para revisión y aprobación.
---

# Skill: Generación de Documentación del SGSI

## Propósito
Esta skill produce el paquete completo de documentación requerido por ISO 27001:2022 para establecer, implementar y mantener un SGSI. Cubre los requisitos de la **Cláusula 7.5 (Información documentada)** y todas las cláusulas 4-10 que exigen documentación.

## Cuándo Usar Esta Skill
- Al establecer un SGSI nuevo y necesitar toda la documentación base
- Para generar documentos individuales (política, procedimientos, registros)
- Cuando se necesita actualizar documentación existente
- Para preparar documentación para una auditoría

## Instrucciones

### Documentación Obligatoria según ISO 27001:2022
Los siguientes documentos son **obligatorios** para certificación:

| # | Documento | Cláusula ISO | Prioridad |
|---|-----------|-------------|-----------|
| 1 | Alcance del SGSI | 4.3 | 🔴 Alta |
| 2 | Política de Seguridad de la Información | 5.2 | 🔴 Alta |
| 3 | Proceso de evaluación de riesgos | 6.1.2 | 🔴 Alta |
| 4 | Proceso de tratamiento de riesgos | 6.1.3 | 🔴 Alta |
| 5 | Declaración de Aplicabilidad (SoA) | 6.1.3 d) | 🔴 Alta |
| 6 | Objetivos de seguridad de la información | 6.2 | 🟠 Media |
| 7 | Evidencia de competencia | 7.2 | 🟡 Media |
| 8 | Información documentada (control de docs) | 7.5 | 🟠 Media |
| 9 | Planificación y control operacional | 8.1 | 🟠 Media |
| 10 | Resultados de la evaluación de riesgos | 8.2 | 🔴 Alta |
| 11 | Resultados del tratamiento de riesgos | 8.3 | 🔴 Alta |
| 12 | Evidencia de monitoreo y medición | 9.1 | 🟡 Media |
| 13 | Programa de auditoría interna | 9.2 | 🟠 Media |
| 14 | Resultados de auditorías internas | 9.2 | 🟠 Media |
| 15 | Resultados de la revisión por la dirección | 9.3 | 🟠 Media |
| 16 | No conformidades y acciones correctivas | 10.1 | 🟡 Media |

### Paso 1: Generar Política de Seguridad de la Información
Crear la política adaptada al contexto de la empresa. Debe incluir:

```markdown
# Política de Seguridad de la Información
## [Nombre de la Empresa]

### 1. Propósito
### 2. Alcance
### 3. Objetivos de Seguridad
   - Objetivos medibles con KPIs
### 4. Principios de Seguridad
   - Confidencialidad, Integridad, Disponibilidad
### 5. Roles y Responsabilidades
   - Alta dirección, CISO/Responsable de seguridad, Comité, Empleados
### 6. Marco Normativo y Legal
   - ISO 27001:2022, LOPDP Ecuador, regulaciones sectoriales
### 7. Gestión de Riesgos
   - Referencia a la metodología y proceso
### 8. Cumplimiento
   - Consecuencias del incumplimiento
### 9. Revisión y Mejora
   - Frecuencia de revisión (anual mínimo)
### 10. Aprobación
   - Firma de la alta dirección, fecha, versión
```

### Paso 2: Generar Procedimientos Operativos
Crear procedimientos para los procesos críticos del SGSI:

**Procedimientos obligatorios**:
1. **Gestión de Incidentes de Seguridad** (A.5.24-A.5.28)
   - Detección, clasificación, respuesta, notificación, lecciones aprendidas
2. **Control de Acceso** (A.5.15-A.5.18)
   - Alta/baja de usuarios, revisión periódica, privilegios
3. **Gestión de Backups** (A.8.13)
   - Política 3-2-1, frecuencia, verificación, restauración
4. **Gestión de Cambios** (A.8.32)
   - Solicitud, evaluación, aprobación, implementación, rollback
5. **Gestión de Proveedores** (A.5.19-A.5.22)
   - Evaluación, requisitos contractuales, monitoreo

**Formato de cada procedimiento**:
```markdown
# Procedimiento: [Nombre]
## Código: PR-SGSI-[NNN]
## Versión: [X.X]

### 1. Objetivo
### 2. Alcance
### 3. Definiciones
### 4. Responsabilidades
### 5. Descripción del Procedimiento
   5.1 [Paso 1]
   5.2 [Paso 2]
   ...
### 6. Registros Generados
### 7. Documentos de Referencia
### 8. Control de Cambios
| Versión | Fecha | Autor | Descripción del Cambio |
```

### Paso 3: Generar Registros y Plantillas
Crear plantillas para registros operativos:

1. **Registro de incidentes de seguridad**
2. **Registro de acceso a áreas seguras**
3. **Acta de revisión por la dirección**
4. **Checklist de auditoría interna**
5. **Registro de capacitaciones en seguridad**
6. **Registro de cambios aprobados**
7. **Formato de evaluación de riesgos**

### Paso 4: Control de Documentos
Todos los documentos deben incluir:
- **Código de documento**: Formato `DOC-SGSI-[CAT]-[NNN]` (ej. DOC-SGSI-POL-001)
- **Versión**: Formato X.Y (mayor.menor)
- **Fecha de emisión**
- **Autor/Elaborado por**
- **Revisado por**
- **Aprobado por**
- **Estado**: Borrador, En revisión, Aprobado, Obsoleto
- **Clasificación**: Público, Interno, Confidencial, Restringido

### Formato de Salida
Generar cada documento como archivo Markdown independiente con la estructura anterior. Organizar en carpetas:
```
documentacion-sgsi/
├── politicas/
│   └── POL-001-Politica-Seguridad-Informacion.md
├── procedimientos/
│   ├── PR-001-Gestion-Incidentes.md
│   ├── PR-002-Control-Acceso.md
│   ├── PR-003-Gestion-Backups.md
│   ├── PR-004-Gestion-Cambios.md
│   └── PR-005-Gestion-Proveedores.md
├── registros/
│   ├── plantillas/
│   └── evidencias/
└── SoA/
    └── Declaracion-Aplicabilidad.md
```

### Consideraciones para TecnoGlobal
- Adaptar la política al **sector de seguridad electrónica** y la **legislación ecuatoriana** (LOPDP, Código Orgánico Integral Penal para delitos informáticos)
- Los procedimientos deben considerar las **dos sedes** (Quito y Guayaquil)
- Incluir procedimientos específicos para **técnicos de campo** que acceden remotamente
- Considerar el **modelo de distribuidores** en el procedimiento de gestión de proveedores
- Usar el equipo existente como responsables: Sebastián (HW/TI), Daniela (SW), Alex (Información), David (Físicos)
