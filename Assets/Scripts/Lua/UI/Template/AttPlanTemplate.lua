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
---@class AttPlanTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field AttPlan MoonClient.MLuaUICom

---@class AttPlanTemplate : BaseUITemplate
---@field Parameter AttPlanTemplateParameter

AttPlanTemplate = class("AttPlanTemplate", super)
--lua class define end

--lua functions
function AttPlanTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function AttPlanTemplate:OnDestroy()
	
	
end --func end
--next--
function AttPlanTemplate:OnDeActive()
	
	
end --func end
--next--
function AttPlanTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	self.Parameter.AttPlan:AddClick(function()
		data.buttonMethod(data.index)
	end,true)
	self.Parameter.Text.LabText=data.name
	
end --func end
--next--
function AttPlanTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AttPlanTemplate