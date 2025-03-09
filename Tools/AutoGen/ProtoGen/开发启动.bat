echo off

setlocal
endlocal

echo "start protogen"

start ProtoGen.exe all

REM ping 127.0.0.1 -n 1 > nul