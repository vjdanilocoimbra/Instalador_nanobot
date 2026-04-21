@echo off
REM ============================================================
REM  Nanobot - Instalador Leve (launcher)
REM  Executa como administrador o instalador PowerShell
REM ============================================================

title Nanobot - Instalador

REM Verifica se ja esta com privilegios de admin
net session >nul 2>&1
if %errorLevel% == 0 goto :RUN

REM Sem admin - solicita elevacao (metodo padrao, sem truques)
echo.
echo  Solicitando privilegios de administrador...
echo.
powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b 0

:RUN
cd /d "%~dp0"

echo.
echo  ============================================================
echo     NANOBOT - Instalador Leve
echo     Instala Python + ffmpeg + dependencias em 1 clique
echo  ============================================================
echo.
echo  Iniciando instalador grafico...
echo.

REM Executa o PS1 com politica liberada apenas para este processo
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nanobot_requisitos.ps1"

echo.
echo  Instalador encerrado. Pressione uma tecla para fechar.
pause >nul
