


module("ModuleMgr", package.seeall)

require "ModuleMgr/BasePayMgr"

local super = ModuleMgr.BasePayMgr
---@class ModuleMgr.MidasPayMgr
MidasPayMgr = class("MidasPayMgr", super)

-- 安卓支付Code
MidasPayMgr.EPayResultCode =
{
    PAYRESULT_ERROR = -1,       --支付流程失败
    PAYRESULT_SUCC = 0,         --支付流程成功
    PAYRESULT_CANCEL = 2,       --用户取消
}

-- 安卓支付状态
MidasPayMgr.EPayState =
{
    PAYSTATE_PAYUNKOWN = -1,
    PAYSTATE_PAYSUCC = 0,               --支付成功
    PAYSTATE_PAYCANCEL = 1,             --用户取消
    PAYSTATE_PAYERROR = 2,              --支付出错
}

-- MSDK token类型
eTokenType =
{
    eToken_QQ_Access = 1,
    eToken_QQ_Pay = 2,
    eToken_WX_Access = 3,
    eToken_WX_Code = 4,
    eToken_WX_Refresh = 5,
    eToken_Guest_Access = 6,
}

MidasPayMgr.MoneyRate = 10

MidasPayMgr.LogEnabled = false -- false:现网，无日志 true:沙箱，有日志


function MidasPayMgr:ctor()
    super.ctor(self)

    self.lastPayGoodsId = 0 -- 支付的商品ID
    self.lastPayGoodsPrice = 0 -- 支付的商品价格

    self.EventDispatcher:Add(self.EVENT_GET_REWARD_INFO, self.GetRewardInfoByName, self)
    self.EventDispatcher:Add(self.ON_EVENT_GET_REWARD_INFO, self.OnGetRewardInfoCallback, self)
    self.EventDispatcher:Add(self.ON_SDK_PAY_NEEDLOGIN_CALLBACK, self.NeedLoginCallback, self)
end

function MidasPayMgr:Init()

    log("MidasPayMgr:Init")

    local l_payParams = self:GetPayInitParams()
    if not l_payParams then
        log("none msdk params")
        return
    end

    local l_msgId = Network.Define.Ptc.PayParameterInfoNtf
    ---@type PayParameterInfo
    local l_sendInfo = GetProtoBufSendTable("PayParameterInfo")
    l_sendInfo.open_key = l_payParams.open_key
    l_sendInfo.session_id = l_payParams.session_id
    l_sendInfo.session_type = l_payParams.session_type
    l_sendInfo.pf = l_payParams.pf
    l_sendInfo.pf_key = l_payParams.pf_key
    -- 默认传游戏币id
    l_sendInfo.app_id = self:GetOfferId("buyGame")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)

    local l_ret = self:GetBaseJson()
    l_ret.logEnabled = self.LogEnabled
    MPay.PayInit(CJson.encode({json = CJson.encode(l_ret)}))

    if self.requestMpInfoTimer ~= nil then
        self.requestMpInfoTimer:Stop()
        self.requestMpInfoTimer = nil
    end

    self.requestMpInfoTimer = Timer.New(function()
        self:GetRewardInfoByName("PayGame")
    end, 5):Start()

    if self.LogEnabled then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("支付进入沙箱环境")
    end
end

function MidasPayMgr:OnReconnected(reconnectData)
    super.OnReconnected(self, reconnectData)
    self:NotifyUpdateMoney()
end

function MidasPayMgr:Purchase(productId)
    logGreen("[MidasPayMgr]Purchase productId: " .. tostring(productId))
    super.Purchase(self, productId)

    if not (next(self.purchaseJsonData)) then
        logError("self.purchaseJsonData is nil productId = " .. productId)
        return
    end
    local data = self.purchaseJsonData
    logGreen("[MidasPayMgr]Purchase " .. ToString(data))

    local arg = self:GetBaseJson()
    arg.price = data.amount * MidasPayMgr.MoneyRate
    MPay.PayGame(CJson.encode({json = CJson.encode(arg)}))
end

-- 传入服务器传回的道具url
function MidasPayMgr:PayGoods(msg)
    ---@type BuyGoodUrlData
    local l_info = ParseProtoBufToTable("BuyGoodUrlData", msg)

    local l_ret = self:GetBaseJson()
    l_ret.goodsTokenUrl = l_info.url
    l_ret.buyNum = "1"
    l_ret.bill_no = l_info.bill_no
    log("PayGoods", CJson.encode(l_ret))
    MPay.PayGoods(CJson.encode({json = CJson.encode(l_ret)}))
end

-- 获取营销活动
function MidasPayMgr:GetRewardInfoByName(name)

    name = name or "PayGame"

    local l_ret = self:GetBaseJson()
    l_ret.name = name
    MPay.GetRewardInfo(CJson.encode({json = CJson.encode(l_ret)}))

    log("GetRewardInfoByName", name)
end


