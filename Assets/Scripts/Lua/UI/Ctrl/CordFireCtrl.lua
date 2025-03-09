--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CordFirePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class CordFireCtrl : UIBaseCtrl
CordFireCtrl = class("CordFireCtrl", super)
--lua class define end

local l_countDownEffectStep = 0.1       -- 倒计时动效刷新频率
local mgr = MgrMgr:GetMgr("CordFireMgr")

--lua functions
function CordFireCtrl:ctor()
	
	super.ctor(self, CtrlNames.CordFire, UILayer.Function, nil, ActiveType.None)
	
end --func end
--next--
function CordFireCtrl:Init()
	
	self.panel = UI.CordFirePanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function CordFireCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CordFireCtrl:OnActive()
	if self.uiPanelData then
		if self.uiPanelData.openType == mgr.OpenType.Open then
			self.panel.cdEffRoot:StopDynamicEffect()
			self:StopUITimer(self.cDEffTimer)
			self.panel.CDEffImg.Img.fillAmount = 1
		elseif self.uiPanelData.openType == mgr.OpenType.CountDown then
			self.countDownEffWidth = self.panel.CDEffImg.RectTransform.sizeDelta.x
			self:_showCountDownEffect(self.uiPanelData.curTime,self.uiPanelData.totalTime)
		end
	end
	
end --func end
--next--
function CordFireCtrl:OnDeActive()
	self:StopUITimer(self.cDEffTimer)
	self.panel.cdEffRoot:StopDynamicEffect()
	self.cDECurTime = nil
	self.cDETotalTime = nil

end --func end
--next--
function CordFireCtrl:Update()
	
	
end --func end
--next--
function CordFireCtrl:BindEvents()

	self:BindEvent(mgr.l_eventDispatcher,mgr.SIG_CORDFIRE_PAUSE,self.Pause,self)
	
end --func end
--next--
--lua functions end

--lua custom scripts

-- 绳子燃烧倒计时特效
function CordFireCtrl:_showCountDownEffect(curTime,totalTime)
	if totalTime <= 0 or curTime >= totalTime then
		UIMgr:DeActiveUI(UI.CtrlNames.CordFire)
		return
	end

	self:StopUITimer(self.cDEffTimer)
	self.cDECurTime = curTime
	self.cDETotalTime = totalTime
	self.cDEffTimer = self:NewUITimer(function()
		local percent = self.cDECurTime / self.cDETotalTime
		self.panel.CDEffImg.Img.fillAmount = 1 - percent
		self.cDECurTime = self.cDECurTime + l_countDownEffectStep
		self.panel.cdEffRoot.transform.localPosition = Vector3.New(self.countDownEffWidth * (percent - 0.5),0,0)
		if self.cDECurTime >= self.cDETotalTime then
			self.panel.cdEffRoot:StopDynamicEffect()
			self.panel.cdEffRoot:PlayDynamicEffect(2,{
				stopTime = 2,
				stopCallback = function()
					UIMgr:DeActiveUI(UI.CtrlNames.CordFire)
				end
			})
			self:StopUITimer(self.cDEffTimer)
		end
	end,l_countDownEffectStep,-1,true)
	self.panel.cdEffRoot:PlayDynamicEffect(1)
	self.cDEffTimer:Start()
end

function CordFireCtrl:Pause()
	self.panel.cdEffRoot:StopDynamicEffect()
	self:StopUITimer(self.cDEffTimer)
end

--lua custom scripts end
return CordFireCtrl