--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/NewPlayerBoxPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
StatusType =
{
	Open = 1,
	Close = 2,
	OpenNow = 3,
	Default = 4
}
--lua fields end

--lua class define
NewPlayerBoxHandler = class("NewPlayerBoxHandler", super)
--lua class define end

--lua functions
function NewPlayerBoxHandler:ctor()
	
	super.ctor(self, HandlerNames.NewPlayerBox, 0)
	
end --func end
--next--
function NewPlayerBoxHandler:Init()

	self.panel = UI.NewPlayerBoxPanel.Bind(self)
	super.Init(self)

	self.state = StatusType.Default
	self.leftTimer = nil
	self.level = -1
	self.mgr = MgrMgr:GetMgr("NewPlayerMgr")
	self.systemMgr = MgrMgr:GetMgr("OpenSystemMgr")
	self.panel.BtnOpen:AddClick(function()
		if self.state == StatusType.Close then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEW_PLAYER_TIPS_2", self.level))
		elseif self.state == StatusType.Open then
			self:PrePer()
		end
	end)
	
end --func end
--next--
function NewPlayerBoxHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mgr = nil
	self.level = nil
	self.state = nil

end --func end
--next--
function NewPlayerBoxHandler:OnActive()


end --func end
--next--
function NewPlayerBoxHandler:OnShow()

	if self.mgr.Gift.now > 0 then
		self:InitGiftOpen(self.mgr.Gift.now)
	else
		self:InitGiftClose()
	end

end --func end
--next--
function NewPlayerBoxHandler:OnHide()
	
	self.panel.EffectClose:StopDynamicEffect()
	self.panel.EffectOpen:StopDynamicEffect()
	self:StopTimer()

end --func end
--next--
function NewPlayerBoxHandler:OnDeActive()
	
end --func end
--next--
function NewPlayerBoxHandler:Update()
	
end --func end
--next--
function NewPlayerBoxHandler:BindEvents()

	self:BindEvent(self.mgr.EventDispatcher, self.mgr.EventType.MainInfo, self.GiftOpen)
	self:BindEvent(self.systemMgr.EventDispatcher, self.systemMgr.CloseSystemEvent, function(self, systemId)
		if systemId == self.systemMgr.eSystemId.NewPlayerGift then
			self:InitGiftClose()
		end
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function NewPlayerBoxHandler:StopTimer()

	if self.leftTimer then
		self:StopUITimer(self.leftTimer)
		self.leftTimer = nil
	end

end

function NewPlayerBoxHandler:PrePer()

	local l_spine = self.panel.Anim.transform:GetComponent("SkeletonGraphic")
	l_spine.startingLoop = false
	l_spine.AnimationName = "Open"
	self.panel.EffectClose:StopDynamicEffect()
	self.panel.EffectOpen:PlayDynamicEffect(-1, {delayTime = 1.25})
	self.panel.BtnOpen:SetGray(true)

	self:StopTimer()
	self.state = StatusType.OpenNow
	self.leftTimer = self:NewUITimer(function()
		self.mgr.GetMengXinLevelGift(self.mgr.Gift.now)
	end, 1.25)
	self.leftTimer:Start()

end

function NewPlayerBoxHandler:GiftOpen()

	self:StopTimer()
	self.state = StatusType.OpenNow
	self.leftTimer = self:NewUITimer(function()
		self:OnShow()
	end, 2.75)
	self.leftTimer:Start()

end

function NewPlayerBoxHandler:InitGiftOpen(id)

	local l_spine = self.panel.Anim.transform:GetComponent("SkeletonGraphic")
	l_spine.startingLoop = true
	l_spine.AnimationName = "Idle"
	self.panel.EffectClose:PlayDynamicEffect()
	self.panel.EffectOpen:StopDynamicEffect()

	local l_table = TableUtil.GetNewPlayerGiftTable().GetRowById(id)
	if l_table ~= nil then
		local l_base = l_table.Base
		self.panel.Hint.LabText = Lang("NEW_PLAYER_TIPS_1", "<size=24>" .. l_base .. "</size>")
	end
	self.panel.BtnOpen:SetGray(false)
	self.state = StatusType.Open

end

function NewPlayerBoxHandler:InitGiftClose()

	local l_spine = self.panel.Anim.transform:GetComponent("SkeletonGraphic")
	l_spine.startingLoop = true
	l_spine.AnimationName = "Idle01"
	self.panel.EffectClose:StopDynamicEffect()
	self.panel.EffectOpen:StopDynamicEffect()

	local l_table = TableUtil.GetNewPlayerGiftTable().GetTable()
	local l_level = -1
	for i = 1, #l_table do
		if l_table[i].Base > MPlayerInfo.Lv then
			l_level = l_table[i].Base
			break
		end
	end
	if l_level == -1 or (not self.systemMgr.IsSystemOpen(self.systemMgr.eSystemId.NewPlayerGift)) then
		self.panel.Hint.LabText = Lang("NEW_PLAYER_FINISH")
		self.panel.BtnOpen:SetActiveEx(false)
	else
		self.panel.Hint.LabText = Lang("NEW_PLAYER_TIPS_2", "<size=24>" .. l_level .. "</size>")
	end
	self.panel.BtnOpen:SetGray(true)
	self.state = StatusType.Close
	self.level = l_level

end
--lua custom scripts end
return NewPlayerBoxHandler