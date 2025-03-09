--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PaymentInstructionsPanel = {}

--lua model end

--lua functions
---@class PaymentInstructionsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Recharge MoonClient.MLuaUICom
---@field PaymentTipRoot MoonClient.MLuaUICom
---@field NumImmediately_2 MoonClient.MLuaUICom
---@field NumImmediately MoonClient.MLuaUICom
---@field NumEveryday_2 MoonClient.MLuaUICom
---@field NumEveryday MoonClient.MLuaUICom
---@field MonthCardTip MoonClient.MLuaUICom
---@field MonthCard MoonClient.MLuaUICom
---@field Money MoonClient.MLuaUICom
---@field InstructionContent MoonClient.MLuaUICom
---@field CurrencyImmediately_2 MoonClient.MLuaUICom
---@field CurrencyEveryDay_2 MoonClient.MLuaUICom
---@field Currency MoonClient.MLuaUICom
---@field CommodityName MoonClient.MLuaUICom
---@field CommodityIcon MoonClient.MLuaUICom
---@field Commodities MoonClient.MLuaUICom
---@field BtnOK MoonClient.MLuaUICom
---@field BtnInstruction MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field Blank MoonClient.MLuaUICom

---@return PaymentInstructionsPanel
---@param ctrl UIBase
function PaymentInstructionsPanel.Bind(ctrl)
	
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
return UI.PaymentInstructionsPanel