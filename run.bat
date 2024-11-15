@echo off

REM 设置执行策略为RemoteSigned
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process"

REM 使用临时文件捕获PowerShell的输出和错误
set tempOutputFile=%temp%\ps_output.txt
set tempErrorFile=%temp%\ps_error.txt

REM 运行PowerShell脚本并捕获输出和错误
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "fish.ps1" 1>%tempOutputFile% 2>%tempErrorFile%

REM 显示PowerShell脚本的输出
type %tempOutputFile%

REM 检查是否有错误输出
if exist %tempErrorFile% (
    echo 发生错误:
    type %tempErrorFile%
)

REM 清理临时文件
del %tempOutputFile%
del %tempErrorFile%

REM 防止窗口立即关闭
pause