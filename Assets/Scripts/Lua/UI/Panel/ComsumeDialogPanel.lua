--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ComsumeDialogPanel = {}

--lua model end

--lua functions
---@class ComsumeDialogPanel.ItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemNumber MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class ComsumeDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field TogPanel MoonClient.MLuaUICom
---@field TogLab MoonClient.MLuaUICom
---@field TogHide MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field EquipDialogMask MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field ItemTemplate ComsumeDialogPanel.ItemTemplate

---@return ComsumeDialogPanel
---@param ctrl UIBase
function ComsumeDialogPanel.Bind(ctrl)
	
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
return UI.ComsumeDialogPanel