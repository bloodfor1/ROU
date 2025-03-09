--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
QuickTeamPanelPanel = {}

--lua model end

--lua functions
---@class QuickTeamPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Team MoonClient.MLuaUICom
---@field Txt_One MoonClient.MLuaUICom
---@field timeLab2 MoonClient.MLuaUICom
---@field timeLab MoonClient.MLuaUICom
---@field TeamSearch MoonClient.MLuaUICom
---@field TeamPassive MoonClient.MLuaUICom
---@field TeamPanel MoonClient.MLuaUICom
---@field TeamMercenary MoonClient.MLuaUICom
---@field TeamMemberTpl MoonClient.MLuaUICom
---@field TeamCreate MoonClient.MLuaUICom
---@field TeamCoordination MoonClient.MLuaUICom
---@field TeamaggregateText1 MoonClient.MLuaUICom
---@field TeamaggregateText MoonClient.MLuaUICom
---@field Teamaggregate MoonClient.MLuaUICom
---@field TeamAddTpl MoonClient.MLuaUICom
---@field reduceBuff MoonClient.MLuaUICom
---@field ProfessionImage MoonClient.MLuaUICom
---@field NotInTeamPanel MoonClient.MLuaUICom
---@field MercenaryText MoonClient.MLuaUICom
---@field Mercenary MoonClient.MLuaUICom
---@field InTeamPanel MoonClient.MLuaUICom
---@field InTeamLayout MoonClient.MLuaUICom
---@field ImageMercenary MoonClient.MLuaUICom
---@field ImageFollow MoonClient.MLuaUICom
---@field ImageCaptain MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field icon2 MoonClient.MLuaUICom
---@field icon1 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field ChangePanelTeam MoonClient.MLuaUICom
---@field ChangePanelOne MoonClient.MLuaUICom
---@field buffList MoonClient.MLuaUICom
---@field Buff MoonClient.MLuaUICom
---@field BtnChangePanel MoonClient.MLuaUICom
---@field BtnArrow MoonClient.MLuaUICom
---@field addBuff MoonClient.MLuaUICom

---@return QuickTeamPanelPanel
---@param ctrl UIBase
function QuickTeamPanelPanel.Bind(ctrl)
	
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
return UI.QuickTeamPanelPanel