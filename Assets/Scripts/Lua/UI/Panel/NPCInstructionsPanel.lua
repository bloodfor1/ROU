--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
NPCInstructionsPanel = {}

--lua model end

--lua functions
---@class NPCInstructionsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TmTitle MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return NPCInstructionsPanel
function NPCInstructionsPanel.Bind(ctrl)

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
return UI.NPCInstructionsPanel