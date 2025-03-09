--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TimeCountDownPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local nowCount = 0
local totalCount = 0
local startSet = false
local textLabInfo = ""
local finFunc = nil
local l_themePartyMgr = nil
--next--
--lua fields end

--lua class define
TimeCountDownCtrl = class("TimeCountDownCtrl", super)
--lua class define end

--lua functions
function TimeCountDownCtrl:ctor()
	
	super.ctor(self, CtrlNames.TimeCountDown, UILayer.Function, nil, ActiveType.Standalone)
	l_themePartyMgr = MgrMgr:GetMgr("ThemePartyMgr")
end --func end
--next--
function TimeCountDownCtrl:Init()
	
	self.panel = UI.TimeCountDownPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function TimeCountDownCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function TimeCountDownCtrl:OnActive()
	
	
end --func end
--next--
function TimeCountDownCtrl:OnDeActive()
	self:ResetData()
end --func end
--next--
function TimeCountDownCtrl:Update()
	self:UpdatePanel()
end --func end




--next--
function TimeCountDownCtrl:OnHide()
	
	self:ResetData()
	
end --func end
--next--
function TimeCountDownCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function TimeCountDownCtrl:ShowTimeCountDown(showText,countDownNum,finishFunc)
	textLabInfo = showText
	totalCount = countDownNum
	finFunc = finishFunc
	startSet = true
end

function TimeCountDownCtrl:UpdatePanel( ... )
	if startSet then
		if nowCount < totalCount then
			self.panel.TimeDownText.LabText = Lang(textLabInfo,tostring(math.ceil(totalCount - nowCount)))
			nowCount = nowCount + Time.deltaTime
		else
			if finFunc then
				finFunc()
			end
			UIMgr:DeActiveUI(UI.CtrlNames.TimeCountDown)
		end
	end
end

function TimeCountDownCtrl:ResetData( ... )
	l_themePartyMgr.l_countDownTotalNum = nowCount < totalCount and totalCount or 0
	l_themePartyMgr.l_nowCount = nowCount < totalCount and nowCount or 0
	l_themePartyMgr.l_countDownTxt = nowCount < totalCount and textLabInfo or ""
	l_themePartyMgr.l_countFinFun = nowCount < totalCount and finFunc or nil
	startSet = false
	nowCount = 0
	totalCount = 0
	textLabInfo = ""
	finFunc = nil
end
--lua custom scripts end
return TimeCountDownCtrl