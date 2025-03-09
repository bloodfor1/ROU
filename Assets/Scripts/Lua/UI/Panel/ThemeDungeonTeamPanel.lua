--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ThemeDungeonTeamPanel = {}

--lua model end

--lua functions
---@class ThemeDungeonTeamPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipText MoonClient.MLuaUICom
---@field Tip MoonClient.MLuaUICom
---@field ThemeDungeonSlider MoonClient.MLuaUICom
---@field ThemeDungeonNameLab MoonClient.MLuaUICom
---@field TglAssist MoonClient.MLuaUICom
---@field RefusedBtn MoonClient.MLuaUICom
---@field MercenaryPanel MoonClient.MLuaUICom
---@field InfoItem MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field HeadBg MoonClient.MLuaUICom
---@field DelegateTipIcon MoonClient.MLuaUICom
---@field AssistPanel MoonClient.MLuaUICom
---@field AssistLabTips MoonClient.MLuaUICom
---@field AssistLab MoonClient.MLuaUICom
---@field AgreeBtn MoonClient.MLuaUICom

---@return ThemeDungeonTeamPanel
---@param ctrl UIBase
function ThemeDungeonTeamPanel.Bind(ctrl)
	
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
return UI.ThemeDungeonTeamPanel