--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GameHelpPanel = {}

--lua model end

--lua functions
---@class GameHelpPanel.GameHelpItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class GameHelpPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field NextBtn MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BtnText MoonClient.MLuaUICom
---@field GameHelpItem GameHelpPanel.GameHelpItem

---@return GameHelpPanel
function GameHelpPanel.Bind(ctrl)

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
return UI.GameHelpPanel