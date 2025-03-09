--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamOfferPanel = {}

--lua model end

--lua functions
---@class TeamOfferPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextName MoonClient.MLuaUICom
---@field TextInfo MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field CaptainLv MoonClient.MLuaUICom
---@field ButtonJoinTxt MoonClient.MLuaUICom
---@field ButtonJoin MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btnspread MoonClient.MLuaUICom
---@field BG5 MoonClient.MLuaUICom
---@field BG4 MoonClient.MLuaUICom
---@field BG3 MoonClient.MLuaUICom
---@field BG2 MoonClient.MLuaUICom
---@field BG1 MoonClient.MLuaUICom

---@return TeamOfferPanel
function TeamOfferPanel.Bind(ctrl)

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
return UI.TeamOfferPanel