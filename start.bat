@echo off
chcp 65001 >nul
echo ================================
echo   WikiChatbot Backend Launcher
echo ================================
echo.

REM Ch?y PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0run.ps1"

pause
