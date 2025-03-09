--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RebateMonthCard_tipsPanel = {}

--lua model end

--lua functions
---@class RebateMonthCard_tipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field Num_Immediatiately MoonClient.MLuaUICom
---@field Num_Everyday MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_cancel MoonClient.MLuaUICom
---@field Btn_buy MoonClient.MLuaUICom

---@return RebateMonthCard_tipsPanel
---@param ctrl UIBase
function RebateMonthCard_tipsPanel.Bind(ctrl)
	
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
return UI.RebateMonthCard_tipsPanel