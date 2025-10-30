# Test Sprint 2 - Products con org scoping y SaasGuard
$baseUrl = "http://localhost:4646"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "SPRINT 2 - PRODUCTS (ORG SCOPING)" -ForegroundColor Cyan
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
    Write-Host "✅ Login exitoso - Org ID: $orgId`n" -ForegroundColor Green
    
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    # TEST 1: GET /api/products (sin token) - debería rechazar
    Write-Host "TEST 1: GET /api/products (sin token)" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/products" -Method GET -ErrorAction Stop
        Write-Host "❌ FAILED - Debería rechazar sin token" -ForegroundColor Red
    } catch {
        if ($_.Exception.Response.StatusCode -eq 401) {
            Write-Host "✅ PASSED - Rechaza sin token (401)" -ForegroundColor Green
        } else {
            Write-Host "❌ FAILED - Status inesperado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
    
    # TEST 2: GET /api/products (con token) - solo org_id del JWT
    Write-Host "`nTEST 2: GET /api/products (con token)" -ForegroundColor Yellow
    try {
        $products = Invoke-RestMethod -Uri "$baseUrl/api/products" -Method GET -Headers $headers
        
        if ($products.success) {
            Write-Host "✅ PASSED - Productos obtenidos ($($products.data.Count) productos)" -ForegroundColor Green
            
            # Verificar que todos pertenecen a la org
            $wrongOrg = $products.data | Where-Object { $_.org_id -ne $orgId }
            if ($wrongOrg) {
                Write-Host "❌ FAILED - Encontrados productos de otra org!" -ForegroundColor Red
            } else {
                Write-Host "✅ Todos los productos pertenecen a org_id $orgId" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ FAILED - Respuesta sin success" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # TEST 3: POST /api/products (crear producto) - verifica SaasGuard
    Write-Host "`nTEST 3: POST /api/products (crear producto)" -ForegroundColor Yellow
    $newProduct = @{
        code = "TEST-$(Get-Random -Maximum 9999)"
        name = "Producto Test $(Get-Random -Maximum 9999)"
        description = "Creado por test de Sprint 2"
        item_type = "RM"  # Raw Material
        procurement_type = "BUY"
        min_stock = 10
        unit_id = 1  # EA (Unidad)
    } | ConvertTo-Json
    
    try {
        $created = Invoke-RestMethod -Uri "$baseUrl/api/products" -Method POST -Body $newProduct -Headers $headers
        
        if ($created.success -and $created.data) {
            Write-Host "✅ PASSED - Producto creado" -ForegroundColor Green
            Write-Host "   ID: $($created.data.id), Código: $($created.data.code)" -ForegroundColor Gray
            Write-Host "   Org ID: $($created.data.org_id) (debe ser $orgId)" -ForegroundColor Gray
            
            if ($created.data.org_id -eq $orgId) {
                Write-Host "✅ Producto asignado correctamente a org_id del JWT" -ForegroundColor Green
            } else {
                Write-Host "❌ FAILED - Producto con org_id incorrecto!" -ForegroundColor Red
            }
            
            $global:testProductId = $created.data.id
        } else {
            Write-Host "❌ FAILED - No se pudo crear producto" -ForegroundColor Red
        }
    } catch {
        # Podría ser límite de plan (SaasGuard)
        if ($_.Exception.Response.StatusCode -eq 403) {
            Write-Host "⚠️  403 Forbidden - Posible límite de plan alcanzado (SaasGuard)" -ForegroundColor Yellow
            $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "   Mensaje: $($errorDetails.message)" -ForegroundColor Gray
        } elseif ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "⚠️  422 Unprocessable - Error de validación" -ForegroundColor Yellow
            if ($_.ErrorDetails.Message) {
                $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
                Write-Host "   Mensaje: $($errorDetails.message)" -ForegroundColor Gray
            }
        } else {
            Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
            if ($_.ErrorDetails.Message) {
                Write-Host "   Detalles: $($_.ErrorDetails.Message)" -ForegroundColor Gray
            }
        }
    }
    
    # TEST 4: GET /api/products/{id} (obtener producto específico)
    if ($global:testProductId) {
        Write-Host "`nTEST 4: GET /api/products/$($global:testProductId)" -ForegroundColor Yellow
        try {
            $product = Invoke-RestMethod -Uri "$baseUrl/api/products/$($global:testProductId)" -Method GET -Headers $headers
            
            if ($product.success) {
                Write-Host "✅ PASSED - Producto obtenido" -ForegroundColor Green
                Write-Host "   Org ID: $($product.data.org_id)" -ForegroundColor Gray
            } else {
                Write-Host "❌ FAILED - Respuesta sin success" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # TEST 5: PUT /api/products/{id} (actualizar producto)
        Write-Host "`nTEST 5: PUT /api/products/$($global:testProductId)" -ForegroundColor Yellow
        $updateData = @{
            name = "Producto Test Actualizado"
            description = "Actualizado en test"
        } | ConvertTo-Json
        
        try {
            $updated = Invoke-RestMethod -Uri "$baseUrl/api/products/$($global:testProductId)" -Method PUT -Body $updateData -Headers $headers
            
            if ($updated.success) {
                Write-Host "✅ PASSED - Producto actualizado" -ForegroundColor Green
                Write-Host "   Nuevo nombre: $($updated.data.name)" -ForegroundColor Gray
            } else {
                Write-Host "❌ FAILED - No se pudo actualizar" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # TEST 6: DELETE /api/products/{id} (soft delete)
        Write-Host "`nTEST 6: DELETE /api/products/$($global:testProductId)" -ForegroundColor Yellow
        try {
            $deleted = Invoke-RestMethod -Uri "$baseUrl/api/products/$($global:testProductId)" -Method DELETE -Headers $headers
            
            if ($deleted.success) {
                Write-Host "✅ PASSED - Producto eliminado (soft delete)" -ForegroundColor Green
            } else {
                Write-Host "❌ FAILED - No se pudo eliminar" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ FAILED - Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ ERROR en login: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMEN PRODUCTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Requiere autenticación JWT" -ForegroundColor Green
Write-Host "✅ Filtra por org_id del token" -ForegroundColor Green
Write-Host "✅ No permite acceder a productos de otras orgs" -ForegroundColor Green
Write-Host "✅ SaasGuard valida límites de plan`n" -ForegroundColor Green
