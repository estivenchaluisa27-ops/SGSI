# Reglas del Proyecto — SGSI TecnoGlobal (ISO 27001:2022)

## Contexto del Proyecto
Este es un proyecto académico para la construcción de una **Matriz de Riesgos** y un **Sistema de Gestión de Seguridad de la Información (SGSI)** para la empresa **TecnoGlobal** (Tecno Global Importadora), empresa ecuatoriana de importación y distribución de equipos de seguridad electrónica con sede en Quito.

## Reglas Generales

### Idioma
- Toda la documentación, análisis y salidas deben generarse en **español**.
- Los nombres de controles ISO 27001 deben mantenerse en su nomenclatura oficial (ej. A.5.12, A.8.24).

### Estándares de Referencia
- La norma base es **ISO/IEC 27001:2022** con su Anexo A de **93 controles** organizados en 4 categorías: Organizacionales (A.5), Personas (A.6), Físicos (A.7), Tecnológicos (A.8).
- Complementar con ISO 27002:2022 para guía de implementación de controles.
- Usar ISO 27005 como referencia para metodología de gestión de riesgos.

### Metodología de Riesgos
- Escala de **Probabilidad**: 1 (Muy baja) a 5 (Muy alta).
- Escala de **Impacto**: 1 (Insignificante) a 5 (Catastrófico).
- Fórmula: **Riesgo = Probabilidad × Impacto**.
- Clasificación: Crítico (≥20), Alto (15-19), Medio (9-14), Bajo (1-8).

### Clasificación de Activos
- Categorías válidas: Hardware (HW), Software (SW), Información (IF), Físicos (FS), Personal (RH).
- Cada activo debe tener: ID, Categoría, Nombre, Clasificación CIA, Ubicación, Proceso de Negocio, Estado, Responsable, Amenaza, Vulnerabilidad, Probabilidad, Impacto, Riesgo, Control ISO 27001, Enfoque, Descripción.

### Archivos del Proyecto
- `TecnoGlobal.md` — Descripción de la empresa y contexto de negocio.
- `Activos_SGSI(Activos SGSI).csv` — Inventario de 50 activos con análisis de riesgos (separador: punto y coma `;`).
- `ISO-27001.md` — Documento exhaustivo de referencia de la norma ISO 27001:2022.

### Responsables por Categoría
- **Sebastián**: Hardware (HW-01 a HW-10)
- **Daniela**: Software (SW-01 a SW-10)
- **Alex**: Información (IF-01 a IF-10)
- **David**: Físicos (FS-01 a FS-10)
- Varios responsables: Personal (RH-01 a RH-10)

### Formato de Salida
- Usar formato Markdown para documentos.
- Usar CSV con separador `;` para datos tabulares (mantener compatibilidad con el inventario existente).
- Incluir diagramas Mermaid cuando sea útil para visualización.
