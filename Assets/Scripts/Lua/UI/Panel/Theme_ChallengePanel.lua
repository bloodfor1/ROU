--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_ChallengePanel = {}

--lua model end

--lua functions
---@class Theme_ChallengePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WeekLimitText MoonClient.MLuaUICom
---@field WeekLimitSlider MoonClient.MLuaUICom
---@field WeekLimitImg MoonClient.MLuaUICom
---@field WeekAwardText MoonClient.MLuaUICom
---@field WeekAwardSlider MoonClient.MLuaUICom
---@field WeekAwardImg MoonClient.MLuaUICom
---@field TipsBackBtn MoonClient.MLuaUICom
---@field TeamPanel MoonClient.MLuaUICom
---@field Simple MoonClient.MLuaUICom
---@field NormalUpAni MoonClient.MLuaUICom
---@field NormalSelectEffect MoonClient.MLuaUICom
---@field NormalSelect MoonClient.MLuaUICom
---@field NormalMask MoonClient.MLuaUICom
---@field NormalBg MoonClient.MLuaUICom
---@field NormalAwardScroll MoonClient.MLuaUICom
---@field LeftTime MoonClient.MLuaUICom
---@field Help MoonClient.MLuaUICom
---@field HardUpAni MoonClient.MLuaUICom
---@field HardSelectEffect MoonClient.MLuaUICom
---@field HardSelect MoonClient.MLuaUICom
---@field HardMask MoonClient.MLuaUICom
---@field HardBg MoonClient.MLuaUICom
---@field HardAwardScroll MoonClient.MLuaUICom
---@field GuideBtn MoonClient.MLuaUICom
---@field Full MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field DungeonName MoonClient.MLuaUICom
---@field DayLimitText MoonClient.MLuaUICom
---@field DayLimitSlider MoonClient.MLuaUICom
---@field DayLimitImg MoonClient.MLuaUICom
---@field ConfirmBtn MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field BeginBtn MoonClient.MLuaUICom
---@field AwardTips MoonClient.MLuaUICom
---@field AwardTipBtn MoonClient.MLuaUICom
---@field AwardSeparation MoonClient.MLuaUICom
---@field Award MoonClient.MLuaUICom

---@return Theme_ChallengePanel
---@param ctrl UIBase
function Theme_ChallengePanel.Bind(ctrl)
	
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
return UI.Theme_ChallengePanel