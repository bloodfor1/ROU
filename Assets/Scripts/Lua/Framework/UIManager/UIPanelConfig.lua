module("UIManager", package.seeall)

-- 打开界面的配置
---@class UIPanelConfig
UIPanelConfig = class("UIPanelConfig")

function UIPanelConfig:ctor()

    --是否添加进当前的组中(栈顶的组)
    self.isInsertCurrentGroup = false

    --添加进一个组中，组的名字
    self.insertGroupName = nil

    --是否是Exclusive类型的界面
    self.isExclusive = false

    --是否是Standalone类型的界面
    self.isStandalone = false

    --是否在切场景的时候关闭
    self.isCloseOnSwitchScene = false

    --是否在所有场景都保持显示
    self.isKeepShowOnAllScene = false

    --只有自己是Exclusive类型的界面时才起作用
    --打开时不隐藏的组
    self.ignoreHideGroupNames = nil

    --在打开时是否隐藏
    --当打开的是一个界面，并且这个界面是加入一个组中时，会隐藏这个界面
    --当打开的是一个组时，会隐藏这个组里的所有界面
    self.isNeedHideOnActive = false

    --打开这个组的时候要隐藏的界面名字
    self.hidePanelNamesOnActive = nil

    --是否需要显示遮罩
    self.isNeedShowMask=false
    --遮罩颜色
    self.maskColor=nil
    --点击遮罩关闭某个界面
    self.closePanelNameOnClickMask=nil
    --遮罩过一段时间才能点击
    self.maskDelayClickTime=nil

    --组的容器的类型
    self.groupContainerType=nil

    --Canvas的SortingOrder
    self.overrideCanvasSortingOrder=nil

    --强制隐藏的界面
    self.forceHidePanelNames=nil

    --是否参与组的栈的处理
    self.isTakePartInGroupStack=false

end

function UIPanelConfig:SetInsertCurrentGroup(isInsertCurrentGroup)
    if isInsertCurrentGroup == nil then
        return
    end
    self.isInsertCurrentGroup = isInsertCurrentGroup
end

function UIPanelConfig:IsInsertCurrentGroup()
    return self.isInsertCurrentGroup
end

function UIPanelConfig:SetIsTakePartInGroupStack(isTakePartInGroupStack)
    if isTakePartInGroupStack == nil then
        return
    end
    self.isTakePartInGroupStack = isTakePartInGroupStack
end

function UIPanelConfig:IsTakePartInGroupStack()
    return self.isTakePartInGroupStack
end

function UIPanelConfig:SetInsertGroupName(insertGroupName)
    if insertGroupName == nil then
        return
    end
    self.insertGroupName = insertGroupName
end

function UIPanelConfig:GetInsertGroupName()
    return self.insertGroupName
end

function UIPanelConfig:SetExclusive(isExclusive)
    if isExclusive == nil then
        return
    end
    self.isExclusive = isExclusive
end

function UIPanelConfig:IsExclusive()
    return self.isExclusive
end

function UIPanelConfig:SetStandalone(isStandalone)
    if isStandalone == nil then
        return
    end
    self.isStandalone = isStandalone
end

function UIPanelConfig:IsStandalone()
    return self.isStandalone
end

function UIPanelConfig:SetIgnoreHideGroupNames(ignoreHideGroupNames)
    if ignoreHideGroupNames == nil then
        return
    end
    self.ignoreHideGroupNames = ignoreHideGroupNames
end

--添加忽略隐藏的组名字
function UIPanelConfig:AddIgnoreHideGroupNames(ignoreHideGroupName)
    if ignoreHideGroupName == nil then
        return
    end
    if self.ignoreHideGroupNames == nil then
        self.ignoreHideGroupNames = {}
    end
    table.insert(self.ignoreHideGroupNames, ignoreHideGroupName)
end

function UIPanelConfig:GetIgnoreHideGroupNames()
    return self.ignoreHideGroupNames
end

function UIPanelConfig:SetNeedHideOnActive(isNeedHideOnActive)
    if isNeedHideOnActive == nil then
        return
    end
    self.isNeedHideOnActive = isNeedHideOnActive
