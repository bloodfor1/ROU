--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeammatePanel = {}

--lua model end

--lua functions
---@class TeammatePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field RefreshBtn MoonClient.MLuaUICom
---@field GHMateInvitePrefab MoonClient.MLuaUIGroup

---@return TeammatePanel
---@param ctrl UIBase
function TeammatePanel.Bind(ctrl)
	
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
return UI.TeammatePanel