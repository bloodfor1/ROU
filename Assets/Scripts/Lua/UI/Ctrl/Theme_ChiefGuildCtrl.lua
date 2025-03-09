--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_ChiefGuildPanel"
require "UI/Template/ChielfSkillCell"
require "UI/Template/ChiefGuildCell"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Theme_ChiefGuildCtrl = class("Theme_ChiefGuildCtrl", super)
--lua class define end

--lua functions
function Theme_ChiefGuildCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_ChiefGuild, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function Theme_ChiefGuildCtrl:Init()
	
	self.panel = UI.Theme_ChiefGuildPanel.Bind(self)
	super.Init(self)


    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Theme_ChiefGuild)
    end)

    -- 首领列表
    self.leaderPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ChiefGuildCell,
        TemplatePrefab = self.panel.ChiefGuildCell.LuaUIGroup.gameObject,
        ScrollRect = self.panel.Guild_Scroll.LoopScroll,
        Method = function(index, leaderId)
            self.leaderPool:SelectTemplate(index)
            self:OnLeaderCellSelected(leaderId)
        end
    })

    -- 首领技能列表
    self.skillPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ChielfSkillCell,
        TemplatePrefab = self.panel.ChielfSkillCell.LuaUIGroup.gameObject,
        ScrollRect = self.panel.Skill_Scroll.LoopScroll,
    })


    -- 初始化左侧标签
    self.tabTogs = {}
    local l_tabTable= TableUtil.GetLeaderMethodTabTable().GetTable()
    for i = 1, #l_tabTable do
        local l_tabTog = self:CloneObj(self.panel.TabTog.gameObject)
        l_tabTog.transform:SetParent(self.panel.TabTog.transform.parent)
        MLuaCommonHelper.SetLocalScale(l_tabTog, 1, 1, 1)
        local l_togCom = l_tabTog:GetComponent("MLuaUICom")
        local l_textComOn = l_tabTog.transform:Find("ON/TagTextOn"):GetComponent("MLuaUICom")
        local l_textComOff = l_tabTog.transform:Find("OFF/TagTextOff"):GetComponent("MLuaUICom")
        self.tabTogs[l_tabTable[i].ID] = {tabTog = l_togCom.TogEx, tabText = l_textCom}

        l_togCom.TogEx.onValueChanged:AddListener(function(value)
            if value then
                self:OnTabSelected(l_tabTable[i].ID)
            end
        end)
        l_textComOn.LabText = l_tabTable[i].TabName
        l_textComOff.LabText = l_tabTable[i].TabName

        -- 默认选中第一个
        if i == 1 then l_togCom.TogEx.isOn = true end
    end
    self.panel.TabTog.gameObject:SetActiveEx(false)
end --func end
--next--
function Theme_ChiefGuildCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Theme_ChiefGuildCtrl:OnActive()
    if self.uiPanelData  and self.uiPanelData.leaderId then
        self:SelectLeader(self.uiPanelData.leaderId)
    end
	
end --func end
--next--
function Theme_ChiefGuildCtrl:OnDeActive()
    self.leaderHeadTogs = nil
	
end --func end
--next--
function Theme_ChiefGuildCtrl:Update()
	
	
end --func end
--next--
function Theme_ChiefGuildCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function Theme_ChiefGuildCtrl:OnTabSelected(tabId)
    local l_togExGroup = self.panel.Content.TogExGroup
    local l_leaderDatas = {}
    for _, v in pairs(TableUtil.GetLeaderMethodDetailTable().GetTable()) do
        if v.TabType == tabId then
            table.insert(l_leaderDatas, {leaderId = v.LeaderID, sortId = v.SortID})
        end
    end
    table.sort(l_leaderDatas, function(a, b)
        return a.sortId < b.sortId
    end)
    self.leaderPool:ShowTemplates({Datas = l_leaderDatas})

    -- 默认选中第一个
    self.leaderPool:SelectTemplate(1)
    self:OnLeaderCellSelected(l_leaderDatas[1].leaderId)
end

