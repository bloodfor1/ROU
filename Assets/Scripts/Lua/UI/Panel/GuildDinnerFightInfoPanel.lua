--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDinnerFightInfoPanel = {}

--lua model end

--lua functions
---@class GuildDinnerFightInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RandomEvent MoonClient.MLuaUICom
---@field Txt_GuildCookScore MoonClient.MLuaUICom
---@field Txt_GuildCookRank MoonClient.MLuaUICom
---@field TimeCount MoonClient.MLuaUICom
---@field StartTimeCountPart MoonClient.MLuaUICom
---@field StartTimeCountBox MoonClient.MLuaUICom
---@field StartTimeCount MoonClient.MLuaUICom
---@field MemberNum MoonClient.MLuaUICom
---@field Img_RandomEvent MoonClient.MLuaUICom
---@field Img_GuildCookScore MoonClient.MLuaUICom
---@field BtnActivityInfo MoonClient.MLuaUICom
---@field Btn_RandomEvent MoonClient.MLuaUICom
---@field Btn_CookRankInfo MoonClient.MLuaUICom
---@field Raw_cookCompetition MoonClient.MLuaUICom

---@return GuildDinnerFightInfoPanel
function GuildDinnerFightInfoPanel.Bind(ctrl)

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
return UI.GuildDinnerFightInfoPanel