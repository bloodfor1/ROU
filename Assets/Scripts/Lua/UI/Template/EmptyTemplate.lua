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
---@class EmptyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Template_Empty MoonClient.MLuaUICom

---@class EmptyTemplate : BaseUITemplate
---@field Parameter EmptyTemplateParameter

EmptyTemplate = class("EmptyTemplate", super)
--lua class define end

--lua functions
function EmptyTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function EmptyTemplate:OnDestroy()
	
	
end --func end
--next--
function EmptyTemplate:OnDeActive()
	
	
end --func end
--next--
function EmptyTemplate:OnSetData(data)
	
	
end --func end
--next--
function EmptyTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return EmptyTemplate