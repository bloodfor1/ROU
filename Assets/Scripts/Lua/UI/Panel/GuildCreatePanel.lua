--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildCreatePanel = {}

--lua model end

--lua functions
---@class GuildCreatePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WordsInput MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field NameInput MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field CostIcon MoonClient.MLuaUICom
---@field CostCount MoonClient.MLuaUICom
---@field BtnZeny MoonClient.MLuaUICom
---@field BtnCreate MoonClient.MLuaUICom
---@field BtnCost MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return GuildCreatePanel
function GuildCreatePanel.Bind(ctrl)

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
return UI.GuildCreatePanel