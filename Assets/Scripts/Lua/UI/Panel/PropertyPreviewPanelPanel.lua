--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PropertyPreviewPanelPanel = {}

--lua model end

--lua functions
---@class PropertyPreviewPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyPreviewParent MoonClient.MLuaUICom

---@return PropertyPreviewPanelPanel
---@param ctrl UIBase
function PropertyPreviewPanelPanel.Bind(ctrl)
	
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
return UI.PropertyPreviewPanelPanel