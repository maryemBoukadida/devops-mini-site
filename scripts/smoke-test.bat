@echo off
setlocal enabledelayedexpansion

set RETRY=0
:CHECK
curl -s http://localhost:8081 > nul
if %ERRORLEVEL% EQU 0 (
    echo PASSED
    exit /b 0
) else (
    set /a RETRY+=1
    if !RETRY! GEQ 10 (
        echo FAILED
        exit /b 1
    )
    echo Waiting for container to be ready... Retry !RETRY!
    timeout /t 3 > nul
    goto CHECK
)
