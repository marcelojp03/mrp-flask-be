# ============================================
# Script para modificar backup SQL
# Configura el search_path para esquema 'mrp'
# ============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$SqlFile
)

if (-not (Test-Path $SqlFile)) {
    Write-Host "❌ Error: Archivo no encontrado: $SqlFile" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== MODIFICANDO ARCHIVO SQL PARA ESQUEMA MRP ===" -ForegroundColor Cyan
Write-Host "Archivo: $SqlFile"
Write-Host ""

# Leer contenido
$content = Get-Content $SqlFile -Raw -Encoding UTF8

# 1. Comentar la línea problemática
Write-Host "🔧 Paso 1: Comentando search_path vacío..." -ForegroundColor Yellow
$content = $content -replace "SELECT pg_catalog\.set_config\('search_path', '', false\);", "-- SELECT pg_catalog.set_config('search_path', '', false);"

# 2. Agregar configuración de esquema mrp
Write-Host "🔧 Paso 2: Agregando SET search_path TO mrp..." -ForegroundColor Yellow

$schemaConfig = @"
-- =====================================================
-- CONFIGURAR ESQUEMA MRP
-- =====================================================
SET search_path TO mrp, public;

"@

# Buscar la línea "SET row_security = off;" y agregar después
$content = $content -replace "(SET row_security = off;)", "`$1`n$schemaConfig"

# 3. Guardar archivo modificado
$backupFile = $SqlFile -replace "\.sql$", "_original.sql"
Write-Host "💾 Paso 3: Guardando backup original como: $backupFile" -ForegroundColor Yellow
Copy-Item $SqlFile $backupFile -Force

Write-Host "💾 Paso 4: Guardando archivo modificado..." -ForegroundColor Yellow
$content | Set-Content $SqlFile -Encoding UTF8

Write-Host ""
Write-Host "✅ Archivo modificado exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 RESUMEN:" -ForegroundColor Cyan
Write-Host "  - Archivo original guardado como: $backupFile"
Write-Host "  - Archivo modificado: $SqlFile"
Write-Host "  - Cambios aplicados:"
Write-Host "    ✓ search_path vacío comentado"
Write-Host "    ✓ SET search_path TO mrp, public agregado"
Write-Host ""
Write-Host "🚀 PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "  1. Conéctate a tu base de datos AWS 'vpayDB'"
Write-Host "  2. Ejecuta: CREATE SCHEMA IF NOT EXISTS mrp;"
Write-Host "  3. Ejecuta el archivo SQL modificado"
Write-Host ""
