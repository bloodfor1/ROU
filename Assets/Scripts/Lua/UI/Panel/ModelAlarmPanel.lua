--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ModelAlarmPanel = {}

--lua model end

--lua functions
---@class ModelAlarmPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalkContent MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field ModelImg MoonClient.MLuaUICom
---@field Layout MoonClient.MLuaUICom

---@return ModelAlarmPanel
function ModelAlarmPanel.Bind(ctrl)

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
return UI.ModelAlarmPanel