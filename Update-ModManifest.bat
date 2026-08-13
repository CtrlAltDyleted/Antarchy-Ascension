@echo off
cd /d "%~dp0"

echo.
echo === ANTARCHY MOD MANIFEST ===
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\tools\Update-ModManifest.ps1"

echo.
pause
