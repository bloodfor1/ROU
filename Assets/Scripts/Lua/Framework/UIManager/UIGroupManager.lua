module("UIManager", package.seeall)

require "Core/System/Stack"

require "Framework/UIManager/UIGroupStack"
require "Framework/UIManager/UIPanelAssociatedGroupNameStackMap"

require "Framework/UIManager/UIGroupActiveInfo"
require "Framework/UIManager/UIGroupDeActiveInfo"

-- UI组管理类，UIManager中使用
UIGroupManager = class("UIGroupManager")

function UIGroupManager:ctor()
    self.groupStack = UIGroupStack.new()
    self.uiPanelAssociatedGroupNameStackMap = UIPanelAssociatedGroupNameStackMap.new()
    self.forceHidePanels = {}
end

---- Start 打开界面时对栈进行处理

--打开组时对栈进行处理
function UIGroupManager:ActiveGroupWithGroupDefine(groupDefine, uiPanelDatas, uiPanelConfig)
    if groupDefine == nil then
        return
    end
    self.uiPanelAssociatedGroupNameStackMap:PushWithGroupDefine(groupDefine)
    local l_currentGroup = self.groupStack:Push(groupDefine.GroupName)
    l_currentGroup:ActiveGroupWithGroupDefine(groupDefine, uiPanelDatas, uiPanelConfig)
end

--打开一个界面
function UIGroupManager:ActiveUIPanel(uiName, uiPanelData, uiPanelConfig)
    if uiName == nil then
        return
    end
    --取这个界面插入的组的名字
    local l_insertGroupName = self:_getInsertGroupName(uiPanelConfig)
    if l_insertGroupName then
        self:InsertPanelToGroup(l_insertGroupName, uiName, uiPanelData)
    else
        self:_activeGroupBySinglePanel(uiName, uiPanelData, uiPanelConfig)
    end
end

function UIGroupManager:_activeGroupBySinglePanel(uiName, uiPanelData, uiPanelConfig)
    local groupName = UIGroupDefine:GetGroupName(uiName)
    self.uiPanelAssociatedGroupNameStackMap:Push(uiName, groupName)
    local l_currentGroup = self.groupStack:Push(groupName)
    l_currentGroup:ActiveUIPanel(uiName, uiPanelData, uiPanelConfig)
    l_currentGroup:SetHideSelfGroupName(nil)
end

--把一个界面添加进一个组中
function UIGroupManager:InsertPanelToGroup(insertGroupName, uiName, uiPanelData)

    --先取要添加进的组数据
    local l_insertGroup = self.groupStack:GetGroup(insertGroupName)
    if l_insertGroup == nil then
        --组不存在就不处理
        --现在的逻辑不支持组没打开就打开要插入进此组的界面
        return
    end

    --如果这个组存在，则只把这个界面添加进这个组中，修改栈顺序
    l_insertGroup:ActiveUIPanel(uiName, uiPanelData)
    self.uiPanelAssociatedGroupNameStackMap:InsertWithGroupStack(uiName, insertGroupName, self.groupStack:GetAllGroupNames())

end

---- End 打开界面时对栈进行处理

---- Start 获取打开界面时的界面数据

--取界面处理数据，在打开界面时
function UIGroupManager:GetActiveInfosWithPanel(uiName, uiPanelConfig)

    local l_insertGroupName = self:_getInsertGroupName(uiPanelConfig)

    if l_insertGroupName then
        return self:_getGroupActiveInfoWithPanelInsertGroup(uiName, l_insertGroupName, uiPanelConfig)
    end

    return self:GetActiveInfosWithGroup(UIGroupDefine:GetGroupName(uiName), uiPanelConfig)
end

---@param uiPanelConfig UIPanelConfig
function UIGroupManager:_getInsertGroupName(uiPanelConfig)
    if uiPanelConfig == nil then
        return nil
    end
    l_insertGroupName = uiPanelConfig:GetInsertGroupName()

    if l_insertGroupName then
        return l_insertGroupName
    end

    if uiPanelConfig:IsInsertCurrentGroup() then
        l_insertGroupName = self:GetTopGroupName()
    end

    return l_insertGroupName
end

--取界面处理数据，这个界面是添加进一个组中的
--界面添加进一个组时，组在栈中的顺序不会变化，因此要考虑此组后面的组
function UIGroupManager:_getGroupActiveInfoWithPanelInsertGroup(uiName, insertGroupName, uiPanelConfig)
    return self:_getGroupActiveInfoWithPanelInsertGroupInternalProcessing(uiName, insertGroupName, nil, uiPanelConfig)
end

--取界面处理数据，这些界面是添加进一个组中的
function UIGroupManager:_getGroupActiveInfoWithMultiplePanelsInsertGroup(uiNames, insertGroupName, uiPanelConfig)
    if uiNames == nil then
        return nil
    end
    if insertGroupName == nil then
        return nil
    end

    local l_groupActiveInfo
    for i = 1, #uiNames do
        l_groupActiveInfo = self:_getGroupActiveInfoWithPanelInsertGroupInternalProcessing(uiNames[i], insertGroupName, l_groupActiveInfo, uiPanelConfig)
    end
    return l_groupActiveInfo
end

--取界面处理数据，这个界面是添加进一个组中的
--界面添加进一个组时，组在栈中的顺序不会变化，因此要考虑此组后面的组
---@param groupActiveInfo UIGroupActiveInfo
---@param uiPanelConfig UIPanelConfig
function UIGroupManager:_getGroupActiveInfoWithPanelInsertGroupInternalProcessing(uiName, insertGroupName, groupActiveInfo, uiPanelConfig)

    if uiName == nil then
        logError("uiName == nil")
        return groupActiveInfo
    end

    if insertGroupName == nil then
        logError("insertGroupName == nil")
        return groupActiveInfo
    end

    local l_group = self.groupStack:GetGroup(insertGroupName)
    if l_group == nil then
        logRed("此界面设置是添加进别的组中，但是要添加进的组并没有打开，请查看是否逻辑有问题,界面名字：" .. uiName.." 组名字："..tostring(insertGroupName))
        return groupActiveInfo
    end

    local l_groupTransform = l_group:GetGroupTransform()

    if l_groupTransform == nil then
        logRed("此界面设置是添加进别的组中，但是要添加进的组并没有打开，请查看是否逻辑有问题,界面名字：" .. uiName.." 组名字："..tostring(insertGroupName))
        return groupActiveInfo
    end

    --如果这个界面在这个组后面是打开的，这个界面不需要处理
    if self.uiPanelAssociatedGroupNameStackMap:IsHaveActivePanelOnBehind(uiName, insertGroupName) then
        return groupActiveInfo
    end

    if groupActiveInfo == nil then
        groupActiveInfo = UIGroupActiveInfo.new()
    end
    local l_panelActiveInfo = groupActiveInfo:GetOrCreatePanelActiveInfo(uiName)

    l_panelActiveInfo:SetNeedActive(true, l_groupTransform)

    --如果这个界面要加入的组是隐藏的，则要把此界面也隐藏
    if l_group:IsGroupHide() then
        l_panelActiveInfo:SetNeedHide(true)
    end

    if uiPanelConfig then
        if uiPanelConfig:IsNeedHideOnActive() then
            l_panelActiveInfo:SetNeedHide(true)
        end
    end

    return groupActiveInfo
end

--取界面处理数据，在打开组时
function UIGroupManager:GetActiveInfosWithGroup(groupName, uiPanelConfig)
    --先处理的栈，因此绝对能取到Group数据
    local l_activeGroup = self.groupStack:GetGroup(groupName)

    self:_onBeforeActiveGroup(l_activeGroup, uiPanelConfig)

    local l_groupActiveInfo = self:_getActiveInfosWithExclusiveGroup(l_activeGroup, uiPanelConfig)

    self:_dealWithActiveInfosWithPanelConfig(l_activeGroup, l_groupActiveInfo, uiPanelConfig)

    return l_groupActiveInfo
end

--在打开组之前做一些处理
---@param activeGroup UIGroup
function UIGroupManager:_onBeforeActiveGroup(activeGroup, uiPanelConfig)

    activeGroup:CreateGroupGameObject(uiPanelConfig)

end

--根据界面配置数据对得到的打开界面数据进行处理
---@param activeGroup UIGroup
---@param groupActiveInfo UIGroupActiveInfo
---@param uiPanelConfig UIPanelConfig
function UIGroupManager:_dealWithActiveInfosWithPanelConfig(activeGroup, groupActiveInfo, uiPanelConfig)
    if groupActiveInfo == nil then
        return
    end

    local l_currentGroupPanelNames = activeGroup:GetPanelNames()
    ---@type UIPanelActiveInfo
    local l_panelActiveInfo
    --遍历组的所有界面
    for i, uiName in pairs(l_currentGroupPanelNames) do

        l_panelActiveInfo = groupActiveInfo:GetOrCreatePanelActiveInfo(uiName)

        --logYellow("_dealWithActiveInfosWithPanelConfig,uiName:"..tostring(uiName)..
        --        "  IsNeedHideOnActiveWithUIName:"..tostring(uiPanelConfig:IsNeedHideOnActiveWithUIName(uiName)))

        --如果配置此界面要隐藏，设置为隐藏
        if uiPanelConfig:IsNeedHideOnActiveWithUIName(uiName) then
            l_panelActiveInfo:SetNeedHoldOn(false)
            l_panelActiveInfo:SetNeedHide(true)
        end

        --如果此界面为强制隐藏状态，则设置不打开
        if self:IsPanelForceHide(uiName) then

            l_panelActiveInfo:SetNeedActive(false)

            local l_uiPanelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:Peek(uiName)

            if l_uiPanelAssociatedGroupNameStackData then
                --界面数据设置为关闭
                l_uiPanelAssociatedGroupNameStackData:SetPanelActive(false)
            end
        end
    end
end

--取界面处理数据，在打开Exclusive组时
---@param activeGroup UIGroup
---@param uiPanelConfig UIPanelConfig
function UIGroupManager:_getActiveInfosWithExclusiveGroup(activeGroup, uiPanelConfig)

    if activeGroup == nil then
        logError("组数据是空的")
        return nil
    end

    local l_isExclusive = false

    local l_ignoreHideGroupNames
    if uiPanelConfig then
        if uiPanelConfig:IsExclusive() then
            l_isExclusive = true
        end
        l_ignoreHideGroupNames = uiPanelConfig:GetIgnoreHideGroupNames()
    end

    --此界面之前缓存的隐藏组的名字
    local l_lastHideGroupNames = activeGroup:GetHideGroupNames()

    --需要处理的界面数据
    --键值对形式
    local l_groupActiveInfo = UIGroupActiveInfo.new()

    local l_activeGroupName = activeGroup:GetGroupName()

    --先标记当前打开的组中的界面都是需要打开的，并且是需要保持显示的
    local l_currentGroupPanelNames = activeGroup:GetPanelNames()
    local l_groupTransform = activeGroup:GetGroupTransform()
    for i, uiName in pairs(l_currentGroupPanelNames) do

        local l_uiPanelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:GetStackData(uiName, l_activeGroupName)

        if l_uiPanelAssociatedGroupNameStackData:IsPanelActive() then
            local l_panelActiveInfo = l_groupActiveInfo:GetOrCreatePanelActiveInfo(uiName)

            l_panelActiveInfo:SetNeedActive(true, l_groupTransform)
            l_panelActiveInfo:SetNeedHoldOn(true)
        end

    end

    if not l_isExclusive then
        --如果当前不是Exclusive类型，但之前打开的时候是Exclusive类型，不予支持，报错
        if l_lastHideGroupNames then
            logError("当前不是Exclusive类型，但之前打开的时候是Exclusive类型")
        end
        --如果打开的界面不是Exclusive类型界面，不用对此组之前的组进行处理
        return l_groupActiveInfo
    end

    --隐藏的组的名字
    local l_hideGroupNames = {}

    local l_isDealWithFinish = false



    --栈顶是当前打开的组，从栈顶的第二个元素开始处理
    for i, group in UIGroupStack.Iterator, self.groupStack, 2 do

        self:_fillHideGroup(group, l_ignoreHideGroupNames, l_hideGroupNames, l_groupActiveInfo, l_activeGroupName)

        --栈里组是唯一的，因此处理完一次后就不需要再处理
        if not l_isDealWithFinish then
            l_isDealWithFinish = self:_dealWithCacheHideGroupNames(group, l_activeGroupName, l_lastHideGroupNames)
        end
    end

    --设置当前组隐藏的组名字
    activeGroup:SetHideGroupNames(l_hideGroupNames)

    return l_groupActiveInfo
end

--填充打开界面数据
---@param hideGroup UIGroup
---@param groupActiveInfo UIGroupActiveInfo
function UIGroupManager:_fillHideGroup(hideGroup, ignoreHideGroupNames, hideGroupNames, groupActiveInfo, activeGroupName)

    --如果此组是隐藏的，但并不是当前打开的组隐藏的，不用处理
    local l_hideSelfGroupName = hideGroup:GetHideSelfGroupName()
    if l_hideSelfGroupName then
        if l_hideSelfGroupName ~= activeGroupName then
            return
        end
    end

    local l_isNeedHoldOn = false

    --Standalone类型不会被隐藏
    if hideGroup:IsStandalone() then
        l_isNeedHoldOn = true
    end

    local l_groupName = hideGroup:GetGroupName()

    --如果忽略隐藏的组的配置中有此组，不隐藏
    if ignoreHideGroupNames then
        if table.ro_contains(ignoreHideGroupNames, l_groupName) then
            l_isNeedHoldOn = true
        end
    end

    l_groupPanelNames = hideGroup:GetPanelNames()

    --填充隐藏界面数据
    for i, uiName in pairs(l_groupPanelNames) do
        local l_panelActiveInfo = groupActiveInfo:GetOrCreatePanelActiveInfo(uiName)

        --如果这个组是要显示的
        if l_isNeedHoldOn then
            l_panelActiveInfo:SetNeedHoldOn(true)
        else
            l_panelActiveInfo:SetNeedHide(true)
        end
    end

    if not l_isNeedHoldOn then

        --设置这个组是被打开的组隐藏的
        hideGroup:SetHideSelfGroupName(activeGroupName)

        table.insert(hideGroupNames, l_groupName)

        groupActiveInfo:SetHideGroup(hideGroup)

    end

end

--此方法是处理以下情况：
--当前打开的组在之前已经被打开过，并且被后面的组给隐藏了；此时又再次打开这个组，这时会调整栈，并且显示这个组
--此方法要处理的就是隐藏了当前打开的组的组（以下称为“待处理组”）
--要对待处理组存储的隐藏了哪些组的数据进行调整
--进行如下两个调整：
--1、把待处理组的隐藏组列表中存储的当前组移除
--2、把当前组之前隐藏的组都加入到待处理组的隐藏组列表中
--needDealWithGroup 需要处理的组
--groupName 此次打开的组的名字
--lastHideGroupNames 此次打开的组在上次打开的时候存储的隐藏组
---@param needDealWithGroup UIGroup
function UIGroupManager:_dealWithCacheHideGroupNames(needDealWithGroup, groupName, lastHideGroupNames)

    --先取出组中的隐藏组名字
    local l_groupHideGroupName = needDealWithGroup:GetHideGroupNames()

    --没有不处理
    if l_groupHideGroupName == nil then
        return false
    end

    --判断这个组中隐藏的组是否包含此次打开的组的名字
    --不包含不处理
    if not table.ro_contains(l_groupHideGroupName, groupName) then
        return false
    end

    --移除此次打开的组的名字
    table.ro_removeOneSameValue(l_groupHideGroupName, groupName)

    --把当前组之前隐藏的组都加入到待处理组的隐藏组列表中
    if lastHideGroupNames then
        table.ro_insertRange(l_groupHideGroupName, lastHideGroupNames)
    end

    return true
end


---- End 获取打开界面时的界面数据

---- Start 关闭界面处理

