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
---@class MercenarySelectCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selection MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Location MoonClient.MLuaUICom
---@field JobImg MoonClient.MLuaUICom
---@field Explain MoonClient.MLuaUICom

---@class MercenarySelectCell : BaseUITemplate
---@field Parameter MercenarySelectCellParameter

MercenarySelectCell = class("MercenarySelectCell", super)
--lua class define end

--lua functions
function MercenarySelectCell:Init()
	
	super.Init(self)
	
end --func end
--next--
function MercenarySelectCell:BindEvents()
	
	
end --func end
--next--
function MercenarySelectCell:OnDestroy()
	
	
end --func end
--next--
function MercenarySelectCell:OnDeActive()
	
	
end --func end
--next--
function MercenarySelectCell:OnSetData(data)
	self.mercenaryId = data.mercenaryId
	local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(self.mercenaryId)
    if not l_mercenaryRow then return end

    self.Parameter.HeadImg:SetSprite(l_mercenaryRow.MercenaryAtlas, l_mercenaryRow.MercenaryIcon, true)
    self.Parameter.HeadImg:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MercenaryRecommendation)
        MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(l_mercenaryRow.RecruitTask[0])
        local l_jobName = ""
        local l_jobRow = TableUtil.GetProfessionTable().GetRowById(l_mercenaryRow.Profession)
        if l_jobRow then l_jobName = l_jobRow.Name end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_SELECTION", l_jobName, l_mercenaryRow.Name))
    end)

    self.Parameter.Recommend:SetActiveEx(MgrMgr:GetMgr("MercenaryMgr").IsMercenaryRecommend(self.mercenaryId))

    local l_jobRow = TableUtil.GetProfessionTable().GetRowById(l_mercenaryRow.Profession)
    if l_jobRow then
        self.Parameter.JobImg:SetSprite("Common", l_jobRow.ProfessionIcon)
    end
    self.Parameter.Name.LabText = l_mercenaryRow.Name
    self.Parameter.Location.LabText = l_mercenaryRow.Duty
    self.Parameter.Explain.LabText = l_mercenaryRow.SchoolsText
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenarySelectCell