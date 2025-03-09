--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BindAccountPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BindAccountCtrl = class("BindAccountCtrl", super)
--lua class define end

--lua functions
function BindAccountCtrl:ctor()

	super.ctor(self, CtrlNames.BindAccount, UILayer.Function, nil, ActiveType.None)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.BindAccount
	
end --func end
--next--
function BindAccountCtrl:Init()

	self.panel = UI.BindAccountPanel.Bind(self)
	super.Init(self)

	self.bindAccountStatus = {
		Facebook = false,
		Google = false,
		Apple = false,
	}
	self.SDKUserInfo = {}

	self.bindRetData = {}
	self.currentBindType = "-1"

	-- 绑定fb
	self.panel.Button_Facebook:AddClick(function()
		self:ClickBindBtn(GameEnum.EJoyyouLoginType.Facebook)
	end)

	-- 绑定google
	self.panel.Button_Google:AddClick(function()
		self:ClickBindBtn(GameEnum.EJoyyouLoginType.Google)
	end)

	-- 绑定apple
	self.panel.Button_Apple:AddClick(function()
		-- apple登录ios只支持ios13以上
		if MGameContext.IsIOS and not MDevice.AvailableSystemVersion(CJson.encode({version = 13})) then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NotAvailableiOS13"))
			return
		end
		self:ClickBindBtn(GameEnum.EJoyyouLoginType.Apple)
	end)

	-- 删除账号
	self.panel.Btn_Delete:AddClick(function()

	end)
	self.panel.Btn_Delete.gameObject:SetActiveEx(false)

	-- 退出账号
	self.panel.Btn_Exit:AddClick(function()
		game:GetAuthMgr():LogoutToAccount()
		UIMgr:DeActiveUI(UI.CtrlNames.BindAccount)
	end)
end --func end
--next--
function BindAccountCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.bindAccountStatus = {
		Facebook = false,
		Google = false,
		Apple = false,
	}
	self.bindRetData = {}
	self.SDKUserInfo = {}
	self.currentBindType = -1
	
end --func end
--next--
function BindAccountCtrl:OnActive()

	self:OnGetUserInfoCallback()
end --func end
--next--
function BindAccountCtrl:OnDeActive()

end --func end
--next--
function BindAccountCtrl:Update()
	
	
end --func end
--next--
function BindAccountCtrl:BindEvents()

	self:BindEvent(game:GetAuthMgr().EventDispatcher, EventConst.Names.ON_SDK_GET_USER_INFO_CALLBACK, self.OnGetUserInfoCallback)
	self:BindEvent(game:GetAuthMgr().EventDispatcher, EventConst.Names.ON_SDK_BIND_ACCOUNT_CALLBACK, self.OnSDKBindAccount)
end --func end
--next--
--lua functions end

--lua custom scripts
function BindAccountCtrl:RefreshPanel()
	self.panel.FacebookText.LabText = self.bindAccountStatus.Facebook and Common.Utils.Lang("BindAccountSuccessText", "Facebook") or Common.Utils.Lang("NotBindAccountText", "Facebook")
	self.panel.GoogleText.LabText = self.bindAccountStatus.Google and Common.Utils.Lang("BindAccountSuccessText", "Google") or Common.Utils.Lang("NotBindAccountText", "Google")
	self.panel.AppleText.LabText = self.bindAccountStatus.Apple and Common.Utils.Lang("BindAccountSuccessText", "Apple") or Common.Utils.Lang("NotBindAccountText", "Apple")
end

function BindAccountCtrl:ClickBindBtn(bindType)
	log("ClickBindBtn: " .. bindType)
	if self.bindAccountStatus.Facebook then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountAlready", "Facebook"))
	elseif self.bindAccountStatus.Google then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountAlready", "Google"))
	elseif self.bindAccountStatus.Apple then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountAlready", "Apple"))
	else
		CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Tourist_Once_Bind_Account_Tip"), function()
			self.currentBindType = bindType
			MLogin.BindAccount(CJson.encode({loginType = bindType}))
		end)
	end
end

function BindAccountCtrl:OnGetUserInfoCallback()
	self.SDKUserInfo = DataMgr:GetData("AuthData").GetSDKUserInfo()
	log(ToString(self.SDKUserInfo))
	if self.SDKUserInfo.channels then
		for _, v in pairs(self.SDKUserInfo.channels) do
			if tostring(v.channel_id) == GameEnum.EJoyyouLoginType.Facebook then
				self.bindAccountStatus.Facebook = v.is_bind
			elseif tostring(v.channel_id) == GameEnum.EJoyyouLoginType.Google then
				self.bindAccountStatus.Google = v.is_bind
			elseif tostring(v.channel_id) == GameEnum.EJoyyouLoginType.Apple then
				self.bindAccountStatus.Apple = v.is_bind
			end
		end
	end
	self:RefreshPanel()
end

function BindAccountCtrl:OnSDKBindAccount(str)
	log("OnSDKBindAccount")
	logGreen(str)
	local json = CJson.decode(str)
	if json then
		if json.result == GameEnum.JoyyouSDKResult.SUCCESS then
			local data = CJson.decode(json.data)
			if self.currentBindType ~= -1 then
				local txt = ""
				if self.currentBindType == GameEnum.EJoyyouLoginType.Facebook then
					txt = "Facebook"
					self.bindAccountStatus.Facebook = true
				elseif self.currentBindType == GameEnum.EJoyyouLoginType.Google then
					txt = "Google"
					self.bindAccountStatus.Google = true
				elseif self.currentBindType == GameEnum.EJoyyouLoginType.Apple then
					txt = "Apple"
					self.bindAccountStatus.Apple = true
				end
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountSuccess", data.data.account_name, txt))
			end
			MLogin.GetUserInfo()
		else
			if json.data then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(json.data)
			else
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountError"))
			end
		end
	end
	self:RefreshPanel()
end
--lua custom scripts end
return BindAccountCtrl