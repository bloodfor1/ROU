--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
WaitingPanel = {}

--lua model end

--lua functions
---@class WaitingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WaitingAnim MoonClient.MLuaUICom
---@field msgText MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom

---@return WaitingPanel
function WaitingPanel.Bind(ctrl)
	
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
return UI.WaitingPanel