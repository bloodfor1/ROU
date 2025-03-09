--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChatPanel = {}

--lua model end

--lua functions
---@class ChatPanel.OtherChatLinePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field AudioTime MoonClient.MLuaUICom
---@field AudioObj MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field AudioAnim MoonClient.MLuaUICom

---@class ChatPanel.HistoryPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom

---@class ChatPanel.PlayerChatLinePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field AudioTime MoonClient.MLuaUICom
---@field AudioObj MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field AudioAnim MoonClient.MLuaUICom

---@class ChatPanel.HintChatLinePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Content MoonClient.MLuaUICom

---@class ChatPanel.SystemChatLinePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TagText MoonClient.MLuaUICom
---@field TagObj MoonClient.MLuaUICom
---@field TagColor MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom

---@class ChatPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TopMsgLeftTime MoonClient.MLuaUICom
---@field TopMsgBox MoonClient.MLuaUICom
---@field TopMsg MoonClient.MLuaUICom
---@field TogWorld MoonClient.MLuaUICom
---@field TogWatch MoonClient.MLuaUICom
---@field TogTeam MoonClient.MLuaUICom
---@field TogSystem MoonClient.MLuaUICom
---@field TogProfession MoonClient.MLuaUICom
---@field TogPrivate MoonClient.MLuaUICom
---@field TogNearBy MoonClient.MLuaUICom
---@field TogGuild MoonClient.MLuaUICom
---@field SettingBtn MoonClient.MLuaUICom
---@field NewMessageHint MoonClient.MLuaUICom
---@field Label MoonClient.MLuaUICom[]
---@field KeyboardBtn MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ChatSenderPanel MoonClient.MLuaUICom
---@field ChatRoomBtn MoonClient.MLuaUICom
---@field ChatLineGroupContent MoonClient.MLuaUICom
---@field ChatLineGroup MoonClient.MLuaUICom
---@field BtnVoice MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnFace MoonClient.MLuaUICom
---@field BtnDisableInput MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field Btn_ForbidPlayerInfo MoonClient.MLuaUICom
---@field AudioPanel MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom
---@field OtherChatLinePrefab ChatPanel.OtherChatLinePrefab
---@field HistoryPrefab ChatPanel.HistoryPrefab
---@field PlayerChatLinePrefab ChatPanel.PlayerChatLinePrefab
---@field HintChatLinePrefab ChatPanel.HintChatLinePrefab
---@field SystemChatLinePrefab ChatPanel.SystemChatLinePrefab

---@return ChatPanel
---@param ctrl UIBase
function ChatPanel.Bind(ctrl)
	
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
return UI.ChatPanel