end

function UIPanelConfig:IsNeedHideOnActive()
    return self.isNeedHideOnActive
end

function UIPanelConfig:SetHidePanelNamesOnActive(hidePanelNamesOnActive)
    if hidePanelNamesOnActive == nil then
        return
    end
    self.hidePanelNamesOnActive = hidePanelNamesOnActive
end

--界面是否在Active时是要隐藏的
function UIPanelConfig:IsNeedHideOnActiveWithUIName(uiName)
    if self.isNeedHideOnActive then
        return true
    end

    if self.hidePanelNamesOnActive == nil then
        return false
    end

    table.ro_contains(self.hidePanelNamesOnActive, uiName)
end

--是否有需要在Active时是要隐藏的界面
function UIPanelConfig:IsHaveNeedHidePanelOnActive()
    if self.isNeedHideOnActive then
        return true
    end

    if self.hidePanelNamesOnActive ~= nil then
        return true
    end

    return false
end

function UIPanelConfig:SetNeedShowMask(isNeedShowMask)
    if isNeedShowMask == nil then
        return
    end
    self.isNeedShowMask=isNeedShowMask
end

function UIPanelConfig:SetMaskColor(maskColor)
    if maskColor == nil then
        return
    end
    self.maskColor=maskColor
end

function UIPanelConfig:SetClosePanelNameOnClickMask(closePanelNameOnClickMask)
    if closePanelNameOnClickMask == nil then
        return
    end
    self.closePanelNameOnClickMask=closePanelNameOnClickMask
end

function UIPanelConfig:IsNeedShowMask()
    return self.isNeedShowMask
end

function UIPanelConfig:GetMaskColor()
    return self.maskColor
end

function UIPanelConfig:GetClosePanelNameOnClickMask()
    return self.closePanelNameOnClickMask
end

function UIPanelConfig:SetMaskDelayClickTime(maskDelayClickTime)
    if maskDelayClickTime == nil then
        return
    end
    self.maskDelayClickTime=maskDelayClickTime
end

function UIPanelConfig:GetMaskDelayClickTime()
    return self.maskDelayClickTime
end

function UIPanelConfig:SetGroupContainerType(groupContainerType)
    if groupContainerType == nil then
        return
    end
    self.groupContainerType=groupContainerType
end

function UIPanelConfig:GetGroupContainerType()
    return self.groupContainerType
end

function UIPanelConfig:SetOverrideCanvasSortingOrder(overrideCanvasSortingOrder)
    if overrideCanvasSortingOrder == nil then
        return
    end
    self.overrideCanvasSortingOrder=overrideCanvasSortingOrder
end

function UIPanelConfig:GetOverrideCanvasSortingOrder()
    return self.overrideCanvasSortingOrder
end

function UIPanelConfig:SetForceHidePanelNames(forceHidePanelNames)
    if forceHidePanelNames == nil then
        return
    end
    self.forceHidePanelNames=forceHidePanelNames
end

function UIPanelConfig:GetForceHidePanelNames()
    return self.forceHidePanelNames
end

function UIPanelConfig:SetCloseOnSwitchScene(isCloseOnSwitchScene)
    if isCloseOnSwitchScene == nil then
        return
    end
    self.isCloseOnSwitchScene = isCloseOnSwitchScene
end

function UIPanelConfig:IsCloseOnSwitchScene()
    self:_checkCorrectness()
    return self.isCloseOnSwitchScene
end

function UIPanelConfig:SetKeepShowOnAllScene(isKeepShowOnAllScene)
    if isKeepShowOnAllScene == nil then
        return
    end
    self.isKeepShowOnAllScene = isKeepShowOnAllScene
end

function UIPanelConfig:IsKeepShowOnAllScene()
    self:_checkCorrectness()
    return self.isKeepShowOnAllScene
end

--检测参数设置的正确性
function UIPanelConfig:_checkCorrectness()
    if Application.isEditor == false then
        return
    end
    if self.isCloseOnSwitchScene and self.isKeepShowOnAllScene then
        logError("IsCloseOnSwitchScene和IsKeepShowOnAllScene不能都是True")
    end
end


