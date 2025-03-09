--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ProfessionalSchoolsPanel"
require "UI/Template/SkillRecomItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ProfessionalSchoolsCtrl = class("ProfessionalSchoolsCtrl", super)
--lua class define end

--lua functions
function ProfessionalSchoolsCtrl:ctor()

    super.ctor(self, CtrlNames.ProfessionalSchools, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    self.selectedSchool = -1

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function ProfessionalSchoolsCtrl:Init()

    self.panel = UI.ProfessionalSchoolsPanel.Bind(self)
    super.Init(self)

    --self:SetBlockOpt(BlockColor.Dark)

    self.skillSchoolPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SkillRecomItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.SkillRecomItemTemplate.LuaUIGroup.gameObject
    })

    -- 成型预览
    self.panel.previewBtn:AddClick(function()
        if not self.selectedSchoolData then end
        local schoolId = self.selectedSchoolData.schoolId

        UIMgr:ActiveUI(UI.CtrlNames.SchoolPreview, function(ctrl)
            local l_skillClassRecommandData = TableUtil.GetAutoAddSkilPointDetailTable().GetRowByID(schoolId).ClassRecommandId
            ctrl:InitWithRecommandId(l_skillClassRecommandData)
        end,{InsertPanelName=UI.CtrlNames.ProfessionalSchools})
    end)

    -- 推荐加点
    self.panel.addPointBtn:AddClick(function()
        if not self.selectedSchoolData then end
        local schoolId = self.selectedSchoolData.schoolId
        UIMgr:DeActiveUI(UI.CtrlNames.ProfessionalSchools)
        local skillCtrl = UIMgr:GetUI(UI.CtrlNames.SkillLearning)
        if skillCtrl ~= nil then
            skillCtrl:RecommandAddSkillPoint(schoolId)
        end
    end)

    -- 素质推荐
    self.panel.recomBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.ProfessionalSchools)
        UIMgr:DeActiveUI(UI.CtrlNames.SkillLearning)
        local l_RoleOpenData =
        {
            openType = MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.OpenAddAttrSchools,
        }
        UIMgr:ActiveUI(UI.CtrlNames.RoleAttr, l_RoleOpenData)
    end)

    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.ProfessionalSchools)
    end)

end --func end
--next--
function ProfessionalSchoolsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.skillSchoolPool = nil
    self.selectedSchool = -1

end --func end
--next--
function ProfessionalSchoolsCtrl:OnActive()
    self.panel.SkillRecomItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
end --func end
--next--
function ProfessionalSchoolsCtrl:OnDeActive()

end --func end

--next--
function ProfessionalSchoolsCtrl:Update()

end --func end

--next--
function ProfessionalSchoolsCtrl:BindEvents()

end --func end

--next--
--lua functions end
--lua custom scripts
function ProfessionalSchoolsCtrl:InitWithProfessionId(proId)

    local datas = {}
    local schoolList = TableUtil.GetAutoAddSkillPointTable().GetRowByProfessionId(proId).ProDetailId
    schoolList = Common.Functions.VectorToTable(schoolList)
    for i, v in ipairs(schoolList) do
        table.insert(datas, {
            schoolId = v
        })
    end
    self.skillSchoolPool:ShowTemplates({Datas = datas})
    self.skillSchoolPool:GetItem(1):Select(true)
    self.selectedSchoolData = datas[1]

end

function ProfessionalSchoolsCtrl:SelectAttr(data)

    if self.selectedAttrData then
        local item = self.recommendPool:GetTemplateWithData(self.selectedAttrData)
        if item then
            item:Select(false)
        end
    end
    self.selectedAttrData = data

end

function ProfessionalSchoolsCtrl:SelectSchool(data)

    if self.selectedSchoolData then
        local item = self.skillSchoolPool:GetTemplateWithData(self.selectedSchoolData)
        if item then
            item:Select(false)
        end
    end
    self.selectedSchoolData = data

end
--lua custom scripts end
return ProfessionalSchoolsCtrl