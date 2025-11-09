# ============================================
# Script de Backup y Restore PostgreSQL
# De DB local 'mrp' a AWS RDS 'vpayDB' esquema 'mrp'
# ============================================

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "help",
    
    [Parameter(Mandatory=$false)]
    [string]$BackupFile = "",
    
    [Parameter(Mandatory=$false)]
    [string]$RdsEndpoint = "",
    
    [Parameter(Mandatory=$false)]
    [string]$RdsUser = "postgres",
    
    [Parameter(Mandatory=$false)]
    [string]$LocalUser = "postgres"
)

$PG_BIN = "C:\Program Files\PostgreSQL\17\bin"
$BACKUP_DIR = "C:\backups\mrp"

# Crear directorio de backups si no existe
if (-not (Test-Path $BACKUP_DIR)) {
    New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
}

function Show-Help {
    Write-Host ""
    Write-Host "=== BACKUP Y RESTORE PostgreSQL ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "USO:" -ForegroundColor Yellow
    Write-Host "  .\backup_and_restore.ps1 -Action <accion> [opciones]"
    Write-Host ""
    Write-Host "ACCIONES:" -ForegroundColor Yellow
    Write-Host "  backup             - Crear backup de DB local 'mrp'"
    Write-Host "  restore            - Restaurar backup en AWS RDS esquema 'mrp'"
    Write-Host "  backup-and-restore - Hacer backup y restaurar en un solo paso"
    Write-Host "  list               - Listar backups disponibles"
    Write-Host ""
    Write-Host "OPCIONES:" -ForegroundColor Yellow
    Write-Host "  -BackupFile <file>    - Archivo de backup (para restore)"
    Write-Host "  -RdsEndpoint <host>   - Endpoint de RDS AWS"
    Write-Host "  -RdsUser <user>       - Usuario de RDS (default: postgres)"
    Write-Host "  -LocalUser <user>     - Usuario local (default: postgres)"
    Write-Host ""
    Write-Host "EJEMPLOS:" -ForegroundColor Yellow
    Write-Host "  # Crear backup"
    Write-Host "  .\backup_and_restore.ps1 -Action backup"
    Write-Host ""
    Write-Host "  # Restaurar backup"
    Write-Host "  .\backup_and_restore.ps1 -Action restore -BackupFile 'C:\backups\mrp\backup_20251107.sql' -RdsEndpoint 'mydb.us-east-1.rds.amazonaws.com'"
    Write-Host ""
    Write-Host "  # Backup y restore automático"
    Write-Host "  .\backup_and_restore.ps1 -Action backup-and-restore -RdsEndpoint 'mydb.us-east-1.rds.amazonaws.com'"
    Write-Host ""
}

function Create-Backup {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = Join-Path $BACKUP_DIR "backup_mrp_$timestamp.sql"
    
    Write-Host ""
    Write-Host "=== CREANDO BACKUP ===" -ForegroundColor Cyan
    Write-Host "Base de datos local: mrp"
    Write-Host "Archivo destino: $backupFile"
    Write-Host ""
    
    # Hacer backup como SQL plano para poder modificarlo
    & "$PG_BIN\pg_dump.exe" `
        -h localhost `
        -U $LocalUser `
        -d mrp `
        -F p `
        --no-owner `
        --no-privileges `
        -f $backupFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Backup creado exitosamente: $backupFile" -ForegroundColor Green
        
        # Modificar el SQL para usar el esquema 'mrp'
        Write-Host "🔧 Modificando SQL para esquema 'mrp'..." -ForegroundColor Yellow
        
        $content = Get-Content $backupFile -Raw
        
        # Agregar SET search_path al inicio
        $newContent = "-- Restaurar en esquema mrp`n"
        $newContent += "SET search_path TO mrp, public;`n`n"
        $newContent += $content
        
        # Guardar archivo modificado
        $newContent | Set-Content $backupFile -Encoding UTF8
        
        Write-Host "✅ SQL modificado para esquema 'mrp'" -ForegroundColor Green
        
        return $backupFile
    } else {
        Write-Host "❌ Error al crear backup" -ForegroundColor Red
        return $null
    }
}

