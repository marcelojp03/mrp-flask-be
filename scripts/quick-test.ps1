# Script simple para ver el error del servidor
$ErrorActionPreference = "Continue"

Write-Host "`n🧪 PRUEBA SIMPLE DE LOGIN`n" -ForegroundColor Yellow

$body = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

Write-Host "Enviando request a http://localhost:4646/api/auth/login..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4646/api/auth/login" `
        -Method POST `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "✅ SUCCESS!" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10 | Write-Host
    
} catch {
    Write-Host "❌ ERROR!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Yellow
    
    if ($_.ErrorDetails.Message) {
        Write-Host "`nResponse Body:" -ForegroundColor Yellow
        $_.ErrorDetails.Message | Write-Host -ForegroundColor White
    }
}

Write-Host "`n💡 RECOMENDACIÓN:" -ForegroundColor Cyan
Write-Host "   Revisa la terminal donde corre Flask para ver el error completo`n" -ForegroundColor White
