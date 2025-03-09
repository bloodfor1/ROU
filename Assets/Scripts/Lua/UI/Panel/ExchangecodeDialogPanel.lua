--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ExchangecodeDialogPanel = {}

--lua model end

--lua functions
---@class ExchangecodeDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtNo MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom

---@return ExchangecodeDialogPanel
---@param ctrl UIBase
function ExchangecodeDialogPanel.Bind(ctrl)
	
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
return UI.ExchangecodeDialogPanel