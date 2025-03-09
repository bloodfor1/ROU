--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DialogPanel = {}

--lua model end

--lua functions
---@class DialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtPlaceholder MoonClient.MLuaUICom
---@field TxtOK MoonClient.MLuaUICom
---@field TxtNo MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field TogLab MoonClient.MLuaUICom
---@field TogHide MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field TextInputStr MoonClient.MLuaUICom
---@field TextInputDesc MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnPraise MoonClient.MLuaUICom
---@field BtnOK MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field PaymentInstructions MoonClient.MLuaUIGroup

---@return DialogPanel
---@param ctrl UIBase
function DialogPanel.Bind(ctrl)
	
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
return UI.DialogPanel