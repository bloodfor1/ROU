--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipAssistantBGPanel = {}

--lua model end

--lua functions
---@class EquipAssistantBGPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTpl MoonClient.MLuaUICom
---@field Text_Main_Title MoonClient.MLuaUICom
---@field SelectEquipParent MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom

---@return EquipAssistantBGPanel
---@param ctrl UIBaseCtrl
function EquipAssistantBGPanel.Bind(ctrl)
	
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
return UI.EquipAssistantBGPanel