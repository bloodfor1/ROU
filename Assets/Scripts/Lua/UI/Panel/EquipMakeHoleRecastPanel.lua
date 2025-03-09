--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipMakeHoleRecastPanel = {}

--lua model end

--lua functions
---@class EquipMakeHoleRecastPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReplaceButton MoonClient.MLuaUICom
---@field RecastPropertyParent3 MoonClient.MLuaUICom
---@field RecastPropertyParent2 MoonClient.MLuaUICom
---@field RecastPropertyParent1 MoonClient.MLuaUICom
---@field RecastProperty3 MoonClient.MLuaUICom
---@field RecastButton MoonClient.MLuaUICom
---@field PropertyPreviewParent MoonClient.MLuaUICom
---@field PropertyPreviewPanel MoonClient.MLuaUICom
---@field PropertyPreviewButton MoonClient.MLuaUICom
---@field ItemName2 MoonClient.MLuaUICom
---@field ItemName1 MoonClient.MLuaUICom
---@field ItemIcon2 MoonClient.MLuaUICom
---@field ItemIcon1 MoonClient.MLuaUICom
---@field ItemCount2 MoonClient.MLuaUICom
---@field ItemCount1 MoonClient.MLuaUICom
---@field consume2 MoonClient.MLuaUICom
---@field consume1 MoonClient.MLuaUICom
---@field ClosePropertyPreviewPanelButton MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field EquipMakeHoleRecastPrefab MoonClient.MLuaUIGroup
---@field MakeHolePropertyPreviewPrefab MoonClient.MLuaUIGroup

---@return EquipMakeHoleRecastPanel
function EquipMakeHoleRecastPanel.Bind(ctrl)

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
return UI.EquipMakeHoleRecastPanel