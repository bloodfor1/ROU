--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/UseAgreementProtoPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("UseAgreementProtoMgr")
--lua fields end

--lua class define
UseAgreementProtoCtrl = class("UseAgreementProtoCtrl", super)
--lua class define end

--lua functions
function UseAgreementProtoCtrl:ctor()
	
	super.ctor(self, CtrlNames.UseAgreementProto, UILayer.Function, nil, ActiveType.None)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark

end --func end
--next--
function UseAgreementProtoCtrl:Init()
	
	self.panel = UI.UseAgreementProtoPanel.Bind(self)
	super.Init(self)

	self.panel.TogProtoGame.TogEx.onValueChanged:AddListener(function(state)
		self:RefreshPanel()
	end)

	self.panel.BtnGame:AddClick(function ()
		MLogin.OpenURL(CJson.encode({url = Mgr.TermsOfUseURL}))
	end)

	self.panel.TogProtoUser.TogEx.onValueChanged:AddListener(function(state)
		self:RefreshPanel()
	end)

	self.panel.BtnUser:AddClick(function ()
		MLogin.OpenURL(CJson.encode({url = Mgr.PersonalPrivacyTermsURL}))
	end)

	self.panel.TogAllPush.TogEx.onValueChanged:AddListener(function(state)
		--玩家勾选2个非必选项，此时取消【同意接受活动推送提示】，会连带取消掉【同意接受夜间推送】的勾选
		if not state and self.panel.TogNightPush.TogEx.isOn then
			self.panel.TogNightPush.TogEx.isOn = false
		end
	end)

	self.panel.TogNightPush.TogEx.onValueChanged:AddListener(function(state)
		--玩家勾选【同意接受夜间推送】时，会连带勾选【同意接受活动推送提示】
		if state and (not self.panel.TogAllPush.TogEx.isOn) then
			self.panel.TogAllPush.TogEx.isOn = true
		end
	end)

	self.panel.BtnSure:AddClick(function ()
		if self.panel.TogProtoGame.TogEx.isOn and self.panel.TogProtoUser.TogEx.isOn then
			self:ReqAcceptGameAgreement()
		else
			-- 置灰状态
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("UseAgreeProtoGameTips"))
		end
	end)

	self.panel.BtnAgree:AddClick(function ()
		self.panel.TogProtoGame.TogEx.isOn = true
		self.panel.TogProtoUser.TogEx.isOn = true
		self.panel.TogAllPush.TogEx.isOn = true
		self.panel.TogNightPush.TogEx.isOn = true
	end)
end --func end
--next--
function UseAgreementProtoCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function UseAgreementProtoCtrl:OnActive()
	self.panel.TogProtoGame.TogEx.isOn = Mgr.TermsOfUseOriginalState
	self.panel.TogProtoUser.TogEx.isOn = Mgr.PersonalPrivacyTermsOriginalState
	self.panel.TogAllPush.TogEx.isOn = Mgr.AllPushSetting
	self.panel.TogNightPush.TogEx.isOn = Mgr.NightTimePushSetting
	self:RefreshPanel()
	
end --func end
--next--
function UseAgreementProtoCtrl:OnDeActive()
	if self.uiPanelData then
		if self.uiPanelData.callback ~= nil then
			self.uiPanelData.callback()
		end
	end
	
end --func end
--next--
function UseAgreementProtoCtrl:Update()
	
	
end --func end
--next--
function UseAgreementProtoCtrl:BindEvents()

	--请求同意协议成功
	self:BindEvent(Mgr.EventDispatcher, Mgr.ON_ACCEPT_GAME_AGREEMENT, self.OnAcceptGameAgreement)

	-- 连接登录服失败
	self:BindEvent(game:GetAuthMgr().EventDispatcher, EventConst.Names.REQ_LOGIN_CONNECT_ERROR, function ()
		UIMgr:DeActiveUI(UI.CtrlNames.UseAgreementProto)
	end)
end --func end
--next--
--lua functions end

--lua custom scripts
function UseAgreementProtoCtrl:RefreshPanel()
	if self.panel.TogProtoGame.TogEx.isOn and self.panel.TogProtoUser.TogEx.isOn then
		self.panel.BtnSure:SetGray(false)
	else
		self.panel.BtnSure:SetGray(true)
	end
end

function UseAgreementProtoCtrl:ReqAcceptGameAgreement()
	Mgr.PushSet = 0
	Mgr.PushSet = Mgr.PushSet + (self.panel.TogAllPush.TogEx.isOn and 1 or 0)
	Mgr.PushSet = Mgr.PushSet + (Mgr.AdvertisingPushSetting and 2 or 0)		-- 活动不显示，但是服务需要知道这个值，所以读表中默认的值@阿戴尔
	Mgr.PushSet = Mgr.PushSet + (self.panel.TogNightPush.TogEx.isOn and 4 or 0)
	game:GetAuthMgr():DealAgreement()
end

--请求同意协议结果
function UseAgreementProtoCtrl:OnAcceptGameAgreement(state)
	if state then
		local l_time = Common.TimeMgr.GetTimeTable(MServerTimeMgr.UtcSeconds)
		local l_str = l_time.year .. "-" .. l_time.month .. "-" .. l_time.day
		if self.panel.TogAllPush.TogEx.isOn then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("UseAgreeProtoAllPush", l_str))
		end
		if self.panel.TogNightPush.TogEx.isOn then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("UseAgreeProtoNightPush", l_str))
		end
		UIMgr:DeActiveUI(UI.CtrlNames.UseAgreementProto)
	end
end
--lua custom scripts end
return UseAgreementProtoCtrl