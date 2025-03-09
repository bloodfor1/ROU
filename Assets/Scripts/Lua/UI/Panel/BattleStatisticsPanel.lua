--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleStatisticsPanel = {}

--lua model end

--lua functions
---@class BattleStatisticsPanel.BlessStatePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLeftBlessTime MoonClient.MLuaUICom
---@field TxtJobExp MoonClient.MLuaUICom
---@field TxtIsOpen MoonClient.MLuaUICom
---@field TxtBattleTime MoonClient.MLuaUICom
---@field TxtBaseExp MoonClient.MLuaUICom
---@field GetItemContent MoonClient.MLuaUICom
---@field BtnUp_1 MoonClient.MLuaUICom
---@field BtnDown_1 MoonClient.MLuaUICom
---@field BtnCheckLeftBlessTime MoonClient.MLuaUICom

---@class BattleStatisticsPanel.NormalStatePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLeftBlessTime MoonClient.MLuaUICom
---@field TxtJobExp MoonClient.MLuaUICom
---@field TxtIsOpen MoonClient.MLuaUICom
---@field TxtBattleTime MoonClient.MLuaUICom
---@field TxtBaseExp MoonClient.MLuaUICom
---@field MonsterCoinTips MoonClient.MLuaUICom
---@field GetItemContent MoonClient.MLuaUICom
---@field BtnUp MoonClient.MLuaUICom
---@field BtnDown MoonClient.MLuaUICom
---@field BtnCheckLeftBlessTime MoonClient.MLuaUICom
---@field BtnCheckBattleState MoonClient.MLuaUICom

---@class BattleStatisticsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogNormalState MoonClient.MLuaUICom
---@field TogBlessState MoonClient.MLuaUICom
---@field Text_06 MoonClient.MLuaUICom
---@field Text_05 MoonClient.MLuaUICom
---@field Text_04 MoonClient.MLuaUICom
---@field Text_03 MoonClient.MLuaUICom
---@field Text_02 MoonClient.MLuaUICom
---@field Text_01 MoonClient.MLuaUICom
---@field ServerLevelTips MoonClient.MLuaUICom
---@field OtherTips MoonClient.MLuaUICom
---@field Obj_SeverLevel MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BlessStatePanel BattleStatisticsPanel.BlessStatePanel
---@field NormalStatePanel BattleStatisticsPanel.NormalStatePanel

---@return BattleStatisticsPanel
---@param ctrl UIBaseCtrl
function BattleStatisticsPanel.Bind(ctrl)
	
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
return UI.BattleStatisticsPanel