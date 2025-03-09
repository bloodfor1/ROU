--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamOfferListPanel = {}

--lua model end

--lua functions
---@class TeamOfferListPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TplTeam MoonClient.MLuaUICom
---@field TeamTarget MoonClient.MLuaUICom
---@field TeamName MoonClient.MLuaUICom
---@field TeamLv MoonClient.MLuaUICom
---@field TeamContent MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field CapName MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnApply MoonClient.MLuaUICom
---@field BG5 MoonClient.MLuaUICom
---@field BG4 MoonClient.MLuaUICom
---@field BG3 MoonClient.MLuaUICom
---@field BG2 MoonClient.MLuaUICom

---@return TeamOfferListPanel
---@param ctrl UIBase
function TeamOfferListPanel.Bind(ctrl)
	
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
return UI.TeamOfferListPanel