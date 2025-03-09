--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AvoidPanelPanel = {}

--lua model end

--lua functions
---@class AvoidPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Start MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field Flag MoonClient.MLuaUICom
---@field End MoonClient.MLuaUICom
---@field Element MoonClient.MLuaUICom
---@field Cursor MoonClient.MLuaUICom

---@return AvoidPanelPanel
---@param ctrl UIBaseCtrl
function AvoidPanelPanel.Bind(ctrl)
	
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
return UI.AvoidPanelPanel