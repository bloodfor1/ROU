--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildApplyPanel = {}

--lua model end

--lua functions
---@class GuildApplyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogAutoBtn MoonClient.MLuaUICom
---@field TogAuto MoonClient.MLuaUICom
---@field TipNoApply MoonClient.MLuaUICom
---@field SortIcon MoonClient.MLuaUICom[]
---@field ScrollView MoonClient.MLuaUICom
---@field BtnLetter MoonClient.MLuaUICom[]
---@field BtnIgnoreAll MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAgreeAll MoonClient.MLuaUICom
---@field GuildApplyItemPrefab MoonClient.MLuaUIGroup

---@return GuildApplyPanel
---@param ctrl UIBase
function GuildApplyPanel.Bind(ctrl)
	
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
return UI.GuildApplyPanel