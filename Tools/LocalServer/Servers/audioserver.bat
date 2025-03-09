echo off

setlocal
endlocal

echo "start audio server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\audioserver.exe conf/audio_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\audioserver.exe conf/audio_conf.xml
	) else (
		start /MIN audioserver.exe conf/audio_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
