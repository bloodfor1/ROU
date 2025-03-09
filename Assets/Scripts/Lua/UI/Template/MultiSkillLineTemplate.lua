--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/SlotHurtTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class MultiSkillLineTemplateParameter.SlotHurtTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SKILLICON MoonClient.MLuaUICom[]
---@field Bg_zikuang3 MoonClient.MLuaUICom
---@field Text3 MoonClient.MLuaUICom
---@field Bg_zikuang5 MoonClient.MLuaUICom
---@field Text5 MoonClient.MLuaUICom
---@field Btn_skill MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom

---@class MultiSkillLineTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillLine MoonClient.MLuaUICom
---@field SlotHurtTemplate MultiSkillLineTemplateParameter.SlotHurtTemplate

---@class MultiSkillLineTemplate : BaseUITemplate
---@field Parameter MultiSkillLineTemplateParameter

MultiSkillLineTemplate = class("MultiSkillLineTemplate", super)
--lua class define end

--lua functions
function MultiSkillLineTemplate:Init()
	
	super.Init(self)
	self.skillPool = nil
	
end --func end
--next--
function MultiSkillLineTemplate:OnDestroy()
	
	self.skillPool = nil
	
end --func end
--next--
function MultiSkillLineTemplate:OnDeActive()
	
	
end --func end
--next--
function MultiSkillLineTemplate:OnSetData(data)
	
	self:OnCustomInit()
	self.skillPool:ShowTemplates({Datas = data.skills})
	
end --func end
--next--
function MultiSkillLineTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MultiSkillLineTemplate:OnCustomInit()

    if not self.skillPool then
        self.skillPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.SlotHurtTemplate,
            TemplatePrefab = self.Parameter.SlotHurtTemplate.LuaUIGroup.gameObject,
            TemplateParent = self.Parameter.LuaUIGroup.transform,
        })
    end

end
--lua custom scripts end
return MultiSkillLineTemplate