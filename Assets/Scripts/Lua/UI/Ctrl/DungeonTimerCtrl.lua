--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonTimerPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local l_timer = nil     --定时器

--lua class define
local super = UI.UIBaseCtrl
DungeonTimerCtrl = class("DungeonTimerCtrl", super)
--lua class define end

--lua functions
function DungeonTimerCtrl:ctor()

	super.ctor(self, CtrlNames.DungeonTimer, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function DungeonTimerCtrl:Init()

	self.panel = UI.DungeonTimerPanel.Bind(self)
	super.Init(self)
	self.panel.TimeLab.LabText = "--:--"
	if  MgrMgr:GetMgr("HeroChallengeMgr").g_hasBegainTime then
		self:UpdateTimeLab()
	else
		local l_index = 2
		l_timer = self:NewUITimer(function()
			l_index = l_index - 1
			if l_index < 0 then
				self:UpdateTimeLab()
			end
		end,1,-1,true)
		l_timer:Start()
	end

end --func end
--next--
function DungeonTimerCtrl:Uninit()

	self:StopTimer()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function DungeonTimerCtrl:OnActive()


end --func end
--next--
function DungeonTimerCtrl:OnDeActive()


end --func end
--next--
function DungeonTimerCtrl:Update()


end --func end





--next--
function DungeonTimerCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts

function DungeonTimerCtrl:UpdateTimeLab()
	self:StopTimer()
	local l_info = MPlayerInfo.PlayerDungeonsInfo
	if not l_info or MPlayerDungeonsInfo.DungeonID == 0 then
		UIMgr:DeActiveUI(UI.CtrlNames.DungeonTimer)
		return
	end
	local l_passTime = MgrMgr:GetMgr("DungeonMgr").GetDungeonsPassTime()
	local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
	if not l_dungeonData or not l_dungeonData.TimeLimit then
		UIMgr:DeActiveUI(UI.CtrlNames.DungeonTimer)
		return
	end
	local l_type = l_dungeonData.TimeLimit:get_Item(0)
	local l_sec = l_dungeonData.TimeLimit:get_Item(1)
	if 	MgrMgr:GetMgr("DungeonMgr").DungeonTimeLimitType.TimeLimit_Ascending == l_type then
		local l_start = Time.realtimeSinceStartup
		local l_all = math.modf(Time.realtimeSinceStartup - l_start +l_passTime +0.5)
		local l_seconds = l_all % 60
		local l_mins = math.floor(l_all / 60)
		if self.panel then
			self.panel.TimeLab.LabText = StringEx.Format("{0:00}:{1:00}",l_mins,l_seconds)
		end
		l_timer = self:NewUITimer(function()
			local l_all = math.modf(Time.realtimeSinceStartup - l_start +l_passTime +0.5)
			if l_sec>0 and l_all>=l_sec then
				UIMgr:DeActiveUI(UI.CtrlNames.DungeonTimer)
			end
			local l_seconds = l_all % 60
			local l_mins = math.floor(l_all / 60)
			if self.panel then
				self.panel.TimeLab.LabText = StringEx.Format("{0:00}:{1:00}",l_mins,l_seconds)
			end
		end,1,-1,true)
		l_timer:Start()
		return
	end
	---TODO:
	UIMgr:DeActiveUI(UI.CtrlNames.DungeonTimer)
end

function DungeonTimerCtrl:StopTimer()
	if l_timer then
		self:StopUITimer(l_timer)
		l_timer = nil
	end
end

--lua custom scripts end
