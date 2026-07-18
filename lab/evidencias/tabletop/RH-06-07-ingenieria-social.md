# Tabletop RH-06+07 — Ingeniería Social (Whaling + Vishing)

## Contexto
- **Activo:** RH-06 (Gerente General) + RH-07 (Recepcionista)
- **Amenaza:** Email falso del gerente pide transferencia + falso soporte TI llama pidiendo credenciales
- **Fecha:** 2026-07-18
- **Duración:** 45 min
- **Participantes:** Contador, Gerente, Recepcionista, SysAdmin
- **Material:** Política de concientización P4, procedimiento de validación de identidad

## Desarrollo

### 1. Contexto (5 min)
TecNoGlobal relanza campaña de phishing externo (no confiable) con dos vectores:
- **RH-06 (Whaling):** Email falso con dominio similar "gerente@tecnogIobal.ec" (sustitución I mayúscula → I minúscula) a Contador: "Urgente: Pagar USD 8,500 a proveedor ACME S.A. antes de las 17:00 o perdemos contrato. Cta: 0123456789 Banco Pichincha. Por favor confirma recepción del correo."
- **RH-07 (Vishing):** Llamada telefónica a Recepción 14:30. Dice ser "David del Soporte de Microsoft" → "necesitamos validar su cuenta de Teams. Por favor dictar la contraseña o pulsar Windows+R + escribir el comando que le dictaré."

### 2. Ejecución (15 min)
**RH-06:** Contador recibe email a las 15:30 → давление temporal → correo "parece" venir del Gerente (cabecera "From: gerente@tecnogIobal.ec" casi idéntico). Responde "Sí, proceso." Procede a registrar pago Odoo + transferencia bancaria.

**RH-07:** Recepcionista recibe llamada 14:30. Voz de hombre, en español neutro (no ecuatoriano). Pide Technicamente la contraseña. Recepcionista recuerda formato de capacitación reciente → cuelga + reporta al SysAdmin inmediatamente.

### 3. Detección (5 min)
**RH-06:** Contador finaliza transferencia a las 16:05 → al cierre de día, Recepción hace impresión con el correo a Gerente "¿Bien este pago, jefe?" Gerente: "¿Qué pago?". Detección retrospectiva 17:30.

**RH-07:** Recepcionista reporta inmediatamente. SysAdmin registra el incidente + llama al número (busy/fake) + alerta a todo el personal sobre campaña vishing.

### 4. Respuesta (10 min)
**RH-06:**
- Gerente llama a banco: "FAX XX: reversionar transferencia por fraude inmediato."
- Banco: "si transferencia es entre cuentas Pichincha, no es reversionable".
- Banco: registra denuncia. SysAdmin + Log: observar cabeceras del correo → testing de DMARC. DMARC policy "none" no bloquea. Posible entrenamiento DMARC "reject" a futuro.

**RH-07:**
- Recepcionista conduce en la práctica correcta.
- SysAdmin evalúa todos los reportes de incidentes vishing en semana (3 total).
- Capacitación a todo el personal la próxima semana.

## Controles Evaluados

- **A.6.3 (Concienciación):** ¿El staff reconoce intentos de ingeniería social?
  - **Resultado:** ⚠️ Recepcionista SÍ reconoce vishing (HR-07 ✅), pero Contador NO reconoce whaling (RH-06 ❌).

- **A.5.3 (Segregación de funciones):** ¿Pago único firma acelerada permite fraude?
  - **Resultado:** ❌ Contador puede hacer pago solo con email "del Gerente". No hay verificación telefónica secundaria.

- **A.5.23 (Cloud):** ¿Microsoft 365 con DMARC reject?
  - **Resultado:** ❌ DMARC configurado como "none" (reporte) no "reject" (bloqueo).

- **A.7.2 (Control de instalaciones para vishing):** ¿Existe procedimiento para reportar vishing?
  - **Resultado:** ✅ Política P5 explicita: reportar inmediatamente.

## Brechas Detectadas

- **NC-21 (RH-06):** Pago de >USD 5,000 sin doble verificación telefónica. Recomendación: cualquier pago >USD 2,000 requiere llamada telefónica a Gerente con número registrado en matriz de contactos, no con número del email.

- **NC-22 (RH-06):** DMARC en dominio de email tecnoGlobal.ec con policy "none". Recomendación: cambiar p=reject para bloquear dominios falsos parecidos a nivel de destino.

- **NC-23 (RH-06):** Contador no reconoció whaling a pesar de capacitación. Recomendación: capacitación vis-à-vis + simulacro anti-whaling mensual.

## Acciones Correctivas

| # | Brecha | Acción | Responsable | Plazo |
|---|---|---|---|---|
| NC-21 | Pago sin verificación telefónica secundaria | Implementar protocolo validación telefónica para pagos >USD 2,000 | Contabilidad + Gerencia | Inmediato |
| NC-22 | DMARC "none" sin que ether rejects | Configurar p=reject en DNS + SPF + DKIM hardening | SysAdmin | 14 días |
| NC-23 | Sin simulacro anti-whaling periódico | Migrar a simulacro mensual con GoPhish interno + métricas por área | RRHH + TI | 30 días |

## Documentación Generada

- Correo de whaling RH-06 (anexo con cabeceras)
- Grabación de llamada vishing RH-07
- Reporte de incidente formal
- Bitácora de regeneración de acceso a correo
