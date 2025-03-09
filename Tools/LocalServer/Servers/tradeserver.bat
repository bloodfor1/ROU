echo off

setlocal
endlocal

echo "start trade server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\tradeserver.exe conf/tr_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\tradeserver.exe conf/tr_conf.xml
	) else (
		start /MIN tradeserver.exe conf/tr_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
