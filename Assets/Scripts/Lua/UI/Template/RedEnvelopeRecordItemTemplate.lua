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
---@class RedEnvelopeRecordItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field HeadBox MoonClient.MLuaUICom
---@field FastFlag MoonClient.MLuaUICom
---@field FastestFlag MoonClient.MLuaUICom
---@field BestFlag MoonClient.MLuaUICom

---@class RedEnvelopeRecordItemTemplate : BaseUITemplate
---@field Parameter RedEnvelopeRecordItemTemplateParameter

RedEnvelopeRecordItemTemplate = class("RedEnvelopeRecordItemTemplate", super)
--lua class define end

--lua functions
function RedEnvelopeRecordItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function RedEnvelopeRecordItemTemplate:OnDestroy()

    self.head2d = nil

end --func end
--next--
function RedEnvelopeRecordItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function RedEnvelopeRecordItemTemplate:OnSetData(data)
    local l_mgr = MgrMgr:GetMgr("RedEnvelopeMgr")
    --名字与数量
    self.Parameter.Name.LabText = data.roleName
    self.Parameter.Number.LabText = tostring(data.itemNum)
    --特殊标记
    self.Parameter.BestFlag.UObj:SetActiveEx(data.specialFlagType == l_mgr.ESpecialFlagType.Best)
    self.Parameter.FastestFlag.UObj:SetActiveEx(data.specialFlagType == l_mgr.ESpecialFlagType.Fastest)
    self.Parameter.FastFlag.UObj:SetActiveEx(data.specialFlagType == l_mgr.ESpecialFlagType.Fast)

    --头像相关
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.HeadBox.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.memberInfo)
    }

    self.head2d:SetData(param)
end --func end
--next--
function RedEnvelopeRecordItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RedEnvelopeRecordItemTemplate