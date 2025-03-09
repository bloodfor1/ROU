--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ArrowSetupPanel = {}

--lua model end

--lua functions
---@class ArrowSetupPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field title MoonClient.MLuaUICom
---@field tip MoonClient.MLuaUICom
---@field ScrollProp MoonClient.MLuaUICom
---@field noObject MoonClient.MLuaUICom
---@field MountBtn MoonClient.MLuaUICom
---@field info MoonClient.MLuaUICom
---@field equipBtnText MoonClient.MLuaUICom
---@field effTip MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field ArrowItemSelectTemplate MoonClient.MLuaUIGroup

---@return ArrowSetupPanel
---@param ctrl UIBaseCtrl
function ArrowSetupPanel.Bind(ctrl)
	
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
return UI.ArrowSetupPanel