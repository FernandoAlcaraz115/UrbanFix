@echo off
setlocal enabledelayedexpansion
title UrbanFix - Centro de Despacho C4 Morelia
color 0B

cls
echo ============================================================
echo   URBANFIX - SISTEMA DE REPORTE CIUDADANO INTELIGENTE
echo        H. Ayuntamiento de Morelia, Michoacan
echo ============================================================
echo.
echo [*] Cobertura: Morelia, Michoacan (Centro, Camelinas, La Huerta)
echo [*] Arquitectura: Panel Web Admin (React) + Servidor en Vivo + App Movil (Flutter)
echo.

where node >nul 2>nul
if %errorlevel% neq 0 goto no_node

:: 1. Iniciar Servidor en Vivo de UrbanFix (Puerto 3001)
echo [*] Iniciando Servidor en Vivo C4 Morelia (Puerto 3001)...
start "UrbanFix Live Server (C4 Morelia)" cmd.exe /c "title UrbanFix Live Server && cd /d "%~dp0server" && node index.js"

:: 2. Verificar dependencias de Admin
cd /d "%~dp0admin"
if not exist "node_modules\" (
    echo [!] Instalando dependencias de Admin...
    call npm.cmd install
    if %errorlevel% neq 0 goto install_failed
)

:: 3. Iniciar Panel Web Admin (Vite)
echo.
echo ------------------------------------------------------------
echo  Servidor en Vivo activo en: http://localhost:3001
echo  Iniciando Panel Web en:     http://localhost:5173
echo.
echo  Para ejecutar la App Movil en otra terminal:
echo    cd mobile
echo    flutter run -d chrome
echo ------------------------------------------------------------
echo.

call npm.cmd run dev -- --open
if %errorlevel% neq 0 goto run_failed
goto end

:no_node
echo.
echo [ERROR] Node.js no esta instalado o no se encuentra en el PATH.
echo.
pause
exit /b 1

:install_failed
echo.
echo [ERROR] Ocurrio un error al instalar las dependencias con npm.
echo.
pause
exit /b 1

:run_failed
echo.
echo [ERROR] El servidor se detuvo de forma inesperada.
echo.
pause
exit /b 1

:end
pause
