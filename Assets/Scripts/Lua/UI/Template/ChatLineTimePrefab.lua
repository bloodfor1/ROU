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
---@class ChatLineTimePrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom

---@class ChatLineTimePrefab : BaseUITemplate
---@field Parameter ChatLineTimePrefabParameter

ChatLineTimePrefab = class("ChatLineTimePrefab", super)
--lua class define end

--lua functions
function ChatLineTimePrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChatLineTimePrefab:OnDestroy()
	
	
end --func end
--next--
function ChatLineTimePrefab:OnDeActive()
	
	
end --func end
--next--
function ChatLineTimePrefab:OnSetData(data)
	
	self.msgPack = data
	self.Parameter.Time.LabText= Common.TimeMgr.GetChatTimeFormatStr(data.time)
	--已读消息
	MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)
	
end --func end
--next--
function ChatLineTimePrefab:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatLineTimePrefab