@echo off
REM Test simple pour vérifier que le serveur Docker tourne
curl -s http://localhost:8081  > nul
IF %ERRORLEVEL% EQU 0 (
    echo PASSED
    exit /b 0
) ELSE (
    echo FAILED
    exit /b 1
)
