--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleCountDownPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local l_timer = nil
local DURATION_START = 4

--lua class define
local super = UI.UIBaseCtrl
BattleCountDownCtrl = class("BattleCountDownCtrl", super)
--lua class define end

--lua functions
function BattleCountDownCtrl:ctor()

	super.ctor(self, CtrlNames.BattleCountDown, UILayer.Function, nil, ActiveType.Normal)


end --func end
--next--
function BattleCountDownCtrl:Init()

	self.panel = UI.BattleCountDownPanel.Bind(self)
	super.Init(self)

	self:StopTimer()
	local l_duration = DURATION_START - 1
	self.panel.Number:SetSprite("main","ui_Battlefield_"..tostring(l_duration)..".png")
	self.panel.Start.gameObject:SetActiveEx(false)
	self.panel.Countdown.gameObject:SetActiveEx(true)
	MLuaClientHelper.PlayFxHelper(self.panel.Countdown.gameObject)
	l_timer = self:NewUITimer(function()
		l_duration = l_duration -1
		if l_duration<0 then
			self:StopTimer()
			UIMgr:DeActiveUI(UI.CtrlNames.BattleCountDown)
			return
		end
		if l_duration<1 then
			self.panel.Start.gameObject:SetActiveEx(true)
			self.panel.Countdown.gameObject:SetActiveEx(false)
			MLuaClientHelper.PlayFxHelper(self.panel.Start.gameObject)
			return
		end
		self.panel.Number:SetSprite("main","ui_Battlefield_"..tostring(l_duration)..".png")
		MLuaClientHelper.PlayFxHelper(self.panel.Countdown.gameObject)
	end,1,-1,true)
	l_timer:Start()

end --func end
--next--
function BattleCountDownCtrl:Uninit()

	self:StopTimer()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BattleCountDownCtrl:OnActive()


end --func end
--next--
function BattleCountDownCtrl:OnDeActive()


end --func end
--next--
function BattleCountDownCtrl:Update()


end --func end



--next--
function BattleCountDownCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function BattleCountDownCtrl:StopTimer()
	if l_timer then
		self:StopUITimer(l_timer)
		l_timer = nil
	end
end
--lua custom scripts end
