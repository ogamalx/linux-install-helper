@echo off
REM Build a standalone install_helper.exe using PyInstaller.
REM Run from an elevated Command Prompt or PowerShell.

setlocal
if "%PYTHON%"=="" set PYTHON=python

%PYTHON% -m pip install --upgrade pip pyinstaller || goto :error
%PYTHON% -m PyInstaller --onefile --name install_helper app/install_helper.py || goto :error

echo.
echo Build complete. The exe lives at %~dp0dist\install_helper.exe
endlocal
exit /b 0

:error
echo Build failed. Ensure Python 3.10+ is installed and on PATH.
endlocal
exit /b 1
