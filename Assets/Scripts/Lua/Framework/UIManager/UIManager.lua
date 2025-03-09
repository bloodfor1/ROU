module("UIManager", package.seeall)

require "UI/UIConst"
require "Framework/UIManager/UIGroupDefine"

require "Core/System/Stack"

require "Framework/UIManager/UIGroupManager"
require "Framework/UIManager/UIManagerDataProcessor"
require "Framework/UIManager/UIManagerMethodCallQueue"

require "Framework/UIManager/UIPanelConfig"

-- UI管理类
---@class UIManager.UIManager
UIManager = class("UIManager")

local panelSuffix = "Ctrl"

function UIManager:ctor()

    --主界面组的名字
    self.MainPanelsGroupDefineName = "MainPanelsGroup"
    self.mainGroupName = UIGroupDefine:GetGroupName(self.MainPanelsGroupDefineName)

    --Group管理类
    self.groupManager = UIGroupManager.new()
    self.dataProcessor = UIManagerDataProcessor.new()
    self.methodCallQueue = UIManagerMethodCallQueue.new()

    --UI界面的类
    self.panelClasses = {}

    self.uiRoot = nil
    self.uiRootTransform = nil

    self.topContainer = nil
    self.guidingContainer = nil
    self.tipsContainer = nil
    self.functionContainer = nil
    self.normalContainer = nil
    self.deActiveCacheContainer = nil

    --打开的界面，调用ActiveUI加进来，调用DeActiveUI移除
    self.activePanelClasses = {}

    self.fullScreenPanelNames = {}

    self.isPanelOnProcessing = false

end

---------------------------------------- Start 外部调用方法 ---------------------------------------------------------------------
--打开界面
function UIManager:ActiveUI(uiName, uiPanelData, uiPanelConfigData, isPlayTween)
    MgrMgr:GetMgr("CrashReportMgr").AddSceneData("uiName", uiName)
    return self:_callPanelProcessMethod(self._activeUI, uiName, uiPanelData, uiPanelConfigData, isPlayTween)
end

--关闭界面
--会根据栈对界面进行处理
--分为一整个组的关闭和组中某一个界面的关闭
--一整个组的关闭会根据栈的状态对界面进行处理
--组中的某一个界面的关闭仅关闭自己，不做其他处理
function UIManager:DeActiveUI(uiName, isPlayTween)
    self:_callPanelProcessMethod(self._deActiveUI, uiName, isPlayTween)
end

--显示界面
--如果没打开则无效果
function UIManager:ShowUI(uiName, isPlayTween)
    self:_callPanelProcessMethod(self._showUI, uiName, isPlayTween)
end

--隐藏界面
function UIManager:HideUI(uiName, isPlayTween)
    self:_callPanelProcessMethod(self._hideUI, uiName, isPlayTween)
end

--直接打开一个组
--如果之前已经打开了这个组，应该把之前组有当前组没有的界面都移除出去
--此时这个组在栈顶
function UIManager:ActiveGroup(groupDefine, uiPanelData, uiPanelConfigData)
    self:_callPanelProcessMethod(self._activeGroup, groupDefine, uiPanelData, uiPanelConfigData)
end

--根据组配置，替换组中的界面
--不会更改栈顺序
function UIManager:ExchangeGroup(groupDefine, uiPanelData, uiPanelConfigData)
    self:_callPanelProcessMethod(self._exchangeGroup, groupDefine, uiPanelData, uiPanelConfigData)
end

--关闭一个组
function UIManager:DeActiveGroup(groupName, isPlayTween)
    self:_callPanelProcessMethod(self._deActiveGroup, groupName, isPlayTween)
end

function UIManager:GoBack(isPlayTween)
    return self:_callPanelProcessMethod(self._goBack, isPlayTween)
end

--设置界面强制隐藏
function UIManager:SetPanelForceHide(uiName)
    self.groupManager:SetPanelForceHide(uiName)
end
--取消界面强制隐藏
function UIManager:CancelPanelForceHide(uiName)
    self.groupManager:CancelPanelForceHide(uiName)
