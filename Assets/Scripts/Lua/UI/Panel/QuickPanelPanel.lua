--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
QuickPanelPanel = {}

--lua model end

--lua functions
---@class QuickPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTeam MoonClient.MLuaUICom
---@field ToggleTask MoonClient.MLuaUICom
---@field ToggleGroupLowLevel MoonClient.MLuaUICom
---@field ToggleBattle MoonClient.MLuaUICom
---@field shrink_btn MoonClient.MLuaUICom
---@field RedSignParentTeamAndTask MoonClient.MLuaUICom
---@field RedSignParentTeam MoonClient.MLuaUICom
---@field QuickPanel MoonClient.MLuaUICom
---@field MemberNumTxt MoonClient.MLuaUICom
---@field MemberNumBg MoonClient.MLuaUICom
---@field LableTask MoonClient.MLuaUICom
---@field LabelTeam MoonClient.MLuaUICom

---@return QuickPanelPanel
---@param ctrl UIBase
function QuickPanelPanel.Bind(ctrl)
	
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
return UI.QuickPanelPanel