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
---@class MakeHolePropertyPreviewTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyText MoonClient.MLuaUICom

---@class MakeHolePropertyPreviewTemplate : BaseUITemplate
---@field Parameter MakeHolePropertyPreviewTemplateParameter

MakeHolePropertyPreviewTemplate = class("MakeHolePropertyPreviewTemplate", super)
--lua class define end

--lua functions
function MakeHolePropertyPreviewTemplate:Init()
    super.Init(self)
end --func end
--next--
function MakeHolePropertyPreviewTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function MakeHolePropertyPreviewTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function MakeHolePropertyPreviewTemplate:OnSetData(data)
    local l_equipTextTable = TableUtil.GetEquipText().GetRowByID(data.PropertyDec)
    if l_equipTextTable == nil then
        logError("EquipText表没有配这个id：" .. tostring(data.PropertyDec))
        return
    end

    local l_text = ""
    for i = 0, l_equipTextTable.PreText.Length - 1 do
        l_text = l_text .. l_equipTextTable.PreText[i]
    end

    self.Parameter.PropertyText.LabText = MgrMgr:GetMgr("EquipMakeHoleMgr").GetColorTextWithHoleId(l_text, data.Id)
end --func end
--next--
function MakeHolePropertyPreviewTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MakeHolePropertyPreviewTemplate