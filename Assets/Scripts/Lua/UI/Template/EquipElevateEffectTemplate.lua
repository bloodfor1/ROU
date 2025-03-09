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
---@class EquipElevateEffectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field EquipElevateEffect MoonClient.MLuaUICom

---@class EquipElevateEffectTemplate : BaseUITemplate
---@field Parameter EquipElevateEffectTemplateParameter

EquipElevateEffectTemplate = class("EquipElevateEffectTemplate", super)
--lua class define end

--lua functions
function EquipElevateEffectTemplate:Init()
	
	    super.Init(self)
	self.Parameter.EquipElevateEffect:PlayFx()
	
end --func end
--next--
function EquipElevateEffectTemplate:OnDeActive()
	
	
end --func end
--next--
function EquipElevateEffectTemplate:OnSetData(data)
	
	
end --func end
--next--
function EquipElevateEffectTemplate:BindEvents()
	
	
end --func end
--next--
function EquipElevateEffectTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipElevateEffectTemplate:ctor(data)
	if data==nil then
		data={}
	end
	data.TemplatePath="UI/Prefabs/EquipElevateEffect"
	super.ctor(self,data)
end
--lua custom scripts end
return EquipElevateEffectTemplate