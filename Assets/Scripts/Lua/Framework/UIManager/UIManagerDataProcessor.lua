
module("UIManager", package.seeall)

-- UIManager中对数据处理的方法
---@class UIManagerDataProcessor
UIManagerDataProcessor = class("UIManagerDataProcessor")

--IsInsertCurrentGroup 是否添加到栈顶的组中
--InsertPanelName 添加进InsertPanelName对应的组中
--InsertGroupName 添加进InsertGroupName组中
--ActiveType == UI.ActiveType.Normal 添加进主界面组中
--ActiveType == UI.ActiveType.Exclusive 界面是Exclusive类型
--ActiveType == UI.ActiveType.Standalone 界面是Standalone类型
--IsCloseOnSwitchScene 切场景是否关闭
--IgnoreHideGroupNames 忽略隐藏的组
--IgnoreHidePanelNames 忽略隐藏界面对应的组
--IsIgnoreHideMainGroup 是否忽略隐藏主界面组
--IsNeedHideOnActive 是否在打开的时候关闭
--HidePanelNamesOnActive 在打开的时候关闭组中的界面
--GroupContainerType 组容器的类型
--ForceHidePanelNames 强制隐藏的界面名字，这个组打开的时候会设置此界面强制隐藏，组关的时候会设置回来

--GroupMaskType == UI.GroupMaskType.None 不显示遮罩
--GroupMaskType == UI.GroupMaskType.Show 显示遮罩
--GroupMaskType == UI.GroupMaskType.Default Exclusive类型界面并且不是全屏界面加遮罩
--MaskColor 遮罩颜色
--ClosePanelNameOnClickMask 点击遮罩要关闭的界面
--MaskDelayClickTime 遮罩延迟点击时间

--组的Mask的层级设置
--以GroupSortingOrder的设置为主，没有则使用overrideSortLayer。如果GroupSortingOrder为UI.UILayerSort.None，不设置层级
--GroupSortingOrder 组的层级
--overrideSortLayer 界面的层级。暂时只是取界面的层级使用，没有支持动态设置界面层级

---@param uiPanelConfig UIPanelConfig
function UIManagerDataProcessor:InsertUIPanelConfigData(uiPanelConfig, config,mainGroupName)
    if uiPanelConfig == nil then
        return
    end
    if config == nil then
        return
    end

    uiPanelConfig:SetInsertCurrentGroup(config.IsInsertCurrentGroup)

    local insertGroupName
    if config.InsertPanelName then
        insertGroupName = UIGroupDefine:GetGroupName(config.InsertPanelName)
    end
    if config.InsertGroupName then
        insertGroupName = config.InsertGroupName
    end
    if not insertGroupName then
        if config.ActiveType then
            if config.ActiveType == UI.ActiveType.Normal then
                insertGroupName = mainGroupName
            end
        end
    end
    uiPanelConfig:SetInsertGroupName(insertGroupName)

    uiPanelConfig:SetIgnoreHideGroupNames(config.IgnoreHideGroupNames)

    if config.IgnoreHidePanelNames then
        for i = 1, #config.IgnoreHidePanelNames do
            local groupName = UIGroupDefine:GetGroupName(config.IgnoreHidePanelNames[i])
            uiPanelConfig:AddIgnoreHideGroupNames(groupName)
        end
    end

    if config.IsIgnoreHideMainGroup then
        uiPanelConfig:AddIgnoreHideGroupNames(mainGroupName)
    end

    uiPanelConfig:SetNeedHideOnActive(config.IsNeedHideOnActive)
    uiPanelConfig:SetHidePanelNamesOnActive(config.HidePanelNamesOnActive)

    local isExclusive
    if config.ActiveType then
        if config.ActiveType == UI.ActiveType.Exclusive then
            isExclusive = true
        elseif config.ActiveType == UI.ActiveType.Standalone then
            uiPanelConfig:SetStandalone(true)
        end
    end
    uiPanelConfig:SetExclusive(isExclusive)

    local isNeedShowMask
    if config.GroupMaskType then
        if config.GroupMaskType == UI.GroupMaskType.None then
            isNeedShowMask = false
        elseif config.GroupMaskType == UI.GroupMaskType.Show then
            isNeedShowMask = true
        elseif config.GroupMaskType == UI.GroupMaskType.Default then
            if isExclusive and (not config.isFullScreen) then
                isNeedShowMask = true
            else
                isNeedShowMask = false
            end
        end
    end
    uiPanelConfig:SetNeedShowMask(isNeedShowMask)
    uiPanelConfig:SetMaskColor(config.MaskColor)
    uiPanelConfig:SetClosePanelNameOnClickMask(config.ClosePanelNameOnClickMask)
    uiPanelConfig:SetMaskDelayClickTime(config.MaskDelayClickTime)

    uiPanelConfig:SetGroupContainerType(config.GroupContainerType)

    local groupSortingOrder
    if config.GroupSortingOrder ~= UI.UILayerSort.None then
        if config.GroupSortingOrder then
            groupSortingOrder=config.GroupSortingOrder
        else
            groupSortingOrder=config.overrideSortLayer
        end
    end
    uiPanelConfig:SetOverrideCanvasSortingOrder(groupSortingOrder)

    uiPanelConfig:SetForceHidePanelNames(config.ForceHidePanelNames)
    uiPanelConfig:SetIsTakePartInGroupStack(config.IsTakePartInGroupStack)
    uiPanelConfig:SetCloseOnSwitchScene(config.IsCloseOnSwitchScene)
    uiPanelConfig:SetKeepShowOnAllScene(config.IsKeepShowOnAllScene)
