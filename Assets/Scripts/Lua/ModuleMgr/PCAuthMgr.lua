

module("ModuleMgr", package.seeall)

require "ModuleMgr/BaseAuthMgr"

local super = ModuleMgr.BaseAuthMgr
---@class PCAuthMgr : BaseAuthMgr
PCAuthMgr = class("PCAuthMgr", super)

function PCAuthMgr:ctor()
    super.ctor(self)
end

--[Comment]
--帐号登录
--@override
function PCAuthMgr:SDKAuth(loginType, account)
    if self.AuthData.GetInnerTestAgreementProto() == "none" then
        UIMgr:ActiveUI(UI.CtrlNames.InnerTestAgreementDialog)
        return
    end
    super.SDKAuth(self, loginType)
	self:OnSDKAuthed(account)
end

--[Comment]
--帐号登录回调
--@override
function PCAuthMgr:OnSDKAuthed(account)
    super.OnSDKAuthed(self, account, "123")
end

--@override
function PCAuthMgr:StartGame(server)
    if super.StartGame(self, server) then
        self:ConnectGateServer()
    end
end

-- #region 公用接口
--@override
function PCAuthMgr:GetPBLoginType(loginType)
    if loginType == "PC" then
        return LoginType.LOGIN_PASSWORD
    else
        logError("[GetLoginType]invalid loginType:" .. tostring(loginType))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("[GetLoginType]invalid loginType:" .. tostring(loginType))
        return -1
    end
end
-- #endregion 公用接口

return PCAuthMgr
