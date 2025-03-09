--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ForbidChatPlayerInfosPanel = {}

--lua model end

--lua functions
---@class ForbidChatPlayerInfosPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel_NoForbidPlayer MoonClient.MLuaUICom
---@field LoopScroll_ForbidPlayers MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Template_forbidPlayerInfo MoonClient.MLuaUIGroup

---@return ForbidChatPlayerInfosPanel
---@param ctrl UIBase
function ForbidChatPlayerInfosPanel.Bind(ctrl)
	
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
return UI.ForbidChatPlayerInfosPanel