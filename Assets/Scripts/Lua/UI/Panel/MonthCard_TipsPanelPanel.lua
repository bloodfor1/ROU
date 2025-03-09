--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MonthCard_TipsPanelPanel = {}

--lua model end

--lua functions
---@class MonthCard_TipsPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ContentText MoonClient.MLuaUICom
---@field BtnText MoonClient.MLuaUICom
---@field Btn_Get MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom

---@return MonthCard_TipsPanelPanel
---@param ctrl UIBase
function MonthCard_TipsPanelPanel.Bind(ctrl)
	
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
return UI.MonthCard_TipsPanelPanel