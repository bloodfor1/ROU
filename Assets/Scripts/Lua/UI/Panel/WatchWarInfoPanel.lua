--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
WatchWarInfoPanel = {}

--lua model end

--lua functions
---@class WatchWarInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field NumberText MoonClient.MLuaUICom
---@field FabulousText MoonClient.MLuaUICom
---@field Anchor MoonClient.MLuaUICom

---@return WatchWarInfoPanel
function WatchWarInfoPanel.Bind(ctrl)
	
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
return UI.WatchWarInfoPanel