@echo off

SET txt=output\ip-%1.txt
SET log=output\ip-%1.log
SET old=output\ip-%1.old

SET bind_ip=..\tools\ForceBindIP-1.32\ForceBindIP64
SET wget=..\tools\wget-1.20.3\wget64
SET url=https://api.ipify.org/?format=text

del /q %txt%
del /q %log%

rem echo Getting IP for %1
%bind_ip% %1 %wget% %url% -O %txt% -o %log%

powershell -command "Start-Sleep -s 2"

echo Current IP
powershell -command "Get-Content -Path %txt%"

echo.

echo Old IPs
powershell -command "if (Test-Path -path %old%) { Get-Content -Path %old% }"
