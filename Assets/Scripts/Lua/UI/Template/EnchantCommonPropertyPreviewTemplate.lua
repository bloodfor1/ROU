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
---@class EnchantCommonPropertyPreviewTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RecommendSign MoonClient.MLuaUICom
---@field PropertyName MoonClient.MLuaUICom
---@field PropertyCount MoonClient.MLuaUICom

---@class EnchantCommonPropertyPreviewTemplate : BaseUITemplate
---@field Parameter EnchantCommonPropertyPreviewTemplateParameter

EnchantCommonPropertyPreviewTemplate = class("EnchantCommonPropertyPreviewTemplate", super)
--lua class define end

--lua functions
function EnchantCommonPropertyPreviewTemplate:Init()

    super.Init(self)

end --func end
--next--
function EnchantCommonPropertyPreviewTemplate:OnDestroy()


end --func end
--next--
function EnchantCommonPropertyPreviewTemplate:OnDeActive()


end --func end
--next--
function EnchantCommonPropertyPreviewTemplate:OnSetData(data)
    local l_text, l_count, l_isShowRecommendSign = MgrMgr:GetMgr("EnchantMgr").GetPropertyPreviewShowData(data)
    self.Parameter.PropertyName.LabText = l_text
    self.Parameter.PropertyCount.LabText = l_count
    self.Parameter.RecommendSign:SetActiveEx(l_isShowRecommendSign)

end --func end
--next--
function EnchantCommonPropertyPreviewTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return EnchantCommonPropertyPreviewTemplate