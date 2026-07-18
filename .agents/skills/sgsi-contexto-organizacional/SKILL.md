---
name: sgsi-contexto-organizacional
description: Analiza el contexto interno y externo de una organización para establecer las bases de un SGSI según ISO 27001:2022. Genera análisis PESTEL, FODA, mapeo de partes interesadas y definición de alcance del SGSI.
---

# Skill: Análisis de Contexto Organizacional para SGSI

## Propósito
Esta skill analiza el entorno interno y externo de la organización para establecer un SGSI alineado con sus necesidades, objetivos y marco regulatorio. Cubre los requisitos de las **Cláusulas 4.1, 4.2 y 4.3** de ISO 27001:2022.

## Cuándo Usar Esta Skill
- Al iniciar un proyecto SGSI desde cero
- Cuando se necesita documentar el contexto de la organización
- Para identificar partes interesadas y sus requisitos
- Para definir o revisar el alcance del SGSI

## Instrucciones

### Paso 1: Recopilar Información de la Organización
Lee los archivos del proyecto para entender el contexto de la empresa:
- `TecnoGlobal.md` — Información general de la empresa
- `Activos_SGSI(Activos SGSI).csv` — Inventario de activos existente

Identifica:
- **Sector**: Tipo de industria y actividad principal
- **Ubicaciones**: Sedes físicas y áreas de operación
- **Modelo de negocio**: Canales de venta, clientes, proveedores
- **Infraestructura tecnológica**: A partir del inventario de activos

### Paso 2: Análisis PESTEL
Genera un análisis de factores externos usando esta estructura:

| Factor | Descripción | Impacto en Seguridad de la Información |
|--------|-------------|---------------------------------------|
| **Político** | Estabilidad política, regulaciones gubernamentales del país | Cómo afecta la protección de datos |
| **Económico** | Situación económica, presupuesto disponible | Recursos para seguridad |
| **Social** | Cultura organizacional, nivel de conciencia en seguridad | Adopción de políticas |
| **Tecnológico** | Tecnologías usadas, nivel de madurez digital | Superficie de ataque |
| **Ecológico** | Riesgos ambientales de la zona (sismos, inundaciones) | Continuidad del negocio |
| **Legal** | Leyes aplicables (Ley de Protección de Datos de Ecuador, LOPDP) | Cumplimiento obligatorio |

### Paso 3: Análisis FODA de Seguridad de la Información
Genera una matriz FODA enfocada exclusivamente en seguridad de la información:

- **Fortalezas**: Capacidades internas positivas (ej. equipo técnico capacitado, firewall empresarial)
- **Oportunidades**: Factores externos favorables (ej. alianzas con fabricantes de seguridad)
- **Debilidades**: Limitaciones internas (ej. falta de políticas formales, activos sin cifrar)
- **Amenazas**: Factores externos negativos (ej. ciberataques dirigidos, regulaciones cambiantes)

Basa las debilidades en las vulnerabilidades reales encontradas en el inventario de activos (`Activos_SGSI(Activos SGSI).csv`).

### Paso 4: Mapeo de Partes Interesadas
Identifica todas las partes interesadas y clasifícalas:

| Parte Interesada | Tipo | Requisitos de Seguridad | Nivel de Influencia | Nivel de Interés |
|-------------------|------|------------------------|---------------------|-----------------|
| Clientes corporativos | Externa | Confidencialidad de planos e IPs de cámaras | Alto | Alto |
| Distribuidores | Externa | Disponibilidad de sistemas de pedidos | Medio | Alto |
| Empleados | Interna | Protección de datos personales | Medio | Medio |
| Reguladores (ARCOM, SRI) | Externa | Cumplimiento legal | Alto | Medio |
| Proveedores chinos | Externa | Confidencialidad contractual | Medio | Bajo |

### Paso 5: Definición del Alcance del SGSI
Genera el documento de alcance con:

1. **Áreas incluidas**: Listar todas las sedes, departamentos y procesos cubiertos
2. **Áreas excluidas**: Con justificación documentada para cada exclusión
3. **Límites del SGSI**: Límites físicos (sedes), lógicos (redes/VLANs) y organizacionales (departamentos)
4. **Interfaces**: Puntos de contacto con entidades externas (proveedores, clientes, reguladores)

### Formato de Salida
Genera un documento Markdown con las siguientes secciones:
```
# Contexto Organizacional — [Nombre de la Empresa]
## 1. Descripción General de la Organización
## 2. Análisis PESTEL
## 3. Análisis FODA de Seguridad de la Información
## 4. Partes Interesadas y sus Requisitos
## 5. Alcance del SGSI
### 5.1 Áreas Incluidas
### 5.2 Áreas Excluidas (con justificación)
### 5.3 Límites del SGSI
## 6. Aprobación
```

### Consideraciones Especiales para TecnoGlobal
- La empresa opera en el sector de **seguridad electrónica** en Ecuador — esto implica que maneja información extremadamente sensible de sus clientes (IPs de cámaras, planos de seguridad, credenciales de acceso)
- Tiene **dos sedes** (Quito matriz y Guayaquil sucursal) — evaluar si ambas entran en el alcance
- Su **modelo de distribuidores** implica que terceros acceden a recursos técnicos de la empresa
- Los **técnicos de campo** trabajan de forma remota con VPN — considerar trabajo remoto en el alcance
- Aplicar la **Ley Orgánica de Protección de Datos Personales (LOPDP)** de Ecuador como marco legal principal
