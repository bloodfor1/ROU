--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipAttrPanelDummyPanel = {}

--lua model end

--lua functions
---@class EquipAttrPanelDummyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field AttrDummyRight MoonClient.MLuaUICom
---@field AttrDummyLeft MoonClient.MLuaUICom

---@return EquipAttrPanelDummyPanel
---@param ctrl UIBase
function EquipAttrPanelDummyPanel.Bind(ctrl)
	
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
return UI.EquipAttrPanelDummyPanel