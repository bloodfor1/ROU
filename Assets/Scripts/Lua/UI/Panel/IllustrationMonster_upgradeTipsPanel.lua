--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonster_upgradeTipsPanel = {}

--lua model end

--lua functions
---@class IllustrationMonster_upgradeTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tips MoonClient.MLuaUICom
---@field LV MoonClient.MLuaUICom
---@field BonusPar MoonClient.MLuaUICom
---@field Bonus MoonClient.MLuaUICom

---@return IllustrationMonster_upgradeTipsPanel
---@param ctrl UIBase
function IllustrationMonster_upgradeTipsPanel.Bind(ctrl)
	
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
return UI.IllustrationMonster_upgradeTipsPanel