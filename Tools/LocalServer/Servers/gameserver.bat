echo off

setlocal
endlocal

echo "start gameserver"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\gameserver.exe conf/gs_conf1.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\gameserver.exe conf/gs_conf1.xml
	) else (
		start /MIN gameserver.exe conf/gs_conf1.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
