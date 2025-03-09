--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HuntDayPointPanel = {}

--lua model end

--lua functions
---@class HuntDayPointPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PointNum MoonClient.MLuaUICom
---@field ChipNum MoonClient.MLuaUICom
---@field Btn_wenhao MoonClient.MLuaUICom

---@return HuntDayPointPanel
---@param ctrl UIBase
function HuntDayPointPanel.Bind(ctrl)
	
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
return UI.HuntDayPointPanel