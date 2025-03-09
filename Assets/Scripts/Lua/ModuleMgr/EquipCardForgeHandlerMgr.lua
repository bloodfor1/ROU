require "Data/Model/BagApi"

module("ModuleMgr.EquipCardForgeHandlerMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

ReceiveEquipCardRemoveEvent = "ReceiveEquipCardRemoveEvent"
--插卡操作回调
EquipDataChange = "EquipDataChange"
InsertCard = "InsertCard"
--点击属性
EquipCardPropertyClick = "EquipCardPropertyClick"
--当前选中的装备UID
g_currentSelectUID = 0
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local recommendMapMgr = MgrMgr:GetMgr("RecommendMapMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    local C_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_INSERTCARD] = 1,
        [ItemChangeReason.ITEM_REASON_REMOVECARD] = 1,
        [ItemChangeReason.ITEM_REASON_MAKEHOLE] = 1,
        [ItemChangeReason.ITEM_REASON_MAKEREFORM] = 1,
    }

    local targetItem = nil
    for i = 1, #itemUpdateDataList do
        local singleItemUpdate = itemUpdateDataList[i]
        if nil ~= C_REASON_MAP[singleItemUpdate.Reason]
                and nil ~= singleItemUpdate.OldItem
                and nil ~= singleItemUpdate.NewItem
        then
            targetItem = singleItemUpdate.NewItem
        end
    end

    if nil ~= targetItem then
        EventDispatcher:Dispatch(EquipDataChange, targetItem)
    end
end

--判断装备能否插卡
function CheckEquipCanInsertCard(propInfo)
    if propInfo == nil then
        return false
    end

    if MgrMgr:GetMgr("EquipMakeHoleMgr").GetCanInsertHoleCount(propInfo) > 0 then
        return true
    end

    return false
end

--错误码提示
function ErrorCodeTips(errorCode)
    local tips = ""
    if errorCode == ErrorCode.ERR_EQUIP_CARD_HOLE_OVERLAP then
        tips = Common.Utils.Lang("ERR_EQUIP_CARD_HOLE_OVERLAP")
    elseif errorCode == ErrorCode.ERR_EQUIP_CARD_ID then
        tips = Common.Utils.Lang("ERR_EQUIP_CARD_ID")
    elseif errorCode == ErrorCode.ERR_EQUIP_CARD_NO_HOLE then
        tips = Common.Utils.Lang("ERR_EQUIP_CARD_NO_HOLE")
    elseif errorCode == ErrorCode.ERR_EQUIP_ITEM_LEVEL_FAILED then
        tips = Common.Utils.Lang("ERR_EQUIP_ITEM_LEVEL_FAILED")
    elseif errorCode == ErrorCode.ERR_EQUIP_CARD_NOT_IN_HOLE then
        tips = Common.Utils.Lang("ERR_EQUIP_CARD_NOT_IN_HOLE")
    elseif errorCode == ErrorCode.ERR_ITEM_NOT_ENOUGH then
        tips = Common.Utils.Lang("ITEM_NOT_ENOUGH")
    elseif errorCode == ErrorCode.ERR_VIRTUAL_ITEM_LACK_ZENY then
        tips = Common.Utils.Lang("NOT_ENOUGH_ZENY")
        local itemData = Data.BagModel:CreateItemWithTid(101)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
    else
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(errorCode)
        return
    end

    -- logError("ErrorCode:" .. tostring(l_info.result) .. "  :" .. tostring(tips))
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tips)
end

--EquipUid 装备的uid
--IsRemoveCard 是否选择卡片显示拆卡
local _currentGotoCardData

--移动到插卡npc
function GotoCardNpc(gotoCardData)
    _currentGotoCardData = gotoCardData
    MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid(gotoCardData.EquipUid)
    --寻路成功才关闭对应界面
    local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard)
    if l_result then
        game:ShowMainPanel()
    end
end

---@param cardItemData ItemData
function SetCurrentSelectedCard(cardItemData)
    _currentGotoCardData = cardItemData
end

function RemoveGotoCardData()
    _currentGotoCardData = nil
end

