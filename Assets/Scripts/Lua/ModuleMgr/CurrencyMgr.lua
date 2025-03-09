---
--- Created by qixuanqi.
--- DateTime: 2018/1/31 16:20
---

require "Data/Model/PlayerInfoModel"


---@module ModuleMgr.CurrencyMgr
module("ModuleMgr.CurrencyMgr", package.seeall)

EXCHANGE_MONEY_SUCCESS = "EXCHANGE_MONEY_SUCCESS"

EventDispatcher = EventDispatcher.new()

eShowCurrencyType={Right=1,Middle=2}
eCurrentCointType={Coin101=1,Coin102=2}
CurrencyDisplay={103,102,101}
PositionX=nil
PositionY=nil
exchangeSuccessFunc = nil
local curWaitMessage = nil

ShowCurrencyType=eShowCurrencyType.Middle
CurrentCointType=eCurrentCointType.Coin101

function OnReconnected(reconnectData)
    curWaitMessage = nil
end

function OnLogout()
    curWaitMessage = nil
end

function ExchangeMoney(targetItemId,count)
    if curWaitMessage ~= nil then
        return
    end
    if count == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXCHANGE_ZERO"))
        return
    end
    curWaitMessage = Network.Define.Rpc.ExchangeMoney
    local l_msgId = Network.Define.Rpc.ExchangeMoney
    ---@type ExchangeMoneyArg
    local l_sendInfo = GetProtoBufSendTable("ExchangeMoneyArg")
    l_sendInfo.source_item_id  = MgrMgr:GetMgr("PropMgr").l_virProp.Coin103
    l_sendInfo.dest_item_id  = targetItemId
    l_sendInfo.counter  = count
    l_sendInfo.exchange_money_type = ExchangeMoneyType.ExchangeMoneyTypeDefault
    CommonUI.Dialog.ShowWaiting(nil,nil,5)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ExchangeMoneyWithFunction(targetItemId,count,onSuccessFunc)
    if curWaitMessage ~= nil then
        return
    end
    if count == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXCHANGE_ZERO"))
        return
    end
    curWaitMessage = Network.Define.Rpc.ExchangeMoney
	local l_msgId = Network.Define.Rpc.ExchangeMoney
	---@type ExchangeMoneyArg
	local l_sendInfo = GetProtoBufSendTable("ExchangeMoneyArg")
	l_sendInfo.source_item_id  = MgrMgr:GetMgr("PropMgr").l_virProp.Coin103
	l_sendInfo.dest_item_id  = targetItemId
    l_sendInfo.counter  = count
    l_sendInfo.exchange_money_type = ExchangeMoneyType.ExchangeMoneyTypeShortcut 
    CommonUI.Dialog.ShowWaiting(nil,nil,5)
	Network.Handler.SendRpc(l_msgId, l_sendInfo,{successFunc = onSuccessFunc})
end

local l_OnExchengSuccessArgType = nil
function OnExchangeMoneyRsp(msg,arg,addationData)
    curWaitMessage = nil
    l_OnExchengSuccessArgType = arg.exchange_money_type
    ---@type ExchangeMoneyRes
    local l_info = ParseProtoBufToTable("ExchangeMoneyRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_IN_PAYING then
            game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.ExchangeMoney, OnExchangeSuccess)
            if addationData then
                if addationData.successFunc then
                    SetExchangeSuccessFunc(addationData.successFunc)
                end
            end
            return
        end
        local l_s=Common.Functions.GetErrorCodeStr(l_info.result)
        if l_s~=nil and l_s~="" then
            CommonUI.Dialog.HideWaiting()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
        end
        return
    end
    if addationData then
        if addationData.successFunc then
            addationData.successFunc()
            SetExchangeSuccessFunc(addationData.successFunc)
        end
    end
    OnExchangeSuccess()
end

function RunExchangeSuccessFunc()
    if exchangeSuccessFunc then
        exchangeSuccessFunc()
        exchangeSuccessFunc = nil
    end
end

function SetExchangeSuccessFunc(func)
    if func then
        exchangeSuccessFunc = nil
        exchangeSuccessFunc = func
    end
end

function OnExchangeSuccess(msg)
    local l_globalData = MGlobalConfig:GetSequenceOrVectorInt("ExchangeDiamondMail")
    local l_isDefaultShowExchangeTips = false   --加号兑换是否弹Tips
    local l_isShortcuttShowExchangeTips = false --快捷兑换是否弹Tips
    for i = 0, l_globalData.Length - 1 do
        if i==0 and l_globalData[i] == 1 then
            l_isDefaultShowExchangeTips = true
        end
        if i==1 and l_globalData[i] == 1 then
            l_isShortcuttShowExchangeTips = true
        end
    end
    if l_OnExchengSuccessArgType and l_isDefaultShowExchangeTips and l_OnExchengSuccessArgType == ExchangeMoneyType.ExchangeMoneyTypeDefault then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXCHANGE_COIN_SUCCESS"))
        l_isShortcuttShowExchangeTips = false
    end
    if l_OnExchengSuccessArgType and l_isShortcuttShowExchangeTips and l_OnExchengSuccessArgType == ExchangeMoneyType.ExchangeMoneyTypeShortcut then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXCHANGE_COIN_SUCCESS"))
    end
    EventDispatcher:Dispatch(EXCHANGE_MONEY_SUCCESS)
end

function SetCurrencyDisplay(shopId,positionX,positionY)

    PositionX=positionX
    PositionY=positionY

    if shopId==nil then
        CurrencyDisplay={103,102,101}
    else
        local l_shop_row = TableUtil.GetShopTable().GetRowByShopId(shopId)
        CurrencyDisplay=Common.Functions.VectorToTable(l_shop_row.CurrencyDisplay)
    end
end

function SetCurrencyDisplayWithData(data)
    CurrencyDisplay=data
end

function ShowQuickExchangePanel(targetItemId,count,onSuccessFunc)
    if targetItemId == GameEnum.l_virProp.Coin103 or targetItemId == GameEnum.l_virProp.Coin104 or targetItemId == GameEnum.l_virProp.ReturnPoint then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COIN_NOT_ENOUGHT",TableUtil.GetItemTable().GetRowByItemID(targetItemId).ItemName))
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.CurrencyExch, function(ctrl)
        ctrl:ShowQuickExchange(targetItemId,tonumber(count),onSuccessFunc)
    end)
end

return ModuleMgr.CurrencyMgr