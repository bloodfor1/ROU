--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AchievementGetBadgeAwardPanel = {}

--lua model end

--lua functions
---@class AchievementGetBadgeAwardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TextInfo MoonClient.MLuaUICom
---@field OKButton MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemAwardScroll MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field AchievementItemAwardParent MoonClient.MLuaUICom

---@return AchievementGetBadgeAwardPanel
---@param ctrl UIBase
function AchievementGetBadgeAwardPanel.Bind(ctrl)
	
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
return UI.AchievementGetBadgeAwardPanel