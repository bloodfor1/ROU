--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShowTeamMemberPanel = {}

--lua model end

--lua functions
---@class ShowTeamMemberPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RoleItem MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field closeButton MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@return ShowTeamMemberPanel
---@param ctrl UIBase
function ShowTeamMemberPanel.Bind(ctrl)
	
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
return UI.ShowTeamMemberPanel