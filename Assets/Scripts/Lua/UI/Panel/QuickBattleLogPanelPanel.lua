--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
QuickBattleLogPanelPanel = {}

--lua model end

--lua functions
---@class QuickBattleLogPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtJobExp MoonClient.MLuaUICom
---@field TxtBattleTime MoonClient.MLuaUICom
---@field TxtBaseExp MoonClient.MLuaUICom
---@field ItemContent MoonClient.MLuaUICom
---@field BtnOpenBattleDetail MoonClient.MLuaUICom
---@field BattleLogPanel MoonClient.MLuaUICom

---@return QuickBattleLogPanelPanel
function QuickBattleLogPanelPanel.Bind(ctrl)

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
return UI.QuickBattleLogPanelPanel