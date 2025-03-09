::call setup.bat
call start_control.bat %1 %2
call start_master.bat %1 %2
call gameserver.bat %1 %2
ping -n 1 127.0.0.1 > nul

rem call start_proxy.bat %1 %2
call dbserver.bat %1 %2
call gate.bat %1 %2
::call start_login.bat %1 %2
call tradeserver.bat %1 %2
call battleserver.bat %1 %2
call audioserver.bat %1 %2
call payserver.bat %1 %2