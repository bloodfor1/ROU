--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ReBackPrivilegePanel = {}

--lua model end

--lua functions
---@class ReBackPrivilegePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PrivilegeItemParent MoonClient.MLuaUICom
---@field LeftTimeRoot MoonClient.MLuaUICom
---@field LeftTime MoonClient.MLuaUICom
---@field PrivilegeItemPrefab MoonClient.MLuaUIGroup

---@return ReBackPrivilegePanel
---@param ctrl UIBase
function ReBackPrivilegePanel.Bind(ctrl)
	
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
return UI.ReBackPrivilegePanel