--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDinnerPanel = {}

--lua model end

--lua functions
---@class GuildDinnerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_CookAccountTime MoonClient.MLuaUICom
---@field Tog_OnlyShowMyGuildInfo MoonClient.MLuaUICom
---@field Tog_MyGuild MoonClient.MLuaUICom
---@field Tog_All MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field QualityGroup MoonClient.MLuaUICom
---@field Panel_Personal MoonClient.MLuaUICom
---@field Panel_GuildRankInfo MoonClient.MLuaUICom
---@field Panel_Guild MoonClient.MLuaUICom
---@field LoopScroll_RankInfo MoonClient.MLuaUICom
---@field Btn_RankInfoHelp MoonClient.MLuaUICom
---@field GuildRankTemplate MoonClient.MLuaUIGroup
---@field GuildInfoTemplate MoonClient.MLuaUIGroup

---@return GuildDinnerPanel
function GuildDinnerPanel.Bind(ctrl)

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
return UI.GuildDinnerPanel