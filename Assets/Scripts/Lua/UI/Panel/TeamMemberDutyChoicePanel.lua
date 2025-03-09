--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamMemberDutyChoicePanel = {}

--lua model end

--lua functions
---@class TeamMemberDutyChoicePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Parent MoonClient.MLuaUICom
---@field DummyBtn MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom

---@return TeamMemberDutyChoicePanel
---@param ctrl UIBase
function TeamMemberDutyChoicePanel.Bind(ctrl)
	
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
return UI.TeamMemberDutyChoicePanel