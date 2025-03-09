--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildRank_TrophyPanelPanel = {}

--lua model end

--lua functions
---@class GuildRank_TrophyPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Txt_Rank MoonClient.MLuaUICom
---@field NoneJiangBei MoonClient.MLuaUICom
---@field Img_Line MoonClient.MLuaUICom
---@field Dummy_6 MoonClient.MLuaUICom
---@field Dummy_5 MoonClient.MLuaUICom
---@field Dummy_4 MoonClient.MLuaUICom
---@field Dummy_3 MoonClient.MLuaUICom
---@field Dummy_2 MoonClient.MLuaUICom
---@field Dummy_1 MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field Btn_Hint MoonClient.MLuaUICom

---@return GuildRank_TrophyPanelPanel
---@param ctrl UIBase
function GuildRank_TrophyPanelPanel.Bind(ctrl)
	
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
return UI.GuildRank_TrophyPanelPanel