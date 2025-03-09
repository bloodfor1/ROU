--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleTipsPanel = {}

--lua model end

--lua functions
---@class BattleTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tips MoonClient.MLuaUICom
---@field Alarm MoonClient.MLuaUICom

---@return BattleTipsPanel
---@param ctrl UIBaseCtrl
function BattleTipsPanel.Bind(ctrl)
	
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
return UI.BattleTipsPanel