--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildUpgradePanel = {}

--lua model end

--lua functions
---@class GuildUpgradePanel.GuildBuildingScetionItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScetionAText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class GuildUpgradePanel.GuildBuildingItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field IsBuilding MoonClient.MLuaUICom
---@field BuildingIcon MoonClient.MLuaUICom

---@class GuildUpgradePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpgradingPanel MoonClient.MLuaUICom
---@field UpgradeCostPanel MoonClient.MLuaUICom
---@field TimeCount MoonClient.MLuaUICom
---@field ScetionScrollView MoonClient.MLuaUICom
---@field PreviewTitleText MoonClient.MLuaUICom
---@field NormalMsgPanel MoonClient.MLuaUICom
---@field MaxLevelPanel MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field Introduction MoonClient.MLuaUICom
---@field FundText MoonClient.MLuaUICom
---@field FundSlider MoonClient.MLuaUICom
---@field Condition MoonClient.MLuaUICom
---@field BuildingScrollView MoonClient.MLuaUICom
---@field BuildingName MoonClient.MLuaUICom
---@field BuildImg MoonClient.MLuaUICom
---@field BtnUpgradeText MoonClient.MLuaUICom
---@field BtnUpgradeGray MoonClient.MLuaUICom
---@field BtnUpgrade MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnArrowRight MoonClient.MLuaUICom
---@field BtnArrowLeft MoonClient.MLuaUICom
---@field GuildBuildingScetionItemPrefab GuildUpgradePanel.GuildBuildingScetionItemPrefab
---@field GuildBuildingItemPrefab GuildUpgradePanel.GuildBuildingItemPrefab

---@return GuildUpgradePanel
---@param ctrl UIBase
function GuildUpgradePanel.Bind(ctrl)
	
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
return UI.GuildUpgradePanel