--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RoleNurturance_TipsBtnPanel = {}

--lua model end

--lua functions
---@class RoleNurturance_TipsBtnPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tiredout MoonClient.MLuaUICom
---@field NurturanceEffect MoonClient.MLuaUICom
---@field Healthy MoonClient.MLuaUICom
---@field FactorText MoonClient.MLuaUICom
---@field Factor MoonClient.MLuaUICom
---@field ExpFirstEffect MoonClient.MLuaUICom
---@field ExpEffect MoonClient.MLuaUICom
---@field Btn_Nurturance MoonClient.MLuaUICom
---@field Btn_Exp MoonClient.MLuaUICom

---@return RoleNurturance_TipsBtnPanel
---@param ctrl UIBase
function RoleNurturance_TipsBtnPanel.Bind(ctrl)
	
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
return UI.RoleNurturance_TipsBtnPanel