# Test GET /api/menu endpoint
$baseUrl = "http://localhost:4646"

Write-Host "`n=== TEST: GET /api/menu ===" -ForegroundColor Cyan

# 1. Login para obtener token
$loginBody = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.data.token
    Write-Host "✅ Login exitoso, token obtenido" -ForegroundColor Green
    
    # 2. GET /api/menu con token
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    $menuResponse = Invoke-RestMethod -Uri "$baseUrl/api/menu" -Method GET -Headers $headers
    Write-Host "`n✅ GET /api/menu - SUCCESS" -ForegroundColor Green
    Write-Host "Respuesta:" -ForegroundColor Yellow
    $menuResponse | ConvertTo-Json -Depth 10
    
    if ($menuResponse.data.Count -eq 0) {
        Write-Host "`n⚠️  NOTA: El menú está vacío porque el usuario no tiene roles asignados" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "`n❌ ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    if ($_.ErrorDetails.Message) {
        Write-Host "Detalles:" $_.ErrorDetails.Message
    }
}
