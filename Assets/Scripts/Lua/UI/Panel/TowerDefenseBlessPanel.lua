--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TowerDefenseBlessPanel = {}

--lua model end

--lua functions
---@class TowerDefenseBlessPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field TDBlessScroll MoonClient.MLuaUICom
---@field DetermineButton MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BlessPresentation MoonClient.MLuaUICom
---@field TDBlessPrefab MoonClient.MLuaUIGroup

---@return TowerDefenseBlessPanel
---@param ctrl UIBase
function TowerDefenseBlessPanel.Bind(ctrl)
	
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
return UI.TowerDefenseBlessPanel