function Restore-Backup {
    param([string]$file, [string]$endpoint)
    
    if (-not (Test-Path $file)) {
        Write-Host "❌ Error: Archivo de backup no encontrado: $file" -ForegroundColor Red
        return $false
    }
    
    if ([string]::IsNullOrWhiteSpace($endpoint)) {
        Write-Host "❌ Error: Debes especificar el endpoint de RDS con -RdsEndpoint" -ForegroundColor Red
        return $false
    }
    
    Write-Host ""
    Write-Host "=== RESTAURANDO BACKUP ===" -ForegroundColor Cyan
    Write-Host "Archivo: $file"
    Write-Host "Destino: $endpoint / vpayDB / esquema mrp"
    Write-Host ""
    
    # Paso 1: Crear esquema si no existe
    Write-Host "📝 Creando esquema 'mrp' si no existe..." -ForegroundColor Yellow
    
    & "$PG_BIN\psql.exe" `
        -h $endpoint `
        -U $RdsUser `
        -d vpayDB `
        -c "CREATE SCHEMA IF NOT EXISTS mrp;"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️ Advertencia: No se pudo crear el esquema (puede que ya exista)" -ForegroundColor Yellow
    }
    
    # Paso 2: Restaurar el backup
    Write-Host "📦 Restaurando datos..." -ForegroundColor Yellow
    
    & "$PG_BIN\psql.exe" `
        -h $endpoint `
        -U $RdsUser `
        -d vpayDB `
        -f $file
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Restore completado exitosamente" -ForegroundColor Green
        
        # Verificar tablas restauradas
        Write-Host ""
        Write-Host "📊 Verificando tablas en esquema 'mrp'..." -ForegroundColor Yellow
        & "$PG_BIN\psql.exe" `
            -h $endpoint `
            -U $RdsUser `
            -d vpayDB `
            -c "SELECT schemaname, tablename FROM pg_tables WHERE schemaname = 'mrp' ORDER BY tablename;"
        
        return $true
    } else {
        Write-Host "❌ Error al restaurar backup" -ForegroundColor Red
        return $false
    }
}

function List-Backups {
    Write-Host ""
    Write-Host "=== BACKUPS DISPONIBLES ===" -ForegroundColor Cyan
    Write-Host "Directorio: $BACKUP_DIR"
    Write-Host ""
    
    if (Test-Path $BACKUP_DIR) {
        $backups = Get-ChildItem -Path $BACKUP_DIR -Filter "backup_mrp_*.sql" | Sort-Object LastWriteTime -Descending
        
        if ($backups.Count -eq 0) {
            Write-Host "No hay backups disponibles" -ForegroundColor Yellow
        } else {
            $backups | ForEach-Object {
                $size = "{0:N2} MB" -f ($_.Length / 1MB)
                Write-Host ("{0,-40} {1,10}  {2}" -f $_.Name, $size, $_.LastWriteTime) -ForegroundColor White
            }
            Write-Host ""
            Write-Host "Total: $($backups.Count) backups" -ForegroundColor Cyan
        }
    } else {
        Write-Host "El directorio de backups no existe todavía" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Main
switch ($Action.ToLower()) {
    "backup" {
        Create-Backup
    }
    "restore" {
        if ([string]::IsNullOrWhiteSpace($BackupFile)) {
            Write-Host "❌ Error: Debes especificar el archivo de backup con -BackupFile" -ForegroundColor Red
            Write-Host ""
            Write-Host "Usa: .\backup_and_restore.ps1 -Action list" -ForegroundColor Yellow
            Write-Host "Para ver los backups disponibles" -ForegroundColor Yellow
            exit 1
        }
        Restore-Backup -file $BackupFile -endpoint $RdsEndpoint
    }
    "backup-and-restore" {
        $backupFile = Create-Backup
        if ($backupFile) {
            Write-Host ""
            Write-Host "⏳ Esperando 3 segundos antes de restaurar..." -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            Restore-Backup -file $backupFile -endpoint $RdsEndpoint
        }
    }
    "list" {
        List-Backups
    }
    default {
        Show-Help
    }
}
