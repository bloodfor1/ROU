--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SettingPlayerPanel = {}

--lua model end

--lua functions
---@class SettingPlayerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WatchTishiBtn MoonClient.MLuaUICom
---@field WatchSettingBtn MoonClient.MLuaUICom
---@field WatchChatSettingBtn MoonClient.MLuaUICom
---@field Watch MoonClient.MLuaUICom
---@field UpdateNoticeBtn MoonClient.MLuaUICom
---@field TogTargetRNG MoonClient.MLuaUICom
---@field TogTargetHP MoonClient.MLuaUICom
---@field TogScreenCapture MoonClient.MLuaUICom
---@field TogPrivateChatLevel MoonClient.MLuaUICom
---@field TogPathFindingFixedView MoonClient.MLuaUICom
---@field TogControlWheel MoonClient.MLuaUICom
---@field TogControlTouch MoonClient.MLuaUICom
---@field TogControl3D MoonClient.MLuaUICom
---@field TogControl2D MoonClient.MLuaUICom
---@field TogCommonAttack MoonClient.MLuaUICom
---@field TogChatWorld MoonClient.MLuaUICom
---@field TogChatWifiAuto MoonClient.MLuaUICom
---@field TogChatTeam MoonClient.MLuaUICom
---@field TogChatGuild MoonClient.MLuaUICom
---@field TogChatCurrent MoonClient.MLuaUICom
---@field TogCameraShake MoonClient.MLuaUICom
---@field SetContent MoonClient.MLuaUICom
---@field RealName MoonClient.MLuaUICom
---@field Panel_AudioSet MoonClient.MLuaUICom
---@field NoOthersPlayerTxt MoonClient.MLuaUICom
---@field LabelScreenCapture MoonClient.MLuaUICom
---@field LabelPrivateChatLevel MoonClient.MLuaUICom
---@field iOSAgreementText MoonClient.MLuaUICom
---@field iOSAgreement MoonClient.MLuaUICom
---@field Heads MoonClient.MLuaUICom
---@field Grid MoonClient.MLuaUICom
---@field FeedbackBtn MoonClient.MLuaUICom
---@field ExitLoginBtn MoonClient.MLuaUICom
---@field CurPlayerServerTxt MoonClient.MLuaUICom
---@field CurPlayerNameTxt MoonClient.MLuaUICom
---@field CurPlayerIDTxt MoonClient.MLuaUICom
---@field CommonAttack MoonClient.MLuaUICom
---@field ChatRoomNameBtn MoonClient.MLuaUICom
---@field ChangeRoleViewBtn MoonClient.MLuaUICom
---@field CameraShake MoonClient.MLuaUICom
---@field BtnGrid MoonClient.MLuaUICom
---@field Btn_UseOriginal MoonClient.MLuaUICom
---@field Btn_PersonalPrivacy MoonClient.MLuaUICom
---@field Btn_OperationStrategy MoonClient.MLuaUICom
---@field Btn_Lockscreen MoonClient.MLuaUICom
---@field Btn_Freefromstuck MoonClient.MLuaUICom
---@field Btn_BindAccout MoonClient.MLuaUICom
---@field BackToSelectCharBtn MoonClient.MLuaUICom
---@field AssistBtn MoonClient.MLuaUICom
---@field AndroidAgreementText MoonClient.MLuaUICom
---@field AndroidAgreement MoonClient.MLuaUICom
---@field SettingPlayerTemplate MoonClient.MLuaUIGroup

---@return SettingPlayerPanel
---@param ctrl UIBase
function SettingPlayerPanel.Bind(ctrl)
	
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
return UI.SettingPlayerPanel