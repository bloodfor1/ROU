--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectElementPanel = {}

--lua model end

--lua functions
---@class SelectElementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTpl MoonClient.MLuaUICom
---@field Root MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return SelectElementPanel
function SelectElementPanel.Bind(ctrl)

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
return UI.SelectElementPanel