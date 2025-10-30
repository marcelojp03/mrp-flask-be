# Test Sprint 2 - Endpoints Públicos (SaaS signup)
$baseUrl = "http://localhost:4646"
$testOrg = "TestCompany_$(Get-Random -Maximum 9999)"
$testEmail = "admin_$(Get-Random -Maximum 9999)@test.com"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SPRINT 2 - ENDPOINTS PÚBLICOS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# === TEST 1: GET /api/public/plans ===
Write-Host "TEST 1: GET /api/public/plans" -ForegroundColor Yellow
try {
    $plans = Invoke-RestMethod -Uri "$baseUrl/api/public/plans" -Method GET
    if ($plans.success -and $plans.data.Count -gt 0) {
        Write-Host "✅ PASSED - $($plans.data.Count) planes encontrados" -ForegroundColor Green
        $plans.data | ForEach-Object {
            Write-Host "   - $($_.name) ($($_.code)): $($_.price_monthly) USD/mes" -ForegroundColor Gray
        }
    } else {
        Write-Host "❌ FAILED - No hay planes activos" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
}

# === TEST 2: POST /api/public/signup - Campos faltantes ===
Write-Host "`nTEST 2: POST /api/public/signup (sin campos)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/public/signup" -Method POST -Body '{}' -ContentType "application/json" -ErrorAction Stop
    Write-Host "❌ FAILED - Debería rechazar request vacío" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ PASSED - Rechaza correctamente (400)" -ForegroundColor Green
    } else {
        Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# === TEST 3: POST /api/public/signup - Contraseña corta ===
Write-Host "`nTEST 3: POST /api/public/signup (contraseña corta)" -ForegroundColor Yellow
$shortPwBody = @{
    org_name = "Test Org"
    org_code = "TEST"
    admin_name = "Admin"
    admin_email = "admin@test.com"
    password = "123"
    plan_code = "free"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/public/signup" -Method POST -Body $shortPwBody -ContentType "application/json" -ErrorAction Stop
    Write-Host "❌ FAILED - Debería rechazar contraseña corta" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "✅ PASSED - Rechaza contraseña <6 caracteres (400)" -ForegroundColor Green
    } else {
        Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# === TEST 4: POST /api/public/signup - Registro exitoso ===
Write-Host "`nTEST 4: POST /api/public/signup (registro completo)" -ForegroundColor Yellow
$signupBody = @{
    org_name = $testOrg
    org_code = "TST$(Get-Random -Maximum 999)"
    admin_name = "Test Admin"
    admin_email = $testEmail
    password = "test123456"
    plan_code = "free"
} | ConvertTo-Json

try {
    $signup = Invoke-RestMethod -Uri "$baseUrl/api/public/signup" -Method POST -Body $signupBody -ContentType "application/json"
    
    if ($signup.success -and $signup.data.token) {
        Write-Host "✅ PASSED - Cuenta creada con token JWT" -ForegroundColor Green
        Write-Host "   Usuario: $($signup.data.user.name) ($($signup.data.user.email))" -ForegroundColor Gray
        Write-Host "   Org ID: $($signup.data.org_id)" -ForegroundColor Gray
        Write-Host "   Token: $($signup.data.token.Substring(0,50))..." -ForegroundColor Gray
        
        # Guardar token para siguientes tests
        $global:testToken = $signup.data.token
        $global:testOrgId = $signup.data.org_id
        $global:testUserId = $signup.data.user.id
    } else {
        Write-Host "❌ FAILED - Respuesta sin token" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "   Detalles: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
}

# === TEST 5: POST /api/public/signup - Email duplicado ===
Write-Host "`nTEST 5: POST /api/public/signup (email duplicado)" -ForegroundColor Yellow
$dupBody = @{
    org_name = "Another Org"
    org_code = "ANO$(Get-Random -Maximum 999)"
    admin_name = "Another Admin"
    admin_email = $testEmail  # Email ya registrado
    password = "test123456"
    plan_code = "free"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/public/signup" -Method POST -Body $dupBody -ContentType "application/json" -ErrorAction Stop
    Write-Host "❌ FAILED - Debería rechazar email duplicado" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "✅ PASSED - Rechaza email duplicado (409 Conflict)" -ForegroundColor Green
    } else {
        Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMEN ENDPOINTS PÚBLICOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Ejecutados 5 tests de signup/plans" -ForegroundColor Green
Write-Host "📧 Email test: $testEmail" -ForegroundColor Gray
Write-Host "🏢 Org test: $testOrg`n" -ForegroundColor Gray