end

function UIManager:IsPanelShowing(uiName)
    ---@type UIBaseCtrl
    local panelClass = self.panelClasses[uiName]
    if panelClass == nil then
        return false
    end
    return panelClass:IsShowing()
end

function UIManager:ShowNormalContainer()
    self:_showContainer(self.normalContainer)
end
function UIManager:HideNormalContainer()
    self:_hideContainer(self.normalContainer)
end

function UIManager:ShowTipsContainer()
    self:_showContainer(self.tipsContainer)
end
function UIManager:HideTipsContainer()
    self:_hideContainer(self.tipsContainer)
end

--显示主界面
function UIManager:ShowMainGroup(excludePanelNames)
    if excludePanelNames == nil then
        excludePanelNames = {}
    end
    table.insert(excludePanelNames, self.MainPanelsGroupDefineName)
    self:DeActiveAllPanels(excludePanelNames)
end

function UIManager:ShowMainGroupWithExcludeGroupNames(excludeGroupNames)
    if excludeGroupNames == nil then
        excludeGroupNames = {}
    end
    table.insert(excludeGroupNames, self.mainGroupName)
    self:DeActiveAllPanelsWithExcludeGroupNames(excludeGroupNames)
end
---------------------------------------- End 外部调用方法 ---------------------------------------------------------------------

---------------------------------------- Start 生命周期调用的公有方法，外部不会调用 ----------------------------------------------

--内部使用
--界面当前是否是打开状态
--调用了ActiveUI就返回true
--调用了DeActiveUI就返回false
function UIManager:IsPanelAtActiveStatus(uiName)
    ---@type UIBaseCtrl
    local panelClass = self.activePanelClasses[uiName]
    if panelClass == nil then
        return false
    end
    return true
end

--关闭所有界面
--excludePanelNames 排除在外的界面（不处理的界面）
function UIManager:DeActiveAllPanels(excludePanelNames)
    local excludeGroupNames
    if excludePanelNames then
        excludeGroupNames = {}
        for i = 1, #excludePanelNames do
            local groupName = UIGroupDefine:GetGroupName(excludePanelNames[i])
            table.insert(excludeGroupNames, groupName)
        end
    end
    self:DeActiveAllPanelsWithExcludeGroupNames(excludeGroupNames)
end

function UIManager:DeActiveAllPanelsWithExcludeGroupNames(excludeGroupNames)
    self:_callPanelProcessMethod(self._deActiveAllGroups, excludeGroupNames)
end

function UIManager:SetPanelOnProcessing()
    self.isPanelOnProcessing = true
end
function UIManager:SetPanelFinishProcessing()
    self.isPanelOnProcessing = false
end

--设置界面关闭的回调
function UIManager:SetDeActiveCallBackInternalProcessing(uiName, deActiveCallBack)
    local panelClass = self:_getPanelClass(uiName)
    if panelClass == nil then
        logError("panelClass == nil")
        return
    end
    panelClass:BasePanelSetDeActiveCallBack(deActiveCallBack)
end

function UIManager:ActiveUIInternalProcessing(uiName, panelParent, uiPanelData, isPlayTween)
    local panelClass = self:_initPanelClass(uiName)
    self:_panelClassActiveUI(panelClass, panelParent, uiPanelData, isPlayTween)
end
function UIManager:DeActiveUIInternalProcessing(uiName, isPlayTween)
    --logGreen("DeActiveUIInternalProcessing,uiName:"..uiName)
    self:_panelClassDeActiveUI(self:_getPanelClass(uiName), isPlayTween)
end
function UIManager:ShowUIInternalProcessing(uiName)
    self:_panelClassShowUI(self:_getPanelClass(uiName))
end
function UIManager:HideUIInternalProcessing(uiName)
    self:_panelClassHideUI(self:_getPanelClass(uiName))
end

function UIManager:RemovePanelClassCache(uiName)
    self.panelClasses[uiName] = nil
