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
---@class SuitEquipmentAttrTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SuitEquipmentAttrTemplate MoonClient.MLuaUICom
---@field SuitDetail MoonClient.MLuaUICom
---@field SuitCount MoonClient.MLuaUICom

---@class SuitEquipmentAttrTemplate : BaseUITemplate
---@field Parameter SuitEquipmentAttrTemplateParameter

SuitEquipmentAttrTemplate = class("SuitEquipmentAttrTemplate", super)
--lua class define end

--lua functions
function SuitEquipmentAttrTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SuitEquipmentAttrTemplate:OnDestroy()
	
	
end --func end
--next--
function SuitEquipmentAttrTemplate:OnDeActive()
	
	
end --func end
--next--
function SuitEquipmentAttrTemplate:OnSetData(data)
	
	self:CustomRefresh(data)
	
end --func end
--next--
function SuitEquipmentAttrTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SuitEquipmentAttrTemplate:CustomRefresh(data)
	
	if data.customFormat then
		self.Parameter.SuitCount.LabText = data.customFormat
	else
		self.Parameter.SuitCount.LabText = Lang("SUIT_FORMAT", data.count)
	end
	self.Parameter.SuitDetail.LabText = data.desc
end
--lua custom scripts end
return SuitEquipmentAttrTemplate