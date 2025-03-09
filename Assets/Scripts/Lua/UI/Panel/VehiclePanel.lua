--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehiclePanel = {}

--lua model end

--lua functions
---@class VehiclePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VehiclePrompt MoonClient.MLuaUICom
---@field TxSpeedUpCD MoonClient.MLuaUICom
---@field OperatePanel MoonClient.MLuaUICom
---@field ImSpeedUpCD MoonClient.MLuaUICom
---@field BtSpeedUp MoonClient.MLuaUICom
---@field BtRide MoonClient.MLuaUICom
---@field BtFlyUp MoonClient.MLuaUICom
---@field BtFlyDown MoonClient.MLuaUICom
---@field BtBattleRide MoonClient.MLuaUICom
---@field BattleVehiclePrompt MoonClient.MLuaUICom

---@return VehiclePanel
---@param ctrl UIBase
function VehiclePanel.Bind(ctrl)
	
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
return UI.VehiclePanel