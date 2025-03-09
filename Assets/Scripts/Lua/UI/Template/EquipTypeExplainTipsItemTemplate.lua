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
---@class EquipTypeExplainTipsItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Small MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Middle MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Big MoonClient.MLuaUICom

---@class EquipTypeExplainTipsItemTemplate : BaseUITemplate
---@field Parameter EquipTypeExplainTipsItemTemplateParameter

EquipTypeExplainTipsItemTemplate = class("EquipTypeExplainTipsItemTemplate", super)
--lua class define end

--lua functions
function EquipTypeExplainTipsItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function EquipTypeExplainTipsItemTemplate:OnDestroy()
	
	
end --func end
--next--
function EquipTypeExplainTipsItemTemplate:OnDeActive()
	
	
end --func end
--next--
function EquipTypeExplainTipsItemTemplate:OnSetData(data,equipWeaponId)
	
	self.Parameter.Icon:SetSpriteAsync(data.Atlas, data.Spt, nil, true)
	self.Parameter.Name.LabText=data.WeaponTypeDec
	self.Parameter.Small.LabText=tostring(data.Small/100).."%"
	self.Parameter.Middle.LabText=tostring(data.Middle/100).."%"
	self.Parameter.Big.LabText=tostring(data.Huge/100).."%"
	    self.Parameter.Select:SetActiveEx(false)
	    for i = 1, data.WeaponId.Length do
	        if data.WeaponId[i-1]==equipWeaponId then
	            self.Parameter.Select:SetActiveEx(true)
	            break
	        end
	    end
	
end --func end
--next--
function EquipTypeExplainTipsItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return EquipTypeExplainTipsItemTemplate