end

--关闭或隐藏全屏界面时，打开主相机
function UIManager:ActiveMainCamera(uiName, isFullScreen)
    --关闭的界面不是全屏的，不用处理
    if isFullScreen == false then
        return
    end
    --这个界面还是显示状态
    --由于关闭和隐藏界面调用时立马打开相机，是同步的，因此这种情况应该不会出现
    if self.groupManager:IsPanelShowing(uiName) then
        logError("界面被关闭或隐藏了，判断还是显示状态")
        return
    end
    --把此界面移除
    table.ro_removeOneSameValue(self.fullScreenPanelNames, uiName)
    for i = 1, #self.fullScreenPanelNames do
        --由于之前缓存的全屏界面可能会被隐藏，所以要判断是否仍然是显示状态
        if self.groupManager:IsPanelShowing(self.fullScreenPanelNames[i]) then
            return
        end
    end
    --当所有全屏界面都关闭时，才会打开相机
    MScene.GameCamera.CameraEnabled = true
end

--打开或显示全屏界面时，关闭主相机
function UIManager:DeActiveMainCamera(uiName, isFullScreen)
    --如果打开的界面不是全屏的
    if isFullScreen == false then
        return
    end
    --界面不是显示状态
    --当界面有动画时，会在动画做完才会关闭相机，是异步的，可能出现
    if self.groupManager:IsPanelShowing(uiName) == false then
        return
    end
    table.insert(self.fullScreenPanelNames, uiName)
    MScene.GameCamera.CameraEnabled = false
end

--得到Cache界面所在的容器的Transform
function UIManager:GetDeActiveCacheContainerTransform()
    return self.deActiveCacheContainer
end

--得到切换场景时不会关闭的组的名字
function UIManager:GetKeepShowGroupNamesOnSwitchScene()
    return self.groupManager:GetKeepShowGroupNamesOnSwitchScene()
end
--得到在所有场景都保持显示的组名字
function UIManager:GetKeepShowGroupNamesOnAllScene()
    return self.groupManager:GetKeepShowGroupNamesOnAllScene()
end

function UIManager:GetUIRootTransform()
    return self.uiRootTransform
end

function UIManager:GetGroupContainerTransform(groupContainerType)
    if groupContainerType == UI.UILayer.Top then
        return self.topContainer
    end
    if groupContainerType == UI.UILayer.Guiding then
        return self.guidingContainer
    end
    if groupContainerType == UI.UILayer.Tips then
        return self.tipsContainer
    end
    if groupContainerType == UI.UILayer.Function then
        return self.functionContainer
    end
    if groupContainerType == UI.UILayer.Normal then
        return self.normalContainer
    end
    return self.normalContainer
end

---------------------------------------- End 生命周期调用的公有方法，外部不会调用 ----------------------------------------------

---------------------------------------- Start UIManager的私有方法 -------------------------------------------------------

--得到界面的配置数据
function UIManager:_getUIPanelConfig(panelClass, uiPanelConfigData)
    local uiPanelConfig = UIPanelConfig.new()
    self.dataProcessor:InsertUIPanelConfigData(uiPanelConfig, panelClass, self.mainGroupName)
    self.dataProcessor:InsertUIPanelConfigData(uiPanelConfig, uiPanelConfigData, self.mainGroupName)
    return uiPanelConfig
end

