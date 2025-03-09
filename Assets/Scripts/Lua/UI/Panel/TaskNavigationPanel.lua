--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TaskNavigationPanel = {}

--lua model end

--lua functions
---@class TaskNavigationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TargetText_5 MoonClient.MLuaUICom
---@field TargetText_4 MoonClient.MLuaUICom
---@field TargetText_3 MoonClient.MLuaUICom
---@field TargetText_2 MoonClient.MLuaUICom
---@field TargetText_1 MoonClient.MLuaUICom
---@field TargetList MoonClient.MLuaUICom
---@field Target_5 MoonClient.MLuaUICom
---@field Target_4 MoonClient.MLuaUICom
---@field Target_3 MoonClient.MLuaUICom
---@field Target_2 MoonClient.MLuaUICom
---@field Target_1 MoonClient.MLuaUICom

---@return TaskNavigationPanel
function TaskNavigationPanel.Bind(ctrl)

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
return UI.TaskNavigationPanel