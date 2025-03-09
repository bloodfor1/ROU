echo off

setlocal
endlocal

echo "start master server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\masterserver.exe conf/ms_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\masterserver.exe conf/ms_conf.xml
	) else (
		start /MIN masterserver.exe conf/ms_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
