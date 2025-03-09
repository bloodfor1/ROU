--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TitlestickerPanel = {}

--lua model end

--lua functions
---@class TitlestickerPanel.TitleCategory
---@field PanelRef MoonClient.MLuaUIPanel
---@field TittleCategory MoonClient.MLuaUICom
---@field TitleContent MoonClient.MLuaUICom
---@field CategoryTog MoonClient.MLuaUICom
---@field CategoryText MoonClient.MLuaUICom

---@class TitlestickerPanel.TitleCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtBg MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TitleCell MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field New MoonClient.MLuaUICom
---@field Collectionicon MoonClient.MLuaUICom
---@field Activated MoonClient.MLuaUICom

---@class TitlestickerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Weijihuo MoonClient.MLuaUICom
---@field UnLockTog MoonClient.MLuaUICom
---@field TitleShareBtn MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TitleLine MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field TimeLimit MoonClient.MLuaUICom
---@field StickerWall MoonClient.MLuaUICom
---@field StickerInfo MoonClient.MLuaUICom
---@field StickerIcon MoonClient.MLuaUICom
---@field StickerGotoBtn MoonClient.MLuaUICom
---@field SortDrop MoonClient.MLuaUICom
---@field ShowStickerBtn MoonClient.MLuaUICom
---@field ShowBtn MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field ReceiveTitleBtn MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSliderText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field Nothing MoonClient.MLuaUICom
---@field NonProgressText MoonClient.MLuaUICom
---@field NonProgress MoonClient.MLuaUICom
---@field LeftScrollDefault MoonClient.MLuaUICom
---@field LeftScrollCategory MoonClient.MLuaUICom
---@field LeftEmpty MoonClient.MLuaUICom
---@field InputClearBtn MoonClient.MLuaUICom
---@field HideBtn MoonClient.MLuaUICom
---@field EquipTitleName MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field DefaultContent MoonClient.MLuaUICom
---@field DeactiveTitleBtn MoonClient.MLuaUICom
---@field ConditionName MoonClient.MLuaUICom
---@field ConditionGotoText MoonClient.MLuaUICom
---@field ConditionGotoBtn MoonClient.MLuaUICom
---@field CategoryContent MoonClient.MLuaUICom
---@field ActiveTitleBtn MoonClient.MLuaUICom
---@field TitleCategory TitlestickerPanel.TitleCategory
---@field TitleCell TitlestickerPanel.TitleCell

---@return TitlestickerPanel
---@param ctrl UIBase
function TitlestickerPanel.Bind(ctrl)
	
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
return UI.TitlestickerPanel