--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleMvpMaskPanel = {}

--lua model end

--lua functions
---@class BattleMvpMaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Effect3 MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect1 MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@return BattleMvpMaskPanel
---@param ctrl UIBaseCtrl
function BattleMvpMaskPanel.Bind(ctrl)
	
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
return UI.BattleMvpMaskPanel