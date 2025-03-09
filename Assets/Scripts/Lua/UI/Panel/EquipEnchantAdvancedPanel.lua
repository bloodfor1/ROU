--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipEnchantAdvancedPanel = {}

--lua model end

--lua functions
---@class EquipEnchantAdvancedPanel.NewAttrPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class EquipEnchantAdvancedPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ZenyCoinText MoonClient.MLuaUICom
---@field TipsButton MoonClient.MLuaUICom
---@field StartEffect MoonClient.MLuaUICom
---@field SelectItemButton MoonClient.MLuaUICom
---@field SelectEquipButton MoonClient.MLuaUICom
---@field RemoveEquipButton MoonClient.MLuaUICom
---@field PropertyPanel MoonClient.MLuaUICom
---@field PreviewButton MoonClient.MLuaUICom
---@field OriginalPropertyParent MoonClient.MLuaUICom
---@field OriginalProperty MoonClient.MLuaUICom
---@field NoSelectEquipPosition MoonClient.MLuaUICom
---@field NoSelectEquip MoonClient.MLuaUICom
---@field NoNewEnchantProperty MoonClient.MLuaUICom
---@field NoneText MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field NoEnchant MoonClient.MLuaUICom
---@field NewPropertyParent MoonClient.MLuaUICom
---@field NewProperty MoonClient.MLuaUICom
---@field NewAttrParent MoonClient.MLuaUICom
---@field NewAttributePanel MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field ForgeSucceedEffect MoonClient.MLuaUICom
---@field ForgeMaterialParent MoonClient.MLuaUICom
---@field ForgeEffectParent MoonClient.MLuaUICom
---@field EquipShowPanel MoonClient.MLuaUICom
---@field EquipName MoonClient.MLuaUICom
---@field EquipButtonText MoonClient.MLuaUICom
---@field EndEffect MoonClient.MLuaUICom
---@field EnchantReplaceButton MoonClient.MLuaUICom
---@field EnchantItemParent MoonClient.MLuaUICom
---@field EnchantEquipButton MoonClient.MLuaUICom
---@field EffectCast MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field CurrentEquipItemParent MoonClient.MLuaUICom
---@field ConfirmEnchantEquipButton MoonClient.MLuaUICom
---@field CloseItemButton MoonClient.MLuaUICom
---@field BlessingItemParent MoonClient.MLuaUICom
---@field NewAttrPrefab EquipEnchantAdvancedPanel.NewAttrPrefab

---@return EquipEnchantAdvancedPanel
---@param ctrl UIBase
function EquipEnchantAdvancedPanel.Bind(ctrl)
	
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
return UI.EquipEnchantAdvancedPanel