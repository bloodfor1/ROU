--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehiclesBGPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
VehiclesBGCtrl = class("VehiclesBGCtrl", super)
--lua class define end

--lua functions
function VehiclesBGCtrl:ctor()
	
	super.ctor(self, CtrlNames.VehiclesBG, UILayer.Normal, nil, ActiveType.Exclusive)
	
end --func end
--next--
function VehiclesBGCtrl:Init()
	
	self.panel = UI.VehiclesBGPanel.Bind(self)
	super.Init(self)

	self:initPanel()
end --func end
--next--
function VehiclesBGCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.vehicleInfoMgr = nil
end --func end
--next--
function VehiclesBGCtrl:OnActive()
	self.panel.Tog_ProVehicle.TogEx.isOn = true
	self.panel.Tog_Ability.TogEx.isOn = true
	if self.uiPanelData~=nil then
		if self.uiPanelData.selectPanel then
			if self.uiPanelData.selectPanel == UI.CtrlNames.VehiclesOccupation then
				self.panel.Tog_ProVehicle.TogEx.isOn = true
				self.panel.Tog_Ability.TogEx.isOn = true
			else
				if self.uiPanelData.chooseVehicleId~=nil then
					self.chooseVehicleId = self.uiPanelData.chooseVehicleId
				end
				self.panel.Tog_SpecialVehicle.TogEx.isOn = true
			end
			return
		end
	end

end --func end
--next--
function VehiclesBGCtrl:OnDeActive()
	self:closePanel(UI.CtrlNames.VehiclesCharacteristic,false)
	self:closePanel(UI.CtrlNames.VehiclesOccupation,false)
	self.showVehicleStageUpPanel = false
	self.chooseVehicleId = nil
end --func end
--next--
function VehiclesBGCtrl:Update()
	
	
end --func end





--next--
function VehiclesBGCtrl:BindEvents()
	self:BindEvent(self.vehicleInfoMgr.EventDispatcher, self.vehicleInfoMgr.EventType.ShowVehicleStagePanel, self.onShowVehicleStageUpPanel)
end --func end

--next--
--lua functions end

--lua custom scripts
function VehiclesBGCtrl:initPanel()
	self.vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
	self.currentShowAbilityPanel = nil
	self.chooseVehicleId = nil
	self.panel.Btn_Close:AddClick(function()
		self:Close()
	end, true)

	self.panel.Tog_ProVehicle:OnToggleExChanged(function(on)
		if on then
			self.panel.Panel_ProChildToggle:SetActiveEx(true)
			self:showProVehiclePanel(self.panel.Tog_Ability.TogEx.isOn)
		else
			self.panel.Panel_ProChildToggle:SetActiveEx(false)
			self:closePanel(UI.CtrlNames.VehiclesOccupation,true)
		end
	end,true)

	self.panel.Tog_SpecialVehicle:OnToggleExChanged(function(on)
		if on then
			self.currentShowAbilityPanel = nil
			if self.chooseVehicleId~=nil then
				self:showVehicleCharacterPanelByVehicleId(self.chooseVehicleId)
				self.chooseVehicleId = nil
			else
				self:showPanel(UI.CtrlNames.VehiclesCharacteristic)
			end
		else
			self:closePanel(UI.CtrlNames.VehiclesCharacteristic,true)
		end
	end,true)

	self.panel.Tog_Ability:OnToggleExChanged(function(on)
		if on then
			self:showProVehiclePanel(true)
		end
	end,true)

	self.panel.Tog_Quality:OnToggleExChanged(function(on)
		if on then
			self:showProVehiclePanel(false)
		end
	end,true)
end

function VehiclesBGCtrl:onShowVehicleStageUpPanel()
	self.showVehicleStageUpPanel = true
	self.panel.Tog_Quality.TogEx.isOn = true
end

function VehiclesBGCtrl:showProVehiclePanel(showAbilityInfo)
	if self.currentShowAbilityPanel~=nil and showAbilityInfo==self.currentShowAbilityPanel then
		return
	end
	self.currentShowAbilityPanel = showAbilityInfo
	local l_showVehicleStageUpPanel = self.showVehicleStageUpPanel
	self.showVehicleStageUpPanel = false
	if UIMgr:IsActiveUI(CtrlNames.VehiclesOccupation) then
		UIMgr:ShowUI(CtrlNames.VehiclesOccupation)
		self.vehicleInfoMgr.EventDispatcher:Dispatch(
				self.vehicleInfoMgr.EventType.ChangeProVehiclePanelInfo,showAbilityInfo,l_showVehicleStageUpPanel)
		return
	end
	UIMgr:ActiveUI(CtrlNames.VehiclesOccupation,{
		showAbilityPanel = showAbilityInfo,
		showStageUpPanel = l_showVehicleStageUpPanel,
	})
end
function VehiclesBGCtrl:showVehicleCharacterPanelByVehicleId(defaultChooseVehicleId)
	if defaultChooseVehicleId == nil then
		defaultChooseVehicleId = 0
	end

	if UIMgr:IsActiveUI(CtrlNames.VehiclesCharacteristic) then
		UIMgr:ShowUI(CtrlNames.VehiclesCharacteristic)
		self.vehicleInfoMgr.EventDispatcher:Dispatch(
				self.vehicleInfoMgr.EventType.UpdateVehiclePanelChooseVehicle,defaultChooseVehicleId)
		return
	end

	UIMgr:ActiveUI(CtrlNames.VehiclesCharacteristic,{
		defaultChooseVehicleId = defaultChooseVehicleId,
	})
end
function VehiclesBGCtrl:showPanel(panelName,openParam)
	if UIMgr:IsPanelShowing(panelName) then
		return
	end
	if UIMgr:IsActiveUI(panelName) then
		UIMgr:ShowUI(panelName)
		return
	end
	UIMgr:ActiveUI(panelName,openParam)
end
function VehiclesBGCtrl:closePanel(panelName,isHide)
	if isHide then
		UIMgr:HideUI(panelName)
		return
	end
	UIMgr:DeActiveUI(panelName)
end
--lua custom scripts end
return VehiclesBGCtrl