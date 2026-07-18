# SIEM Lightweight — Sustitución de Elasticsearch/Kibana/Wazuh

## Contexto

El laboratorio físico tiene **~3.9 GB de RAM libre**. Los stacks SIEM tradicionales (Elasticsearch + Kibana + Wazuh) consumen ~2.5 GB. Se eliminan del laboratorio físico y se sustituyen por un **SIEM lightweight** basado en volúmenes compartidos + scripts de revisión.

## Arquitectura

```
                          ┌─────────────────────────┐
                          │   Volumen: sgsi-logs     │
                          │   /var/log/sgsi/         │
                          └─────────────────────────┘
                                     ▲
        ┌──────────┬──────────┬──────────┬──────────┐
        │          │          │          │          │
   odoo/logs/  nginx/    postgres/  mariadb/    mongodb/
        │          │          │          │          │
        └──────────┴──────────┴──────────┴──────────┘
                                  │
                          ┌───────┴────────┐
                          │  Script:        │
                          │  check-logs.sh  │
                          │  + grep + jq    │
                          └────────────────┘
```

## Cómo usar el SIEM lightweight

### Revisar todos los logs en vivo
```bash
docker run --rm -v sgsi-logs:/logs alpine \
  sh -c 'watch "tail -n 100 /logs/*/*.log"'
```

### Filtrar intentos de login fallidos (Hydra)
```bash
docker run --rm -v sgsi-logs:/logs alpine \
  sh -c 'grep -rE "FAILED|denied|invalid" /logs/ | tail -50'
```

### Detectar SQL injection
```bash
docker run --rm -v sgsi-logs:/logs alpine \
  sh -c 'grep -rE "SQL|inject|union|select.*from" /logs/ | tail -50'
```

### Detectar borrado de logs (IF-07)
```bash
docker run --rm -v sgsi-logs:/logs alpine \
  sh -c 'find /logs -size 0 -print'
```

## Mapeo de controles SIEM

| Control ISO | Implementación lightweight |
|---|---|
| A.8.15 (Logs) | Todos los servicios escriben logs al volumen compartido |
| A.8.16 (Protección logs) | Volumen de solo lectura para servicios excepto su propio subdir |
| A.5.30 (Continuidad TI) | Logs persistentes en volumen Docker — sobreviven restarts |
| A.5.7 (Threat intel) | Script `check-iocs.sh` busca hashes/IPs en logs (feeds MISP simulados) |
| A.8.5 (Autenticación) | Logs de auth de Odoo, LDAP, Postgres se revisan post-ataque |

## Limitaciones vs SIEM completo

| Característica | SIEM completo | Lightweight |
|---|---|---|
| Correlación en tiempo real | ✅ | ❌ (post-procesado) |
| Dashboards visuales | ✅ Kibana | ❌ Texto |
| Alertas proactivas | ✅ Wazuh | ❌ (revisión manual post-ataque) |
| Detección EDR en endpoint | ✅ Wazuh agent | ❌ |
| Almacenamiento logs | ✅ 6+ meses | ✅ Volumen persistente |
| Detección de IOCs | ✅ Automática | Parcial (script) |
| **RAM consumida** | ~2.5 GB | **~50 MB** |

## En el informe final (Fase 3)

Documentar como **limitación conocida del laboratorio**:
> Por restricciones de RAM (3.9 GB disponibles), no se desplegó un SIEM comercial. Se usó
> un SIEM lightweight basado en volúmenes compartidos + scripts de revisión. La detección
> fue post-procesada (no tiempo real). Para fase de producción se recomienda desplegar
> Wazuh + Elastic Stack en infraestructura con ≥8 GB RAM.

## Script de revisión de logs

Ver `scripts/check-logs.sh` — ejecuta las consultas más comunes y genera un resumen
post-simulación que se adjunta como evidencia.
