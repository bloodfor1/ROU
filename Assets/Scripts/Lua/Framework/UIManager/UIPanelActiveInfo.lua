module("UIManager", package.seeall)

--界面打开的数据
---@class UIPanelActiveInfo
UIPanelActiveInfo = class("UIPanelActiveInfo")

function UIPanelActiveInfo:ctor()

    --是否需要打开
    self.isNeedActive = false
    --是否需要保持
    self.isNeedHoldOn = false
    --是否需要隐藏
    self.isNeedHide = false
    --界面的父物体
    self.panelParent=nil

end

function UIPanelActiveInfo:SetNeedActive(isNeedActive,panelParent)
    self.isNeedActive = isNeedActive
    if isNeedActive then
        self.panelParent=panelParent
    end
end

function UIPanelActiveInfo:GetPanelParent()
    if self.panelParent == nil then
        logError("界面的父物体没有创建")
    end
    return self.panelParent
end

function UIPanelActiveInfo:SetNeedHoldOn(isNeedHoldOn)
    self.isNeedHoldOn = isNeedHoldOn
end

function UIPanelActiveInfo:SetNeedHide(isNeedHide)
    self.isNeedHide = isNeedHide
end

function UIPanelActiveInfo:IsNeedActive()
    return self.isNeedActive
end

--只有不保持的界面并且设置为隐藏的界面才会隐藏
function UIPanelActiveInfo:IsNeedHide()

    if self.isNeedHoldOn then
        return false
    end

    return self.isNeedHide
end


