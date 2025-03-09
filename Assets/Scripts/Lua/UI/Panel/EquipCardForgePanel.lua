--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipCardForgePanel = {}

--lua model end

--lua functions
---@class EquipCardForgePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Txt_InsertCardEquipName MoonClient.MLuaUICom
---@field ShowDetailsButton MoonClient.MLuaUICom
---@field ScrollRect MoonClient.MLuaUICom
---@field RemoveCardButton MoonClient.MLuaUICom
---@field NoSelectEquip MoonClient.MLuaUICom
---@field NoneHoleMask MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field MapBtn MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field ForgeEffectParent MoonClient.MLuaUICom
---@field EquipShowPanel MoonClient.MLuaUICom
---@field EquipButton MoonClient.MLuaUICom
---@field CurrentEquipItemParent MoonClient.MLuaUICom
---@field CurrentAttrParent MoonClient.MLuaUICom
---@field CardUI MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field AttrPrefab MoonClient.MLuaUIGroup
---@field CardItemPrefab MoonClient.MLuaUIGroup

---@return EquipCardForgePanel
---@param ctrl UIBase
function EquipCardForgePanel.Bind(ctrl)
	
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
return UI.EquipCardForgePanel