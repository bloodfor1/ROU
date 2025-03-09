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
---@class ChatTagTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ChatTagSp MoonClient.MLuaUICom
---@field ChatTagName MoonClient.MLuaUICom

---@class ChatTagTemplate : BaseUITemplate
---@field Parameter ChatTagTemplateParameter

ChatTagTemplate = class("ChatTagTemplate", super)
--lua class define end

--lua functions
function ChatTagTemplate:Init()

    super.Init(self)
    self.Parameter.ChatTagName:SetActiveEx(false)

end --func end
--next--
function ChatTagTemplate:BindEvents()

    -- do nothing

end --func end
--next--
function ChatTagTemplate:OnDestroy()

    -- do nothing

end --func end
--next--
function ChatTagTemplate:OnDeActive()

    -- do nothing

end --func end
--next--
function ChatTagTemplate:OnSetData(data)

    self:_onSetData(data)

end --func end
--next--
--lua functions end

--lua custom scripts
---@param data DialogTabTable
function ChatTagTemplate:_onSetData(data)
    if nil == data then
        logError("[ChatTagTemplate] invalid config")
        return
    end

    self.Parameter.ChatTagSp:SetSpriteAsync(data.Atlas, data.Icon)
end
--lua custom scripts end
return ChatTagTemplate