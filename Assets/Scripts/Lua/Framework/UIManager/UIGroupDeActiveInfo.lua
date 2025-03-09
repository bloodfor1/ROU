module("UIManager", package.seeall)

require "Framework/UIManager/UIPanelDeActiveInfo"

--关闭界面的时候对界面的操作和对组的操作信息
---@class UIGroupDeActiveInfo
UIGroupDeActiveInfo = class("UIGroupDeActiveInfo")

function UIGroupDeActiveInfo:ctor(deActiveGroup)

    --界面关闭数据的容器，键值对
    --Key为界面名字
    --Value为UIPanelDeActiveInfo类
    ---@type table<number, UIPanelDeActiveInfo>
    self.uiPanelDeActiveInfoContainer = {}

    --当前要关闭的组
    ---@type UIGroup
    self.deActiveGroup = deActiveGroup

    --此组关闭的时候需要显示的组
    ---@type UIGroup[]
    self.needShowGroups = nil

    --总共需要关闭的界面个数
    self.deActivePanelCount = 0
    --当前已经关闭的界面个数
    self.currentDeActivePanelCount = 0

end

---------------------------------------------- Start 关闭组数据操作 ------------------------------------------------------------

--取当前要关的组
function UIGroupDeActiveInfo:GetDeActiveGroup()
    return self.deActiveGroup
end

--取或创建数据
---@return UIPanelDeActiveInfo
function UIGroupDeActiveInfo:GetOrCreatePanelDeActiveInfo(uiName)
    local l_panelDeActiveInfo = self.uiPanelDeActiveInfoContainer[uiName]
    if l_panelDeActiveInfo == nil then
        l_panelDeActiveInfo = UIPanelDeActiveInfo.new(uiName)
        self.uiPanelDeActiveInfoContainer[uiName] = l_panelDeActiveInfo
    end
    return l_panelDeActiveInfo
end

--取界面关闭数据
---@return UIPanelDeActiveInfo
function UIGroupDeActiveInfo:GetPanelDeActiveInfo(uiName)
    return self.uiPanelDeActiveInfoContainer[uiName]
end
--设置关闭界面数据
function UIGroupDeActiveInfo:SetPanelDeActiveInfo(uiName, panelDeActiveInfo)
    self.uiPanelDeActiveInfoContainer[uiName] = panelDeActiveInfo
end
--得到所有关闭界面数据
function UIGroupDeActiveInfo:GetPanelDeActiveInfoContainer()
    return self.uiPanelDeActiveInfoContainer
end

--设置需要显示的组
function UIGroupDeActiveInfo:SetNeedShowGroup(showGroup)
    if showGroup == nil then
        return
    end
    if self.needShowGroups == nil then
        self.needShowGroups = {}
    end
    table.insert(self.needShowGroups, showGroup)
end

function UIGroupDeActiveInfo:GetNeedShowGroups()
    return self.needShowGroups
end

function UIGroupDeActiveInfo:ClearNeedShowGroups()
    self.needShowGroups = nil
end

---------------------------------------------- End 关闭组数据操作 ------------------------------------------------------------

---------------------------------------------- Start 关闭组时界面显示逻辑操作 ----------------------------------------------

