--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipEnchantPreviewPanel = {}

--lua model end

--lua functions
---@class EquipEnchantPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyPreviewParent3 MoonClient.MLuaUICom
---@field PropertyPreviewParent2 MoonClient.MLuaUICom
---@field PropertyPreviewParent1 MoonClient.MLuaUICom
---@field PreviewParent MoonClient.MLuaUICom
---@field ClosePreviewButton MoonClient.MLuaUICom
---@field EnchantPlayerPropertyPreviewPrefab MoonClient.MLuaUIGroup
---@field EnchantCommonPropertyPreviewPrefab MoonClient.MLuaUIGroup
---@field EnchantBuffPropertyPreviewPrefab MoonClient.MLuaUIGroup

---@return EquipEnchantPreviewPanel
---@param ctrl UIBaseCtrl
function EquipEnchantPreviewPanel.Bind(ctrl)
	
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
return UI.EquipEnchantPreviewPanel