module("ModuleMgr.SweaterMgr", package.seeall)

-- 界面打开类型
ESweaterType = {
    Trade = "Trade",
    Stall = "Stall",
    Auction = "Auction"
}
-- 界面当前类型
LastSweaterType = ESweaterType.Trade

tradeMgr = MgrMgr:GetMgr("TradeMgr")
stallMgr = MgrMgr:GetMgr("StallMgr")


function OnLogout()
    LastSweaterType = ESweaterType.Trade
end


-- 来源跳转到出售;
function OpenSellSweater(type, id)
    if type == ESweaterType.Trade then
        tradeMgr.g_targetSellItemId = id
        tradeMgr.SearchTradeItemId = nil
        tradeMgr.IsBuyPanel = false
        tradeMgr.TradeFirstIn = false
    end
    if type == ESweaterType.Stall then
        stallMgr.g_targetSellItemId = id
        stallMgr.g_searchStallItemId = nil
        stallMgr.g_isBuyPanel = false
    end
    OpenSweater(type)
end

--来源跳转到购买;
function OpenBuySweater(sweaterType, id)
    if sweaterType == ESweaterType.Trade then
        local l_tradeInfo = tradeMgr.GetTradeInfo(id)
        if not l_tradeInfo then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_NOT_OPEN"))
            return
        end
        tradeMgr.g_targetSellItemId = nil
        tradeMgr.SearchTradeItemId = id
        tradeMgr.IsBuyPanel = true
        tradeMgr.TradeFirstIn = false
    end
    if sweaterType == ESweaterType.Stall then
        local l_target = stallMgr.g_tableItemInfo[id]
        if not l_target then
            logError("item not find@李韬,id:" .. tostring(id))
            return
        end
        local l_serverLevel = l_target.info.ServerLevelLimit
        if MPlayerInfo.ServerLevel < l_serverLevel then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("STALL_SERVER_LIMIT"), l_serverLevel))
            return
        end
        local l_index1 = l_target.info.Index1
        local l_indexInfo = TableUtil.GetStallIndexDescTable().GetRowByID(l_index1)
        if not l_indexInfo then
            logError("item type not find in stall@李韬,id:" .. tostring(id) .. ",index1:" .. tostring(l_index1))
            return
        end
        if MPlayerInfo.ServerLevel < l_indexInfo.ServerLevelLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("STALL_SERVER_LIMIT"), l_indexInfo.ServerLevelLimit))
            return
        end
        stallMgr.g_targetSellItemId = nil
        stallMgr.g_searchStallItemId = id
        stallMgr.g_isBuyPanel = true
    end
    OpenSweater(sweaterType)
end

-- 交易界面页签切换;
function OpenSweater(sweaterType)
    if sweaterType == ESweaterType.Trade then
        tradeMgr.SendGetTradeInfoReq()
    elseif sweaterType == ESweaterType.Stall then
        stallMgr.RequestStallInfo()
    end
    UIMgr:ActiveUI(UI.CtrlNames.Sweater, {openSweaterType = sweaterType})
end


return ModuleMgr.SweaterMgr