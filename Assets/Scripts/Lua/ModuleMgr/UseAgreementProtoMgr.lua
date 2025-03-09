--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.UseAgreementProtoMgr", package.seeall)

--lua model end

--lua custom scripts

-- 游戏利用条款初始状态
TermsOfUseOriginalState = (MGlobalConfig:GetInt("TermsOfUseOriginalState") == 1) and true or false
-- 个人隐私条款初始状态
PersonalPrivacyTermsOriginalState = (MGlobalConfig:GetInt("PersonalPrivacyTermsOriginalState") == 1) and true or false
-- 所有推送设置
AllPushSetting = (MGlobalConfig:GetInt("AllPushSetting") == 1) and true or false
-- 广告开关
AdvertisingPushSetting = (MGlobalConfig:GetInt("AdvertisingPushSetting") == 1) and true or false
-- 深夜推送设置
NightTimePushSetting  = (MGlobalConfig:GetInt("NightTimePushSetting") == 1) and true or false
-- 游戏利用条款URL
TermsOfUseURL = MGlobalConfig:GetString("TermsOfUseURL")
-- 个人隐私条款URL
PersonalPrivacyTermsURL = MGlobalConfig:GetString("PersonalPrivacyTermsURL")
-- 运营策略URL
OperationStrategy = MGlobalConfig:GetString("OperationStrategy")
-- 韩国客服链接URL
CustomerServiceURL = MGlobalConfig:GetString("CustomerServiceURL")
-- 腾讯客服链接URL
TencentServiceURL = "https://ro.qq.com/"
-- 卖场客服链接URL
MallFeedingURL = MGlobalConfig:GetString("MallCustomerServiceURL")
-- 事件注册
EventDispatcher = EventDispatcher.new()
-- 请求同意协议成功
ON_ACCEPT_GAME_AGREEMENT = "ON_ACCEPT_GAME_AGREEMENT"

PushSet = 0

CurrentUseAgreementTimeStamp = ""      -- 当前http返回的使用条款时间戳

function ReqAcceptGameAgreement()
    log("ReqAcceptGameAgreement")
    local l_msgId = Network.Define.Rpc.AcceptGameAgreement
    ---@type AcceptGameAgreementArg
    local l_sendInfo = GetProtoBufSendTable("AcceptGameAgreementArg")
    l_sendInfo.openid = DataMgr:GetData("AuthData").GetAccountInfo().account
    l_sendInfo.push_set = PushSet
    l_sendInfo.agreement = CurrentUseAgreementTimeStamp
    l_sendInfo.type = game:GetAuthMgr().pbLoginType
    log(ToString(l_sendInfo))
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function RspAcceptGameAgreement(msg)
    --关闭loginserver的链接
    MNetClient:CloseConnection()
    MNetClient.NetLoginStep = ENetLoginStep.GateServerFetched

    log("RspAcceptGameAgreement")
    ---@type AcceptGameAgreementRes
    local l_info = ParseProtoBufToTable("AcceptGameAgreementRes", msg)
    log(ToString(l_info))
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        SetAgreementProtoTimeStamp(CurrentUseAgreementTimeStamp)
    end
    MPlayerSetting.AllowAgreement = (l_info.error == 0)
    EventDispatcher:Dispatch(ON_ACCEPT_GAME_AGREEMENT, MPlayerSetting.AllowAgreement)
end

function GetCustomerServiceURL()
    if g_Globals.IsKorea then
        return CustomerServiceURL
    else
        return TencentServiceURL
    end
end

local l_isSend = false
function GetUseAgreementTimeStamp(callback)
    -- 构成URL
    local str_sign, str_time, l_url = Common.CommonUIFunc.GetHttpSignAndTimeAndUrl()
    local l_url = l_url .. "/check-terms-version"

    --如果正在请求 不再重新请求
    if l_isSend then
        return
    end
    l_isSend = true
    HttpTask.Create(l_url):AddHeader("timestamp", tostring(str_time)):AddHeader("sign", str_sign):TimeOut(5000):GetResponseAynsc(function(res, str)
        logGreen("[GetUseAgreementTimeStamp]res={0}, json={1}", res, str)
        l_isSend = false
        if res == HttpResult.OK then
            local l_jsonData = CJson.decode(str)
            if l_jsonData["code"] == 200 then
                local l_data = l_jsonData["data"]
                if not string.ro_isEmpty(l_data.the_latest_time) then
                    CurrentUseAgreementTimeStamp = l_data.the_latest_time
                    MPlayerSetting.AllowAgreement = (CurrentUseAgreementTimeStamp == GetAgreementProtoTimeStamp())
                end
            end
        else
            logError("GetUseAgreementTimeStamp Fail HttpResult = " .. tostring(res) .. " str = " .. str)
        end
        if callback ~= nil then
            callback()
        end
    end)
end

-- 存储玩家是否同意【使用条款】
function SetAgreementProtoTimeStamp(value)
    UserDataManager.SetDataFromLua("AGREEMENT_PROTO_TIMESTAMP" .. DataMgr:GetData("AuthData").GetAccountInfo().account, MPlayerSetting.GLOBAL_SETING_GROUP, value)
end
-- 获取玩家是否同意【使用条款】
function GetAgreementProtoTimeStamp()
    return UserDataManager.GetStringDataOrDef("AGREEMENT_PROTO_TIMESTAMP" .. DataMgr:GetData("AuthData").GetAccountInfo().account, MPlayerSetting.GLOBAL_SETING_GROUP, "0")
end

--lua custom scripts end
return ModuleMgr.UseAgreementProtoMgr