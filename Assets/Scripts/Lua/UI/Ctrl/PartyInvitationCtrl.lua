--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PartyInvitationPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PartyInvitationCtrl = class("PartyInvitationCtrl", super)
--lua class define end

--lua functions
function PartyInvitationCtrl:ctor()
	
	super.ctor(self, CtrlNames.PartyInvitation, UILayer.Tips, nil, ActiveType.Standalone)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.PartyInvitation
	self.MaskDelayClickTime=2

end --func end
--next--
function PartyInvitationCtrl:Init()
	
	self.panel = UI.PartyInvitationPanel.Bind(self)
	super.Init(self)
end --func end
--next--
function PartyInvitationCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PartyInvitationCtrl:OnActive()
	--self:SetBlockOpt(BlockColor.Dark,function ()
	--	UIMgr:DeActiveUI(UI.CtrlNames.PartyInvitation)
	--end,2)
	self:InitPanel()
end --func end
--next--
function PartyInvitationCtrl:OnDeActive()
	if self.partyTimer then
		self:StopUITimer(self.partyTimer)
		self.partyTimer = nil
	end
end --func end
--next--
function PartyInvitationCtrl:Update()
	
	
end --func end





--next--
function PartyInvitationCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function PartyInvitationCtrl:InitPanel()
	local l_partyText = Lang("PARTY_INVITE_MESSAGE")
	self.panel.PartyText.LabText = Lang(l_partyText,MgrMgr:GetMgr("ThemePartyMgr").l_lucky_no)
	self.panel.PartyBtn:AddClick(function()
		MgrMgr:GetMgr("ThemePartyMgr").EnterToThemePartyScene()
		UIMgr:DeActiveUI(UI.CtrlNames.PartyInvitation)
		UIMgr:DeActiveUI(UI.CtrlNames.Bag)
	end)
	local fxAnimClose = self.panel.GameObjectPartyClose:GetComponent("FxAnimationHelper")
	local fxAnimOpen  = self.panel.GameObjectPartyOpen:GetComponent("FxAnimationHelper")
	if fxAnimClose then fxAnimClose:PlayAll() end
	self.partyTimer = self:NewUITimer(function()
		if fxAnimOpen then fxAnimOpen:PlayAll() end
	end,0.6)
	self.partyTimer:Start()
end
--lua custom scripts end
return PartyInvitationCtrl