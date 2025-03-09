--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InputpasswordPanel = {}

--lua model end

--lua functions
---@class InputpasswordPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field CodeInput MoonClient.MLuaUICom
---@field CodeBtn MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom

---@return InputpasswordPanel
---@param ctrl UIBase
function InputpasswordPanel.Bind(ctrl)
	
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
return UI.InputpasswordPanel