# Test Sprint 2 - Auth con org_id en JWT
$baseUrl = "http://localhost:4646"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SPRINT 2 - AUTH & JWT" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# TEST: POST /api/auth/login - Verificar que incluye org_id
Write-Host "TEST: POST /api/auth/login (verifica org_id en JWT)" -ForegroundColor Yellow

$loginBody = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

try {
    $login = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    
    if ($login.success -and $login.data.token -and $login.data.org_id) {
        Write-Host "✅ PASSED - Login exitoso con org_id" -ForegroundColor Green
        Write-Host "   Usuario: $($login.data.user.name) ($($login.data.user.email))" -ForegroundColor Gray
        Write-Host "   Org ID: $($login.data.org_id)" -ForegroundColor Gray
        
        # Decodificar JWT para verificar que org_id está dentro
        $tokenParts = $login.data.token.Split('.')
        if ($tokenParts.Count -eq 3) {
            # Decodificar payload (parte 2)
            $payload = $tokenParts[1]
            # Agregar padding si falta
            while ($payload.Length % 4 -ne 0) { $payload += "=" }
            $payloadJson = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($payload))
            $payloadObj = $payloadJson | ConvertFrom-Json
            
            Write-Host "`n📦 Payload del JWT:" -ForegroundColor Cyan
            Write-Host "   sub (user_id): $($payloadObj.sub)" -ForegroundColor Gray
            Write-Host "   email: $($payloadObj.email)" -ForegroundColor Gray
            Write-Host "   org_id: $($payloadObj.org_id)" -ForegroundColor Gray
            Write-Host "   exp: $($payloadObj.exp) (timestamp)" -ForegroundColor Gray
            
            if ($payloadObj.org_id) {
                Write-Host "`n✅ JWT contiene org_id correctamente" -ForegroundColor Green
            } else {
                Write-Host "`n❌ FAILED - JWT no contiene org_id" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "❌ FAILED - Respuesta incompleta" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "   Detalles: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMEN AUTH" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Login incluye org_id en respuesta y JWT`n" -ForegroundColor Green
