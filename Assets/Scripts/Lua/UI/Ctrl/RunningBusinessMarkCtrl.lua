--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RunningBusinessMarkPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RunningBusinessMarkCtrl = class("RunningBusinessMarkCtrl", super)
--lua class define end

--lua functions
function RunningBusinessMarkCtrl:ctor()
	
	super.ctor(self, CtrlNames.RunningBusinessMark, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)
	
end --func end
--next--
function RunningBusinessMarkCtrl:Init()
	
	self.panel = UI.RunningBusinessMarkPanel.Bind(self)
	super.Init(self)

	self.panel.TextSuccess.gameObject:SetActiveEx(false)
	self.panel.TextFailure.gameObject:SetActiveEx(false)
	
	self.closeTimer = nil
end --func end
--next--
function RunningBusinessMarkCtrl:Uninit()
	
	if self.closeTimer then
		self:StopUITimer(self.closeTimer)
		self.closeTimer = nil
	end

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RunningBusinessMarkCtrl:OnActive()
	
	self:ShowMark(self.uiPanelData)	
end --func end
--next--
function RunningBusinessMarkCtrl:OnDeActive()
	
	
end --func end
--next--
function RunningBusinessMarkCtrl:Update()
	
	
end --func end





--next--
function RunningBusinessMarkCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

-- 显示跑商状态
function RunningBusinessMarkCtrl:ShowMark(state, time)
	-- 传入事件或者默认值
	time = time or 3

	if self.closeTimer then
		self:StopUITimer(self.closeTimer)
		self.closeTimer = nil
	end
	
	self.closeTimer = self:NewUITimer(function()
		UIMgr:DeActiveUI(self.name)
	end, time)
	self.closeTimer:Start()

	local l_mgr = MgrMgr:GetMgr("MerchantMgr")
	local l_data = DataMgr:GetData("MerchantData")
	self.panel.TextSuccess.gameObject:SetActiveEx(false)
	self.panel.TextFailure.gameObject:SetActiveEx(false)
	if state == l_data.EMerchantState.Running then
		self.panel.TextSuccess.gameObject:SetActiveEx(true)
		self.panel.TextSuccess.LabText = Lang("MERCHANT_BEGIN_TITLE")
	elseif state == l_data.EMerchantState.Success then
		self.panel.TextSuccess.gameObject:SetActiveEx(true)
		self.panel.TextSuccess.LabText = Lang("MERCHANT_SUCCESS_TITLE")
	elseif state == l_data.EMerchantState.Failure then
		self.panel.TextFailure.gameObject:SetActiveEx(true)
		self.panel.TextFailure.LabText = Lang("MERCHANT_FAILURE_TITLE")
	end
end
--lua custom scripts end
return RunningBusinessMarkCtrl
