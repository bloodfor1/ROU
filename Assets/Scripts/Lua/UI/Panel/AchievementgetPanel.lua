--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementgetPanel = {}

--lua model end

--lua functions
---@class AchievementgetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Grade MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field CloseBtn2 MoonClient.MLuaUICom
---@field CloseBtn1 MoonClient.MLuaUICom

---@return AchievementgetPanel
---@param ctrl UIBaseCtrl
function AchievementgetPanel.Bind(ctrl)
	
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
return UI.AchievementgetPanel