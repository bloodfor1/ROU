--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PhotographPanel = {}

--lua model end

--lua functions
---@class PhotographPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogTeamMember MoonClient.MLuaUICom
---@field TogPlayerSelf MoonClient.MLuaUICom
---@field TogPlayerName MoonClient.MLuaUICom
---@field TogOtherPlayer MoonClient.MLuaUICom
---@field TogNPC MoonClient.MLuaUICom
---@field TogMonster MoonClient.MLuaUICom
---@field TogMercenary MoonClient.MLuaUICom
---@field TogGuild MoonClient.MLuaUICom
---@field TogGameInfo MoonClient.MLuaUICom
---@field TogFX MoonClient.MLuaUICom
---@field TogFriend MoonClient.MLuaUICom
---@field TogCouple MoonClient.MLuaUICom
---@field SliderCameraSize MoonClient.MLuaUICom
---@field SetupPanel MoonClient.MLuaUICom
---@field PhotoTypeSelectPanel MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field DecalPanel MoonClient.MLuaUICom
---@field DecalInstance MoonClient.MLuaUICom
---@field ChatPanel MoonClient.MLuaUICom
---@field CameraPanel MoonClient.MLuaUICom
---@field BtnVR360Photo MoonClient.MLuaUICom
---@field BtnTakePhoto MoonClient.MLuaUICom
---@field BtnSetup MoonClient.MLuaUICom
---@field BtnSendMessage MoonClient.MLuaUICom
---@field BtnSelfPhoto MoonClient.MLuaUICom
---@field BtnPhoto MoonClient.MLuaUICom
---@field BtnExpression MoonClient.MLuaUICom
---@field BtnDecelExit MoonClient.MLuaUICom
---@field BtnDecalScale MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnChat MoonClient.MLuaUICom
---@field BtnBeautify MoonClient.MLuaUICom
---@field BtnARPhoto MoonClient.MLuaUICom
---@field BorderPanel MoonClient.MLuaUICom

---@return PhotographPanel
function PhotographPanel.Bind(ctrl)

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
return UI.PhotographPanel