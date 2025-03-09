---
--- Created by husheng.
--- DateTime: 2018/5/24 16:59
---
---@module ModuleMgr.TradeMgr
module("ModuleMgr.TradeMgr", package.seeall)

require "Common.TimeMgr"
require "Data.Model.BagModel"

module("ModuleMgr.TradeMgr", package.seeall)

--------------------------------事件相关------------------------------------------------
EventDispatcher = EventDispatcher.new()
ON_TYPE_CLICK = "ON_TYPE_CLICK"
-- 商品信息更新
ON_ITEM_INFO_UPDATE = "ON_ITEM_INFO_UPDATE"
ON_ITEM_INFO_DELETE = "ON_ITEM_INFO_DELETE"
ON_BAG_ITEM_CHANGE = "ON_BAG_ITEM_CHANGE"
FORCE_TO_BUY = "FORCE_TO_BUY"
FORCE_TO_SELL = "FORCE_TO_SELL"
REFRASH_TRADE_PANEL = "REFRASH_TRADE_PANEL"
ITEM_FOLLOW_CHANGED = "ITEM_FOLLOW_CHANGED"
--------------------------------事件相关------------------------------------------------


-- 是否是购买面板
IsBuyPanel = true
-- 服务器等级
ServerLevel = 0
-- 是否是第一次进入
TradeFirstIn = true
-- 所查找的商会物品id
SearchTradeItemId = nil
-- 所查找物品的主分类id
SearchTradeMainId = nil
-- 所查找物品的子分类id
SearchTradeSonId = nil
-- 界面关闭时的主分类id
LastMainId = nil
-- 界面关闭时的子分类id
LastSonId = nil
-- 界面关闭时的物品id
LastItemId = nil
-- 刷新时间
NextRefreshTime = -1


-- 商会数据
tradeData = DataMgr:GetData("TradeData")
--是否已请求过商会数据
isTradeInfoRequired = false

g_noticeDisable = false
g_targetSellItemId = nil
l_itemID = nil
l_tradeItemStock = false

local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
local l_sellType = l_limitMgr.g_limitType.TRADE_SELL
local l_buyType = l_limitMgr.g_limitType.TRADE_BUY
local l_noticeSellType = l_limitMgr.g_limitType.TRADE_SELL_LIMIT
local l_noticeBuyType = l_limitMgr.g_limitType.TRADE_BUY_LIMIT

function OnSelectRoleNtf()
    isTradeInfoRequired = false
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:Add(MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate, OnSystemUpdate, MgrMgr:GetMgr("TradeMgr"))
    OnSystemUpdate()
end

function OnSystemUpdate()
    if not isTradeInfoRequired and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Trade) then
        SendGetTradeInfoReq()
    end
end

--断线重连 重现请求商会数据
function OnReconnected(reconnectData)
    if not isTradeInfoRequired and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Trade) then
        SendGetTradeInfoReq()
    end
end

function OnLogout()
    ServerLevel = 0
    SearchTradeItemId = nil
    SearchTradeMainId = nil
    SearchTradeSonId = nil
    IsBuyPanel = true
    g_targetSellItemId = nil
    g_allTradeInfo = {}
    LastMainId = nil
    LastSonId = nil
    LastItemId = nil
    g_noticeDisable = false
    TradeFirstIn = true
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:RemoveObjectAllFunc(MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate,
            MgrMgr:GetMgr("TradeMgr"))
end

function OpenStallOnAchieve(dataTb)
    local l_tableData = TableUtil.GetStallDetailTable().GetRowByItemID(dataTb.itemId)
    if _isConformServerLevelWithTableInfo(l_tableData) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("OPEN_FAIL_BY_SERVERLIMIT", l_tableData.ServerLevelLimit))
        return
    end
    MgrMgr:GetMgr("SweaterMgr").OpenBuySweater(MgrMgr:GetMgr("SweaterMgr").ESweaterType.Stall, dataTb.itemId)
end

function _isConformServerLevelWithTableInfo(tableInfo)
    if tableInfo == nil then
        return false
    end

    local l_serverLevelLimit = tonumber(tableInfo.ServerLevelLimit)
    if l_serverLevelLimit == nil then
        return false
    end
    local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    if l_roleInfoMgr.SeverLevelData == nil then
        return false
    end
    if l_roleInfoMgr.SeverLevelData.serverlevel == nil then
        return false
    end
    local l_serverlevel = tonumber(l_roleInfoMgr.SeverLevelData.serverlevel)
    if l_serverlevel == nil then
        return false
    end

    return l_serverlevel < l_serverLevelLimit
end

