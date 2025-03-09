--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementDetailsPanel = {}

--lua model end

--lua functions
---@class AchievementDetailsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field AchievementDetailsParent MoonClient.MLuaUICom
---@field AchievementDetailsPrefab MoonClient.MLuaUIGroup

---@return AchievementDetailsPanel
---@param ctrl UIBaseCtrl
function AchievementDetailsPanel.Bind(ctrl)
	
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
return UI.AchievementDetailsPanel