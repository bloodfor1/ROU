--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AttributeRecastingPanel = {}

--lua model end

--lua functions
---@class AttributeRecastingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field PropertyPanel MoonClient.MLuaUICom
---@field PreviewButton MoonClient.MLuaUICom
---@field OriginalPropertyParent MoonClient.MLuaUICom
---@field OriginalProperty MoonClient.MLuaUICom
---@field NoNewEnchantProperty MoonClient.MLuaUICom
---@field NewPropertyParent MoonClient.MLuaUICom
---@field NewProperty MoonClient.MLuaUICom
---@field ForgeMaterialParent MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_replace MoonClient.MLuaUICom
---@field Btn_Recast MoonClient.MLuaUICom

---@return AttributeRecastingPanel
---@param ctrl UIBase
function AttributeRecastingPanel.Bind(ctrl)
	
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
return UI.AttributeRecastingPanel