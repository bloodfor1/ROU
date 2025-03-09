--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildCrystalStudyPanel = {}

--lua model end

--lua functions
---@class GuildCrystalStudyPanel.CrystalPropertyChangeItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NextBuffValue MoonClient.MLuaUICom
---@field NextBuffName MoonClient.MLuaUICom
---@field NextBuffBox MoonClient.MLuaUICom
---@field ImgArrow MoonClient.MLuaUICom
---@field CurBuffValue MoonClient.MLuaUICom
---@field CurBuffName MoonClient.MLuaUICom
---@field CurBuffBox MoonClient.MLuaUICom

---@class GuildCrystalStudyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpgradeContent MoonClient.MLuaUICom
---@field StudySpeed MoonClient.MLuaUICom
---@field SelectCrystalName MoonClient.MLuaUICom
---@field PropertyScrollView MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field NextPropertyTitle MoonClient.MLuaUICom
---@field MaxLevelTip MoonClient.MLuaUICom
---@field LimitTipIcon MoonClient.MLuaUICom[]
---@field LimitText MoonClient.MLuaUICom[]
---@field LimitBox2 MoonClient.MLuaUICom
---@field IsStudying MoonClient.MLuaUICom
---@field ExplainText MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainBubble MoonClient.MLuaUICom
---@field CrystalIcon MoonClient.MLuaUICom
---@field BtnStudySpeedHelp MoonClient.MLuaUICom
---@field BtnStudyHelp MoonClient.MLuaUICom
---@field BtnSetStudyBlock MoonClient.MLuaUICom
---@field BtnSetStudy MoonClient.MLuaUICom
---@field BtnQuickUpgrade MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field CrystalPropertyChangeItemPrefab GuildCrystalStudyPanel.CrystalPropertyChangeItemPrefab

---@return GuildCrystalStudyPanel
function GuildCrystalStudyPanel.Bind(ctrl)

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
return UI.GuildCrystalStudyPanel