--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FishResultPanel = {}

--lua model end

--lua functions
---@class FishResultPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field IsLargest MoonClient.MLuaUICom
---@field FishSize MoonClient.MLuaUICom
---@field FishShowView MoonClient.MLuaUICom
---@field FishName MoonClient.MLuaUICom
---@field FishIcon MoonClient.MLuaUICom
---@field EffectView MoonClient.MLuaUICom

---@return FishResultPanel
function FishResultPanel.Bind(ctrl)

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
return UI.FishResultPanel