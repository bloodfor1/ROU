-- 封印卡片管理
module("ModuleMgr.SealCardMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
EventType = {
    UnsealCardSucceed = 1,
}


-- 卡片解封所需材料
sealCardCostItems = {}

function OnInit()
    for _, row in pairs(TableUtil.GetEquipCardSeal().GetTable()) do
        for i = 0, row.ItemCost.Length - 1 do
            sealCardCostItems[row.ItemCost[i][0]] = true
        end
    end
end

function OpenUnsealCardUI(cardId)
    UIMgr:ActiveUI(UI.CtrlNames.CardUnseal, { cardId = cardId })
end

-- 是否是封印的卡片
function IsSealCard(cardId)
    local l_cardRow = TableUtil.GetEquipCardSeal().GetRowBySealCardId(cardId, true)
    return l_cardRow ~= nil
end


-- 是否是卡片解封所需材料
function IsSealCardCostItem(itemId)
    return not not sealCardCostItems[itemId]
end

---@type ItemData[]
function GetSealCardItems(isEquip)
    -- 获取背包中的封印卡片
    local l_types = { GameEnum.EBagContainerType.Bag }
    local l_conditions = { { Cond = function(itemData)
        -- 是否是封印卡片
        return IsSealCard(itemData.TID)
    end } }
    local l_bagCardItems = Data.BagApi:GetItemsByTypesAndConds(l_types, l_conditions)
    -- 获取装备上的封印卡片
    l_types = { GameEnum.EBagContainerType.Bag, GameEnum.EBagContainerType.Equip }
    l_conditions = { { Cond = function(itemData)
        -- 是否是装备
        return nil ~= itemData.EquipConfig
    end } }
    local l_equipCardItems = Data.BagApi:GetItemsByTypesAndConds(l_types, l_conditions)
    local l_cardItems = {}
    if not isEquip then
        for _, itemData in ipairs(l_bagCardItems) do
            for i = 1, tonumber(itemData.ItemCount) do
                local l_fakeCardItemData = Data.BagModel:CreateItemWithTid(itemData.TID)
                l_fakeCardItemData.UID = itemData.UID
                table.insert(l_cardItems, { itemData = l_fakeCardItemData, isEquip = false, pos = 1 })
            end
        end
    end
    for _, itemData in ipairs(l_equipCardItems) do
        local itemCardAttrMap = itemData.AttrSet[GameEnum.EItemAttrModuleType.Card]
        if itemCardAttrMap then
            for i, attrDatas in ipairs(itemCardAttrMap) do
                for j, attrData in ipairs(attrDatas) do
                    if IsSealCard(attrData.AttrID) then
                        local l_fakeCardItemData = Data.BagModel:CreateItemWithTid(attrData.AttrID)
                        table.insert(l_cardItems, { itemData = l_fakeCardItemData, isEquip = true, pos = i, equipItemData = itemData })
                    end
                end
            end
        end
    end
    table.sort(l_cardItems, function(a, b)
        local l_aE = a.isEquip and 0 or 1
        local l_bE = b.isEquip and 0 or 1
        if l_aE == l_bE then
            return a.itemData.TID < b.itemData.TID
        else
            return l_aE < l_bE
        end
    end)
    return l_cardItems
end

function EquipCardUnSeal(uid, isEquip, pos, customData)
    local l_sendInfo = GetProtoBufSendTable("EquipCardUnSealArg")
    l_sendInfo.item_uid = uid
    l_sendInfo.is_equip = isEquip
    l_sendInfo.pos = pos - 1
    --logError(ToString(l_sendInfo))
    Network.Handler.SendRpc(Network.Define.Rpc.EquipCardUnSeal, l_sendInfo, customData)
end

-- 协议处理
function OnEquipCardUnSeal(msg, sendArg, customData)
    local l_res = ParseProtoBufToTable("EquipCardUnSealRes", msg)
    -- logError(l_res.result)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
        return
    end

    if sendArg.is_equip then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("UNSEAL_EQUIP_SUCCEED", customData.equipName, customData.cardName))

        -- 特殊提示处理
        MgrMgr:GetMgr("NoticeMgr").NoticeNormalTips(customData.cardId, 1, false, false)
        MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(customData.cardId, 1, nil, { titleName = Lang("UNSEAL_SUCCEED", "") })
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("UNSEAL_SUCCEED", customData.cardName))
    end

    EventDispatcher:Dispatch(EventType.UnsealCardSucceed)
end

return ModuleMgr.SealCardMgr