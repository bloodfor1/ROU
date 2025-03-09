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
---@class MultiSkillTitleLineTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Line MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom

---@class MultiSkillTitleLineTemplate : BaseUITemplate
---@field Parameter MultiSkillTitleLineTemplateParameter

MultiSkillTitleLineTemplate = class("MultiSkillTitleLineTemplate", super)
--lua class define end

--lua functions
function MultiSkillTitleLineTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MultiSkillTitleLineTemplate:OnDestroy()
	
	
end --func end
--next--
function MultiSkillTitleLineTemplate:OnDeActive()
	
	
end --func end
--next--
function MultiSkillTitleLineTemplate:OnSetData(data)
	
	    self.Parameter.Text.LabText = data.name
	
end --func end
--next--
function MultiSkillTitleLineTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MultiSkillTitleLineTemplate