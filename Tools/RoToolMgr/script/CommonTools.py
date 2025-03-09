import os

class RoToolMgr:
    def __init__(self):
        self.csvFolderLocalPath ="/Table/CSV"
        self.batToolLocalPath = "/Table/Tools/BatTools"
        self.defaultPcPackagePath= "/../exe/ro.exe"
        self.moonClientProjDir = "/CSProject"
        self.csvToolPath = "/Tools/AutoGen/CsvGen/CsvGen.exe"
        self.protoToolPath = "/Tools/AutoGen/ProtoGen/ProtoGen.exe"
        self.buildPcDllToolPath = "/Tools/BuildForPC/build_pc_dll.bat"
        self.exportOfflineToolPath = "/Tools/ExportOffLineExe"
        self.localServerFolder = "/Tools/LocalServer"
        self.pathFindingNavTool = "/Tools/RONavigation"
        pass

    def OpenCSVFolder(self,projPath):
        try:
            os.startfile(projPath+self.csvFolderLocalPath)
        except:
            print("打开失败，未找到对应路径！")

    def OpenBatToolFolder(self,projPath):
        try:
            os.startfile(projPath+self.batToolLocalPath)
        except:
            print("打开失败，未找到对应路径！")

    def OpenMoonClientProjDir(self,projPath):
        try:
            os.startfile(projPath+self.moonClientProjDir)
        except:
            print("打开失败，未找到对应路径！")

    def OpenLocalServerFolder(self,projPath):
        try:
            os.startfile(projPath+self.localServerFolder)
        except:
            print("打开失败，未找到对应路径！")

    def StartRoPcPackage(self,projPath):
        try:
            os.system(projPath+self.defaultPcPackagePath)
        except:
            print("打开失败，未找到对应路径！")

    def OpenCSVTool(self,projPath):
        try:
            os.system(projPath+self.csvToolPath)
        except:
            print("打开失败，未找到对应路径！")

    def OpenProtoTool(self,projPath):
        try:
            os.system(projPath+self.protoToolPath)
        except:
            print("打开失败，未找到对应路径！")

    def BuildPcDllTool(self,projPath):
        try:
            os.system(projPath+self.buildPcDllToolPath)
        except:
            print("打开失败，未找到对应路径！")

    def ExportOffLineTool(self,projPath):
        try:
            os.startfile(projPath+self.exportOfflineToolPath)
        except:
            print("打开失败，未找到对应路径！")

    def PathFindingNavTool(self,projPath):
        try:
            os.startfile(projPath+self.pathFindingNavTool)
        except:
            print("打开失败，未找到对应路径！")