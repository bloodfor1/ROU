--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ExpAchieveTipsPanel = {}

--lua model end

--lua functions
---@class ExpAchieveTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field Title_02 MoonClient.MLuaUICom
---@field Title_01 MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field TeamMemberTpl MoonClient.MLuaUICom
---@field Obj MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemAchievePanel MoonClient.MLuaUICom
---@field ImageCaptain MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field AchieveTpl MoonClient.MLuaUICom

---@return ExpAchieveTipsPanel
function ExpAchieveTipsPanel.Bind(ctrl)

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
return UI.ExpAchieveTipsPanel