--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PartyInvitationPanel = {}

--lua model end

--lua functions
---@class PartyInvitationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PartyText MoonClient.MLuaUICom
---@field PartyBtn MoonClient.MLuaUICom
---@field GameObjectPartyOpen MoonClient.MLuaUICom
---@field GameObjectPartyClose MoonClient.MLuaUICom

---@return PartyInvitationPanel
function PartyInvitationPanel.Bind(ctrl)

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
return UI.PartyInvitationPanel