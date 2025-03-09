--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TowerDefenseSpiritCommandPanel = {}

--lua model end

--lua functions
---@class TowerDefenseSpiritCommandPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollRect MoonClient.MLuaUICom
---@field TowerDefenseSpiritCommandPrefab MoonClient.MLuaUIGroup

---@return TowerDefenseSpiritCommandPanel
---@param ctrl UIBase
function TowerDefenseSpiritCommandPanel.Bind(ctrl)
	
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
return UI.TowerDefenseSpiritCommandPanel