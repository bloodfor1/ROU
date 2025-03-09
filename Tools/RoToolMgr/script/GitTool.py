import git
from PyQt5.QtWidgets import QInputDialog,QMessageBox
from threading import Thread
import queue
from PyQt5.QtCore import QThread

class SimpleGit:

    def __init__(self):
        #git处理模式，True为队列模式，请求的git操作会按顺序依次执行
        # False为并发模式，请求的git操作会用多线程并发执行
        self.IsQueueMode = True
        queueMaxNum = 10
        self.gitQueue = queue.Queue(queueMaxNum)

        pass

    def showMessageWindow(self):
        print("showMessageWindow")
        pass

    def ChangeGitMode(self,parentWindow,useQueue):
        if useQueue == self.IsQueueMode:
            return
        if ~useQueue:
            if not self.gitQueue.empty():
                QMessageBox.warning(parentWindow,"git队列中还有未处理完的操作，无法切换！","1")
                return

        self.IsQueueMode = useQueue

    #创建并切入一个新的分支
    def CreateAndCheckoutNewBranch(self,parentWindow,gitReposPathList):
        newBranchName,isSuc = QInputDialog.getText(parentWindow,"创建检出新分支","输入新分支名称：")
        if not isSuc:
            return
        t = Thread(target=self.createAndCheckoutNewBranch, args=(newBranchName, gitReposPathList,))
        t.start()

    def createAndCheckoutNewBranch(self, newBranchName, gitReposPathList):
        for reposPath in gitReposPathList:
            repo = git.Repo(reposPath)
            try:
                print("正在创建并切入分支：" + reposPath)
                repo.git.checkout(b=newBranchName)
                print("创建切入成功!")
            except Exception as e:
                print("发生异常:" + str(e) + "直接跳过处理此仓库！")

    def ClearUntrackedFile(self,parentWindow,gitReposPathList):
        t = Thread(target=self.clearUntrackedFile, args=(gitReposPathList,))
        t.start()

    def clearUntrackedFile(self, gitReposPathList):
        for reposPath in gitReposPathList:
            repo = git.Repo(reposPath)
            try:
                print("正在清理Untracked文件，git路径："+reposPath)
                repo.git.clear("-df")
                print("清理successful!")
            except Exception as e:
                print("发生异常:" + str(e) + "直接跳过处理此仓库！")

        print("已完成清理untracked文件！")

    #切入指定分支，如果分支不存在，则从远端Fetch
    def CheckoutBranch(self,parentWindow,gitReposPathList):
        checkoutBranchName, isSuc = QInputDialog.getText(parentWindow, "检出指定分支", "输入分支名称：")
        if not isSuc:
            return
        t = Thread(target=self.checkBranchByName,args=(checkoutBranchName, gitReposPathList,))
        t.start()


    def checkBranchByName(self,checkoutBranchName,gitReposPathList):
        print("checkBranchByName:")
        for reposPath in gitReposPathList:
            print("reposPath:"+reposPath)
            repo = git.Repo(reposPath)
            print("当前处理的分支路径："+reposPath)
            canCheckoutBranch = self.isBranchExist(repo,checkoutBranchName)
            if not canCheckoutBranch:
                print("远端数据不存在此分支，从远端获取分支数据再次查看！")
                try:
                    repo.git.fetch("origin")
                    fetchBranchArg = "origin %s" %checkoutBranchName
                    repo.git.fetch(fetchBranchArg)
                except Exception as e:
                    pass
                canCheckoutBranch = self.isBranchExist(repo, checkoutBranchName)

            if canCheckoutBranch:
                print("切入指定分支，git路径：" + reposPath)
                repo.git.checkout(checkoutBranchName)
                print("切入指定分支成功!")
            else:
                print("分支不存在，无法切入！")

        print("已完成切入指定分支操作！")

    def isBranchExist(self,repo,branchName):
        try:
            isBranchExist = False
            for branchInfo in repo.git.branch().split("\n"):
                if branchName in branchInfo:
                    print("本地存在此分支")
                    isBranchExist = True
                    break

            if not isBranchExist:
                print("本地不存在此分支，查看远端是否存在！")
                for branchInfo in repo.git.branch("-r").split("\n"):
                    if branchName in branchInfo:
                        print("远端存在此分支")
                        isBranchExist = True
                        break
            return isBranchExist
        except Exception as e:
            print("处理此仓库时发生错误，已跳过！")
            return False

    #清理当前分支，并切入指定分支，同时拉到最新
    def ClearAndCheckout(self,parentWindow,gitReposPathList):
        targetBranchName, isSuc = QInputDialog.getText(parentWindow, "清理分支，切入目标分支并拉新", "输入目标分支名称：")
        if not isSuc:
            return
        t = Thread(target=self.clearAndCheckout, args=(targetBranchName, gitReposPathList,))
        t.start()
        print("已完成重置、清理、切入、拉新分支")

    def clearAndCheckout(self,targetBranchName,gitReposPathList):
        for reposPath in gitReposPathList:
            print("正在处理的分支："+reposPath)
            roRepo = git.Repo(reposPath)
            try:
                print("正在重置当前路径，请稍等!")
                roRepo.git.reset(hard=True)
                print("reset --hard successful!")
                print("正在清理当前路径的untrack文件，请稍等!")
                roRepo.git.clean("-df")
                print("clean -df successful!")
                print("正尝试切入目标分支，请稍等!")
                roRepo.git.checkout(targetBranchName)
                print("checkout " + targetBranchName + " successful!")
                print("正在拉取信息，请稍等!")
                roRepo.git.pull()
                print("pull " + targetBranchName + " successful!")
            except Exception as e:
                print("发生异常:" + str(e) + "直接跳过处理此分支")


    def PushToRemote(self,parentWindow,gitReposPathList):
        t = Thread(target=self.pushToRemote, args=(gitReposPathList,))
        t.start()

    def pushToRemote(self,gitReposPathList):
        for reposPath in gitReposPathList:
            print("正在处理的分支："+reposPath)
            try:
                roRepo = git.Repo(reposPath)
                print("正在尝试将分支推送至远端！")
                roRepo.remote().push(roRepo.active_branch)
                print("推送成功！")
            except Exception as e:
                print("正在处理的分支：" + str(e))

        print("已完成将本地分会推送至远端！")