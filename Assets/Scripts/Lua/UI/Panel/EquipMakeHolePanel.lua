--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipMakeHolePanel = {}

--lua model end

--lua functions
---@class EquipMakeHolePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field MaterialsParent MoonClient.MLuaUICom
---@field MaterialsPanel MoonClient.MLuaUICom
---@field MakeHoleButton MoonClient.MLuaUICom
---@field MainPanel MoonClient.MLuaUICom
---@field HoleParent MoonClient.MLuaUICom
---@field EquipName MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field CurrentEquipItemParent MoonClient.MLuaUICom
---@field AllOpenText MoonClient.MLuaUICom

---@return EquipMakeHolePanel
function EquipMakeHolePanel.Bind(ctrl)

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
return UI.EquipMakeHolePanel