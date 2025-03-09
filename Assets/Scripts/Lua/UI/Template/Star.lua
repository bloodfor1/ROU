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
---@class StarParameter
---@field PanelRef MoonClient.MLuaUIPanel

---@class Star : BaseUITemplate
---@field Parameter StarParameter

Star = class("Star", super)
--lua class define end

--lua functions
function Star:Init()
    super.Init(self)
end --func end
--next--
function Star:BindEvents()
    -- do nothing
end --func end
--next--
function Star:OnDestroy()
    -- do nothing
end --func end
--next--
function Star:OnDeActive()
    -- do nothing
end --func end
--next--
function Star:OnSetData(data)
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return Star