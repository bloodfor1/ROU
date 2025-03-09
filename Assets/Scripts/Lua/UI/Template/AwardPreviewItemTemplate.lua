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
---@class AwardPreviewItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text1 MoonClient.MLuaUICom
---@field Text2 MoonClient.MLuaUICom

---@class AwardPreviewItemTemplate : BaseUITemplate
---@field Parameter AwardPreviewItemTemplateParameter

AwardPreviewItemTemplate = class("AwardPreviewItemTemplate", super)
--lua class define end

--lua functions
function AwardPreviewItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function AwardPreviewItemTemplate:OnDestroy()
	
	
end --func end
--next--
function AwardPreviewItemTemplate:OnDeActive()
	
	
end --func end
--next--
function AwardPreviewItemTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function AwardPreviewItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
AwardPreviewItemTemplate.TemplatePath = "UI/Prefabs/AwardPreviewItemPrefab"

function AwardPreviewItemTemplate:CustomSetData(data)
    if data.isParticular then
        self.Parameter.Text1.LabText = Lang("RARE")
        self.Parameter.Text2.LabText = ""
    elseif data.dropRate and data.dropRate > 0 then
        self.Parameter.Text1.LabText = Lang("RATE")
        self.Parameter.Text2.LabText = string.rep("+", data.dropRate)
    elseif data.probablyType and data.probablyType ~= 0 then
        if data.probablyType == 1 then
            self.Parameter.Text1.LabText = Lang("RATE_SURE")
        elseif data.probablyType == 2 then
            self.Parameter.Text1.LabText = Lang("RATE_PROBABLY")
        end
        self.Parameter.Text2.LabText = ""
    else
        self.Parameter.Text1.LabText = ""
        self.Parameter.Text2.LabText = ""
    end
	
end
--lua custom scripts end
return AwardPreviewItemTemplate