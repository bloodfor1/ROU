--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SetIllustrationPanel"
require "UI/Template/SelectEquipSuitTemplate"
require "UI/Template/SuitEquipementTemplate"
require "UI/Template/SuitEquipmentAttrTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SetIllustrationCtrl = class("SetIllustrationCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("SuitMgr")
--lua functions
function SetIllustrationCtrl:ctor()

    super.ctor(self, CtrlNames.SetIllustration, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function SetIllustrationCtrl:Init()

    self.panel = UI.SetIllustrationPanel.Bind(self)
    super.Init(self)

    self.panel.ButtonFilter:AddClick(function()
        self:ClickFilter()
    end)

    self.panel.CloseButton:AddClick(function()
        self:CloseUI()
    end)

    self.panel.QuestionText:AddClick(function()
        self:OnClickQuestion()
    end)

    self.selectSuitTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SelectEquipSuitTemplate,
        TemplatePrefab = self.panel.SelectEquipSuitTemplate.gameObject,
        TemplateParent = self.panel.SuitContent.Transform,
    })

    self.suitEquipTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SuitEquipementTemplate,
        TemplatePrefab = self.panel.SuitEquipementTemplate.gameObject,
        TemplateParent = self.panel.Content.Transform,
    })

    self.suitAttrTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SuitEquipmentAttrTemplate,
        TemplatePrefab = self.panel.SuitEquipmentAttrTemplate.gameObject,
        TemplateParent = self.panel.AttrContent.Transform,
    })

    self.lastSelectFilter = nil
    self.curSelectFilter = nil
    self.filterDatas = nil
    self.originalDatas = nil
    self.professionDatas = nil
    self.selectSuitId = nil
    self.cachedSuitInfo = {}

    self.data = DataMgr:GetData("SuitData")
end --func end
--next--
function SetIllustrationCtrl:Uninit()

    self.lastSelectFilter = nil
    self.curSelectFilter = nil
    self.selectSuitTemplatePool = nil
    self.filterDatas = nil
    self.originalDatas = nil
    self.professionDatas = nil
    self.selectSuitId = nil
    self.cachedSuitInfo = nil
    self.suitAttrTemplatePool = nil

    self.data = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SetIllustrationCtrl:OnActive()
    self:CustomRefresh()
end --func end
--next--
function SetIllustrationCtrl:OnDeActive()


end --func end
--next--
function SetIllustrationCtrl:Update()


end --func end




--next--
function SetIllustrationCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function SetIllustrationCtrl:CloseUI()
    UIMgr:DeActiveUI(self.name)
end

function SetIllustrationCtrl:ClickFilter()

    UIMgr:ActiveUI(UI.CtrlNames.SelectBox, function(ctrl)
        ctrl:ShowSelectBox(self.professionDatas, function(data)
            self.curSelectFilter = data.index
            self.selectSuitId = nil
            self:CustomRefresh()
        end)
    end)
end

function SetIllustrationCtrl:CustomRefresh()

    if self.originalDatas == nil then
        self.originalDatas = {}
        local l_datas = TableUtil.GetSuitTable().GetTable()
        for i, v in ipairs(l_datas) do
            table.insert(self.originalDatas, v)
        end

        table.sort(self.originalDatas, function(m, n)
            return m.SortId < n.SortId
            
        end)
    end

    if self.professionDatas == nil then
        self.professionDatas = {}
        local professionTable = TableUtil.GetProfessionTable().GetTable()
        for k, v in pairs(professionTable) do
            if v.ParentProfession ~= -1 and (v.ParentProfession == 1000) then
                v.name = v.Name
                table.insert(self.professionDatas, v)
            end
        end
        table.insert(self.professionDatas, {Id = 0, name = Lang("ILLUSTRATION_DROPDOWN_MAIN")})
        table.sort(self.professionDatas, function(m, n)
            return m.Id < n.Id
        end)

        self.curSelectFilter = 1
        for i, v in ipairs(self.professionDatas) do
            v.index = i
            if v.Id == MPlayerInfo.ProfessionId then
                self.curSelectFilter = i
            end
        end
    end

    local l_curProfession = self.professionDatas[self.curSelectFilter]

    if self.lastSelectFilter ~= self.curSelectFilter then
        self.lastSelectFilter = self.curSelectFilter

        if l_curProfession.Id == 0 then
            self.filterDatas = self.originalDatas
        else
            self.filterDatas = {}
            for k, v in pairs(self.originalDatas) do
                for i = 0, v.ProfessionId.Count - 1 do
                    if v.ProfessionId[i] == l_curProfession.Id then
                        table.insert(self.filterDatas, v)
                    end
                end

            end
            table.sort(self.filterDatas, function(m, n)
                return m.SortId < n.SortId
            end)
        end
    end

    self.panel.SelectTypeButtonName.LabText = l_curProfession.name

    if self.selectSuitId == nil then
        local _, l_firstSuitRow = next(self.filterDatas)
        if not l_firstSuitRow then
            self.panel.TextName.LabText = Lang("NONE_SUIT_MATCH_PROFESSION")
            self.panel.NoneEquipText.gameObject:SetActiveEx(true)
            self.panel.SuitInfo.gameObject:SetActiveEx(false)
            self.panel.SuitDetail.gameObject:SetActiveEx(false)
        else
            self:SelectSuit(l_firstSuitRow.SuitId)
            self.panel.NoneEquipText.gameObject:SetActiveEx(false)
            self.panel.SuitInfo.gameObject:SetActiveEx(true)
            self.panel.SuitDetail.gameObject:SetActiveEx(true)
        end
    end

    for i, v in ipairs(self.filterDatas) do
        v.selected = (v.SuitId == self.selectSuitId)
    end

    self.selectSuitTemplatePool:ShowTemplates({Datas = self.filterDatas, Method = function(id)
        self:SelectSuit(id)
        self:RefreshAllSuitTemplate()
    end})
