--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamCareerChoice2Panel = {}

--lua model end

--lua functions
---@class TeamCareerChoice2Panel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_title MoonClient.MLuaUICom
---@field Txt_time MoonClient.MLuaUICom
---@field Txt_MatchNum MoonClient.MLuaUICom
---@field Txt_FreeMatch MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Dummy_SinglePersonMatch MoonClient.MLuaUICom
---@field Dummy_Member MoonClient.MLuaUICom
---@field Dummy_MatchDetail MoonClient.MLuaUICom
---@field Dummy_LeaderMatch MoonClient.MLuaUICom
---@field Dummy_FreeMatch MoonClient.MLuaUICom
---@field Btn_Stop MoonClient.MLuaUICom
---@field Btn_MatchBrief MoonClient.MLuaUICom
---@field Btn_Continue MoonClient.MLuaUICom

---@return TeamCareerChoice2Panel
---@param ctrl UIBase
function TeamCareerChoice2Panel.Bind(ctrl)
	
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
return UI.TeamCareerChoice2Panel