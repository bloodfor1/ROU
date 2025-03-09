--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TurntablePanel = {}

--lua model end

--lua functions
---@class TurntablePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Table MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom[]
---@field halo MoonClient.MLuaUICom
---@field FxRoot MoonClient.MLuaUICom
---@field Circle16 MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom
---@field BtnStart MoonClient.MLuaUICom
---@field BlockBG MoonClient.MLuaUICom
---@field BG10 MoonClient.MLuaUICom
---@field Arrow10 MoonClient.MLuaUICom

---@return TurntablePanel
function TurntablePanel.Bind(ctrl)
	
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
return UI.TurntablePanel