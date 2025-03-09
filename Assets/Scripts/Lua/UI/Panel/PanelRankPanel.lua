--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PanelRankPanel = {}

--lua model end

--lua functions
---@class PanelRankPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field Score MoonClient.MLuaUICom
---@field RankText MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field JobName MoonClient.MLuaUICom
---@field HeadDummySelf MoonClient.MLuaUICom
---@field RankItemPrefab MoonClient.MLuaUIGroup

---@return PanelRankPanel
---@param ctrl UIBase
function PanelRankPanel.Bind(ctrl)
	
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
return UI.PanelRankPanel