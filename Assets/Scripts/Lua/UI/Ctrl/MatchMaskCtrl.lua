--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MatchMaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
local l_mgr = MgrMgr:GetMgr("ArenaMgr")
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MatchMaskCtrl = class("MatchMaskCtrl", super)
--lua class define end

--lua functions
function MatchMaskCtrl:ctor()

	super.ctor(self, CtrlNames.MatchMask, UILayer.Function, nil, ActiveType.Normal)
	self.fadeTime = 1.5
    self.enterTimer = nil
    self.enterLeftTime = 0
end --func end
--next--
function MatchMaskCtrl:Init()

	self.panel = UI.MatchMaskPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function MatchMaskCtrl:Uninit()

    if self.enterTimer then
		self:StopUITimer(self.enterTimer)
        self.enterTimer = nil
        self.enterLeftTime = 0
    end

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function MatchMaskCtrl:OnActive()
	local enterTimer
	enterTimer = self:NewUITimer(function()
		self:StopUITimer(enterTimer)
		UIMgr:DeActiveUI(UI.CtrlNames.MatchMask)
	end, 10, -1)

end --func end
--next--
function MatchMaskCtrl:OnDeActive()


end --func end
--next--
function MatchMaskCtrl:Update()


end --func end



--next--
function MatchMaskCtrl:BindEvents()
	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--==============================--
--@Description: 淡入
--@Date: 2018/9/15
--@Param: [args]
--@Return:
--==============================--
function MatchMaskCtrl:OnFadeIn()
	self.panel.MatchMask:GetComponent("CanvasGroup").alpha = 0
	self.panel.MatchMask.UObj:SetActiveEx(true)
	self.panel.MatchMask:GetComponent("CanvasGroup"):DOFade(1, self.fadeTime)
end

--==============================--
--@Description: 淡出
--@Date: 2018/9/15
--@Param: [args]
--@Return:
--==============================--
function MatchMaskCtrl:OnFadeOut()
	if self.panel then
		self.panel.MatchMask:GetComponent("CanvasGroup"):DOFade(0, self.fadeTime).onComplete = function()
			self.panel.MatchMask.UObj:SetActiveEx(false)
		end
	end
end

--==============================--
--@Description: 匹配成功
--@Date: 2018/9/15
--@Param: [args]
--@Return:
--==============================--
function MatchMaskCtrl:OnMatchSucc()
	if self.enterTimer then
		self:StopUITimer(self.enterTimer)
		self.enterTimer = nil
	end
	self.enterLeftTime = l_mgr.ArenaCountDownAfterMatching or 3
	self.panel.MatchTip.LabText = Lang("ARENA_MATCHED", self.enterLeftTime)
	self.enterTimer = self:NewUITimer(function()
		self.enterLeftTime = self.enterLeftTime - 1
		self.panel.MatchTip.LabText = Lang("ARENA_MATCHED", self.enterLeftTime)
		if self.enterLeftTime <= 0 then
			self:StopUITimer(self.enterTimer)
			self.enterTimer = nil
			--self:FadeOut()
		end
	end, 1, -1)
	self.enterTimer:Start()
end
--lua custom scripts end
