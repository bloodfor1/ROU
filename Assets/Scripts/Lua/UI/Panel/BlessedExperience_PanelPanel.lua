--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BlessedExperience_PanelPanel = {}

--lua model end

--lua functions
---@class BlessedExperience_PanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_LeftShow MoonClient.MLuaUICom
---@field TuijianBtn MoonClient.MLuaUICom
---@field MowuBtn MoonClient.MLuaUICom
---@field Job_txt MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_BlessInfo MoonClient.MLuaUICom
---@field BlessTip MoonClient.MLuaUICom
---@field BlessSpeedUpText MoonClient.MLuaUICom
---@field BlessHelpBtn MoonClient.MLuaUICom
---@field BattleTimeHelpBtn MoonClient.MLuaUICom
---@field BattleTime MoonClient.MLuaUICom
---@field BattleState MoonClient.MLuaUICom
---@field Base_txt MoonClient.MLuaUICom
---@field AutoBackTog MoonClient.MLuaUICom

---@return BlessedExperience_PanelPanel
---@param ctrl UIBase
function BlessedExperience_PanelPanel.Bind(ctrl)
	
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
return UI.BlessedExperience_PanelPanel