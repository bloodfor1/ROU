--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DisplacerMakePanel = {}

--lua model end

--lua functions
---@class DisplacerMakePanel.DisplacerMakeItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockText MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field DisplacerIcon MoonClient.MLuaUICom
---@field CanMakeFlag MoonClient.MLuaUICom

---@class DisplacerMakePanel.DisplacerPropertyItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom

---@class DisplacerMakePanel.DisplacerMaterialSelectItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class DisplacerMakePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsPanel MoonClient.MLuaUICom
---@field TipDescribe MoonClient.MLuaUICom
---@field SuccessRateText MoonClient.MLuaUICom
---@field SucceedEffect MoonClient.MLuaUICom
---@field SelectDrop MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field PropertyScroll MoonClient.MLuaUICom
---@field MaterialChooseScroll MoonClient.MLuaUICom
---@field MaterialChoosePanel MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field ItemBoxChoose2 MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field EffectParent MoonClient.MLuaUICom
---@field DisplacerName MoonClient.MLuaUICom
---@field CostBoxChoose2 MoonClient.MLuaUICom
---@field CostBaseBox MoonClient.MLuaUICom
---@field BtnTipShow MoonClient.MLuaUICom
---@field BtnTipClose MoonClient.MLuaUICom
---@field BtnSelectChoose2 MoonClient.MLuaUICom
---@field BtnMaterialChooseClose MoonClient.MLuaUICom
---@field BtnMake MoonClient.MLuaUICom
---@field BtnDeleteChoose2 MoonClient.MLuaUICom
---@field BtnArrowRight MoonClient.MLuaUICom
---@field BtnArrowLeft MoonClient.MLuaUICom
---@field DisplacerMakeItemPrefab DisplacerMakePanel.DisplacerMakeItemPrefab
---@field DisplacerPropertyItemPrefab DisplacerMakePanel.DisplacerPropertyItemPrefab
---@field DisplacerMaterialSelectItemPrefab DisplacerMakePanel.DisplacerMaterialSelectItemPrefab

---@return DisplacerMakePanel
---@param ctrl UIBaseCtrl
function DisplacerMakePanel.Bind(ctrl)
	
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
return UI.DisplacerMakePanel