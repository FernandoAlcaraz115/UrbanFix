@echo off
chcp 65001 >nul
title UrbanFix - Panel Administrativo Municipal (Morelia)
color 0B

cd /d "%~dp0admin"

cls
echo ============================================================
echo   URBANFIX - SISTEMA DE REPORTE CIUDADANO INTELIGENTE
echo        H. Ayuntamiento de Morelia, Michoacan
echo ============================================================
echo.
echo  [*] Ubicacion del proyecto: %~dp0admin
echo  [*] Cobertura: Morelia, Michoacan (Centro, Camelinas, La Huerta, etc.)
echo  [*] Modo: Panel de Control Municipal y Despacho C4
echo.

:: Verificar si Node.js esta instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado o no se encuentra en el PATH.
    echo Por favor instala Node.js desde https://nodejs.org/ para continuar.
    echo.
    pause
    exit /b 1
)

:: Verificar si node_modules existe
if not exist "node_modules\" (
    echo [!] No se detecto la carpeta node_modules.
    echo [*] Instalando dependencias necesarias (npm install)...
    echo.
    call npm install
    if %errorlevel% neq 0 (
        echo.
        echo [ERROR] Fallo la instalacion de dependencias.
        pause
        exit /b 1
    )
    echo.
    echo [OK] Dependencias instaladas correctamente.
    echo.
)

echo ------------------------------------------------------------
echo  Iniciando servidor local y abriendo tu navegador...
echo  Presiona Ctrl + C en esta ventana cuando desees cerrar el servidor.
echo ------------------------------------------------------------
echo.

call npm run dev -- --open

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] El servidor se detuvo con errores.
    pause
)
