--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildBanquetPanel = {}

--lua model end

--lua functions
---@class GuildBanquetPanel.GuildDinnerDishItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field RankNum MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field CookText MoonClient.MLuaUICom

---@class GuildBanquetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Menu MoonClient.MLuaUICom
---@field Closed MoonClient.MLuaUICom
---@field GuildDinnerDishItemPrefab GuildBanquetPanel.GuildDinnerDishItemPrefab

---@return GuildBanquetPanel
function GuildBanquetPanel.Bind(ctrl)

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
return UI.GuildBanquetPanel