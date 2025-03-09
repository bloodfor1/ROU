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
---@class ChatHistoryPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom

---@class ChatHistoryPrefab : BaseUITemplate
---@field Parameter ChatHistoryPrefabParameter

ChatHistoryPrefab = class("ChatHistoryPrefab", super)
--lua class define end

--lua functions
function ChatHistoryPrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChatHistoryPrefab:OnDeActive()
	
	
end --func end
--next--
function ChatHistoryPrefab:OnSetData(data)
	
	
end --func end
--next--
function ChatHistoryPrefab:BindEvents()
	
	
end --func end
--next--
function ChatHistoryPrefab:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatHistoryPrefab