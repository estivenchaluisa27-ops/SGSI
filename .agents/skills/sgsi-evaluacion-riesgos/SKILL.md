---
name: sgsi-evaluacion-riesgos
description: Evalúa y calcula riesgos de seguridad de la información para el SGSI. Identifica amenazas y vulnerabilidades, calcula niveles de riesgo usando la fórmula Probabilidad × Impacto (escala 1-5), genera la Matriz de Riesgos 5×5 con mapa de calor y prioriza riesgos para tratamiento.
---

# Skill: Evaluación y Cálculo de Riesgos del SGSI

## Propósito
Esta skill ejecuta el proceso completo de evaluación de riesgos de seguridad de la información conforme a las **Cláusulas 6.1.2 y 8.2** de ISO 27001:2022, utilizando la metodología de **ISO 27005** como referencia.

## Cuándo Usar Esta Skill
- Al evaluar riesgos de activos nuevos o existentes
- Para generar o actualizar la matriz de riesgos
- Cuando se necesita priorizar riesgos para tratamiento
- Para completar valores de riesgo faltantes en el inventario

## Instrucciones

### Paso 1: Cargar el Inventario de Activos
Lee el archivo `Activos_SGSI(Activos SGSI).csv` (separador: `;`). Para cada activo, extrae los campos de amenaza, vulnerabilidad, probabilidad, impacto y riesgo.

### Paso 2: Identificar Amenazas y Vulnerabilidades
Para cada activo, verifica que tenga amenaza y vulnerabilidad identificadas. Si faltan, usa la referencia en `references/matriz-riesgos-5x5.md` para catálogos de amenazas comunes.

**Catálogo de amenazas por categoría**:

| Categoría | Amenazas Típicas |
|-----------|------------------|
| **Hardware** | Fallo de hardware, robo físico, obsolescencia, sabotaje, desastres naturales |
| **Software** | Vulnerabilidades (CVE), malware, acceso no autorizado, errores de configuración, inyección SQL |
| **Información** | Fuga de datos, alteración, ransomware, pérdida, acceso no autorizado, espionaje |
| **Físicos** | Intrusión, vandalismo, incendio, inundación, fallo eléctrico, robo |
| **Personal** | Ingeniería social, fraude interno, negligencia, rotación de personal, sabotaje |

### Paso 3: Calcular Riesgo
Aplicar la fórmula para cada activo:

```
Riesgo = Probabilidad × Impacto
```

**Escala de Probabilidad** (1-5):
| Nivel | Valor | Descripción | Frecuencia Estimada |
|-------|-------|-------------|---------------------|
| Muy baja | 1 | Evento excepcional | < 1 vez cada 5 años |
| Baja | 2 | Evento raro | 1 vez cada 2-5 años |
| Media | 3 | Evento posible | ~1 vez al año |
| Alta | 4 | Evento probable | Varias veces al año |
| Muy alta | 5 | Evento frecuente | Mensual o más |

**Escala de Impacto** (1-5):
| Nivel | Valor | Operacional | Financiero | Reputacional |
|-------|-------|-------------|------------|--------------|
| Insignificante | 1 | Sin efecto | < $500 | Ninguno |
| Menor | 2 | Molestia temporal | $500 - $5,000 | Interno |
| Moderado | 3 | Interrupción parcial (horas) | $5,000 - $25,000 | Clientes directos |
| Mayor | 4 | Interrupción significativa (días) | $25,000 - $100,000 | Público regional |
| Catastrófico | 5 | Paralización total | > $100,000 | Medios/Nacional |

### Paso 4: Clasificar Riesgo
Clasificar cada riesgo calculado según:

| Rango | Nivel | Color | Acción Requerida |
|-------|-------|-------|-----------------|
| **20-25** | 🔴 Crítico | Rojo | Acción inmediata. Escalar a dirección. Plazo: < 1 mes |
| **15-19** | 🟠 Alto | Naranja | Plan de tratamiento prioritario. Plazo: < 3 meses |
| **9-14** | 🟡 Medio | Amarillo | Plan de tratamiento planificado. Plazo: < 6 meses |
| **1-8** | 🟢 Bajo | Verde | Monitorear. Aceptar si el costo de mitigación supera el impacto |

### Paso 5: Generar Matriz de Riesgos 5×5
Producir la matriz de calor con los IDs de activos posicionados:

```markdown
## Matriz de Riesgos 5×5 — Mapa de Calor

|  | **Impacto 1** | **Impacto 2** | **Impacto 3** | **Impacto 4** | **Impacto 5** |
|--|--------------|--------------|--------------|--------------|--------------|
| **Prob. 5** | 5 🟢 | 10 🟡 | 15 🟠 | 20 🔴 | 25 🔴 |
| **Prob. 4** | 4 🟢 | 8 🟢 | 12 🟡 | 16 🟠 | 20 🔴 |
| **Prob. 3** | 3 🟢 | 6 🟢 | 9 🟡 | 12 🟡 | 15 🟠 |
| **Prob. 2** | 2 🟢 | 4 🟢 | 6 🟢 | 8 🟢 | 10 🟡 |
| **Prob. 1** | 1 🟢 | 2 🟢 | 3 🟢 | 4 🟢 | 5 🟢 |
```

Dentro de cada celda, listar los IDs de activos que caen en esa posición.

### Paso 6: Ranking de Riesgos Priorizados
Generar tabla ordenada de mayor a menor riesgo:

```markdown
## Top Riesgos — Prioridad de Tratamiento

| # | ID | Activo | Riesgo | Nivel | Amenaza Principal |
|---|-----|--------|--------|-------|-------------------|
| 1 | XX-XX | [nombre] | 20 | 🔴 Crítico | [amenaza] |
| 2 | XX-XX | [nombre] | 20 | 🔴 Crítico | [amenaza] |
| ... | ... | ... | ... | ... | ... |
```

### Paso 7: Análisis Estadístico
Producir resumen con:
- Distribución de riesgos por nivel (Crítico/Alto/Medio/Bajo)
- Distribución por categoría de activo
- Riesgo promedio por categoría
- Top 3 amenazas más frecuentes
- Top 3 vulnerabilidades más comunes

### Formato de Salida
Generar un documento Markdown con:
```
# Evaluación de Riesgos — [Nombre de la Empresa]
## 1. Metodología Aplicada
## 2. Matriz de Riesgos 5×5 (Mapa de Calor)
## 3. Ranking de Riesgos Priorizados
## 4. Análisis por Categoría de Activo
## 5. Análisis Estadístico
## 6. Conclusiones y Recomendaciones
```

### Consideraciones Especiales para TecnoGlobal
- Prestar atención especial a los activos que manejan **credenciales de clientes** (IF-02: BD de IPs y contraseñas de cámaras) — este es probablemente el activo más crítico de toda la empresa
- Los **activos de Software (SW-01 a SW-10)** tienen campos de riesgo vacíos que deben calcularse
- Considerar que TecnoGlobal es una **PYME ecuatoriana** — calibrar impacto financiero acorde a su escala
- Los **técnicos de campo (RH-01)** representan un vector de ataque significativo por el uso de redes inseguras
