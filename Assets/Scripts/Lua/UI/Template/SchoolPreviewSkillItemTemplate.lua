--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)
--lua model end

--lua class define
local super = UITemplate.BaseUITemplate
SchoolPreviewSkillItemTemplate = class("SchoolPreviewSkillItemTemplate", super)
--lua class define end

--lua functions
function SchoolPreviewSkillItemTemplate:Init()

    super.Init(self)
    self.data = DataMgr:GetData("SkillData")

end --func end
--next--
function SchoolPreviewSkillItemTemplate:OnDeActive()

    self.data = nil

end --func end
--next--
function SchoolPreviewSkillItemTemplate:OnSetData(data)

    local l_skillId = data.id
    local l_parent = data.parent
    local l_skillData = self.data.GetDataFromTable("SkillTable", l_skillId)
    local l_requiredSkill = l_skillData.PreSkillRequired
    self.Parameter.BtnSkill:SetSprite(l_skillData.Atlas, l_skillData.Icon)
    self.Parameter.TxtSkillName.LabText = Common.Utils.GetCutOutText(l_skillData.Name, 4)
    self.Parameter.BtnSkill:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.SkillPointTip, function(ctrl)
            ctrl.panel.btnClosePanel.gameObject:SetActiveEx(true)
            ctrl.panel.btnClosePanel:AddClick(function()
                UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
            end)
            ctrl:InitWithSkillId(l_skillId, self.data.SkillTipState.SELECT_SHOW_SLOT, nil, nil, false)
            ctrl:AutoSize()
        end)
    end)
    if l_requiredSkill.Count <= 0 or l_requiredSkill:get_Item(0, 0) == 0 then
        self.Parameter.TxtLv.gameObject:SetActiveEx(false)
    else
        local l_requiredSkillData = self.data.GetDataFromTable("SkillTable", l_requiredSkill:get_Item(0, 0))
        self.Parameter.TxtLv.gameObject:SetActiveEx(true)
        self.Parameter.TxtLv.LabText = StringEx.Format(Lang("SKILLLEARNING_NEED_PRESKILL", l_requiredSkillData.Name, l_requiredSkill:get_Item(0, 1)))
    end

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
