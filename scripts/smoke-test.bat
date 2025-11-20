@echo off
set RETRIES=10
set SLEEP_TIME=5
set PORT=8081
set URL=http://localhost:%PORT%/

echo Starting smoke test for %URL%

:RETRY
for /L %%i in (1,1,%RETRIES%) do (
    echo Attempt %%i of %RETRIES%...
    powershell -Command "try {Invoke-WebRequest -Uri '%URL%' -UseBasicParsing; exit 0} catch {exit 1}"
    if %ERRORLEVEL%==0 (
        echo Smoke test PASSED!
        exit /b 0
    ) else (
        echo Waiting %SLEEP_TIME% seconds before retry...
        timeout /t %SLEEP_TIME% /nobreak > nul
    )
)

echo Smoke test FAILED!
exit /b 1
