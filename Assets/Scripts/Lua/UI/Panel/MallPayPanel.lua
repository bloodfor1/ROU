--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallPayPanel = {}

--lua model end

--lua functions
---@class MallPayPanel
---@field PanelRef MoonClient.MLuaUIPanel

---@return MallPayPanel
---@param ctrl UIBase
function MallPayPanel.Bind(ctrl)
	
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
return UI.MallPayPanel