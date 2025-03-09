#!/usr/bin/env python
# -*- coding:utf-8 -*-
import sys
import os
sys.path.append(os.path.abspath(os.path.join(sys.path[0], os.path.pardir)))
import platform
import common.file_util as util
import time

env_dist = os.environ
copyFileCounts = 0

ClientPath = util.get_client_project_path()
ConfigPath = util.get_client_config_path()
CodePath = util.get_client_code_path()


def get_execute_path(byte_type):
    if platform.system() == "Windows":
        return "luajit%s.exe" % byte_type
    else:
        return "./luajit%s" % byte_type


def copy_files(source_dir, target_dir, byte_type):
    if os.path.exists(source_dir):
        global copyFileCounts
        print source_dir
        for f in os.listdir(source_dir):
            sourceF = os.path.join(source_dir, f)
            targetF = os.path.join(target_dir, f)

            if os.path.isfile(sourceF) and sourceF.endswith(".lua"):
                if not os.path.exists(target_dir):
                    os.makedirs(target_dir)
                copyFileCounts += 1
                # open(targetF, "wb").write(open(sourceF, "rb").read())
                jitpath = os.path.join(ClientPath, "Luajit%s" % (byte_type))
                os.chdir(jitpath)
                exepath = get_execute_path(byte_type)
                command = exepath + " " + "-bg " + sourceF + " " + targetF
                os.system(command)

            if os.path.isdir(sourceF) and sourceF.find('UnityLuaAPI') == -1:
                copy_files(sourceF, targetF, byte_type)


if __name__ == '__main__':

    args = sys.argv
    # print args
    argsLen = len(args)
    try:
        byte_type = args[1]
        encry_file = args[2]
        targetDir = os.path.join(ConfigPath, "Assets/Resources/LuaSource/Lua%s/Scripts" % byte_type)
        f = encry_file[encry_file.index("Scripts")+len("Scripts/Lua/"):]
        target_f = os.path.join(targetDir, f)
        target_f_dir = os.path.dirname(target_f)
        if not os.path.exists(target_f_dir):
            os.makedirs(target_f_dir)
        jitpath = os.path.join(ClientPath, "Luajit%s" % (byte_type))
        os.chdir(jitpath)
        exepath = get_execute_path(byte_type)
        command = exepath + " " + "-b " + encry_file + " " + target_f
        os.system(command)
    except Exception as info:
        # print "Error '%s' happened on line %d" % (info[0], info[1][1])
        import traceback

        print (traceback.format_exc())
        raw_input("plase @zxz")
    finally:
        pass
