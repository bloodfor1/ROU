--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Ctrl/BlackCurtainCtrl"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.BlackCurtainCtrl
--next--
--lua fields end

--lua class define
BlackCurtainNormalCtrl = class("BlackCurtainNormalCtrl", super)
--lua class define end

--lua functions
function BlackCurtainNormalCtrl:ctor()

	super.super.ctor(self, CtrlNames.BlackCurtain, UILayer.Top, nil, ActiveType.Normal)
	self.paragraph = nil
	self.actionTimer = nil
	self.fxActionQuene = nil
	self.fadeAction = nil
	self.fxId = 0
	self.fxStartId = 0
	self.currentLineNum = 0
	self.linesCache = {}
	self.status = EBlackCurtainStatus.NONE
	self.isDefault = true
end --func end
--next--
function BlackCurtainCtrl:FadeOutAction( ... )
	local l_timeData = MgrMgr:GetMgr("BlackCurtainMgr").GetTimeData()

	self.fadeAction = self.panel.BG.CanvasGroup:DOFade(0,l_timeData.fadeOut)
	self.actionTimer = self:NewUITimer(function()
		UIMgr:DeActiveUI(CtrlNames.BlackCurtainNormal)
	end, l_timeData.fadeOut)
	self.actionTimer:Start()
end

return BlackCurtainNormalCtrl