@echo off
echo 重启中...请稍后
docker exec -it ro_dev  bash r
echo 重启成功...进入ro_gsa
docker exec -it ro_dev screen -x ro_gsa