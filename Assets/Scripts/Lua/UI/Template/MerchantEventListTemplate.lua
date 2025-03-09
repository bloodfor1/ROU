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
---@class MerchantEventListTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Event MoonClient.MLuaUICom

---@class MerchantEventListTemplate : BaseUITemplate
---@field Parameter MerchantEventListTemplateParameter

MerchantEventListTemplate = class("MerchantEventListTemplate", super)
--lua class define end

--lua functions
function MerchantEventListTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MerchantEventListTemplate:OnDestroy()
	
	
end --func end
--next--
function MerchantEventListTemplate:OnDeActive()
	
	
end --func end
--next--
function MerchantEventListTemplate:OnSetData(data)
	
	self.Parameter.Event.LabText = data
	
end --func end
--next--
function MerchantEventListTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MerchantEventListTemplate