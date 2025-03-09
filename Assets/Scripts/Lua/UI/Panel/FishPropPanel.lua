--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FishPropPanel = {}

--lua model end

--lua functions
---@class FishPropPanel.FishPropItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field IsUsing MoonClient.MLuaUICom
---@field IsSeclect MoonClient.MLuaUICom

---@class FishPropPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field FishPropItemPrefab FishPropPanel.FishPropItemPrefab

---@return FishPropPanel
function FishPropPanel.Bind(ctrl)

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
return UI.FishPropPanel