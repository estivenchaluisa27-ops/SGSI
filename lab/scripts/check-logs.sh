#!/bin/bash
# check-logs.sh — SIEM Lightweight para el laboratorio SGSI
# Reemplaza Elasticsearch/Kibana/Wazuh por revisión de logs en volumen compartido
# Uso: ./scripts/check-logs.sh [patrón opcional]

set -e

LOG_DIR="/var/lib/docker/volumes/sgsi-logs/_data"
PATTERN="${1:-}"

echo "=============================================="
echo "  SGSI - SIEM Lightweight - Revisión de Logs"
echo "  Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================================="
echo ""

if [ ! -d "$LOG_DIR" ]; then
    echo "❌ Volumen sgsi-logs no encontrado."
    echo "   ¿Está el laboratorio levantado? Ejecuta: docker compose up -d"
    exit 1
fi

echo "📁 Directorio de logs: $LOG_DIR"
echo ""

# Tamaño total de logs
echo "📊 Tamaño de logs por servicio:"
sudo du -sh "$LOG_DIR"/* 2>/dev/null | sort -h
echo ""

# Archivos vacíos (posible IF-07 — borrado de logs)
EMPTY_FILES=$(sudo find "$LOG_DIR" -type f -size 0 2>/dev/null)
if [ -n "$EMPTY_FILES" ]; then
    echo "⚠️  ALERTA: Logs vacíos detectados (posible IF-07 — borrado evidencias):"
    echo "$EMPTY_FILES"
    echo ""
fi

# Errores de autenticación (A.8.5)
echo "🔐 Intentos de autenticación fallidos (A.8.5):"
sudo grep -rhE "FAILED|denied|invalid|authentication" "$LOG_DIR" 2>/dev/null | tail -20
echo ""

# Patrones de SQL injection (para SW-01, SW-06)
echo "💉 Patrones de SQL injection (SW-01, SW-06):"
sudo grep -rhE "SQL|inject|union|select.*from|--|;.*drop" "$LOG_DIR" 2>/dev/null | tail -20
echo ""

# Accesos a endpoints sensibles (HW-02+03 perimeter bypass)
echo "🚪 Accesos a /admin/ y /logs/ (HW-02+03 evasión):"
sudo grep -rhE "/admin/|/logs/|/api/" "$LOG_DIR" 2>/dev/null | tail -20
echo ""

# Borrar logs (IF-07)
echo "🗑️  Comandos DELETE en logs (IF-07):"
sudo grep -rhE "DELETE|rm .*log|truncate" "$LOG_DIR" 2>/dev/null | tail -10
echo ""

# Patrón específico si se pasó como argumento
if [ -n "$PATTERN" ]; then
    echo "🔍 Búsqueda personalizada: '$PATTERN'"
    sudo grep -rhE "$PATTERN" "$LOG_DIR" 2>/dev/null | tail -30
    echo ""
fi

echo "=============================================="
echo "  Revisión completada. Resultado guardado en:"
echo "  evidencias/siem/check-logs-$(date +%Y%m%d-%H%M%S).txt"
echo "=============================================="

# Guardar evidencia
OUTPUT="evidencias/siem/check-logs-$(date +%Y%m%d-%H%M%S).txt"
{
    echo "# Evidencia SIEM Lightweight - $(date)"
    echo ""
    echo "Volumen: $LOG_DIR"
    echo "Patrón buscado: ${PATTERN:-ninguno (todos)}"
    echo ""
    sudo du -sh "$LOG_DIR"/* 2>/dev/null
    echo ""
    echo "## Auth failed:"
    sudo grep -rhE "FAILED|denied|invalid|authentication" "$LOG_DIR" 2>/dev/null
    echo ""
    echo "## SQL patterns:"
    sudo grep -rhE "SQL|inject|union|select.*from" "$LOG_DIR" 2>/dev/null
    echo ""
    echo "## Admin/logs access:"
    sudo grep -rhE "/admin/|/logs/|/api/" "$LOG_DIR" 2>/dev/null
} > "$OUTPUT"

echo ""
echo "✅ Evidencia guardada: $OUTPUT"