function UIManager:_activeUI(uiName, uiPanelData, uiPanelConfigData, isPlayTween)
    if uiName == nil then
        logError("ActiveUI没有传uiName")
        return nil
    end

    --logRed("ActiveUI:"..uiName)

    --取当前UI的Class
    local currentPanelClass = self:_initPanelClass(uiName)
    if currentPanelClass == nil then
        return nil
    end

    if self.groupManager:IsPanelForceHide(uiName) then
        return
    end

    local groupDefine

    if currentPanelClass.IsGroup then
        groupDefine = UIGroupDefine:GetGroupDefine(uiName)
    end

    local uiPanelConfig = self:_getUIPanelConfig(currentPanelClass, uiPanelConfigData)

    --如果是单一界面，直接打开
    if groupDefine == nil then

        self.groupManager:ActiveUIPanel(uiName, uiPanelData, uiPanelConfig)

        local activeInfos = self.groupManager:GetActiveInfosWithPanel(uiName, uiPanelConfig)

        local activePanelData = {}
        activePanelData[uiName] = uiPanelData

        self:_dealWithPanelWithActiveInfos(activeInfos, activePanelData, uiPanelConfig, isPlayTween)

    else

        self:_activeGroupInternal(groupDefine, uiPanelData, uiPanelConfig, isPlayTween)

    end

    return currentPanelClass
end

--打开组
function UIManager:_activeGroupInternal(groupDefine, uiPanelData, uiPanelConfig, isPlayTween)
    self.groupManager:ActiveGroupWithGroupDefine(groupDefine, uiPanelData, uiPanelConfig)

    local activeInfos = self.groupManager:GetActiveInfosWithGroup(groupDefine.GroupName, uiPanelConfig)
    self:_dealWithPanelWithActiveInfos(activeInfos, uiPanelData, uiPanelConfig, isPlayTween)
end

--根据打开界面数据，对界面进行打开和隐藏
function UIManager:_dealWithPanelWithActiveInfos(groupActiveInfo, uiPanelData, uiPanelConfig, isPlayTween)

    if groupActiveInfo == nil then
        return
    end

    --打开组的时候根据配置设置强制隐藏界面
    local forceHidePanelNames = uiPanelConfig:GetForceHidePanelNames()
    if forceHidePanelNames then
        for i = 1, #forceHidePanelNames do
            self:SetPanelForceHide(forceHidePanelNames[i])
        end
    end

    local uiPanelActiveInfoContainer = groupActiveInfo:GetPanelActiveInfoContainer()

    for uiName, panelActiveInfo in pairs(uiPanelActiveInfoContainer) do

        --logYellow("dealWithPanelWithActiveInfos,uiName:"..uiName..
        --"  IsNeedActive:"..tostring(panelActiveInfo:IsNeedActive())..
        --"  IsNeedHide:"..tostring(panelActiveInfo:IsNeedHide()))

        if not panelActiveInfo:IsNeedActive() then
            if panelActiveInfo:IsNeedHide() then
                self:HideUIInternalProcessing(uiName)
            end
            uiPanelActiveInfoContainer[uiName] = nil
        end
    end

    for uiName, panelActiveInfo in pairs(uiPanelActiveInfoContainer) do
        self:ActiveUIInternalProcessing(uiName, panelActiveInfo:GetPanelParent(), self:_getUIPanelDataWithName(uiPanelData, uiName), isPlayTween)

        --此处处理的是打开并隐藏的需求
        --因为业务逻辑认为界面是打开状态，想要显示时会直接调用ShowUI，如果没打开过，调用ShowUI并不会显示。
        --因此此处必须要先打开界面，再调用隐藏界面
        if panelActiveInfo:IsNeedHide() then
            self:HideUIInternalProcessing(uiName)
        end
    end

    local hideGroups = groupActiveInfo:GetHideGroups()

    if hideGroups then
        for i = 1, #hideGroups do
            hideGroups[i]:SetVisible(false)
        end
    end
end

function UIManager:_deActiveUI(uiName, isPlayTween)
    if uiName == nil then
        logError("DeActiveUI传的名字是空的")
        return
    end

    --取到需要关闭的组，此时会对相应的栈进行出栈操作
    local deActiveGroupInfo = self.groupManager:GetDeActiveGroupInfoAndDealWithStack(uiName)
    if deActiveGroupInfo then
        deActiveGroupInfo:DealWithGroupAndPanels(isPlayTween)
    else
        --如果没有取到Group数据,此时这个界面是一个组中的普通界面，直接关闭这个界面
        self:DeActiveUIInternalProcessing(uiName, isPlayTween)
    end
end