--默认选择装备时是否选择卡片显示拆卡
function IsSelectEquipWithCard()
    if _currentGotoCardData == nil then
        return false
    end
    return _currentGotoCardData.IsRemoveCard
end

--SelectEquip
function GetSelectEquips(data)
    return MgrMgr:GetMgr("EquipMakeHoleMgr").GetSelectEquips(data)
end

function GetNoneEquipText()
    return Lang("EquipCard_NoEquipText")
end

---@param itemData ItemData
function IsSelectCanShowRedSign(itemData)
    if MgrMgr:GetMgr("EquipMakeHoleMgr").GetCanInsertHoleCount(itemData) == 0 then
        return false
    end

    local l_cards = GetCardsWithEquipId(itemData.TID)
    if #l_cards > 0 then
        return true
    end

    return false
end
--SelectEquip

-- 得到当前装备部位的卡片，会去掉重复的
-- 这个地方的ID是卡牌的ID
function GetCardsWithEquipId(id)
    local l_cards = {}
    local l_equipTable = TableUtil.GetEquipTable().GetRowById(id)
    if l_equipTable == nil then
        logError("EquipTable not have ID" .. tostring(id))
        return l_cards
    end

    local cards = _getItemsInBagByType(GameEnum.EItemType.Card)
    local sortFunc = function(cardLeft, cardRight)
        ---@type ItemData
        local innerCardLeft = cardLeft
        ---@type ItemData
        local innerCardRight = cardRight

        if nil == innerCardLeft or nil == innerCardRight then
            logError("[CardForgeMgr] invalid param")
            return false
        end

        local cardLeftMatch = recommendMapMgr.ItemMatchItemSchool(innerCardLeft.TID, l_equipTable.Id)
        local cardRightMatch = recommendMapMgr.ItemMatchItemSchool(innerCardRight.TID, l_equipTable.Id)
        if cardLeftMatch ~= cardRightMatch then
            return cardLeftMatch > cardRightMatch
        end

        local cardLeftQuality = innerCardLeft.ItemConfig.ItemQuality
        local cardRightQuality = innerCardRight.ItemConfig.ItemQuality
        if cardLeftQuality ~= cardRightQuality then
            return cardLeftQuality > cardRightQuality
        end

        -- todo 这边会有一个类型，等到做了卡牌封印之后再添加
        return innerCardLeft.TID > innerCardRight.TID
    end

    table.sort(cards, sortFunc)
    for i = 1, #cards do
        local itemData = cards[i]
        local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(itemData.TID)
        if not CheckCardRepeat(l_cards, itemData.TID) then
            for j = 0, l_cardInfo.CanUsePosition.Length - 1 do
                --部位
                if l_cardInfo.CanUsePosition[j] == l_equipTable.EquipId then

                    local forgeCardData={}
                    forgeCardData.ItemData=itemData
                    forgeCardData.CardTableData=l_cardInfo
                    forgeCardData.Recommended = _isCardRecommended(i)

                    table.insert(l_cards, forgeCardData)
                    break
                end
            end
        end
    end

    return l_cards
end

function CheckCardRepeat(table, propId)
    if #table < 1 then
        return false
    end
    for i = 1, #table do
        if table[i].ID == propId then
            return true
        end
    end
    return false
end

function _isCardRecommended(idx)
    if nil == idx then
        return false
    end

    local C_VALID_MIN_IDX = 1
    local C_VALID_MAX_IDX = 3
    local C_RECOMMEND_MAX_LV = 50
    local idxValid = C_VALID_MIN_IDX <= idx and C_VALID_MAX_IDX > idx
    local lvValid = C_RECOMMEND_MAX_LV >= MPlayerInfo.Lv
    return lvValid and idxValid
end

--- 通过道具类型来获取背包中的道具
---@return ItemData[]
function _getItemsInBagByType(targetType)
    if GameEnum.ELuaBaseType.Number ~= type(targetType) then
        logError("[EquipCardForgeMgr] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTypes, Param = { targetType } }
    local conditions = { condition }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end

--寻路到插卡npc
function GotoCardNpcWithCardId(cardId)
    --寻路成功才关闭对应界面
    local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard, cardId)
    if l_result then
        game:ShowMainPanel()
    end
