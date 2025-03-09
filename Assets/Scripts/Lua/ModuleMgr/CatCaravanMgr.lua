require "Data/Model/BagApi"
module("ModuleMgr.CatCaravanMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
Event = {
    InitData = "InitData",
    ResetData = "ResetData",
    AwardChange = "AwardChange",
    NeedChange = "NeedChange",
}

Datas = nil
AwardStatus = 0
AllFull = false
LastTaskDay = nil
LastTaskYear = nil
NeedItems = {}
NeedItemsCount = {}
g_catTimer = nil

local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

---------------------------------生命周期
function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnLogout()
    Datas = nil
    LastTaskDay = nil
    LastTaskYear = nil

    if g_catTimer then
        g_catTimer:Stop()
        g_catTimer = nil
    end
end

function OnUnInit()
    if g_catTimer then
        g_catTimer:Stop()
        g_catTimer = nil
    end
end


---------------------------------

--请求所有数据
function SendGetInfo(isVip)
    local l_msgId = Network.Define.Rpc.CatTradeActivityGetInfo
    ---@type CatTradeActivityGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("CatTradeActivityGetInfoArg")
    l_sendInfo.is_vip_refresh = isVip or false
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收所有数据
function OnCatTradeActivityGetInfo(msg)
    ---@type CatTradeActivityGetInfoRes
    local l_resInfo = ParseProtoBufToTable("CatTradeActivityGetInfoRes", msg)
    if l_resInfo.error_code ~= 0 and l_resInfo.error_code ~= 1150 then
        logError("拉取猫车数据异常 => " .. tostring(l_resInfo.error_code))
    end
    Datas = l_resInfo.train_list
    ResetAllFull()
    SetAwardStatus(l_resInfo.status)
    EventDispatcher:Dispatch(Event.InitData, l_resInfo.error_code)
    ResetNeedTable()
end

--请求交货
function SendSellGoods(tid, sid, items)
    local l_msgId = Network.Define.Rpc.CatTradeActivitySellGoods
    ---@type CatTradeActivitySellGoodsArg
    local l_sendInfo = GetProtoBufSendTable("CatTradeActivitySellGoodsArg")
    l_sendInfo.train_id = tid
    l_sendInfo.train_seat_id = sid
    for i = 1, #items do
        local l_dataItem = l_sendInfo.item_list:add()
        local l_dataCount = l_sendInfo.item_count_list:add()
        l_dataItem.value = items[i].uid
        l_dataCount.value = tostring(items[i].num)
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--交货结果
function OnCatTradeActivitySellGoods(msg, arg)
    ---@type CatTradeActivitySellGoodsRes
    local l_resInfo = ParseProtoBufToTable("CatTradeActivitySellGoodsRes", msg)
    if l_resInfo.error_code ~= 0 then
        --logError("猫车货物交取异常 => "..tostring(l_resInfo.error_code))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    else
        for i = 1, #Datas do
            if Datas[i].id == arg.train_id then
                for j = 1, #Datas[i].seat_list do
                    if Datas[i].seat_list[j].id == arg.train_seat_id then
                        Datas[i].seat_list[j].is_full = true

                        local l_change = ResetAllFull()
                        EventDispatcher:Dispatch(Event.ResetData, arg.train_id, arg.train_seat_id, l_change)
                        ResetNeedTable()
                        return
                    end
                end
            end
        end
    end
end

--请求领取奖励
function SendGetReward()
    local l_msgId = Network.Define.Rpc.CatTradeActivityGetReward
    ---@type CatTradeActivityGetRewardArg
    local l_sendInfo = GetProtoBufSendTable("CatTradeActivityGetRewardArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--领取奖励结果
function OnCatTradeActivityGetReward(msg)
    ---@type CatTradeActivityGetRewardRes
    local l_resInfo = ParseProtoBufToTable("CatTradeActivityGetRewardRes", msg)
    if l_resInfo.error_code ~= 0 then
        logError("猫车领取额外奖励异常 => " .. tostring(l_resInfo.error_code))
    else
        SetAwardStatus(2)
    end
end

function ResetAllFull()
    local l_oldValue = AllFull
    if Datas ~= nil and next(Datas) then
        AllFull = true
        for i = 1, #Datas do
            local l_trainFull = true
            for j = 1, #Datas[i].seat_list do
                local l_seat = Datas[i].seat_list[j]
                if not l_seat.is_full then
                    l_trainFull = false
                    break
                end
            end

            Datas[i].is_full = l_trainFull
            if not l_trainFull then
                AllFull = false
            end
        end
    end

    if AllFull ~= l_oldValue and AwardStatus == 0 then
        SetAwardStatus(1)
    end
    return AllFull ~= l_oldValue
end

function SetAwardStatus(value)
    if AwardStatus == value then
        return
    end
    AwardStatus = value
    EventDispatcher:Dispatch(Event.AwardChange, AwardStatus)
end

--- 接道具更新数据
---@param updateItemDataList ItemUpdateData[]
function _onItemUpdate(updateItemDataList)
    if nil == updateItemDataList then
        logError("[CatCaravan] invalid update data")
        return
    end

    for i = 1, #updateItemDataList do
        local singleUpdateData = updateItemDataList[i]
        local itemUpdateReason = singleUpdateData.Reason
        local compareData = singleUpdateData:GetItemCompareData()
        if ItemChangeReason.ITEM_REASON_CAT_TRADE_REWARD == itemUpdateReason and nil ~= singleUpdateData.NewItem then
            local tips = GetItemText(compareData.id, { num = compareData.count, icon = { size = 19, width = 1 } })
            --对绵绵岛有杰出贡献，特别嘉奖道具
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CatCaravan_Award") .. tips)
        end
    end
end

--更具Datas数据刷新需要更新的道具
function ResetNeedTable()
    Datas = Datas or {}
    NeedItems = {}
    NeedItemsCount = {}
    for i = 1, #Datas do
        if not Datas[i].is_full then
            for j = 1, #Datas[i].seat_list do
                local l_seat = Datas[i].seat_list[j]
                if not l_seat.is_full and l_seat.item_count > 0 then
                    local l_recycleRow = TableUtil.GetRecycleTable().GetRowByID(l_seat.item_id)
                    if l_recycleRow ~= nil then
                        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_recycleRow.ItemID)
                        if l_itemRow ~= nil then
                            local l_data = nil
                            for i = 1, #NeedItems do
                                if NeedItems[i].ID == l_recycleRow.ItemID then
                                    l_data = NeedItems[i]
                                    break
                                end
                            end
                            if l_data == nil then
                                l_data = {
                                    ID = l_recycleRow.ItemID,
                                    Count = 0,
                                }
                                NeedItems[#NeedItems + 1] = l_data
                            end
                            if NeedItemsCount[l_recycleRow.ItemID] == nil then
                                NeedItemsCount[l_recycleRow.ItemID] = 0
                            end
                            NeedItemsCount[l_recycleRow.ItemID] = NeedItemsCount[l_recycleRow.ItemID] + l_seat.item_count
                            l_data.Count = l_data.Count + l_seat.item_count
                        end
                    end
                end
            end
        end
    end

    GetNeedItemTable()
end

--获取需求道具数量，如不是需求道具则返回0
function GetNeedItemCount(id)
    if NeedItemsCount == nil then
        return 0
    end
    return NeedItemsCount[tonumber(id)] or 0
end

--获取需求道具列表（数据只读不能修改）
function GetNeedItemTable()
    return NeedItemsCount
end

--道具是否为需求的道具
function IsNeedItem(id)
    for i = 1, #NeedItems do
        if NeedItems[i].ID == id then
            local l_curNum = Data.BagModel:GetBagItemCountByTid(id)
            return l_curNum < NeedItems[i].Count
        end
    end
    return false
end

--红点
function OnRedPointNotifyGs(msg)
    ---@type ModuleMgr.RedSignCheckMgr
    local mgr = MgrMgr:GetMgr("RedSignCheckMgr")
    mgr.ReceiveRedPointNotify(msg)
end

--尝试截取日常任务
function TryGetTask()
    --获取猫手任务ID
    local l_taskId = MGlobalConfig:GetInt("OrderTaskId")
    if l_taskId  and l_taskId ~= 0 then
        local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
        local l_Status = l_taskMgr.GetTaskStatusAndStep(l_taskId)
        --如果是可接取状态则请求接取
        if l_Status == l_taskMgr.ETaskStatus.CanTake then
            MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(l_taskId)
        end
    end
end

---@return int64
function GetCoinOrPropNumWithoutMultiTalentsEquip(tid)
    if MgrMgr:GetMgr("PropMgr").IsVirtualCoin(tid) then
        return Data.BagModel:GetCoinNumById(tid)
    end

    local count = 0
    local items = _getValidBagItems(tid)
    for i = 1, #items do
        local singleItem = items[i]
        if not MgrMgr:GetMgr("MultiTalentEquipMgr").IsInMultiTalentEquipWithUid(singleItem.UID) then
            count = count + singleItem.ItemCount
        end
    end

    return count
end

---@param itemData ItemData
---@param param boolean
function _validFunc(itemData, param)
    if nil == itemData or GameEnum.ELuaBaseType.Boolean ~= type(param) then
        return false
    end

    local uid = itemData.UID
    local containsUID = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(uid)
    return containsUID == param
end

--- 获取符合条件道具对象
function _getValidBagItems(tid)
    if GameEnum.ELuaBaseType.Number ~= type(tid) then
        logError("[CatCaravan] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local conditions = {
        { Cond = _validFunc, Param = false },
        { Cond = itemFuncUtil.ItemMatchesTid, Param = tid },
    }

    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

function IsAllFull()
    return AllFull
end

return ModuleMgr.CatCaravanMgr