function UIManager:_showUI(uiName, isPlayTween)

    local panelClass = self:_getPanelClass(uiName)
    if panelClass == nil then
        return
    end

    --如果界面强制隐藏，不会显示
    if self.groupManager:IsPanelForceHide(uiName) then
        return
    end

    --设置界面在组中的显示状态
    self.groupManager:ShowUI(uiName)

    --如果界面所在的组是显示的，才会把界面显示出来
    if not self.groupManager:IsGroupHide(uiName) then
        self:_panelClassShowUI(panelClass, isPlayTween)
    end
end

function UIManager:_hideUI(uiName, isPlayTween)
    local panelClass = self:_getPanelClass(uiName)
    if panelClass == nil then
        return
    end
    self.groupManager:HideUI(uiName)
    self:_panelClassHideUI(panelClass, isPlayTween)
end

function UIManager:_activeGroup(groupDefine, uiPanelData, uiPanelConfigData)
    self:_deActivePanelOnActiveGroup(groupDefine)
    --再打开组
    local uiPanelConfig = self:_getUIPanelConfig(nil, uiPanelConfigData)
    self:_activeGroupInternal(groupDefine, uiPanelData, uiPanelConfig)
end

function UIManager:_deActivePanelOnActiveGroup(groupDefine)
    --如果这个组还开着的情况下再开这个组，要对组里面的界面进行处理
    --先取需要移除的界面，并对栈进行处理
    local removePanelNames = self.groupManager:GetRemovePanelInfosOnActiveGroupAndDealWithStack(groupDefine)

    self:_deActivePanelWithRemovePanelNames(removePanelNames)
end

function UIManager:_deActivePanelWithRemovePanelNames(removePanelNames)
    if removePanelNames == nil then
        return
    end
    --关闭这些界面
    for i = 1, #removePanelNames do
        self:DeActiveUIInternalProcessing(removePanelNames[i])
    end
end

function UIManager:_exchangeGroup(groupDefine, uiPanelDatas, uiPanelConfigData)
    local groupName = groupDefine.GroupName
    if self.groupManager:IsGroupExist(groupName) then

        --1、对于之前在组中现在依然还在组中的界面，重新设置此界面的状态是Active的
        self.groupManager:ResetHoldPanelActiveStatusOnExchangeGroup(groupDefine)
        --2、处理要移除的界面
        local removePanelNames = self.groupManager:GetRemovePanelInfosOnExchangeGroupAndDealWithStack(groupDefine)

        local uiPanelConfig = self:_getUIPanelConfig(nil, uiPanelConfigData)
        --3、取要添加进组中的界面
        local addPanelNames = self.groupManager:GetAddPanelsOnExchangeGroup(groupDefine)

        --4、处理要添加的界面
        local groupActiveInfo = self.groupManager:GetGroupActiveInfoOnExchangeGroup(groupDefine, groupName, addPanelNames, uiPanelConfig)
        --5、对加进组中的界面的栈数据进行处理
        self.groupManager:DealWithAddPanelsStackOnExchangeGroup(groupName, addPanelNames)

        --6、替换组数据中存储的界面配置数据
        self.groupManager:ExchangeGroupPanelsWithGroupDefine(groupDefine, uiPanelDatas, uiPanelConfig)

        --7、最后再修改界面的显示状态
        --把需要移除的界面都关闭
        self:_deActivePanelWithRemovePanelNames(removePanelNames)
        --根据得到的数据对界面进行显示
        self:_dealWithPanelWithActiveInfos(groupActiveInfo, uiPanelDatas, uiPanelConfig)
    else
        self:ActiveGroup(groupDefine, uiPanelDatas, uiPanelConfigData)
    end
end

function UIManager:_deActiveGroup(groupName, isPlayTween)
    if groupName == nil then
        logError("DeActiveGroup传的组名字是空的")
        return
    end
    --取到需要关闭的组，此时会对相应的栈进行出栈操作
    local deActiveGroupInfo = self.groupManager:GetDeActiveGroupInfoAndDealWithStackWithGroupName(groupName)
    if deActiveGroupInfo == nil then
        return
    end
    deActiveGroupInfo:DealWithGroupAndPanels(isPlayTween)
