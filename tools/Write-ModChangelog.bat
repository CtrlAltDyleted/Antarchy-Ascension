@echo off
setlocal

set "TOOLS_DIR=%~dp0"
set "REPO_ROOT=%~dp0.."
set "MANIFEST_SCRIPT=%TOOLS_DIR%Update-ModManifest.ps1"
set "CHANGELOG_SCRIPT=%TOOLS_DIR%Write-ModChangelog.ps1"

if not exist "%MANIFEST_SCRIPT%" (
    echo ERROR: Could not find:
    echo %MANIFEST_SCRIPT%
    echo.
    pause
    exit /b 1
)

if not exist "%CHANGELOG_SCRIPT%" (
    echo ERROR: Could not find:
    echo %CHANGELOG_SCRIPT%
    echo.
    pause
    exit /b 1
)

cd /d "%REPO_ROOT%"
if errorlevel 1 (
    echo ERROR: Could not switch to repository root:
    echo %REPO_ROOT%
    echo.
    pause
    exit /b 1
)

echo.
echo === ANTARCHY MOD CHANGELOG ===
echo.

set "CHANGELOG_LABEL="
set /p "CHANGELOG_LABEL=Release/version label [Unreleased]: "

if not defined CHANGELOG_LABEL set "CHANGELOG_LABEL=Unreleased"

echo.
echo Refreshing the current manifest and local change report first...
echo.

pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%MANIFEST_SCRIPT%"
if errorlevel 1 goto :error

echo.
echo Writing Git-tracked mod changelog entry...
echo.

pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%CHANGELOG_SCRIPT%" -Label "%CHANGELOG_LABEL%"
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