end

function SetIllustrationCtrl:SelectSuit(id)
    if self.selectSuitId == id then
        return
    end
    self.selectSuitId = id
    self:RefreshSuitInfo()
end

function SetIllustrationCtrl:GetItemsBySuitComponents(component)

    local l_mark = {}
    local l_isPc = not (MGameContext.IsAndroid or MGameContext.IsIOS)

    local l_result = {}
    local l_secondIdMap = {}
    local l_minLevel = 10000
    local ESuitEquipComponentType = DataMgr:GetData("SuitData").ESuitEquipComponentType
    for i = 0, component.Length - 1 do
        local l_listInfo = component[i]
        if l_listInfo.Length >= 2 then
            local l_type = l_listInfo[0]
            if l_type == ESuitEquipComponentType.EquipSecondID then
                for j = 1, l_listInfo.Length - 1 do
                    l_secondIdMap[l_listInfo[j]] = true
                end
            else
                for j = 1, l_listInfo.Length - 1 do
                    table.insert(l_result, l_listInfo[j])
                end
            end
        end
    end

    local l_getItemRowFunc = TableUtil.GetItemTable().GetRowByItemID
    -- 记录secondid对应的等级最低的装备(其余装备不需要)
    local l_equipsTmp = {}
    for i, v in ipairs(TableUtil.GetEquipTable().GetTable()) do
        if l_secondIdMap[v.EquipSecondId] then
            local equipItem = l_getItemRowFunc(v.Id)
            if equipItem == nil then
                logError("SetIllustrationCtrl:GetItemsBySuitComponents ItemTable中找不到 id => " .. v.Id)
            else
                -- table.insert(l_result, v.Id)
                local minLevel = equipItem.LevelLimit:get_Item(0)
                if minLevel < l_minLevel then
                    l_minLevel = minLevel
                end
                if not l_equipsTmp[v.EquipSecondId] then
                    l_equipsTmp[v.EquipSecondId] = {
                        id = v.Id,
                        level = minLevel
                    }
                else
                    if l_equipsTmp[v.EquipSecondId].level > minLevel then
                        l_equipsTmp[v.EquipSecondId].level = minLevel
                        l_equipsTmp[v.EquipSecondId].id = v.Id
                    end
                end
            end
            if l_isPc then
                l_mark[v.EquipSecondId] = true
            end
        end
    end

    for k, v in pairs(l_equipsTmp) do
        table.insert(l_result, v.id)
    end

    if l_isPc then
        for k, v in pairs(l_secondIdMap) do
            if not l_mark[k] then
                logError("SetIllustrationCtrl:GetItemsBySuitComponents error, 配置的套装装备SecondID在equiptable表找不到", k)
            end
        end
    end

    table.sort(l_result, function(m, n)
        return n < n
    end)

    return l_result, l_minLevel
end

function SetIllustrationCtrl:RefreshSuitInfo()

    local l_rowSuit = TableUtil.GetSuitTable().GetRowBySuitId(self.selectSuitId)
    if not l_rowSuit then
        logError("SetIllustrationCtrl:RefreshSuitInfo error, cannot find suit", self.selectSuitId)
        return
    end

    -- name
    self.panel.SuitName.LabText = l_rowSuit.Dec

    -- suit euqipments
    local l_items = nil
    if self.cachedSuitInfo[self.selectSuitId] then
        l_items = self.cachedSuitInfo[self.selectSuitId]
    else
        self.cachedSuitInfo[self.selectSuitId] = self:GetItemsBySuitComponents(l_rowSuit.ComponentID)
        l_items = self.cachedSuitInfo[self.selectSuitId]
    end
    self.suitEquipTemplatePool:ShowTemplates({Datas = l_items})

    local l_attrList = self:GetSuitAttrList(l_rowSuit)
    -- 额外添加一个推荐流派词条
    local l_recomand = MgrMgr:GetMgr("SuitMgr").GetRecommandInfo(l_rowSuit.RecommendSchool)
    if string.len(l_recomand) > 0 then
        table.insert(l_attrList, {
            customFormat = Lang("SKILLLEARNING_RECOMMAND_SKILL_CLASS"),
            desc = l_recomand
        })
    end
    
    self.suitAttrTemplatePool:ShowTemplates({Datas = l_attrList})
end

function SetIllustrationCtrl:RefreshAllSuitTemplate()
    local l_templates = self.selectSuitTemplatePool:GetItems()
    for k, v in pairs(l_templates) do
        v:SetSelected(v.SuitId == self.selectSuitId)
    end
end

function SetIllustrationCtrl:GetSuitAttrList(row)
    local l_result = {}

    for i = 2, table.maxn(self.data.SuitDescKey) do
        local l_desc = row[self.data.SuitDescKey[i]]
        if l_desc and string.len(l_desc) > 0 then
            table.insert(l_result, {
                count = i,
                desc = l_desc
            })
        end
    end

    return l_result
end

function SetIllustrationCtrl:OnClickQuestion()
    local l_content = Common.Utils.Lang("SUIT_HELP_DESC")
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.MiddleLeft,
        pos = {
            x = 398,
            y = 242,
        },
        width = 400,
    })
end
--lua custom scripts end

return SetIllustrationCtrl