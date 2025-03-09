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
---@class ProbabilityRowTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Pro MoonClient.MLuaUICom
---@field Text_Name MoonClient.MLuaUICom
---@field Img_ItemIcon MoonClient.MLuaUICom

---@class ProbabilityRowTem : BaseUITemplate
---@field Parameter ProbabilityRowTemParameter

ProbabilityRowTem = class("ProbabilityRowTem", super)
--lua class define end

--lua functions
function ProbabilityRowTem:Init()

    super.Init(self)

end --func end
--next--
function ProbabilityRowTem:BindEvents()


end --func end
--next--
function ProbabilityRowTem:OnDestroy()


end --func end
--next--
function ProbabilityRowTem:OnDeActive()


end --func end
--next--
---@param data ProbabilityDetails
function ProbabilityRowTem:OnSetData(data)
    self.Parameter.Img_ItemIcon:SetActiveEx(data.RewardType == 1)
    local showStr = ""
    if data.RewardType == 1 then
        local ItemData = Data.BagApi:CreateLocalItemData(data.RewardID).ItemConfig
        showStr = ItemData.ItemName
        self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.Img_ItemIcon.transform,
            Data = { ID = ItemData.ItemID, IsShowTips = true, IsShowCount = false},
        })
    else
        showStr = data.SpecialDescription
    end
	if data.Value >1 then
		self.Parameter.Text_Name.LabText = StringEx.Format("{0}*{1}", showStr, data.Value)
	else
		self.Parameter.Text_Name.LabText = showStr
	end
    self.Parameter.Text_Pro.LabText = string.format("%.2f", data.Probability / 100) .. "%"
    self.Parameter.Img_Line.gameObject:SetActiveEx(data.Underline == 1)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ProbabilityRowTem