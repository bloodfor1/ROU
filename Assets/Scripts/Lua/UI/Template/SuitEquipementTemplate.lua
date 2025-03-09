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
---@class SuitEquipementTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SuitEquipementTemplate MoonClient.MLuaUICom
---@field Dianzhong MoonClient.MLuaUICom

---@class SuitEquipementTemplate : BaseUITemplate
---@field Parameter SuitEquipementTemplateParameter

SuitEquipementTemplate = class("SuitEquipementTemplate", super)
--lua class define end

--lua functions
function SuitEquipementTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SuitEquipementTemplate:OnDestroy()
	
	self.itemTemplate = nil
	
end --func end
--next--
function SuitEquipementTemplate:OnDeActive()
	
	
end --func end
--next--
function SuitEquipementTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function SuitEquipementTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SuitEquipementTemplate:CustomSetData(data)
	
    if self.itemTemplate == nil then
        self.itemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.SuitEquipementTemplate.Transform
        })
    end

    self.itemTemplate:SetData({ID = data, IsShowCount = false})

end
--lua custom scripts end
return SuitEquipementTemplate