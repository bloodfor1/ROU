--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MallPayPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class MallPayCtrl : UIBaseCtrl
MallPayCtrl = class("MallPayCtrl", super)
--lua class define end

--lua functions
function MallPayCtrl:ctor()
	
	super.ctor(self, CtrlNames.MallPay, UILayer.Top, nil, ActiveType.Standalone)

	self.cacheGrade = EUICacheLv.VeryLow
	self.overrideSortLayer = UI.UILayerSort.Top + 1
	self.closeUITimeOut = 0
	self.startTimer = 0

end --func end
--next--
function MallPayCtrl:Init()
	
	self.panel = UI.MallPayPanel.Bind(self)
	super.Init(self)
	
	self.mask = self:NewPanelMask(BlockColor.Dark, nil, function()
        if Application.isEditor then
        	UIMgr:DeActiveUI(self.name)
        end
    end)
end --func end
--next--
function MallPayCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.mask = nil
end --func end
--next--
function MallPayCtrl:OnActive()

	if self.uiPanelData ~= nil then
		if self.uiPanelData.TimeOut then
			self:SetTimeout(self.uiPanelData.TimeOut)
		end
	end
end --func end
--next--
function MallPayCtrl:OnDeActive()

	self.closeUITimeOut = 0
	self.startTimer = 0
end --func end
--next--
function MallPayCtrl:Update()

	if self.closeUITimeOut > 0 then
		if Time.time - self.startTimer > self.closeUITimeOut then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_RESPONSE_TIMEOUT"))
			UIMgr:DeActiveUI(UI.CtrlNames.MallPay)
		end
	end
end --func end
--next--
function MallPayCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function MallPayCtrl:SetTimeout(time)
	self.closeUITimeOut = tonumber(time) or 0
	self.startTimer = Time.time
end

--lua custom scripts end
return MallPayCtrl