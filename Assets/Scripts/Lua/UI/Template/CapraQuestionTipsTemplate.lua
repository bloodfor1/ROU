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
---@class CapraQuestionTipsTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field SelectText MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class CapraQuestionTipsTemplate : BaseUITemplate
---@field Parameter CapraQuestionTipsTemplateParameter

CapraQuestionTipsTemplate = class("CapraQuestionTipsTemplate", super)
--lua class define end

--lua functions
function CapraQuestionTipsTemplate:Init()

    super.Init(self)
    self._value = nil
    self.Parameter.Button:AddClick(function()
        self.Parameter.Select:SetActiveEx(true)
        self.MethodCallback(self._value)
    end)

end --func end
--next--
function CapraQuestionTipsTemplate:BindEvents()


end --func end
--next--
function CapraQuestionTipsTemplate:OnDestroy()


end --func end
--next--
function CapraQuestionTipsTemplate:OnDeActive()


end --func end
--next--
function CapraQuestionTipsTemplate:OnSetData(data)
    self.Parameter.Select:SetActiveEx(false)
    self.Parameter.SelectText.LabText = data
    self._value = data
    self.Parameter.Text.LabText = data

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CapraQuestionTipsTemplate