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
---@class ChielfSkillCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ImportantDes MoonClient.MLuaUICom
---@field Des MoonClient.MLuaUICom

---@class ChielfSkillCell : BaseUITemplate
---@field Parameter ChielfSkillCellParameter

ChielfSkillCell = class("ChielfSkillCell", super)
--lua class define end

--lua functions
function ChielfSkillCell:Init()
	
	super.Init(self)
	
end --func end
--next--
function ChielfSkillCell:BindEvents()
	
	
end --func end
--next--
function ChielfSkillCell:OnDestroy()
	
	
end --func end
--next--
function ChielfSkillCell:OnDeActive()
	
	
end --func end
--next--
function ChielfSkillCell:OnSetData(data)
    local l_skillRow = TableUtil.GetLeaderMethodSkillTable().GetRowBySkillID(data.skillId)
    if l_skillRow then
        self.Parameter.Name.LabText = l_skillRow.Name
        self.Parameter.Des.LabText = RoColor.FormatWord(l_skillRow.SkillDesc)
        self.Parameter.ImportantDes:SetActiveEx(l_skillRow.ImportantSkillDesc ~= "")
        self.Parameter.ImportantDes.LabText = RoColor.FormatWord(l_skillRow.ImportantSkillDesc)

        LayoutRebuilder.ForceRebuildLayoutImmediate(self:transform())
    end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ChielfSkillCell