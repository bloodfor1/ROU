--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RefinePanel = {}

--lua model end

--lua functions
---@class RefinePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_SafeHintNormal MoonClient.MLuaUICom
---@field TextExplain MoonClient.MLuaUICom
---@field SuccessRate MoonClient.MLuaUICom
---@field ShowExplainPanelButton MoonClient.MLuaUICom
---@field SelectItemButton MoonClient.MLuaUICom
---@field SelectEquipParent MoonClient.MLuaUICom
---@field SelectEquipButton MoonClient.MLuaUICom
---@field SafeText MoonClient.MLuaUICom
---@field SafeRefineButtonOn MoonClient.MLuaUICom
---@field SafeRefineButtonOff MoonClient.MLuaUICom
---@field RepairPropertyName MoonClient.MLuaUICom
---@field RepairPropertyCount MoonClient.MLuaUICom
---@field RepairPanel MoonClient.MLuaUICom
---@field RepairLevel MoonClient.MLuaUICom
---@field RepairItemParent MoonClient.MLuaUICom
---@field RepairEquipButton MoonClient.MLuaUICom
---@field RemoveEquipButton MoonClient.MLuaUICom
---@field RefinePropertyPanel MoonClient.MLuaUICom
---@field RefinePanel MoonClient.MLuaUICom
---@field RefineName MoonClient.MLuaUICom
---@field RefineMask MoonClient.MLuaUICom
---@field RefineItemParent MoonClient.MLuaUICom
---@field RefineEquipButtonText MoonClient.MLuaUICom
---@field RefineEquipButton MoonClient.MLuaUICom
---@field NonSelectPanel MoonClient.MLuaUICom
---@field NoneText MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field NextMaxLevelText MoonClient.MLuaUICom
---@field MaxPropertyName_2 MoonClient.MLuaUICom
---@field MaxPropertyName_1 MoonClient.MLuaUICom
---@field MaxPropertyName_0 MoonClient.MLuaUICom
---@field MaxPropertyCount_2 MoonClient.MLuaUICom
---@field MaxPropertyCount_1 MoonClient.MLuaUICom
---@field MaxPropertyCount_0 MoonClient.MLuaUICom
---@field MaxLevelText MoonClient.MLuaUICom
---@field MainPanel MoonClient.MLuaUICom
---@field LevelMaxPanel MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field ForgeEffectParent MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field DummyCurrentNextAttr MoonClient.MLuaUICom
---@field DummyCurrentAttr MoonClient.MLuaUICom
---@field CurrentEquipItemParent MoonClient.MLuaUICom
---@field CommonRefineButtonOn MoonClient.MLuaUICom
---@field CommonRefineButtonOff MoonClient.MLuaUICom
---@field CloseItemButton MoonClient.MLuaUICom
---@field CloseExplainPanelButton MoonClient.MLuaUICom
---@field Buttons MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BlessingPanelCloseButton MoonClient.MLuaUICom
---@field BlessingPanel MoonClient.MLuaUICom
---@field BlessingItemSelectButton2 MoonClient.MLuaUICom
---@field BlessingItemSelectButton1 MoonClient.MLuaUICom
---@field BlessingItemParent MoonClient.MLuaUICom
---@field BlessingItemName2 MoonClient.MLuaUICom
---@field BlessingItemName1 MoonClient.MLuaUICom
---@field BlessingItemIcon2 MoonClient.MLuaUICom
---@field BlessingItemIcon1 MoonClient.MLuaUICom
---@field BlessingItemDescription2 MoonClient.MLuaUICom
---@field BlessingItemDescription1 MoonClient.MLuaUICom

---@return RefinePanel
---@param ctrl UIBase
function RefinePanel.Bind(ctrl)
	
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
return UI.RefinePanel