--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChatRoomPanel = {}

--lua model end

--lua functions
---@class ChatRoomPanel.PlayerPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Zhiye MoonClient.MLuaUICom
---@field SelectBtn MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field HeadBtn MoonClient.MLuaUICom
---@field ExitBtn MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom

---@class ChatRoomPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleText MoonClient.MLuaUICom
---@field TitleIcon MoonClient.MLuaUICom
---@field SetBtn MoonClient.MLuaUICom
---@field PlayerScroll MoonClient.MLuaUICom
---@field Panel_InputAndVoice MoonClient.MLuaUICom
---@field NewMessageHint MoonClient.MLuaUICom
---@field NewMessageContent MoonClient.MLuaUICom
---@field KeyboardBtn MoonClient.MLuaUICom
---@field InputPanel MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field ExitBtn MoonClient.MLuaUICom
---@field DissolveBtn MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field ChatScroll MoonClient.MLuaUICom
---@field BtnVoice MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnFace MoonClient.MLuaUICom
---@field AudioPanel MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field PlayerPrefab ChatRoomPanel.PlayerPrefab

---@return ChatRoomPanel
---@param ctrl UIBase
function ChatRoomPanel.Bind(ctrl)
	
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
return UI.ChatRoomPanel