--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ItemAchieveTipsNewPanel = {}

--lua model end

--lua functions
---@class ItemAchieveTipsNewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TargetScrollRect MoonClient.MLuaUICom
---@field TargetPanel MoonClient.MLuaUICom
---@field ItemAchieveScrollRect MoonClient.MLuaUICom
---@field ItemAchievePanel MoonClient.MLuaUICom
---@field CloseTip MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field ItemAchieveTpl MoonClient.MLuaUIGroup
---@field ItemAchieveTargetTpl MoonClient.MLuaUIGroup

---@return ItemAchieveTipsNewPanel
---@param ctrl UIBase
function ItemAchieveTipsNewPanel.Bind(ctrl)
	
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
return UI.ItemAchieveTipsNewPanel