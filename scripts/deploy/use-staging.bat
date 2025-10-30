@echo off
REM Script para cambiar a entorno de STAGING

echo.
echo ========================================
echo  Cambiando a STAGING
echo ========================================
echo.

if not exist ".env.staging" (
    echo ERROR: No existe el archivo .env.staging
    pause
    exit /b 1
)

REM Hacer backup
if exist ".env" (
    copy /Y ".env" ".env.backup" >nul
    echo [OK] Backup creado: .env.backup
)

REM Copiar archivo de staging
copy /Y ".env.staging" ".env" >nul
echo [OK] Entorno cambiado a: STAGING
echo.

echo Configuracion activa:
echo ---------------------
type .env | findstr /V "^#" | findstr /V "^$"
echo.
echo [!] Recuerda reiniciar el servidor Flask
echo.
pause