--根据 组关闭数据 进行关闭界面处理
function UIGroupDeActiveInfo:DealWithGroupAndPanels(isPlayTween)

    self:_cancelPanelForceHideOnDeActiveGroup()

    if self.needShowGroups then
        for i, showGroup in pairs(self.needShowGroups) do
            showGroup:SetVisible(true)
        end
    end

    local deActivePanelNames = {}
    for uiName, deActivePanelInfo in pairs(self.uiPanelDeActiveInfoContainer) do
        self:_dealWithPanelWithDeActivePanelInfo(uiName, deActivePanelInfo, deActivePanelNames)
    end

    local deActivePanelCallBack = function(uiName)
        self:_deActivePanelCallBack(uiName)
    end

    local trueDeActivePanelNames
    for i = 1, #deActivePanelNames do
        local deActivePanelName = deActivePanelNames[i]
        --logRed("关闭的组：" .. tostring(self.deActiveGroup:GetGroupName()) .. " 关闭的界面：" .. deActivePanelName)
        if UIMgr:IsPanelAtActiveStatus(deActivePanelName) then
            if trueDeActivePanelNames == nil then
                trueDeActivePanelNames = {}
            end
            UIMgr:SetDeActiveCallBackInternalProcessing(deActivePanelName, deActivePanelCallBack)
            table.insert(trueDeActivePanelNames, deActivePanelName)
        end
    end

    if trueDeActivePanelNames == nil then
        self.deActiveGroup:Uninit()
        self.deActiveGroup = nil
        return
    end

    self.currentDeActivePanelCount = 0
    self.deActivePanelCount = #trueDeActivePanelNames

    local deActivePanelName
    for i = 1, self.deActivePanelCount do
        deActivePanelName = trueDeActivePanelNames[i]
        --logRed("关闭的组：" .. tostring(self.deActiveGroup:GetGroupName()) .. " 真正要关闭的界面：" .. deActivePanelName)
        UIMgr:DeActiveUIInternalProcessing(deActivePanelName, isPlayTween)
    end
end

--关闭组的时候根据配置取消强制隐藏界面
function UIGroupDeActiveInfo:_cancelPanelForceHideOnDeActiveGroup()
    local forceHidePanelNames=self.deActiveGroup:GetForceHidePanelNames()
    if forceHidePanelNames==nil then
        return
    end
    for i = 1, #forceHidePanelNames do
        UIMgr:CancelPanelForceHide(forceHidePanelNames[i])
    end
end

function UIGroupDeActiveInfo:_deActivePanelCallBack(uiName)
    if self.deActiveGroup == nil then
        logError("关闭界面回调时，存储的组已经被销毁了")
        return
    end
    self.currentDeActivePanelCount = self.currentDeActivePanelCount + 1

    --logYellow("GroupName:"..self.deActiveGroup:GetGroupName()..  "  uiName:"..uiName.."  self.deActivePanelCount:"..tostring(self.deActivePanelCount).."  self.currentDeActivePanelCount:"..tostring(self.currentDeActivePanelCount))

    if self.deActivePanelCount == self.currentDeActivePanelCount then
        self.deActiveGroup:Uninit()
        self.deActiveGroup = nil
    end
end

--处理界面
---@param deActivePanelInfo UIPanelDeActiveInfo
function UIGroupDeActiveInfo:_dealWithPanelWithDeActivePanelInfo(uiName, deActivePanelInfo, deActivePanelNames)

    --logYellow("关闭界面处理，uiName：" .. tostring(uiName) ..
    --        "  IsHaveActivePanelOnBehind:" .. tostring(deActivePanelInfo:IsHaveActivePanelOnBehind()) ..
    --        "  IsNeedReActive:" .. tostring(deActivePanelInfo:IsNeedReActive()) ..
    --        "  IsNeedShowUI:" .. tostring(deActivePanelInfo:IsNeedShowUI()))

    if deActivePanelInfo:IsHaveActivePanelOnBehind() then
        return
    end

    --1、当需要重新打开时
    --2、当需要显示界面时，但这个界面被关闭了
    --这两种情况都需要重新打开界面
    local isTrueNeedReActive = deActivePanelInfo:IsNeedReActive()
    if not isTrueNeedReActive then
        if deActivePanelInfo:IsNeedShowUI() then
            if not UIMgr:IsPanelAtActiveStatus(uiName) then
                isTrueNeedReActive = true
            end
        end
    end

    if isTrueNeedReActive then
        UIMgr:ActiveUIInternalProcessing(uiName, deActivePanelInfo:GetPanelParent(), deActivePanelInfo:GetReActivePanelData())
    else
        if deActivePanelInfo:IsNeedShowUI() then
            UIMgr:ShowUIInternalProcessing(uiName)
        else
            --如果此界面没有在其他组中是打开状态，直接关闭
            table.insert(deActivePanelNames, uiName)
        end
    end
end

return UIGroupDeActiveInfo




