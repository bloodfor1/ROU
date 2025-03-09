echo off

setlocal
endlocal

echo "start pay server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\payserver.exe conf/pay_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\payserver.exe conf/pay_conf.xml
	) else (
		start /MIN payserver.exe conf/pay_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