end

function UIManager:_goBack(isPlayTween)
    local topGroupName = self.groupManager:GetTopGroupName()
    if topGroupName == nil then
        logError("topGroupName == nil")
        return false
    end
    if topGroupName == self.mainGroupName then
        return false
    end
    self:_deActiveGroup(topGroupName, isPlayTween)
    return true
end

--批量关闭组
function UIManager:_deActiveAllGroups(excludeGroupNames)
    --存储关闭组信息的栈
    --栈顶为最后要关闭的组
    local deActiveGroupInfoStack = System.Stack.new()
    --存储关闭组信息的字典，键值对形式，用来方便对比
    ---@type table<string,UIGroupDeActiveInfo>
    local deActiveGroupInfoDictionary = {}
    --需要显示的组
    ---@type table<string,UIGroup>
    local needShowGroups = {}

    local isNeedDeActive
    local allGroupNames = self.groupManager:GetAllGroupNames()
    --从栈顶对组进行遍历
    for i, groupName in System.Stack.Iterator, allGroupNames, 1 do
        if excludeGroupNames == nil then
            isNeedDeActive = true
        else
            isNeedDeActive = not table.ro_contains(excludeGroupNames, groupName)
        end
        --如果此组是要关闭的
        if isNeedDeActive then
            --调用关闭组的逻辑，得到组关闭的数据
            local deActiveGroupInfo = self.groupManager:GetDeActiveGroupInfoAndDealWithStackWithGroupName(groupName)
            --根据当前组关闭数据填充最终的处理数据
            --此处只做了数据的填充
            self.dataProcessor:FillDeActiveGroupsInfoOnDeActiveAllGroups(deActiveGroupInfoStack, deActiveGroupInfoDictionary, needShowGroups, deActiveGroupInfo)
        end
    end

    --根据所有的关闭的组，对需要显示的组进行处理
    --关闭的组不会再显示
    for groupName, v in pairs(needShowGroups) do
        if deActiveGroupInfoDictionary[groupName] then
            needShowGroups[groupName] = nil
        end
    end

    --对存储的所有组关闭数据进行对比和处理，得到最终的组关闭数据
    --deActiveGroupInfoStack和deActiveGroupInfoDictionary存储的是一样的数据（都是所有组的关闭数据），此处是为了方便对比
    self.dataProcessor:DealWithDeActiveGroupInfoStackOnDeActiveAllGroups(deActiveGroupInfoStack, deActiveGroupInfoDictionary)

    ---@param deActiveGroupInfo UIGroupDeActiveInfo
    for n, deActiveGroupInfo in System.Stack.Iterator, deActiveGroupInfoStack, 1 do
        deActiveGroupInfo:DealWithGroupAndPanels(false)
    end

    self:_showGroups(needShowGroups)
end

---@param showGroups table<string,UIGroup>
function UIManager:_showGroups(showGroups)
    if showGroups == nil then
        return
    end
    for i, showGroup in pairs(showGroups) do
        showGroup:SetVisible(true)
    end
end

function UIManager:_showContainer(container)
    local canvas = container.gameObject:GetComponent("Canvas")
    if canvas then
        canvas.enabled = true
    end
end
function UIManager:_hideContainer(container)
    local canvas = container.gameObject:GetComponent("Canvas")
    if canvas then
        canvas.enabled = false
    end
end

function UIManager:_getUIPanelDataWithName(uiPanelData, uiName)
    if uiPanelData == nil then
        return nil
    end

    if type(uiPanelData) == "function" then
        return uiPanelData
    end
    return uiPanelData[uiName]
end

