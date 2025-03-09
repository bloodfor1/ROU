--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildIconSelectPanel = {}

--lua model end

--lua functions
---@class GuildIconSelectPanel.GuildIconItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field CurImg MoonClient.MLuaUICom

---@class GuildIconSelectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field GuildIconItemPrefab GuildIconSelectPanel.GuildIconItemPrefab

---@return GuildIconSelectPanel
function GuildIconSelectPanel.Bind(ctrl)

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
return UI.GuildIconSelectPanel