-- 支付回调
function MidasPayMgr:OnSDKPay(json)
    logGreen("[MidasPayMgr]OnSDKPay json = " .. json)
    local data = CJson.decode(json)
    if data then
        if data.resultCode == self.EPayResultCode.PAYRESULT_SUCC then
            self:OnSDKPayed(data)
        else
            self:OnSDKPayFailed(data)
        end
    else
        self:OnSDKPayFailed()
    end
end

-- 请求服务器游戏币余额
function MidasPayMgr:OnSDKPayed(data)
    logGreen("[MidasPayMgr]OnSDKPayed data = " .. ToString(data))

    local l_msgId = Network.Define.Rpc.PayNotify
    ---@type PayNotifyArg
    local l_sendInfo = GetProtoBufSendTable("PayNotifyArg")
    l_sendInfo.param_type = PayParamType.PAY_PARAM_LIST

    -- MSDK登陆态参数
    local l_payParams = self:GetPayInitParams()
    if l_payParams then
        l_sendInfo.data.open_key = l_payParams.open_key
        l_sendInfo.data.session_id = l_payParams.session_id
        l_sendInfo.data.session_type = l_payParams.session_type
        l_sendInfo.data.pf = l_payParams.pf
        l_sendInfo.data.pf_key = l_payParams.pf_key
    end

    -- 根据不同的支付，获取OfferID
    l_sendInfo.data.app_id = self:GetOfferId(data.name)
    -- 游戏币
    if data.name == "buyGame" then
        l_sendInfo.param_id = ""
        l_sendInfo.amount = tonumber(data.realSaveNum)
        l_sendInfo.count = 0
    elseif data.name == "buyGoods" then
        l_sendInfo.param_id = ""
        l_sendInfo.amount = tonumber(data.realSaveNum)
        l_sendInfo.count = 0
    else
        logError("OnPaySuccess:对应支付接口未完善", data.name)
        -- return
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)

    local l_data = self:GetPaySuccessData()
    l_data.price = tonumber(data.realSaveNum)

    self.EventDispatcher:Dispatch(self.ON_SDK_PAY_SUCCESS, l_data)
    self:SubmitPayResultLog(true)
    super.OnSDKPayed(self, data)
end

function MidasPayMgr:OnSDKPayFailed(data)
    logGreen("[MidasPayMgr]OnSDKPayFailed")
    if data and data.resultCode then
        logGreen(ToString(data))
        if data.resultCode == self.EPayResultCode.PAYRESULT_CANCEL then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_CANCEL"))
        else
            if data.resultMsg and data.resultMsg ~= "" then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(data.resultMsg)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_ERROR"))
            end
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_ERROR"))
    end
    self.EventDispatcher:Dispatch(self.ON_SDK_PAY_FAILED)
    self:SubmitPayResultLog(false)
    super.OnSDKPayFailed(self, data)
end

-- 根据不同的支付请求，不同的平台返回不同的id
function MidasPayMgr:GetOfferId(name)

    if name == "buyGame" then
        return MGameContext.IsAndroid and "1450015906" or "1450016079"
    elseif name == "buyGoods" then
        return MGameContext.IsAndroid and "1450016082" or "1450016083"
    else
        logError("GetOfferId fail, 对应类型接口未实现", name)
    end
end

-- 所有的请求都必须带上zoneId
function MidasPayMgr:GetBaseJson()
    local l_ret = {}
    l_ret.zoneId = self:GetGateServerId()

    return l_ret
end

function MidasPayMgr:NotifyUpdateMoney()

    local l_msgId = Network.Define.Rpc.PayNotify
    ---@type PayNotifyArg
    local l_sendInfo = GetProtoBufSendTable("PayNotifyArg")
    l_sendInfo.param_type = PayParamType.PAY_PARAM_LIST

    -- MSDK登陆态参数
    local l_payParams = self:GetPayInitParams()
    if l_payParams then
        l_sendInfo.data.open_key = l_payParams.open_key
        l_sendInfo.data.session_id = l_payParams.session_id
        l_sendInfo.data.session_type = l_payParams.session_type
        l_sendInfo.data.pf = l_payParams.pf
        l_sendInfo.data.pf_key = l_payParams.pf_key
    else
        return
    end

    -- 根据不同的支付，获取OfferID
    l_sendInfo.data.app_id = self:GetOfferId("buyGame")
    l_sendInfo.param_id = ""
    l_sendInfo.amount = 0
    l_sendInfo.count = 0

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end


