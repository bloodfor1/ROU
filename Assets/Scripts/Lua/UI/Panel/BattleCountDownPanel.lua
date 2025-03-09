--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleCountDownPanel = {}

--lua model end

--lua functions
---@class BattleCountDownPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Start MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Countdown MoonClient.MLuaUICom

---@return BattleCountDownPanel
---@param ctrl UIBaseCtrl
function BattleCountDownPanel.Bind(ctrl)
	
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
return UI.BattleCountDownPanel