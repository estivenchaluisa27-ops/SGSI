# Tabletop FS-02+06 — Seguridad en Data Center

## Contexto
- **Activo:** FS-02 (Cuarto de Servidores) + FS-06 (Rack 42U)
- **Amenaza:** Técnico externo pide acceso sin orden + personal de limpieza desconecta cable en rack
- **Fecha:** 2026-07-18
- **Duración:** 45 min
- **Participantes:** SysAdmin, Guardia, Facilities
- **Material:** Política de acceso a DC, registro de visitantes DC, política P3 (Física)

## Desarrollo

### 1. Contexto (5 min)
El cuarto de servidores de TecNoGlobal aloja el servidor HPE ProLiant DL380, NAS Synology y switch PoE. Acceso restringido por biométrico + tarjeta. Se simulan:
- (FS-02) Técnico externo se presenta sin orden de trabajo oficial a las 10:30 AM
- (FS-06) Personal de limpieza externo ingresa al DC nocturno y desconecta cable de alimentación del rack por error

### 2. Ejecución (15 min)
**FS-02:** Técnico externo vestido con overol dice venir de proveedor "DataCenter Services" para "mantenimiento preventivo de UPS". No tiene orden de trabajo, no está en la lista de visitantes esperados.

**FS-06:** Personal de limpieza (subcontratado) accede a las 02:00 AM con permiso general de "limpieza nocturna". Limpia el piso del DC y tropieza con cable blanco de PDU por detrás del rack → desconexión.

### 3. Detección (5 min)
**FS-02:** Guardia de recepción solicita identificación → busca en sistema → técnico no está registrado → llama a SysAdmin → SysAdmin no ha generado orden.

**FS-06:** Monitoreo de estado del servidor (Nagios ping) detecta caída 02:15 AM → SysAdmin recibe alerta → inspección física.

### 4. Respuesta (10 min)
**FS-02:** Guardia deniega acceso, registra intento en bitácora, foto del individuo, reporta a SysAdmin → SysAdmin contacta proveedor oficial "DataCenter Services" para confirmar envío → proveedor niega haber enviado técnico.

**FS-06:** SysAdmin acude físicamente 02:30 AM → encuentra cable de PDU desconectado → reconecta → reinicia servicios caídos → RTO acumulado: 30 min.

## Controles Evaluados

- **A.7.6 (Trabajo en zonas seguras):** ¿El acceso al DC está restringido y documentado?
  - **Resultado:** ✅ Acceso por biométrico + tarjeta + orden de trabajo. Guardia validó identidad del técnico.

- **A.7.1 (Perímetro físico):** ¿Existe perímetro físico del DC?
  - **Resultado:** ✅ Puerta reforzada, sin ventanas, cerradura electromagnética.

- **A.7.8 (Política de escritorio limpio / pantalla bloqueada):** ¿Hay política de orden físico en rack?
  - **Resultado:** ❌ Cableado del rack no está canalizado, cable PDU suelto puede ser desconectado por error.

## Brechas Detectadas

- **NC-06 (FS-06):** Cableado del rack sin canalización → personal no técnico puede desconectar equipos por accidente. Recomendación: instalar canaletas cerradas + bloqueo de puertos PDU.

- **NC-07 (FS-06):** Personal de limpieza externo ingresa al DC sin supervisión nocturna. Recomendación: restringir limpieza del DC a horario con presencia de SysAdmin.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-06 | Cableado del rack sin canalización | Instalar canaletas cerradas velcro + bloqueo de puertos PDU | Facilities | 21 días |
| NC-07 | Limpieza del DC sin supervisión | Reestringir limpieza DC a horario con SysAdmin presente | Director TI | Inmediato |

## Documentación Generada

- Bitácora de guardia con intento de intrusión FS-02
- Reporte de incidente de desconexión FS-06 (Nagios alert)
- Checklist de acceso DC (completado)
- Fotos del cableado del rack
