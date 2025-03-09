--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MazeDungeonWheelPanel = {}

--lua model end

--lua functions
---@class MazeDungeonWheelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TargetTxt MoonClient.MLuaUICom
---@field PanelEntry MoonClient.MLuaUICom

---@return MazeDungeonWheelPanel
function MazeDungeonWheelPanel.Bind(ctrl)

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
return UI.MazeDungeonWheelPanel