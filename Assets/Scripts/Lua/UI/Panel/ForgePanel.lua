--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ForgePanel = {}

--lua model end

--lua functions
---@class ForgePanel.PropertyPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyImage MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class ForgePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_ForgeLvHint MoonClient.MLuaUICom
---@field Txt_EquipTips MoonClient.MLuaUICom
---@field ShowEquipTypeTipsButton MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field PropertyTitle MoonClient.MLuaUICom
---@field PropertyParent MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field MainPanel MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field ForgeSucceedEffect MoonClient.MLuaUICom
---@field ForgeModel MoonClient.MLuaUICom
---@field ForgeMaterialParent MoonClient.MLuaUICom
---@field ForgeIcon MoonClient.MLuaUICom
---@field ForgeEquipButton MoonClient.MLuaUICom
---@field EquipShowPanel MoonClient.MLuaUICom
---@field EquipReceiveTaskButton MoonClient.MLuaUICom
---@field EquipPropertyParent MoonClient.MLuaUICom
---@field EquipName MoonClient.MLuaUICom
---@field EquipItemScroll MoonClient.MLuaUICom
---@field EquipDetailPanel MoonClient.MLuaUICom
---@field EquipCancelTaskButton MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Tuijian MoonClient.MLuaUICom
---@field BasePropertyTitle MoonClient.MLuaUICom
---@field BasePropertyText MoonClient.MLuaUICom
---@field BasePropertyIcon MoonClient.MLuaUICom
---@field PropertyPrefab ForgePanel.PropertyPrefab

---@return ForgePanel
---@param ctrl UIBase
function ForgePanel.Bind(ctrl)
	
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
return UI.ForgePanel