# Script para diagnosticar problema de login 401
$ErrorActionPreference = "Continue"

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║  🔍 DIAGNÓSTICO DE LOGIN 401 UNAUTHORIZED                 ║" -ForegroundColor Yellow
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📧 Usuarios disponibles en la base de datos:`n" -ForegroundColor Yellow

# Ejecutar script para ver usuarios
python scripts/check_user_passwords.py

Write-Host "`n🧪 PRUEBA 1: Login con usuario de prueba" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════`n" -ForegroundColor Gray

$testUser = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

Write-Host "📤 Request:" -ForegroundColor Cyan
Write-Host "   Email: test@test.com" -ForegroundColor White
Write-Host "   Password: 123456`n" -ForegroundColor White

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4646/api/auth/login" `
        -Method POST `
        -Body $testUser `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "✅ LOGIN EXITOSO!" -ForegroundColor Green
    Write-Host "   Token: $($response.data.token.Substring(0,50))..." -ForegroundColor Gray
    Write-Host "   Usuario: $($response.data.user.name)" -ForegroundColor White
    Write-Host "   Email: $($response.data.user.email)`n" -ForegroundColor White
    
} catch {
    Write-Host "❌ LOGIN FALLÓ" -ForegroundColor Red
    Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        $errorBody = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Message: $($errorBody.message)" -ForegroundColor Yellow
        Write-Host "   Code: $($errorBody.code)`n" -ForegroundColor Yellow
    }
}

Write-Host "🧪 PRUEBA 2: Login con credenciales INCORRECTAS" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Gray

$wrongUser = @{
    email = "test@test.com"
    password = "wrong_password_123"
} | ConvertTo-Json

Write-Host "📤 Request:" -ForegroundColor Cyan
Write-Host "   Email: test@test.com" -ForegroundColor White
Write-Host "   Password: wrong_password_123 (incorrecta)`n" -ForegroundColor White

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4646/api/auth/login" `
        -Method POST `
        -Body $wrongUser `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "⚠️  ADVERTENCIA: Debería rechazar credenciales incorrectas`n" -ForegroundColor Yellow
    
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "✅ Validación correcta: Rechaza contraseña incorrecta`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Status inesperado: $($_.Exception.Response.StatusCode.value__)`n" -ForegroundColor Yellow
    }
}

Write-Host "🧪 PRUEBA 3: Login con email INEXISTENTE" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════`n" -ForegroundColor Gray

$nonexistentUser = @{
    email = "noexiste@example.com"
    password = "123456"
} | ConvertTo-Json

Write-Host "📤 Request:" -ForegroundColor Cyan
Write-Host "   Email: noexiste@example.com (no existe)" -ForegroundColor White
Write-Host "   Password: 123456`n" -ForegroundColor White

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4646/api/auth/login" `
        -Method POST `
        -Body $nonexistentUser `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "⚠️  ADVERTENCIA: Debería rechazar usuario inexistente`n" -ForegroundColor Yellow
    
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "✅ Validación correcta: Rechaza usuario inexistente`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Status inesperado: $($_.Exception.Response.StatusCode.value__)`n" -ForegroundColor Yellow
    }
}

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║  💡 POSIBLES CAUSAS DEL ERROR 401                         ║" -ForegroundColor Yellow
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "1. ❓ Contraseña incorrecta" -ForegroundColor White
Write-Host "   Solución: Verifica la contraseña que estás usando`n" -ForegroundColor Gray

Write-Host "2. ❓ Usuario no existe" -ForegroundColor White
Write-Host "   Solución: Ejecuta 'python scripts/check_user_passwords.py'`n" -ForegroundColor Gray

Write-Host "3. ❓ Contraseña hasheada incorrectamente" -ForegroundColor White
Write-Host "   Solución: Ejecuta 'python scripts/create_test_user.py'`n" -ForegroundColor Gray

Write-Host "4. ❓ Email con espacios o formato incorrecto" -ForegroundColor White
Write-Host "   Solución: Verifica que no haya espacios en el email`n" -ForegroundColor Gray

Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
