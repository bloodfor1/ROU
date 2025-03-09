--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ThemeArroundPanel = {}

--lua model end

--lua functions
---@class ThemeArroundPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTitle MoonClient.MLuaUICom
---@field TextLv MoonClient.MLuaUICom
---@field TextKey MoonClient.MLuaUICom
---@field TextAffix MoonClient.MLuaUICom
---@field ScrollviewHard MoonClient.MLuaUICom
---@field ScrollViewAffix MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RewardTextTitle MoonClient.MLuaUICom
---@field RewardTextDesc MoonClient.MLuaUICom
---@field RewardScrollview MoonClient.MLuaUICom
---@field RewardContent MoonClient.MLuaUICom
---@field PushKeyPanel MoonClient.MLuaUICom
---@field PanelMain MoonClient.MLuaUICom
---@field Notice MoonClient.MLuaUICom
---@field NormalTextDesc MoonClient.MLuaUICom
---@field NormalSelected MoonClient.MLuaUICom
---@field NormalPanel MoonClient.MLuaUICom
---@field NormalLocked MoonClient.MLuaUICom
---@field Normal MoonClient.MLuaUICom
---@field ModelTailFxImg MoonClient.MLuaUICom
---@field ModelImg MoonClient.MLuaUICom
---@field ModelImageRT MoonClient.MLuaUICom
---@field ModelFxImg MoonClient.MLuaUICom
---@field Locked MoonClient.MLuaUICom
---@field LabelLocked MoonClient.MLuaUICom
---@field ImageUp MoonClient.MLuaUICom
---@field ImageRT MoonClient.MLuaUICom
---@field ImageRewardTitle MoonClient.MLuaUICom
---@field ImageDown MoonClient.MLuaUICom
---@field HardSelected MoonClient.MLuaUICom
---@field HardPanel MoonClient.MLuaUICom
---@field HardKeyCollider MoonClient.MLuaUICom
---@field HardItemParent MoonClient.MLuaUICom
---@field Hard MoonClient.MLuaUICom
---@field EasyEquipFlag MoonClient.MLuaUICom
---@field Collider MoonClient.MLuaUICom
---@field ButtonTeam MoonClient.MLuaUICom
---@field ButtonForward MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field ButtonArrow MoonClient.MLuaUICom
---@field ButtonAffix MoonClient.MLuaUICom
---@field AnimPoint MoonClient.MLuaUICom
---@field AffixPanelMask MoonClient.MLuaUICom
---@field affixPanelBg MoonClient.MLuaUICom
---@field AffixPanel MoonClient.MLuaUICom
---@field AffixDetailContent MoonClient.MLuaUICom
---@field AffixContent MoonClient.MLuaUICom
---@field ThemeDungeonHardItem MoonClient.MLuaUIGroup
---@field ThemeDungeonAffix MoonClient.MLuaUIGroup
---@field ThemeDungeonAffixItem MoonClient.MLuaUIGroup

---@return ThemeArroundPanel
function ThemeArroundPanel.Bind(ctrl)

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
return UI.ThemeArroundPanel