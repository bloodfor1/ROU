--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SchoolPreviewPanel = {}

--lua model end

--lua functions
---@class SchoolPreviewPanel.EquipItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class SchoolPreviewPanel.CardItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtLv MoonClient.MLuaUICom

---@class SchoolPreviewPanel.HeadItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class SchoolPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field line2 MoonClient.MLuaUICom
---@field line MoonClient.MLuaUICom
---@field equipJump MoonClient.MLuaUICom
---@field CoreHeadContent MoonClient.MLuaUICom
---@field CoreEquipContent MoonClient.MLuaUICom
---@field CoreCardContent MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field cardJump MoonClient.MLuaUICom
---@field EquipItem SchoolPreviewPanel.EquipItem
---@field CardItem SchoolPreviewPanel.CardItem
---@field HeadItem SchoolPreviewPanel.HeadItem

---@return SchoolPreviewPanel
function SchoolPreviewPanel.Bind(ctrl)

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
return UI.SchoolPreviewPanel