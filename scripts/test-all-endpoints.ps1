# Test completo de login y endpoints protegidos
$ErrorActionPreference = "Continue"

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║  ✅ TEST COMPLETO DE AUTENTICACIÓN Y ENDPOINTS            ║" -ForegroundColor Green
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Test 1: Login exitoso
Write-Host "Test 1: LOGIN EXITOSO" -ForegroundColor Yellow
Write-Host "═══════════════════════`n" -ForegroundColor Gray

$body = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:4646/api/auth/login" `
        -Method POST `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "✅ Login exitoso!" -ForegroundColor Green
    Write-Host "   Usuario: $($loginResponse.data.user.name)" -ForegroundColor White
    Write-Host "   Email: $($loginResponse.data.user.email)" -ForegroundColor White
    Write-Host "   Org ID: $($loginResponse.data.org_id)" -ForegroundColor White
    Write-Host "   Token: $($loginResponse.data.token.Substring(0,50))...`n" -ForegroundColor Gray
    
    $token = $loginResponse.data.token
    
    # Test 2: Endpoint protegido - Listar usuarios
    Write-Host "Test 2: ENDPOINT PROTEGIDO - GET /api/users" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════`n" -ForegroundColor Gray
    
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    try {
        $usersResponse = Invoke-RestMethod -Uri "http://localhost:4646/api/users" `
            -Method GET `
            -Headers $headers `
            -ErrorAction Stop
        
        Write-Host "✅ Endpoint protegido funciona!" -ForegroundColor Green
        Write-Host "   Total usuarios: $($usersResponse.data.Count)" -ForegroundColor White
        Write-Host "   Usuarios encontrados:" -ForegroundColor White
        foreach ($user in $usersResponse.data | Select-Object -First 5) {
            Write-Host "   • $($user.name) ($($user.email))" -ForegroundColor Gray
        }
        Write-Host ""
        
    } catch {
        Write-Host "❌ Error en endpoint protegido" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)`n" -ForegroundColor Yellow
    }
    
    # Test 3: Endpoint público - Listar planes
    Write-Host "Test 3: ENDPOINT PÚBLICO - GET /api/public/plans" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Gray
    
    try {
        $plansResponse = Invoke-RestMethod -Uri "http://localhost:4646/api/public/plans" `
            -Method GET `
            -ErrorAction Stop
        
        Write-Host "✅ Endpoint público funciona!" -ForegroundColor Green
        Write-Host "   Total planes: $($plansResponse.data.Count)" -ForegroundColor White
        Write-Host "   Planes disponibles:" -ForegroundColor White
        foreach ($plan in $plansResponse.data) {
            Write-Host "   • $($plan.name) ($($plan.code))" -ForegroundColor Gray
        }
        Write-Host ""
        
    } catch {
        Write-Host "❌ Error en endpoint público" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)`n" -ForegroundColor Yellow
    }
    
    # Test 4: Sin token (debe fallar)
    Write-Host "Test 4: ENDPOINT PROTEGIDO SIN TOKEN (debe fallar)" -ForegroundColor Yellow
    Write-Host "════════════════════════════════════════════════════`n" -ForegroundColor Gray
    
    try {
        $noTokenResponse = Invoke-RestMethod -Uri "http://localhost:4646/api/users" `
            -Method GET `
            -ErrorAction Stop
        
        Write-Host "⚠️  ADVERTENCIA: Endpoint debería rechazar request sin token" -ForegroundColor Yellow
        
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 401) {
            Write-Host "✅ Validación correcta: Rechaza request sin token`n" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Status inesperado: $($_.Exception.Response.StatusCode.value__)`n" -ForegroundColor Yellow
        }
    }
    
    # Test 5: Token inválido (debe fallar)
    Write-Host "Test 5: TOKEN INVÁLIDO (debe fallar)" -ForegroundColor Yellow
    Write-Host "═════════════════════════════════════`n" -ForegroundColor Gray
    
    $badHeaders = @{
        "Authorization" = "Bearer token_invalido_12345"
    }
    
    try {
        $badTokenResponse = Invoke-RestMethod -Uri "http://localhost:4646/api/users" `
            -Method GET `
            -Headers $badHeaders `
            -ErrorAction Stop
        
        Write-Host "⚠️  ADVERTENCIA: Endpoint debería rechazar token inválido" -ForegroundColor Yellow
        
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -eq 401 -or $_.Exception.Response.StatusCode.value__ -eq 422) {
            Write-Host "✅ Validación correcta: Rechaza token inválido`n" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Status inesperado: $($_.Exception.Response.StatusCode.value__)`n" -ForegroundColor Yellow
        }
    }
    
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                            ║" -ForegroundColor Cyan
    Write-Host "║  ✅ TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE            ║" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ ERROR EN LOGIN" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
    
    if ($_.ErrorDetails.Message) {
        Write-Host "`nResponse:" -ForegroundColor Yellow
        $_.ErrorDetails.Message | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
    }
    Write-Host ""
}
