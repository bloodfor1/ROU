--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Tips_LagePanel = {}

--lua model end

--lua functions
---@class Tips_LagePanel
---@field PanelRef MoonClient.MLuaUIPanel

---@return Tips_LagePanel
function Tips_LagePanel.Bind(ctrl)
	
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
return UI.Tips_LagePanel