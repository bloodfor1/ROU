--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiluzCoreResetPanel = {}

--lua model end

--lua functions
---@class BeiluzCoreResetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TopNameRoot MoonClient.MLuaUICom
---@field TopItemName MoonClient.MLuaUICom
---@field TopItemBg MoonClient.MLuaUICom
---@field TopItem MoonClient.MLuaUICom
---@field TipsButton MoonClient.MLuaUICom
---@field State2 MoonClient.MLuaUICom
---@field State1 MoonClient.MLuaUICom
---@field RightSkillColor MoonClient.MLuaUICom[]
---@field RightSkill MoonClient.MLuaUICom[]
---@field ResetButton MoonClient.MLuaUICom
---@field ReplaceButton MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field MiddleSkillColor MoonClient.MLuaUICom[]
---@field MiddleSkill MoonClient.MLuaUICom[]
---@field LeftSkillColor MoonClient.MLuaUICom[]
---@field LeftSkill MoonClient.MLuaUICom[]
---@field ForgeMaterialParent MoonClient.MLuaUICom
---@field EquippedTgl MoonClient.MLuaUICom
---@field EmptyTip2 MoonClient.MLuaUICom
---@field EmptyTip MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field CoreList MoonClient.MLuaUICom
---@field BtnSkillTip MoonClient.MLuaUICom

---@return BeiluzCoreResetPanel
---@param ctrl UIBase
function BeiluzCoreResetPanel.Bind(ctrl)
	
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
return UI.BeiluzCoreResetPanel