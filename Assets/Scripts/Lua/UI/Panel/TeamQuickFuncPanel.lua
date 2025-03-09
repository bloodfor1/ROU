--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamQuickFuncPanel = {}

--lua model end

--lua functions
---@class TeamQuickFuncPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field FucPanel MoonClient.MLuaUICom
---@field FucMemberTpl MoonClient.MLuaUICom
---@field BtnBg MoonClient.MLuaUICom

---@return TeamQuickFuncPanel
function TeamQuickFuncPanel.Bind(ctrl)

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
return UI.TeamQuickFuncPanel