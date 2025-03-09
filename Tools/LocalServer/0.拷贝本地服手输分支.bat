echo off
echo -----------------------
echo 手动输入Git分支进行二进制拷贝
echo -----------------------


set /p choice=输入Git分支(例如 develop):

set branch=%choice%

echo %branch%


echo 准备拷贝 %branch% 到本地
pause
cd Servers/

call copy_server_bin.bat 10.0.128.201 ro_server\ro_%branch%\roserver\Build\Debug\bin
