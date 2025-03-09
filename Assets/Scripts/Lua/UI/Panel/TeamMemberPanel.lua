--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamMemberPanel = {}

--lua model end

--lua functions
---@class TeamMemberPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextAutoTeam MoonClient.MLuaUICom
---@field Target MoonClient.MLuaUICom
---@field TameName MoonClient.MLuaUICom
---@field obj_ProfessionList MoonClient.MLuaUICom
---@field Loot MoonClient.MLuaUICom
---@field Img_ProIcon MoonClient.MLuaUICom[]
---@field expTips MoonClient.MLuaUICom[]
---@field ExpShowPanel MoonClient.MLuaUICom
---@field CloseExpBtn MoonClient.MLuaUICom
---@field ButtonSuit MoonClient.MLuaUICom
---@field ButtonQuit MoonClient.MLuaUICom
---@field ButtonOneKeyTalk MoonClient.MLuaUICom
---@field ButtonOneKeyFollow MoonClient.MLuaUICom
---@field ButtonFollowCaptain MoonClient.MLuaUICom
---@field ButtonAutoTeam MoonClient.MLuaUICom
---@field BtnSet MoonClient.MLuaUICom
---@field BtnExp MoonClient.MLuaUICom
---@field TeamMemberPerTem MoonClient.MLuaUIGroup

---@return TeamMemberPanel
---@param ctrl UIBase
function TeamMemberPanel.Bind(ctrl)
	
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
return UI.TeamMemberPanel