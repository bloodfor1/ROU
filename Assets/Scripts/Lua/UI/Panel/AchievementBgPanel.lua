--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementBgPanel = {}

--lua model end

--lua functions
---@class AchievementBgPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTpl MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return AchievementBgPanel
---@param ctrl UIBaseCtrl
function AchievementBgPanel.Bind(ctrl)
	
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
return UI.AchievementBgPanel