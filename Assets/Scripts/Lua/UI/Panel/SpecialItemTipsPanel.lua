--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SpecialItemTipsPanel = {}

--lua model end

--lua functions
---@class SpecialItemTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field OBJ MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return SpecialItemTipsPanel
function SpecialItemTipsPanel.Bind(ctrl)

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
return UI.SpecialItemTipsPanel