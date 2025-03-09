---@module ModuleMgr
module("ModuleMgr", package.seeall)

require "ModuleMgr/BaseAuthMgr"

local g_WxLoginFlag = false

local super = ModuleMgr.BaseAuthMgr
---@class MSDKAuthMgr : BaseAuthMgr
MSDKAuthMgr = class("MSDKAuthMgr", super)

function MSDKAuthMgr:ctor()
    super.ctor(self)
end

--@override
function MSDKAuthMgr:OnInit()
    super.OnInit(self)
end

function MSDKAuthMgr:OnUninit()
    super.OnUninit(self)
end

--[Comment]
--帐号登录
--@override
function MSDKAuthMgr:SDKAuth(loginType)
    if self.AuthData.GetInnerTestAgreementProto() == "none" then
        UIMgr:ActiveUI(UI.CtrlNames.InnerTestAgreementDialog)
        return
    end
    -- 基类方法
    super.SDKAuth(self, loginType)

    if MLogin.IsLogin() then --已经登录了
        self:OnSDKAuth(MLogin.GetLoginData())
    else
        MLogin.Login(CJson.encode({loginType = loginType}))
        MStatistics.DoStatistics(CJson.encode({
            tag = MLuaCommonHelper.Enum2Int(TagPoint.SelectPlatform),
            status = true,
            msg = loginType,
            authorize = true,
            finish = true
        }))
        if loginType == GameEnum.EMSDKLoginType.Weixin then
            g_WxLoginFlag = true
        end
    end
end

--[Comment]
--帐号登录回调
--@override
function MSDKAuthMgr:OnSDKAuth(loginData)
    if loginData.flag == EFlag.eFlag_Succ then
        self:OnSDKAuthed(loginData)
    else
        self:OnSDKAuthFailed(loginData)
    end

    g_WxLoginFlag = false
end

function MSDKAuthMgr:OnSDKAuthed(loginData)
    --初始化用户协议和隐私选中状态
    logGreen("[MSDKAuthMgr]OnSDKAuthed")
    local l_accountType = 0
    if loginData.platform == EPlatform.ePlatform_Weixin then
        l_accountType = 1
        self.loginType = GameEnum.EMSDKLoginType.Weixin
    elseif loginData.platform == EPlatform.ePlatform_QQ then
        l_accountType = 2
        self.loginType = GameEnum.EMSDKLoginType.QQ
    elseif loginData.platform == EPlatform.ePlatform_Guest then
        l_accountType = 5
        self.loginType = GameEnum.EMSDKLoginType.Guest
    else
        logError("[OnSDKAuth]unknow login platform: {0}", tostring(loginData.platform))
    end
    MStatistics.GemSetUser(CJson.encode({
        accounttype = l_accountType,
        openid = loginData.open_id
    }))
    super.OnSDKAuthed(self, loginData.open_id, loginData:GetAccessToken())
end

--[Comment]
--帐号登录失败回调
--@override
function MSDKAuthMgr:OnSDKAuthFailed(loginData)
    -- 基类方法
    super.OnSDKAuthFailed(self)

    if loginData.flag == EFlag.eFlag_Local_Invalid then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("eFlag_Local_Invalid")
    elseif loginData.flag == EFlag.eFlag_Need_Realname_Auth then
        -- MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NEED_REALNAME_AUTH"))
    elseif loginData.flag == EFlag.eFlag_WX_UserCancel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("USERCANCEL"))
    elseif loginData.flag == EFlag.eFlag_QQ_UserCancel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("USERCANCEL"))
    elseif loginData.flag == EFlag.eFlag_WX_NotInstall then
        --微信有bug，会重复调用这个接口
        if g_WxLoginFlag == true then
            --调用微信二维码
            MLogin.Login(CJson.encode({loginType = GameEnum.EMSDKLoginType.WXQrCode}))
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_WX_NotInstall"))
    elseif loginData.flag == EFlag.eFlag_QQ_NotInstall then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_QQ_NotInstall"))
    elseif loginData.flag == EFlag.eFlag_WX_NotSupportApi then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_WX_NotSupportApi"))
    elseif loginData.flag == EFlag.eFlag_QQ_NotSupportApi then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_QQ_NotSupportApi"))
    elseif loginData.flag == EFlag.eFlag_WX_LoginFail then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_WX_LoginFail"))
    elseif loginData.flag == EFlag.eFlag_QQ_LoginFail then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("eFlag_QQ_LoginFail"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_LOGIN_FAILED"))
        logError("[OnSDKAuthFailed]未知错误 错误码:"..tostring(loginData.flag))
    end
end

--开始游戏
--@override
function MSDKAuthMgr:StartGame(server)
    if super.StartGame(self, server) then
        self:ConnectGateServer()
    end
end

--[Comment]
--请求登陆
--@override
function MSDKAuthMgr:LoginGateServer()
    super.LoginGateServer(self)
    MTss.OnTssSdkLogin(CJson.encode({
        platf = self.pbLoginType,
        openid = self.AuthData.GetAccountInfo().account,
        worldid = self.AuthData.GetCurGateServer().serverid,
        roleid = self.AuthData.GetAccountInfo().account
    }))
end

--[Comment]
--返回到未登录帐号
--@override
function MSDKAuthMgr:LogoutToAccount()
    super.LogoutToAccount(self)
end

--[Comment]
--登陆参数
--@override
function MSDKAuthMgr:GetClientInfo()
    -- 注册渠道
    local l_regChannelId = tonumber(MLogin.GetRegisterChannelId()) or 0
    -- 登陆渠道
    local l_channelId = tonumber(MLogin.GetChannelId()) or 0

    local l_myInfo = MLogin.GetMyInfo()
    local l_picurl = l_myInfo and l_myInfo._pictureMiddle or ""

    local l_loginData = MLogin.GetLoginData()
    local l_token = l_loginData and l_loginData:GetAccessToken() or ""

    return {
        regChannelId = l_regChannelId,
        channelId = l_channelId,
        picurl = l_picurl,
        token = l_token
    }
end

-- #region 公用接口
--@override
function MSDKAuthMgr:GetPBLoginType(loginType)
    if loginType == GameEnum.EMSDKLoginType.Weixin or loginType == GameEnum.EMSDKLoginType.WXQrCode then
        return LoginType.LGOIN_WECHAT_PF
    elseif loginType == GameEnum.EMSDKLoginType.QQ then
        return LoginType.LOGIN_QQ_PF
    elseif loginType == GameEnum.EMSDKLoginType.Guest then
        return LoginType.LOGIN_IOS_GUEST
    else
        logError("[GetLoginType]invalid loginType:" .. tostring(loginType))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("[GetLoginType]invalid loginType:" .. tostring(loginType))
        return -1
    end
end
-- #endregion 公用接口

return MSDKAuthMgr
