@echo off
REM Script para cambiar a entorno de DESARROLLO

echo.
echo ========================================
echo  Cambiando a DESARROLLO
echo ========================================
echo.

if not exist ".env.development" (
    echo ERROR: No existe el archivo .env.development
    pause
    exit /b 1
)

REM Hacer backup
if exist ".env" (
    copy /Y ".env" ".env.backup" >nul
    echo [OK] Backup creado: .env.backup
)

REM Copiar archivo de desarrollo
copy /Y ".env.development" ".env" >nul
echo [OK] Entorno cambiado a: DEVELOPMENT
echo.

echo Configuracion activa:
echo ---------------------
type .env | findstr /V "^#" | findstr /V "^$"
echo.
echo [!] Recuerda reiniciar el servidor Flask
echo.
pause
