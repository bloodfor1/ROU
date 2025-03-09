--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildTeamReplacePanel = {}

--lua model end

--lua functions
---@class GuildTeamReplacePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RewardClosePanel MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field RefreshBtn MoonClient.MLuaUICom
---@field PanelReward MoonClient.MLuaUICom
---@field NonePanel MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field GuildMatchTeamSelTem MoonClient.MLuaUIGroup

---@return GuildTeamReplacePanel
---@param ctrl UIBase
function GuildTeamReplacePanel.Bind(ctrl)
	
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
return UI.GuildTeamReplacePanel