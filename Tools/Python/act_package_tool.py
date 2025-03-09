#!/usr/bin/python
# -*- encoding: UTF-8 -*-
"""工具入口
   其他的build模块通过这个模块调用打包工具
create by vegicai
"""
import common.act_common_function as utilFunc
import types
import traceback

from components import *


def resetByGit(needReset):
    if False:#needReset:
        os.system('git reset --hard')
        os.system('git clean -xdf')

def getStepFunction(stepName):
        "get tool step from components"
        stepTool = "act_step_%s" % stepName
        module = sys.modules['components']
        if hasattr(module, stepTool):
            return getattr(getattr(module, stepTool),"doStep")
        else:
            return None

def doPackage(toolList,needReset=True):
    """
    Do Package by toolList"""

    for toolArgs in toolList:
        runSusses = True
        if type(toolArgs) is types.StringType:
            toolName = toolArgs
            __func = getStepFunction(toolName)
        else:
            toolName = toolArgs[0]
            __func = getStepFunction(toolName)
        if __func is None:
            utilFunc.log("doPackage","error step:%s" % toolName, True)
            resetByGit(needReset)
            break
        else:
            utilFunc.log("doPackage","Start "+toolName, True)
            try:
                runSusses = __func(toolArgs)

            except Exception , e:
                utilFunc.log("doPackage", traceback.format_exc(), True)
                ipt = utilFunc.getInputByCommon(u"是否执行git还原:Y / N",["Y","N"])
                if ipt == "Y":
                    resetByGit(True)
                sys.exit(1)
                return

            else:
                if runSusses:
                    utilFunc.log("doPackage","End "+toolName, True)
                else:
                    utilFunc.log("doPackage","error "+toolName, True)
                    resetByGit(needReset)
                    sys.exit(1)
                    break

    utilFunc.log("doPackage","completed.", True)

def printStepDoc(toolList):
    for toolArgs in toolList:
        if type(toolArgs) is types.StringType:
            toolName = toolArgs
            __func = getStepFunction(toolName)
        else:
            toolName = toolArgs[0]
            __func = getStepFunction(toolName)
        if __func is None:
            continue

        utilFunc.printf(toolName+":")
        utilFunc.printf("\t"+__func.__doc__)

if __name__ == "__main__":
    doPackage([["simple_crypt","encode"]])