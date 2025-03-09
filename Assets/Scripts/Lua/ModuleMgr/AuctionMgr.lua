---@module ModuleMgr.AuctionMgr
module("ModuleMgr.AuctionMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
EEventType = {
    BlackShopItemPriceRefresh = 1,
    AuctionItemRefresh = 2,
    AuctionItemFollowRefresh = 3,
    BilledItemRefresh = 4,
    AuctionItemUpdateList = 5,
}


priceCallback = nil

---@param itemData ItemData
function GetBlackShopSellPrice(itemData, priceCallbackArg, notRequestBlackPrice)
    local l_price, l_needRequest = DataMgr:GetData("AuctionData").GetBlackShopSellPrice(itemData)
    if l_needRequest and not notRequestBlackPrice then
        local l_itemInfo = GetTableRowByItemId(itemData.TID)
        local l_sendInfo = GetProtoBufSendTable("GetBlackMarketItemPriceArg")
        l_sendInfo.auction_ids = {l_itemInfo.tableInfo.AuctionID}
        priceCallback = priceCallbackArg
        Network.Handler.SendRpc(Network.Define.Rpc.GetBlackMarketItemPrice, l_sendInfo)
    else
        if priceCallbackArg then
            priceCallbackArg(l_price)
        end
    end
    return l_price
end


-- 协议
function OnGetBlackMarketItemPrice(msg)
    local l_info = ParseProtoBufToTable("GetBlackMarketItemPriceRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if priceCallback and l_info.item_price[1] then
        priceCallback(l_info.item_price[1].price)
        priceCallback = nil
    end
    for i = 1, #l_info.item_price do
        local l_auctionRow = TableUtil.GetAuctionTable().GetRowByAuctionID(l_info.item_price[i].acution_id)
        if l_auctionRow then
            SetServerSellPrice(l_auctionRow.ItemID, l_info.item_price[i].price)
        end
    end
    EventDispatcher:Dispatch(EEventType.BlackShopItemPriceRefresh)
end

-- 心跳协议
function AuctionKeepAliveNotify()
    local l_msgId = Network.Define.Ptc.AuctionKeepAliveNotify
    ---@type AuctionKeepAliveNotifyData
    local l_sendInfo = GetProtoBufSendTable("AuctionKeepAliveNotifyData")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function GetAuctionInfo()
    local l_sendInfo = GetProtoBufSendTable("GetAuctionInfoArg")
    Network.Handler.SendRpc(Network.Define.Rpc.GetAuctionInfo, l_sendInfo)

    EventDispatcher:Dispatch(EEventType.AuctionItemRefresh)
end

function OnGetAuctionInfo(msg)
    local l_info = ParseProtoBufToTable("GetAuctionInfoRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
    -- 清空之前的数据
    ClearAuctionItem()
    for _, v in ipairs(l_info.auction_item_info) do
        -- logError(ToString(v))
        UpdateAuctionItem({uid = v.item_uid,
                           auctionId = v.auction_id,
                           count = v.count,
                           isInAuction = v.is_in_auction,
                           curBidPrice = v.cur_bib_price,
                           myBidPrice = v.my_bib_price,
                           isInit = v.is_init,
                           endTimeStamp = v.end_auction_time,
                           billState = v.bill_state,
        }, v.bill_state == AuctionBillState.kAuctionBillStateBibFinished)
    end
    for _, v in ipairs(l_info.follow_item_list) do
        UpdateFollow(v, true)
    end

    EventDispatcher:Dispatch(EEventType.AuctionItemRefresh)
end

function OnAuctionItemChangeNotify(msg)
    local l_info = ParseProtoBufToTable("AuctionItemPbNotify", msg)
    local l_isAddOrRemove = false
    local l_updateDatas = {}
    for _, v in ipairs(l_info.item_infos) do
        --logError(ToString(v))
        local l_auctionItem = GetAuctionItemByUid(v.item_uid)
        if not l_auctionItem or v.bill_state == AuctionBillState.kAuctionBillStateBibFinished then
            l_isAddOrRemove = true
        else
            table.insert(l_updateDatas, l_auctionItem)
        end
        UpdateAuctionItem({uid = v.item_uid,
                           auctionId = v.auction_id,
                           count = v.count,
                           isInAction = v.is_in_auction,
                           curBidPrice = v.cur_bib_price,
                           myBidPrice = v.my_bib_price,
                           isInit = v.is_init,
                           endTimeStamp = v.end_auction_time,
                           billState = v.bill_state,
        }, v.bill_state == AuctionBillState.kAuctionBillStateBibFinished)
    end

    if l_isAddOrRemove then
        EventDispatcher:Dispatch(EEventType.AuctionItemRefresh)
    else
        EventDispatcher:Dispatch(EEventType.AuctionItemUpdateList, l_updateDatas)
    end

end

function AuctionFollowItem(itemId, isFollow)
    local l_sendInfo = GetProtoBufSendTable("AuctionFollowItemArg")
    l_sendInfo.item_id = itemId
    l_sendInfo.is_follow = isFollow
    Network.Handler.SendRpc(Network.Define.Rpc.AuctionFollowItem, l_sendInfo)
end

function OnAuctionFollowItem(msg, sendArg)
    local l_info = ParseProtoBufToTable("AuctionFollowItemRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
    UpdateFollow(sendArg.item_id, sendArg.is_follow)
    if sendArg.is_follow then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TRADE_NOTICE_SUCCESS"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TRADE_NOTICE_FAILURE"))
    end

    EventDispatcher:Dispatch(EEventType.AuctionItemFollowRefresh, sendArg.item_id)
end

function AuctionItemBid(uid, isAuto, price)
    local l_passTime = Common.TimeMgr.GetNowTimestamp() - lastBidTimestamp
    if l_passTime < bidCd then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUCTION_BID_CD", bidCd - l_passTime))
    end

    local l_sendInfo = GetProtoBufSendTable("AuctionItemBibArg")
    l_sendInfo.item_uid = uid
    l_sendInfo.is_auto_bib = isAuto
    l_sendInfo.bib_price = price
    Network.Handler.SendRpc(Network.Define.Rpc.AuctionItemBib, l_sendInfo)
end

function OnAuctionItemBib(msg)
    local l_info = ParseProtoBufToTable("AuctionItemBibRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    EventDispatcher:Dispatch(EEventType.BilledItemRefresh)
    MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.AuctionPurchaseComplete)
end

function AuctionBillCancel(uid)
    local l_sendInfo = GetProtoBufSendTable("AuctionBillCancelArg")
    l_sendInfo.item_uid = uid
    Network.Handler.SendRpc(Network.Define.Rpc.AuctionBillCancel, l_sendInfo)
end

function OnAuctionBillCancel(msg)
    local l_info = ParseProtoBufToTable("AuctionBillCancelRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    EventDispatcher:Dispatch(EEventType.BilledItemRefresh)
end

return ModuleMgr.AuctionMgr