--得到关闭组数据，并且对栈进行处理
--此时要关闭的是一个组
function UIGroupManager:GetDeActiveGroupInfoAndDealWithStackWithGroupName(groupName)

    local l_currentGroup = self.groupStack:GetGroup(groupName)

    if l_currentGroup == nil then
        return nil
    end

    local l_deActiveGroupInfo = self:_getDeActiveGroupInfoAndDealWithStackWithGroup(l_currentGroup)

    return l_deActiveGroupInfo
end

--得到关闭组数据，并且对栈进行处理
--返回是nil的话会只关闭这个界面
--IsHaveActivePanelOnBehind 界面是否在后面打开
--IsNeedReActive 是否需要重新打开
--ReActivePanelData 重新打开界面需要的数据
function UIGroupManager:GetDeActiveGroupInfoAndDealWithStack(uiName)

    local l_groupName = self:GetGroupNameAccordingToPanelName(uiName)

    if l_groupName == nil then
        return nil
    end

    local l_currentGroup = self.groupStack:GetGroup(l_groupName)

    if l_currentGroup == nil then
        logGreen("组数据是空的")
        return nil
    end

    --如果此界面不是组的主功能界面
    if not l_currentGroup:IsGroupMainUIPanel(uiName) then
        --设置此界面是关闭的
        self.uiPanelAssociatedGroupNameStackMap:SetPanelActiveFalse(uiName, l_groupName)
        return nil
    end

    local l_deActiveGroupInfo = self:_getDeActiveGroupInfoAndDealWithStackWithGroup(l_currentGroup)

    return l_deActiveGroupInfo
end

--根据组数据，得到关闭组数据，并且对栈进行处理
---@param deActiveGroup UIGroup
function UIGroupManager:_getDeActiveGroupInfoAndDealWithStackWithGroup(deActiveGroup)

    local l_deActiveGroupInfo = self:_getDeActiveGroupInfo(deActiveGroup)

    self:_dealWithDeActiveGroupStack(deActiveGroup)

    --当前关闭的组会把此组隐藏的组都打开
    --设置之前隐藏的组中存储数据
    ---@type UIGroup
    local l_hideGroup
    local l_hideGroupNames = deActiveGroup:GetHideGroupNames()
    if l_hideGroupNames then
        for i = 1, #l_hideGroupNames do
            l_hideGroup = self.groupStack:GetGroup(l_hideGroupNames[i])
            if l_hideGroup then
                l_hideGroup:SetHideSelfGroupName(nil)
            end
        end
    end

    return l_deActiveGroupInfo

end

--获取关闭界面数据
---@param deActiveGroup UIGroup
function UIGroupManager:_getDeActiveGroupInfo(deActiveGroup)

    local l_deActiveGroupInfo = UIGroupDeActiveInfo.new(deActiveGroup)

    local l_groupName = deActiveGroup:GetGroupName()

    self:_fillDeActivePanelInfosWithDeActiveGroup(l_deActiveGroupInfo, deActiveGroup, l_groupName)

    local l_hideGroupNames = deActiveGroup:GetHideGroupNames()
    local l_previousActiveGroups = self:_getPreviousActiveGroups(l_hideGroupNames, l_groupName)
    if l_hideGroupNames then
        for i = 1, #l_hideGroupNames do
            l_deActiveGroupInfo:SetNeedShowGroup(self.groupStack:GetGroup(l_hideGroupNames[i]))
        end
    end

    for i, previousGroup in System.Stack.Iterator, l_previousActiveGroups, 1 do
        --logGreen("previousActiveGroups,groupName:"..group:GetGroupName())
        self:_fillDeActivePanelInfosWithPreviousGroup(l_deActiveGroupInfo, previousGroup, l_groupName)
    end

    return l_deActiveGroupInfo
end

--填充关闭的组的关闭界面数据
---@param deActiveGroupInfo UIGroupDeActiveInfo
---@param deActiveGroup UIGroup
function UIGroupManager:_fillDeActivePanelInfosWithDeActiveGroup(deActiveGroupInfo, deActiveGroup, deActiveGroupName)

    local l_groupPanelNames = deActiveGroup:GetPanelNames()

    for i, uiName in pairs(l_groupPanelNames) do

        --所有关闭的界面都创建一个数据
        local l_deActivePanelInfo = deActiveGroupInfo:GetOrCreatePanelDeActiveInfo(uiName)

        --再判断是否后面打开了这个界面
        l_deActivePanelInfo:SetHaveActivePanelOnBehind(self.uiPanelAssociatedGroupNameStackMap:IsHaveActivePanelOnBehind(uiName, deActiveGroupName))
    end
end

--取得关闭的组之前的需要处理的组
function UIGroupManager:_getPreviousActiveGroups(hideGroupNames, groupName)

    local l_previousActiveGroups = System.Stack.new()

    --local l_hideGroupNames = deActiveGroup:GetHideGroupNames()

    --if l_hideGroupNames then
    --    for i = 1, #l_hideGroupNames do
    --        logGreen("l_hideGroupNames:"..l_hideGroupNames[i])
    --    end
    --end


    --取到此组之前的所有组
    local l_previousGroups = self.groupStack:GetPreviousGroups(groupName)

    for i, previousGroup in System.Stack.Iterator, l_previousGroups, 1 do

        --logGreen("PreviousGroups,groupName:"..previousGroup:GetGroupName())

        --如果这个组是隐藏的
        if previousGroup:IsGroupHide() then
            --如果是关闭的组把此组隐藏的，则加进处理组中
            if hideGroupNames then
                if table.ro_contains(hideGroupNames, previousGroup:GetGroupName()) then
                    l_previousActiveGroups:Push(previousGroup)
                end
            end
        else
            --如果这个组是显示状态的，加进处理组中
            l_previousActiveGroups:Push(previousGroup)
        end

    end

    return l_previousActiveGroups

