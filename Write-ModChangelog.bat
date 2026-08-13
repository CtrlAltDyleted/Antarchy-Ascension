@echo off
cd /d "%~dp0"

echo.
echo === ANTARCHY MOD CHANGELOG ===
echo.

set "CHANGELOG_LABEL="
set /p "CHANGELOG_LABEL=Release/version label [Unreleased]: "

if not defined CHANGELOG_LABEL set "CHANGELOG_LABEL=Unreleased"

echo.
echo Refreshing the current manifest and local change report first...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\tools\Update-ModManifest.ps1"
if errorlevel 1 goto :error

echo.
echo Writing Git-tracked mod changelog entry...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\tools\Write-ModChangelog.ps1" -Label "%CHANGELOG_LABEL%"
if errorlevel 1 goto :error

echo.
echo Done.
echo.
pause
exit /b 0

:error
echo.
echo ERROR: Mod changelog generation failed.
echo.
pause
exit /b 1
