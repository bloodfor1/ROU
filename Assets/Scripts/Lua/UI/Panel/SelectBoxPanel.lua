--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectBoxPanel = {}

--lua model end

--lua functions
---@class SelectBoxPanel.SelectBoxCellPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectText MoonClient.MLuaUICom
---@field SelectIcon MoonClient.MLuaUICom
---@field SelectCellButton MoonClient.MLuaUICom

---@class SelectBoxPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field YesButton MoonClient.MLuaUICom
---@field SelectBoxCellParent MoonClient.MLuaUICom
---@field NoButton MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field CloseBgButton MoonClient.MLuaUICom
---@field SelectBoxCellPrefab SelectBoxPanel.SelectBoxCellPrefab

---@return SelectBoxPanel
function SelectBoxPanel.Bind(ctrl)

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
return UI.SelectBoxPanel