end

--填充关闭的组之前的组的关闭界面数据
---@param previousGroup UIGroup
function UIGroupManager:_fillDeActivePanelInfosWithPreviousGroup(deActiveGroupInfo, previousGroup, deActiveGroupName)

    local l_groupPanelNames = previousGroup:GetPanelNames()

    for i, previousGroupPanelName in pairs(l_groupPanelNames) do

        self:_fillDeActivePanelInfoWithPreviousPanel(deActiveGroupInfo, deActiveGroupName, previousGroup, previousGroupPanelName)

    end
end

--一个组关闭后，这个组前面的组里的界面的显示状态需要进行处理
--只会处理这个组的界面对之前的组的界面进行影响的界面数据
--比如：这个组隐藏了前面的组、这个组中的界面覆盖的前面组的界面
---@param deActiveGroupInfo UIGroupDeActiveInfo
---@param previousGroup UIGroup
function UIGroupManager:_fillDeActivePanelInfoWithPreviousPanel(deActiveGroupInfo, deActiveGroupName, previousGroup, previousGroupPanelName)

    --logGreen("开始处理界面关闭数据,界面名字:"..previousGroupPanelName.. "  当前要处理的组名字:"..previousGroup:GetGroupName().." 要关闭的组名字:"..deActiveGroupName)

    local l_deActivePanelInfo = deActiveGroupInfo:GetPanelDeActiveInfo(previousGroupPanelName)

    if l_deActivePanelInfo then
        --如果后面有打开的，不再处理
        if l_deActivePanelInfo:IsHaveActivePanelOnBehind() then
            --logYellow("IsHaveActivePanelOnBehind,uiName:"..previousGroupPanelName)
            return
        end
        --如果已经设置了要重新显示，不再处理
        if l_deActivePanelInfo:IsNeedShowUI() then
            --logYellow("IsNeedShowUI,uiName:"..previousGroupPanelName)
            return
        end
        --如果已经设置了要重新打开，不再处理
        if l_deActivePanelInfo:IsNeedReActive() then
            --logYellow("IsNeedReActive,uiName:"..previousGroupPanelName)
            return
        end
    end

    local l_previousGroupName = previousGroup:GetGroupName()

    --这个界面在之前的组中的状态
    local l_uiPanelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:GetStackData(previousGroupPanelName, l_previousGroupName)

    if l_uiPanelAssociatedGroupNameStackData == nil then
        logError("uiPanelAssociatedGroupNameStackData是空的,uiName:" .. previousGroupPanelName)
        return
    end

    --这个界面在这个组中是关闭状态（即这个组的内部逻辑关闭的这个界面），此时不用处理
    if not l_uiPanelAssociatedGroupNameStackData:IsPanelActive() then
        --logYellow("not IsPanelActive,uiName:"..previousGroupPanelName)
        return
    end

    --这个界面在这个组中是隐藏状态（即这个组的内部逻辑隐藏的这个界面），此时不用处理
    if l_uiPanelAssociatedGroupNameStackData:IsPanelHide() then
        --logYellow("IsPanelHide,uiName:"..previousGroupPanelName)
        return
    end

    local l_overrideGroupName = l_uiPanelAssociatedGroupNameStackData:GetOverrideGroupName()

    if l_overrideGroupName then
        --如果当前关的组并不是覆盖此界面的组
        if l_overrideGroupName ~= deActiveGroupName then
            --如果覆盖此界面的组还在
            --正常情况下执行到这里此方法一定返回true
            if not self.groupStack:IsGroupExist(l_overrideGroupName) then
                logError("覆盖此界面的组不存在了，界面名字：" .. previousGroupPanelName .. "  覆盖的组名字：" .. l_overrideGroupName)
            end
            return
        end
    end

    if l_deActivePanelInfo == nil then

        --如果之前没有缓存数据，再取一次后面有没有打开这个界面
        --只要后面有打开这个界面，就不用处理
        if self.uiPanelAssociatedGroupNameStackMap:IsHaveActivePanelOnBehind(previousGroupPanelName, l_previousGroupName) then
            --logYellow("isHaveActivePanelOnBehind,uiName:"..previousGroupPanelName)
            return
        end

        --如果这个界面没有被后面组中的界面覆盖
        if l_overrideGroupName == nil then

            --如果这个界面所在的组不是被后面的组隐藏了，不用处理
            if not previousGroup:IsGroupHide() then
                --logYellow("not previousGroup:IsGroupHide(),uiName:"..previousGroupPanelName)
                return
            end
        end

        l_deActivePanelInfo = deActiveGroupInfo:GetOrCreatePanelDeActiveInfo(previousGroupPanelName)
    end

    --logYellow("界面名字:"..previousGroupPanelName.."  覆盖的组名字:"..tostring(l_overrideGroupName))

    --由于界面关闭的情况下直接显示界面是不会显示的，此时需要重新打开界面
    --因此不管是设置重新打开还是显示，界面重新打开的数据都要赋值
    l_deActivePanelInfo:SetDeActivePanelGroupData(previousGroup)

    --被覆盖只会有一个
    if l_overrideGroupName then
        l_deActivePanelInfo:SetNeedReActive(true)
    else
        --被隐藏可能会有多个，不过只设置一个变量，因此不需要处理多个的情况
        l_deActivePanelInfo:SetNeedShowUI(true)
    end
