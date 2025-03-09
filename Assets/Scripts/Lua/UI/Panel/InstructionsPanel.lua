--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InstructionsPanel = {}

--lua model end

--lua functions
---@class InstructionsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Content MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return InstructionsPanel
function InstructionsPanel.Bind(ctrl)

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
return UI.InstructionsPanel