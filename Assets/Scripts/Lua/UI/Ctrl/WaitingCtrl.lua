--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/WaitingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
WaitingCtrl = class("WaitingCtrl", super)
--lua class define end

--lua functions
function WaitingCtrl:ctor()

	super.ctor(self, CtrlNames.Waiting, UILayer.Top, nil, ActiveType.Standalone)
	self.cacheGrade = EUICacheLv.VeryLow
	self.overrideSortLayer = UI.UILayerSort.Top + 2
	self.hideTimer = nil
	self.hideTime = 0
	self.delayShowTime = 0
	self.delayShowTimer = nil
	self.isMaskHide = false
	self.showMsgText = Lang("TIPS_WAITING")

end --func end
--next--
function WaitingCtrl:Init()

	self.panel = UI.WaitingPanel.Bind(self)
	super.Init(self)
	self.panel.WaitingAnim:SetActiveEx(false)

end --func end
--next--
function WaitingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function WaitingCtrl:OnActive()
    if self.uiPanelData ~= nil then
        if self.uiPanelData.TimeOut then
            self:SetTimeout(self.uiPanelData.TimeOut)
        end
        if self.uiPanelData.DelayShow then
            self:SetDelayShowTime(self.uiPanelData.DelayShow)
        end
        if self.uiPanelData.MaskHide then
            self:SetMaskHide(self.uiPanelData.MaskHide)
        end
    end
	self:WaitingPanelRefresh()
	
end --func end

--next--
function WaitingCtrl:OnDeActive()

	if self.hideTimer ~= nil then
		self:StopUITimer(self.hideTimer)
	end
	self.hideTimer = nil
	self.hideTime = 0

	if self.delayShowTimer ~= nil then
		self:StopUITimer(self.delayShowTimer)
	end
	self.delayShowTime = 0
	self.delayShowTimer = nil

	self.panel.WaitingAnim:SetActiveEx(false)
	self:StopWaitingTimer()

	self.isMaskHide = false
end --func end
--next--
function WaitingCtrl:Update()


end --func end
--next--
function WaitingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function WaitingCtrl:WaitingPanelRefresh()
	if self.delayShowTimer ~= nil then
		self:StopUITimer(self.delayShowTimer)
		self.delayShowTimer = nil
	end

	if self.delayShowTime > 0 then
		self.panel.WaitingAnim:SetActiveEx(false)
		self.panel.msgText:SetActiveEx(false)
		self.delayShowTimer = self:NewUITimer(function ()
			self.panel.WaitingAnim:SetActiveEx(true)
			self.panel.msgText:SetActiveEx(true)
			self:StartWaitingTimer()
		end, self.delayShowTime)
		self.delayShowTimer:Start()
	else
		self.panel.WaitingAnim:SetActiveEx(true)
		self.panel.msgText:SetActiveEx(true)
		self:StartWaitingTimer()
	end

	if self.hideTimer ~= nil then
		self:StopUITimer(self.hideTimer)
		self.hideTimer = nil
	end

	if self.hideTime > 0 then
		self.hideTimer = self:NewUITimer(function ()
				UIMgr:DeActiveUI(UI.CtrlNames.Waiting)
		end, self.hideTime)
		self.hideTimer:Start()
	end

	self.panel.Mask:SetActiveEx(not self.isMaskHide)
end

function WaitingCtrl:SetTimeout(time)
	self.hideTime = tonumber(time) or 0
end

--[Comment]
--设置延迟显示的时间
function WaitingCtrl:SetDelayShowTime(time)
	self.delayShowTime = tonumber(time) or 0
end

--[Comment]
--延迟显示的时间内遮罩层是否可用
function WaitingCtrl:SetMaskHide(value)
	self.isMaskHide = not not value
end

--[Comment]
--显示的文本内容
function WaitingCtrl:SetMsgText(value)
	self.showMsgText = value
end

function WaitingCtrl:StartWaitingTimer()
	self:StopWaitingTimer()

	self.WaitingIdx = 0
	self.panel.msgText.LabText = self.showMsgText
	self.WaitingTimer = self:NewUITimer(function()

		local l_txt = self.showMsgText
		if self.WaitingIdx > 0 then
			for i = 1, self.WaitingIdx do
				l_txt = l_txt ..'.'
			end
		end
        self.panel.msgText.LabText = l_txt
        self.WaitingIdx = self.WaitingIdx + 1
        if self.WaitingIdx > 3 then
        	self.WaitingIdx = 0
        end

        self.panel.Mask:SetActiveEx(true)
    end, 0.5, -1)
    self.WaitingTimer:Start()
end

function WaitingCtrl:StopWaitingTimer()

	if self.WaitingTimer then
		self:StopUITimer(self.WaitingTimer)
		self.WaitingTimer = nil
	end
end
--lua custom scripts end