end

--关闭组时对栈进行处理
---@param group UIGroup
function UIGroupManager:_dealWithDeActiveGroupStack(group)

    local l_groupName = group:GetGroupName()

    --logYellow("_dealWithDeActiveGroupStack:"..l_groupName)

    --当此界面是组的主功能界面时，把此组相关的数据都出栈
    self.groupStack:Remove(l_groupName)

    local l_groupPanelNames = group:GetPanelNames()

    self.uiPanelAssociatedGroupNameStackMap:RemoveWithPanelNames(l_groupPanelNames, l_groupName)
end

---- End 关闭界面处理

--- Start 替换组中的界面

--1、对于之前在组中现在依然还在组中的界面，重新设置此界面的状态是Active的
function UIGroupManager:ResetHoldPanelActiveStatusOnExchangeGroup(groupDefine)
    local l_groupName = groupDefine.GroupName

    local l_currentGroup = self.groupStack:GetGroup(l_groupName)

    if l_currentGroup == nil then
        return
    end

    local l_currentGroupPanelNames = l_currentGroup:GetPanelNames()

    local l_groupDefinePanelNames = groupDefine.UIPanelNames

    --组中有这个界面，新的配置中也有这个界面，设置这个界面的状态是Active的
    local l_uiName
    for i = 1, #l_groupDefinePanelNames do
        l_uiName = l_groupDefinePanelNames[i]
        if table.ro_contains(l_currentGroupPanelNames, l_uiName) then
            self:_setPanelStatusToActive(l_uiName, l_groupName)
        end
    end
end

--设置界面状态是Active的
function UIGroupManager:_setPanelStatusToActive(uiName, groupName)
    local l_uiPanelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:GetStackData(uiName, groupName)
    if l_uiPanelAssociatedGroupNameStackData == nil then
        return
    end
    l_uiPanelAssociatedGroupNameStackData:SetPanelActive(true)
end

--2、先处理要移除的界面
function UIGroupManager:GetRemovePanelInfosOnExchangeGroupAndDealWithStack(groupDefine)

    --根据配置，取出来需要从组中移除的界面
    local l_removePanelNames = self:_getRemovePanelsOnActiveGroup(groupDefine)
    if l_removePanelNames == nil then
        return nil
    end

    local l_groupName = groupDefine.GroupName
    --只有界面在这个组后面的组没有打开的情况下才会关闭
    local l_realDeActivePanelNames = {}
    for i = 1, #l_removePanelNames do

        local l_uiName = l_removePanelNames[i]

        --如果后面的组中这个界面是打开的，不关闭
        if not self.uiPanelAssociatedGroupNameStackMap:IsHaveActivePanelOnBehind(l_uiName, l_groupName) then
            table.insert(l_realDeActivePanelNames, l_uiName)
        end

        --移除此界面的栈数据
        self.uiPanelAssociatedGroupNameStackMap:Remove(l_uiName, l_groupName)
    end

    return l_realDeActivePanelNames
end

--3、取要添加进组中的界面
function UIGroupManager:GetAddPanelsOnExchangeGroup(groupDefine)
    local l_groupName = groupDefine.GroupName

    local l_currentGroup = self.groupStack:GetGroup(l_groupName)

    if l_currentGroup == nil then
        return nil
    end

    local l_currentGroupPanelNames = l_currentGroup:GetPanelNames()

    local l_groupDefinePanelNames = groupDefine.UIPanelNames

    local l_addPanelNames

    --如果再打开的组中没有这个界面，添加进移除列表，之后会直接关闭这个界面
    local l_uiName
    for i = 1, #l_groupDefinePanelNames do
        l_uiName = l_groupDefinePanelNames[i]
        if not table.ro_contains(l_currentGroupPanelNames, l_uiName) then
            if l_addPanelNames == nil then
                l_addPanelNames = {}
            end
            table.insert(l_addPanelNames, l_uiName)
        end
    end
    return l_addPanelNames
end

--4、处理要添加的界面
function UIGroupManager:GetGroupActiveInfoOnExchangeGroup(groupDefine, insertGroupName, addPanelNames, uiPanelConfig)

    if insertGroupName == nil then
        return nil
    end

    --先取出来添加进组中的界面开启数据
    local l_groupActiveInfo = self:_getGroupActiveInfoWithMultiplePanelsInsertGroup(addPanelNames, insertGroupName, uiPanelConfig)

    if l_groupActiveInfo == nil then
        l_groupActiveInfo = UIGroupActiveInfo.new()
    end

    local l_group = self.groupStack:GetGroup(insertGroupName)

    if l_group == nil then
        logError("l_group == nil")
        return nil
    end

    local l_groupTransform = l_group:GetGroupTransform()

    if l_groupTransform == nil then
        logError("l_groupTransform == nil")
        return nil
    end

    local l_isGroupHide = l_group:IsGroupHide()

    --再遍历需要打开的所有的界面
    local l_groupDefinePanelNames = groupDefine.UIPanelNames
    local l_uiName
    local l_panelActiveInfo
    local l_lastStackData
    for i = 1, #l_groupDefinePanelNames do
        l_uiName = l_groupDefinePanelNames[i]
        --只有这个组里的这个界面没有在后面的组中的情况下才会处理这个界面
        l_lastStackData = self.uiPanelAssociatedGroupNameStackMap:GetNextStackData(l_uiName, insertGroupName)
        if l_lastStackData == nil then
            l_panelActiveInfo = l_groupActiveInfo:GetOrCreatePanelActiveInfo(l_uiName)
            l_panelActiveInfo:SetNeedActive(true, l_groupTransform)
            if l_isGroupHide then
                l_panelActiveInfo:SetNeedHide(true)
            end
        else
            l_panelActiveInfo = l_groupActiveInfo:GetPanelActiveInfo(l_uiName)
            if l_panelActiveInfo then
                l_panelActiveInfo:SetNeedActive(false)
                l_panelActiveInfo:SetNeedHoldOn(false)
                l_panelActiveInfo:SetNeedHide(false)
            end
        end
    end

    return l_groupActiveInfo
