--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CompoundPanel = {}

--lua model end

--lua functions
---@class CompoundPanel.Prefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemPrafabParent MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom

---@class CompoundPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectButton MoonClient.MLuaUICom
---@field Parent MoonClient.MLuaUICom
---@field OnlyCompleteTog MoonClient.MLuaUICom
---@field NumberInput MoonClient.MLuaUICom
---@field NoSelectEquip MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field ForgeEquipButton MoonClient.MLuaUICom
---@field ForgeEffectParent MoonClient.MLuaUICom
---@field EquipItemScroll MoonClient.MLuaUICom
---@field ConsumeParent MoonClient.MLuaUICom
---@field BindTog MoonClient.MLuaUICom
---@field Prefab CompoundPanel.Prefab

---@return CompoundPanel
---@param ctrl UIBaseCtrl
function CompoundPanel.Bind(ctrl)
	
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
return UI.CompoundPanel