
module("UIManager", package.seeall)

require "Framework/UIManager/UIPanelActiveInfo"

--打开界面的时候对界面的操作和对组的操作信息
---@class UIGroupActiveInfo
UIGroupActiveInfo = class("UIGroupActiveInfo")

function UIGroupActiveInfo:ctor()

    self.uiPanelActiveInfoContainer={}

    self.hideGroups=nil

end

---@return UIPanelActiveInfo
function UIGroupActiveInfo:GetOrCreatePanelActiveInfo(uiName)
    local l_panelActiveInfo=self.uiPanelActiveInfoContainer[uiName]
    if l_panelActiveInfo == nil then
        l_panelActiveInfo=UIPanelActiveInfo.new()
        self.uiPanelActiveInfoContainer[uiName]=l_panelActiveInfo
    end
    return l_panelActiveInfo
end

function UIGroupActiveInfo:GetPanelActiveInfo(uiName)
    return self.uiPanelActiveInfoContainer[uiName]
end

function UIGroupActiveInfo:GetPanelActiveInfoContainer()
    return self.uiPanelActiveInfoContainer
end

function UIGroupActiveInfo:SetHideGroup(hideGroup)
    if hideGroup == nil then
        logError("设置隐藏的组，组是空的")
        return
    end
    if self.hideGroups == nil then
        self.hideGroups={}
    end
    table.insert(self.hideGroups,hideGroup)
end

function UIGroupActiveInfo:GetHideGroups()
    return self.hideGroups
end