function GetIndexByItemId(itemId)
    local l_commoditRow = TableUtil.GetCommoditTable().GetRowByCommoditID(itemId)
    if l_commoditRow then
        local l_classRow = TableUtil.GetMerchantGuildTable().GetRowByClassificationID(l_commoditRow.OfClassList) -- 分类信息
        if l_classRow then
            local l_mainId = -1
            local l_sonId = -1
            if l_classRow.ClassInformation[0] == 0 then
                l_mainId = l_classRow.ClassInformation[1]
                l_sonId = l_commoditRow.OfClassList
            else
                l_mainId = l_commoditRow.OfClassList
                l_sonId = -1
            end
            return true, l_mainId, l_sonId, itemId
        end
    end
    return false, nil, nil, nil
end

--===================================net info================================================================================

-- info:TradeItemPbInfo
function SetTradeInfo(info)
    local l_itemID = info.item_id
    tradeData.SetTradeInfo(info.item_id, { buyCount = info.buy_count,
                                           sellCount = info.sell_count,
                                           curPrice = info.cur_price,
                                           basePrice = info.base_price,
                                           isNotice = info.is_notice,
                                           isFollow = info.is_follow,
                                           stockNum = MLuaCommonHelper.Long(info.stock_num),
                                           preBuyNum = MLuaCommonHelper.Long(info.pre_buy_num),
                                           modifiedFactor = info.modified_factor

    })
    ---int64==0时,得到的lua类型为number,不是string;

    EventDispatcher:Dispatch(ON_ITEM_INFO_UPDATE, l_itemID)
end

function DeleteTradeInfo(info)
    tradeData.SetTradeInfo(info.item_id, nil)
    EventDispatcher:Dispatch(ON_ITEM_INFO_DELETE, info.item_id)
end

function GetBuyCountLimitInfo(id)
    local l_itemInfo = tradeData.GetTradeInfo(id)
    if not l_itemInfo then
        logError("[TradeMgr]can not find target info.")
        return nil
    end

    if l_itemInfo.isNotice then
        local l_info = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[l_noticeBuyType]
        if not l_info then
            logError(StringEx.Format("[TradeMgr]未能找到公示道具{0}的预售限购信息@昭湘@小红", id))
            return nil
        end
        return l_info[tostring(id)]
    else
        local l_info = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[l_buyType]
        if not l_info then
            logError(StringEx.Format("[TradeMgr]未能找到{0}的限购信息@昭湘@小红", id))
            return nil
        end
        return l_info[tostring(id)]
    end
end

function GetSellCountLimitInfo(id)
    local l_itemInfo = tradeData.GetTradeInfo(id)
    if not l_itemInfo then
        -- 标注一下，这个地方数据是服务器同步下来的，如果没有就是没有，所以报错先注释掉
        -- logError("[TradeMgr]can not find target info.")
        return nil
    end
    if l_itemInfo.isNotice then
        local l_info = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[l_noticeSellType]
        if not l_info then
            logError(StringEx.Format("[TradeMgr]未能找到公示道具{0}的出售限购信息@昭湘@小红", id))
            return nil
        end
        return l_info[tostring(id)]
    else
        local l_info = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[l_sellType]
        if not l_info then
            logError(StringEx.Format("[TradeMgr]未能找到{0}的限售信息@昭湘@小红", id))
            return nil
        end
        return l_info[tostring(id)]
    end
end

-- 获取期望价格和浮动比例
function GetExpectAndRange(itemId)
    local l_expectPrice = 0
    local l_range = 0
    local l_priceRow = TableUtil.GetExpectPriceTable().GetRowByItemID(itemId)
    if l_priceRow then
        l_range = l_priceRow.FloatRange
        for i = 0, l_priceRow.Price.Length - 1 do
            -- 默认值处理
            if i == 0 then
                l_expectPrice = l_priceRow.Price[i][1]
            end
            if l_priceRow.Price[i][0] == MPlayerInfo.ServerLevel then
                l_expectPrice = l_priceRow.Price[i][1]
                break
            end
        end
    end
    return l_expectPrice, l_range
end


-----------------------------------协议处理-----------------------------------
-- 获取商会信息
function SendGetTradeInfoReq()
    local l_msgId = Network.Define.Rpc.GetTradeInfo
    ---@type GetTradeInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetTradeInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 商会信息
