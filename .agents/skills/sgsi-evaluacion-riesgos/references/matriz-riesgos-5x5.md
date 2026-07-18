# Referencia: Matriz de Riesgos 5×5 y Catálogo de Amenazas

## Matriz de Riesgos 5×5 — Mapa de Calor

```
         Impacto →
         1-Insignif.  2-Menor  3-Moderado  4-Mayor  5-Catastrófico
Prob. ↓
5-Muy alta    5🟢      10🟡     15🟠       20🔴      25🔴
4-Alta        4🟢       8🟢     12🟡       16🟠      20🔴
3-Media       3🟢       6🟢      9🟡       12🟡      15🟠
2-Baja        2🟢       4🟢      6🟢        8🟢      10🟡
1-Muy baja    1🟢       2🟢      3🟢        4🟢       5🟢
```

## Niveles de Riesgo y Acciones

| Rango | Nivel | Acción | Plazo | Aprobación |
|-------|-------|--------|-------|------------|
| 20-25 | 🔴 Crítico | Acción inmediata obligatoria | < 1 mes | Gerencia General |
| 15-19 | 🟠 Alto | Plan de tratamiento prioritario | < 3 meses | Comité de Seguridad |
| 9-14 | 🟡 Medio | Plan de tratamiento planificado | < 6 meses | Responsable del activo |
| 1-8 | 🟢 Bajo | Monitorear / Aceptar | Revisión anual | Responsable del activo |

## Catálogo de Amenazas por Categoría

### Hardware
| ID | Amenaza | Descripción |
|----|---------|-------------|
| A-HW-01 | Fallo de hardware | Avería de componentes (disco, fuente, CPU, RAM) |
| A-HW-02 | Robo físico | Sustracción del equipo |
| A-HW-03 | Obsolescencia | Fin de vida útil o soporte del fabricante |
| A-HW-04 | Sabotaje | Daño intencional al equipo |
| A-HW-05 | Desastre natural | Terremoto, inundación, incendio |
| A-HW-06 | Acceso no autorizado | Manipulación física sin permisos |
| A-HW-07 | Fallo eléctrico | Sobrecarga, corte de energía |

### Software
| ID | Amenaza | Descripción |
|----|---------|-------------|
| A-SW-01 | Vulnerabilidad explotable | CVE conocido sin parchear |
| A-SW-02 | Malware/Ransomware | Infección por código malicioso |
| A-SW-03 | Acceso no autorizado | Bypass de autenticación |
| A-SW-04 | Error de configuración | Configuración insegura o por defecto |
| A-SW-05 | Inyección (SQL/XSS) | Ataques de inyección en aplicaciones |
| A-SW-06 | Denegación de servicio | Interrupción del servicio |
| A-SW-07 | Fuga de información | Exposición de datos por error de software |

### Información
| ID | Amenaza | Descripción |
|----|---------|-------------|
| A-IF-01 | Fuga de datos | Divulgación no autorizada |
| A-IF-02 | Alteración de datos | Modificación no autorizada |
| A-IF-03 | Ransomware | Cifrado malicioso de datos |
| A-IF-04 | Pérdida de datos | Eliminación accidental o intencional |
| A-IF-05 | Espionaje industrial | Robo de información competitiva |
| A-IF-06 | Incumplimiento legal | Violación de regulaciones de privacidad |

### Físicos
| ID | Amenaza | Descripción |
|----|---------|-------------|
| A-FS-01 | Intrusión | Acceso físico no autorizado |
| A-FS-02 | Vandalismo | Daño intencional a instalaciones |
| A-FS-03 | Incendio | Fuego accidental o provocado |
| A-FS-04 | Inundación | Daño por agua |
| A-FS-05 | Fallo de suministros | Electricidad, agua, climatización |
| A-FS-06 | Robo de activos | Sustracción de equipos o mercancía |

### Personal
| ID | Amenaza | Descripción |
|----|---------|-------------|
| A-RH-01 | Ingeniería social | Phishing, vishing, pretexting |
| A-RH-02 | Fraude interno | Abuso de confianza o privilegios |
| A-RH-03 | Negligencia | Errores humanos no intencionales |
| A-RH-04 | Rotación de personal | Pérdida de conocimiento y accesos no revocados |
| A-RH-05 | Sabotaje interno | Daño intencional por empleado |
| A-RH-06 | Fuga de talento | Pérdida de personal clave con conocimiento crítico |

## Catálogo de Vulnerabilidades Comunes

| ID | Vulnerabilidad | Controles Aplicables |
|----|---------------|---------------------|
| V-01 | Contraseñas débiles o por defecto | A.5.17, A.8.5 |
| V-02 | Falta de cifrado (en reposo o tránsito) | A.8.24 |
| V-03 | Ausencia de MFA | A.8.5 |
| V-04 | Software sin parches/actualizaciones | A.8.8 |
| V-05 | Falta de segmentación de red | A.8.22 |
| V-06 | Backups en misma red sin aislamiento | A.8.13 |
| V-07 | Permisos excesivos (privilegios) | A.8.2, A.5.15 |
| V-08 | Falta de logs/auditoría | A.8.15 |
| V-09 | Ausencia de gestión MDM en móviles | A.6.7, A.8.1 |
| V-10 | Sin plan de continuidad del negocio | A.5.30 |
| V-11 | Falta de concienciación del personal | A.6.3 |
| V-12 | Credenciales compartidas | A.5.17 |
| V-13 | Interfaces de gestión expuestas | A.8.20 |
| V-14 | Ausencia de DLP | A.8.12 |
| V-15 | Falta de segregación de funciones | A.5.3 |
