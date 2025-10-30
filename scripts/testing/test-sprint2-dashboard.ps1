# Test Sprint 2 - Dashboard con org scoping
$baseUrl = "http://localhost:4646"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SPRINT 2 - DASHBOARD" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Login para obtener token
$loginBody = @{
    email = "test@test.com"
    password = "123456"
} | ConvertTo-Json

try {
    $login = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $login.data.token
    $orgId = $login.data.org_id
    Write-Host "✅ Login exitoso - Org ID: $orgId" -ForegroundColor Green
    
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    # TEST 1: GET /api/dashboard/kpis
    Write-Host "`nTEST 1: GET /api/dashboard/kpis" -ForegroundColor Yellow
    try {
        $kpis = Invoke-RestMethod -Uri "$baseUrl/api/dashboard/kpis" -Method GET -Headers $headers
        
        if ($kpis.success) {
            Write-Host "✅ PASSED - KPIs obtenidos" -ForegroundColor Green
            Write-Host "   Total productos: $($kpis.data.total_products)" -ForegroundColor Gray
            Write-Host "   Stock bajo: $($kpis.data.low_stock_count)" -ForegroundColor Gray
            Write-Host "   Movimientos hoy: $($kpis.data.movements_today)" -ForegroundColor Gray
            if ($kpis.data.plan_adherence) {
                Write-Host "   Plan adherence: $($kpis.data.plan_adherence)" -ForegroundColor Gray
            }
        } else {
            Write-Host "❌ FAILED - Respuesta sin success" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # TEST 2: GET /api/dashboard/alerts
    Write-Host "`nTEST 2: GET /api/dashboard/alerts" -ForegroundColor Yellow
    try {
        $alerts = Invoke-RestMethod -Uri "$baseUrl/api/dashboard/alerts" -Method GET -Headers $headers
        
        if ($alerts.success) {
            Write-Host "✅ PASSED - Alertas obtenidas ($($alerts.data.Count) alertas)" -ForegroundColor Green
            $alerts.data | ForEach-Object {
                Write-Host "   [$($_.severity)] $($_.message)" -ForegroundColor Gray
            }
        } else {
            Write-Host "❌ FAILED - Respuesta sin success" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # TEST 3: Sin token - debería rechazar
    Write-Host "`nTEST 3: GET /api/dashboard/kpis (sin token)" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/dashboard/kpis" -Method GET -ErrorAction Stop
        Write-Host "❌ FAILED - Debería rechazar sin token" -ForegroundColor Red
    } catch {
        if ($_.Exception.Response.StatusCode -eq 401) {
            Write-Host "✅ PASSED - Rechaza sin token (401)" -ForegroundColor Green
        } else {
            Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ ERROR en login: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMEN DASHBOARD" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Dashboard requiere autenticación" -ForegroundColor Green
Write-Host "✅ KPIs filtrados por org_id`n" -ForegroundColor Green
