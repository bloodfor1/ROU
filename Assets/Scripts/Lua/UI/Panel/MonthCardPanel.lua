--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MonthCardPanel = {}

--lua model end

--lua functions
---@class MonthCardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RingScrollRect MoonClient.MLuaUICom
---@field Panel_TwoShowItem MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field Btn_ChangeRight MoonClient.MLuaUICom
---@field Btn_ChangeLeft MoonClient.MLuaUICom
---@field Show_Item MoonClient.MLuaUIGroup

---@return MonthCardPanel
---@param ctrl UIBase
function MonthCardPanel.Bind(ctrl)
	
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
return UI.MonthCardPanel