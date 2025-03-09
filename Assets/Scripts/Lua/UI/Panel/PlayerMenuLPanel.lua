--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PlayerMenuLPanel = {}

--lua model end

--lua functions
---@class PlayerMenuLPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_ForbidPlayer MoonClient.MLuaUICom
---@field Txt_CancelForbidPlayer MoonClient.MLuaUICom
---@field TxAskVehicle MoonClient.MLuaUICom
---@field TitleName MoonClient.MLuaUICom
---@field TextName MoonClient.MLuaUICom
---@field TeamText MoonClient.MLuaUICom
---@field TargetIcon MoonClient.MLuaUICom
---@field Sticker MoonClient.MLuaUICom
---@field QqSpeakBtn MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field Offset MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom
---@field LvClass MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field InfoBtn MoonClient.MLuaUICom
---@field Guild MoonClient.MLuaUICom
---@field FriendBtn MoonClient.MLuaUICom
---@field ButtonInviteTeamTxt MoonClient.MLuaUICom
---@field ButtonInviteTeam MoonClient.MLuaUICom
---@field ButtonApplyTeam MoonClient.MLuaUICom
---@field BtnPrefabText MoonClient.MLuaUICom
---@field BtnPrefab MoonClient.MLuaUICom
---@field BtnGuildInvite MoonClient.MLuaUICom
---@field BtnGuildApply MoonClient.MLuaUICom
---@field Btn_ForbidPlayer MoonClient.MLuaUICom
---@field Btn_CancelForbidPlayer MoonClient.MLuaUICom
---@field BtAskVehicle MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field BadListBtn MoonClient.MLuaUICom

---@return PlayerMenuLPanel
---@param ctrl UIBase
function PlayerMenuLPanel.Bind(ctrl)
	
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
return UI.PlayerMenuLPanel