import json
import os,sys
curPath = os.path.abspath(os.path.dirname(__file__))
rootPath = os.path.split(curPath)[0]
sys.path.append(rootPath)
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QMessageBox
from RoToolMainWindow import Ui_MainWindow
from RoQLineEdit import RoQLineEdit
from CommonTools import RoToolMgr
from GitTool import SimpleGit
from threading import Thread

class MainWindowWidgets(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        #roProjInfo格式例子 self.roProjInfo = {"proj1":{"path":"11111","isChoosing":True},}
        self.roProjInfoDic = {}
        self.projEnviromentInfoDic={}
        self.projInfoCheckWidgetDic={}
        self.gitReposInfoCheckWidgetDic = {}
        self.configFilePath = "./roToolMgrConfig.json"
        self.initConfigInfo(self.configFilePath)
        self.uiMainWindow = None
        self.roToolMgr = RoToolMgr()
        self.gitToolMgr = SimpleGit()

    def initConfigInfo(self,filePath):
        if not os.path.exists(filePath):
            with open(filePath,"w") as file:
                configStr = json.dumps(self.roProjInfoDic)
                file.write(configStr)
                pass

        with open(filePath,"r") as file:
            self.roProjInfoDic = json.loads(file.read())
        for k,v in self.roProjInfoDic.items():
            with open(v["path"],"r") as evnFile:
                self.projEnviromentInfoDic[k] = json.loads(evnFile.read())

    def getSelectedProjEviromentInfo(self):
        for k,v in self.roProjInfoDic.items():
            projWidgets = self.projInfoCheckWidgetDic[k]
            checkWidget = projWidgets["checkBox"]
            if checkWidget.isChecked():
                return self.projEnviromentInfoDic[k]

    def saveConfigInfo(self,filePath:str):
        configStr = json.dumps(self.roProjInfoDic)
        with open(filePath,"w") as file:
            file.write(configStr)

    def initCommonToolClickEvent(self, uiMainWindow:Ui_MainWindow):
        uiMainWindow.openCsvFloderBtn.clicked.connect(self.onOpenCSVFolderClick)
        uiMainWindow.openBatToolFloderBtn.clicked.connect(self.onOpenBatToolClick)
        uiMainWindow.openRoPcPackage.clicked.connect(self.onOpenRoPcPackageClick)
        uiMainWindow.openClientCodeFolder.clicked.connect(self.onOpenClientCodeFolderClick)
        uiMainWindow.openCsvToolBtn.clicked.connect(self.onOpenCsvToolClick)
        uiMainWindow.openProtoGenTool.clicked.connect(self.onOpenProtoGenToolClick)
        uiMainWindow.buildPcDllBtn.clicked.connect(self.onBuildPcDllClick)
        uiMainWindow.exportOfflineDataBtn.clicked.connect(self.onExportOfflineDataClick)
        uiMainWindow.openLocalServerFolder.clicked.connect(self.onOpenLocalServerFolderClick)
        uiMainWindow.openNavTool.clicked.connect(self.onOpenNavToolClick)

    def startToolFailedTip(self):
        QMessageBox.warning(self, "启动失败", "未选择Proj，请从上面的项目列表中勾选至少一个项目！")

    def onAddProjInfoClick(self):
        newProjName = self.addNewProjEnviromentInfo(self.uiMainWindow.lineEdit.text(), self.uiMainWindow)
        print(newProjName)
        self.saveConfigInfo(self.configFilePath)
        self.createGitRepoInfoWidgetsByProjName(self.uiMainWindow, newProjName)

    def onOpenCSVFolderClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.OpenCSVFolder(currentHandleProjBranchInfo["MoonClientConfigPath"])

    def onOpenBatToolClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.OpenBatToolFolder(currentHandleProjBranchInfo["MoonClientConfigPath"])

    def onOpenRoPcPackageClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        t = Thread(target=self.roToolMgr.StartRoPcPackage,args=(currentHandleProjBranchInfo["MoonClientProjPath"],))
        t.start()

    def onOpenClientCodeFolderClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.OpenMoonClientProjDir(currentHandleProjBranchInfo["MoonClientCodePath"])

    def onOpenCsvToolClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        t = Thread(target=self.roToolMgr.OpenCSVTool, args=(currentHandleProjBranchInfo["MoonClientProjPath"],))
        t.start()

    def onOpenProtoGenToolClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        t = Thread(target=self.roToolMgr.OpenProtoTool, args=(currentHandleProjBranchInfo["MoonClientProjPath"],))
        t.start()

    def onBuildPcDllClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        t = Thread(target=self.roToolMgr.BuildPcDllTool, args=(currentHandleProjBranchInfo["MoonClientProjPath"],))
        t.start()

    def onExportOfflineDataClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.ExportOffLineTool(currentHandleProjBranchInfo["MoonClientProjPath"])

    def onOpenLocalServerFolderClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.OpenLocalServerFolder(currentHandleProjBranchInfo["MoonClientProjPath"])

    def onOpenNavToolClick(self):
        currentHandleProjBranchInfo = self.getSelectedProjEviromentInfo()
        if currentHandleProjBranchInfo==None :
            self.startToolFailedTip()
            return
        self.roToolMgr.PathFindingNavTool(currentHandleProjBranchInfo["MoonClientProjPath"])

    def addNewProjEnviromentInfo(self, projPath:str, uiMainWindow):
        projPathStripStr = projPath.strip()
        if projPathStripStr =="":
            return
        if os.path.basename(projPathStripStr)!="sys_env.json":
            return
        dirName = os.path.dirname(projPath)
        parentFolderName = os.path.basename(dirName)
        for key,value in self.roProjInfoDic.items():
            if value["path"] == projPathStripStr:
                return
            if key == parentFolderName:
                parentFolderName=parentFolderName+"#"

        self.roProjInfoDic[parentFolderName]={"path":projPathStripStr, "isChoosing":False}
        self.createProjEvnInfoWidgets(uiMainWindow, parentFolderName, projPathStripStr, False)

        with open(projPathStripStr,"r") as evnFile:
            self.projEnviromentInfoDic[parentFolderName] = json.loads(evnFile.read())

        return parentFolderName

    def initGitToolClickEvent(self, uiMainWindow:Ui_MainWindow):
        uiMainWindow.checkoutNewBranchBtn.clicked.connect(self.onCheckoutNewBranchBtnClick)
        uiMainWindow.clearUntrackFileBtn.clicked.connect(self.onClearUntrackFileBtnClick)
        uiMainWindow.checkoutBranchBtn.clicked.connect(self.onCheckoutBranchBtnClick)
        uiMainWindow.clearAndCheckoutBtn.clicked.connect(self.onClearAndCheckoutBtnClick)
        uiMainWindow.pushToRemoteBtn.clicked.connect(self.onPushToRemoteBtnClick)

    def onCheckoutNewBranchBtnClick(self):
        willOperaGitReposPaths = self.getWillOperateGitReposPaths()
        self.gitToolMgr.CreateAndCheckoutNewBranch(self,willOperaGitReposPaths)

    def onClearUntrackFileBtnClick(self):
        willOperaGitReposPaths = self.getWillOperateGitReposPaths()
        self.gitToolMgr.ClearUntrackedFile(self,willOperaGitReposPaths)

    def onCheckoutBranchBtnClick(self):
        willOperaGitReposPaths = self.getWillOperateGitReposPaths()
        self.gitToolMgr.CheckoutBranch(self,willOperaGitReposPaths)

    def onClearAndCheckoutBtnClick(self):
        willOperaGitReposPaths = self.getWillOperateGitReposPaths()
        self.gitToolMgr.ClearAndCheckout(self,willOperaGitReposPaths)

    def onPushToRemoteBtnClick(self):
        willOperaGitReposPaths = self.getWillOperateGitReposPaths()
        self.gitToolMgr.PushToRemote(self,willOperaGitReposPaths)

    def createProjEvnInfoWidgets(self, uiMainWindow, projName, projPath, isChoosing):
        if projName not in self.projInfoCheckWidgetDic.keys():
            self.projInfoCheckWidgetDic[projName]={}

        newProjInfoWidgets=self.projInfoCheckWidgetDic[projName]
        verticalLayoutWidget = uiMainWindow.verticalLayoutWidget
        horizontalLayout = QtWidgets.QHBoxLayout()
        horizontalLayout.setContentsMargins(0, 0, 0, 0)
        horizontalLayout.setObjectName(projName+"HorLayout")

        projNameLabel = QtWidgets.QLabel(verticalLayoutWidget)
        projNameLabel.setObjectName(projName+"ProjName")
        projNameLabel.setText(projName)
        horizontalLayout.addWidget(projNameLabel)

        projPathLabel = QtWidgets.QLabel(verticalLayoutWidget)
        projPathLabel.setObjectName(projName+"ProjPath")
        projPathLabel.setText(projPath)
        horizontalLayout.addWidget(projPathLabel)

        checkBox = QtWidgets.QCheckBox(verticalLayoutWidget)
        checkBox.setObjectName(projName+"CheckBox")
        checkBox.setCheckState(isChoosing)
        horizontalLayout.addWidget(checkBox)
        newProjInfoWidgets["checkBox"] = checkBox

        uiMainWindow.verticalLayout.addLayout(horizontalLayout)

    def createAllGitRepoInfoWidgets(self, uiMainWindow):
        for k,v in self.roProjInfoDic.items():
            self.createGitRepoInfoWidgetsByProjName(uiMainWindow, k)
        pass

    def createGitRepoInfoWidgetsByProjName(self, uiMainWindow, projName):
        branchInfo = self.projEnviromentInfoDic[projName]
        for k,v in branchInfo.items():
            self.createBranchInfoWidgets(uiMainWindow, k, False)

    def createBranchInfoWidgets(self, uiMainWindow, branchName, isChoosing):
        if branchName in self.gitReposInfoCheckWidgetDic.keys():
            return
        self.gitReposInfoCheckWidgetDic[branchName] = {}
        branchWidgets = self.gitReposInfoCheckWidgetDic[branchName]

        horizontalLayout = QtWidgets.QHBoxLayout()
        horizontalLayout.setContentsMargins(0, 0, 0, 0)
        horizontalLayout.setObjectName(branchName+"HorLayout")

        branchNameLabel = QtWidgets.QLabel(uiMainWindow.verticalLayoutWidget_2)
        branchNameLabel.setObjectName(branchName+"ProjName")
        branchNameLabel.setText(branchName)
        horizontalLayout.addWidget(branchNameLabel)

        checkBox = QtWidgets.QCheckBox(uiMainWindow.verticalLayoutWidget_2)
        checkBox.setObjectName(branchName+"CheckBox")
        checkBox.setCheckState(isChoosing)
        horizontalLayout.addWidget(checkBox)
        branchWidgets["checkBox"] = checkBox

        uiMainWindow.canOperaGitReposLayout.addLayout(horizontalLayout)

    def CreateAllProjEnvInfoWidgets(self, uiMainWindow):
        for key,value in self.roProjInfoDic.items():
            self.createProjEvnInfoWidgets(uiMainWindow, key, value["path"], value["isChoosing"])

    def SetupUI(self,uiMainWindow):
        self.uiMainWindow = uiMainWindow
        uiMainWindow.lineEdit = RoQLineEdit(uiMainWindow.centralwidget)
        uiMainWindow.lineEdit.setGeometry(QtCore.QRect(160, 40, 501, 20))
        uiMainWindow.lineEdit.setAcceptDrops(True)
        uiMainWindow.lineEdit.setObjectName("lineEdit")
        uiMainWindow.pushButton.clicked.connect(self.onAddProjInfoClick)

    def getWillOperateGitReposPaths(self):
        chooseProjList = [k for k,v in self.projInfoCheckWidgetDic.items() if v["checkBox"].isChecked()]
        chooseGitReposList = [k for k,v in self.gitReposInfoCheckWidgetDic.items() if v["checkBox"].isChecked()]
        willOperaGitReposList = []
        try:
            for projName in chooseProjList:
                projEnviromentInfo = self.projEnviromentInfoDic.get(projName)
                for gitReposName in chooseGitReposList:
                    if gitReposName in projEnviromentInfo.keys():
                        willOperaGitReposList.append(projEnviromentInfo.get(gitReposName))
                pass
        except:
            pass

        return willOperaGitReposList

if __name__=="__main__":
    import sys
    toolApp=QtWidgets.QApplication(sys.argv)
    mainWidget=MainWindowWidgets()
    mainWindowUI=Ui_MainWindow()
    mainWindowUI.setupUi(mainWidget)
    mainWidget.CreateAllProjEnvInfoWidgets(mainWindowUI)
    mainWidget.SetupUI(mainWindowUI)
    mainWidget.initCommonToolClickEvent(mainWindowUI)
    mainWidget.initGitToolClickEvent(mainWindowUI)
    mainWidget.createAllGitRepoInfoWidgets(mainWindowUI)
    mainWidget.show()
    sys.exit(toolApp.exec_())