end

--打开插卡界面
function OpenCardForgePanle(cardId)
    _setSelectEquipWithCardId(cardId)
    MgrMgr:GetMgr("ShowEquipPanleMgr").CurrentShowEquipPanelType = MgrMgr:GetMgr("ShowEquipPanleMgr").eShowEquipPanelType.EquipCardForge
    UIMgr:ActiveUI(UI.CtrlNames.EquipBG)
end

--根据卡片id设置选择的装备
function _setSelectEquipWithCardId(cardId)
    if cardId == nil then
        return
    end

    local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(cardId)
    if l_cardInfo == nil then
        return
    end

    local l_allBodyEquips = {}
    for i = 0, l_cardInfo.CanUsePosition.Length - 1 do
        local l_bodyEquips = MgrMgr:GetMgr("EquipMgr").GetEquipOnBodyWithEquipId(l_cardInfo.CanUsePosition[i])
        table.ro_insertRange(l_allBodyEquips, l_bodyEquips)
    end

    if #l_allBodyEquips > 0 then
        _setSelectEquipWithEquips(l_allBodyEquips)
        return
    end

    local l_allBagEquips = {}
    for i = 0, l_cardInfo.CanUsePosition.Length - 1 do
        local l_bagEquips = MgrMgr:GetMgr("EquipMgr").GetEquipsInBagWithEquipId(l_cardInfo.CanUsePosition[i])
        table.ro_insertRange(l_allBagEquips, l_bagEquips)
    end

    if #l_allBagEquips == 0 then
        return
    end

    _setSelectEquipWithEquips(l_allBagEquips)
end

--根据传的装备数据设置选择的装备
function _setSelectEquipWithEquips(equips)
    table.sort(equips, function(a, b)
        local l_holeCountA = a:GetOpenHoleCount()
        local l_holeCountB = b:GetOpenHoleCount()
        local l_isHaveHoleA = l_holeCountA > 0
        local l_isHaveHoleB = l_holeCountB > 0
        if l_isHaveHoleA == l_isHaveHoleB then
            return a.TID < b.TID
        end

        return l_isHaveHoleA
    end)

    MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectWithPropInfo(equips[1])
end


--请求插卡
function RequestEquipCardInsert(equipUid, cardUid, holePosition)
    local l_msgId = Network.Define.Rpc.EquipCardInsert
    ---@type CardInsertArg
    local l_sendInfo = GetProtoBufSendTable("CardInsertArg")
    l_sendInfo.equip_uid = equipUid
    l_sendInfo.card_uid = cardUid
    l_sendInfo.pos = holePosition - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--请求拆卡
function RequestEquipCardRemove(equipUid, holePosition,consumeData,isNotCheck)

    local totalCost = 0
    for key, value in pairs(consumeData) do
        if value.ID == GameEnum.l_virProp.Coin101 then
            totalCost = value.RequireCount
        end
    end

    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                RequestEquipCardRemove(equipUid, holePosition,consumeData,true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.EquipCardRemove
    ---@type CardRemoveArg
    local l_sendInfo = GetProtoBufSendTable("CardRemoveArg")
    l_sendInfo.equip_uid = equipUid
    l_sendInfo.pos = holePosition - 1

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--插卡
function EquipCardInsert(msg)
    ---@type CardInsertRes
    local l_info = ParseProtoBufToTable("CardInsertRes", msg)
    if l_info.result ~= 0 then
        ErrorCodeTips(l_info.result)
        return
    end

    EventDispatcher:Dispatch(ReceiveEquipCardRemoveEvent)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("EQUIP_CARD_INSERT_SUCCEED"))
end
--拆卡
function EquipCardRemove(msg)
    ---@type CardRemoveRes
    local l_info = ParseProtoBufToTable("CardRemoveRes", msg)
    if l_info.result ~= 0 then
        ErrorCodeTips(l_info.result)
        return
    end

    EventDispatcher:Dispatch(ReceiveEquipCardRemoveEvent)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("EQUIP_CARD_REMOVE_SUCCEED"))
end

return EquipCardForgeHandlerMgr

