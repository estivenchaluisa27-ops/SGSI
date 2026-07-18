# Tabletop RH-03+08 — Fraude Financiero Interno

## Contexto
- **Activo:** RH-03 (Jefe de Bodega) + RH-08 (Contador)
- **Amenaza:** Jefe Bodega registra salida falsa de 10 cámaras + Contador recibe factura falsa y cambia nro. de cuenta bancaria
- **Fecha:** 2026-07-18
- **Duración:** 50 min
- **Participantes:** Jefe de Bodega (rol fictional), Contador (rol fictional), Gerente
- **Material:** Política P1 (General), procedimiento de salida de inventario, procedimiento de pago a proveedores

## Desarrollo

### 1. Contexto (5 min)
Jefe de Bodega de TecNoGlobal presiona por deudas personales. Colabora con contador (también presionado) para desviar USD 12,000 (10 cámaras a USD 1,200 cada una) via factura falsificada + transferencia a cuenta externo.

### 2. Ejecución (20 min)

**Fase A — RH-03:** Jefe Bodega registra salida falsa al inventario_stock (MariaDB) de 10 cámaras (UPDATE WHERE id=1) marcando como "venta cliente ACME Corp". Genera DT (Documento de Transferencia) inventario.

**Fase B — RH-08:** Contador recibe factura de ACME Corp (falsa, proveedor real pero generada en casa) por USD 12,000. Sistema Odoo no valida coincidencia entre DT inventario y factura. Contador cambia número de cuenta en factura (edición PDF via Adobe, modificación en banco destino) para transferir a su propia cuenta.

**Fase C — Pago:** Gerente aprueba transferencia con una sola firma sin validar que la cuenta bancaria sea la originalmente registrada de ACME.

### 3. Detección (5 min)
2 meses más tarde: ACME reclama no recibir productos pagados → Gerente inicia investigación → compara DT inventario + factura → detecta cuenta bancaria distinta + inventario físicamente intacto en bodega.

### 4. Respuesta (10 min)
- Suspensión inmediata de Jefe Bodega + Contador (con retención de acceso).
- Denuncia penal por apropiación + falsificación.
- Recuperación del dinero en proceso legal con banco.
- Revisión completa de operaciones de inventario y pagos por auditoría externa.

## Controles Evaluados

- **A.5.3 (Segregación de funciones):** ¿Pago y salida de inventario requieren doble firma?
  - **Resultado:** ❌ Solo Gerente firma el pago, sin segunda verificación del inventario + factura.

- **A.8.3 (Restricción de acceso):** ¿Cualquier usuario puede hacer UPDATE en inventario?
  - **Resultado:** ❌ Conexión directa a MariaDB permitió UPDATE sin control de cambio documentado.

- **A.8.15 (Logging):** ¿UPDATE en inventario queda registrado con usuario + motivo?
  - **Resultado:** ❌ (corresponde con IF-09 simulación Docker). No existe logging de auditoría.

- **A.8.2 (Control de acceso privilegiado):** ¿Cuenta bancaria de proveedor puede ser cambiada sin control?
  - **Resultado:** ❌ Contador puede editar cuenta en factura PDF sin verificación dual.

## Brechas Detectadas

- **NC-16 (RH-03):** Salida de inventario sin doble firma + conciliación automática. Recomendación: implementar workflow de aprobación dual en Odoo para salidas de valor > USD 5,000.

- **NC-17 (RH-08):** Cuenta bancaria del proveedor editable en factura sin verificación adicional. Recomendación: registro editable solo por Gerente, en factura usar código QR federado con cada banco.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-16 | Salida inventario sin doble firma | Workflow aprobación dual en Odoo para pares > USD 5,000 + digital DT con 2 firmas | Director TI + Gerencia | 45 días |
| NC-17 | Cuentas bancarias editables en facturas | Migrar a registro de cuentas bancarias (solo lectura en factura) con validación vs matriz | Director TI | 30 días |

## Documentación Generada

- Reporte de incidente por fraude financiero
- Comparación DT inventario real vs factura falsa
- Policía: copia de denuncia penal
- Auditoría externa (en proceso)
