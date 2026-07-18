# Tabletop RH-02 — Sabotaje Interno (SysAdmin Despedido)

## Contexto
- **Activo:** RH-02 (SysAdmin)
- **Amenaza:** SysAdmin despedido borra configs de firewall antes de irse
- **Fecha:** 2026-07-18
- **Duración:** 45 min
- **Participantes:** SysAdmin (rol fictional), Director TI
- **Material:** Política P2 (Acceso), procedimiento de desvinculación

## Desarrollo

### 1. Contexto (5 min)
SysAdmin de TecNoGlobal (cmartinez) es desvinculado por reducción de personal. Aviso oficial al despacho el viernes 17:00. La empresa le permite acceso durante fin de semana para "documentación/traspaso". El lunes a las 09:00 ya no tiene acceso.

### 2. Ejecución (15 min)
Sábado 10:00 — cmartinez ingresa con credenciales activas al firewall Mikrotik via Winbox. Borra 3 reglas de NAT críticas, cambia contraseña admin del FortiGate. Elimina script de backup de firewall (configuración de Ansible). Exporta configs y copia a USB.

### 3. Detección (5 min)
Lunes 09:00 — svc-internet no funciona → ingeniero de soporte revisa firewall → reglas NAT borradas → reporta a Director TI → Director descubre clave de Forti cambiada → inicia investigación.

### 4. Respuesta (10 min)
- Reset clave FortiGate via console local (Físicamente presente DC).
- Restablece reglas NAT desde backup SVN (recuperación en 30 min).
- Audita logs RADIUS/SYSLOG → identifica acceso sábado 10:00 de cmartinez.
- Determina mala práctica: "acceso para documentación" sin supervisión permitió sabotaje.
- Aplica procedimiento disciplinario.

## Controles Evaluados

- **A.8.2 (Acceso):** ¿Existió control de privilegios + revisión de acceso durante desvinculación?
  - **Resultado:** ❌ El acceso post-despacho fue sin supervisión, sin revocación inmediata de privilegios.

- **A.8.2 (Control de cambios):** ¿Cambios en firewall requieren aprobación dual?
  - **Resultado:** ❌ SysAdmin puede editar reglas en firewall sin testigo.

- **A.8.15 (Logging):** ¿Cambios en firewall quedan en log?
  - **Resultado:** ✅ Logs RADIUS + SYSLOG permitieron rastrear al culpable.

## Brechas Detectadas

- **NC-14 (RH-02):** Procedimiento de desvinculación no incluye revocación inmediata de privilegios. Recomendación: política de revocación de accesos en formato cascadón: notificación de despido = revocación simultánea de accesos con un testigo.

- **NC-15 (RH-02):** Cambios en firewall sin aprobación dual. Recomendación: requerir 2 firmas (N+1) para cambios en infraestructura crítica.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-14 | Sin revocación inmediata de accesos al desvincular | Procedimiento: notificación de despido = revocación de accesos LDAP/VPN/BIOMÉTRICO simultánea con testigo | RRHH + Director TI | Inmediato |
| NC-15 | Cambios firewall sin aprobación dual | Implementar flujo 2-firmas para cambios en firewall + versionamiento en Git | Director TI | 30 días |

## Documentación Generada

- Reporte de incidente RH-02 (sabotaje)
- Logs SYSLOG de acceso cmartinez sábado 10:00
- Bitácora de recuperación firewall (30 min RTO)
- Procedimiento disciplinario (anexo)