-- 相关参数参看  https://wiki.midas.qq.com/post/index/1/29/89/0
-- -- 营销活动回调
function MidasPayMgr:OnGetRewardInfoCallback(str)

    if not str or type(str) ~= 'string' then
        logError("OnGetRewardInfoCallback error, 参数错误", str)
        return
    end

    local data = CJson.decode(str)
    if not data then
        logError("OnRewardCallback error, 参数错误", str)
        return
    end

    if data.flag ~= "Success" then
        logError("OnGetRewardInfoCallback fail")
        return
    end

    local l_result = data.result
    if not l_result then
        logError("OnGetRewardInfoCallback fail, no result")
        return
    end

    local l_info = CJson.decode(l_result)
    if l_info.ret ~= 0 then
        logError("OnGetRewardInfoCallback ret:", l_info.ret)
        return
    end

    l_rewardinfo = l_rewardinfo or {}
    l_rewardinfo[data.name] = {}

    local l_first = l_info.first_save_flag
    local l_mpinfo = l_info.mp_info

    l_rewardinfo[data.name].mpinfo = table.ro_deepCopy(l_info.mp_info)
    l_rewardinfo[data.name].first = tonumber(l_first) == 1

    self.EventDispatcher:Dispatch(self.ON_REWARD_INFO, data.name)
end

-- OnGetRewardInfoCallback("{\"ret\" : 0,\"list\" : \"[100,200,500,1000]\",\"rate\" : 10,\"firstsave_present_count\" : 0,\"present_level\" : \"[10,5,20,6]\",\"begin_time\" : \"\",\"end_time\" : \"\",\"mp_info\" : {\"utp_mpinfo\" : [{\"num\" : \"10\",\"send_rate\" : \"0\",\"send_num\" : \"5\",\"send_type\" : \"2\",\"send_ext\" : \"\",\"ex_send\" : []},{\"num\" : \"20\",\"send_rate\" : \"0\",\"send_num\" : \"6\",\"send_type\" : \"2\",\"send_ext\" : \"\",\"ex_send\" : []}],\"utp_mpinfo_detail\" : {\"rank_info\" : [{\"num\" : \"10\",\"send_type\" : \"2\",\"send_rate\" : \"0\",\"send_num\" : \"5\",\"send_ext\" : \"\",\"ex_send\" : []},{\"num\" : \"20\",\"send_type\" : \"2\",\"send_rate\" : \"0\",\"send_num\" : \"6\",\"send_ext\" : \"\",\"ex_send\" : []}],\"range_info\" : [{\"num\" : \"10\",\"coin\" : [{\"send_type\" : \"2\",\"send_num\" : \"5\"}],\"send_ext\" : \"\",\"ex_send\" : []},{\"num\" : \"20\",\"coin\" : [{\"send_type\" : \"2\",\"send_num\" : \"6\"}],\"send_ext\" : \"\",\"ex_send\" : []}]},\"utp_mpinfo_ex\" : {\"title\" : \"测试满赠活动\",\"type\" : \"\"},\"mall_url\" : \"\",\"result_url\" : \"\",\"actset_id\" : \"DRM000000000000001\",\"mpinfo_ex\" : {\"title\" : \"\",\"title_url\" : \"\"}},\"product_list\" : [],\"mall_url\" : \"\",\"result_url\" : \"\",\"first_save_flag\" : 0,\"support_pc_mp\" : \"0\",\"usr_wxcommid\" : \"\",\"now\" : \"1541857322\"}")

function MidasPayMgr:GetRewardInfo(name)

    if not l_rewardinfo then
        return
    end

    return l_rewardinfo[name]
end

-- 上报支付结果,清理临时变量
function MidasPayMgr:SubmitPayResultLog(success)

    local l_msgId = Network.Define.Ptc.PayBuyGoodsNtf
    ---@type PayBuyGoodsData
    local l_sendInfo = GetProtoBufSendTable("PayBuyGoodsData")
    l_sendInfo.good_id = self.lastPayGoodsId
    l_sendInfo.price = self.lastPayGoodsPrice
    l_sendInfo.recharge_num = self.lastPayGoodsPrice
    l_sendInfo.result = success and 0 or 1

    Network.Handler.SendPtc(l_msgId, l_sendInfo)

    self.lastPayGoodsId = 0
    self.lastPayGoodsPrice = 0
end

 -- 获取支付参数
 function MidasPayMgr:GetPayInitParams()
     local l_loginret = MLogin.GetLoginData()
     if not l_loginret then
         logError("未找到登录信息！！！！！请检查MSDK")
         return
     end

     local l_result = {}
     if l_loginret.platform == EPlatform.ePlatform_QQ then
         l_result["open_key"] = l_loginret:GetTokenByType(eTokenType.eToken_QQ_Pay)
         l_result["session_id"] = "openid"
         l_result["session_type"] = "kp_actoken"
     elseif l_loginret.platform == EPlatform.ePlatform_Weixin then
         l_result["open_key"] = l_loginret:GetTokenByType(eTokenType.eToken_WX_Access)
         l_result["session_id"] = "hy_gameid"
         l_result["session_type"] = "wc_actoken"
     end
     l_result["pf"] = l_loginret.pf
     l_result["pf_key"] = l_loginret.pf_key

     return l_result
 end

return MidasPayMgr
