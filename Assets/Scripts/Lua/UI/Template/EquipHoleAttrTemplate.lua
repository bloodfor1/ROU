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
---@class EquipHoleAttrTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShowSkillButton MoonClient.MLuaUICom
---@field QualityGood MoonClient.MLuaUICom
---@field PropertyNameSign MoonClient.MLuaUICom
---@field PropertyName MoonClient.MLuaUICom
---@field PropertyCount MoonClient.MLuaUICom
---@field EffectImageNumber MoonClient.MLuaUICom
---@field EffectImageName MoonClient.MLuaUICom
---@field EffectImageBuff MoonClient.MLuaUICom
---@field BuffName MoonClient.MLuaUICom
---@field BaseProperty MoonClient.MLuaUICom

---@class EquipHoleAttrTemplate : BaseUITemplate
---@field Parameter EquipHoleAttrTemplateParameter

EquipHoleAttrTemplate = class("EquipHoleAttrTemplate", super)
--lua class define end

--lua functions
function EquipHoleAttrTemplate:Init()
    super.Init(self)
end --func end
--next--
function EquipHoleAttrTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function EquipHoleAttrTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function EquipHoleAttrTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipHoleAttrTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 参数为字符串，这里只负责设置文字显示
---@param data string
function EquipHoleAttrTemplate:_setData(data)
    if nil == data then
        logError("[EquipHoleAttr] invalid param")
        return
    end

    self.Parameter.PropertyName.LabText = data
end

--lua custom scripts end
return EquipHoleAttrTemplate