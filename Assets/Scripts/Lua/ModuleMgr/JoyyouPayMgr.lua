module("ModuleMgr", package.seeall)

require "ModuleMgr/BasePayMgr"

local super = ModuleMgr.BasePayMgr
---@class ModuleMgr.JoyyouPayMgr
JoyyouPayMgr = class("JoyyouPayMgr", super)

local l_testUrl = "https://ou-common-authapi-ready.huanle.com/test-pay-create-binzai/"
local l_tryReVerifyPurchaseTimes = 0       -- 支付成功，消耗失败，当前尝试次数
local l_ReVerifyPurchaseTotalTimes = 5     -- 尝试总次数

function JoyyouPayMgr:ctor()
    logGreen("[JoyyouPayMgr]ctor")
    super.ctor(self)
    self.timer = nil
end

function JoyyouPayMgr:Init()
    logGreen("[JoyyouPayMgr]Init")
    super.Init(self)
end

function JoyyouPayMgr:OnReconnected(reconnectData)
    logGreen("[JoyyouPayMgr]OnReconnected")
    -- onestore渠道断线重连走单独消耗流程
    if not g_Globals.IsOneStore then
        MPay.ReVerifyPurchase()
    else
        -- 重新连接onestore服务器 查询&&补单
        MPay.ReConnect()
    end
    super.OnReconnected(self, reconnectData)
end

function JoyyouPayMgr:Purchase(productId)
    logGreen("[JoyyouPayMgr]Purchase productId: " .. tostring(productId))
    -- 游客登录不能支付
    if game:GetAuthMgr().AuthData.GetCurLoginType() == GameEnum.EJoyyouLoginType.JoyyouGuest then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Tourist_Can_Not_Pay_Tip"), function()
            MgrMgr:GetMgr("BindAccountMgr").LogoutToGameOpenBindAccountUI()
        end)
        return
    end

    super.Purchase(self, productId)

    if not (next(self.purchaseJsonData)) then
        logError("self.purchaseJsonData is nil productId = " .. productId)
        return
    end

    local data = self.purchaseJsonData
    logGreen("[JoyyouPayMgr]Purchase " .. ToString(data))
    local msgId = Network.Define.Ptc.PaySDKCreateOrder
    ---@type PaySDKCreateOrderData
    local sendInfo = GetProtoBufSendTable("PaySDKCreateOrderData")
    if g_Globals.IsGooglePlay then
        sendInfo.pay_type = "google"
        sendInfo.package_code = "ro-kr-android"
    elseif g_Globals.IsAppStore then
        sendInfo.pay_type = "apple"
        sendInfo.package_code = "ro-kr-ios"
    elseif g_Globals.IsOneStore then
        sendInfo.pay_type = "oneStore"
        sendInfo.package_code = "ro-kr-android"
    end
    sendInfo.product_name = data.product_name
    sendInfo.device_id = MPay.GetDeviceId()
    local jsonDataExt = {
        role_name = MPlayerInfo.Name
    }
    sendInfo.ext = CJson.encode(jsonDataExt)
    sendInfo.lang_code = GameEnum.GameLanguage2TechnologyCenter[tostring(MGameContext.CurrentLanguage)]
    sendInfo.game_code = "ro"
    logGreen(ToString(sendInfo))
    Network.Handler.SendPtc(msgId, sendInfo)
end

function JoyyouPayMgr:OnPaySDKOrderResultData(msg)
    logGreen("[JoyyouPayMgr]OnPaySDKOrderResultData")
    ---@type PaySDKOrderResultData
    local l_info = ParseProtoBufToTable("PaySDKOrderResultData", msg)
    logGreen(ToString(l_info))
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_FAILED then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PAY_CREATE_ORDER_ERROR"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
        super.OnSDKPayFailed(self)
    else
        if MGameContext.IsAndroid or MGameContext.IsIOS then
            l_tryReVerifyPurchaseTimes = 0  -- 发起sdk支付请求 重置次数
            local json = {
                productName = self.purchaseJsonData.product_name,
                orderid = l_info.order_id,
            }
            MPay.Purchase(CJson.encode({json = CJson.encode(json)}))
        else
            local l_testUrl = l_testUrl .. "?order_id="..l_info.order_id.."&pay_type="
            log(l_testUrl)
            HttpTask.Create(l_testUrl):TimeOut(5000):GetResponseAynsc(function(res, str)
                logGreen("[GetLoginSvrInfo]res={0}, json={1}", res, str)
                if res == HttpResult.OK then
                    local l_jsonData = CJson.decode(str)
                    log(ToString(l_jsonData))
                    local arg = {}
                    if l_jsonData["code"] == 200 then
                        arg = {
                            result = GameEnum.JoyyouSDKResult.SUCCESS,
                            orderid = l_info.order_id
                        }
                    else
                        arg = {
                            result = GameEnum.JoyyouSDKResult.ERROR,
                            msg = str,
                        }
                    end
                    self:OnSDKPay(CJson.encode(arg))
                end
            end)
        end
    end
