echo off

setlocal
endlocal

echo "start db server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\dbserver.exe conf/db_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\dbserver.exe conf/db_conf.xml
	) else (
		start /MIN dbserver.exe conf/db_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
