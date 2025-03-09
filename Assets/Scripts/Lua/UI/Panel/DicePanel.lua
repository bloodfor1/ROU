--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DicePanel = {}

--lua model end

--lua functions
---@class DicePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field DiceFx MoonClient.MLuaUICom

---@return DicePanel
---@param ctrl UIBase
function DicePanel.Bind(ctrl)
	
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
return UI.DicePanel