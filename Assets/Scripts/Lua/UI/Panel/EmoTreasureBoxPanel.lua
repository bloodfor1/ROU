--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EmoTreasureBoxPanel = {}

--lua model end

--lua functions
---@class EmoTreasureBoxPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Fx1 MoonClient.MLuaUICom
---@field Fx MoonClient.MLuaUICom

---@return EmoTreasureBoxPanel
---@param ctrl UIBaseCtrl
function EmoTreasureBoxPanel.Bind(ctrl)
	
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
return UI.EmoTreasureBoxPanel