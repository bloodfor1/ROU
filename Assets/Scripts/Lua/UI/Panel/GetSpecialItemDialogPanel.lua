--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GetSpecialItemDialogPanel = {}

--lua model end

--lua functions
---@class GetSpecialItemDialogPanel.ItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemNumber MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class GetSpecialItemDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TittleBg MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Btn02Txt MoonClient.MLuaUICom
---@field Btn02 MoonClient.MLuaUICom
---@field Btn01Txt MoonClient.MLuaUICom
---@field Btn01 MoonClient.MLuaUICom
---@field ItemTemplate GetSpecialItemDialogPanel.ItemTemplate

---@return GetSpecialItemDialogPanel
function GetSpecialItemDialogPanel.Bind(ctrl)

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
return UI.GetSpecialItemDialogPanel