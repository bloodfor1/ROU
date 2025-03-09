#coding=utf-8

import os
import sys
import subprocess 
# import commands

if __name__ == '__main__':
    source_path = sys.argv[1]
    dest_path = "/storage/emulated/0/Android/data/com.joyyou.ro/files/AssetBundles"
    adb_connect_cmd = "adb connect 127.0.0.1:7555"
    adb_push_cmd = "adb push %s %s" % (source_path,dest_path)
    print(source_path, dest_path)

    # os.system(adb_connect_cmd)
    # tmp = subprocess.Popen(adb_connect_cmd, shell=True)
    tmp = os.popen(adb_connect_cmd)
    returncode = tmp.close()
    if returncode != None:
        print("连接沐沐模拟器失败", returncode)

    tmp = os.popen(adb_push_cmd)
    returncode = tmp.close()
    if returncode != None:
        print("adb push file fail returncode = ", returncode)
    