function OnGetTradeInfoRsp(msg)
    ---@type GetTradeInfoRes
    local l_info = ParseProtoBufToTable("GetTradeInfoRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    local l_itemList = l_info.item_list
    for i = 1, #l_itemList do
        SetTradeInfo(l_itemList[i])
    end
    ServerLevel = l_info.server_level
    NextRefreshTime = -1
    local l_openList = l_info.mark_list
    for i = 1, #l_openList do
        local l_target = l_openList[i]
        local l_markId = l_target.mark_id
        local l_timeSec = l_target.open_time == 0 and 0 or MLuaClientHelper.GetTiks2NowSeconds(l_target.open_time)
        local l_openSec = MLuaCommonHelper.Int(l_timeSec)
        -- 取最小的刷新时间
        if l_openSec > 0 then
            if NextRefreshTime == -1 then
                NextRefreshTime = l_openSec
            else
                NextRefreshTime = math.min(NextRefreshTime, l_openSec)
            end
        end
        local l_timeDes = Common.TimeMgr.GetTimeTable(l_target.open_time)
        local l_openDes = StringEx.Format("{0:00}:{1:00}", l_timeDes.hour, l_timeDes.min)
        tradeData.SetOpenState(l_markId, { id = l_markId, isOpen = l_target.is_open, openTime = l_target.open_time, openSec = l_openSec, openDes = l_openDes })
    end

    SearchTradeMainId = nil
    SearchTradeSonId = nil
    if SearchTradeItemId then
        local l_item, l_mainId, l_sonId, l_itemId = GetIndexByItemId(SearchTradeItemId)
        if l_item then
            SearchTradeItemId = l_itemId
            SearchTradeMainId = l_mainId
            SearchTradeSonId = l_sonId
        end
    end

    EventDispatcher:Dispatch(REFRASH_TRADE_PANEL)
    isTradeInfoRequired = true
end

function OnBuySccess(id, num, price)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(tonumber(id))
    if l_itemRow == nil then
        return
    end
    if tostring(price) == "0" then
        return
    end
    local priceText= MNumberFormat.GetNumberFormat(tostring(price))
    local l_tips = StringEx.Format(Common.Utils.Lang("TRADE_BUY_SUC"), MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(id, num),
            priceText, MgrMgr:GetMgr("TipsMgr").GetItemIconTips(102))
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips, true)
end

function OnSellSccess(id, num, price)
    ---出售提示
    EventDispatcher:Dispatch(ON_BAG_ITEM_CHANGE, id, num)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(id)
    if l_itemRow == nil then
        return
    end
    if tostring(price) == "0" then
        return
    end
    local priceText= MNumberFormat.GetNumberFormat(tostring(price))
    local l_tips = StringEx.Format("{0} {1}, {2} {3} {4}",
            Common.Utils.Lang("Shop_Sell"), MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(id, num),
            Common.Utils.Lang("Chat_GetItem"), priceText, MgrMgr:GetMgr("TipsMgr").GetItemIconTips(102))
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
end

-- 商会变更信息ptc
function OnTradeInfoUpdateNotify(msg)
    ---@type TradeUpdateInfo
    local l_info = ParseProtoBufToTable("TradeUpdateInfo", msg)
    local l_itemList = l_info.item_list
    local l_delList = l_info.del_item_list
    if #l_itemList > 0 then
        for i = 1, #l_itemList do
            SetTradeInfo(l_itemList[i])
        end
    end
    if #l_delList > 0 then
        for i = 1, #l_delList do
            DeleteTradeInfo(l_delList[i])
        end
    end

    ServerLevel = l_info.server_level
    local l_openList = l_info.mark_list
    for i = 1, #l_openList do
        local l_target = l_openList[i]
        local l_markId = l_target.mark_id
        local l_timeSec = l_target.open_time == 0 and 0 or MLuaClientHelper.GetTiks2NowSeconds(l_target.open_time)
        local l_openSec = MLuaCommonHelper.Int(l_timeSec)
        local l_timeDes = Common.TimeMgr.GetTimeTable(l_target.open_time)
        local l_openDes = StringEx.Format("{0:00}:{1:00}", l_timeDes.hour, l_timeDes.min)
        tradeData.SetOpenState(l_markId, { id = l_markId, isOpen = l_target.is_open, openTime = l_target.open_time, openSec = l_openSec, openDes = l_openDes })
    end
end

