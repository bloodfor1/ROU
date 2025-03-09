--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ConnectingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ConnectingCtrl = class("ConnectingCtrl", super)
--lua class define end

--lua functions
function ConnectingCtrl:ctor()

	super.ctor(self, CtrlNames.Connecting, UILayer.Top, nil, ActiveType.Standalone)
	self.cacheGrade = EUICacheLv.VeryLow
	self.overrideSortLayer = UI.UILayerSort.Top + 2
	self.hideTimer = nil
	self.hideTime = 0
	self.delayShowTime = 0
	self.delayShowTimer = nil
	self.isMaskHide = false
	self.showMsgText = Lang("TIPS_NET_RECONNECTING")

end --func end
--next--
function ConnectingCtrl:Init()

	self.panel = UI.ConnectingPanel.Bind(self)
	super.Init(self)
	self.panel.ConnectingAnim:SetActiveEx(false)

end --func end
--next--
function ConnectingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ConnectingCtrl:OnActive()

	if self.uiPanelData.TimeOut then
		self:SetTimeout(self.uiPanelData.TimeOut)
	end
	if self.uiPanelData.DelayShow then
		self:SetDelayShowTime(self.uiPanelData.DelayShow)
	end
	if self.uiPanelData.MaskHide then
		self:SetMaskHide(self.uiPanelData.MaskHide)
	end
	
	self:ConnectingPanelRefresh()
end --func end

--next--
function ConnectingCtrl:OnDeActive()

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

	self.panel.ConnectingAnim:SetActiveEx(false)
	self:StopConnectingTimer()

	self.isMaskHide = false
end --func end
--next--
function ConnectingCtrl:Update()


end --func end
--next--
function ConnectingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--next--
function ConnectingCtrl:ConnectingPanelRefresh()
	if self.delayShowTimer ~= nil then
		self:StopUITimer(self.delayShowTimer)
		self.delayShowTimer = nil
	end

	if self.delayShowTime > 0 then
		self.panel.ConnectingAnim:SetActiveEx(false)
		self.panel.msgText:SetActiveEx(false)
		self.delayShowTimer = self:NewUITimer(function ()
			self.panel.ConnectingAnim:SetActiveEx(true)
			self.panel.msgText:SetActiveEx(true)
			self:StartConnectingTimer()
		end, self.delayShowTime)
		self.delayShowTimer:Start()
	else
		self.panel.ConnectingAnim:SetActiveEx(true)
		self.panel.msgText:SetActiveEx(true)
		self:StartConnectingTimer()
	end

	if self.hideTimer ~= nil then
		self:StopUITimer(self.hideTimer)
		self.hideTimer = nil
	end

	if self.hideTime > 0 then
		self.hideTimer = self:NewUITimer(function ()
			UIMgr:DeActiveUI(UI.CtrlNames.Connecting)
		end, self.hideTime)
		self.hideTimer:Start()
	end

	self.panel.Mask:SetActiveEx(not self.isMaskHide)
end --func end

function ConnectingCtrl:SetTimeout(time)
	self.hideTime = tonumber(time) or 0
end

--[Comment]
--设置延迟显示的时间
function ConnectingCtrl:SetDelayShowTime(time)
	self.delayShowTime = tonumber(time) or 0
end

--[Comment]
--延迟显示的时间内遮罩层是否可用
function ConnectingCtrl:SetMaskHide(value)
	self.isMaskHide = not not value
end

--[Comment]
--显示的文本内容
function ConnectingCtrl:SetMsgText(value)
	self.showMsgText = value
end

function ConnectingCtrl:StartConnectingTimer()
	self:StopConnectingTimer()

	self.connectingIdx = 0
	self.panel.msgText.LabText = self.showMsgText
	self.connectingTimer = self:NewUITimer(function()

		local l_txt = self.showMsgText
		if self.connectingIdx > 0 then
			for i = 1, self.connectingIdx do
				l_txt = l_txt ..'.'
			end
		end
        self.panel.msgText.LabText = l_txt
        self.connectingIdx = self.connectingIdx + 1
        if self.connectingIdx > 3 then
        	self.connectingIdx = 0
        end

        self.panel.Mask:SetActiveEx(true)
    end, 0.5, -1)
    self.connectingTimer:Start()
end

function ConnectingCtrl:StopConnectingTimer()

	if self.connectingTimer then
		self:StopUITimer(self.connectingTimer)
		self.connectingTimer = nil
	end
end
--lua custom scripts end
