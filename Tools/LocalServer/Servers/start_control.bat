echo off

setlocal
endlocal

echo "start control server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\controlserver.exe conf/ctrl_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\controlserver.exe conf/ctrl_conf.xml
	) else (
		start /MIN controlserver.exe conf/ctrl_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
