--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamApplyPanel = {}

--lua model end

--lua functions
---@class TeamApplyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field OpenNoticeText MoonClient.MLuaUICom
---@field OpenNotice MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field ButtonRefresh MoonClient.MLuaUICom
---@field ButtonClear MoonClient.MLuaUICom
---@field TeamApplyPerTem MoonClient.MLuaUIGroup

---@return TeamApplyPanel
---@param ctrl UIBase
function TeamApplyPanel.Bind(ctrl)
	
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
return UI.TeamApplyPanel