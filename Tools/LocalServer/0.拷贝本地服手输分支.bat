echo off
echo -----------------------
echo �ֶ�����Git��֧���ж����ƿ���
echo -----------------------


set /p choice=����Git��֧(���� develop):

set branch=%choice%

echo %branch%


echo ׼������ %branch% ������
pause
cd Servers/

call copy_server_bin.bat 10.0.128.201 ro_server\ro_%branch%\roserver\Build\Debug\bin
