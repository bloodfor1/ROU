---@module ModuleMgr.AutoFightItemMgr
module("ModuleMgr.AutoFightItemMgr", package.seeall)

require("ModuleMgr/CommonMsgProcessor")

EventDispatcher = EventDispatcher.new()
EventType = {
    GuaJiJiaSuRefresh = "GuaJiJiaSuRefresh",             -- 刷新加速道具信息
    DaBaoTangRefresh = "DaBaoTangRefresh",               -- 刷新打宝糖道具信息
}

GuaJiJiaSuItemId = 0
DaBaoTangItemId = 0
DaBaoTangLeftTime = 0
DaBaoTangStartTimeStamp = 0     -- 0表示停止计时

itemIdToBuffIdMap = {

}

daBaoItemPriority = {

}

function OnGuaJiJiaSuItemId(_, value)
    --logError(StringEx.Format("健康挂机加速消耗的itemid{0}", tostring(value)))
    GuaJiJiaSuItemId = tonumber(value)

    EventDispatcher:Dispatch(EventType.GuaJiJiaSuRefresh)
end

function OnDaBaoTangItemId(_, value)
    --logError(StringEx.Format("打宝糖当前itemid{0}", tostring(value)))
    DaBaoTangItemId = tonumber(value)

    EventDispatcher:Dispatch(EventType.DaBaoTangRefresh)
end

function OnDaBaoTangLeftTime(_, value)
    --logError(StringEx.Format("打宝糖剩余时间{0}", tostring(value)))
    DaBaoTangLeftTime = tonumber(value)

    EventDispatcher:Dispatch(EventType.DaBaoTangRefresh)
end

function OnDaBaoTangStartTimeStamp(_, value)
    --logError(StringEx.Format("打宝糖开始计时时间轴{0}", tostring(value)))
    DaBaoTangStartTimeStamp = tonumber(value)

    EventDispatcher:Dispatch(EventType.DaBaoTangRefresh)
end


function OnInit()
    -- 通用数据协议处理称号
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_HEALTH_BATTLE_QUICKLY,
        Callback = OnGuaJiJiaSuItemId,
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_DAOBAO_CANDY_ID,
        Callback = OnDaBaoTangItemId,
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_DABAO_CANDY_REMAIN_TIME,
        Callback = OnDaBaoTangLeftTime,
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_DABAO_CANDY_START_TICK,
        Callback = OnDaBaoTangStartTimeStamp,
    })
    l_commonData:Init(l_data)

    local l_buffIds = MGlobalConfig:GetVectorSequence("AwardDropUpBuffID")
    for i = 0, l_buffIds.Length-1 do
        itemIdToBuffIdMap[tonumber(l_buffIds[i][0])] = tonumber(l_buffIds[i][1])
    end

    local l_itemIds = MGlobalConfig:GetSequenceOrVectorInt("AwardDropUpSort")
    for i = 0, l_itemIds.Length-1 do
        daBaoItemPriority[l_itemIds[i]] = i+1
    end
end

function OnLogout()
    GuaJiJiaSuItemId = 0
    DaBaoTangItemId = 0
    DaBaoTangLeftTime = 0
    DaBaoTangStartTimeStamp = 0     -- 0表示停止计时
end


function CheckUseGuaJiJiaSuItem(itemId, useItemFunc)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
    local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
    if not l_itemRow or not l_itemFucRow then return end
    local l_state, l_stateText, l_timeText = MgrMgr:GetMgr("BattleStatisticsMgr").GetBattleStateByTime(MPlayerInfo.ExtraFightTime / (60 * 1000))
    if l_state ~= GameEnum.EBattleHealthy.Healthy then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JIA_SU_TRIED", l_itemRow.ItemName))
        return
    end

    if GuaJiJiaSuItemId == 0 then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("JIA_SU_CONFIRM", l_itemRow.ItemName, l_itemFucRow.ItemFunctionValue[0] / 10000), useItemFunc)
        return
    end

    local l_curItemFuncRow = TableUtil.GetItemFunctionTable().GetRowByItemId(GuaJiJiaSuItemId)
    local l_curItemRow = TableUtil.GetItemTable().GetRowByItemID(GuaJiJiaSuItemId)
    if l_curItemFuncRow and l_curItemRow then
        local l_funcValue = l_itemFucRow.ItemFunctionValue[0] or 0
        local l_curFuncValue = l_curItemFuncRow.ItemFunctionValue[0] or 0
        if l_funcValue == l_curFuncValue then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JIA_SU_EQUAL", l_itemRow.ItemName))
        elseif l_funcValue < l_curFuncValue then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("JIA_SU_LESS"))
        else
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("JIA_SU_GREATER", l_curItemRow.ItemName, l_itemRow.ItemName), useItemFunc)
        end
    end
