--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RecordingPanel = {}

--lua model end

--lua functions
---@class RecordingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtColor MoonClient.MLuaUICom
---@field Send MoonClient.MLuaUICom
---@field Record MoonClient.MLuaUICom
---@field QuanAnim MoonClient.MLuaUICom
---@field Halo1 MoonClient.MLuaUICom
---@field Halo MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CircleAnim MoonClient.MLuaUICom
---@field Back MoonClient.MLuaUICom

---@return RecordingPanel
function RecordingPanel.Bind(ctrl)

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
return UI.RecordingPanel