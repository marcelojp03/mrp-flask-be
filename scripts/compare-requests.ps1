# Script para capturar y comparar requests
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║  🔍 COMPARACIÓN: Request Exitoso vs Tu Request            ║" -ForegroundColor Yellow
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "✅ REQUEST QUE FUNCIONA (desde script):`n" -ForegroundColor Green

$workingRequest = @{
    email = "test@test.com"
    password = "123456"
}

Write-Host "Body (JSON):" -ForegroundColor Cyan
$workingRequest | ConvertTo-Json | Write-Host -ForegroundColor White

Write-Host "`nContent-Type: application/json" -ForegroundColor Cyan
Write-Host "Method: POST" -ForegroundColor Cyan
Write-Host "URL: http://localhost:4646/api/auth/login`n" -ForegroundColor Cyan

Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "❌ TU REQUEST (desde Angular):`n" -ForegroundColor Red

Write-Host "Revisa en la consola del navegador (Network tab):" -ForegroundColor Yellow
Write-Host "1. Abre DevTools (F12)" -ForegroundColor White
Write-Host "2. Ve a la pestaña Network" -ForegroundColor White
Write-Host "3. Haz login" -ForegroundColor White
Write-Host "4. Click en la petición 'login'" -ForegroundColor White
Write-Host "5. Ve a 'Headers' > 'Request Payload'`n" -ForegroundColor White

Write-Host "Busca diferencias en:`n" -ForegroundColor Yellow

Write-Host "❓ Headers:" -ForegroundColor Cyan
Write-Host "   • Content-Type: application/json?" -ForegroundColor White
Write-Host "   • Hay algún header extra?`n" -ForegroundColor White

Write-Host "❓ Body:" -ForegroundColor Cyan
Write-Host "   • Email exacto: 'test@test.com'?" -ForegroundColor White
Write-Host "   • Password exacto: '123456'?" -ForegroundColor White
Write-Host "   • Hay espacios extras?" -ForegroundColor White
Write-Host "   • Los nombres de campos son: 'email' y 'password'?`n" -ForegroundColor White

Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "💡 PROBLEMAS COMUNES EN ANGULAR:`n" -ForegroundColor Yellow

Write-Host "1. 🔍 Campos con nombres diferentes:" -ForegroundColor Cyan
Write-Host "   Frontend envía: { username: '...', pass: '...' }" -ForegroundColor Red
Write-Host "   Backend espera: { email: '...', password: '...' }" -ForegroundColor Green
Write-Host ""

Write-Host "2. 🔍 Email o password con espacios:" -ForegroundColor Cyan
Write-Host "   Frontend envía: { email: ' test@test.com ', password: '123456' }" -ForegroundColor Red
Write-Host "   Backend espera: { email: 'test@test.com', password: '123456' }" -ForegroundColor Green
Write-Host ""

Write-Host "3. 🔍 Content-Type incorrecto:" -ForegroundColor Cyan
Write-Host "   Frontend envía: Content-Type: text/plain" -ForegroundColor Red
Write-Host "   Backend espera: Content-Type: application/json" -ForegroundColor Green
Write-Host ""

Write-Host "4. 🔍 Body como FormData en lugar de JSON:" -ForegroundColor Cyan
Write-Host "   Frontend envía: FormData (multipart/form-data)" -ForegroundColor Red
Write-Host "   Backend espera: JSON (application/json)" -ForegroundColor Green
Write-Host ""

Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "🔧 SOLUCIÓN ANGULAR:`n" -ForegroundColor Yellow

Write-Host "Asegúrate que tu código Angular sea así:`n" -ForegroundColor White

Write-Host @"
// login.component.ts
login() {
  const credentials = {
    email: this.loginForm.value.email.trim(),  // .trim() elimina espacios
    password: this.loginForm.value.password
  };

  this.http.post('http://localhost:4646/api/auth/login', credentials, {
    headers: {
      'Content-Type': 'application/json'
    }
  }).subscribe({
    next: (response: any) => {
      console.log('Login exitoso:', response);
      localStorage.setItem('token', response.data.token);
    },
    error: (error) => {
      console.error('Error login:', error);
      console.error('Status:', error.status);
      console.error('Body enviado:', credentials);
    }
  });
}
"@ -ForegroundColor Cyan

Write-Host "`n═══════════════════════════════════════════════════════════`n" -ForegroundColor Gray

Write-Host "🧪 PRUEBA DESDE POSTMAN/CURL:`n" -ForegroundColor Yellow

Write-Host "Postman:" -ForegroundColor Cyan
Write-Host "  POST http://localhost:4646/api/auth/login" -ForegroundColor White
Write-Host "  Headers: Content-Type = application/json" -ForegroundColor White
Write-Host "  Body (raw JSON):" -ForegroundColor White
Write-Host '  { "email": "test@test.com", "password": "123456" }' -ForegroundColor Gray
Write-Host ""

Write-Host "cURL:" -ForegroundColor Cyan
Write-Host @"
curl -X POST http://localhost:4646/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"123456"}'
"@ -ForegroundColor Gray

Write-Host "`n═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
