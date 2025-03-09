--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PvpArenaInvitationPanel = {}

--lua model end

--lua functions
---@class PvpArenaInvitationPanel.PvpArenaInvitationItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field InvitationBtn MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field head MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom

---@class PvpArenaInvitationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field switchBtn MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field OnlyWearToggle MoonClient.MLuaUICom
---@field guildBtn MoonClient.MLuaUICom
---@field friendBtn MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field closeButton MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom
---@field PvpArenaInvitationItemPrefab PvpArenaInvitationPanel.PvpArenaInvitationItemPrefab

---@return PvpArenaInvitationPanel
---@param ctrl UIBase
function PvpArenaInvitationPanel.Bind(ctrl)
	
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
return UI.PvpArenaInvitationPanel