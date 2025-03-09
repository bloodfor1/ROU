---@module ModuleMgr.MallMgr
module("ModuleMgr.MallMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
Event = {
    ResetData = "ResetData", --刷新所有数据
    ResetItem = "ResetItem", --单个商品刷新
    FreshMallItemEvent="FreshMallItemEvent",
}
DataLis = {}

MallPanelOpenType = {
    ToPay = "ToPay",
    OnFindItem = "OnFindItem",
    SetTablePay = "SetTablePay"
}

MallTable = {
    Glod_Hot = 101, --金币-热销
    Glod_Gift = 102, --金币-礼包
    Glod_Appearance = 103, -- 金币-外观
    House_Zeny = 201, --万事屋-zeny
    House_Copper = 202, --万事屋-铜币
    Mystery = 301, --神秘商店
    Pay = 401, --充值
    ReBackPoint = 801,    --回归商店-积分
    ReBackPay = 802,      --回归商店-喵喵商店
    NewPlayer = 901,
    Festival = 77101,     -- 节日商店       -- 特殊处理，没有配置在表里
}

ProductType_TYPE = {                -- 和 PaymentTable.ProductType对应
    Recharge = 1,                   -- 喵喵果实
    ActiveMonthCard = 2,            -- 卡普拉贵宾卡
    CommonMonthCard = 3,            -- 普通返利月卡
    SuperMonthCard = 4,             -- 超级返利月卡
}

DeliverWayType = {
    None = 0,
    Mail = 1,
}

RetryTime = nil --重发的消息
RefundExpirationTime = 0        -- 退款有效时间 单位：秒

MallManualRefreshCount = {}

MallType2System = nil

MallTypeRedSign2CommondataId = nil

MallSystemId = nil

local curWaitMessage = nil
local l_manualCheckTimer = nil
local l_lastLevel
------------------------------生命周期
function OnInit()
    RefundExpirationTime = TableUtil.GetGlobalTable().GetRowByName("RefundExpirationTime").Value * 3600 --小时转秒

    local l_systemId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId
    MallType2System = {
        [MallTable.Glod_Hot] = l_systemId.MallGoldHot,
        [MallTable.Glod_Gift] = l_systemId.MallGoldGift,
        [MallTable.Glod_Appearance] = l_systemId.MallGoldAppearance,
        [MallTable.House_Zeny] = l_systemId.MallMasterHouseZeny,
        [MallTable.House_Copper] = l_systemId.MallMasterHouseCoin,
        [MallTable.Mystery] = l_systemId.MallMysteryShop,
        [MallTable.Pay] = l_systemId.MallFeeding,
    }

    MallTypeRedSign2CommondataId = {}

    local l_config = MGlobalConfig:GetString("MallRedDot")
    if string.len(l_config) > 0 then
        local l_split1 = string.ro_split(l_config, "|")
        for i, v in ipairs(l_split1) do
            local l_args = string.ro_split(v, "=")
            if #l_args ~= 6 then
                logError("global表 MallRedDot 配置问题")
            else
                MallTypeRedSign2CommondataId[tonumber(l_args[1])] = {
                    LastRefreshTimeKey = tonumber(l_args[2]),
                    DayInterval = tonumber(l_args[3]),
                    LevelCheck = tonumber(l_args[4]),
                    RedSign = tonumber(l_args[5]),
                    RedSignCheck = tonumber(l_args[6]),
                }
            end
        end
    end

    local l_propMgr = MgrMgr:GetMgr("PropMgr")
    l_propMgr.EventDispatcher:Add(l_propMgr.LEVEL_CHANGE, OnLevelChanged)

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    MallSystemId = l_openSystemMgr.eSystemId.Mall
    l_openSystemMgr.EventDispatcher:Add(l_openSystemMgr.OpenSystemUpdate, OnSystemUpdate)

    CloseAllManualCheckTimer()
end

function OnLogout()

    l_lastLevel = nil
    curWaitMessage = nil
    CloseAllManualCheckTimer()
end

function OnReconnected()

    curWaitMessage = nil
end

function OnSelectRoleNtf(info)

    MallManualRefreshCount = {}

    local l_record = info.mall_record
    if l_record and l_record.records then
        for i, v in ipairs(l_record.records) do
            MallManualRefreshCount[v.mall_id] = v.manual_refresh_count 
        end
    end

    l_lastLevel = info.brief.level

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if l_openSystemMgr.IsSystemOpen(MallSystemId) then
        RequestGetMallTimeStamp()
    end
end

function OnLogout()
    if RetryTime then
        RetryTime:Stop()
        RetryTime = nil
    end
    DataLis={}
end


------------------------------public
function GetMallData(mid, send)
    local l_data = DataLis and DataLis[mid] or nil
    if not l_data and send and mid ~= MallTable.Pay then
        SendGetMallInfo(mid)
        return true
    end
    return false, l_data or {}
end

function GetMallIdByFuncId(funcId)
    local l_default = MallTable.Glod_Hot
    if MallType2System == nil or table.ro_size(MallType2System) == 0 then
        return l_default
    end

    for key, value in pairs(MallType2System) do
        if value == funcId then
            return key
        end
    end
    return l_default
end

------------------------------协议
--获取所有数据
function SendGetMallInfo(mid)
    local l_msgId = Network.Define.Rpc.GetMallInfo
    ---@type GetMallInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetMallInfoArg")
    l_sendInfo.mall_id = mid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnGetMallInfo(msg, arg)
    ---@type GetMallInfoRes
    local l_resInfo = ParseProtoBufToTable("GetMallInfoRes", msg)
    if l_resInfo.error ~= ErrorCode.ERR_SUCCESS then
        if l_resInfo.error == ErrorCode.ERR_ROLE_NOTEXIST then
            --这个error需要特殊处理，定时重发
            if RetryTime then
                RetryTime:Stop()
            end
            RetryTime = Timer.New(function()
                SendGetMallInfo(arg.mall_id)
                RetryTime = nil
            end, 1)
            RetryTime:Start()
        else
            if arg.mall_id == MallTable.NewPlayer and l_resInfo.error == ErrorCode.ERR_SYSTEM_NOT_OPEN then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEW_PLAYER_CLOSE"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error))
            end
        end
        return
    end

    _setMallData(arg.mall_id, l_resInfo.items, l_resInfo.next_fresh_time, l_resInfo.manual_refresh_count)

    --logError("获得商店数据 => mid={0}; 数量=>{1}", arg.mall_id, #l_resInfo.items)
    EventDispatcher:Dispatch(Event.ResetData, arg.mall_id)
end

function RequestManualRefreshMallItem(mid)
    
    local l_msgId = Network.Define.Rpc.ManualRefreshMallItem
    ---@type GetMallInfoArg
    local l_sendInfo = GetProtoBufSendTable("ManualRefreshMallItemArg")
    l_sendInfo.mall_id = mid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRefreshSuccess(mid)

    SendGetMallInfo(mid, true)
end

function OnManualRefreshMallItem(msg, arg)
    local l_info = ParseProtoBufToTable("ManualRefreshMallItemRes", msg)
    local l_mallId = arg.mall_id
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        if l_info.result == ErrorCode.ERR_IN_PAYING then
            game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.ManualRefreshMallItem, function()
                OnRefreshSuccess(l_mallId)
            end)
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end

    OnRefreshSuccess(l_mallId)
end

function _setMallData(mallId, mallItems, nextFreshTime, manualRefreshCount)
    local l_dataLis = {}
    for i = 1, #mallItems do
        local l_item = mallItems[i]
        local l_mallRow = TableUtil.GetMallTable().GetRowByMajorID(l_item.seq_id)
        if l_mallRow then
            l_dataLis[#l_dataLis + 1] = l_item
        else
            logError("接受到不存在的商品 => mid={0} sid={1}", mallId, l_item.seq_id)
        end
    end
    --排序
    table.sort(l_dataLis, function(a, b)
        local l_mRowA = TableUtil.GetMallTable().GetRowByMajorID(a.seq_id)
        local l_mRowB = TableUtil.GetMallTable().GetRowByMajorID(b.seq_id)
        return l_mRowB.SequenceId > l_mRowA.SequenceId
    end)
    DataLis[mallId] = {
        mid = mallId,
        data = l_dataLis,
        time = nextFreshTime + Time.realtimeSinceStartup,
        resetTime = MServerTimeMgr.UtcSeconds,
    }

    MallManualRefreshCount[mallId] = manualRefreshCount
end

function CheckRedSignMethod(mallId)
    
    if not IsSystemOpenByMallType(mallId) then
        return 0
    end

    local l_config = MallTypeRedSign2CommondataId[mallId]
    if not l_config then
        return 0
    end

    if l_config.LevelCheck ~= 0 then
        if MPlayerInfo.Lv >= l_config.LevelCheck then
            return 1
        else
            return 0
        end
    end

    -- 这是是通过红点表的LoseCheck实现，所以这里返回1即可
    return 1
end

function CheckRedSignMethodGoldGift()

    return CheckRedSignMethod(MallTable.Glod_Gift)
end

function CheckRedSignMethodMystery()

    return CheckRedSignMethod(MallTable.Mystery)
end

function CloseAllManualCheckTimer()
    if l_manualCheckTimer then
        l_manualCheckTimer:Stop()
        l_manualCheckTimer = nil
    end
end

function RequestGetMallTimeStamp()
    CloseAllManualCheckTimer()

    local l_msgId = Network.Define.Rpc.GetMallTimestamp
    ---@type GetMallTimestampArg
    local l_sendInfo = GetProtoBufSendTable("GetMallTimestampArg")
    local l_tbl = {}
    for k, _ in pairs(MallTypeRedSign2CommondataId) do
        table.insert(l_tbl, k)
    end
    l_sendInfo.mall_id_list = l_tbl
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetMallTimestamp(msg, args)
    local l_info = ParseProtoBufToTable("GetMallTimestampRes", msg)
    -- logError("OnGetMallTimestamp", ToString(l_info))
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    local l_nextRefreshTime
    for i, v in ipairs(args.mall_id_list) do
        ManualCheckRedSign(v, l_info.mall_timestamp[i])

        local l_next = l_info.mall_timestamp[i].next_refresh_timestamp
        if not l_nextRefreshTime then
            l_nextRefreshTime = l_next
        elseif l_next < l_nextRefreshTime then
            l_nextRefreshTime = l_next
        end
    end
    if l_nextRefreshTime then
        local l_remainTime = MLuaCommonHelper.Int(l_nextRefreshTime - Common.TimeMgr.GetNowTimestamp())
        l_manualCheckTimer = Timer.New(function()
            RequestGetMallTimeStamp()
        end, l_remainTime)
        l_manualCheckTimer:Start()
    end
end

function ManualCheckRedSign(mallId, timeStamp)

    if not mallId or not timeStamp then
        logError("[MallMgr]ManualCheckRedSign 无效参数", tostring(mallId), tostring(timeStamp))
        return
    end

    local l_config = MallTypeRedSign2CommondataId[mallId]
    if not l_config then
        log("[MallMgr]ManualCheckRedSign 无对应商店红点配置，无需更新")
        return
    end

    local l_lastRecordTimeStamp = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(l_config.LastRefreshTimeKey) or 0
    log("[MallMgr]ManualCheckRedSign", tostring(timeStamp.next_refresh_timestamp), tostring(l_lastRecordTimeStamp))
    if int64.equals(timeStamp.next_refresh_timestamp, l_lastRecordTimeStamp) then
        return
    end

    MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(l_config.LastRefreshTimeKey, timeStamp.next_refresh_timestamp)

    local l_visible = true

    if l_config.DayInterval > 0 then

        local l_timeMgr = Common.TimeMgr
        local l_curTime = l_timeMgr.GetNowTimestamp()
        local l_timeRet = l_timeMgr.GetCountDownDayTimeTable(l_curTime - timeStamp.last_buy_timestamp)
        local l_day = l_timeRet.day or 0
        -- logError("l_config.DayInterval", l_config.DayInterval, l_day, timeStamp.last_buy_timestamp, l_curTime - timeStamp.last_buy_timestamp)
        if l_config.DayInterval < l_day then
            log("[MallMgr]ManualCheckRedSign 上次购买事件小于配置时间，不显示红点")
            l_visible = false
        end
    end

    if l_visible then
        MgrMgr:GetMgr("RedSignMgr").SetIgnoreState(l_config.RedSign, 0, 0)

        -- update red check
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(l_config.RedSign)
    end
end

function OnLevelChanged()

    if not l_lastLevel or l_lastLevel == MPlayerInfo.Lv then
        return
    end

    l_lastLevel = MPlayerInfo.Lv

    for k, v in pairs(MallTypeRedSign2CommondataId) do
        if v.LevelCheck ~= 0 and v.LevelCheck == MPlayerInfo.Lv then
            MgrMgr:GetMgr("RedSignMgr").SetIgnoreState(v.RedSign, 0, 0)
            -- update red check
            MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(v.RedSign)
            log("[MallMgr]OnLevelChanged 等级触发红点")
        end
    end
end

function OnSystemUpdate(openIds)
    if openIds == nil then
        return
    end

    local l_ret = false
    for i, v in ipairs(openIds) do
        if v.value == MallSystemId then
            l_ret = true
            break
        end
    end

    if l_ret then
        RequestGetMallTimeStamp()
    end
end

--购买
function SendBuyMallItem(mid, sid, num, price, isNotCheck)
    local l_curCoinId = nil

    local l_mallRow = TableUtil.GetMallTable().GetRowByMajorID(sid)
    if l_mallRow then
        local l_cost = Common.Functions.VectorSequenceToTable(l_mallRow.cost)
        l_curCoinId = tonumber(l_cost[1][1])
    end

    if num * price > 0 and l_curCoinId then
        local _, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(l_curCoinId, num * price)
        if l_needNum > 0 and not isNotCheck and l_curCoinId ~= GameEnum.l_virProp.Coin103 and l_curCoinId ~= GameEnum.l_virProp.Coin104 then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(l_curCoinId, l_needNum, function()
                SendBuyMallItem(mid, sid, num, price, true)
            end)
            return
        end
    end

    if curWaitMessage ~= nil then
        return
    end
    curWaitMessage = Network.Define.Rpc.BuyMallItem

    local l_msgId = Network.Define.Rpc.BuyMallItem
    ---@type BuyMallItemArg
    local l_sendInfo = GetProtoBufSendTable("BuyMallItemArg")
    l_sendInfo.mall_id = mid
    l_sendInfo.seq_id = sid
    l_sendInfo.num = num
    l_sendInfo.now_price = tostring(price)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function CopyParameters(info, arg)

    local l_arg = {}
    l_arg.mall_id = arg.mall_id
    l_arg.num = arg.num
    l_arg.seq_id = arg.seq_id

    return l_arg, info.need_refresh
end

function OnBuyMallItem(msg, arg)
    curWaitMessage = nil
    ---@type BuyMallItemRes
    local l_resInfo = ParseProtoBufToTable("BuyMallItemRes", msg)
    if l_resInfo.error.errorno ~= ErrorCode.ERR_SUCCESS then
        if l_resInfo.error.errorno == ErrorCode.ERR_ROLE_NOTEXIST then
            --这个error需要特殊处理，定时重发
            if RetryTime then
                RetryTime:Stop()
            end
            RetryTime = Timer.New(function()
                SendBuyMallItem(arg.mall_id, arg.seq_id, arg.num, arg.now_price)
                RetryTime = nil
            end, 1)
            RetryTime:Start()
        else
            if l_resInfo.error.errorno == ErrorCode.ERR_IN_PAYING then
                local l_arg, l_refresh = CopyParameters(l_resInfo, arg)
                game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.BuyMallItem, function()
                    OnBuySuccess(l_arg, l_refresh)
                end)
                return
            end
            if arg.mall_id == MallTable.NewPlayer and l_resInfo.error.errorno == ErrorCode.ERR_SYSTEM_NOT_OPEN then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEW_PLAYER_CLOSE"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error.errorno))
            end
        end
    else
        OnBuySuccess(arg, l_resInfo.need_refresh)
    end
end

function OnBuySuccess(arg, needRefresh)

    --替换数据
    local l_refresh, l_mData = GetMallData(arg.mall_id)
    local l_data = nil
    if not l_refresh and l_mData.data then
        for i = 1, #l_mData.data do
            if l_mData.data[i].seq_id == arg.seq_id then
                l_data = l_mData.data[i]
                break
            end
        end
    end
    if not l_refresh and l_data then
        if l_data.left_times > 0 then
            l_data.left_times = math.max(0, l_data.left_times - arg.num)
            EventDispatcher:Dispatch(Event.ResetItem, arg.mall_id, l_data)
        end
        MgrMgr:GetMgr("AdjustTrackerMgr").PurchaseCompleteEvent(arg.mall_id)

        local l_mallRow = TableUtil.GetMallTable().GetRowByMajorID(arg.seq_id)
        if l_mallRow and CanShowDeliverWay(l_mallRow.DeliverWay) then
            local l_ui = UIMgr:GetUI(UI.CtrlNames.Mall)
            if l_ui ~= nil then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MallItemToMail"))
            end
            local l_ui = UIMgr:GetUI(UI.CtrlNames.ReBack)
            if l_ui ~= nil then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ReturnMallItemToMail"))
            end
            local l_ui = UIMgr:GetUI(UI.CtrlNames.NewPlayer)
            if l_ui ~= nil then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ReturnMallItemToMail"))
            end
        end
    else
        logError("购买成功，但是找不到对应的商品")
    end

    if needRefresh then
        SendGetMallInfo(arg.mall_id)
    end
end

function RequestFreshMallItem(mallIdTable)
    local l_msgId = Network.Define.Rpc.FreshMallItem
    local l_sendInfo = GetProtoBufSendTable("FreshMallItemArg")
    l_sendInfo.mall_id = mallIdTable
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveFreshMallItem(msg, arg)
    local l_info = ParseProtoBufToTable("FreshMallItemRes", msg)
    EventDispatcher:Dispatch(Event.FreshMallItemEvent)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    local mallItems = l_info.mall_items
    local mallItem
    for i = 1, #mallItems do
        mallItem = mallItems[i]
        _setMallData(mallItem.mall_id, mallItem.items, mallItem.next_fresh_time)
        EventDispatcher:Dispatch(Event.ResetData, mallItem.mall_id)
    end
end


function IsSystemOpenByMallType(mallType)
 
    local l_systemId = MallType2System[mallType]
    if not l_systemId then
        return false
    end

    return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_systemId)
end


function GetRefreshCount(mallId)

    local l_count = MallManualRefreshCount[mallId] or 0

    return l_count + 1
end

function GetRefreshCost(mallId)
    
    local l_refreshCount = GetRefreshCount(mallId)
    for i = 1, TableUtil.GetMallRefreshTable().GetTableSize() do
        local l_row = TableUtil.GetMallRefreshTable().GetRowByMajorID(i, true)
        if not l_row then
            return
        end
        if l_refreshCount >= l_row.RefreshTime[0] and l_refreshCount <= l_row.RefreshTime[1] then
            local l_cost = {}
            if l_row.CostItem[1] ~= 0 then
                l_cost.ItemId = l_row.CostItem[0]
                l_cost.Count = l_row.CostItem[1]
            end
            return l_cost
        end
    end
end


function CanShowDeliverWay(deliverWay)
    if not deliverWay then return false end

    if deliverWay.Length ~= 2 then return false end

    if deliverWay[0] == DeliverWayType.Mail then return true end

    return false
end

return ModuleMgr.MallMgr