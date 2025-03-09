--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildRankPanel = {}

--lua model end

--lua functions
---@class GuildRankPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_TimeRemaining MoonClient.MLuaUICom
---@field Txt_Score MoonClient.MLuaUICom
---@field Txt_Rank MoonClient.MLuaUICom
---@field Tog_HonorRank MoonClient.MLuaUICom
---@field Tog_EliteRank MoonClient.MLuaUICom
---@field QualityGroup MoonClient.MLuaUICom
---@field Panel_Personal MoonClient.MLuaUICom
---@field LoopScroll_RankInfo MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field container MoonClient.MLuaUICom
---@field Btn_Hint MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom

---@return GuildRankPanel
---@param ctrl UIBase
function GuildRankPanel.Bind(ctrl)
	
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
return UI.GuildRankPanel