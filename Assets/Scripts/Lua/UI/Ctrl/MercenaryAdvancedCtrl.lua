--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenaryAdvancedPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MercenaryAdvancedCtrl = class("MercenaryAdvancedCtrl", super)
--lua class define end

--lua functions
function MercenaryAdvancedCtrl:ctor()

    super.ctor(self, CtrlNames.MercenaryAdvanced, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function MercenaryAdvancedCtrl:Init()
    self.panel = UI.MercenaryAdvancedPanel.Bind(self)

    super.Init(self)
    self.fixSkillTemplatePool = nil
    self.attrTemplatePool = nil
    self.advAttrTemplatePool = nil
    self.mercenaryInfo = nil
    self.conditionPool = nil

    self:InitPanel()
end --func end
--next--
function MercenaryAdvancedCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MercenaryAdvancedCtrl:OnActive()


end --func end
--next--
function MercenaryAdvancedCtrl:OnDeActive()
    if self.mercenaryModel then
        self:DestroyUIModel(self.mercenaryModel)
        self.mercenaryModel = nil
    end

end --func end
--next--
function MercenaryAdvancedCtrl:Update()


end --func end





--next--
function MercenaryAdvancedCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function MercenaryAdvancedCtrl:InitPanel()
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MercenaryAdvanced)
    end)
end

