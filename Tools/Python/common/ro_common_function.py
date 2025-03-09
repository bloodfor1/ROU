#!/usr/bin/python
# -*- encoding: UTF-8 -*-
"""定义一些公共函数

create by tm
"""
import datetime
import os
import commands
import sys
import re
import common.file_util as file_util


def log(step,msg,bPrintToScreen=False):
    logPath = os.path.join(file_util.get_tool_path(), "Python/log")
    if not os.path.exists(logPath):
        os.makedirs(logPath)
    nowTime = datetime.datetime.now()
    today = nowTime.strftime("%Y_%m_%d")
    logName = logPath + "/" + today + ".log"
    time = nowTime.strftime("%H:%M:%S.")+nowTime.strftime('%f')[:3]
    f = open(logName, "a")
    line = "%s[%s] %s\n"%(time,step,msg)
    f.write(line)
    f.close()

    if bPrintToScreen:
        printf(line)


def printf(messAge):
    if sys.platform == 'win32':
        print str(messAge).decode('utf-8').encode('gbk')
    else:
        print str(messAge)


def findFiles(rootDir,extensions=None):
    fileList = []
    for parent,dirnames,filenames in os.walk(rootDir):
        for filename in filenames:
            if extensions != None:
                for tmp in extensions:
                    if filename.endswith(tmp):
                        fileList.append((parent,filename))
            else:
                fileList.append((parent,filename))
    return fileList


def getInputByCommon(tip,commons):
    while True:
        printf(tip)
        ipt = raw_input("input:")
        if ipt in commons:
            break
    return ipt


def getLang():
    appXml = common_define.PROJECT_COMMON_PATH+"/client/res/config/app.xml"
    appXmlFP = open(appXml, 'r')
    xmlContent = appXmlFP.read()
    appXmlFP.close()
    xmlArray=re.findall("app_lang=\"(.+?)\"", xmlContent)
    return xmlArray[0]


def getBaseInfoXml():
    lang = getLang()
    pathXml = common_define.PROJECT_PATH+"/res/"+lang+"/noUpdateFiles/baseInfo.xml"
    baseInfoContent = open(pathXml, 'r')
    xmlContent = baseInfoContent.read()
    baseInfoContent.close()
    xmlArray=re.findall("<base_version>(.+?)</base_version>", xmlContent)
    return xmlArray[0]


def familyFtpUpload(ftpType):
    ftpCmd = ""
    if ftpType=="ios":
        ftpCmd = 'rm actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.ipa; '+\
                 'put '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.ipa; '+\
                 'put '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.plist'
    elif ftpType == "android":
        if (common_define.CHANNEL == "haixing") or (common_define.CHANNEL == "testing"):
            ftpCmd = 'rm actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk; '+\
                     'put '+common_define.PROJECT_PATH+'/publish/mztgame/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk'
        else:
            ftpCmd = 'rm actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk; '+\
                     'put '+common_define.PROJECT_PATH+'/publish/android/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk'
    elif ftpType == "qr":
        ftpCmd = 'put '+common_define.SCRIPT_DIR+'/qr_'+common_define.CHANNEL+'_'+common_define.VERSION+'.png'
    else:
        return 1
    status=os.system('ping -c 3 -t 3 10.1.14.133')
    if status == 0:
        localCommd = '/usr/local/bin/lftp << EOF; '+'open 10.1.14.133; '+'user gameapk 123u123u.gameapk; '+'cd jieji; '+ftpCmd+'; '+'bye; '+'EOF'
        os.system(localCommd)
    else:
        return 1


def intranetFtpUpload(ftpType):
    ftpCmd = ""
    if ftpType == "ios":
        ftpCmd = 'rm actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.ipa; '+\
                 'put '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.ipa; '\
                 'put '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.plist'
    elif ftpType == "android":
        if (common_define.CHANNEL == "haixing") or (common_define.CHANNEL == "testing"):
            ftpCmd = 'rm actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk; '+\
                     'put '+common_define.PROJECT_PATH+'/publish/mztgame/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk'
        else:
            ftpCmd = 'rm actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk; '+\
                     'put '+common_define.PROJECT_PATH+'/publish/android/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk'
    elif ftpType == "qr":
        ftpCmd = 'put '+common_define.SCRIPT_DIR+'/qr_'+common_define.CHANNEL+'_'+common_define.VERSION+'.png'
    else:
        return 1
    status = os.system('ping -c 3 -t 3 10.1.14.133')
    if status == 0:
        localCommd = '/usr/local/bin/lftp<<EOF; '+'open 10.1.14.133; '+'user gameapk 123u123u.gameapk; '+'cd testing/jieji; '+ftpCmd+'; '+'bye; '+'EOF'
        os.system(localCommd)
    else:
        return 1


def fileserverCopy(copyType):
    (status, SMB)= commands.getstatusoutput('df -h | grep 10.0.127.120/public')
    if SMB:
        if copyType == "ios":
            localCommd ='cp '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.ipa ~/mnt/actgame/版本/ios/; '+\
                        'cp '+common_define.PROJECT_PATH+'/publish/ios/actgame_ios_'+common_define.CHANNEL+'_'+common_define.VERSION+'.zip ~/mnt/actgame/版本/ios/'
            os.system(localCommd)
        elif copyType == "android":
            if (common_define.CHANNEL == "haixing") or (common_define.CHANNEL == "testing"):
                os.system('cp '+common_define.PROJECT_PATH+'/publish/mztgame/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk ~/mnt/actgame/版本/android/')
            else:
                os.system('cp '+common_define.PROJECT_PATH+'/publish/android/actgame_android_'+common_define.CHANNEL+'_'+common_define.VERSION+'.apk ~/mnt/actgame/版本/android/')
        elif copyType == "qr":
            os.system('cp '+common_define.SCRIPT_DIR+'/qr_'+common_define.CHANNEL+'_'+common_define.VERSION+'.png ~/mnt/actgame/qrcode/')
        else:
            return 1
    else :
        return 1


def reportGameadm(status="", log="", percent="", package_info=""):
    if common_define.TASK_ID:
        os.system('curl "http://10.0.128.219:8080/report.php" -d "task_id='+common_define.TASK_ID+'&status='\

                  +status+'&log='+log+'&percent='+percent+'&package_info='+package_info+'"')
def adPack(apkFile):
    apkDir=common_define.PROJECT_PATH+'/publish/mztgame/${'+apkFile+':0:${#'+apkFile+'}-4}'
    if not os.path.isfile(common_define.PROJECT_PATH+'/publish/mztgame/'+apkFile):
        log("adPack", apkFile+" does not exist.", True)
        return 1
    if not os.path.isfile(common_define.TOOL_PROJECT_PATH+'/../compile/ad/code'):
        log("adPack", "ad code does not exist.", True)
        return 1
    if os.path.isdir(apkDir):
        os.system('rm -rf '+apkDir)


if __name__ == "__main__":
    getInputByCommon("check input:Y/N",["Y","N"])