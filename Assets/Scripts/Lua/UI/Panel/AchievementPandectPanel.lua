--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementPandectPanel = {}

--lua model end

--lua functions
---@class AchievementPandectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TrophyName MoonClient.MLuaUICom
---@field StarParent MoonClient.MLuaUICom
---@field ShowBadgeButton MoonClient.MLuaUICom
---@field ShareButton MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field ItmeAwardScroll MoonClient.MLuaUICom
---@field ItmeAwardMoreImage MoonClient.MLuaUICom
---@field GetAwardButton MoonClient.MLuaUICom
---@field FunctionAwardScroll MoonClient.MLuaUICom
---@field FunctionAwardMoreImage MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field DetailName MoonClient.MLuaUICom
---@field CantGetAwardButton MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom
---@field AchievementTrophyStarSelectParent MoonClient.MLuaUICom
---@field AchievementTrophyParent MoonClient.MLuaUICom
---@field AchievementPandectItemAwardParent MoonClient.MLuaUICom
---@field AchievementPandectFunctionAwardParent MoonClient.MLuaUICom
---@field AchievementBadgeProgressParent MoonClient.MLuaUICom
---@field AchievementTrophyPrefab MoonClient.MLuaUIGroup
---@field AchievementBadgeProgressPrefab MoonClient.MLuaUIGroup
---@field AchievementTrophyStarSelectPrefab MoonClient.MLuaUIGroup
---@field AchievementPandectFunctionAwardPrefab MoonClient.MLuaUIGroup

---@return AchievementPandectPanel
---@param ctrl UIBase
function AchievementPandectPanel.Bind(ctrl)
	
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
return UI.AchievementPandectPanel