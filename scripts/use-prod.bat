@echo off
REM Script para cambiar a entorno de PRODUCCION

echo.
echo ========================================
echo  Cambiando a PRODUCCION
echo ========================================
echo.

if not exist ".env.production" (
    echo ERROR: No existe el archivo .env.production
    pause
    exit /b 1
)

REM Hacer backup
if exist ".env" (
    copy /Y ".env" ".env.backup" >nul
    echo [OK] Backup creado: .env.backup
)

REM Copiar archivo de produccion
copy /Y ".env.production" ".env" >nul
echo [OK] Entorno cambiado a: PRODUCTION
echo.

echo [!] ATENCION: Estas usando configuracion de PRODUCCION
echo [!] Base de datos: AWS RDS
echo [!] Debug: Desactivado
echo.
echo [!] Recuerda reiniciar el servidor Flask
echo.
pause
