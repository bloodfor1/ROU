module("UIManager", package.seeall)

require "Framework/UIManager/UIPanelAssociatedGroupNameStack"

---@class UIPanelAssociatedGroupNameStackMap
UIPanelAssociatedGroupNameStackMap = class("UIPanelAssociatedGroupNameStackMap")

function UIPanelAssociatedGroupNameStackMap:ctor()
    --每个UI界面关联的Group名字都入栈
    self.stackMap = {}
end

function UIPanelAssociatedGroupNameStackMap:Push(uiName, groupName)
    self:_push(uiName, groupName)
end

function UIPanelAssociatedGroupNameStackMap:PushWithGroupDefine(groupDefine)

    local l_uiPanelNames = groupDefine.UIPanelNames
    for i = 1, #l_uiPanelNames do
        self:_push(l_uiPanelNames[i], groupDefine.GroupName)
    end

end

--uiName相关联的groupName入栈
function UIPanelAssociatedGroupNameStackMap:_push(uiName, groupName)

    local l_currentStack = self:_getOrCreateStack(uiName)

    l_currentStack:Push(groupName)

end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStackMap:Peek(uiName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        return nil
    end

    return l_currentStack:Peek()

end

--根据当前打开的所有组的顺序，把此次要打开的界面的数据插入到对应位置
function UIPanelAssociatedGroupNameStackMap:InsertWithGroupStack(uiName, groupName, groupStack)

    local l_currentStack = self:_getOrCreateStack(uiName)

    l_currentStack:InsertWithGroupStack(groupName, groupStack)

end

--根据界面名字取相关的栈，没有则创建
function UIPanelAssociatedGroupNameStackMap:_getOrCreateStack(uiName)
    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        l_currentStack = UIPanelAssociatedGroupNameStack.new(uiName)
        self.stackMap[uiName] = l_currentStack
    end
    return l_currentStack
end

function UIPanelAssociatedGroupNameStackMap:RemoveWithPanelNames(uiNames, groupName)

    if uiNames == nil then
        logError("传递的uiNames是空的")
        return
    end

    for i, uiName in pairs(uiNames) do
        self:_remove(uiName, groupName)
    end

end

function UIPanelAssociatedGroupNameStackMap:Remove(uiName, groupName)
    self:_remove(uiName, groupName)
end

function UIPanelAssociatedGroupNameStackMap:_remove(uiName, groupName)

    if uiName == nil then
        return
    end

    if groupName == nil then
        return
    end

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        return
    end

    l_currentStack:Remove(groupName)

end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStackMap:GetStackData(uiName, groupName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        logError("没有取到栈")
        return nil
    end

    return l_currentStack:GetStackData(groupName)
end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStackMap:GetLastStackData(uiName, groupName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        logError("没有取到栈")
        return nil
    end

    return l_currentStack:GetLastStackData(groupName)
end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStackMap:GetNextStackData(uiName, groupName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        return nil
    end

    return l_currentStack:GetNextStackData(groupName)
end

function UIPanelAssociatedGroupNameStackMap:SetPanelActiveFalse(uiName, groupName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        logError("没有取到栈")
        return nil
    end

    l_currentStack:SetPanelActiveFalse(groupName)

end

function UIPanelAssociatedGroupNameStackMap:IsHaveActivePanelOnBehind(uiName, groupName)

    local l_currentStack = self:GetStackWithUIName(uiName)
    if l_currentStack == nil then
        return false
    end

    return l_currentStack:IsHaveActivePanelOnBehind(groupName)

end

---@return UIPanelAssociatedGroupNameStack
function UIPanelAssociatedGroupNameStackMap:GetStackWithUIName(uiName)

    if uiName == nil then
        logError("传递的uiName是空的")
        return nil
    end

    local l_currentStack = self.stackMap[uiName]
    if l_currentStack == nil then
        return nil
    end
    return l_currentStack
end

function UIPanelAssociatedGroupNameStackMap:DebugLogStack()

    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    logYellow("以下是打印界面关联组中的所有名字")
    for uiName, panelAssociatedGroupNameStack in pairs(self.stackMap) do
        panelAssociatedGroupNameStack:DebugLogStack()
    end
end

return UIPanelAssociatedGroupNameStackMap




