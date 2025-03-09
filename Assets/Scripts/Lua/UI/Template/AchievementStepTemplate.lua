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
---@class AchievementStepTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StepName MoonClient.MLuaUICom

---@class AchievementStepTemplate : BaseUITemplate
---@field Parameter AchievementStepTemplateParameter

AchievementStepTemplate = class("AchievementStepTemplate", super)
--lua class define end

--lua functions
function AchievementStepTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function AchievementStepTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementStepTemplate:OnSetData(data)
	
	self:showStep(data)
	
end --func end
--next--
function AchievementStepTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementStepTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
local defaultColor=Color.New(0.592, 0.596, 0.6)
local finishColor=Color.New(0.2, 0.2, 0.2)

function AchievementStepTemplate:showStep(data)
	if data.IsFinish then
		self.Parameter.StepName.LabColor = finishColor
	else
		self.Parameter.StepName.LabColor = defaultColor
	end

	self.Parameter.StepName.LabText=data.StepName
end
--lua custom scripts end
return AchievementStepTemplate