--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildEditorialPositionPanel = {}

--lua model end

--lua functions
---@class GuildEditorialPositionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field NameInput_02 MoonClient.MLuaUICom
---@field NameInput_01 MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnNoEdit02 MoonClient.MLuaUICom
---@field BtnNoEdit01 MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return GuildEditorialPositionPanel
function GuildEditorialPositionPanel.Bind(ctrl)

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
return UI.GuildEditorialPositionPanel