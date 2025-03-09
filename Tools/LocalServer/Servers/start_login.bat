echo off

setlocal
endlocal

echo "start login server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\loginserver.exe conf/login_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\loginserver.exe conf/login_conf.xml
	) else (
		start /MIN loginserver.exe conf/login_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
