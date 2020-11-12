@echo off

echo Restarting squid instance %1 port %2

SET squid=c:\apps\sd\Squid-3.5\bin\squid.exe
SET inst=c:\apps\sd\scrappy\inf\win\squid\inst-%1

powershell -command "Stop-Process -Id (Get-NetTCPConnection -LocalPort %2).OwningProcess"
%squid% -f %inst%\inst.conf

echo.
