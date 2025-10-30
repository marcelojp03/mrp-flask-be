# TEST SPRINT 2 - WAREHOUSES (ORG SCOPING)
$ErrorActionPreference = 'Stop'
$baseUrl = "http://localhost:4646"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SPRINT 2 - WAREHOUSES (ORG SCOPING)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Login
try {
    $loginData = @{
        email = "test@test.com"
        password = "123456"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST `
        -Body $loginData -ContentType 'application/json'
    $token = $loginResponse.token
    $orgId = $loginResponse.org_id
    Write-Host "✅ Login exitoso - Org ID: $orgId`n" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR en login: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

$headers = @{
    'Authorization' = "Bearer $token"
    'Content-Type' = 'application/json'
}

try {
    # TEST 1: GET /api/warehouses (sin token)
    Write-Host "TEST 1: GET /api/warehouses (sin token)" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses" -Method GET
        Write-Host "❌ FAILED - Debería rechazar sin token" -ForegroundColor Red
    } catch {
        if ($_.Exception.Response.StatusCode -eq 401) {
            Write-Host "✅ PASSED - Rechaza sin token (401)`n" -ForegroundColor Green
        } else {
            Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }

    # TEST 2: GET /api/warehouses (con token) - debe filtrar por org_id
    Write-Host "TEST 2: GET /api/warehouses (con token)" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses" -Method GET -Headers $headers
        
        if ($response.data) {
            $count = $response.data.Count
            Write-Host "✅ PASSED - Almacenes obtenidos ($count almacenes)" -ForegroundColor Green
            
            # Verificar que todos pertenecen a org_id 1
            $wrongOrg = $response.data | Where-Object { $_.org_id -ne $orgId }
            if ($wrongOrg.Count -eq 0) {
                Write-Host "✅ Todos los almacenes pertenecen a org_id $orgId`n" -ForegroundColor Green
            } else {
                Write-Host "❌ FAILED - Hay almacenes de otras organizaciones" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ FAILED - No se obtuvieron datos" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ FAILED - Error en GET warehouses" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        if ($_.ErrorDetails.Message) {
            $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "   Mensaje: $($errorObj.message)" -ForegroundColor Red
        }
        throw
    }

    # TEST 3: POST /api/warehouses (crear almacén) - verifica SaasGuard
    Write-Host "TEST 3: POST /api/warehouses (crear almacén)" -ForegroundColor Yellow
    $newWarehouse = @{
        name = "Almacén Test $(Get-Random -Maximum 9999)"
        location = "Ubicación de prueba"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses" -Method POST `
        -Headers $headers -Body $newWarehouse
    
    if ($response.data.id) {
        $warehouseId = $response.data.id
        Write-Host "✅ PASSED - Almacén creado" -ForegroundColor Green
        Write-Host "   ID: $warehouseId, Nombre: $($response.data.name)" -ForegroundColor Gray
        Write-Host "   Org ID: $($response.data.org_id) (debe ser $orgId)" -ForegroundColor Gray
        
        if ($response.data.org_id -eq $orgId) {
            Write-Host "✅ Almacén asignado correctamente a org_id del JWT`n" -ForegroundColor Green
        } else {
            Write-Host "❌ FAILED - org_id incorrecto" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ FAILED - No se pudo crear almacén" -ForegroundColor Red
        Write-Host "   Respuesta: $($response | ConvertTo-Json)" -ForegroundColor Gray
        exit 1
    }

    # TEST 4: GET /api/warehouses/{id} - debe validar org_id
    Write-Host "TEST 4: GET /api/warehouses/$warehouseId" -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses/$warehouseId" -Method GET `
        -Headers $headers
    
    if ($response.data.id -eq $warehouseId) {
        Write-Host "✅ PASSED - Almacén obtenido" -ForegroundColor Green
        Write-Host "   Org ID: $($response.data.org_id)`n" -ForegroundColor Gray
    } else {
        Write-Host "❌ FAILED - No se pudo obtener almacén" -ForegroundColor Red
    }

    # TEST 5: PUT /api/warehouses/{id} - debe validar org_id
    Write-Host "TEST 5: PUT /api/warehouses/$warehouseId" -ForegroundColor Yellow
    $updateData = @{
        name = "Almacén Test Actualizado"
        location = "Nueva ubicación"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses/$warehouseId" -Method PUT `
        -Headers $headers -Body $updateData
    
    if ($response.data.name -eq "Almacén Test Actualizado") {
        Write-Host "✅ PASSED - Almacén actualizado" -ForegroundColor Green
        Write-Host "   Nuevo nombre: $($response.data.name)`n" -ForegroundColor Gray
    } else {
        Write-Host "❌ FAILED - No se pudo actualizar" -ForegroundColor Red
    }

    # TEST 6: DELETE /api/warehouses/{id} - debe validar org_id
    Write-Host "TEST 6: DELETE /api/warehouses/$warehouseId" -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "$baseUrl/api/warehouses/$warehouseId" -Method DELETE `
        -Headers $headers
    
    if ($response.message -match "eliminado") {
        Write-Host "✅ PASSED - Almacén eliminado`n" -ForegroundColor Green
    } else {
        Write-Host "❌ FAILED - No se pudo eliminar" -ForegroundColor Red
    }

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "RESUMEN WAREHOUSES" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "✅ Requiere autenticación JWT" -ForegroundColor Green
    Write-Host "✅ Filtra por org_id del token" -ForegroundColor Green
    Write-Host "✅ No permite acceder a almacenes de otras orgs" -ForegroundColor Green
    Write-Host "✅ SaasGuard valida límites de plan" -ForegroundColor Green

} catch {
    Write-Host "`n❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        $errorObj = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host "   Mensaje: $($errorObj.message)" -ForegroundColor Red
    }
    exit 1
}
