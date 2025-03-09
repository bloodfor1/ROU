--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FullScreenCGPanel = {}

--lua model end

--lua functions
---@class FullScreenCGPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field MovieView MoonClient.MLuaUICom
---@field BtnSkip MoonClient.MLuaUICom

---@return FullScreenCGPanel
function FullScreenCGPanel.Bind(ctrl)

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
return UI.FullScreenCGPanel