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
---@class EnchantBuffPropertyPreviewTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RecommendSign MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BuffName MoonClient.MLuaUICom

---@class EnchantBuffPropertyPreviewTemplate : BaseUITemplate
---@field Parameter EnchantBuffPropertyPreviewTemplateParameter

EnchantBuffPropertyPreviewTemplate = class("EnchantBuffPropertyPreviewTemplate", super)
--lua class define end

--lua functions
function EnchantBuffPropertyPreviewTemplate:Init()
    super.Init(self)
end --func end
--next--
function EnchantBuffPropertyPreviewTemplate:OnDestroy()

end --func end
--next--
function EnchantBuffPropertyPreviewTemplate:OnDeActive()

end --func end
--next--
function EnchantBuffPropertyPreviewTemplate:OnSetData(data)
    local l_text, l_count, l_isShowRecommendSign = MgrMgr:GetMgr("EnchantMgr").GetPropertyPreviewShowData(data)
    self.Parameter.BuffName.LabText = l_text
    self.Parameter.Count.LabText = l_count
    self.Parameter.RecommendSign:SetActiveEx(l_isShowRecommendSign)
end --func end
--next--
function EnchantBuffPropertyPreviewTemplate:BindEvents()

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return EnchantBuffPropertyPreviewTemplate