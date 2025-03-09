module("UIManager", package.seeall)

require "Framework/UIManager/UIPanelAssociatedGroupNameStackData"

---@class UIPanelAssociatedGroupNameStack
UIPanelAssociatedGroupNameStack = class("UIPanelAssociatedGroupNameStack")

function UIPanelAssociatedGroupNameStack:ctor(uiName)

    --界面名字
    self.uiName = uiName
    --每个UI界面关联的Group名字都入栈
    ---@type UIPanelAssociatedGroupNameStackData[]
    self.stack = {}

end

--界面打开时调用
--uiName相关联的groupName入栈
function UIPanelAssociatedGroupNameStack:Push(groupName)
    --logRed("self.uiName:" .. self.uiName .. "  groupName:" .. groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    ---@type UIPanelAssociatedGroupNameStackData
    local l_stackData = self:_getOrCreateStackDataWithIndex(l_index, groupName)

    --如果此groupName在栈里
    if l_index > 0 then
        --如果此groupName不在栈顶,把此groupName挪到栈顶
        --在栈顶就不用操作
        if l_index ~= #self.stack then
            self:_removeStackWithIndex(l_index)

            self:_insertStack(l_stackData)

            self:_setOverrideGroupNameWithIndex(l_index)
        end
    else

        --如果groupName不在栈里，就加入栈
        self:_insertStack(l_stackData)

    end

    self:_setOverrideGroupNameWithIndex(#self.stack)

end

--根据当前打开的所有组的顺序，把此次要打开的界面的数据插入到对应位置
--默认界面状态是打开并显示的
function UIPanelAssociatedGroupNameStack:InsertWithGroupStack(insertGroupName, groupStack)

    --先取要加进的组所在的index
    --作用是判断这个组是否就已经打开过这个界面
    local l_index = self:_getStackIndexWithGroupName(insertGroupName)
    ---@type UIPanelAssociatedGroupNameStackData
    local l_stackData
    if l_index > 0 then
        --如果取到index，即这个组打开过这个界面，则把界面状态设置成打开状态
        l_stackData = self:_getStackDataWithIndex(l_index)
        if l_stackData == nil then
            logError("stackData == nil")
        else
            l_stackData:SetPanelActive(true)
        end
        return
    end

    --数据不存在，就创建数据
    l_stackData = UIPanelAssociatedGroupNameStackData.new(insertGroupName)

    --再判断栈里是否没有数据，没有数据就不用考虑插入到哪里了，直接加进去就可以了
    if #self.stack == 0 then
        self:_insertStack(l_stackData)
        return
    end

    l_index = -1
    --根据组在栈中的顺序取要插入的index
    for n, groupName in System.Stack.Iterator, groupStack, 1 do
        if groupName == insertGroupName then
            break
        end

        for i = 1, #self.stack do
            if self.stack[i]:GetGroupName() == groupName then
                l_index = i
                break
            end
        end
    end

    if l_index < 0 then
        l_index = #self.stack + 1
    end

    self:_insertStackWithIndex(l_stackData, l_index)

    self:_setOverrideGroupNameWithIndex(l_index)

end

function UIPanelAssociatedGroupNameStack:InsertToIndex(groupName, insertIndex)

    if insertIndex <= 0 then
        return
    end

    if insertIndex > #self.stack + 1 then
        return
    end

    local l_index = self:_getStackIndexWithGroupName(groupName)

    local l_stackData = self:_getOrCreateStackDataWithIndex(l_index, groupName)

    --先添加进去
    self:_insertStackWithIndex(l_stackData, insertIndex)

    --为了保证数据唯一，如果之前在
    if l_index > 0 then
        if l_index ~= insertIndex then
            self:_removeStackWithIndex(l_index)

            if l_index < insertIndex then
                insertIndex = insertIndex - 1
            end

            self:_insertStackWithIndex(l_stackData, insertIndex)

            self:_setOverrideGroupNameWithIndex(l_index)
        end
    else

        --如果groupName不在栈里，就加入栈
        self:_insertStackWithIndex(l_stackData, insertIndex)

    end

    self:_setOverrideGroupNameWithIndex(insertIndex)
end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStack:_getOrCreateStackDataWithIndex(index, groupName)
    ---@type UIPanelAssociatedGroupNameStackData
    local stackData = self:_getStackDataWithIndex(index)

    --把自己的数据设置成默认的
    if stackData then
        stackData:SetPanelActive(true)
    else
        stackData = UIPanelAssociatedGroupNameStackData.new(groupName)
    end
    return stackData
end

function UIPanelAssociatedGroupNameStack:_setOverrideGroupNameWithIndex(index)

    local l_lastIndex = index - 1
    local l_nextIndex = index + 1

    local l_lastStackData = self:_getStackDataWithIndex(l_lastIndex)

    local l_currentStackData = self:_getStackDataWithIndex(index)

    local l_nextStackData = self:_getStackDataWithIndex(l_nextIndex)

    if l_lastStackData then
        if l_currentStackData then
            l_lastStackData:SetOverrideGroupName(l_currentStackData:GetGroupName())
        else
            l_lastStackData:SetOverrideGroupName(nil)
        end
    end

    if l_currentStackData then
        if l_nextStackData then
            l_currentStackData:SetOverrideGroupName(l_nextStackData:GetGroupName())
        else
            l_currentStackData:SetOverrideGroupName(nil)
        end
    end

end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStack:_getStackDataWithIndex(index)
    if index <= 0 then
        return nil
    end
    if index > #self.stack then
        return nil
    end
    return self.stack[index]
end

function UIPanelAssociatedGroupNameStack:Remove(groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    if l_index <= 0 then
        return
    end

    self:_removeStackWithIndex(l_index)

    self:_setOverrideGroupNameWithIndex(l_index)

end

---@return UIPanelAssociatedGroupNameStackData
function UIPanelAssociatedGroupNameStack:Peek()

    local l_stackCount = #self.stack
    if l_stackCount == 0 then
        return nil
    end

    return self.stack[l_stackCount]

end

function UIPanelAssociatedGroupNameStack:GetStackData(groupName)

    local l_stackData = self:_getStackDataWithGroupName(groupName)

    if l_stackData == nil then
        --logError("没有找到这个组，组名字："..tostring(groupName))
        return
    end

    return l_stackData
end

function UIPanelAssociatedGroupNameStack:GetLastStackData(groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    l_index = l_index - 1

    if l_index <= 0 then
        return nil
    end

    return self.stack[l_index]
end

function UIPanelAssociatedGroupNameStack:GetNextStackData(groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    if l_index <= 0 then
        return nil
    end

    l_index = l_index + 1

    if l_index > #self.stack then
        return nil
    end

    return self.stack[l_index]
end

function UIPanelAssociatedGroupNameStack:SetPanelActiveFalse(groupName)

    local l_stackData = self:_getStackDataWithGroupName(groupName)

    if l_stackData == nil then
        return
    end

    l_stackData:SetPanelActive(false)
end

function UIPanelAssociatedGroupNameStack:IsHaveActivePanelOnBehind(groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    if l_index <= 0 then
        return false
    end

    local l_stackCount = #self.stack

    l_index = l_index + 1

    if l_index > l_stackCount then
        return false
    end

    for i = l_index, l_stackCount do
        if self.stack[i]:IsPanelActive() then
            return true
        end
    end

    return false
end

function UIPanelAssociatedGroupNameStack:_getStackDataWithGroupName(groupName)

    local l_index = self:_getStackIndexWithGroupName(groupName)

    if l_index <= 0 then
        return nil
    end

    return self.stack[l_index]
end

--从栈里取相应groupName的Index
function UIPanelAssociatedGroupNameStack:_getStackIndexWithGroupName(groupName)

    if groupName == nil then
        logError("传递的groupName是空的")
        return -1
    end

    if self.stack == nil then
        return -1
    end
    for i = #self.stack, 1, -1 do
        if self.stack[i]:IsEqualToGroupName(groupName) then
            return i
        end
    end

    return -1
end

function UIPanelAssociatedGroupNameStack:_removeStackWithIndex(index)
    --logRed(self.uiName.."界面移除，index："..index)
    table.remove(self.stack, index)
end

function UIPanelAssociatedGroupNameStack:_insertStack(stackData)
    --logRed(self.uiName.."界面添加，添加前个数："..tostring(#self.stack).."数据："..ToString(stackData))
    table.insert(self.stack, stackData)
end

function UIPanelAssociatedGroupNameStack:_insertStackWithIndex(stackData, index)
    --logRed(self.uiName.."界面添加，index："..index)
    table.insert(self.stack, index, stackData)
end

function UIPanelAssociatedGroupNameStack:Iterator(index)

    if index <= 0 then
        return nil, nil
    end

    local l_stackCount = #self.stack

    if index > l_stackCount then
        return nil, nil
    end

    local l_stackIndex = l_stackCount + 1 - index

    return index + 1, self.stack[l_stackIndex]

end

function UIPanelAssociatedGroupNameStack:DebugLogStack()

    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    logRed("--界面名字：" .. self.uiName .. ":")

    for i = #self.stack, 1, -1 do
        logGreen("----组名字：" .. self.stack[i]:GetGroupName() ..
                "  是否Active：" .. tostring(self.stack[i]:IsPanelActive()) ..
                "  被覆盖的组的名字:" .. tostring(self.stack[i]:GetOverrideGroupName()) ..
                "  是否Hide：" .. tostring(self.stack[i]:IsPanelHide()))
    end
end

return UIPanelAssociatedGroupNameStack




