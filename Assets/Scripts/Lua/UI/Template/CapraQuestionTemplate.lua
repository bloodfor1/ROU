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
---@class CapraQuestionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field HeadIcon MoonClient.MLuaUICom

---@class CapraQuestionTemplate : BaseUITemplate
---@field Parameter CapraQuestionTemplateParameter

CapraQuestionTemplate = class("CapraQuestionTemplate", super)
--lua class define end

--lua functions
function CapraQuestionTemplate:Init()
    super.Init(self)
    self.head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadIcon.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function CapraQuestionTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function CapraQuestionTemplate:OnDestroy()
    self.head2d = nil
end --func end
--next--
function CapraQuestionTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function CapraQuestionTemplate:OnSetData(data)
    ---@type HeadTemplateParam
    local param = {
        IsPlayerSelf = true
	}

    self.head2d:SetData(param)
    local l_text = data.Text
    local l_mgr = MgrMgr:GetMgr("CapraFAQMgr")
    local l_judgeTextForbid = l_mgr.GetJudgeTextForbid(l_text)
    if l_judgeTextForbid then
        self.Parameter.Text.LabText = l_judgeTextForbid
        return
    end

    MgrMgr:GetMgr("ForbidTextMgr").RequestJudgeTextForbid(l_text, function(checkInfo)
        local l_resultCode = checkInfo.result
        local l_labelText
        if l_resultCode ~= 0 then
            --判断服务器是否判断失败 如果失败什么都不发生
            if l_resultCode == ErrorCode.ERR_USER_INPUT_INVAILD then
                l_labelText = checkInfo.text
            end
        else
            l_labelText = l_text
        end
        if l_labelText == nil then
            l_labelText = l_text
        end
        l_mgr.SetJudgeTextForbid(l_text, l_labelText)
        if self == nil then
            return
        end
        if self.Parameter == nil then
            return
        end
        if MLuaCommonHelper.IsNull(self.Parameter.Text) then
            return
        end

        self.Parameter.Text.LabText = l_labelText
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CapraQuestionTemplate