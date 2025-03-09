--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RebateMonthCardPanel = {}

--lua model end

--lua functions
---@class RebateMonthCardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Price MoonClient.MLuaUICom[]
---@field StatusNotActive MoonClient.MLuaUICom[]
---@field StatusActive MoonClient.MLuaUICom[]
---@field RemainTime MoonClient.MLuaUICom[]
---@field Num_LeftDay MoonClient.MLuaUICom[]
---@field Num_Left_2 MoonClient.MLuaUICom[]
---@field Num_Left MoonClient.MLuaUICom[]
---@field Num_EveryDay_2 MoonClient.MLuaUICom[]
---@field Num_EveryDay MoonClient.MLuaUICom[]
---@field Num_BuyNow MoonClient.MLuaUICom[]
---@field item MoonClient.MLuaUICom[]
---@field Day MoonClient.MLuaUICom[]
---@field Currency_Left_2 MoonClient.MLuaUICom[]
---@field Currency_Left MoonClient.MLuaUICom[]
---@field Currency_EveryDay_2 MoonClient.MLuaUICom[]
---@field Currency_EveryDay MoonClient.MLuaUICom[]
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_QuickAccess MoonClient.MLuaUICom[]
---@field Btn_Buy MoonClient.MLuaUICom[]
---@field Btn_Back MoonClient.MLuaUICom

---@return RebateMonthCardPanel
---@param ctrl UIBase
function RebateMonthCardPanel.Bind(ctrl)
	
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
return UI.RebateMonthCardPanel