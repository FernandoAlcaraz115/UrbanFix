@echo off
setlocal enabledelayedexpansion
title UrbanFix - Panel Administrativo Morelia
color 0B

cd /d "%~dp0admin"

cls
echo ============================================================
echo   URBANFIX - SISTEMA DE REPORTE CIUDADANO INTELIGENTE
echo        H. Ayuntamiento de Morelia, Michoacan
echo ============================================================
echo.
echo [*] Directorio: %~dp0admin
echo [*] Cobertura: Morelia, Michoacan
echo [*] Sistema: Panel de Control Municipal y Despacho C4
echo.

where node >nul 2>nul
if %errorlevel% neq 0 goto no_node

if not exist "node_modules\" goto do_install
goto run_app

:do_install
echo [!] Instalando dependencias necesarias con npm...
echo.
call npm.cmd install
if %errorlevel% neq 0 goto install_failed
echo.
echo [OK] Dependencias instaladas correctamente.
echo.

:run_app
echo ------------------------------------------------------------
echo  Iniciando servidor local y abriendo tu navegador...
echo  Presiona Ctrl + C en esta ventana para detener el servidor.
echo ------------------------------------------------------------
echo.
call npm.cmd run dev -- --open
if %errorlevel% neq 0 goto run_failed
goto end

:no_node
echo.
echo [ERROR] Node.js no esta instalado o no se encuentra en el PATH.
echo Por favor instala Node.js desde https://nodejs.org/ para continuar.
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
