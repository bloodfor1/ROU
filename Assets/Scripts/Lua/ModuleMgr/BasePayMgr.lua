

module("ModuleMgr", package.seeall)

BasePayMgr = class("BasePayMgr")
BasePayMgr.MoneyRate = 10
BasePayMgr.LogEnabled = true

BasePayMgr.PAY_GAME = "PayGame"
BasePayMgr.PAY_GOODS = "PayGoods"

BasePayMgr.EventDispatcher = EventDispatcher.new()

BasePayMgr.EVENT_GET_REWARD_INFO = "EVENT_GET_REWARD_INFO"
BasePayMgr.ON_EVENT_GET_REWARD_INFO = "ON_EVENT_GET_REWARD_INFO"
BasePayMgr.ON_SDK_PAY_NEEDLOGIN_CALLBACK = "ON_SDK_PAY_NEEDLOGIN_CALLBACK"

BasePayMgr.ON_REWARD_INFO = "ON_REWARD_INFO"
BasePayMgr.ON_SDK_PAY_SUCCESS = "ON_SDK_PAY_SUCCESS"
BasePayMgr.ON_SDK_PAY_FAILED = "ON_SDK_PAY_FAILED"
BasePayMgr.ON_BUY_SUCCESS = "ON_BUY_SUCCESS"

local PayNtfReasons = {
    Success = 0,
    Fail = 1,
    TimeOut = 2,
}

function BasePayMgr:ctor()
    logGreen("[BasePayMgr]ctor")
    self.protoCallbackTimer = {}
    self.purchaseJsonData = {}      -- 购买商品数据
end

function BasePayMgr:Init()
    logGreen("[BasePayMgr]Init")
    local l_msgId = Network.Define.Ptc.PayParameterInfoNtf
    ---@type PayParameterInfo
    local l_sendInfo = GetProtoBufSendTable("PayParameterInfo")
    l_sendInfo.open_key = ""
    l_sendInfo.session_id = ""
    l_sendInfo.session_type = ""
    l_sendInfo.pf = ""
    l_sendInfo.pf_key = ""
    l_sendInfo.app_id = ""
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function BasePayMgr:OnReconnected(reconnectData)
    logGreen("[BasePayMgr]OnReconnected")
    game:GetPayMgr():Init()
    game:GetPayMgr():ClearProtoCallback()
end

function BasePayMgr:OnLogout()
    logGreen("[BasePayMgr]OnLogout")
    game:GetPayMgr():ClearProtoCallback()
    CommonUI.Dialog.HidePaying()
end

-- 游戏服务器大区id,游戏不分大区则默认zoneId ="1"。
-- 如果应用选择支持角色(不同角色的游戏币不互通)，则角色ID接在分区ID号后用"_"连接(单个分区最多支持60个角色)，例如zoneId=1_roleid
function BasePayMgr:GetGateServerId()
    logGreen("[BasePayMgr]GetGateServerId")
    local l_server_id = game:GetAuthMgr().AuthData.GetCurGateServer().serverid
    return StringEx.Format("{0}_{1}", l_server_id, MPlayerInfo.UID:tostring())
end

function BasePayMgr:PayGoods(msg)
    logGreen("[BasePayMgr]PayGoods")
end

function BasePayMgr:Purchase(productId)
    logGreen("[BasePayMgr]Purchase productId: " .. tostring(productId))
    local l_paymentRow = TableUtil.GetPaymentTable().GetRowByProductId(productId, true)
    if l_paymentRow then
        self.purchaseJsonData = {
            product_id = productId,
            product_name = l_paymentRow.ProductName,
            amount = tostring(l_paymentRow.Price),
            currency = l_paymentRow.Currency,
        }
        CommonUI.Dialog.ShowPaying()
    else
        self.purchaseJsonData = {}
        logError("PaymentTable not have productId " .. productId)
    end
end

function BasePayMgr:OnSDKPayed(data)
    logGreen("[BasePayMgr]OnSDKPayed")
    CommonUI.Dialog.HidePaying()
end

