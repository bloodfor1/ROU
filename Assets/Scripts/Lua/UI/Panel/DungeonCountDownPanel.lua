--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DungeonCountDownPanel = {}

--lua model end

--lua functions
---@class DungeonCountDownPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field NumPanel MoonClient.MLuaUICom
---@field NumLab MoonClient.MLuaUICom
---@field LabPanel MoonClient.MLuaUICom
---@field DesLab MoonClient.MLuaUICom

---@return DungeonCountDownPanel
---@param ctrl UIBaseCtrl
function DungeonCountDownPanel.Bind(ctrl)
	
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
return UI.DungeonCountDownPanel