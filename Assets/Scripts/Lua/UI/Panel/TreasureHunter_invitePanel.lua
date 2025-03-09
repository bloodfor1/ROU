--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TreasureHunter_invitePanel = {}

--lua model end

--lua functions
---@class TreasureHunter_invitePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field NilPanel MoonClient.MLuaUICom
---@field LoopScroll MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field TreasureHunterInviteTem MoonClient.MLuaUIGroup

---@return TreasureHunter_invitePanel
---@param ctrl UIBase
function TreasureHunter_invitePanel.Bind(ctrl)
	
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
return UI.TreasureHunter_invitePanel