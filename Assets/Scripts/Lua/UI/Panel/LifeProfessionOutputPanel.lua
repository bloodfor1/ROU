--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProfessionOutputPanel = {}

--lua model end

--lua functions
---@class LifeProfessionOutputPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field Parent MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return LifeProfessionOutputPanel
function LifeProfessionOutputPanel.Bind(ctrl)

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
return UI.LifeProfessionOutputPanel