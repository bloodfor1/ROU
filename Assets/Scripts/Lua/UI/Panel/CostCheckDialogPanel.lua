--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CostCheckDialogPanel = {}

--lua model end

--lua functions
---@class CostCheckDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtNo MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field HaveDetail MoonClient.MLuaUICom
---@field CostDetail MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field PaymentInstructions MoonClient.MLuaUIGroup

---@return CostCheckDialogPanel
---@param ctrl UIBase
function CostCheckDialogPanel.Bind(ctrl)
	
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
return UI.CostCheckDialogPanel