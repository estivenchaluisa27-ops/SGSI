# Tabletop FS-05 — Robo en Ruta (Piratería)

## Contexto
- **Activo:** FS-05 (Camión Hino)
- **Amenaza:** Camión detenido en falso control policial
- **Fecha:** 2026-07-18
- **Duración:** 30 min
- **Participantes:** Chofer, Despachador
- **Material:** Política de seguridad en ruta, manual del chofer, GPS Wialon (documentación)

## Desarrollo

### 1. Contexto (5 min)
Camión Hino transporta 50 cámaras IP Hikvision + 20 NVR desde Quito a sucursal Guayaquil (ruta Panamericana, ~420 km). Riesgo: asalto en ruta. Simulación: camión detenido en "control policial" falseado a 40 km al sur de Quito, sector despoblado.

### 2. Ejecución (15 min)
A las 09:00, chofer se aproxima a un retén con 2 individuos vestidos con uniformes policiales no estándar (sin chaleco oficial, sin motocicleta policial visible). Individuos solicitan bajar, "inspeccionar carga". Chofer recuerda procedimiento de empresa: no debe abrir cajas en ruta sin orden de juez + llamada a Despachador.

### 3. Detección (5 min)
Chofer desconfía: no ve radio policía ni identificación legítima. Llama a Despachador por radio + GPS Wialon reporta detención anómala en zona inusual.

### 4. Respuesta (10 min)
Chofer no abre cajas, solicita número de identificación de los "policías". Individuos insisten con agresividad. Chofer reporta por radio a Despachador → Despachador valida con Comando de Policía E-9-1-1 → identifica que no hay operativo en ese tramo → Despachador instruye chofer reanudar marcha → individuos no pueden responder agresivamente.

## Controles Evaluados

- **A.7.9 (Seguridad de equipos fuera de las instalaciones):** ¿Existe procedimiento de respuesta a control no auténtico?
  - **Resultado:** ✅ Política P3 (Física) §7.9 documenta procedimiento: no abrir sin orden de juez, llamar a Despachador.

- **A.7.9 (Monitoreo GPS):** ¿El camión reporta su ubicación en tiempo real?
  - **Resultado:** ✅ Wialon GPS reporta ubicación cada 2 min → detecta detención anómala.

## Brechas Detectadas

- **NC-09 (FS-05):** Chofer no tiene número directo de Policía Nacional para validar control → depende de Despachador activar consulta con ECU911. Recomendación: entregar a chofer tarjeta de contactos de seguridad con número directo.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-09 | Chofer sin contactos directos de seguridad | Emitir tarjeta de contactos con Policía ECU911, Despachador, SysAdmin | Director Logística | 15 días |

## Documentación Generada

- Bitácora del chofer con descripción del incidente
- Screenshot del GPS Wialon mostrando detención
- Reporte de incidente a Policía
