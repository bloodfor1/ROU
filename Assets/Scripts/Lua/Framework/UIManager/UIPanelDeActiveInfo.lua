
module("UIManager", package.seeall)

--界面关闭的数据
---@class UIPanelDeActiveInfo
UIPanelDeActiveInfo = class("UIPanelDeActiveInfo")

function UIPanelDeActiveInfo:ctor(uiName)

    --此数据对应的界面的名字
    self.uiName=uiName
    --包含此界面的组的名字
    self.groupNameOfContainingDeActivePanel=nil

    --是否后面有打开的，有的话不需要处理
    self.isHaveActivePanelOnBehind=false
    --是否需要显示
    self.isNeedShowUI=false

    --是否重新打开
    self.isNeedReActive=false
    --重新打开需要的数据
    self.reActivePanelData=nil
    --重新打开的界面父物体
    self.panelParent=nil

end

--设置界面是否在后面的组是打开的
function UIPanelDeActiveInfo:SetHaveActivePanelOnBehind(isHaveActivePanelOnBehind)
    self.isHaveActivePanelOnBehind=isHaveActivePanelOnBehind
end

--设置界面需要重新打开
function UIPanelDeActiveInfo:SetNeedReActive(isNeedReActive)
    self.isNeedReActive=isNeedReActive
end

--设置界面需要显示
function UIPanelDeActiveInfo:SetNeedShowUI(isNeedShowUI)
    self.isNeedShowUI=isNeedShowUI
end

--设置关闭的界面所在的组的数据
--只有需要显示或重新打开的界面才会赋值
---@param group UIGroup
function UIPanelDeActiveInfo:SetDeActivePanelGroupData(group)
    self.panelParent=group:GetGroupTransform()
    self.reActivePanelData=group:GetPanelDataWithPanelName(self.uiName)
    self.groupNameOfContainingDeActivePanel=group:GetGroupName()
end

--重新打开界面时，取界面的父物体
function UIPanelDeActiveInfo:GetPanelParent()
    if self.panelParent == nil then
        logError("界面的父物体没有创建")
    end
    return self.panelParent
end

--重新打开界面时，取界面数据
function UIPanelDeActiveInfo:GetReActivePanelData()
    return self.reActivePanelData
end

--获取包含这个界面的组的名字
function UIPanelDeActiveInfo:GetGroupNameOfContainingDeActivePanel()
    return self.groupNameOfContainingDeActivePanel
end

function UIPanelDeActiveInfo:IsHaveActivePanelOnBehind()
    return self.isHaveActivePanelOnBehind
end

function UIPanelDeActiveInfo:IsNeedReActive()
    return self.isNeedReActive
end

function UIPanelDeActiveInfo:IsNeedShowUI()
    return self.isNeedShowUI
end

function UIPanelDeActiveInfo:IsNeedDeActive()
    if self.isHaveActivePanelOnBehind then
        return false
    end
    if self.isNeedReActive then
        return false
    end
    if self.isNeedShowUI then
        return false
    end
    return true
end