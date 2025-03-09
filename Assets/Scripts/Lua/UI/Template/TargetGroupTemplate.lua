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
---@class TargetGroupTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tag MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Choose MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class TargetGroupTemplate : BaseUITemplate
---@field Parameter TargetGroupTemplateParameter

TargetGroupTemplate = class("TargetGroupTemplate", super)
--lua class define end

--lua functions
function TargetGroupTemplate:Init()
    
    super.Init(self)
    
end --func end
--next--
function TargetGroupTemplate:BindEvents()
    
    
end --func end
--next--
function TargetGroupTemplate:OnDestroy()
    
    
end --func end
--next--
function TargetGroupTemplate:OnDeActive()
    
    
end --func end
--next--
function TargetGroupTemplate:OnSetData(data)

    self.id = data.id
    self.Parameter.Name.LabText = data.name
    self.Parameter.Tag:SetActiveEx(not string.ro_isEmpty(data.typeName))
    self.Parameter.Tag.LabText = data.typeName
    self.Parameter.Choose.gameObject:SetActiveEx(false)
    self.Parameter.Button:AddClick(function()
        MSkillTargetMgr.singleton:EnemyAim(data.id, true)
        if self.MethodCallback then
            self.MethodCallback(data.id)
        end
    end)
    
end --func end
--next--
--lua functions end

--lua custom scripts
function TargetGroupTemplate:ShowFrame(isShow)
    self.Parameter.Choose.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return TargetGroupTemplate