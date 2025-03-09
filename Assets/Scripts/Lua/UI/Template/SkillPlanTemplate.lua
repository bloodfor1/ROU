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
---@class SkillPlanTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field SkillPlan MoonClient.MLuaUICom

---@class SkillPlanTemplate : BaseUITemplate
---@field Parameter SkillPlanTemplateParameter

SkillPlanTemplate = class("SkillPlanTemplate", super)
--lua class define end

--lua functions
function SkillPlanTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SkillPlanTemplate:OnDestroy()
	
	
end --func end
--next--
function SkillPlanTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillPlanTemplate:OnSetData(data)
	
	    if data == nil then
	        return
	    end
	    self.Parameter.SkillPlan:AddClick(function()
	        data.buttonMethod(data.index)
	    end, true)
	    self.Parameter.Text.LabText = data.name
	
end --func end
--next--
function SkillPlanTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillPlanTemplate