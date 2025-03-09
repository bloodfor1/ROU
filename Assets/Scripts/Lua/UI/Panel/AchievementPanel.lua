--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementPanel = {}

--lua model end

--lua functions
---@class AchievementPanel.AchievementDetailsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitlePrefab MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field StickersPrefab MoonClient.MLuaUICom
---@field StickersLine MoonClient.MLuaUICom
---@field Stickers MoonClient.MLuaUICom
---@field RateText MoonClient.MLuaUICom
---@field PointLine MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field DetailsPanelCloseButton MoonClient.MLuaUICom
---@field AwardTextPrefab MoonClient.MLuaUICom
---@field AwardText MoonClient.MLuaUICom

---@class AchievementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalProgressText2 MoonClient.MLuaUICom
---@field TotalProgressText1 MoonClient.MLuaUICom
---@field TotalProgressSlider2 MoonClient.MLuaUICom
---@field TotalProgressSlider1 MoonClient.MLuaUICom
---@field TagName2 MoonClient.MLuaUICom
---@field TagName1 MoonClient.MLuaUICom
---@field StarParent MoonClient.MLuaUICom
---@field Star5 MoonClient.MLuaUICom
---@field Star3 MoonClient.MLuaUICom
---@field Star2 MoonClient.MLuaUICom
---@field ShowBadgeButton MoonClient.MLuaUICom
---@field ShowAwardButton1 MoonClient.MLuaUICom
---@field ShowAwardButton MoonClient.MLuaUICom
---@field SearchTextParent MoonClient.MLuaUICom
---@field SearchTextPanel MoonClient.MLuaUICom
---@field SearchPanel MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field SearchButton MoonClient.MLuaUICom
---@field ProgressItemParent MoonClient.MLuaUICom
---@field PointAwardRedPrompt1 MoonClient.MLuaUICom
---@field PointAwardRedPrompt MoonClient.MLuaUICom
---@field PandectPanel MoonClient.MLuaUICom
---@field ImageTag MoonClient.MLuaUICom
---@field ClearSearchButton MoonClient.MLuaUICom
---@field ClassifyAchievementPanel MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom
---@field AchievementItemScroll MoonClient.MLuaUICom
---@field AchievementItemPanel MoonClient.MLuaUICom
---@field AchievementButtonParent MoonClient.MLuaUICom
---@field AchievementButton MoonClient.MLuaUIGroup
---@field ProgressItemPrefab MoonClient.MLuaUIGroup
---@field SearchTextTemplate MoonClient.MLuaUIGroup
---@field AchievementItem MoonClient.MLuaUIGroup
---@field AchievementDetailsPanel AchievementPanel.AchievementDetailsPanel

---@return AchievementPanel
---@param ctrl UIBaseCtrl
function AchievementPanel.Bind(ctrl)
	
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
return UI.AchievementPanel