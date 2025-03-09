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
---@class EquipIllustrationSuitTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SuitTitle MoonClient.MLuaUICom
---@field QuestionText MoonClient.MLuaUICom
---@field EquipRandomTip MoonClient.MLuaUICom

---@class EquipIllustrationSuitTemplate : BaseUITemplate
---@field Parameter EquipIllustrationSuitTemplateParameter

EquipIllustrationSuitTemplate = class("EquipIllustrationSuitTemplate", super)
--lua class define end

--lua functions
function EquipIllustrationSuitTemplate:Init()
    super.Init(self)
end --func end
--next--
function EquipIllustrationSuitTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function EquipIllustrationSuitTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipIllustrationSuitTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function EquipIllustrationSuitTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipIllustrationSuitTemplate:CustomSetData(data)
    self.Parameter.EquipRandomTip.LabText = StringEx.Format("\n{0}\n{1}", data.equipNames, data.suitDesc)
    self.Parameter.SuitTitle.LabText = data.title
    self.Parameter.QuestionText.Listener:SetActionClick(self.OnClickQuestion, self)
end

function EquipIllustrationSuitTemplate:OnClickQuestion(go, eventData)
    local l_content = Common.Utils.Lang("SUIT_HELP_DESC")
    local l_anchor = Vector2.New(0.5, 0)
    local pos = Vector2.New(eventData.position.x, eventData.position.y)
    eventData.position = pos
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_content, eventData, l_anchor)
end
--lua custom scripts end
return EquipIllustrationSuitTemplate