--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ConnectingPanel = {}

--lua model end

--lua functions
---@class ConnectingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field msgText MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field ConnectingAnim MoonClient.MLuaUICom

---@return ConnectingPanel
---@param ctrl UIBaseCtrl
function ConnectingPanel.Bind(ctrl)
	
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
return UI.ConnectingPanel