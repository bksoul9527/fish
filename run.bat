@echo off
REM 设置执行策略为RemoteSigned
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process"

REM 运行你的PowerShell脚本
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "fish.ps1"