--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TipsInfoPanel = {}

--lua model end

--lua functions
---@class TipsInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tittle MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return TipsInfoPanel
function TipsInfoPanel.Bind(ctrl)
	
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
return UI.TipsInfoPanel