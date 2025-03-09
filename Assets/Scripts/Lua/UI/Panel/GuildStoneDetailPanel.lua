--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildStoneDetailPanel = {}

--lua model end

--lua functions
---@class GuildStoneDetailPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogNow MoonClient.MLuaUICom
---@field TogAll MoonClient.MLuaUICom
---@field StoneQuestion MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field StoneHelp MoonClient.MLuaUIGroup

---@return GuildStoneDetailPanel
---@param ctrl UIBase
function GuildStoneDetailPanel.Bind(ctrl)
	
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
return UI.GuildStoneDetailPanel