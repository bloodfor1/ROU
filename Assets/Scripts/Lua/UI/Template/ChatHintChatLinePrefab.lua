--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ChatHintChatLinePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Content MoonClient.MLuaUICom

---@class ChatHintChatLinePrefab : BaseUITemplate
---@field Parameter ChatHintChatLinePrefabParameter

ChatHintChatLinePrefab = class("ChatHintChatLinePrefab", super)
--lua class define end

--lua functions
function ChatHintChatLinePrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChatHintChatLinePrefab:OnDeActive()
	
	
end --func end
--next--
function ChatHintChatLinePrefab:OnSetData(msgPack)
	
	self.msgPack = msgPack
	self.Parameter.Content.LabRayCastTarget = false
	self.Parameter.Content.LabText = tostring(self.msgPack.content)
	--已读消息
	MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)
	
end --func end
--next--
function ChatHintChatLinePrefab:OnDestroy()
	
	
end --func end
--next--
function ChatHintChatLinePrefab:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatHintChatLinePrefab