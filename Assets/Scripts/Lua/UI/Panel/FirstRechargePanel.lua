--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FirstRechargePanel = {}

--lua model end

--lua functions
---@class FirstRechargePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Received MoonClient.MLuaUICom
---@field ReceiveBtn MoonClient.MLuaUICom
---@field Panel_Cover MoonClient.MLuaUICom
---@field OpenBtn MoonClient.MLuaUICom
---@field ItemScrollContent MoonClient.MLuaUICom
---@field GotoBtn MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CloseBg MoonClient.MLuaUICom
---@field animation MoonClient.MLuaUICom
---@field PaymentInstructions MoonClient.MLuaUIGroup

---@return FirstRechargePanel
---@param ctrl UIBase
function FirstRechargePanel.Bind(ctrl)
	
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
return UI.FirstRechargePanel