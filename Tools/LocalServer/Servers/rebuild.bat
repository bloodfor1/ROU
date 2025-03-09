@echo off

echo "[CUSTOM]begin compile rocommongamelibs"
msbuild ..\..\..\..\rogamelibs\proj.win32\rocommongamelibs.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile rocommongamelibs failed"
	goto error
)
echo "[CUSTOM]compile rocommongamelibs success"

echo "[CUSTOM]begin compile rogamelibs"
msbuild ..\..\..\..\rogamelibs\proj.win32\rogamelibs.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile rogamelibs failed"
	goto error
)
echo "[CUSTOM]compile rogamelibs success"

echo "[CUSTOM]begin compile controlserver"
msbuild ..\..\..\..\roserver\winproject\controlserver\controlserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile controlserver failed"
	goto error
)
echo "[CUSTOM]compile controlserver success"

echo "[CUSTOM]begin compile dbserver"
msbuild ..\..\..\..\roserver\winproject\dbserver\dbserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile dbserver failed"
	goto error
)
echo "[CUSTOM]compile dbserver success"

echo "[CUSTOM]begin compile gameserver"
msbuild ..\..\..\..\roserver\winproject\gameserver\gameserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile gameserver failed"
	goto error
)
echo "[CUSTOM]compile gameserver success"

echo "[CUSTOM]begin compile gateserver"
msbuild ..\..\..\..\roserver\winproject\gateserver\gateserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile gateserver failed"
	goto error
)
echo "[CUSTOM]compile gateserver success"

::msbuild ..\..\..\..\roserver\winproject\loginserver\loginserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
::if %errorlevel%==1 (
::	echo "[CUSTOM]compile loginserver failed"
::	goto error
::)
::echo "[CUSTOM]compile loginserver success"

echo "[CUSTOM]begin compile masterserver"
msbuild ..\..\..\..\roserver\winproject\masterserver\masterserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile masterserver failed"
	goto error
)
echo "[CUSTOM]compile masterserver success"

echo "[CUSTOM]begin compile tradeserver"
msbuild ..\..\..\..\roserver\winproject\tradeserver\tradeserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile tradeserver failed"
	goto error
)
echo "[CUSTOM]compile tradeserver success"

rem echo "[CUSTOM]begin compile proxyserver"
rem msbuild ..\..\..\..\roserver\winproject\proxyserver\proxyserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
rem if %errorlevel%==1 (
rem 	color c
rem 	echo "[CUSTOM]compile proxyserver failed"
rem 	goto error
rem )
rem echo "[CUSTOM]compile proxyserver success"

echo "[CUSTOM]begin compile battleserver"
msbuild ..\..\..\..\roserver\winproject\battleserver\battleserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile battleserver failed"
	goto error
)
echo "[CUSTOM]compile battleserver success"

echo "[CUSTOM]begin compile audioserver"
msbuild ..\..\..\..\roserver\winproject\audioserver\audioserver.vcxproj /t:Rebuild /p:Configuration=Debug;Platform=x64
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]compile audioserver failed"
	goto error
)
echo "[CUSTOM]compile audioserver success"


goto success

:error
echo "[CUSTOM]ERROR: compile with errors, please check it"
goto end

:success
echo "[CUSTOM]all servers compile success begin copy resources"
call update.bat
if %errorlevel%==1 (
	color c
	echo "[CUSTOM]copy resources failed"
	goto end
)
echo "[CUSTOM]copy resources success"

:end
pause