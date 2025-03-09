--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildConstructionPanel = {}

--lua model end

--lua functions
---@class GuildConstructionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TimeCount MoonClient.MLuaUICom
---@field MaskBG MoonClient.MLuaUICom
---@field EffectTime02 MoonClient.MLuaUICom
---@field EffectTime01 MoonClient.MLuaUICom
---@field BtnChoice02 MoonClient.MLuaUICom
---@field BtnChoice01 MoonClient.MLuaUICom

---@return GuildConstructionPanel
function GuildConstructionPanel.Bind(ctrl)

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
return UI.GuildConstructionPanel