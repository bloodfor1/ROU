--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_ConfirmationPanel = {}

--lua model end

--lua functions
---@class Theme_ConfirmationPanel.SceneElementCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field SolutionText MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field EffectText MoonClient.MLuaUICom
---@field EffectName MoonClient.MLuaUICom

---@class Theme_ConfirmationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field SceneTog MoonClient.MLuaUICom
---@field SceneEmpty MoonClient.MLuaUICom
---@field SceneElementScroll MoonClient.MLuaUICom
---@field SceneElement MoonClient.MLuaUICom
---@field RecommendEquipmentScroll MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field EquipTog MoonClient.MLuaUICom
---@field EquipRefineLevel MoonClient.MLuaUICom[]
---@field EquipLevel MoonClient.MLuaUICom[]
---@field Btn_Close MoonClient.MLuaUICom
---@field SceneElementCell Theme_ConfirmationPanel.SceneElementCell

---@return Theme_ConfirmationPanel
---@param ctrl UIBase
function Theme_ConfirmationPanel.Bind(ctrl)
	
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
return UI.Theme_ConfirmationPanel