::@echo off

cd ../../../clientcode/CSProject

echo "begin build MoonCommonLib.dll"
msbuild MoonCommonLib/MoonCommonLib.csproj /t:Rebuild /p:Configuration=UNITY_PC;PostBuildEvent=;Platform=AnyCPU
if %errorlevel% neq 0 (
    color c
    echo "[CUSTOM]compile MoonCommonLib failed"
    goto error
)

if exist ../../rosdk (
	pause
	echo "begin build SDKLib.dll"
	cd ../../rosdk
	msbuild SDKLib/SDKLib.csproj /t:Rebuild /p:Configuration=UNITY_PC;PostBuildEvent=;Platform=AnyCPU
	if %errorlevel% neq 0 (
	    color c
	    echo "[CUSTOM]compile SDKLib failed"
	    goto error
	)
	cd ../../clientcode/CSProject
)

echo "begin build MoonClient.dll"
msbuild MoonClient/MoonClient.csproj /t:Rebuild /p:Configuration=UNITY_PC;PostBuildEvent=;Platform=AnyCPU
if %errorlevel% neq 0 (
    color c
    echo "[CUSTOM]compile MoonClient failed"
    goto error
)

goto end

:error
echo "build dll with error"
pause
exit 1

:end
exit 0