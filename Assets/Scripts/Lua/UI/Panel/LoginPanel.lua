--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LoginPanel = {}

--lua model end

--lua functions
---@class LoginPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field txtVersion MoonClient.MLuaUICom
---@field TxtAgreement MoonClient.MLuaUICom
---@field TogAgreement MoonClient.MLuaUICom
---@field StartGamePanel MoonClient.MLuaUICom
---@field StartGameBtn MoonClient.MLuaUICom
---@field SelectServerTxt MoonClient.MLuaUICom
---@field SelectServerState MoonClient.MLuaUICom
---@field SelecteServerBtn MoonClient.MLuaUICom
---@field RedPromptPlayback MoonClient.MLuaUICom
---@field RedPromptLogin MoonClient.MLuaUICom
---@field RedPromptFeedback MoonClient.MLuaUICom
---@field RedPromptAnnounce MoonClient.MLuaUICom
---@field PanelTencent MoonClient.MLuaUICom
---@field PanelLogin MoonClient.MLuaUICom
---@field PanelJoyyou MoonClient.MLuaUICom
---@field PanelInnerTest MoonClient.MLuaUICom
---@field Panel_SDKLogin MoonClient.MLuaUICom
---@field Logo MoonClient.MLuaUICom
---@field InputMapleId MoonClient.MLuaUICom
---@field InputLoginPort MoonClient.MLuaUICom
---@field InputLoginIp MoonClient.MLuaUICom
---@field InAccount MoonClient.MLuaUICom
---@field GMPanel MoonClient.MLuaUICom
---@field GMDetailPanel MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field deviceUniqueIdentifier MoonClient.MLuaUICom
---@field deviceType MoonClient.MLuaUICom
---@field deviceName MoonClient.MLuaUICom
---@field deviceModel MoonClient.MLuaUICom
---@field DeviceInfo MoonClient.MLuaUICom
---@field Button_WX MoonClient.MLuaUICom
---@field Button_Visitor MoonClient.MLuaUICom
---@field Button_QQ MoonClient.MLuaUICom
---@field Button_Guest MoonClient.MLuaUICom
---@field Button_Google MoonClient.MLuaUICom
---@field Button_GameCenter MoonClient.MLuaUICom
---@field Button_Facebook MoonClient.MLuaUICom
---@field Button_Apple MoonClient.MLuaUICom
---@field BtnRefreshSvr MoonClient.MLuaUICom
---@field BtnLogin MoonClient.MLuaUICom
---@field BtnGM MoonClient.MLuaUICom
---@field Btn_Playback MoonClient.MLuaUICom
---@field Btn_Feedback MoonClient.MLuaUICom
---@field Btn_back MoonClient.MLuaUICom
---@field Btn_Announce MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@return LoginPanel
---@param ctrl UIBase
function LoginPanel.Bind(ctrl)
	
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
return UI.LoginPanel