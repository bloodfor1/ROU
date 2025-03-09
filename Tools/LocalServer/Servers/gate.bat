echo off

setlocal
endlocal

echo "start gate server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\gateserver.exe conf/gate_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\gateserver.exe conf/gate_conf.xml
	) else (
		start /MIN gateserver.exe conf/gate_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
