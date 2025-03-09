--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleEndFailPanel = {}

--lua model end

--lua functions
---@class BattleEndFailPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WidgetWin MoonClient.MLuaUICom
---@field WidgetFail MoonClient.MLuaUICom
---@field VictoryPanel MoonClient.MLuaUICom
---@field Txt_ExtraRewardTip MoonClient.MLuaUICom
---@field TimeLab MoonClient.MLuaUICom
---@field Panel_TimeTip MoonClient.MLuaUICom
---@field Panel_ExtraReward MoonClient.MLuaUICom
---@field fx2 MoonClient.MLuaUICom
---@field fx1 MoonClient.MLuaUICom
---@field Effect3 MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field AwardContent MoonClient.MLuaUICom
---@field AssistTxt MoonClient.MLuaUICom

---@return BattleEndFailPanel
---@param ctrl UIBase
function BattleEndFailPanel.Bind(ctrl)
	
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
return UI.BattleEndFailPanel