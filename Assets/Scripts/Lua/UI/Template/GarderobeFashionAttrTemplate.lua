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
---@class GarderobeFashionAttrTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CurAttributetmp MoonClient.MLuaUICom
---@field CurAttribute MoonClient.MLuaUICom

---@class GarderobeFashionAttrTemplate : BaseUITemplate
---@field Parameter GarderobeFashionAttrTemplateParameter

GarderobeFashionAttrTemplate = class("GarderobeFashionAttrTemplate", super)
--lua class define end

--lua functions
function GarderobeFashionAttrTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function GarderobeFashionAttrTemplate:BindEvents()
	
	
end --func end
--next--
function GarderobeFashionAttrTemplate:OnDestroy()
	
	
end --func end
--next--
function GarderobeFashionAttrTemplate:OnDeActive()
	
	
end --func end
--next--
function GarderobeFashionAttrTemplate:OnSetData(data)
	local attr = data
	if attr.type and attr.id and attr.val then
		self.Parameter.CurAttribute.LabText =  MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GarderobeFashionAttrTemplate