--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DungeonHintNormalPanel = {}

--lua model end

--lua functions
---@class DungeonHintNormalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsRight MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field HintBG MoonClient.MLuaUICom
---@field DangerBG MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return DungeonHintNormalPanel
---@param ctrl UIBase
function DungeonHintNormalPanel.Bind(ctrl)
	
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
return UI.DungeonHintNormalPanel