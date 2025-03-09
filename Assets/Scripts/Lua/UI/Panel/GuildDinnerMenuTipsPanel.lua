--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDinnerMenuTipsPanel = {}

--lua model end

--lua functions
---@class GuildDinnerMenuTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RoleView MoonClient.MLuaUICom
---@field DishesTip MoonClient.MLuaUICom
---@field DishesNum MoonClient.MLuaUICom
---@field CookTime MoonClient.MLuaUICom
---@field ChefName MoonClient.MLuaUICom[]
---@field BtnTaste MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom

---@return GuildDinnerMenuTipsPanel
function GuildDinnerMenuTipsPanel.Bind(ctrl)

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
return UI.GuildDinnerMenuTipsPanel