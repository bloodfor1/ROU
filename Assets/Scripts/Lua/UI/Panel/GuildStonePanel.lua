--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildStonePanel = {}

--lua model end

--lua functions
---@class GuildStonePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field StoneSliderTxt MoonClient.MLuaUICom
---@field StoneSliderImg MoonClient.MLuaUICom
---@field StoneQuestion MoonClient.MLuaUICom
---@field StoneLeftDes MoonClient.MLuaUICom
---@field Stone MoonClient.MLuaUICom[]
---@field RawImage MoonClient.MLuaUICom[]
---@field Player MoonClient.MLuaUICom[]
---@field Perfect MoonClient.MLuaUICom[]
---@field Patch MoonClient.MLuaUICom[]
---@field HelpName MoonClient.MLuaUICom[]
---@field HelpBG MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom[]
---@field Describe MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom
---@field BtnGiftText MoonClient.MLuaUICom
---@field BtnGift MoonClient.MLuaUICom
---@field BtnDetail MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return GuildStonePanel
---@param ctrl UIBase
function GuildStonePanel.Bind(ctrl)
	
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
return UI.GuildStonePanel