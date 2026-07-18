# Tabletop FS-07+08+09 — Falla de Infraestructura Crítica

## Contexto
- **Activo:** FS-07 (AC) + FS-08 (Supresión FM-200) + FS-09 (UPS)
- **Amenaza:** Temperatura sube a 35°C + conato de incendio sin activación + UPS solo aguanta 2 min
- **Fecha:** 2026-07-18
- **Duración:** 60 min
- **Participantes:** SysAdmin, Facilities
- **Material:** Política P3 (Continuidad), manual del AC, manual del FM-200, manual del UPS

## Desarrollo

### 1. Contexto (5 min)
Simulación en cascada:
- (FS-07) AC del DC falla en horario pico (14:00)
- (FS-09) UPS supplementario solo sostiene 2 min (Capacidad 1500VA insuficiente)
- (FS-08) Conato de incendio en NVR por sobrecarga térmica → supresión FM-200 falla al no recibir señal del detector humo (mantenimiento vencido)

### 2. Ejecución (20 min)
T+0 min: AC del DC se detiene por falla del compresor. Sensor de temperatura DC showAlerta a Facilities. T+10 min: temperatura sube a 30°C. SysAdmin apaga NVR y NAS preventivamente. T+20 min: temperatura sube a 35°C → NVR ya apagado, pero hay conato en fuente de alimentación del NAS por estrés térmico previo. Detector de humo deberían activarse → no activa (mantenimiento vencido hace 11 meses). T+25 min: humo visible, Facilities activa extintor manual CO2 + botón de Emergencia. UPS sostiene el servidor solo 2 min → SysAdmin hace apagado de Emergencia via SSH.

### 3. Detección (5 min)
- Detector de humo no activa: ❌ Mantenimiento vencido.
- Sensor de temperatura ambiental **sí** activa alerta a los 30°C → SysAdmin recibe a los 14:10.
- UPS monitor por SNMP alerts a los 14:25: "batería baja, 2 min restantes".

### 4. Respuesta (10 min)
Facilities activa extintor CO2 manual → extingue conato. SysAdmin ejecuta procedimiento de apagado ordenado de Odoo + Postgres. Servidor HPE se apaga sin corrupción de datos. NAS se apaga forzosamente (pérdida de journaling no-critica).

## Controles Evaluados

- **A.7.11 (Cableado seguro):** ¿Cableado del DC sigue normas de canalización separada energía + datos?
  - **Resultado:** ✅ (afortunadamente, dado NC-06)

- **A.7.5 (Protección contra amenazas físicas y ambientales):** ¿Sensores de temperatura + humo funcionan?
  - **Resultado:** ⚠️ Sensor de temperatura sí alerta, pero detector de humo falla por mantenimiento vencido.

- **A.7.11 (UPS):** ¿Existen UPS de capacidad suficiente?
  - **Resultado:** ❌ UPS de 1500VA sostiene servidor por 2 min, insuficiente para apagado ordenado + validación.

## Brechas Detectadas

- **NC-10 (FS-07):** AC sin redundancia (N+0) → falla total en único equipo → temperatura sube sin pausa. Recomendación: AC N+1.

- **NC-11 (FS-08):** Detector de humo con mantenimiento vencido (11 meses +policy dice revisión cada 6 meses. Recomendación: hacer cumplir plan de mantenimiento trimestral con contrato externo.

- **NC-12 (FS-09):** UPS de 1500VA/2 min insuficiente para apagado ordenado de Servidor + NAS + Switch. Recomendación: UPS de mayor capacidad (≥3000VA / 15 min) o baterías redundantes.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-10 | AC N+0 sin redundancia | Adquirir 2do AC de igual capacidad + balanceador | Facilities | 90 días |
| NC-11 | Detector humo con manto vencido | Contratar mantenimiento preventivo trimestral certificado FM | Director TI | Inmediato |
| NC-12 | UPS insuficiente | Adquirir UPS de 3000VA / 15 min capacidad | Director TI | 60 días |

## Documentación Generada

- Bitácora de Facilities (cronología incidente)
- Screenshot del centro de monitoreo ambiental
- Foto del detector de humo fallido (con etiqueta de mantenimiento vencido)
- Registro de apagado ordenado del servidor
