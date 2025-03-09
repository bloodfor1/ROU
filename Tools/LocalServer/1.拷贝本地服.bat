echo off
set choice=1
echo -----------------------
echo 1 develop
echo 2 kr.cbt
echo 3 kr.dev.cbt
echo 4 kr.dev.cbt2
echo 5 kr.pre.cbt
echo 6 pre.release1.6.0
echo 7 release1.2.0
echo 8 kr.dev.obt
echo -----------------------


set /p choice=enter number(default 1):

set branch=develop

if %choice%==1 set branch=develop
if %choice%==2 set branch=kr.cbt
if %choice%==3 set branch=kr.dev.cbt
if %choice%==4 set branch=kr.dev.cbt2
if %choice%==5 set branch=kr.pre.cbt
if %choice%==6 set branch=pre.release1.6.0
if %choice%==7 set branch=release1.2.0
if %choice%==8 set branch=kr.dev.obt

echo copy %branch% to local
cd Servers/

call copy_server_bin.bat 10.0.128.201 %branch%
