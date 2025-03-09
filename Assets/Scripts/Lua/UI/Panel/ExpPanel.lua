--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ExpPanel = {}

--lua model end

--lua functions
---@class ExpPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field sldJobExpBless MoonClient.MLuaUICom
---@field sldJobExp MoonClient.MLuaUICom
---@field sldBaseExpBless MoonClient.MLuaUICom
---@field sldBaseExp MoonClient.MLuaUICom
---@field JobExpTitle MoonClient.MLuaUICom
---@field JobBg MoonClient.MLuaUICom
---@field ExpBg MoonClient.MLuaUICom
---@field BaseExpTitle MoonClient.MLuaUICom

---@return ExpPanel
---@param ctrl UIBase
function ExpPanel.Bind(ctrl)
	
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
return UI.ExpPanel