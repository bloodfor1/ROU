--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildRank_ScorePanelPanel = {}

--lua model end

--lua functions
---@class GuildRank_ScorePanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Score MoonClient.MLuaUICom
---@field Txt_Rank MoonClient.MLuaUICom
---@field Txt_HelpDesc MoonClient.MLuaUICom
---@field Guild_Dummy_4 MoonClient.MLuaUICom
---@field Guild_Dummy_3 MoonClient.MLuaUICom
---@field Guild_Dummy_2 MoonClient.MLuaUICom
---@field Guild_Dummy_1 MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Trophy MoonClient.MLuaUICom
---@field Btn_Rank MoonClient.MLuaUICom
---@field Btn_Hint MoonClient.MLuaUICom

---@return GuildRank_ScorePanelPanel
---@param ctrl UIBase
function GuildRank_ScorePanelPanel.Bind(ctrl)
	
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
return UI.GuildRank_ScorePanelPanel