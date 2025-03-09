--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildteammanagePanel = {}

--lua model end

--lua functions
---@class GuildteammanagePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Scroll MoonClient.MLuaUICom
---@field RewardClosePanel MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field infoComeBtn MoonClient.MLuaUICom
---@field BtnComeTxt MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field GuildTeamShow MoonClient.MLuaUIGroup

---@return GuildteammanagePanel
---@param ctrl UIBase
function GuildteammanagePanel.Bind(ctrl)
	
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
return UI.GuildteammanagePanel