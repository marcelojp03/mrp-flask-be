# Script PowerShell para cambiar entre entornos
# Uso: .\switch-env.ps1 development|staging|production

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('development', 'staging', 'production')]
    [string]$Environment
)

$SourceFile = ".env.$Environment"
$TargetFile = ".env"
$BackupFile = ".env.backup"

# Verificar que existe el archivo fuente
if (-not (Test-Path $SourceFile)) {
    Write-Host "❌ No existe el archivo: $SourceFile" -ForegroundColor Red
    exit 1
}

# Hacer backup del .env actual
if (Test-Path $TargetFile) {
    Copy-Item $TargetFile $BackupFile -Force
    Write-Host "📦 Backup creado: .env.backup" -ForegroundColor Yellow
}

# Copiar el nuevo entorno
Copy-Item $SourceFile $TargetFile -Force

Write-Host "✅ Entorno cambiado a: $($Environment.ToUpper())" -ForegroundColor Green
Write-Host "   Archivo activo: .env" -ForegroundColor Cyan
Write-Host "   Fuente: .env.$Environment" -ForegroundColor Cyan

# Mostrar configuración (ocultando valores sensibles)
Write-Host "`n📋 Configuración activa:" -ForegroundColor Cyan
Get-Content $TargetFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith('#')) {
        if ($line -match 'PASSWORD|SECRET|KEY|PASS') {
            $key = $line.Split('=')[0]
            Write-Host "   $key=***OCULTO***" -ForegroundColor DarkGray
        } else {
            Write-Host "   $line" -ForegroundColor Gray
        }
    }
}

Write-Host "`n🚀 Recuerda reiniciar el servidor Flask para aplicar los cambios" -ForegroundColor Yellow
