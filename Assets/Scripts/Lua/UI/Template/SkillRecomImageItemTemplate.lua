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
---@class SkillRecomImageItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class SkillRecomImageItemTemplate : BaseUITemplate
---@field Parameter SkillRecomImageItemTemplateParameter

SkillRecomImageItemTemplate = class("SkillRecomImageItemTemplate", super)
--lua class define end

--lua functions
function SkillRecomImageItemTemplate:Init()
	
	    super.Init(self)
	    self.data = DataMgr:GetData("SkillData")
	
end --func end
--next--
function SkillRecomImageItemTemplate:OnDestroy()
	
	    self.data = nil
	
end --func end
--next--
function SkillRecomImageItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillRecomImageItemTemplate:OnSetData(data)
	
	    local skillsdata = self.data.GetDataFromTable("SkillTable", data.skillId)
	    self.Parameter.Icon:SetSpriteAsync(skillsdata.Atlas, skillsdata.Icon)
	    self.Parameter.Text.LabText = skillsdata.Name
	
end --func end
--next--
function SkillRecomImageItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillRecomImageItemTemplate