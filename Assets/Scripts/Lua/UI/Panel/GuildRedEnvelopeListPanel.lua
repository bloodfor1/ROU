--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildRedEnvelopeListPanel = {}

--lua model end

--lua functions
---@class GuildRedEnvelopeListPanel.GuildRedEnvelopeItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedTypeName MoonClient.MLuaUICom
---@field RedIcon MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom

---@class GuildRedEnvelopeListPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field GuildRedEnvelopeItemParent MoonClient.MLuaUICom
---@field GuildRedEnvelopeItemPrefab GuildRedEnvelopeListPanel.GuildRedEnvelopeItemPrefab

---@return GuildRedEnvelopeListPanel
function GuildRedEnvelopeListPanel.Bind(ctrl)

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
return UI.GuildRedEnvelopeListPanel