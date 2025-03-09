---@module ModuleMgr.BattleStatisticsMgr
module("ModuleMgr.BattleStatisticsMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

OnRefreshSimpleBattleRevenue = "OnRefreshSimpleBattleRevenue"
OnRefreshBattleRevenue = "OnRefreshBattleRevenue"

local l_currentBlessFightTime = 0
local l_currentBlessBaseExp = 0
local l_currentBlessJobExp = 0
local l_currentBlessItem = {}
local l_isBless = false
local l_remainBlessTime = 0

local l_currentNormalFightTime = 0
local l_currentNormalBaseExp = 0
local l_currentNormalJobExp = 0
local l_currentNormalItem = {}

local l_currentTotalFightTime = 0
local l_currentTotalBaseExp = 0
local l_currentTotalJobExp = 0
local l_currentTotalItem = {}

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

--请求详细战斗统计信息
function BattleRevenueReq()

    local l_msgid = Network.Define.Rpc.GetBattleRevenue
    ---@type GetBattleRevenueArg
    local l_sendInfo = GetProtoBufSendTable("GetBattleRevenueArg")
    Network.Handler.SendRpc(l_msgid, l_sendinfo)

end

--详细战斗统计信息返回信息
function BattleRevenueResp(msg)
    ---@type GetBattleRevenueRes
    local l_info = ParseProtoBufToTable("GetBattleRevenueRes", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_isBless = l_info.bless_info.is_bless
    l_remainBlessTime = l_info.bless_info.remain_bless_time
    l_currentBlessFightTime = l_info.bless_info.base_info.fight_time
    l_currentBlessBaseExp = l_info.bless_info.base_info.base_exp
    l_currentBlessJobExp = l_info.bless_info.base_info.job_exp
    l_currentBlessItem = GetItemInfo(l_info.bless_info.base_info.items)

    l_currentNormalFightTime = l_info.common_info.base_info.fight_time
    l_currentNormalBaseExp = l_info.common_info.base_info.base_exp
    l_currentNormalJobExp = l_info.common_info.base_info.job_exp
    l_currentNormalItem = GetItemInfo(l_info.common_info.base_info.items)

    l_currentTotalItem = GetItemInfo(l_info.bless_info.base_info.items, l_info.common_info.base_info.items)
    l_currentTotalFightTime = l_currentBlessFightTime + l_currentNormalFightTime
    l_currentTotalBaseExp = l_currentBlessBaseExp + l_currentNormalBaseExp
    l_currentTotalJobExp = l_currentBlessJobExp + l_currentNormalJobExp

    SendEventRefreshBattleRevenue()
end

function OnBattleRevenueChangeNtf(msg)
    ---@type RevenueChangeDataPb
    local l_info = ParseProtoBufToTable("RevenueChangeDataPb", msg)

    local l_bless = l_info.is_bless
    for i = 1, #l_info.items do
        local l_item = l_info.items[i]
        local l_itemid = l_item.item_id
        local l_itemCount = l_item.item_count
        local l_itemTime = l_item.time

        --更新物品函数
        local l_updateItemList = function(itemList, condition)

            if not condition() then
                return
            end

            local l_contains = false
            for j = 1, #itemList do
                if itemList[j].ID == l_itemid then
                    l_contains = true
                    itemList[j].Count = itemList[j].Count + l_itemCount
                    itemList[j].Time = l_itemTime
                    break
                end
            end
            if not l_contains then
                table.insert(itemList, {
                    ID = l_item.item_id,
                    Count = l_item.item_count,
                    Time = l_item.time
                })
            end

            table.sort(itemList, function(a, b)
                return a.Time > b.Time
            end)

        end

        l_updateItemList(l_currentBlessItem, function()
            return l_bless == true
        end)

        l_updateItemList(l_currentNormalItem, function()
            return l_bless == false
        end)

        l_updateItemList(l_currentTotalItem, function()
            return true
        end)
    end

    SendEventRefreshBattleRevenue()
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[BattleStatisticsMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        if nil ~= singleData.NewItem then
            local compareData = singleData:GetItemCompareData()
            if GameEnum.l_virProp.exp == compareData.id then
                if ItemChangeReason.ITEM_REASON_EXP_BLESS == singleData.Reason then
                    l_currentBlessBaseExp = l_currentBlessBaseExp + compareData.count
                else
                    l_currentNormalBaseExp = l_currentNormalBaseExp + compareData.count
                end
            elseif GameEnum.l_virProp.jobExp == compareData.id then
                if ItemChangeReason.ITEM_REASON_EXP_BLESS == singleData.Reason then
                    l_currentBlessJobExp = l_currentBlessJobExp + compareData.count
                else
                    l_currentNormalJobExp = l_currentNormalJobExp + compareData.count
                end
            end
        end
    end

    l_currentTotalBaseExp = l_currentBlessBaseExp + l_currentNormalBaseExp
    l_currentTotalJobExp = l_currentBlessJobExp + l_currentNormalJobExp
    SendEventRefreshBattleRevenue()
end

function OpenBlessedExperiencePanel()
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.BlessedExperience) then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.BlessedExperience_Panel)
end

function OnHealthExpNtf(msg)
    ---@type HealthExpData
    local l_info = ParseProtoBufToTable("HealthExpData", msg)
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.BlessedExperience) then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.BlessedExperience, { healthExpData = l_info })
end

