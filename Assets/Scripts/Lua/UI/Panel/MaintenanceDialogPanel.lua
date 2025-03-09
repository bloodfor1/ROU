--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MaintenanceDialogPanel = {}

--lua model end

--lua functions
---@class MaintenanceDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TexTitle MoonClient.MLuaUICom
---@field TexMaintenanceEndTime MoonClient.MLuaUICom
---@field TexMaintenanceContent MoonClient.MLuaUICom
---@field BtnOK MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return MaintenanceDialogPanel
---@param ctrl UIBase
function MaintenanceDialogPanel.Bind(ctrl)
	
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
return UI.MaintenanceDialogPanel