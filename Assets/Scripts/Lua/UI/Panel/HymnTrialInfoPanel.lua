--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HymnTrialInfoPanel = {}

--lua model end

--lua functions
---@class HymnTrialInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtWait MoonClient.MLuaUICom
---@field TxtRound MoonClient.MLuaUICom
---@field TurnTxt MoonClient.MLuaUICom
---@field MongserNumTxt MoonClient.MLuaUICom
---@field InfoPanel MoonClient.MLuaUICom
---@field EventTxt MoonClient.MLuaUICom

---@return HymnTrialInfoPanel
function HymnTrialInfoPanel.Bind(ctrl)

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
return UI.HymnTrialInfoPanel