--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_NewTaskPanel = {}

--lua model end

--lua functions
---@class Theme_NewTaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field LeftTime MoonClient.MLuaUICom
---@field IsNew MoonClient.MLuaUICom
---@field GotBtn MoonClient.MLuaUICom
---@field DungeonImg MoonClient.MLuaUICom

---@return Theme_NewTaskPanel
---@param ctrl UIBase
function Theme_NewTaskPanel.Bind(ctrl)
	
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
return UI.Theme_NewTaskPanel