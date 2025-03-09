--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PollyPanel = {}

--lua model end

--lua functions
---@class PollyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Toggle MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field HowToPlay MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom

---@return PollyPanel
function PollyPanel.Bind(ctrl)

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
return UI.PollyPanel