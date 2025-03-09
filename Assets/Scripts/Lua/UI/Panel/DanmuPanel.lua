--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DanmuPanel = {}

--lua model end

--lua functions
---@class DanmuPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextDanmuInstance MoonClient.MLuaUICom
---@field Container MoonClient.MLuaUICom

---@return DanmuPanel
---@param ctrl UIBaseCtrl
function DanmuPanel.Bind(ctrl)
	
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
return UI.DanmuPanel