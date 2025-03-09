echo off

setlocal
endlocal

echo "start battle server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\battleserver.exe conf/bt_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\battleserver.exe conf/bt_conf.xml
	) else (
		start /MIN battleserver.exe conf/bt_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