function OnLogout()
    UIMgr:DeActiveUI(UI.CtrlNames.BattleStatistics, true)
    l_currentBlessFightTime = 0
    l_currentBlessBaseExp = 0
    l_currentBlessJobExp = 0
    l_currentBlessItem = {}
    l_isBless = false
    l_remainBlessTime = 0

    l_currentNormalFightTime = 0
    l_currentNormalBaseExp = 0
    l_currentNormalJobExp = 0
    l_currentNormalItem = {}

    l_currentTotalFightTime = 0
    l_currentTotalBaseExp = 0
    l_currentTotalJobExp = 0
    l_currentTotalItem = {}
end

--发送刷新简单统计信息事件
function SendEventRefreshSimpleBattleRevenue()

    local l_showItems = {}
    for i = 1, 3 do
        l_showItems[i] = l_currentTotalItem[i]
    end
    EventDispatcher:Dispatch(OnRefreshSimpleBattleRevenue, {
        FightTime = l_currentTotalFightTime,
        BaseExp = l_currentTotalBaseExp,
        JobExp = l_currentTotalJobExp,
        Items = l_showItems
    })

end

--发送刷新详细统计信息事件
function SendEventRefreshBattleRevenue()

    EventDispatcher:Dispatch(OnRefreshBattleRevenue, {
        Bless = {
            FightTime = l_currentBlessFightTime,
            BaseExp = l_currentBlessBaseExp,
            JobExp = l_currentBlessJobExp,
            Items = l_currentBlessItem,
            IsBless = l_isBless,
            RemainBlessTime = l_remainBlessTime
        },
        Normal = {
            FightTime = l_currentNormalFightTime,
            BaseExp = l_currentNormalBaseExp,
            JobExp = l_currentNormalJobExp,
            Items = l_currentNormalItem,
        }
    })

    SendEventRefreshSimpleBattleRevenue()

end

function getCurrentNormalFightTime()
    return l_currentNormalFightTime
end

--将协议中的物品信息转换为所需的数据结构
function GetItemInfo(itemList, itemListEx)

    local l_result = {}
    local l_ids = {}

    if itemList then
        for i = 1, #itemList do
            local l_item = itemList[i]
            table.insert(l_result, {
                ID = l_item.item_id,
                Count = l_item.item_count,
                Time = l_item.time
            })
            l_ids[l_item.item_id] = i
        end
    end

    if itemListEx then
        for i = 1, #itemListEx do
            local l_item = itemListEx[i]
            if l_ids[l_item.item_id] and l_ids[l_item.item_id] > 0 then
                local l_idx = l_ids[l_item.item_id]
                l_result[l_idx].Count = l_result[l_idx].Count + l_item.item_count
                if l_item.time > l_result[l_idx].Time then
                    l_result[l_idx].Time = l_item.time
                end
            else
                table.insert(l_result, {
                    ID = l_item.item_id,
                    Count = l_item.item_count,
                    Time = l_item.time
                })
            end
        end
    end

    table.sort(l_result, function(a, b)
        return a.Time > b.Time
    end)
    return l_result
end


function GetBattleStateByTime(battleTime)
    local l_state = GameEnum.EBattleHealthy.Healthy
    local l_stateText = ""
    local l_timeText = StringEx.Format("{0:F0}", battleTime) .. Lang("MINUTE")

    local l_healthTime = MGlobalConfig:GetInt("HealthyFightTime")
    local l_tiredFightTime = MGlobalConfig:GetInt("TiredFightTime")
    if battleTime < l_healthTime then
        l_state = GameEnum.EBattleHealthy.Healthy
        l_stateText = "<color=$$Green$$>" .. Lang("HEALTHY") .. "</color>"
        l_timeText = "<color=$$Green$$>" .. l_timeText .. "</color>"
    elseif battleTime < l_tiredFightTime then
        l_state = GameEnum.EBattleHealthy.Tried
        l_stateText = "<color=$$Yellow$$>" .. Lang("TIRED") .. "</color>"
        l_timeText = "<color=$$Yellow$$>" .. l_timeText .. "</color>"
    else
        l_state = GameEnum.EBattleHealthy.VeryTried
        l_stateText = "<color=$$Red$$>" .. Lang("VERY_TIRED") .. "</color>"
        l_timeText = "<color=$$Red$$>" .. l_timeText .. "</color>"
    end

    return l_state, RoColor.FormatWord(l_stateText), RoColor.FormatWord(l_timeText)
end


return ModuleMgr.BattleStatisticsMgr