function BasePayMgr:OnSDKPayFailed(data)
    logGreen("[BasePayMgr]OnSDKPayFailed")
    CommonUI.Dialog.HidePaying()
end

-- 上报支付结果,清理临时变量
function BasePayMgr:SubmitPayResultLog(success)
    logGreen("[BasePayMgr]SubmitPayResultLog")
end

function BasePayMgr:OnPaySuccessNotify(msg)
    logGreen("[BasePayMgr]OnPaySuccessNotify")
    ---@type PayNotifyRes
    local l_info = ParseProtoBufToTable("PayNotifyRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
end

function BasePayMgr:OnMidasExceptionNtf(msg)
    logGreen("[BasePayMgr]OnMidasExceptionNtf")
    ---@type MidasExceptionInfo
    local l_info = ParseProtoBufToTable("MidasExceptionInfo", msg)
    logError("OnMidasExceptionNtf", l_info)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

function BasePayMgr:OnPayTimeOut(protoId)
    logGreen("[BasePayMgr]OnPayTimeOut")

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NET_RESPONSE_TIMEOUT"))

    self:CloseTimer(protoId, PayNtfReasons.TimeOut)

    CommonUI.Dialog.HideWaiting()
end

function BasePayMgr:RegisterPayResultCallback(protoId, callback, failCallback, timeoutCallback)
    logGreen("[BasePayMgr]RegisterPayResultCallback")

    self:CloseTimer(protoId)

    local l_tmp = {}
    l_tmp.callback = callback
    l_tmp.failCallback = failCallback
    l_tmp.timeoutCallback = timeoutCallback
    l_tmp.timer = Timer.New(function()
        self:OnPayTimeOut(protoId)
    end, 5)
    l_tmp.timer:Start()

    self.protoCallbackTimer[protoId] = l_tmp

    CommonUI.Dialog.ShowWaiting()
end

function BasePayMgr:ClearProtoCallback()
    logGreen("[BasePayMgr]ClearProtoCallback")

    self:CloseTimer(nil, PayNtfReasons.TimeOut)

    CommonUI.Dialog.HideWaiting()
end

function BasePayMgr:CallbackByReason(tbl, reason)

    if not tbl then return end

    local l_cb
    if reason == PayNtfReasons.Success then
        l_cb = tbl.callback
        tbl.callback = nil
    elseif reason == PayNtfReasons.Fail then
        l_cb = tbl.failCallback
        tbl.failCallback = nil
    else
        l_cb = tbl.timeoutCallback
        tbl.timeoutCallback = nil
    end

    if l_cb then
        l_cb()
    end
end

function BasePayMgr:CloseTimer(protoId, reason)
    logGreen("[BasePayMgr]CloseTimer")

    if self.protoCallbackTimer[protoId] then
        if self.protoCallbackTimer[protoId].timer then
            self.protoCallbackTimer[protoId].timer:Stop()
        end
        self:CallbackByReason(self.protoCallbackTimer[protoId], reason)
        self.protoCallbackTimer[protoId] = nil
    else
        for k, v in pairs(self.protoCallbackTimer) do
            if v.timer then
                v.timer:Stop()
            end
            self:CallbackByReason(v, reason)
        end
        self.protoCallbackTimer = {}
    end
end

function BasePayMgr:HandlePayMoneySuccess(msg)
    
    CommonUI.Dialog.HideWaiting()

    logGreen("[BasePayMgr]HandlePayMoneySuccess")
    ---@type PayMoneySuccessData 
    local l_info = ParseProtoBufToTable("PayMoneySuccessData", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        self:CloseTimer(l_protoId, PayNtfReasons.Fail)
        return
    end

    logGreen("HandlePayMoneySuccess", l_info.rpc_type)
    local l_protoId = l_info.rpc_type
    if self.protoCallbackTimer[l_protoId] then
        local l_callback = self.protoCallbackTimer[l_protoId].callback
        self.protoCallbackTimer[l_protoId].callback = nil
        if l_callback then
            l_callback()
        end
    else
        logWarn("HandlePayMoneySuccess error", self.protoCallbackTimer and self.protoCallbackTimer.protoId or 0, l_info.rpc_type)
    end

    self:CloseTimer(l_protoId, PayNtfReasons.Success)

    self.EventDispatcher:Dispatch(self.ON_BUY_SUCCESS)
    
    MgrMgr:GetMgr("CurrencyMgr").RunExchangeSuccessFunc()

end

function BasePayMgr:OnPayMoneySuccessFromMs(msg)
    logGreen("[BasePayMgr]OnPayMoneySuccessFromMs")

    self:HandlePayMoneySuccess(msg)
    
end

function BasePayMgr:OnPayMoneySuccessFromGs(msg)
    logGreen("[BasePayMgr]OnPayMoneySuccessFromGs")

    self:HandlePayMoneySuccess(msg)
end

function BasePayMgr:FireEvent(event, ...)
    self.EventDispatcher:Dispatch(event, ...)
end

function BasePayMgr:GetRewardInfo()
    logGreen("[BasePayMgr]GetRewardInfo")
end

function BasePayMgr:GetPayInitParams()
    logGreen("[BasePayMgr]GetPayInitParams")
end

-- 原生层token失效，需要重新登录
function BasePayMgr:NeedLoginCallback(data)
    logGreen("[BasePayMgr]NeedLoginCallback")
    local l_timer = Timer.New(function()
        game:GetAuthMgr():LogoutToAccount()
    end, 0.5)
    l_timer:Start()
end

function BasePayMgr:GetPaySuccessData()

    local l_data = {
        product_id = "",
        product_name = "",
        currency = "",
        amount = 0,
        orderid = "",
    }

    return l_data
end

function BasePayMgr:GetPaymentCurrencyFormat(row)
    local l_priceStr = Common.Functions.NumberFormat(row.Price, ",")

    local l_curArea = MLuaCommonHelper.Enum2Int(MGameContext.CurrentChannel)
    local l_row = TableUtil.GetPaymentSignalTable().GetRowByArea(l_curArea)
    return StringEx.Format(l_row.Format, l_row.Signal, l_priceStr)
end

function BasePayMgr:GetPaymentCurrencyFormatByProductId(productId)

    local l_row = TableUtil.GetPaymentTable().GetRowByProductId(productId)

    return self:GetPaymentCurrencyFormat(l_row)
end

function BasePayMgr:GetPaymentCurrencyFormatByProductName(productName)

   local l_row = TableUtil.GetPaymentTable().GetRowByProductName(productName)

    return self:GetPaymentCurrencyFormat(l_row) 
end

function BasePayMgr:CheckMatchPlatform(p1)

	if p1 == 0 then
		return true
	end

	if p1 == 1 then
		return g_Globals.IsGooglePlay
	end

	if p1 == 2 then
		return g_Globals.IsAppStore
	end

    if p1 == 3 then
        return g_Globals.IsOneStore
    end

	return false
end

function BasePayMgr:IsPaymentIDMatched(paymentId)
    local l_payRow = TableUtil.GetPaymentTable().GetRowByProductId(paymentId)
    if not l_payRow then return false end

    local l_curArea = MLuaCommonHelper.Enum2Int(MGameContext.CurrentChannel)
    return l_curArea == l_payRow.Area and self:CheckMatchPlatform(l_payRow.Platform)
end

--根据策划配置的PaymentKey得到当前平台的实际支付ProductId
function BasePayMgr:GetRealProductId(key)
    local l_globalePayRow = TableUtil.GetPayGlobalTable().GetRowByPayGlobalKey(key)
    if l_globalePayRow then
        local paymentIdTb = Common.Functions.VectorToTable(l_globalePayRow.Value)
        for i = 1, #paymentIdTb do
            local state = self:IsPaymentIDMatched(tonumber(paymentIdTb[i]))
            if state then
                return paymentIdTb[i]
            end
        end
    else
        logError("策划查一下PaymentTable配置 没有找到符合当前平台的支付ID")
    end
    return nil
end

return BasePayMgr