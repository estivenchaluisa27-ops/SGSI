# Tabletop RH-01 — Robo de Credenciales en Campo

## Contexto
- **Activo:** RH-01 (Técnico Instalador)
- **Amenaza:** Técnico pierde mochila con laptop + credenciales en sitio de cliente
- **Fecha:** 2026-07-18
- **Duración:** 30 min
- **Participantes:** Técnico, SysAdmin
- **Material:** Política P1 (General), política de respuesta a incidentes

## Desarrollo

### 1. Contexto (5 min)
Técnico instalador de TecNoGlobal visita cliente en Cuenca para instalación de 5 cámaras CCTV. Lleva laptop corporativa con VPN + credenciales LDAP + contraseña odoo + contraseña SSH de Postgres anotadas encuaderna física.

### 2. Ejecución (15 min)
Técnico estaciona vehículo en calle pública cerca del cliente. Entra 15 min a cafetería por almuerzo. Al regresar, encuentra ventana rota → mochila con laptop + cuaderno desaparecidas. Ocurrrió entre 13:00 y 13:20.

### 3. Detección (5 min)
Técnico relata SysAdmin por teléfono a las 13:30 → SysAdmin recibe reporte de incidente de robo → interna lista de respuesta a incidentes #INST-01 Robo de equipo móvil.

### 4. Respuesta (10 min)
SysAdmin:
1. Desactiva cuenta LDAP del técnico (jperez) en 2 min → revokea VPN.
2. Borra access token VPN activo del técnico (si existe).
3. Cambia credenciales SSH Postgres (en .env de P3).
4. Wipe remoto del laptop (MDM Jamf si disponible - confirmado sí).
5. Reporte de incidente formal + reporte a Policía Nacional.
6. Contacta cliente en Cuenca para recuperar trabahjo.

## Controles Evaluados

- **A.6.7 (Teletrabajo y robo de equipo):** ¿Existe procedimiento de respuesta ante robo de equipo corporativo?
  - **Resultado:** ✅ Política P1 §6.7 especifica: (a) wipe remoto, (b) desactivar accesos, (c) reporte a Policía, (d) bitácora.

- **A.6.7 (Cifrado en laptop corporativa):** ¿Disco duro cifrado?
  - **Resultado:** ✅ LUKS en todas las laptops (política obligatoria).

- **A.8.1 (Inventario):** ¿El técnico tiene credenciales físicas anotadas en cuaderno?
  - **Resultado:** ❌ Práctica peligrosa prohibida por política P5 §8.1 — sensitive data solo en bóveda digital (Bitwarden).

## Brechas Detectadas

- **NC-13 (RH-01):** Técnico tenía credenciales anotadas en cuaderno físico (violación política P5). Recomendación: capacitación recordatoria + auditoría cuadernos físicosmensual.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-13 | Técnico anota credenciales en cuaderno físico | Sesiones de capacitación + auditoría mensual + migración forzosa a Bitwarden | RRHH + Director TI | 14 días |

## Documentación Generada

- Reporte de incidente RH-01 (robo)
- Log de wipe remoto del laptop
- Bitácora de SysAdmin (cronología desactivación accesos)
- Denuncia a Policía Nacional
