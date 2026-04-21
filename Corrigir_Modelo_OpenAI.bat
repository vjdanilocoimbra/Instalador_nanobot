@echo off
chcp 65001 >nul 2>&1
title Corrigir modelo para OpenAI gpt-4o-mini

echo.
echo  ============================================================
echo     CORRIGIR MODELO PARA OPENAI GPT-4O-MINI
echo     (se estiver em Claude Opus ou outro modelo caro)
echo  ============================================================
echo.

set "CFG=%USERPROFILE%\.nanobot\config.json"

if not exist "%CFG%" (
    echo  ERRO: config nao encontrado em:
    echo    %CFG%
    echo.
    echo  Rode primeiro o atalho 'Conversar com Nanobot'.
    pause
    exit /b 1
)

echo  Ajustando config...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p = '%CFG%'; $c = [IO.File]::ReadAllText($p, [Text.UTF8Encoding]::new($false)); $c = $c -replace '\"provider\"\s*:\s*\"[^\"]*\"', '\"provider\": \"openai\"'; $c = $c -replace '\"model\"\s*:\s*\"[^\"]*\"', '\"model\": \"gpt-4o-mini\"'; [IO.File]::WriteAllText($p, $c, [Text.UTF8Encoding]::new($false)); Write-Host '   Config ajustado para:' -ForegroundColor Green; Write-Host '     provider: openai' -ForegroundColor Cyan; Write-Host '     model:    gpt-4o-mini' -ForegroundColor Cyan"

echo.
echo  ============================================================
echo     PRONTO!
echo  ============================================================
echo.
echo  Agora voce pode:
echo    1. Abrir o Bloco de Notas pra conferir a chave OpenAI
echo       (ou rodar de novo o atalho 'Conversar com Nanobot')
echo    2. Conversar com a IA
echo.
echo  Custo por mensagem: R$0,006 (menos de 1 centavo).
echo  Com $5 de credito OpenAI, dura 3-6 meses de uso.
echo.
pause
