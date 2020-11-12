@echo off

SET txt=output\ip-%3.txt
SET old=output\ip-%3.old

set reboot=no
if "%1"=="reboot" set reboot=yes
if "%1"=="reconnect" set reboot=yes
if "%reboot%"=="yes" (

    powershell -command "echo $null >> %txt%"
    powershell -command "echo $null >> %old%"

    powershell -command "Add-Content -Path %txt% -Value ''"
    powershell -command "Add-Content -Path %txt% -Value (Get-Content %old%)"
    powershell -command "Get-Content -Path %txt% | Select-Object -First 5 | Set-Content %old%"

)

py cmd\e8372_control.py %1 %2
echo.