--初始化Ctrl
function UIManager:_initPanelClass(uiName)

    local panelClassName = uiName .. panelSuffix

    local currentPanelClass = self.panelClasses[uiName]
    if currentPanelClass == nil then

        require("UI/Ctrl/" .. panelClassName)

        if UI[panelClassName] == nil then
            logError("没有找到此名字的Ctrl，Ctrl名字：" .. panelClassName)
            return nil
        end

        currentPanelClass = UI[panelClassName].new()
        self.panelClasses[uiName] = currentPanelClass
    end

    return currentPanelClass
end

function UIManager:_callPanelProcessMethod(method, ...)
    return method(self, ...)
end

function UIManager:_getPanelClass(uiName)
    if uiName == nil then
        logError("界面名字是空的")
        return nil
    end
    local panelClass = self.panelClasses[uiName]
    return panelClass
end

--仅调用UI的打开方法
---@param panelClass UIBaseCtrl
function UIManager:_panelClassActiveUI(panelClass, panelParent, uiPanelData, isPlayTween)
    if panelClass == nil then
        return
    end
    --logYellow("panelClassActiveUI:" .. panelClass.name)

    self.activePanelClasses[panelClass:GetPanelName()] = panelClass

    if isPlayTween == nil then
        isPlayTween = true
    end
    panelClass:ActiveTemp(panelParent, function(ctrl)
        if uiPanelData == nil then
            return
        end
        if type(uiPanelData) == "function" then
            uiPanelData(ctrl)
        end
    end, isPlayTween, uiPanelData)
end

--仅调用UI的关闭方法
---@param panelClass UIBaseCtrl
function UIManager:_panelClassDeActiveUI(panelClass, isPlayTween)
    if panelClass == nil then
        return
    end
    --logRed("panelClassDeActiveUI:" .. panelClass.name)

    local panelName = panelClass:GetPanelName()
    self.activePanelClasses[panelName] = nil

    if isPlayTween == nil then
        isPlayTween = true
    end
    panelClass:DeActive(isPlayTween)
end

---@param panelClass UIBaseCtrl
function UIManager:_panelClassShowUI(panelClass, isPlayTween)

    if panelClass == nil then
        return
    end

    --logYellow("panelClassShowUI:" .. panelClass.name)

    panelClass:BasePanelShowUI(isPlayTween)

end

---@param panelClass UIBaseCtrl
function UIManager:_panelClassHideUI(panelClass, isPlayTween)

    if panelClass == nil then
        return
    end

    --logRed("panelClassHideUI:" .. panelClass.name)

    panelClass:BasePanelHideUI(isPlayTween)

end
---------------------------------------- End UIManager的私有方法 --------------------------------------------------------

-------------------------------------- Start 生命周期相关 -----------------------------------------------------------------

function UIManager:Init()

    self.uiRoot = GameObject.Find("UIRoot")

    self.uiRootTransform = self.uiRoot.transform

    self.topContainer = self.uiRootTransform:Find("TopLayer")
    self.guidingContainer = self.uiRootTransform:Find("GuidingLayer")
    self.tipsContainer = self.uiRootTransform:Find("TipsLayer")
    self.functionContainer = self.uiRootTransform:Find("FunctionLayer")
    self.normalContainer = self.uiRootTransform:Find("NormalLayer")
    self.deActiveCacheContainer = self.uiRootTransform:Find("DeActiveCacheContainer")

    --预加载
    self:_preLoad()
end

function UIManager:Uninit()
    for uiName, panelClass in pairs(self.panelClasses) do
        --在关闭游戏的时候 设置所有已开启的UI不缓存 让所有UI都能正确卸载
        panelClass:UnCacheUI()
        panelClass:Uninit()
    end
end

function UIManager:_preLoad()
    self:_loadUI(UI.CtrlNames.Dialog)
    self:_loadUI(UI.CtrlNames.InputDialog)
    self:_loadUI(UI.CtrlNames.DrapDownDialog)
    self:_loadUI(UI.CtrlNames.Connecting)
    self:_loadUI(UI.CtrlNames.TipsDlg)
    self:_loadUI(UI.CtrlNames.TalkDlg2)
end

