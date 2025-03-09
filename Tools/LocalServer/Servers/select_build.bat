@echo off

setlocal enabledelayedexpansion
set servers[0]=controlserver
set servers[1]=gameserver
set servers[2]=audioserver
set servers[3]=dbserver
set servers[4]=masterserver
set servers[5]=tradeserver
set servers[6]=battleserver
set servers[7]=gateserver

call :display_servers
::默认值为-1，全部编译服务器
set a=-1
set /p a=Please select the server index what you would want to build[default all]:
::echo %a%

call :build_gamelibs

if %a% equ -1 (
    goto :process_all_server
) else (
    if %a% lss 0 (
        goto :process_all_server
    )
    if %a% gtr 7 (
        goto :process_all_server
    )
    goto :process_server
)

:process_all_server
    call :build_all_server
    call :copy_all_server
    ::echo "aaaaa"
    goto :end

:process_server
    call :build_server %a%
    call :copy_server %a%
    ::echo "bbbbbb"

:end
endlocal
echo  ------------------------------------------------------
pause
exit /b 0

rem 函数定义在这里
:display_servers
echo index  server
for /l %%n in (0, 1, 7) do (
    echo   %%n    !servers[%%n]!
)
exit /b 0

:build_all_server
for /l %%n in (0, 1, 7) do (
    call :build_server %%n
)
exit /b 0

:copy_all_server
for /l %%n in (0, 1, 7) do (
    call :copy_server %%n
)
exit /b 0

:copy_server
set local_index=%~1
echo "[CUSTOM]copy !servers[%local_index%]!"
copy ..\..\..\..\roserver\winproject\exe\!servers[%local_index%]!.exe !servers[%local_index%]!.exe
exit /b 0

:build_server
set local_index=%~1
rem echo %local_index%
echo "[CUSTOM]begin compile !servers[%local_index%]!"
msbuild "..\..\..\..\roserver\winproject\!servers[%local_index%]!\!servers[%local_index%]!.vcxproj" /t:build /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile !servers[%local_index%]! failed"
	goto error
)
echo "[CUSTOM]compile !servers[%local_index%]! success"
echo  ------------------------------------------------------
exit /b 0

:build_gamelibs
echo "[CUSTOM]begin compile rocommongamelibs"
msbuild ..\..\..\..\rogamelibs\proj.win32\rocommongamelibs.vcxproj /t:build /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
    color c
    echo "[CUSTOM]compile rocommongamelibs failed"
    goto error
)
echo "[CUSTOM]compile rocommongamelibs success"
echo  ------------------------------------------------------
echo "[CUSTOM]begin compile rogamelibs"
msbuild ..\..\..\..\rogamelibs\proj.win32\rogamelibs.vcxproj /t:build /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile rogamelibs failed"
	goto error
)
echo "[CUSTOM]compile rogamelibs success"
echo  ------------------------------------------------------
exit /b 0


:error
echo "[CUSTOM]ERROR: compile with errors, please check it"
exit /b 0

pause
