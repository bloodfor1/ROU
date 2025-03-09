--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainChatPanel = {}

--lua model end

--lua functions
---@class MainChatPanel.ChannelTem
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeIcon MoonClient.MLuaUICom
---@field TagText MoonClient.MLuaUICom
---@field MessageText MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class MainChatPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WorldMessageBtn MoonClient.MLuaUICom
---@field TopRoot MoonClient.MLuaUICom
---@field TeamRecordObj MoonClient.MLuaUICom
---@field TeamRecordMain MoonClient.MLuaUICom
---@field TeamRecordBtn MoonClient.MLuaUICom
---@field SettingBtn MoonClient.MLuaUICom
---@field RecordGroup MoonClient.MLuaUICom
---@field NoticeBtn MoonClient.MLuaUICom
---@field MessageContent MoonClient.MLuaUICom
---@field MessageBox MoonClient.MLuaUICom
---@field GuideRecordObj MoonClient.MLuaUICom
---@field GuideRecordMain MoonClient.MLuaUICom
---@field GuideRecordBtn MoonClient.MLuaUICom
---@field GMButton MoonClient.MLuaUICom
---@field DailyActivityGroup MoonClient.MLuaUICom
---@field ChatGroupContent MoonClient.MLuaUICom
---@field CameraButton MoonClient.MLuaUICom
---@field Camera3D MoonClient.MLuaUICom
---@field Camera25D MoonClient.MLuaUICom
---@field BtnShowAction MoonClient.MLuaUICom
---@field BtnQuickTeam MoonClient.MLuaUICom
---@field BtnQuickGuild MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom
---@field BtnEnterChat MoonClient.MLuaUICom
---@field BtnChangeChatSize MoonClient.MLuaUICom
---@field Btn_Notice MoonClient.MLuaUICom
---@field ChannelTem MainChatPanel.ChannelTem

---@return MainChatPanel
---@param ctrl UIBase
function MainChatPanel.Bind(ctrl)
	
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
return UI.MainChatPanel