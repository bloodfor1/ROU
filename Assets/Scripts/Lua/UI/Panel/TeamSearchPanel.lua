--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamSearchPanel = {}

--lua model end

--lua functions
---@class TeamSearchPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogS MoonClient.MLuaUICom
---@field TogL MoonClient.MLuaUICom
---@field Tog_BeLeader MoonClient.MLuaUICom
---@field Templent MoonClient.MLuaUICom
---@field TeamContent MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnRefresh MoonClient.MLuaUICom
---@field BtnCreat MoonClient.MLuaUICom
---@field BtnAutoTxt MoonClient.MLuaUICom
---@field BtnAuto MoonClient.MLuaUICom
---@field TeamSearchLineTem MoonClient.MLuaUIGroup

---@return TeamSearchPanel
---@param ctrl UIBase
function TeamSearchPanel.Bind(ctrl)
	
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
return UI.TeamSearchPanel