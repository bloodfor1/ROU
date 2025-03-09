--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ArenaSettlementPanel = {}

--lua model end

--lua functions
---@class ArenaSettlementPanel.ArenaSettleRoleItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field RoleItem MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom

---@class ArenaSettlementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field SaveBtn MoonClient.MLuaUICom
---@field RoleGroup MoonClient.MLuaUICom
---@field MobileBtn MoonClient.MLuaUICom
---@field MetalCount MoonClient.MLuaUICom
---@field ArenaSettleRoleItem ArenaSettlementPanel.ArenaSettleRoleItem

---@return ArenaSettlementPanel
---@param ctrl UIBaseCtrl
function ArenaSettlementPanel.Bind(ctrl)
	
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
return UI.ArenaSettlementPanel