function MercenaryAdvancedCtrl:SetData(mercenaryInfo)
    if not mercenaryInfo then
        return
    end

    self.mercenaryInfo = MgrMgr:GetMgr("MercenaryMgr").GetMercenaryInfoFromTable(tonumber(mercenaryInfo.tableInfo.Id) + 1, false)
    local l_tableInfo = self.mercenaryInfo.tableInfo

    local l_JobTableInfo = TableUtil.GetProfessionTable().GetRowById(l_tableInfo.Profession)

    self.panel.JobIcon:SetSpriteAsync(mercenaryInfo.tableInfo.AdvancedIconAtlas, mercenaryInfo.tableInfo.AdvancedIcon)
    self.panel.JobText.LabText = l_JobTableInfo.Name
    self.panel.JobEnglishText.LabText = l_JobTableInfo.EnglishName
    self.panel.merNametext.LabText = l_tableInfo.Name
    self.panel.SchoolText.LabText = l_tableInfo.Schools
    self.panel.SchoolDescText.LabText = l_tableInfo.SchoolsText
    local rtTrans = self.panel.LayOut.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
    --设置佣兵模型
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(l_tableInfo.Id)
    if l_mercenaryRow then
        local l_presentRow = TableUtil.GetPresentTable().GetRowById(l_mercenaryRow.PresentID)
        if l_presentRow then
            if self.mercenaryModel then
                self:DestroyUIModel(self.mercenaryModel)
            end
            local l_modelData = 
            {
                defaultEquipId = l_mercenaryRow.DefaultEquipID,
                presentId = l_mercenaryRow.PresentID,
                rawImage = self.panel.ModelImage.RawImg
            }
            self.mercenaryModel = self:CreateUIModelByDefaultEquipId(l_modelData)
        end

    end
    --设置佣兵技能

    local l_SkillData = {}

    self.mercenaryInfo.isRecruited = true
    for _, v in pairs(self.mercenaryInfo.skillInfo) do
        --if not v.isOptionSkill then
            table.insert(l_SkillData, { skillInfo = v, mercenaryInfo = self.mercenaryInfo, isFromAdvance = true })
        --end
    end

    if not self.fixSkillTemplatePool then
        self.fixSkillTemplatePool = self:NewTemplatePool({
            TemplateClassName = "MercenarySkillCellTemplate",
            TemplatePath = "UI/Prefabs/MercenarySkillCellTemplate",
            ScrollRect = self.panel.SvSkill.LoopScroll,
        })
    end
    self.fixSkillTemplatePool:ShowTemplates({ Datas = l_SkillData, AdditionalData = Vector3.New(0.8, 0.8, 0.8) })

    --设置佣兵进阶属性

    local l_AttrData = {}

    local l_attrRow = TableUtil.GetAttraddRecomTable().GetRowByProfession(99 .. "|" .. l_tableInfo.Point)
    if l_attrRow then
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_STR") .. "Str", value = l_attrRow.STR })
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_VIT") .. "Vit", value = l_attrRow.VIT })
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_AGI") .. "Agi", value = l_attrRow.AGI })
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_INT") .. "Int", value = l_attrRow.INT })
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_DEX") .. "Dex", value = l_attrRow.DEX })
        table.insert(l_AttrData, { isAdvance = true, name = Common.Utils.Lang("ATTR_LUCK") .. "Luk", value = l_attrRow.LUK })
    end

    --for _, v in pairs(l_Attr) do
    --    table.insert(l_AttrData, { attrInfo = v, isRecruited = true })
    --end
    --table.sort(l_AttrData, function(a, b)
    --    return a.attrInfo.tableInfo.ShortId < b.attrInfo.tableInfo.ShortId
    --end)
    if not self.attrTemplatePool then
        self.attrTemplatePool = self:NewTemplatePool({
            TemplateClassName = "MercenaryAttrCellTemplate",
            TemplatePath = "UI/Prefabs/MercenaryAttrCellTemplate",
            ScrollRect = self.panel.SvNumericalvalue.LoopScroll,
        })
    end
    self.attrTemplatePool:ShowTemplates({ Datas = l_AttrData })

    --设置进阶条件
    local l_advData = {}
    local Conditions = mercenaryInfo.tableInfo.AdvancedCondition
    table.insert(l_advData, { curlvl = mercenaryInfo.level, targetlvl = Conditions[0] })
    table.insert(l_advData, { curlvl = mercenaryInfo.level, targetlvl = Conditions[0], taskId = Conditions[1] })
    if not self.conditionPool then
        self.conditionPool = self:NewTemplatePool({
            TemplateClassName = "AdvancedConditionTem",
            TemplatePrefab = self.panel.AdvancedConditionTem.LuaUIGroup.gameObject,
            ScrollRect = self.panel.SvCondition.LoopScroll,
        })
    end
    self.conditionPool:ShowTemplates({ Datas = l_advData })

    local l_advAttrData = {}
    local l_Attr = MgrMgr:GetMgr("MercenaryMgr").GetMercenaryAttrs(tonumber(mercenaryInfo.tableInfo.Id) + 1, 1)
    local l_advAttr = MgrMgr:GetMgr("MercenaryMgr").GetMercenaryAttrs(tonumber(mercenaryInfo.tableInfo.Id), Conditions[0])
    for k, v in pairs(l_advAttr) do
        if l_Attr[k] then
            l_advAttr[k].value = l_Attr[k].value - l_advAttr[k].value
        end
        table.insert(l_advAttrData, { attrInfo = v, isRecruited = true })
    end
    table.sort(l_advAttrData, function(a, b)
        return a.attrInfo.tableInfo.ShortId < b.attrInfo.tableInfo.ShortId
    end)
    if not self.advAttrTemplatePool then
        self.advAttrTemplatePool = self:NewTemplatePool({
            TemplateClassName = "MercenaryAttrCellTemplate",
            TemplatePath = "UI/Prefabs/MercenaryAttrCellTemplate",
            ScrollRect = self.panel.SvNumericalvalue2.LoopScroll,
        })
    end
    self.advAttrTemplatePool:ShowTemplates({ Datas = l_advAttrData })

    self.panel.Transfer1Tog.TogEx.isOn = true
    self.panel.Transfer2Tog.TogEx.isOn = false
    self.panel.Transfer2Tog.TogEx.onValueChanged:AddListener(function(value)
        if value then
            self.panel.Transfer1Tog.TogEx.isOn = true
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MERCENARY_ADVANCE_ISNTOPEN"))
        end

    end)
end


--lua custom scripts end
return MercenaryAdvancedCtrl