--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DisplacerUsePanel = {}

--lua model end

--lua functions
---@class DisplacerUsePanel.DisplacerEquipItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field RefineLv MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemHole MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsUsedDisplacer MoonClient.MLuaUICom
---@field IsEquiped MoonClient.MLuaUICom
---@field ImgHole4 MoonClient.MLuaUICom
---@field ImgHole3 MoonClient.MLuaUICom
---@field ImgHole2 MoonClient.MLuaUICom
---@field ImgHole1 MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom

---@class DisplacerUsePanel.DisplacerPropertyItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom

---@class DisplacerUsePanel.DisplacerSelectItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class DisplacerUsePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WeaponName MoonClient.MLuaUICom
---@field TitleProperty MoonClient.MLuaUICom
---@field SucceedEffect MoonClient.MLuaUICom
---@field SelectItemUnidentified MoonClient.MLuaUICom
---@field SelectItemRefineLv MoonClient.MLuaUICom
---@field SelectItemRare MoonClient.MLuaUICom
---@field SelectItemImgHole4 MoonClient.MLuaUICom
---@field SelectItemImgHole3 MoonClient.MLuaUICom
---@field SelectItemImgHole2 MoonClient.MLuaUICom
---@field SelectItemImgHole1 MoonClient.MLuaUICom
---@field SelectItemHole MoonClient.MLuaUICom
---@field SelectItemDamage MoonClient.MLuaUICom
---@field PropertyScroll MoonClient.MLuaUICom
---@field ItemBoxDisplacer MoonClient.MLuaUICom
---@field IsNoUse MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field EquipSelectDrop MoonClient.MLuaUICom
---@field EquipItemScroll MoonClient.MLuaUICom
---@field EffectParent MoonClient.MLuaUICom
---@field DisplacerChooseScroll MoonClient.MLuaUICom
---@field DisplacerChoosePanel MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnSelectDisplacer MoonClient.MLuaUICom
---@field BtnDisplacerChooseClose MoonClient.MLuaUICom
---@field BtnDeleteDisplacer MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BlockBg MoonClient.MLuaUICom
---@field DisplacerEquipItemPrefab DisplacerUsePanel.DisplacerEquipItemPrefab
---@field DisplacerPropertyItemPrefab DisplacerUsePanel.DisplacerPropertyItemPrefab
---@field DisplacerSelectItemPrefab DisplacerUsePanel.DisplacerSelectItemPrefab

---@return DisplacerUsePanel
---@param ctrl UIBaseCtrl
function DisplacerUsePanel.Bind(ctrl)
	
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
return UI.DisplacerUsePanel