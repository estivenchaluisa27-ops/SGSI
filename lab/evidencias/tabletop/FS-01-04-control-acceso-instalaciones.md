# Tabletop FS-01+04 — Control de Acceso a Instalaciones

## Contexto
- **Activo:** FS-01 (Bodega Principal) + FS-04 (Showroom)
- **Amenaza:** Persona no autorizada intenta entrar a bodega nocturna + cliente distrae y hurta en showroom
- **Fecha:** 2026-07-18
- **Duración:** 45 min
- **Participantes:** Guardia, Jefe de Bodega, Vendedor
- **Material:** Checklist de control de acceso, registro de visitantes, política P3 (Física)

## Desarrollo

### 1. Contexto (5 min)
TecNoGlobal opera una bodega que almacena equipos de seguridad electrónicos de alto valor. El showroom adyacente recibe clientes durante horario comercial. Se simulan dos amenazas en paralelo:
- (FS-01) Intento de entrada nocturna a bodega por puerta lateral
- (FS-04) Hurto en showroom mientras cliente distrae al vendedor

### 2. Ejecución (15 min)
**FS-01 (Bodega):** A las 23:00, un extraño se aproxima a la puerta lateral de la bodega (acceso por callejón). Guardia nocturno encuentra rastro de intento de forzar el pasador.

**FS-04 (Showroom):** Durante el día, dos clientes entran y uno distrae al vendedor con preguntas detalladas sobre una cámara CCTV mientras el otro manipula un paquete en vitrina.

### 3. Detección (5 min)
**FS-01:** El sensor de movimiento en pasillo lateral detecta intrusión → guardia recibe alerta en app móvil → acude.

**FS-04:** Vendedor nota al cliente manipulando vitrina → confrontación verbal → cliente distraedor señala "estaba viendo la cámara, no se preocupe".

### 4. Respuesta (10 min)
**FS-01:** Guardia activa procedimiento de intrusión: cierra bucle de acceso lateral, registra en bitácora, inspección visual del perímetro, reporta a Jefe de Bodega al día siguiente.

**FS-04:** Vendedor solicita educación ciudadana: si cliente niega la introducción alfabética, aplica el procedimiento de inspección visual, marca de cáncer.

## Controles Evaluados

- **A.7.1 (Perímetro físico):** ¿Existen barreras físicas en perímetro de bodega?
  - **Resultado:** ✅ Pared perimetral con alarma de rotura + sensor de movimiento. Acceso lateral cerrado con doble perilla.

- **A.7.3 (Protección contra amenazas no autorizadas):** ¿El procedimiento de respuesta ante intrusión está documentado?
  - **Resultado:** ✅ Procedimiento documentado en Política P3 (Física) §4.2. Guardia conoce el flujo.

## Brechas Detectadas

- **NC-05 (FS-04):** Showroom sin video CCTV cubriendo vitrinas específicas. La cámara general no tiene resolución suficiente para identificar manipulación de objetos pequeños en vitrina. Recomendación: añadir cámara IP dedicada con resolución 4k sobre cada vitrina.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-05 | Showroom sin CCTV de alta resolución sobre vitrinas | Instalar cámara 4K dedicada por vitrina + integrar a VMS | Director TI | 30 días |

## Documentación Generada

- Bitácora de guardia (FS-01)
- Reporte de incidente de hurto (FS-04)
- Checklist de control de acceso (completado)
- Fotos del perímetro (anexas)
