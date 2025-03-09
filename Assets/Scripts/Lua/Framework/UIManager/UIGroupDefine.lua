module("UIManager.UIGroupDefineConfig", package.seeall)

ShopGroup = {
    MainPanelNames = { UI.CtrlNames.Bag },
    UIPanelNames = { UI.CtrlNames.Bag, UI.CtrlNames.Shop, UI.CtrlNames.Currency }
}

WorldMapGroup = {
    MainPanelNames = { UI.CtrlNames.WorldMap },
    UIPanelNames = { UI.CtrlNames.WorldMap, UI.CtrlNames.Map }
}

EquipBGGroup = {
    MainPanelNames = { UI.CtrlNames.EquipBG },
    UIPanelNames = { UI.CtrlNames.EquipBG, UI.CtrlNames.Currency }
}

CardExchangeShopGroup = {
    MainPanelNames = { UI.CtrlNames.CardExchangeShop },
    UIPanelNames = { UI.CtrlNames.CardExchangeShop, UI.CtrlNames.Currency }
}

BagGroup = {
    MainPanelNames = { UI.CtrlNames.Bag },
    UIPanelNames = { UI.CtrlNames.Bag, UI.CtrlNames.Currency }
}

EquipAssistantBGGroup = {
    MainPanelNames = { UI.CtrlNames.EquipAssistantBG },
    UIPanelNames = { UI.CtrlNames.EquipAssistantBG, UI.CtrlNames.Currency }
}

ForgeGroup = {
    MainPanelNames = { UI.CtrlNames.Forge },
    UIPanelNames = { UI.CtrlNames.Forge, UI.CtrlNames.Currency }
}

PhotographGroup = {
    MainPanelNames = { UI.CtrlNames.Photograph },
    UIPanelNames = { UI.CtrlNames.Photograph, UI.CtrlNames.MoveControllerContainer }
}

RefineGroup = {
    MainPanelNames = { UI.CtrlNames.Refine },
    UIPanelNames = { UI.CtrlNames.Refine, UI.CtrlNames.Currency }
}

DeadDlgGroup = {
    MainPanelNames = { UI.CtrlNames.DeadDlg },
    UIPanelNames = { UI.CtrlNames.DeadDlg, UI.CtrlNames.MainChat }
}

TowerDefenseSpiritGroup = {
    MainPanelNames = { UI.CtrlNames.TowerDefenseSpirit },
    UIPanelNames = { UI.CtrlNames.TowerDefenseSpirit, UI.CtrlNames.TowerDefenseSpiritAdmin }
}

BeiluzOperationContainerGroup = {
    MainPanelNames = { UI.CtrlNames.BeiluzOperationContainer },
    UIPanelNames = { UI.CtrlNames.BeiluzOperationContainer, UI.CtrlNames.Currency }
}

UIGroupDefine = class("UIGroupDefine")

local groupSuffix = "Group"
local canCreateGroupDefineNames = {

}

function UIGroupDefine:GetGroupName(uiName)
    return uiName .. groupSuffix
end

function UIGroupDefine:GetGroupDefine(uiName)

    local l_groupName = self:GetGroupName(uiName)
    local l_currentGroup = UIManager.UIGroupDefineConfig[l_groupName]
    if l_currentGroup == nil then
        logError("Group的数据并没有在UIGroupDefine中配置，ui的名字：" .. uiName)
        return nil
    end
    l_currentGroup.GroupName = l_groupName
    return l_currentGroup
end

function UIGroupDefine:CreateGroupDefine(groupDefineName, uiPanelNames, mainPanelNames)

    if Application.isEditor then
        if not (groupDefineName == UIMgr.MainPanelsGroupDefineName or table.ro_contains(canCreateGroupDefineNames, groupDefineName)) then
            logError("这个组不允许创建，名字：" .. groupDefineName)
        end
    end

    local l_groupDefine = {}
    l_groupDefine.GroupName = self:GetGroupName(groupDefineName)
    l_groupDefine.MainPanelNames = mainPanelNames
    l_groupDefine.UIPanelNames = uiPanelNames
    return l_groupDefine

end

function UIGroupDefine:checkRepetition()


end

declareGlobal("UIGroupDefine", UIGroupDefine.new())

return UIManager.UIGroupDefineConfig















