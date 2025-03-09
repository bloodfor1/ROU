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
---@class MercenaryEquipAttrTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field AttrValueText MoonClient.MLuaUICom
---@field AttrNameText MoonClient.MLuaUICom

---@class MercenaryEquipAttrTemplate : BaseUITemplate
---@field Parameter MercenaryEquipAttrTemplateParameter

MercenaryEquipAttrTemplate = class("MercenaryEquipAttrTemplate", super)
--lua class define end

--lua functions
function MercenaryEquipAttrTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function MercenaryEquipAttrTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenaryEquipAttrTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryEquipAttrTemplate:OnSetData(data)
	
	local l_attrName = ""
	    local l_attrRow = TableUtil.GetAttrDecision().GetRowById(data.attrId)
	    if l_attrRow then
	        l_attrName = StringEx.Format(l_attrRow.TipTemplate, "")
	    end
	    self.Parameter.AttrNameText.LabText = l_attrName
	    self.Parameter.AttrValueText.LabText = data.value
	    if not data.beforeValue or data.beforeValue == data.value then
	        self.Parameter.AttrValueText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Blue[1])
	    else
	        if data.beforeValue > data.value then
	            self.Parameter.AttrValueText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
	        else
	            self.Parameter.AttrValueText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Green[1])
	        end
	    end
	
end --func end
--next--
function MercenaryEquipAttrTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryEquipAttrTemplate