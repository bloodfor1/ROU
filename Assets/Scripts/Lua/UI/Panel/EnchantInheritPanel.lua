--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EnchantInheritPanel = {}

--lua model end

--lua functions
---@class EnchantInheritPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TransferPanel MoonClient.MLuaUICom
---@field transferholo2 MoonClient.MLuaUICom
---@field TextRightHint MoonClient.MLuaUICom
---@field TextRightEquipName MoonClient.MLuaUICom
---@field TextLeftHint MoonClient.MLuaUICom
---@field TextLeftEquipName MoonClient.MLuaUICom
---@field Text_Enchant_Inherit MoonClient.MLuaUICom
---@field ShowExplainPanelButton MoonClient.MLuaUICom
---@field RightSelectEquipButton MoonClient.MLuaUICom
---@field RightRemoveEquipButton MoonClient.MLuaUICom
---@field RightEquipItemParent MoonClient.MLuaUICom
---@field RefineTransferItemParent MoonClient.MLuaUICom
---@field NoEnchantTag MoonClient.MLuaUICom
---@field NoEnchant MoonClient.MLuaUICom
---@field LeftSelectEquipButton MoonClient.MLuaUICom
---@field LeftRemoveEquipButton MoonClient.MLuaUICom
---@field LeftEquipItemParent MoonClient.MLuaUICom
---@field ItemDialogParent MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field IconButtonRight MoonClient.MLuaUICom
---@field IconButtonLeft MoonClient.MLuaUICom
---@field Halo1 MoonClient.MLuaUICom
---@field EnchantParent MoonClient.MLuaUICom
---@field Dummy_NoEquip MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field Container_Mat MoonClient.MLuaUICom
---@field Button_Confirm MoonClient.MLuaUICom

---@return EnchantInheritPanel
---@param ctrl UIBase
function EnchantInheritPanel.Bind(ctrl)
	
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
return UI.EnchantInheritPanel