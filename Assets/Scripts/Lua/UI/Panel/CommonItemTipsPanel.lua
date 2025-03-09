--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CommonItemTipsPanel = {}

--lua model end

--lua functions
---@class CommonItemTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsPanel MoonClient.MLuaUICom
---@field QualityExplainPanel MoonClient.MLuaUICom
---@field CloseQualityExplainPanelButton MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom

---@return CommonItemTipsPanel
---@param ctrl UIBaseCtrl
function CommonItemTipsPanel.Bind(ctrl)
	
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
return UI.CommonItemTipsPanel