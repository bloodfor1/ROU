--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShortcutChatPanel = {}

--lua model end

--lua functions
---@class ShortcutChatPanel.Prefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field RestoreBtn MoonClient.MLuaUICom
---@field RecordBtn MoonClient.MLuaUICom
---@field Panel_InputAndVoice MoonClient.MLuaUICom
---@field NewMessageHint MoonClient.MLuaUICom
---@field NewMessageContent MoonClient.MLuaUICom
---@field Mini MoonClient.MLuaUICom
---@field MainFloor MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field KeyboardBtn MoonClient.MLuaUICom
---@field InputPanel MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field HideBtn MoonClient.MLuaUICom
---@field FriendText MoonClient.MLuaUICom
---@field FriendLight MoonClient.MLuaUICom
---@field FriendFloor MoonClient.MLuaUICom
---@field FriendFinish MoonClient.MLuaUICom
---@field FriendChatParent MoonClient.MLuaUICom
---@field Friend MoonClient.MLuaUICom
---@field ChatScroll MoonClient.MLuaUICom
---@field ChannelText MoonClient.MLuaUICom
---@field ChannelLight MoonClient.MLuaUICom
---@field ChannelFloor MoonClient.MLuaUICom
---@field ChannelFinish MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field CancelBtn MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnFace MoonClient.MLuaUICom
---@field AudioPanel MoonClient.MLuaUICom
---@field AudioBtn MoonClient.MLuaUICom

---@class ShortcutChatPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Parent MoonClient.MLuaUICom
---@field Prefab ShortcutChatPanel.Prefab

---@return ShortcutChatPanel
---@param ctrl UIBase
function ShortcutChatPanel.Bind(ctrl)
	
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
return UI.ShortcutChatPanel