end

--对得到的关闭组数据进行处理，填充成处理后的数据
---@param deActiveGroupInfo UIGroupDeActiveInfo
function UIManagerDataProcessor:FillDeActiveGroupsInfoOnDeActiveAllGroups(deActiveGroupInfoStack,deActiveGroupInfoDictionary,needShowGroups,deActiveGroupInfo)
    if deActiveGroupInfo==nil then
        return
    end

    deActiveGroupInfoStack:Push(deActiveGroupInfo)

    --填充关闭的组
    local l_deActiveGroup = deActiveGroupInfo:GetDeActiveGroup()
    local deActiveGroupName= l_deActiveGroup:GetGroupName()
    deActiveGroupInfoDictionary[deActiveGroupName]=deActiveGroupInfo

    --填充需要显示的组
    local currentNeedShowGroups = deActiveGroupInfo:GetNeedShowGroups()
    if currentNeedShowGroups then
        for i = 1, #currentNeedShowGroups do
            local needShowGroupName= currentNeedShowGroups[i]:GetGroupName()
            needShowGroups[needShowGroupName]=currentNeedShowGroups[i]
        end
    end
end

--批量关闭组处理
--根据得到的UIGroupDeActiveInfo数据栈，进行数据处理
function UIManagerDataProcessor:DealWithDeActiveGroupInfoStackOnDeActiveAllGroups(deActiveGroupInfoStack, deActiveGroupInfoDictionary)
    --界面处理数据
    local finalPanelDeActiveInfoContainer = {}

    ---@param deActiveGroupInfo UIGroupDeActiveInfo
    for n, deActiveGroupInfo in System.Stack.Iterator, deActiveGroupInfoStack, 1 do
        --显示组会在所有关闭组处理完后再处理
        --数据已经在外部处理完，此处清空
        deActiveGroupInfo:ClearNeedShowGroups()

        local panelDeActiveInfoContainer = deActiveGroupInfo:GetPanelDeActiveInfoContainer()
        for uiName, deActivePanelInfo in pairs(panelDeActiveInfoContainer) do
            if self:_isNeedDealWithPanelDeActiveInfoOnDeActiveAllGroups(finalPanelDeActiveInfoContainer, uiName, deActivePanelInfo, deActiveGroupInfoDictionary) then
                finalPanelDeActiveInfoContainer[uiName] = deActivePanelInfo
            else
                panelDeActiveInfoContainer[uiName] = nil
            end
        end
    end
end

--填充界面处理数据
---@param deActivePanelInfo UIPanelDeActiveInfo
function UIManagerDataProcessor:_isNeedDealWithPanelDeActiveInfoOnDeActiveAllGroups(finalPanelDeActiveInfoContainer, uiName, deActivePanelInfo, deActiveGroupInfoDictionary)

    --logGreen("_deActiveGroupsDealWithPanelDeActiveInfo,uiName:"..tostring(uiName)..
    --        "  groupName:"..tostring(deActivePanelInfo:GetGroupNameOfContainingDeActivePanel())..
    --        "  IsNeedDeActive:"..tostring(deActivePanelInfo:IsNeedDeActive())..
    --        "  IsHaveActivePanelOnBehind:"..tostring(deActivePanelInfo:IsHaveActivePanelOnBehind()))

    ---@type UIPanelDeActiveInfo
    local currentDeActivePanelInfo=finalPanelDeActiveInfoContainer[uiName]

    --如果有数据,不用处理，使用最后的数据
    if currentDeActivePanelInfo then
        if currentDeActivePanelInfo:IsNeedShowUI() then
            currentDeActivePanelInfo:SetNeedReActive(true)
        end
        return false
    end
    --如果这个界面是要关闭的，或这个界面在后面打开的，直接加进来
    if deActivePanelInfo:IsNeedDeActive() or deActivePanelInfo:IsHaveActivePanelOnBehind() then
        return true
    end

    --不是以上两种情况，就是重新打开或显示
    --重新打开或显示需要判断这个界面所在的组是否关闭了,只有没关闭才处理
    local l_groupName = deActivePanelInfo:GetGroupNameOfContainingDeActivePanel()
    if l_groupName == nil then
        logError("关闭界面数据中的界面所在的组名字是空的")
        return false
    end
    if deActiveGroupInfoDictionary[l_groupName] then
        return false
    end
    return true
end

