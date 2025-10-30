# Script PowerShell para probar login
# Uso: .\test-login.ps1

$baseUrl = "http://localhost:4646"

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  🧪 PRUEBA DE LOGIN" -ForegroundColor Yellow
Write-Host "============================================================`n" -ForegroundColor Cyan

# Test 1: Login exitoso
Write-Host "Test 1: Login con usuario de prueba" -ForegroundColor Yellow
Write-Host "============================================`n" -ForegroundColor Gray

$loginData = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

Write-Host "📤 Request:" -ForegroundColor Green
Write-Host "   URL: $baseUrl/api/auth/login"
Write-Host "   Method: POST"
Write-Host "   Body: $loginData`n"

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/auth/login" `
        -Method POST `
        -Body $loginData `
        -ContentType "application/json" `
        -TimeoutSec 10 `
        -ErrorAction Stop
    
    Write-Host "📥 Response:" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode) $($response.StatusDescription)" -ForegroundColor Green
    Write-Host "   Body:" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
    
    Write-Host "`n✅ LOGIN EXITOSO`n" -ForegroundColor Green
    
    # Extraer token
    $responseData = $response.Content | ConvertFrom-Json
    if ($responseData.data.token) {
        $token = $responseData.data.token
        Write-Host "🔑 Token obtenido: $($token.Substring(0, [Math]::Min(50, $token.Length)))...`n" -ForegroundColor Cyan
        
        # Test 2: Endpoint protegido
        Write-Host "`n============================================================" -ForegroundColor Cyan
        Write-Host "Test 2: Endpoint protegido (GET /api/users)" -ForegroundColor Yellow
        Write-Host "============================================`n" -ForegroundColor Gray
        
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        
        Write-Host "📤 Request:" -ForegroundColor Green
        Write-Host "   URL: $baseUrl/api/users"
        Write-Host "   Method: GET"
        Write-Host "   Authorization: Bearer $($token.Substring(0, 30))...`n"
        
        try {
            $protectedResponse = Invoke-WebRequest -Uri "$baseUrl/api/users" `
                -Method GET `
                -Headers $headers `
                -TimeoutSec 10 `
                -ErrorAction Stop
            
            Write-Host "📥 Response:" -ForegroundColor Green
            Write-Host "   Status: $($protectedResponse.StatusCode)" -ForegroundColor Green
            $protectedResponse.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
            
            Write-Host "`n✅ ENDPOINT PROTEGIDO FUNCIONA`n" -ForegroundColor Green
            
        } catch {
            Write-Host "📥 Response:" -ForegroundColor Red
            Write-Host "   Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "`n❌ ERROR EN ENDPOINT PROTEGIDO`n" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "📥 Response:" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "   Status: $statusCode" -ForegroundColor Red
        
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Body: $responseBody" -ForegroundColor Red
        
        if ($statusCode -eq 401) {
            Write-Host "`n❌ LOGIN FALLÓ: Credenciales inválidas`n" -ForegroundColor Red
        } elseif ($statusCode -eq 500) {
            Write-Host "`n❌ ERROR DEL SERVIDOR (500)`n" -ForegroundColor Red
            Write-Host "💡 Revisa los logs del servidor Flask para más detalles`n" -ForegroundColor Yellow
        } else {
            Write-Host "`n❌ LOGIN FALLÓ`n" -ForegroundColor Red
        }
    } else {
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($_.Exception.Message -like "*Unable to connect*" -or $_.Exception.Message -like "*No connection*") {
            Write-Host "`n❌ ERROR: No se puede conectar al servidor" -ForegroundColor Red
            Write-Host "   ¿Está corriendo Flask en el puerto 4646?" -ForegroundColor Yellow
            Write-Host "   Inicia el servidor con: python run.py`n" -ForegroundColor Cyan
        } else {
            Write-Host "`n❌ ERROR INESPERADO`n" -ForegroundColor Red
        }
    }
}

# Test 3: Credenciales incorrectas
Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "Test 3: Login con credenciales incorrectas" -ForegroundColor Yellow
Write-Host "============================================`n" -ForegroundColor Gray

$wrongData = @{
    email = "test@test.com"
    password = "wrong_password"
} | ConvertTo-Json

Write-Host "📤 Request:" -ForegroundColor Green
Write-Host "   Body: $wrongData`n"

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/auth/login" `
        -Method POST `
        -Body $wrongData `
        -ContentType "application/json" `
        -TimeoutSec 10 `
        -ErrorAction Stop
    
    Write-Host "⚠️  Se esperaba error 401 pero se recibió:" -ForegroundColor Yellow
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor Yellow
    
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "✅ VALIDACIÓN CORRECTA (Rechaza credenciales inválidas)`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Status inesperado: $($_.Exception.Response.StatusCode.value__)`n" -ForegroundColor Yellow
    }
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  PRUEBAS COMPLETADAS" -ForegroundColor Yellow
Write-Host "============================================================`n" -ForegroundColor Cyan
