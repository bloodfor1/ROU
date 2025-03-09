#!/usr/bin/python
# -*- encoding: UTF-8 -*-
"""
proto转lua
create by tm
"""

import os
import sys
import platform
if __name__ == "__main__":
    sys.path.append(os.path.split(os.path.realpath(__file__))[0] + "/..")
import common.ro_common_function as utilFunc
import common.file_util as file_util

class ProtocToLua():
    def __init__(self, stepName):
        self.name = stepName
        self.exeDir = os.path.join(file_util.get_client_project_path(), "Tools/Protobuf/ProtoGenLua")

    def __translateOne(self, filename):
        # utilFunc.log(self.name, filename, True)
        if "Windows" == platform.system():
            opt = file_util.get_client_project_path() + '/Tools/Protobuf/protoc.exe --proto_path="%s/"' % file_util.get_proto_config_path() +\
                ' --plugin=protoc-gen-lua="protoc-gen-lua.bat"' +\
                ' --lua_out="%s" %s'%(file_util.get_lua_proto_path(), filename)
            os.system(opt)
        else:
            os.system("protoc --lua_out %s %s" % \
                (file_util.get_lua_proto_path(), filename))

    def __updatePbMgrFile(self):
        f = open(file_util.get_lua_proto_path() + '/PbcMgr.lua', 'w+')
        f.writelines('-- Generated By ro_step_lua_proto.py, Do not Edit\n')
        f.writelines('module("PbcMgr", package.seeall)\n')

        for root, dirs, files in os.walk(file_util.get_lua_proto_path()):
            for file in files:
                fileName, fileExt = os.path.splitext(file)
                # utilFunc.log(self.name, fileExt, True)
                if fileExt == '.lua' and fileName != 'PbcMgr':
                    f.writelines('local l_%s = nil \n\
function get_%s() \n\
    if l_%s == nil then\n\
        l_%s = require("%s")\n\
    end\n\
    return l_%s\n\
end\n' % (fileName, fileName, fileName, fileName, fileName, fileName))

        f.close()

    def doTranslate(self):
        os.chdir(self.exeDir)

        filelist = utilFunc.findFiles(file_util.get_proto_config_path(), [".proto"])
        for fileinfo in filelist:
            self.__translateOne("%s/%s" % (fileinfo[0], fileinfo[1]))

        self.__updatePbMgrFile()

        return True

def doStep(argv):
    '''proto转lua程序
        toolList:"lua_proto"
        需求环境：protoc-gen-lua工具
        参数说明：无'''
    step = ProtocToLua(argv[0])
    return step.doTranslate()

if __name__ == '__main__':
    step = ProtocToLua("ProtocToLua")
    step.doTranslate()