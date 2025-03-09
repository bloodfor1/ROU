--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildStoneHelpPanel = {}

--lua model end

--lua functions
---@class GuildStoneHelpPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field HelpDay MoonClient.MLuaUICom
---@field GiftNum MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom[]
---@field Content MoonClient.MLuaUICom
---@field BtnEnter MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field GuildStoneDetail MoonClient.MLuaUIGroup

---@return GuildStoneHelpPanel
---@param ctrl UIBase
function GuildStoneHelpPanel.Bind(ctrl)
	
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
return UI.GuildStoneHelpPanel