end

-- 支付回调
function JoyyouPayMgr:OnSDKPay(json)
    logGreen("[JoyyouPayMgr]OnSDKPay json = " .. json)
    local data = CJson.decode(json)
    if data and data.result then
        if data.result == GameEnum.JoyyouSDKResult.SUCCESS then
            self:OnSDKPayed(data)
        else
            self:OnSDKPayFailed(data)
        end
    else
        self:OnSDKPayFailed()
    end
end

function JoyyouPayMgr:OnSDKPayed(data)
    logGreen("[JoyyouPayMgr]OnSDKPayed data = " .. ToString(data))

    local l_data = self:GetPaySuccessData()
    l_data.product_id = self.purchaseJsonData.product_id
    l_data.product_name = self.purchaseJsonData.product_name
    l_data.amount = self.purchaseJsonData.amount
    l_data.currency = self.purchaseJsonData.currency
    l_data.orderid = data.orderid
    self.EventDispatcher:Dispatch(self.ON_SDK_PAY_SUCCESS, l_data)
    super.OnSDKPayed(self, data)

    MTracker.TrackPurchaseCpmplete(CJson.encode({
        tracker_event = GameEnum.AdjustTrackerEvent.PurchaseEvent,
        json = CJson.encode({
            amount = self.purchaseJsonData.amount,
            currency = self.purchaseJsonData.currency,
            orderid = data.orderid,
        }),
    }))
end

function JoyyouPayMgr:OnSDKPayFailed(data)
    logGreen("[JoyyouPayMgr]OnSDKPayFailed")
    if data and data.result then
        logGreen(ToString(data))
        if data.result == GameEnum.JoyyouSDKResult.VERIFY_PURCHASE_ERRO then
            if self.timer then
                Timer.Stop(self.timer)
                self.timer = nil
            end
            logGreen("JoyyouPayMgr start timer ReVerifyPurchase l_tryReVerifyPurchaseTimes = " .. l_tryReVerifyPurchaseTimes)
            if l_tryReVerifyPurchaseTimes <= l_ReVerifyPurchaseTotalTimes then
                self.timer = Timer.New(function()
                    l_tryReVerifyPurchaseTimes = l_tryReVerifyPurchaseTimes + 1
                    MPay.ReVerifyPurchase()
                end, 2)
                self.timer:Start()
                return --遮罩不关闭
            else
                l_tryReVerifyPurchaseTimes = 0
                logGreen("JoyyouPayMgr ReVerifyPurchase TimeOut")
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NET_RESPONSE_TIMEOUT"))
            end
        elseif data.result == GameEnum.JoyyouSDKResult.ONESTORE_NEED_LOGIN then
            CommonUI.Dialog.ShowOKDlg(true, Lang("TIP"), Lang("ONESTORE_PAY_NEED_LOGIN"))
        elseif data.result == GameEnum.JoyyouSDKResult.CANCER then
            if data.msg and data.msg ~= "" then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(data.msg)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_CANCEL"))
            end
        else
            if data.msg and data.msg ~= "" then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(data.msg)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_ERROR"))
            end
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PAY_ERROR"))
    end
    self.EventDispatcher:Dispatch(self.ON_SDK_PAY_FAILED)
    super.OnSDKPayFailed(self, data)
end

-- 以下是测试函数
--game:GetPayMgr():TestPay()
function JoyyouPayMgr:TestPay()
    game:GetPayMgr():Purchase("100000")
end
--game:GetPayMgr():TestDevicePermission(EDevicePermissionType.Notification)
function JoyyouPayMgr:TestDevicePermission(permissionType)
    MDevice.RequestPermissionByType(CJson.encode({permission = tostring(permissionType)}), function(result, permission)
        log("result = " .. result .. "  permission = " .. permission)
        if permission == tostring(permissionType) then
            if result == tostring(EDevicePermissionResult.Authorized) then

            elseif result == tostring(EDevicePermissionResult.NotDetermined) then
                MDevice.RequestPermissionByType(CJson.encode({permission = tostring(permissionType)}))
            elseif result == tostring(EDevicePermissionResult.Denied) then
                if MGameContext.IsAndroid then

                elseif MGameContext.IsIOS then
                    MDevice.OpenSettingPermission()
                end
            elseif result == tostring(EDevicePermissionResult.DeniedAndNoAsk) then
                if MGameContext.IsAndroid then
                    MDevice.OpenSettingPermission()
                elseif MGameContext.IsIOS then
                    
                end
            end
        end
    end)
end
-- 以上是测试函数

return JoyyouPayMgr
