---@module ModuleMgr
module("ModuleMgr", package.seeall)

require "ModuleMgr/BaseAuthMgr"

local super = ModuleMgr.BaseAuthMgr
---@class JoyyouAuthMgr : BaseAuthMgr
JoyyouAuthMgr = class("JoyyouAuthMgr", super)

function JoyyouAuthMgr:ctor()
    super.ctor(self)
end

function JoyyouAuthMgr:OnUninit()
    super.OnUninit(self)
end

--[Comment]
--帐号登录
--@override
function JoyyouAuthMgr:SDKAuth(loginType)
    -- 基类方法
    super.SDKAuth(self, loginType)

    if loginType == GameEnum.EJoyyouLoginType.AutoLogin then
        MLogin.AutoLogin()
    else
        MLogin.Logout()
        MLogin.Login(CJson.encode({loginType = loginType}))
    end
    MStatistics.DoStatistics(CJson.encode({
        tag = MLuaCommonHelper.Enum2Int(TagPoint.SelectPlatform),
        status = true,
        msg = loginType,
        authorize = true,
        finish = true
    }))
    -- 用于测试sdk登录 token30天过期
    --local arg = {
    --    result = GameEnum.JoyyouSDKResult.SUCCESS,
    --    channel = (loginType == GameEnum.EJoyyouLoginType.AutoLogin) and GameEnum.EJoyyouLoginType.JoyyouGuest or loginType,
    --    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50X2lkIjoxMDI0ODg1NjgsImFjY291bnRfbmFtZSI6InJvc3MgQyIsImVtYWlsIjoiY3Jvc3NsaWJpbkBnbWFpbC5jb20iLCJjaGFubmVsX2lkIjoyLCJkZXZpY2VfaWQiOiJiZTYyNjlhZjc5YTc1Nzk4ZTZiN2Y4ODkyNzhiM2NhZSIsImV4cCI6MTU5NjA5MTQ0OH0.nSja5KgOrhKObynFw0HhJLK1tVfTKSVGncQ9L5MNYtg",
    --}
    --game:GetAuthMgr():OnSDKAuth(CJson.encode(arg))
end

--[Comment]
--帐号登录回调
--@override
function JoyyouAuthMgr:OnSDKAuth(loginData)
    local data = CJson.decode(loginData)
    if data and data.result then
        if data.result == GameEnum.JoyyouSDKResult.SUCCESS then
            self:OnSDKAuthed(data)
        else
            self:OnSDKAuthFailed(data)
        end
    else
        CommonUI.Dialog.HideWaiting()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_LOGIN_FAILED"))
        logError("[OnSDKAuth]loginData数据错误:"..tostring(loginData))
    end
end

function JoyyouAuthMgr:OnSDKAuthed(loginData)
    -- 登录成功 刷新logintype
    self.loginType = loginData.channel
    MgrMgr:GetMgr("AdjustTrackerMgr").LoginEvent(self.loginType)
    MLogin.GetUserInfo()
    super.OnSDKAuthed(self, "", loginData.token)
end

--[Comment]
--帐号登录失败回调
--@override
function JoyyouAuthMgr:OnSDKAuthFailed(loginData)
    -- 基类方法
    super.OnSDKAuthFailed(self)

    if loginData.msg and loginData.msg ~= "" then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(loginData.msg)
    else
        if loginData.result == GameEnum.JoyyouSDKResult.CANCER then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("USERCANCEL"))
        elseif loginData.result == GameEnum.JoyyouSDKResult.ERROR then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_LOGIN_FAILED"))
        elseif loginData.result == GameEnum.JoyyouSDKResult.SDKLoginError then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SDK_LOGIN_ERROR"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_LOGIN_FAILED"))
            logError("[OnSDKAuthFailed]未知错误 错误码:"..tostring(loginData.result))
        end
    end
end

--开始游戏
function JoyyouAuthMgr:StartGame(server)
    if super.StartGame(self, server) then
        self:ConnectGateServer()
    end
end

--[Comment]
--返回到未登录帐号
--@override
function JoyyouAuthMgr:LogoutToAccount()
    super.LogoutToAccount(self)
end

-- #region 公用接口
--@override
function JoyyouAuthMgr:GetPBLoginType(loginType)
    -- 服务器判定下面类型都属于Joyyou登录
    if loginType == GameEnum.EJoyyouLoginType.Google then
        return LoginType.LOGIN_JOYYOU_GOOGLE
    elseif loginType == GameEnum.EJoyyouLoginType.JoyyouGuest then
        return LoginType.LOGIN_JOYYOU_GUEST
    elseif loginType == GameEnum.EJoyyouLoginType.Facebook then
        return LoginType.LOGIN_JOYYOU_FACEBOOK
    elseif loginType == GameEnum.EJoyyouLoginType.Apple then
        return LoginType.LOGIN_JOYYOU_APPLE
    else
        logError("[GetLoginType]invalid loginType:" .. tostring(loginType))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("[GetLoginType]invalid loginType:" .. tostring(loginType))
        return -1
    end
end
-- #endregion 公用接口

return JoyyouAuthMgr
