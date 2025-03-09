echo off

set remoteIp=%1
set buildType=%2
set "mypath=\\%remoteIp%\%buildType%"
set to_path=..\ro

if not exist %to_path% md %to_path%


for  %%I in (controlserver,masterserver,gameserver,dbserver,audioserver,battleserver,gateserver,payserver,tradeserver,rankserver) do (
    if exist %mypath%\%%I (
    echo copy %mypath%\%%I to ro
    copy %mypath%\%%I %to_path%
    )
)


pause

setlocal
endlocal