end


function CheckUseDaBaoItem(itemId, useItemFunc)
    local l_confirmFunc = function()
        if DaBaoTangItemId == 0 and useItemFunc then
            useItemFunc()
            return
        end

        local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
        local l_curItemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(DaBaoTangItemId)
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
        local l_curItemRow = TableUtil.GetItemTable().GetRowByItemID(DaBaoTangItemId)

        if l_itemFucRow and l_curItemFucRow and l_itemRow and l_curItemRow then
            local l_priority = daBaoItemPriority[itemId] or 0
            local l_curPriority = daBaoItemPriority[DaBaoTangItemId] or 0
            if l_priority < l_curPriority then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DA_BAO_LESS"))
            elseif l_priority > l_curPriority then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("DA_BAO_GREATER", l_curItemRow.ItemName, l_itemRow.ItemName), useItemFunc)
            elseif GetDaBaoTangBuffLeftTime() >= MGlobalConfig:GetInt("DropUpCandyLimitTime") then
                --local l_buffName = ""
                --local l_buffRow = TableUtil.GetBuffTable().GetRowById(GetDaBaoTangBuffId())
                --if l_buffRow then
                --    l_buffName = l_buffRow.InGameName
                --end
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DA_BAO_TIME_LIMIT", l_itemRow.ItemName))
            elseif useItemFunc then
                useItemFunc()
            end
        end
    end
    local l_count, l_limit, l_timeStr = GetDaBaoTangCountAndLimitAndTimeStr(itemId)
    if l_count >= l_limit then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DA_BAO_LIMIT", l_timeStr))
    else
        local l_itemName = ""
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
        if l_itemRow then
            l_itemName = l_itemRow.ItemName
        end
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("DA_BAO_CONFIRM", l_itemName, l_timeStr, l_limit - l_count), l_confirmFunc, nil, nil, 2, "DaBaoTangConfirm")
    end
end

-- 获取打宝糖buffid
function GetDaBaoTangBuffId()
    local l_buffId = itemIdToBuffIdMap[DaBaoTangItemId] or 0
    return l_buffId
end

function IsDaBaoTangBuffStop()
    return DaBaoTangStartTimeStamp == 0
end

function GetDaBaoTangBuffLeftTime()
    if DaBaoTangStartTimeStamp == 0 then
        return DaBaoTangLeftTime
    end
    return DaBaoTangLeftTime - (MServerTimeMgr.UtcSeconds_u - DaBaoTangStartTimeStamp)
end

-- 获取挂机加速倍速
function GetJiaJiJiaSuFactor()
    local l_factor = 0
    local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(GuaJiJiaSuItemId, true)
    if l_itemFucRow then
        l_factor = l_itemFucRow.ItemFunctionValue[0] / 10000
    end
    return l_factor
end

function GetDaBaoTangCountAndLimitAndTimeStr(itemId)
    local l_limitId = 0
    local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
    if l_itemFucRow then
        local l_itemUseLimitRow = TableUtil.GetItemUseLimitTable().GetRowByID(l_itemFucRow.ItemLimitID[0][0])
        if l_itemUseLimitRow then
            l_limitId = l_itemUseLimitRow.Para[1] or 0
        end
    end
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_count = l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.DaBaoTang, l_limitId)
    local l_limit = l_limitBuyMgr.GetLimitByKey(l_limitBuyMgr.g_limitType.DaBaoTang, l_limitId)
    local l_timeStr = ""
    local l_refreshType = l_limitBuyMgr.GetRefreshTypeByKey(l_limitBuyMgr.g_limitType.DaBaoTang, l_limitId)
    if l_refreshType == 0 then
    elseif l_refreshType == 1 or l_refreshType == 2 then
        l_timeStr = Lang("JIN_RI")
    elseif l_refreshType == 3 or l_refreshType == 4 then
        l_timeStr = Lang("BEN_ZHOU")
    end
    return l_count, l_limit, l_timeStr
end

return ModuleMgr.AutoFightItemMgr