end

--5、对加进组中的界面的栈数据进行处理
function UIGroupManager:DealWithAddPanelsStackOnExchangeGroup(insertGroupName, uiNames)
    if insertGroupName == nil then
        return
    end
    if uiNames == nil then
        return
    end

    if not self.groupStack:IsGroupExist(insertGroupName) then
        return
    end

    local l_allGroupNames = self.groupStack:GetAllGroupNames()

    for i = 1, #uiNames do
        self.uiPanelAssociatedGroupNameStackMap:InsertWithGroupStack(uiNames[i], insertGroupName, l_allGroupNames)
    end
end

--6、替换组数据中存储的界面配置数据
function UIGroupManager:ExchangeGroupPanelsWithGroupDefine(groupDefine, uiPanelDatas, uiGroupConfigData)

    if groupDefine == nil then
        return
    end

    local l_currentGroup = self.groupStack:GetGroup(groupDefine.GroupName)
    if l_currentGroup == nil then
        logError("组不存在，替换组的配置数据需要这个组存在，组名字：" .. tostring(groupDefine.GroupName))
        return
    end
    l_currentGroup:ExchangeGroupDefine(groupDefine, uiPanelDatas, uiGroupConfigData)

end

--- End 替换组中的界面

function UIGroupManager:GetTopGroupName()
    return self.groupStack:GetTopGroupName()
end

--主动调用ActiveGroup时会调用
--此次要打开的组之前是打开的，但两次打开需要显示的界面不同
--此时会对比之前开启的界面和当前要开启的界面，把之前开启但现在不再开启的界面都移除出组，关闭并处理栈
--打开的组直接设置在栈顶，不需要考虑后面的组
--关闭界面是组内部操作，也不需要考虑前面的组
function UIGroupManager:GetRemovePanelInfosOnActiveGroupAndDealWithStack(groupDefine)

    local l_removePanelNames = self:_getRemovePanelsOnActiveGroup(groupDefine)

    if l_removePanelNames == nil then
        return nil
    end

    local l_groupName = groupDefine.GroupName

    --处理栈
    self.uiPanelAssociatedGroupNameStackMap:RemoveWithPanelNames(l_removePanelNames, l_groupName)

    --这里对打开一个组的情况进行特殊处理
    --如果要移除的界面在前面的组中是打开状态的，此时要对界面数据设置覆盖此界面的组的信息
    local l_panelAssociatedGroupNameStackData
    for i = 1, #l_removePanelNames do
        --当前要打开的组还没放在栈顶，从栈顶取出来的是之前的组打开的界面数据
        l_panelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:Peek(l_removePanelNames[i])

        if l_panelAssociatedGroupNameStackData then
            --对栈顶的界面数据设置覆盖此界面的组的信息
            l_panelAssociatedGroupNameStackData:SetOverrideGroupName(l_groupName)
        end

    end

    return l_removePanelNames

end

function UIGroupManager:_getRemovePanelsOnActiveGroup(groupDefine)
    local l_groupName = groupDefine.GroupName

    local l_currentGroup = self.groupStack:GetGroup(l_groupName)

    if l_currentGroup == nil then
        return nil
    end

    local l_currentGroupPanelNames = l_currentGroup:GetPanelNames()

    local l_groupDefinePanelNames = groupDefine.UIPanelNames

    local l_removePanelNames = {}

    --如果再打开的组中没有这个界面，添加进移除列表，之后会直接关闭这个界面
    for i, uiName in pairs(l_currentGroupPanelNames) do

        if not table.ro_contains(l_groupDefinePanelNames, uiName) then
            table.insert(l_removePanelNames, uiName)
        end

    end
    return l_removePanelNames
end

--取界面所在的组的名字
function UIGroupManager:GetGroupNameAccordingToPanelName(uiName)
    local l_uiPanelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:Peek(uiName)

    if l_uiPanelAssociatedGroupNameStackData == nil then
        return nil
    end

    local l_groupName = l_uiPanelAssociatedGroupNameStackData:GetGroupName()

    return l_groupName
end

