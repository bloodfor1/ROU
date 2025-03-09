--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AddAttrSchoolsPanel"
require "UI/Template/AttrRecomItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AddAttrSchoolsCtrl = class("AddAttrSchoolsCtrl", super)
--lua class define end

--lua functions
function AddAttrSchoolsCtrl:ctor()

    super.ctor(self, CtrlNames.AddAttrSchools, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function AddAttrSchoolsCtrl:Init()

    self.panel = UI.AddAttrSchoolsPanel.Bind(self)
    super.Init(self)
    --self:SetBlockOpt(BlockColor.Dark)
    self.data = DataMgr:GetData("SkillData")
    self.recommendPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AttrRecomItemTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.AttrRecomItemTemplate.LuaUIGroup.gameObject
    })

    -- 成型预览
    self.panel.previewBtn:AddClick(function()
        if not self.selectedAttrData then return end
        local schoolId = self.selectedAttrData.recommentClassId
        UIMgr:ActiveUI(UI.CtrlNames.SchoolPreview, function(ctrl)
            local l_skillClassRecommandData = TableUtil.GetAutoAddSkilPointDetailTable().GetRowByID(schoolId).ClassRecommandId
            ctrl:InitWithRecommandId(l_skillClassRecommandData)
        end,{InsertPanelName=UI.CtrlNames.AddAttrSchools})
    end)

    -- 一键加点
    self.panel.addPointBtn:AddClick(function()
        if not self.selectedAttrData then return end
        local ui = UIMgr:GetUI(UI.CtrlNames.RoleAttr)
        if ui then
            if ui:IsShowing() then
                MgrMgr:GetMgr("RoleInfoMgr").AutoCalulateCom(self.selectedAttrData.recommendId)
            else
                local skillUi = UIMgr:GetUI(UI.CtrlNames.SkillLearning)
                if skillUi then
                    UIMgr:DeActiveUI(UI.CtrlNames.SkillLearning)
                end
                local l_RoleOpenData =
                {
                    openType = MgrMgr:GetMgr("RoleInfoMgr").ERoleInfoOpenType.AutoCalulateCom,
                    id = self.selectedAttrData.recommendId
                }
                UIMgr:ActiveUI(UI.CtrlNames.RoleAttr, l_RoleOpenData)
            end
        end
        UIMgr:DeActiveUI(UI.CtrlNames.AddAttrSchools)
    end)

    -- 流派推荐
    self.panel.recomBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AddAttrSchools)
        UIMgr:DeActiveUI(UI.CtrlNames.RoleAttr)
        local l_skillData =
        {
            openType = DataMgr:GetData("SkillData").OpenType.OpenProfessionalSchools
        }
        UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
    end)
    local curProType = self.data.CurrentProTypeAndId()
    self.panel.recomBtn:SetActiveEx(curProType >= self.data.ProfessionList.PRO_TWO)

    self.panel.closeBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AddAttrSchools)
    end)

end --func end
--next--
function AddAttrSchoolsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AddAttrSchoolsCtrl:OnActive()


end --func end
--next--
function AddAttrSchoolsCtrl:OnDeActive()


end --func end
--next--
function AddAttrSchoolsCtrl:Update()


end --func end





--next--
function AddAttrSchoolsCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function AddAttrSchoolsCtrl:InitWithAttrTypeId(id)
    local roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    local genreTable = roleInfoMgr.GetGenreIdByProfession(id)
    local datas = {}
    for i, v in ipairs(genreTable) do
        local genreInfo = roleInfoMgr.GetGenreDetailInfo(v)
		if genreInfo ~= nil then
			table.insert(datas, {
				recommendId = v,
				recommentClassId = genreInfo.recommendClass
			})
		end
    end
    self.recommendPool:ShowTemplates({Datas = datas})
    self.recommendPool:GetItem(1):Select(true)
    self.selectedAttrData = datas[1]
end

function AddAttrSchoolsCtrl:SelectAttr(data)
    if self.selectedAttrData then
        local item = self.recommendPool:GetTemplateWithData(self.selectedAttrData)
        if item then
            item:Select(false)
        end
    end
    self.selectedAttrData = data
end
--lua custom scripts end
return AddAttrSchoolsCtrl