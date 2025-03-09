--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TimelimitpayPanel = {}

--lua model end

--lua functions
---@class TimelimitpayPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkeletonGraphic MoonClient.MLuaUICom
---@field SecText MoonClient.MLuaUICom
---@field PreviewProIntroduce MoonClient.MLuaUICom
---@field MinText MoonClient.MLuaUICom
---@field HourText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field TimelimitpayTemplate MoonClient.MLuaUIGroup

---@return TimelimitpayPanel
function TimelimitpayPanel.Bind(ctrl)
	
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
return UI.TimelimitpayPanel