---
name: sgsi-inventario-activos
description: Gestiona el inventario de activos de información del SGSI. Crea, clasifica, valida y mantiene actualizado el catálogo de activos con su clasificación CIA, ubicación lógica, proceso de negocio y responsable asignado. Detecta campos incompletos y sugiere correcciones.
---

# Skill: Gestión de Inventario de Activos del SGSI

## Propósito
Esta skill gestiona el ciclo de vida completo del inventario de activos de información, desde la identificación inicial hasta la validación de completitud. Cubre los requisitos de **A.5.9 (Inventario de activos)** y **Cláusula 8.1** de ISO 27001:2022.

## Cuándo Usar Esta Skill
- Al crear un inventario de activos desde cero
- Para validar y completar un inventario existente
- Cuando se necesita clasificar activos por CIA (Confidencialidad, Integridad, Disponibilidad)
- Para detectar activos faltantes o con campos incompletos

## Instrucciones

### Paso 1: Leer el Inventario Existente
Lee el archivo `Activos_SGSI(Activos SGSI).csv` (separador: `;`). 

**Campos del inventario**:
| Campo | Descripción | Obligatorio |
|-------|-------------|-------------|
| ID | Identificador único (formato: XX-NN, ej. HW-01) | ✅ |
| Categoría | Hardware, Software, Información, Físicos, Personal | ✅ |
| Nombre del Activo Específico | Nombre descriptivo incluyendo marca/modelo | ✅ |
| Clasificación_CIA | Nivel de C-I-D (Alta/Media/Baja para cada dimensión) | ✅ |
| Ubicación_Lógica | VLAN, segmento de red o ubicación física | ✅ |
| Proceso_Negocio | Proceso al que contribuye el activo | ✅ |
| Estado_Ciclo_Vida | Activo, En mantenimiento, Obsoleto, En adquisición | ✅ |
| Responsable | Persona responsable del activo | ✅ |
| Amenaza | Amenaza principal identificada | ✅ |
| Vulnerabilidad | Vulnerabilidad principal asociada | ✅ |
| Probabilidad de Ocurrencia | Escala 1-5 | ✅ |
| Impacto | Escala 1-5 | ✅ |
| Riesgo | Probabilidad × Impacto | ✅ |
| Control ISO 27001 | Control(es) del Anexo A aplicable(s) | ✅ |
| Enfoque | Mitigar, Transferir, Aceptar, Evitar | ✅ |
| Descripción | Descripción del control/medida propuesta | ✅ |

### Paso 2: Validar Completitud
Para cada activo, verificar que **TODOS los 16 campos** estén completos. Reportar:

```markdown
## Reporte de Validación del Inventario

### Activos Completos: XX/50
### Activos Incompletos: XX/50

| ID | Campos Faltantes |
|----|-----------------|
| SW-01 | Probabilidad, Impacto, Riesgo, Ubicación_Lógica, Estado_Ciclo_Vida |
| ... | ... |
```

### Paso 3: Completar Campos Faltantes
Para activos con campos vacíos, usa las siguientes reglas:

**Probabilidad de Ocurrencia** (1-5):
| Valor | Criterio |
|-------|----------|
| 1 | Muy improbable — Evento raro, sin precedentes en la industria |
| 2 | Poco probable — Podría ocurrir una vez cada 2-5 años |
| 3 | Posible — Podría ocurrir una vez al año |
| 4 | Probable — Podría ocurrir varias veces al año |
| 5 | Muy probable — Ocurre frecuentemente (mensual o más) |

**Impacto** (1-5):
| Valor | Criterio |
|-------|----------|
| 1 | Insignificante — Sin efecto notable en la operación |
| 2 | Menor — Molestia operativa, se resuelve rápidamente |
| 3 | Moderado — Interrupción parcial, pérdida financiera moderada |
| 4 | Mayor — Interrupción significativa, pérdida financiera importante, daño reputacional |
| 5 | Catastrófico — Paralización total, pérdida de clientes clave, sanciones legales |

**Clasificación CIA**: Evalúa cada dimensión (Alta/Media/Baja) considerando:
- **Confidencialidad**: ¿Qué pasa si la información se divulga sin autorización?
- **Integridad**: ¿Qué pasa si la información se altera sin autorización?
- **Disponibilidad**: ¿Qué pasa si el activo deja de estar disponible?

### Paso 4: Identificar Activos Faltantes
Analiza la descripción de la empresa en `TecnoGlobal.md` y sugiere activos que podrían faltar:

Categorías a considerar:
- **Hardware**: ¿Faltan estaciones de trabajo, puntos de acceso WiFi, equipos de la sucursal Guayaquil?
- **Software**: ¿Faltan antivirus/EDR, herramientas de monitoreo, plataforma e-commerce?
- **Información**: ¿Faltan políticas documentadas, manuales, propiedad intelectual?
- **Físicos**: ¿Faltan activos de la sucursal Guayaquil?
- **Personal**: ¿Faltan roles como RRHH, Marketing, Legal?

### Paso 5: Generar Resumen Estadístico

```markdown
## Resumen del Inventario

### Por Categoría
| Categoría | Cantidad | % del Total |
|-----------|----------|-------------|
| Hardware  | XX       | XX%         |
| Software  | XX       | XX%         |
| ...       | ...      | ...         |

### Por Nivel de Riesgo
| Nivel     | Cantidad | Activos |
|-----------|----------|---------|
| Crítico   | XX       | ID-XX, ID-XX |
| Alto      | XX       | ID-XX, ID-XX |
| Medio     | XX       | ID-XX, ID-XX |
| Bajo      | XX       | ID-XX, ID-XX |

### Por Responsable
| Responsable | Activos Asignados | Riesgo Promedio |
|-------------|-------------------|-----------------|
| Sebastián   | HW-01 a HW-10    | XX              |
| ...         | ...               | ...             |
```

### Formato de Salida
- **Inventario actualizado**: CSV con separador `;` manteniendo el formato original
- **Reporte de validación**: Markdown con hallazgos y recomendaciones
- **Resumen estadístico**: Markdown con tablas y métricas

### Convenciones de Nomenclatura
- **IDs**: Prefijo de categoría + número secuencial de 2 dígitos (ej. HW-11, SW-11)
- **Nombres**: Incluir marca, modelo y función principal entre paréntesis
- **VLANs**: Usar formato VLAN-XX-NOMBRE (ej. VLAN-10-SERVIDORES)
