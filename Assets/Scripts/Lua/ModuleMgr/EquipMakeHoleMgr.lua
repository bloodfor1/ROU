---@module ModuleMgr.EquipMakeHoleMgr
module("ModuleMgr.EquipMakeHoleMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
ReceiveEquipMakeHoleEvent = "ReceiveEquipMakeHoleEvent"
ReceiveEquipHoleRefogeEvent = "ReceiveEquipHoleRefogeEvent"
ReceiveEquipSaveHoleReforgeEvent = "ReceiveEquipSaveHoleReforgeEvent"
FirstMakeHoleRedSignStorageKey = "FirstMakeHoleRedSignStorageKey"
FirstMakeHoleTemplateGotoCardStorageKey = "FirstMakeHoleTemplateGotoCardStorageKey"

--可插卡的部位
local _cardPosition = MGlobalConfig:GetSequenceOrVectorInt("CardPosition")

--SelectEquip
---@param data ItemData[]
function GetSelectEquips(data)
    local equips = {}
    for i = 1, #data do
        local singleItem = data[i]
        local equipTableInfo = singleItem.EquipConfig
        if equipTableInfo == nil then
            logError("EquipTable not have ID" .. tostring(singleItem.TID))
        elseif equipTableInfo.HoleNum > 0 then
            table.insert(equips, singleItem)
        end
    end

    return equips
end

function GetNoneEquipText()
    return Lang("MakeHole_NoneEquipText")
end
--SelectEquip

function GetHoleOpenText(equipHoleTableId)
    ---@type EquipHoleTable
    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(equipHoleTableId)
    if l_holeTableInfo == nil then
        logError("EquipHoleTable表里没有配，id" .. tostring(equipHoleTableId))
        return nil
    end

    local l_openText = nil
    local l_activition = l_holeTableInfo.Activition
    if l_activition.Length == 0 then
        -- do nothing
    else
        if l_activition.Length ~= 2 then
            logError("EquipHoleTable表的Activition字段配的不对，id" .. tostring(l_holeTableInfo.table_id))
            return nil
        end
        if l_activition[0] == 1 then
            l_openText = StringEx.Format(Lang("MakeHole_HoleOpenRefineText"), l_activition[1])
        elseif l_activition[0] == 2 then
            local l_achievementDetailTableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(l_activition[1])
            l_openText = StringEx.Format(Lang("MakeHole_HoleOpenAchievementText"), l_achievementDetailTableInfo.Name)
        end
    end

    return l_openText
end

function GetColorTextWithHoleId(text, equipHoleTableId)
    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(equipHoleTableId)
    if l_holeTableInfo == nil then
        logError("EquipHoleTable表里没有配，id" .. tostring(equipHoleTableId))
        return text
    end

    return GetColorText(text, RoQuality.GetColorTag(l_holeTableInfo.Quality))
end

--得到最大洞数,装备表的配的洞数
---@param itemData ItemData
function GetMaxHoleCount(itemData)
    return itemData.EquipConfig.HoleNum
end



--得到没有开启的洞的个数
---@param propInfo ItemData
function GetNotOpenHoleCount(propInfo)
    local l_count = GetMaxHoleCount(propInfo) - propInfo:GetOpenHoleCount()
    if l_count < 0 then
        l_count = 0
    end

    return l_count
end
--得到插了卡的卡片id
---@param itemData ItemData
function GetCardIds(itemData)
    local l_cardIds = {}
    local cards = itemData.AttrSet[GameEnum.EItemAttrModuleType.Card]
    for i = 1, #cards do
        for j = 1, #cards[i] do
            local cardAttr = cards[i][j].AttrID
            table.insert(l_cardIds, cardAttr)
        end
    end

    return l_cardIds
end

--得到已经插卡的个数
---@param propInfo ItemData
function GetInsertedCardCount(propInfo)
    local l_cards = GetCardIds(propInfo)
    return #l_cards
end

--- 获取所有的装备
---@return ItemData[]
function _getAllEquips()
    local types = { GameEnum.EBagContainerType.Equip }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

--得到全身已插卡的个数
function GetAllInsertedCardNum()
    local l_equips = _getAllEquips()
    local l_sum = 0
    for _, v in pairs(l_equips) do
        l_sum = l_sum + GetInsertedCardCount(v)
    end

    return l_sum
end

--得到可以插卡的洞的个数
---@param propInfo ItemData
function GetCanInsertHoleCount(propInfo)
    local l_count = propInfo:GetOpenHoleCount() - GetInsertedCardCount(propInfo)
    if l_count < 0 then
        l_count = 0
    end

    return l_count
end

--是否所有洞都插卡满
function IsInsertCardWithAllHole(propInfo)
    local l_maxHole = GetMaxHoleCount(propInfo)
    local l_insertedCardCount = GetInsertedCardCount(propInfo)
    if l_maxHole == l_insertedCardCount then
        return true
    end

    return false
end

--是否身上的装备都插卡满
function IsAllBodyEquipInsertAllCard()
    local l_equips = _getAllEquips()
    for i, equip in pairs(l_equips) do
        if not IsInsertCardWithAllHole(equip) then
            return false
        end
    end

    return true
end

--是否全身装备都插卡满
function IsFullBodyEquipInsertAllCard()
    if not MgrMgr:GetMgr("BodyEquipMgr").IsFullEquipOnBody() then
        return false
    end

    return IsAllBodyEquipInsertAllCard()
end

--是否身上可插卡部位的装备都插卡满
function IsBodyEquipInsertAllCardWithAllCanCardPosition()
    local l_equips = MgrMgr:GetMgr("RefineMgr").GetNeedCheckEquipsWithEquipTypes(_cardPosition)
    if l_equips == nil then
        return false
    end

    for i = 1, #l_equips do
        if not IsInsertCardWithAllHole(l_equips[i]) then
            return false
        end
    end

    return true
end

-- 协议 请求打洞
-- totalCost isNotCheck 为快捷付费数据可不传
function RequestEquipMakeHole(equipUid,totalCost,isNotCheck)

    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                RequestEquipMakeHole(equipUid,totalCost,true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.EquipMakeHole
    ---@type HoleMakeArg
    local l_sendInfo = GetProtoBufSendTable("HoleMakeArg")
    l_sendInfo.equip_uid = equipUid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--打洞
function ReceiveEquipMakeHole(msg)
    ---@type HoleMakeRes
    local l_info = ParseProtoBufToTable("HoleMakeRes", msg)
    EventDispatcher:Dispatch(ReceiveEquipMakeHoleEvent)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("EQUIP_MAKE_HOLE_SUCCEED"))

end

--请求重铸洞属性
function RequestEquipHoleRefoge(equipUid, holeIndex)
    local l_msgId = Network.Define.Rpc.EquipHoleRefoge
    ---@type EquipHoleRefogeArg
    local l_sendInfo = GetProtoBufSendTable("EquipHoleRefogeArg")
    l_sendInfo.equip_uid = equipUid
    l_sendInfo.pos = holeIndex - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveEquipHoleRefoge(msg)
    ---@type EquipHoleRefogeRes
    local l_info = ParseProtoBufToTable("EquipHoleRefogeRes", msg)
    EventDispatcher:Dispatch(ReceiveEquipHoleRefogeEvent)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

--请求保存洞属性
function RequestEquipSaveHoleReforge(equipUid, holeIndex)
    local l_msgId = Network.Define.Rpc.EquipSaveHoleReforge
    ---@type EquipSaveHoleReforgeArg
    local l_sendInfo = GetProtoBufSendTable("EquipSaveHoleReforgeArg")
    l_sendInfo.equip_uid = equipUid
    l_sendInfo.pos = holeIndex - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveEquipSaveHoleReforge(msg)
    ---@type EquipSaveHoleReforgeRes
    local l_info = ParseProtoBufToTable("EquipSaveHoleReforgeRes", msg)
    EventDispatcher:Dispatch(ReceiveEquipSaveHoleReforgeEvent)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MakeHole_SaveHoleReforgeSuccessText"))

end

return EquipMakeHoleMgr
