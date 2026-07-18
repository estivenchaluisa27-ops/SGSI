# Tabletop FS-03+10 — Falla de Control Físico + Biométrico

## Contexto
- **Activo:** FS-03 (Lector biométrico) + FS-10 (Cerradura electromagnética)
- **Amenaza:** Intento de huella falsa en biométrico + corte energía libera cerradura magnética
- **Fecha:** 2026-07-18
- **Duración:** 45 min
- **Participantes:** SysAdmin, Recepcionista, Facilities
- **Material:** Política de control de acceso físico, manual del biométrico, política P3 (Física)

## Desarrollo

### 1. Contexto (5 min)
TecNoGlobal usa un biométrico ZKTeco en entrada principal de oficinas y una cerradura electromagnética en la puerta del DC. Ambos dependen de diferentes modalidades eléctricas. Se simulan:
- (FS-03) Atacante intenta usar gelatina con huella falsa del gerente CM para engañar biométrico
- (FS-10) Corte de energía a las 14:00 libera la cerradura electromagnética → puerta DC se abre sin control durante falla

### 2. Ejecución (15 min)
**FS-03:** Atacante se aproxima a biométrico de entrada principal con molde de gelatina con huella del gerente (huella robada de vasos en restaurante). Intenta 3 veces → biométrico óptico con tecnología "live finger detection" (detección de temperatura/humedad).

**FS-10:** Corte eléctrico de 1 hora en sector 14:00-15:00. Cerradura electromagnética (12V, modo "fail-safe") libera al faltar energía → DC queda accesible para cualquier persona que empuje la puerta.

### 3. Detección (5 min)
**FS-03:** Biométrico ZKTeco rechaza gelatina por no detectar sangre fluyendo → registra los 3 intentos fallidos en log → alerta "tentativa fraude biométrico" enviada a SysAdmin.

**FS-10:** SysAdmin recibe alerta de corte eléctrico (UPS/Inverter detecta pérdida AC) → al verificarse حالة ve que DC tiene UPS de 2 min (documentado en Fase 1/Fase 2 simulación real) → UPS se agota al minuto → puerta libera.

### 4. Respuesta (10 min)
**FS-03:** SysAdmin consulta logs del biométrico, identifica 3 intentos fallidos en horario 9:30 AM → coordina con guardia para inspección de cámara de entrada → identifica a atacante → reporta a Gerencia y RRHH.

**FS-10:** SysAdmin acude al DC en menos de 5 min → encuentra puerta cerrada pero libre (solo empuje) → posiciona guardia supletorio mientras se restablece energía. Cerradura no resiste hasta 15:10.

## Controles Evaluados

- **A.7.2 (Control de entrada física):** ¿El biométrico valida huella "viva"?
  - **Resultado:** ✅ ZKTeco con Live Finger Detection (tejido capacitivo + temperatura) rechaza huellas falsas.

- **A.7.2 (Continuidad de control físico):** ¿La cerradura mantiene seguridad durante falla eléctrica?
  - **Resultado:** ❌ Cerradura electromagnética es "fail-safe" → libera al faltar energía. UPS de 2 min es insuficiente.

## Brechas Detectadas

- **NC-08 (FS-10):** Cerradura electromagnética "fail-safe" combinada con UPS de solo 2 min → durante corte eléctrico prolongado, DC queda accesible. Recomendación: instalar cerradura "fail-secure" con batería de respaldo, o UPS de mayor capacidad (≥30 min).

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-08 | Falla de cerradura eléctrica con UPS 2 min | Migrar a cerradura fail-secure con batería de respaldo de 4h + UPS dedicado | Facilities + Director TI | 60 días |

## Documentación Generada

- Log del biométrico (3 intentos fallidos + detección de gelatina)
- Reporte de incidente eléctrico FS-10
- Inspección visual de puerta DC post-corte
