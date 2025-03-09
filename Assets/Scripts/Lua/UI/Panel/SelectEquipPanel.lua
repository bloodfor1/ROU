--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectEquipPanel = {}

--lua model end

--lua functions
---@class SelectEquipPanel.EquipItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Unidentified MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RefineLv MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemHole MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImgHole4 MoonClient.MLuaUICom
---@field ImgHole3 MoonClient.MLuaUICom
---@field ImgHole2 MoonClient.MLuaUICom
---@field ImgHole1 MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom

---@class SelectEquipPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextName MoonClient.MLuaUICom
---@field SelectEquipPanel MoonClient.MLuaUICom
---@field SelectEquipCloseButton MoonClient.MLuaUICom
---@field OnlyWearToggle MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field EquipSelectButton MoonClient.MLuaUICom
---@field EquipItemScroll MoonClient.MLuaUICom
---@field EquipItemPrefab SelectEquipPanel.EquipItemPrefab

---@return SelectEquipPanel
function SelectEquipPanel.Bind(ctrl)

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
return UI.SelectEquipPanel