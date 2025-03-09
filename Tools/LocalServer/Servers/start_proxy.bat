echo off

setlocal
endlocal

echo "start proxy server"

set buildType=%1
set remoteIp=%2
if "%buildType%"=="common-develop" (
	start /MIN \\%remoteIp%\localserver\proxyserver.exe conf/proxy_conf.xml
) else (
	if "%buildType%"=="common-stable" (
		start /MIN \\%remoteIp%\localserver-stable\proxyserver.exe conf/proxy_conf.xml
	) else (
		start /MIN proxyserver.exe conf/proxy_conf.xml
	)
)

REM ping 127.0.0.1 -n 1 > nul