-- 发送购买
function SendTradeBuyItemReq(notice, id, count, force ,totalCost ,isNotCheck)

    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin102,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin102,l_needNum,function ()
                SendTradeBuyItemReq(notice, id, count, force ,totalCost ,true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.TradeBuyItem
    ---@type TradeBuyItemArg
    local l_sendInfo = GetProtoBufSendTable("TradeBuyItemArg")
    l_sendInfo.item_id = id
    l_sendInfo.count = tostring(count)
    if not notice then
        l_sendInfo.force = force
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 购买
function OnTradeBuyItemRsp(msg, arg)
    ---@type TradeBuyItemRes
    local l_info = ParseProtoBufToTable("TradeBuyItemRes", msg)
    local l_error = l_info.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    local l_id = arg.item_id
    local l_count = arg.count
    local l_isNotice = false
    local l_itemInfo = tradeData.GetTradeInfo(l_id)
    if l_itemInfo then
        l_isNotice = l_itemInfo.isNotice
    end
    if l_isNotice then
        if l_errorNo ~= ErrorCode.ERR_SUCCESS then
            MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(
                StringEx.Format(Common.Utils.Lang("TRADE_PRE_BUY_SUCCESS"), MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(l_id, l_count)))
    else
        if l_errorNo ~= ErrorCode.ERR_SUCCESS then
            if l_errorNo ~= ErrorCode.ERR_TRADE_ITEM_SHORT_SUPPLY then
                MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)
            else
                EventDispatcher:Dispatch(FORCE_TO_BUY)
            end
            return
        end
        OnBuySccess(arg.item_id, arg.count, l_info.price)
        MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.ShopPurchaseComplete)
    end
end

---@return ItemData
function _getBagItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

-- 发送售卖
function SendTradeSellItemReq(id, uid, count, force)
    local l_msgId = Network.Define.Rpc.TradeSellItem
    ---@type TradeSellItemArg
    local l_sendInfo = GetProtoBufSendTable("TradeSellItemArg")
    l_sendInfo.item_id = id
    l_sendInfo.count = count
    l_sendInfo.force = force
    l_sendInfo.item_uuid = uid
    local l_target = _getBagItemByUID(uid)
    if l_target ~= nil and l_target.Price ~= nil then
        l_sendInfo.price = tostring(l_target.Price)
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 售卖
function OnTradeSellItemRsp(msg, arg)
    ---@type TradeSellItemRes
    local l_info = ParseProtoBufToTable("TradeSellItemRes", msg)
    if l_info.error_code ~= 0 then
        local l_s = Common.Functions.GetErrorCodeStr(l_info.error_code)
        if l_s ~= nil and l_s ~= "" and l_info.error_code ~= 939 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
        end
        if l_info.error_code == 939 then
            EventDispatcher:Dispatch(FORCE_TO_SELL)
        end
        return
    end
    OnSellSccess(arg.item_id, arg.count, l_info.price)
end

-- 关注
function SendTradeFollowItemReq(id, isfollow)
    local l_msgId = Network.Define.Rpc.TradeFollowItem
    ---@type TradeFollowItemArg
    local l_sendInfo = GetProtoBufSendTable("TradeFollowItemArg")
    l_sendInfo.item_id = id
    l_sendInfo.is_follow = isfollow
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnTradeFollowItemRsp(msg, arg)
    ---@type TradeFollowItemRes
    local l_info = ParseProtoBufToTable("TradeFollowItemRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if not arg.is_follow then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_NOTICE_FAILURE"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_NOTICE_SUCCESS"))
    end
    tradeData.SetTradeInfo(arg.item_id, { isFollow = arg.is_follow })
    EventDispatcher:Dispatch(ITEM_FOLLOW_CHANGED, arg.item_id, arg.is_follow)
end


-- 心跳协议
function SendTradeKeepAliveNotify()
    local l_msgId = Network.Define.Ptc.TradeKeepAliveNotify
    ---@type TradeKeepAliveInfo
    local l_sendInfo = GetProtoBufSendTable("TradeKeepAliveInfo")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function OnTradeItemStockChangeNtf(msg)
    ---@type TradeItemStockData
    local l_info = ParseProtoBufToTable("TradeItemStockData", msg)
    local l_itemId = l_info.item_id
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_itemId)
    if l_itemRow then
        UIMgr:DeActiveUI(UI.CtrlNames.ArenaOffer, true)
        UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
            ctrl:ShowContentCallBackWithoutCountdown(StringEx.Format(Common.Utils.Lang("TRADE_STOCK_NUMBER_UPDATE2"),
                    GetColorText(l_itemRow.ItemName, RoColorTag.Blue)), function()
                local l_ui = UIMgr:GetUI(UI.CtrlNames.Sweater)
                if l_ui then
                    UIMgr:DeActiveUI(UI.CtrlNames.Sweater, true)
                end
                MgrMgr:GetMgr("TradeMgr").l_itemID = l_itemId
                MgrMgr:GetMgr("TradeMgr").l_tradeItemStock = true
            end)
        end)
    end
end

return ModuleMgr.TradeMgr