function UIManager:_loadUI(uiName)
    local currentPanelClass = self:_initPanelClass(uiName)
    if currentPanelClass == nil then
        return
    end
    currentPanelClass:SetPanelParentData(self:GetDeActiveCacheContainerTransform())
    --预加载之后 直接隐藏
    currentPanelClass:Load(function(panelClass)
        self:_onLoadUI(panelClass)
    end)
end

function UIManager:_onLoadUI(panelClass)
    panelClass:_setVisible(false)
end

-------------------------------------- End 生命周期相关 -----------------------------------------------------------------


-------------------------------------- Start Debug相关 -----------------------------------------------------------------

function UIManager:DebugLog()
    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end
    self.groupManager:DebugLog()
end

function UIManager:OpenUIPanelDebuger()
    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end
    require "Framework/UIManager/UIPanelDebuger"
end

function UIManager:DebugLogPanelClassesInfo(isShowAll)
    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    local panelClassesInfos = {}

    for uiName, panelClass in pairs(self.panelClasses) do
        local panelClassInfo = {}
        panelClassInfo.UIName = uiName
        panelClassInfo.TemplatePoolCount = #panelClass.templatePools
        panelClassInfo.TemplateCount = #panelClass.templates

        if isShowAll then
            table.insert(panelClassesInfos, panelClassInfo)
        else
            if panelClassInfo.TemplatePoolCount ~= 0 or panelClassInfo.TemplateCount ~= 0 then
                table.insert(panelClassesInfos, panelClassInfo)
            end
        end
    end

    for i = 1, #panelClassesInfos do
        logGreen("界面名字：" .. panelClassesInfos[i].UIName)
        logGreen("——TemplatePool个数：" .. tostring(panelClassesInfos[i].TemplatePoolCount) ..
                "  Template个数：" .. tostring(panelClassesInfos[i].TemplateCount))
    end
end

-------------------------------------- End Debug相关 --------------------------------------------------------------------

-------------------------------------- Start 以前遗留的或需要改的方法 -----------------------------------------------------
--取界面所在的组的名字
function UIManager:GetGroupNameAccordingToActivePanelName(uiName)
    return self.groupManager:GetGroupNameAccordingToActivePanelName(uiName)
end
function UIManager:GetGroupContainerTypeAccordingToActivePanelName(uiName)
    return self.groupManager:GetGroupContainerTypeAccordingToActivePanelName(uiName)
end

function UIManager:IsActiveUI(uiName)
    ---@type UIBaseCtrl
    local panelClass = self.panelClasses[uiName]
    if panelClass == nil then
        return false
    end
    return panelClass:IsActive()
end

--[Comment]
--根据名字获取ui对象  返回可能为空 使用者注意 需要判空
function UIManager:GetUI(uiName)
    local l_ctrl = self.panelClasses[uiName]
    if l_ctrl and l_ctrl:IsShowing(true) then
        return l_ctrl
    end
    return nil
end

--[Comment]
--根据Ctrl 和 HandlerName 获取对应的Handler对象 返回可能为空 使用者注意 需要判空
function UIManager:GetHandler(uiName, handlerName)
    local l_ctrl = self:GetUI(uiName)
    if l_ctrl and l_ctrl:IsShowing() then
        local l_handler = l_ctrl:GetHandlerByName(handlerName)
        if l_handler and l_handler:IsShowing() then
            return l_handler
        end
    end
    return nil
end

function UIManager:GetOrInitUI(uiName)
    return self:_initPanelClass(uiName)
end

function UIManager:UpdateInput(touchItem)
    for k, v in pairs(self.activePanelClasses) do
        if v:IsInited() and v:IsShowing() then
            v:UpdateInput(touchItem)
        end
    end
end

function UIManager:Update()
    for k, v in pairs(self.activePanelClasses) do
        if v:IsInited() and v:IsShowing() then
            v:Update()
        end
    end
end
-------------------------------------- End 以前遗留的或需要改的方法 -------------------------------------------------------

declareGlobal("UIMgr", UIManager.new())

return UIManager