function Theme_ChiefGuildCtrl:OnLeaderCellSelected(leaderId)
    local l_leaderRow = TableUtil.GetLeaderMethodDetailTable().GetRowByLeaderID(leaderId)
    if not l_leaderRow then return end
    -- 首领头像
    self.headLeaderIds = {}
    table.insert(self.headLeaderIds, l_leaderRow.LeaderID)
    for i = 0, l_leaderRow.DeputyLeaderIds.Length-1 do
        table.insert(self.headLeaderIds, l_leaderRow.DeputyLeaderIds[i])
    end
    if not self.leaderHeadTogs then
        self.leaderHeadTogs = {}
        self.panel.HeadTog.gameObject:SetActiveEx(false)
    end
    for i = 1, #self.headLeaderIds do
        if not self.leaderHeadTogs[i] then
            local l_headClone = self:CloneObj(self.panel.HeadTog.gameObject)
            l_headClone.transform:SetParent(self.panel.HeadTog.transform.parent)
            MLuaCommonHelper.SetLocalScale(l_headClone, 1, 1, 1)
            self.leaderHeadTogs[i] = {go = l_headClone,
                                      togEx = l_headClone:GetComponent("MLuaUICom").TogEx,
                                      onImg = l_headClone.transform:Find("On/Image/OnImg"):GetComponent("MLuaUICom"),
                                      offImg = l_headClone.transform:Find("Off/Image/OffImg"):GetComponent("MLuaUICom")
            }
            self.leaderHeadTogs[i].togEx.onValueChanged:AddListener(function(isOn)
                if isOn then
                    self:RefreshLeaderDetail(self.headLeaderIds[i])
                end
            end)
        end
        local l_childLeaderRow = TableUtil.GetLeaderMethodDetailTable().GetRowByLeaderID(self.headLeaderIds[i])
        if l_childLeaderRow then
            self.leaderHeadTogs[i].onImg:SetSpriteAsync(l_childLeaderRow.HeadAtlas, l_childLeaderRow.HeadIcon, nil, true)
            self.leaderHeadTogs[i].offImg:SetSpriteAsync(l_childLeaderRow.HeadAtlas, l_childLeaderRow.HeadIcon, nil, true)
        end
        self.leaderHeadTogs[i].go:SetActiveEx(true)
    end
    for i = #self.headLeaderIds+1, #self.leaderHeadTogs do
        self.leaderHeadTogs[i].go:SetActiveEx(false)
    end

    -- 默认选中第一个
    if self.leaderHeadTogs[1] then self.leaderHeadTogs[1].togEx.isOn = true end

    self:RefreshLeaderDetail(leaderId)
end

-- 详细信息
function Theme_ChiefGuildCtrl:RefreshLeaderDetail(leaderId)
    local l_leaderRow = TableUtil.GetLeaderMethodDetailTable().GetRowByLeaderID(leaderId)
    ---@type EntityTable
    local l_entityRow = TableUtil.GetEntityTable().GetRowById(leaderId)
    if not l_leaderRow or  not l_entityRow then return end
    self.panel.Name.LabText = l_entityRow.Name
    self.panel.DesText.LabText = l_leaderRow.Des
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.DesText.transform.parent)
    local l_attrRow = TableUtil.GetElementAttr().GetRowByAttrId(l_entityRow.UnitAttrType)
    if l_attrRow then
        self.panel.AttrText.LabText = l_attrRow.ColourTextDefence
        --local l_color = RoColor.Hex2Color(RoBgColor[l_attrRow.Colour])
        --if l_color then
        --    self.panel.AttrImg.Img.color = l_color
        --end
    end
    self.panel.SizeText.LabText = Lang("UnitSize_" .. tostring(l_entityRow.UnitSize)) .. Lang("ILLUSTRATION_DROPDOWN_MONSTER_TIXING")
    local l_raceRow= TableUtil.GetRaceEnum().GetRowById(l_entityRow.UnitRace)
    if l_raceRow then
        self.panel.RaceText.LabText = l_raceRow.Text
    end

    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.AttrText, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.SizeText, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.RaceText, nil, Vector2.New(1, 1))

    local l_skillDatas = {}
    for i = 0, l_leaderRow.SkillIds.Length-1 do
        table.insert(l_skillDatas, {skillId = l_leaderRow.SkillIds[i]})
    end
    self.skillPool:ShowTemplates({Datas = l_skillDatas})
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Skill_Scroll.transform)
end

-- 选中对应的首领
function Theme_ChiefGuildCtrl:SelectLeader(leaderId)
    local l_leaderRow = TableUtil.GetLeaderMethodDetailTable().GetRowByLeaderID(leaderId)
    if l_leaderRow then
        if self.tabTogs[l_leaderRow.TabType] then
            self.tabTogs[l_leaderRow.TabType].tabTog.isOn = true

            self.leaderPool:ScrollAndSelectIndexByDataCondition(function(item)
                return item.leaderId == leaderId
            end, 2000)
        end
    end
    self:OnLeaderCellSelected(leaderId)
end

--lua custom scripts end
return Theme_ChiefGuildCtrl