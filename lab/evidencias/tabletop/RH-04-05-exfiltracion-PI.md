# Tabletop RH-04+05 — Exfiltración de Propiedad Intelectual

## Contexto
- **Activo:** RH-04 (Ejecutivo de Ventas) + RH-05 (Ingeniero de Diseño)
- **Amenaza:** Ejecutivo lleva BD clientes en USB + Ingeniero sube planos a GitHub personal
- **Fecha:** 2026-07-18
- **Duración:** 40 min
- **Participantes:** Ejecutivo, Ingeniero, Director, SysAdmin
- **Material:** Política P4 (Gestión Activos), NDA firmados, política de DLP

## Desarrollo

### 1. Contexto (5 min)
TecNoGlobal exporta planos de seguridad para clientes. Ingeniero diseña. Ejecutivo vende. Ambos salen de la empresa con material sensible:

- **RH-04:** Ejecutivo de Ventas copia BD de 2,500 clientes tecNoGlobal (.csv) a USB personal antes de renunciar → lleva a nuevo empleador (competidor).
- **RH-05:** Ingeniero sube 12 planos de diseño de sistemas de seguridad a su repositorio GitHub personal para "portafolio profesional".

### 2. Ejecución (15 min)
**RH-04:** Ejecutivo renuncia, en último día descarga CSV via Odoo export, copia a USB Kingstone en DC, entrega laptop. Sale sin revisión de EDR. DLP no detecta movimiento.

**RH-05:** Ingeniero commitee a github.com/jperez/portfolio-enimer 12 archivos .dwg (AutoCAD) en repositorio público. DLP no detecta.

### 3. Detección (10 min)
**RH-04:** 3 meses después, ex-ejecutivo aparece trabajando con competidor "SecurityEcuador" → competen con los precios de TecNoGlobal a clientes exactamente. Gerente realiza investigación.

**RH-05:** 2 meses después, Google Alert para "tecnoglobal" aparece encontrado en planos .dwg públicos en github.com/jperez → ingeniero de soporte detecta.

### 4. Respuesta (10 min)
**RH-04:** Revisión EDR del laptop → descarga CSV registrada (afortunadamente) el último día → abre acción legal por incumplimiento de NDA + spionaje industrial.

**RH-05:** SysAdmin solicita a GitHub (DCMA takedown) → 4 horas después archivos retirados. Apertura de investigación interna → ingeniero departido, demandado por incumplimiento NDA.

## Controles Evaluados

- **A.6.2 (Protección contra programas maliciosos y exfiltración):** ¿Existe DLP en endpoints?
  - **Resultado:** ❌ Sin DLP → ni CSV a USB ni .dwg a GitHub detectados.

- **A.8.12 (Clasificación de la información en nubes):** ¿Los planos y BD clientes están clasificados?
  - **Resultado:** ❌ No tienen etiqueta de clasificación → no fueron tratados como sensibles.

- **A.6.2 (EDR / monitoreo de endpoints):** ¿EDR en laptop del ejecutivo registra descargas?
  - **Resultado:** ✅ ESET Enterprise Armor registra exportaciones (afortunadamente en retrospective), aunque no bloqueó.

## Brechas Detectadas

- **NC-18 (RH-04):** Sin DLP en endpoints → exfiltración tanto de CSV a USB como de .dwg a GitHub no detectada en tiempo real. Recomendación: implementar Windows DLP o Bitdefender DLP para bloquear USB + GitHub.

- **NC-19 (RH-05):** Planos y BD clientes sin etiqueta de clasificación → no fueron tratados como confidenciales. Recomendación: clasificar todos los documentos sensibles con watermarking (visible y metadatos), agregar DLP con políticas basadas en clasificación.

- **NC-20 (RH-04/05):** Procedimiento de salida de empleado no incluye revisión de actividades previas a la renuncia. Recomendación: al momento de notificación de renuncia → SysAdmin aumenta nivel de monitoreo de endpoint.
</parameter>
</invoke>
