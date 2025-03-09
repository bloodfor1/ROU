--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildOrganizationHanorRankPanel = {}

--lua model end

--lua functions
---@class GuildOrganizationHanorRankPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Scroll_Rank MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Template_GuildOraganizationRank MoonClient.MLuaUIGroup

---@return GuildOrganizationHanorRankPanel
---@param ctrl UIBase
function GuildOrganizationHanorRankPanel.Bind(ctrl)
	
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
return UI.GuildOrganizationHanorRankPanel