--取真正打开此界面所在的组数据
---@return UIGroup
function UIGroupManager:GetGroupAccordingToActivePanelName(uiName)
    local l_uiPanelAssociatedGroupNameStack = self.uiPanelAssociatedGroupNameStackMap:GetStackWithUIName(uiName)

    if l_uiPanelAssociatedGroupNameStack == nil then
        return nil
    end

    local l_groupName
    local l_currentGroup
    for i, stackData in UIPanelAssociatedGroupNameStack.Iterator, l_uiPanelAssociatedGroupNameStack, 1 do
        if stackData:IsVisible() then
            l_groupName = stackData:GetGroupName()
            l_currentGroup = self.groupStack:GetGroup(l_groupName)
            if not l_currentGroup:IsGroupHide() then
                return l_currentGroup
            end
        end
    end

    l_groupName = self:GetGroupNameAccordingToPanelName(uiName)
    if l_groupName == nil then
        return nil
    end
    l_currentGroup = self.groupStack:GetGroup(l_groupName)

    return l_currentGroup
end
--取真正打开此界面所在的组的名字
function UIGroupManager:GetGroupNameAccordingToActivePanelName(uiName)
    local l_group = self:GetGroupAccordingToActivePanelName(uiName)
    if l_group == nil then
        return nil
    end

    return l_group:GetGroupName()
end
--取真正打开此界面所在的组的物体容器类型
function UIGroupManager:GetGroupContainerTypeAccordingToActivePanelName(uiName)
    local l_group = self:GetGroupAccordingToActivePanelName(uiName)
    if l_group == nil then
        return nil
    end

    local l_groupContainerType = l_group:GetGroupContainerType()
    if l_groupContainerType == nil then
        logError("没有取到GroupContainerType，uiName：" .. uiName)
    end

    return l_groupContainerType
end

--界面所在的组是否是隐藏的
function UIGroupManager:IsGroupHide(uiName)

    local l_groupName = self:GetGroupNameAccordingToPanelName(uiName)

    if l_groupName == nil then
        return false
    end

    local l_currentGroup = self.groupStack:GetGroup(l_groupName)

    return l_currentGroup:IsGroupHide()
end

--调用界面的ShowUI时修改栈里存储的数据
function UIGroupManager:ShowUI(uiName)
    l_panelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:Peek(uiName)

    if l_panelAssociatedGroupNameStackData then
        l_panelAssociatedGroupNameStackData:SetPanelHide(false)
    end
end

--调用界面的HideUI时修改栈里存储的数据
function UIGroupManager:HideUI(uiName)
    l_panelAssociatedGroupNameStackData = self.uiPanelAssociatedGroupNameStackMap:Peek(uiName)

    if l_panelAssociatedGroupNameStackData then
        l_panelAssociatedGroupNameStackData:SetPanelHide(true)
    end
end

--设置界面强制隐藏
function UIGroupManager:SetPanelForceHide(uiName)
    self.forceHidePanels[uiName] = uiName
end

--取消界面强制隐藏
function UIGroupManager:CancelPanelForceHide(uiName)
    self.forceHidePanels[uiName] = nil
end

--界面是否强制隐藏
function UIGroupManager:IsPanelForceHide(uiName)
    return self.forceHidePanels[uiName] ~= nil
end

--得到所有打开的组名字
--返回值类型 Stack
function UIGroupManager:GetAllGroupNames()
    return self.groupStack:GetAllGroupNames()
end

--组是否存在
function UIGroupManager:IsGroupExist(groupName)
    return self.groupStack:IsGroupExist(groupName)
end

--界面是否显示
function UIGroupManager:IsPanelShowing(uiName)
    local uiPanelAssociatedGroupNameStack = self.uiPanelAssociatedGroupNameStackMap:GetStackWithUIName(uiName)

    if uiPanelAssociatedGroupNameStack == nil then
        return false
    end

    local groupName
    local currentGroup
    ---@param stackData UIPanelAssociatedGroupNameStackData
    for i, stackData in UIPanelAssociatedGroupNameStack.Iterator, uiPanelAssociatedGroupNameStack, 1 do
        if stackData:IsVisible() then
            groupName = stackData:GetGroupName()
            currentGroup = self.groupStack:GetGroup(groupName)
            if not currentGroup:IsGroupHide() then
                return true
            end
        end
    end

    return false
end

--得到切场景时依然显示的组名字
function UIGroupManager:GetKeepShowGroupNamesOnSwitchScene()
    local l_groupNames = {}
    ---@param group UIGroup
    for i, group in UIGroupStack.Iterator, self.groupStack, 1 do
        if not group:IsCloseOnSwitchScene() then
            local l_groupName = group:GetGroupName()
            table.insert(l_groupNames, l_groupName)
        end
    end
    return l_groupNames
end

--得到在所有场景都保持显示的组名字
function UIGroupManager:GetKeepShowGroupNamesOnAllScene()
    local l_groupNames = {}
    ---@param group UIGroup
    for i, group in UIGroupStack.Iterator, self.groupStack, 1 do
        if group:IsKeepShowOnAllScene() then
            local l_groupName = group:GetGroupName()
            table.insert(l_groupNames, l_groupName)
        end
    end
    return l_groupNames
end

function UIGroupManager:DebugLog()

    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    if self.forceHidePanels ~= nil then
        local l_hideCount = 0
        for i, uiName in pairs(self.forceHidePanels) do
            l_hideCount = l_hideCount + 1
            logGreen("强制隐藏的界面:" .. uiName)
        end
        if l_hideCount == 0 then
            logGreen("没有强制隐藏的界面")
        end
    else
        logGreen("没有强制隐藏的界面")
    end

    self.groupStack:DebugLogStack()

    logGreen("-------------------------------------------------------------------")

    self.uiPanelAssociatedGroupNameStackMap:DebugLogStack()

end

return UIGroupManager

