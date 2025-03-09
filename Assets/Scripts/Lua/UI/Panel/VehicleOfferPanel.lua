--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehicleOfferPanel = {}

--lua model end

--lua functions
---@class VehicleOfferPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxName MoonClient.MLuaUICom
---@field TxBtnYesName MoonClient.MLuaUICom
---@field TxAsk MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field BtYes MoonClient.MLuaUICom
---@field BtClose MoonClient.MLuaUICom

---@return VehicleOfferPanel
function VehicleOfferPanel.Bind(ctrl)
	
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
return UI.VehicleOfferPanel