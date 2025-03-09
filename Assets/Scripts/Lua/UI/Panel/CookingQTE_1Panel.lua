--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CookingQTE_1Panel = {}

--lua model end

--lua functions
---@class CookingQTE_1Panel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WarningImg MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field SafetyImg MoonClient.MLuaUICom
---@field Fire MoonClient.MLuaUICom
---@field BgMask MoonClient.MLuaUICom

---@return CookingQTE_1Panel
---@param ctrl UIBaseCtrl
function CookingQTE_1Panel.Bind(ctrl)
	
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
return UI.CookingQTE_1Panel