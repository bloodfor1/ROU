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
---@class CostPropTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Template_CostProp MoonClient.MLuaUICom

---@class CostPropTemplate : BaseUITemplate
---@field Parameter CostPropTemplateParameter

CostPropTemplate = class("CostPropTemplate", super)
--lua class define end

--lua functions
function CostPropTemplate:Init()
	
	super.Init(self)
	self.itemTemplate=nil
end --func end
--next--
function CostPropTemplate:BindEvents()
	
	
end --func end
--next--
function CostPropTemplate:OnDestroy()
	self.itemTemplate=nil
	
end --func end
--next--
function CostPropTemplate:OnDeActive()
	
	
end --func end
--next--
function CostPropTemplate:OnSetData(data)
	if data==nil then
		return
	end
	if MLuaCommonHelper.IsNull(self.itemTemplate) then
		self.itemTemplate = self:NewTemplate("ItemTemplate",{
			TemplateParent = self:transform(),
			Data=data
		})
	else
		self.itemTemplate:SetData(data)
	end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CostPropTemplate