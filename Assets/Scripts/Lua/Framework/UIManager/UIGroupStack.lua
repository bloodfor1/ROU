module("UIManager", package.seeall)

require "Framework/UIManager/UIGroup"
require "Core/System/Stack"

---@class UIGroupStack
UIGroupStack = class("UIGroupStack")

function UIGroupStack:ctor()

    --GroupName和Group类的键值对，便于查找
    ---@type table<string, UIGroup>
    self.groupMap = {}

    --GroupName的栈，用来保证显示顺序
    self.groupStack = {}

end

--把Group放入栈里
--每一个Group只会有一个，如果之前已经入栈，把此Group从栈里移到栈顶
---@return UIGroup
function UIGroupStack:Push(groupName)

    local l_currentGroup = self.groupMap[groupName]

    --如果没有此Group，创建一个Group，并入栈
    if l_currentGroup == nil then

        l_currentGroup = UIGroup.new(groupName)
        self.groupMap[groupName] = l_currentGroup

        table.insert(self.groupStack, groupName)

    else

        local l_index = -1
        local l_groupStackCount = #self.groupStack

        --如果Group已经入栈，取Group在栈里的Index
        for i = 1, l_groupStackCount do
            if self.groupStack[i] == groupName then
                l_index = i
                break
            end
        end

        --如果此Group不在栈顶,把此Group挪到栈顶
        --在栈顶就不用操作
        if l_index ~= l_groupStackCount then
            if l_index > 0 then
                table.remove(self.groupStack, l_index)
            end

            table.insert(self.groupStack, groupName)
        end

    end

    return l_currentGroup

end

--此方法会返回从栈顶开始第一个参与栈处理逻辑的组的名字
function UIGroupStack:GetTopGroupName()
    local groupCount = #self.groupStack
    if groupCount == 0 then
        logError("groupCount == 0")
        return nil
    end
    local groupName
    for i = #self.groupStack, 1, -1 do
        groupName = self.groupStack[i]
        local group = self.groupMap[groupName]
        if group == nil then
            logError("group == nil")
            return nil
        end
        if group:IsTakePartInGroupStack() then
            return groupName
        end
    end
    return nil
end

function UIGroupStack:Peek()
    local l_groupCount = #self.groupStack
    if l_groupCount == 0 then
        return nil
    end
    return self.groupStack[l_groupCount]
end

function UIGroupStack:Remove(groupName)
    local l_currentGroup = self.groupMap[groupName]
    if l_currentGroup == nil then
        return nil
    end

    self.groupMap[groupName] = nil

    table.ro_removeOneSameValue(self.groupStack, groupName)

    return l_currentGroup
end

---@return UIGroup
function UIGroupStack:GetGroup(groupName)
    return self.groupMap[groupName]
end

function UIGroupStack:IsGroupExist(groupName)
    if self.groupMap[groupName] == nil then
        return false
    end
    return true
end

--得到栈中groupName之前的所有Group
--返回值类型：Stack
function UIGroupStack:GetPreviousGroups(groupName)

    local l_groups = System.Stack.new()

    if groupName == nil then
        logError("传递的groupName是空的")
        return l_groups
    end

    for i = 1, #self.groupStack do
        if self.groupStack[i] == groupName then
            return l_groups
        end

        local l_group = self.groupMap[self.groupStack[i]]

        if l_group == nil then
            logError("没有取到此Group，groupName：" .. tostring(self.groupStack[i]))
            return l_groups
        end

        l_groups:Push(l_group)

    end

    logError("在栈中没有此Group，groupName：" .. tostring(groupName))

    return l_groups
end

function UIGroupStack:GetAllGroupNames()
    local l_groupNames = System.Stack.new()
    for i = 1, #self.groupStack do
        l_groupNames:Push(self.groupStack[i])
    end
    return l_groupNames
end

--从栈顶向下遍历
function UIGroupStack:Iterator(index)

    if index <= 0 then
        return nil, nil
    end

    local l_stackCount = #self.groupStack

    if index > l_stackCount then
        return nil, nil
    end

    local l_stackIndex = l_stackCount + 1 - index

    return index + 1, self.groupMap[self.groupStack[l_stackIndex]]

end

function UIGroupStack:DebugLogStack()

    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    logGreen("以下是打印UIGroupStack中的所有名字")

    for i = #self.groupStack, 1, -1 do

        l_groupName = self.groupStack[i]

        local l_group = self.groupMap[l_groupName]

        if l_group then
            l_group:DebugLog()
        else
            logError("没有这个组数据:" .. l_groupName)
        end
    end
end

return UIGroupStack


