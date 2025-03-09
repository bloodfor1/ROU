--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementGetBadgePanel = {}

--lua model end

--lua functions
---@class AchievementGetBadgePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field StarParent MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Btn_GO MoonClient.MLuaUICom
---@field Bottom MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field AchievementBadgeAwardParent MoonClient.MLuaUICom
---@field AchievementGetBadgeStarPrefab MoonClient.MLuaUIGroup
---@field AchievementBadgeAwardPrefab MoonClient.MLuaUIGroup

---@return AchievementGetBadgePanel
---@param ctrl UIBase
function AchievementGetBadgePanel.Bind(ctrl)
	
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
return UI.AchievementGetBadgePanel