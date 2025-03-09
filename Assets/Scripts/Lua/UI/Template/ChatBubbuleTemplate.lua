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
---@class ChatBubbuleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field tag_new MoonClient.MLuaUICom
---@field img_selected MoonClient.MLuaUICom
---@field img_limit_time MoonClient.MLuaUICom
---@field img_in_use MoonClient.MLuaUICom
---@field img_bubble_icon MoonClient.MLuaUICom

---@class ChatBubbuleTemplate : BaseUITemplate
---@field Parameter ChatBubbuleTemplateParameter

ChatBubbuleTemplate = class("ChatBubbuleTemplate", super)
--lua class define end

--lua functions
function ChatBubbuleTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function ChatBubbuleTemplate:BindEvents()
	
	
end --func end
--next--
function ChatBubbuleTemplate:OnDestroy()
	
	
end --func end
--next--
function ChatBubbuleTemplate:OnDeActive()
	
	
end --func end
--next--
function ChatBubbuleTemplate:OnSetData(data)
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChatBubbuleTemplate