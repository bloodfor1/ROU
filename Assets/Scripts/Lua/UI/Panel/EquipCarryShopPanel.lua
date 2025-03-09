--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipCarryShopPanel = {}

--lua model end

--lua functions
---@class EquipCarryShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field widget_no_item MoonClient.MLuaUICom
---@field widget_item_dummy MoonClient.MLuaUICom
---@field widget_item_container MoonClient.MLuaUICom
---@field widget_container MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field txt_item_name MoonClient.MLuaUICom
---@field txt_item_lv MoonClient.MLuaUICom
---@field txt_item_desc MoonClient.MLuaUICom
---@field txt_insuffcient_mat MoonClient.MLuaUICom
---@field loopscroll_items MoonClient.MLuaUICom
---@field dropdown_type_root MoonClient.MLuaUICom
---@field dropdown_type MoonClient.MLuaUICom
---@field dropdown_lv_root MoonClient.MLuaUICom
---@field dropdown_lv MoonClient.MLuaUICom
---@field btn_hint MoonClient.MLuaUICom
---@field btn_confirm MoonClient.MLuaUICom
---@field btn_close MoonClient.MLuaUICom
---@field ShardItemTemplate MoonClient.MLuaUIGroup

---@return EquipCarryShopPanel
---@param ctrl UIBase
function EquipCarryShopPanel.Bind(ctrl)
	
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
return UI.EquipCarryShopPanel