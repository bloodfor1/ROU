--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildMatchSettlementPanel = {}

--lua model end

--lua functions
---@class GuildMatchSettlementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field winTitle MoonClient.MLuaUICom
---@field TeamParentRed MoonClient.MLuaUICom
---@field TeamParentBlue MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field loseTitle MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field GuildNameRed MoonClient.MLuaUICom
---@field GuildNameBlue MoonClient.MLuaUICom
---@field GuildIconRed MoonClient.MLuaUICom
---@field GuildIconBlue MoonClient.MLuaUICom
---@field CloseTip MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field GuildMatchResultTeamTem MoonClient.MLuaUIGroup

---@return GuildMatchSettlementPanel
function GuildMatchSettlementPanel.Bind(ctrl)

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
return UI.GuildMatchSettlementPanel