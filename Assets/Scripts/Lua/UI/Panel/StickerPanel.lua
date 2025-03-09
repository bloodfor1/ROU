--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
StickerPanel = {}

--lua model end

--lua functions
---@class StickerPanel.StickItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ValidMask MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field InvalidMask MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field AwardRawImg MoonClient.MLuaUICom
---@field AddImg MoonClient.MLuaUICom

---@class StickerPanel.StickerScrollItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtBg MoonClient.MLuaUICom
---@field Txt MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class StickerPanel.StickerGridDetailCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field StickerGridDetailCell MoonClient.MLuaUICom
---@field SelectImg MoonClient.MLuaUICom
---@field Reach MoonClient.MLuaUICom
---@field NotReached MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field AttributeDes MoonClient.MLuaUICom
---@field AchievementText MoonClient.MLuaUICom
---@field AchievementSliderText MoonClient.MLuaUICom
---@field AchievementSlider MoonClient.MLuaUICom
---@field AchievementDes MoonClient.MLuaUICom

---@class StickerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Yiyongyou MoonClient.MLuaUICom
---@field Weiyongyou MoonClient.MLuaUICom
---@field UnlockTog MoonClient.MLuaUICom
---@field Toggroup MoonClient.MLuaUICom
---@field Tog MoonClient.MLuaUICom
---@field TitleShareBtn MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TitleLine MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field StickerWall MoonClient.MLuaUICom
---@field StickerShareBtn MoonClient.MLuaUICom
---@field StickerIcon MoonClient.MLuaUICom
---@field StickerDetail MoonClient.MLuaUICom
---@field StickerContent MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSliderText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field Nothing MoonClient.MLuaUICom
---@field NonProgressText MoonClient.MLuaUICom
---@field NonProgress MoonClient.MLuaUICom
---@field LeftEmpty MoonClient.MLuaUICom
---@field GridDetailContent MoonClient.MLuaUICom
---@field GridDetail MoonClient.MLuaUICom
---@field ConditionName MoonClient.MLuaUICom
---@field ConditionGotoText MoonClient.MLuaUICom
---@field ConditionGotoBtn MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field StickItemTemplate StickerPanel.StickItemTemplate
---@field StickerScrollItemTemplate StickerPanel.StickerScrollItemTemplate
---@field StickerGridDetailCell StickerPanel.StickerGridDetailCell

---@return StickerPanel
---@param ctrl UIBase
function StickerPanel.Bind(ctrl)
	
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
return UI.StickerPanel