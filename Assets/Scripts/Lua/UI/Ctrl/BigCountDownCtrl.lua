--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BigCountDownPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
BigCountDownCtrl = class("BigCountDownCtrl", super)
--lua class define end

--lua functions
function BigCountDownCtrl:ctor()

	super.ctor(self, CtrlNames.BigCountDown, UILayer.Function, nil, ActiveType.Standalone)
	self.currentNum = -1
	self.countDownTimer = nil

end --func end
--next--
function BigCountDownCtrl:Init()

	self.panel = UI.BigCountDownPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function BigCountDownCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BigCountDownCtrl:OnActive()

	self:SetCountDown(self.uiPanelData.time, self.uiPanelData.callback)
	-- 时尚评分需要多一行提示文字
	if MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto then
		self.panel.TxtDesc.LabText = Common.Utils.Lang("FashionRatingCountDown")
		self.panel.TxtDesc:SetActiveEx(true)
		self.panel.TxtDesc.gameObject:GetComponent("FxAnimationHelper"):PlayAll()
	else
		self.panel.TxtDesc:SetActiveEx(false)
	end

end --func end
--next--
function BigCountDownCtrl:OnDeActive()

	if self.countDownTimer ~= nil then
		self:StopUITimer(self.countDownTimer)
		self.countDownTimer = nil
	end

end --func end
--next--
function BigCountDownCtrl:Update()

end --func end

--next--
function BigCountDownCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts
function BigCountDownCtrl:SetCountDown(countDownNum, callback)

	if self.countDownTimer ~= nil then
		self:StopUITimer(self.countDownTimer)
		self.countDownTimer = nil
	end
	self.currentNum = countDownNum
	self.panel.TxtCountDown:SetActiveEx(false)
	self.countDownTimer = self:NewUITimer(function()
		self.panel.TxtCountDown:SetActiveEx(true)
		self.panel.TxtCountDown.LabText = tostring(self.currentNum)
		self.currentNum = self.currentNum - 1
		if self.currentNum < 0 then
			self:StopUITimer(self.countDownTimer)
			self.countDownTimer = nil
			if callback ~= nil then
				callback()
			end
			UIMgr:DeActiveUI(UI.CtrlNames.BigCountDown)
		end
	end, 1, -1)
	self.countDownTimer:Start()

end

--lua custom scripts end
return BigCountDownCtrl