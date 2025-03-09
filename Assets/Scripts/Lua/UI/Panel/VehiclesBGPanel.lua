--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehiclesBGPanel = {}

--lua model end

--lua functions
---@class VehiclesBGPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog_SpecialVehicle MoonClient.MLuaUICom
---@field Tog_Quality MoonClient.MLuaUICom
---@field Tog_ProVehicle MoonClient.MLuaUICom
---@field Tog_Ability MoonClient.MLuaUICom
---@field Panel_ProChildToggle MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom

---@return VehiclesBGPanel
---@param ctrl UIBase
function VehiclesBGPanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.VehiclesBGPanel