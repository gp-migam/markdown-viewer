@echo off
setlocal
if "%~1"=="" (
  echo Usage: mdviewer.cmd "path\to\file.md"
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0mdviewer.ps1" "%~1"
endlocal
