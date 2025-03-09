--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HymnTrialRoulettePanel = {}

--lua model end

--lua functions
---@class HymnTrialRoulettePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TurnsTxt MoonClient.MLuaUICom
---@field SelectEffectView MoonClient.MLuaUICom
---@field RTBg MoonClient.MLuaUICom
---@field RouletteView MoonClient.MLuaUICom
---@field RoulettePreLoadView MoonClient.MLuaUICom
---@field PlayerView MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field LogTxt MoonClient.MLuaUICom
---@field EventTxt MoonClient.MLuaUICom
---@field EventTextGroup MoonClient.MLuaUICom
---@field BtnQuit MoonClient.MLuaUICom

---@return HymnTrialRoulettePanel
function HymnTrialRoulettePanel.Bind(ctrl)

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
return UI.HymnTrialRoulettePanel