module("UIManager", package.seeall)

---@class UIPanelAssociatedGroupNameStackData
UIPanelAssociatedGroupNameStackData = class("UIPanelAssociatedGroupNameStackData")

function UIPanelAssociatedGroupNameStackData:ctor(groupName)

    --组名字
    self.groupName = groupName

    --此界面被后面打开的组中打开的相同界面覆盖了，后面的组的名字
    --如果覆盖的组关闭了，此界面要调用ActiveUI，重新设置数据
    self.overrideGroupName = nil

    --这俩个参数都是界面自己的状态，和所在的组无关
    --界面是否Active
    self.isPanelActive = true
    --界面是否被隐藏了
    self.isPanelHide = false

end

function UIPanelAssociatedGroupNameStackData:GetGroupName()
    return self.groupName
end
function UIPanelAssociatedGroupNameStackData:IsEqualToGroupName(groupName)
    return self.groupName == groupName
end

--设置此组的此界面被后面的组覆盖
function UIPanelAssociatedGroupNameStackData:SetOverrideGroupName(overrideGroupName)
    if overrideGroupName then
        --只有界面状态是打开的才会覆盖
        --打开状态，不管显示隐藏，覆盖的组关闭时都应该重新设置数据
        --关闭状态的界面再显示会重新打开，因此不用标记
        if self.isPanelActive then
            self.overrideGroupName = overrideGroupName
        end
    else
        self.overrideGroupName = nil
    end
end
function UIPanelAssociatedGroupNameStackData:GetOverrideGroupName()
    return self.overrideGroupName
end

--设置界面状态是Active的
--当设置界面状态是Active时，此界面必然是显示的，因此此时也会设置此界面不是隐藏的
function UIPanelAssociatedGroupNameStackData:SetPanelActive(isPanelActive)
    self.isPanelActive = isPanelActive
    self.isPanelHide = false
end

function UIPanelAssociatedGroupNameStackData:IsPanelActive()
    return self.isPanelActive
end

function UIPanelAssociatedGroupNameStackData:IsPanelHide()
    return self.isPanelHide
end

function UIPanelAssociatedGroupNameStackData:SetPanelHide(isPanelHide)
    self.isPanelHide = isPanelHide
end

--是否可见
function UIPanelAssociatedGroupNameStackData:IsVisible()

    if self.isPanelActive == false then
        return false
    end

    if self.isPanelHide then
        return false
    end

    return true

end







