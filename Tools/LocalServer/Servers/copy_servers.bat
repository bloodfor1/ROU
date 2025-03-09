echo off

set globalvar=110

echo "copy server to local"

set remoteIp=%1
set buildType=%2
set "mypath=\\%remoteIp%\localserver\develop"

if "%buildType%"=="common-stable" (
	set "mypath=\\%remoteIp%\localserver-stable"
)

@echo %mypath%

echo "[CUSTOM]begin copy controlserver"
copy %mypath%\controlserver.exe .
echo "[CUSTOM]finish copy controlserver"

echo "[CUSTOM]begin copy masterserver"
copy %mypath%\masterserver.exe .
echo "[CUSTOM]finish copy masterserver\n"

echo "[CUSTOM]begin copy gameserver"
copy %mypath%\gameserver.exe .
echo "[CUSTOM]finish copy gameserver\n"


echo "[CUSTOM]begin copy dbserver"
copy %mypath%\dbserver.exe .
echo "[CUSTOM]finish copy dbserver\n"


echo "[CUSTOM]begin copy audioserver"
copy %mypath%\audioserver.exe .
echo "[CUSTOM]finish copy audioserver\n"


echo "[CUSTOM]begin copy battleserver"
copy %mypath%\battleserver.exe .
echo "[CUSTOM]finish copy battleserver\n"

echo "[CUSTOM]begin copy gateserver"
copy %mypath%\gateserver.exe .
echo "[CUSTOM]finish copy gateserver\n"

echo "[CUSTOM]begin copy payserver"
copy %mypath%\payserver.exe .
echo "[CUSTOM]finish copy payserver\n"

echo "[CUSTOM]begin copy tradeserver"
copy %mypath%\tradeserver.exe .
echo "[CUSTOM]finish copy tradeserver\n"



setlocal
endlocal
