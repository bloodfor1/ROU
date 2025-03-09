@echo off
@hostname>.\ro\ip
for /f "delims=: tokens=2" %%i in ('ipconfig ^| find /i "IPv4"') do echo%%i>>.\ro\ip
cd Servers/
call stop_docker.bat
call start_docker_hy.bat
timeout /T 3 /NOBREAK
docker ps -a
timeout /T 10 /NOBREAK
docker exec -it ro_dev screen -x ro_gsa
