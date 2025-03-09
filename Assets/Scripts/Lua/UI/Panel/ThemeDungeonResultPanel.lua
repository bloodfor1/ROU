--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ThemeDungeonResultPanel = {}

--lua model end

--lua functions
---@class ThemeDungeonResultPanel.TeamPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpLab MoonClient.MLuaUICom
---@field UI MoonClient.MLuaUICom
---@field ThumbBtn MoonClient.MLuaUICom
---@field Taken MoonClient.MLuaUICom
---@field PlayerPos MoonClient.MLuaUICom
---@field NameLab MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field IsMy MoonClient.MLuaUICom
---@field Hit MoonClient.MLuaUICom
---@field Heal MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom
---@field AddFriendBtn MoonClient.MLuaUICom

---@class ThemeDungeonResultPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VictoryPanel MoonClient.MLuaUICom
---@field Txt_ExtraRewardTip MoonClient.MLuaUICom
---@field TipsLab MoonClient.MLuaUICom
---@field TimeLab MoonClient.MLuaUICom
---@field ThumbText MoonClient.MLuaUICom
---@field ThumbPanel MoonClient.MLuaUICom
---@field ThemeThumb MoonClient.MLuaUICom
---@field Theme_Desc MoonClient.MLuaUICom
---@field RTBg MoonClient.MLuaUICom
---@field Panel_TimeTip MoonClient.MLuaUICom
---@field Panel_ExtraReward MoonClient.MLuaUICom
---@field HeadIconImg MoonClient.MLuaUICom
---@field GoBtn MoonClient.MLuaUICom
---@field fx2 MoonClient.MLuaUICom
---@field fx1 MoonClient.MLuaUICom
---@field Effect3 MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field ComeBackDes MoonClient.MLuaUICom
---@field ComeBackBtn MoonClient.MLuaUICom
---@field AwardContent MoonClient.MLuaUICom
---@field AssistTxt MoonClient.MLuaUICom
---@field Achievement MoonClient.MLuaUICom
---@field TeamPrefab ThemeDungeonResultPanel.TeamPrefab

---@return ThemeDungeonResultPanel
---@param ctrl UIBase
function ThemeDungeonResultPanel.Bind(ctrl)
	
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
return UI.ThemeDungeonResultPanel