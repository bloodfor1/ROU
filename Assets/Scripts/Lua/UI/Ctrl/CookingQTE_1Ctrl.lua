--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CookingQTE_1Panel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CookingQTE_1Ctrl = class("CookingQTE_1Ctrl", super)
--lua class define end
TEMPERATURE_MAX_LENGTH = 230
WARNING_TOP_Y = 92
WARNING_BOTTOM_Y = -70
WARNING_TEMPERATURE = 12
SAFE_MAX = 80
SAFE_MIN = 30
--lua functions
function CookingQTE_1Ctrl:ctor()

	super.ctor(self, CtrlNames.CookingQTE_1, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
	
end --func end
--next--
function CookingQTE_1Ctrl:Init()
	self.panel = UI.CookingQTE_1Panel.Bind(self)
	super.Init(self)
	self.panel.Fire.UObj:SetActiveEx(false)

end --func end
--next--
function CookingQTE_1Ctrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function CookingQTE_1Ctrl:OnActive()
	self.isBegin = false
	self.temperature = 65
	local l_timer = self:NewUITimer(function()
		self:QTEBegin()
	end, 1.5)
	l_timer:Start()
	self.panel.BgMask:AddClick(function()
		if self.isBegin then
			self:TapScreen()
		end
	end)
	self.qteBeginTimer = nil
	self.warningAni = self.panel.WarningImg.transform:GetComponent("DOTweenAnimation")
end --func end
--next--
function CookingQTE_1Ctrl:OnDeActive()
	self.isBegin = false
	self.temperature = 65
	if self.qteBeginTimer ~= nil then
		self:StopUITimer(self.qteBeginTimer)
		self.qteBeginTimer = nil
	end
	if self.warningAni ~= nil then
		self.warningAni:DOKill()
		self.warningAni = nil
	end

end --func end
--next--
function CookingQTE_1Ctrl:Update()

	if not self.isBegin then
		return
	end

	if self:CheckFailed() then
		self:QTEFailed()
		return
	end
	self.temperature = self.temperature - 0.3
	self:UpdateTemperaturePosition()

end --func end
--next--
function CookingQTE_1Ctrl:BindEvents()

	--dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts

function CookingQTE_1Ctrl:QTEBegin()
	-- body
	self.isBegin = true
	self.panel.Title.UObj:SetActiveEx(false)
	self.panel.Fire.UObj:SetActiveEx(true)
	self.temperature = 65
	self:UpdateTemperaturePosition()
	self.panel.WarningImg.UObj:SetActiveEx(false)
	MgrMgr:GetMgr("CookingSingleMgr").PlayAudioWithTiming(MgrMgr:GetMgr("CookingSingleMgr").CookingTiming.QTE_BEGIN)
	self.qteBeginTimer = self:NewUITimer(function()
		SetQTEState(true)
	end, 8)
	self.qteBeginTimer:Start()
end

function CookingQTE_1Ctrl:SetQTEState(state)
	local qteWin = false
	qteWin = state
	self.isBegin = false
	MgrMgr:GetMgr("CookingSingleMgr").RequsetSingleCookingFinish(qteWin)
	UIMgr:DeActiveUI(CtrlNames.CookingQTE_1)
end

function CookingQTE_1Ctrl:TapScreen()
	self.temperature = self.temperature + 5

	if self.temperature + WARNING_TEMPERATURE > SAFE_MAX  then
		self.panel.WarningImg.UObj:SetActiveEx(true)
		MLuaCommonHelper.SetRectTransformPosY(self.panel.WarningImg.UObj,WARNING_TOP_Y)
		if self.warningAni == nil then
			self.warningAni = self.panel.WarningImg.transform:GetComponent("DOTweenAnimation")
		end
		self.warningAni:DORestart()
	elseif self.temperature - WARNING_TEMPERATURE < SAFE_MIN then
		self.panel.WarningImg.UObj:SetActiveEx(true)
		MLuaCommonHelper.SetRectTransformPosY(self.panel.WarningImg.UObj,WARNING_BOTTOM_Y)
		if self.warningAni == nil then
			self.warningAni = self.panel.WarningImg.transform:GetComponent("DOTweenAnimation")
		end
		self.warningAni:DORestart()
	else
		self.panel.WarningImg.UObj:SetActiveEx(false)

	end

	self:UpdateTemperaturePosition()
	if self:CheckFailed() then
		self:QTEFailed()
	end
end

function CookingQTE_1Ctrl:CheckFailed( ... )
	if self.temperature > SAFE_MAX or self.temperature < SAFE_MIN then
		return true
	end
	return false
end

function CookingQTE_1Ctrl:UpdateTemperaturePosition()
	local pos= self.panel.SafetyImg.RectTransform.anchoredPosition
	pos.y = self.temperature / 100 * self.panel.Fire.RectTransform.sizeDelta .y
	self.panel.SafetyImg.RectTransform.anchoredPosition = pos
end

function CookingQTE_1Ctrl:QTEFailed(  )
	if self.qteBeginTimer ~= nil then
		self:StopUITimer(self.qteBeginTimer)
		self.qteBeginTimer = nil
		SetQTEState(false)
	end
end

--lua custom scripts end
