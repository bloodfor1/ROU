--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationEquipmentPanel = {}

--lua model end

--lua functions
---@class IllustrationEquipmentPanel.MonsterLimitImageTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterLimitText MoonClient.MLuaUICom

---@class IllustrationEquipmentPanel.IllustrationEquipListPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field EquipFivePrefab MoonClient.MLuaUICom

---@class IllustrationEquipmentPanel.EquipIllustrationSuitTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SuitTitle MoonClient.MLuaUICom
---@field QuestionText MoonClient.MLuaUICom
---@field EquipRandomTip MoonClient.MLuaUICom

---@class IllustrationEquipmentPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NoMatState MoonClient.MLuaUICom
---@field ShowEquipTypeTipsButton MoonClient.MLuaUICom
---@field ScrollEquipment MoonClient.MLuaUICom
---@field ProRecommendScroll MoonClient.MLuaUICom
---@field ProRecommendContent MoonClient.MLuaUICom
---@field ProfessionSelectButton MoonClient.MLuaUICom
---@field GroupSuitAttr MoonClient.MLuaUICom
---@field GroupBaseAttr MoonClient.MLuaUICom
---@field ForgeMatScroll MoonClient.MLuaUICom
---@field EquipTypeText MoonClient.MLuaUICom
---@field EquipTypeSelectText MoonClient.MLuaUICom
---@field EquipTypeSelectButton MoonClient.MLuaUICom
---@field EquipSuit MoonClient.MLuaUICom
---@field EquipSuggestText MoonClient.MLuaUICom
---@field EquipSlotText MoonClient.MLuaUICom
---@field EquipProfessionSelectText MoonClient.MLuaUICom
---@field EquipNotFoundText MoonClient.MLuaUICom
---@field EquipNameText MoonClient.MLuaUICom
---@field EquipLvText MoonClient.MLuaUICom
---@field EquipJobText MoonClient.MLuaUICom
---@field EquipImg MoonClient.MLuaUICom
---@field EquipGetButton MoonClient.MLuaUICom
---@field EquipAttrTip MoonClient.MLuaUICom
---@field EquipAttrText1 MoonClient.MLuaUICom
---@field EquipAttrScroll MoonClient.MLuaUICom
---@field EquipAttrContent MoonClient.MLuaUICom
---@field Dummy_ForgeMatParent MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field ButtonSuit MoonClient.MLuaUICom
---@field Btn_ProRecommend_On MoonClient.MLuaUICom
---@field Btn_ProRecommend_Off MoonClient.MLuaUICom
---@field Btn_ProRecommend MoonClient.MLuaUICom
---@field Btn_ForgeMat_On MoonClient.MLuaUICom
---@field Btn_ForgeMat_Off MoonClient.MLuaUICom
---@field Btn_ForgeMat MoonClient.MLuaUICom
---@field Btn_EquipAttr_On MoonClient.MLuaUICom
---@field Btn_EquipAttr_Off MoonClient.MLuaUICom
---@field Btn_EquipAttr MoonClient.MLuaUICom
---@field MonsterLimitImageTemplate IllustrationEquipmentPanel.MonsterLimitImageTemplate
---@field IllustrationEquipListPrefab IllustrationEquipmentPanel.IllustrationEquipListPrefab
---@field EquipIllustrationSuitTemplate IllustrationEquipmentPanel.EquipIllustrationSuitTemplate

---@return IllustrationEquipmentPanel
---@param ctrl UIBase
function IllustrationEquipmentPanel.Bind(ctrl)
	
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
return UI.IllustrationEquipmentPanel