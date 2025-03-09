--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ConsumeChooseDialogPanel = {}

--lua model end

--lua functions
---@class ConsumeChooseDialogPanel.ItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemNumber MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class ConsumeChooseDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field TogTwoLab MoonClient.MLuaUICom
---@field TogPanel MoonClient.MLuaUICom
---@field TogOneLab MoonClient.MLuaUICom
---@field ToggleTwo MoonClient.MLuaUICom
---@field ToggleOne MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field EquipDialogMask MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnOK MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field ItemTemplate ConsumeChooseDialogPanel.ItemTemplate

---@return ConsumeChooseDialogPanel
---@param ctrl UIBaseCtrl
function ConsumeChooseDialogPanel.Bind(ctrl)
	
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
return UI.ConsumeChooseDialogPanel