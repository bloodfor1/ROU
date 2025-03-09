--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_StoryPanel = {}

--lua model end

--lua functions
---@class Theme_StoryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TeamPanel MoonClient.MLuaUICom
---@field SpecialTog MoonClient.MLuaUICom
---@field RecordTog MoonClient.MLuaUICom
---@field PassedImg MoonClient.MLuaUICom
---@field InformationScroll MoonClient.MLuaUICom
---@field InformationBtn MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field DungeonName MoonClient.MLuaUICom
---@field DungeonLv MoonClient.MLuaUICom
---@field DownArrow MoonClient.MLuaUICom
---@field DesText MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field BossTog MoonClient.MLuaUICom
---@field BossName MoonClient.MLuaUICom
---@field BossImg MoonClient.MLuaUICom
---@field BeginBtn MoonClient.MLuaUICom
---@field AwardScroll MoonClient.MLuaUICom

---@return Theme_StoryPanel
---@param ctrl UIBase
function Theme_StoryPanel.Bind(ctrl)
	
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
return UI.Theme_StoryPanel