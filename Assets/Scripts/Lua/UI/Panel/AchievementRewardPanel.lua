--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementRewardPanel = {}

--lua model end

--lua functions
---@class AchievementRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TagName2 MoonClient.MLuaUICom
---@field RewardScroll MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PandectPanel MoonClient.MLuaUICom
---@field NeedPointText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field DetailPanel MoonClient.MLuaUICom
---@field DetailName MoonClient.MLuaUICom
---@field DetailLab MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CantAward MoonClient.MLuaUICom
---@field CanAward MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom
---@field Awarded MoonClient.MLuaUICom
---@field RewardItemPrefab MoonClient.MLuaUIGroup

---@return AchievementRewardPanel
---@param ctrl UIBaseCtrl
function AchievementRewardPanel.Bind(ctrl)
	
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
return UI.AchievementRewardPanel