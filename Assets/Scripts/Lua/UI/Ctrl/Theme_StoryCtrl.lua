--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_StoryPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Theme_StoryCtrl = class("Theme_StoryCtrl", super)
--lua class define end

--lua functions
function Theme_StoryCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_Story, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function Theme_StoryCtrl:Init()
	
	self.panel = UI.Theme_StoryPanel.Bind(self)
	super.Init(self)

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Theme_Story)
    end)

    -- 奖励
    self.rewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.AwardScroll.LoopScroll
    })

    -- 公开情报
    self.panel.InformationBtn:AddClick(function()
        if self.currentThemeDungeonInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_Information, {themeDungeonId = self.currentThemeDungeonInfo.themeDungeonId})
        end
    end)

    -- 开始挑战
    self.panel.BeginBtn:AddClick(function()
        if self.themeDungeonInfo then
            if self.themeDungeonMgr.IsDungeonPassed(self.themeDungeonInfo.tableInfo.StoryDungeonID) then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("THEME_DUNGEON_NO_REWARD"), function()
                    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.themeDungeonInfo.tableInfo.StoryDungeonID, 0, 0)
                end)
            else
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.themeDungeonInfo.tableInfo.StoryDungeonID, 0, 0)
            end
        end
    end)

    -- 首领
    self.panel.BossTog.TogEx.onValueChanged:AddListener(function(value)
        self:RefreshBossInfo()
    end)
    -- 特性
    self.panel.SpecialTog.TogEx.onValueChanged:AddListener(function(value)
        self:RefreshBossInfo()
    end)
    -- 档案
    self.panel.RecordTog.TogEx.onValueChanged:AddListener(function(value)
        self:RefreshBossInfo()
    end)
    self.panel.BossTog.TogEx.isOn = true

    -- 组队信息
    self.teamTemplate = self:NewTemplate("EmbeddedTeamTemplate",{
        TemplateParent = self.panel.TeamPanel.transform
    })

    self.panel.InformationScroll:SetScrollRectGameObjListener(nil, self.panel.DownArrow.gameObject, nil, nil)

    self:InitEffect()
end --func end
--next--
function Theme_StoryCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Theme_StoryCtrl:OnActive()

    if self.uiPanelData and self.uiPanelData.themeDungeonId then
        self:SetInfo(self.uiPanelData.themeDungeonId)
        -- 判断是否是第一次打开界面
        local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
        if not l_onceSystemMgr.GetAndSetState(l_onceSystemMgr.EClientOnceType.ThemeDungeonOpen, self.uiPanelData.themeDungeonId, true) then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_Information, {themeDungeonId = self.currentThemeDungeonInfo.themeDungeonId})
        end
    end

    self.themeDungeonMgr.EventDispatcher:Dispatch(self.themeDungeonMgr.EventType.ThemeDungeonUIClosed)
end --func end
--next--
function Theme_StoryCtrl:OnDeActive()
    self.currentThemeDungeonInfo = nil
    self.panel.BossImg:ResetRawTex()

    self:DestroyEffect()
end --func end
--next--
function Theme_StoryCtrl:Update()
	
	
end --func end
--next--
function Theme_StoryCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "ThemeDungeonStoryReward", function(_, ...)
        self:RefreshReward(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function Theme_StoryCtrl:InitEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.Effect.RawImg
    l_fxData.scaleFac = Vector3.New(1.6, 1.6, 1.6)
    l_fxData.loadedCallback = nil
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge0", l_fxData)

    l_fxData.rawImage = self.panel.Effect2.RawImg
    l_fxData.position = Vector3.New(3, 1.24,0)
    l_fxData.scaleFac = Vector3.New(4, 4, 4)
    l_fxData.loadedCallback = nil
    if self.effect2 then
        self:DestroyUIEffect(self.effect2)
    end
    self.effect2 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge2", l_fxData)

    
end

function Theme_StoryCtrl:DestroyEffect()
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    if self.effect2 then
        self:DestroyUIEffect(self.effect2)
    end
end

function Theme_StoryCtrl:SetInfo(themeDungeonId)
    ---@type ThemeDungeonTable
    local l_themeDungeonRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(themeDungeonId)
    if not l_themeDungeonRow then return end

    self.themeDungeonInfo = {
        themeDungeonId = themeDungeonId,
        tableInfo = l_themeDungeonRow
    }


    self.currentThemeDungeonInfo = self.currentThemeDungeonInfo or {}
    self.currentThemeDungeonInfo.themeDungeonId = themeDungeonId
    self.currentThemeDungeonInfo.tableInfo = l_themeDungeonRow

    self.panel.BeginBtn:SetGray(l_themeDungeonRow.ChapterLevel > MPlayerInfo.Lv)

    self.panel.DungeonName.LabText = l_themeDungeonRow.ThemeName
    self.panel.DungeonLv.LabText = "Lv." .. l_themeDungeonRow.ChapterLevel
    self.panel.BossName.LabText = l_themeDungeonRow.LeaderName

    self.panel.BossImg:SetRawTexAsync(l_themeDungeonRow.Painting, nil, true)

    self.panel.PassedImg:SetActiveEx(self.themeDungeonMgr.IsDungeonPassed(l_themeDungeonRow.StoryDungeonID))

    self:RefreshBossInfo()

    -- 奖励信息
    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_themeDungeonRow.StoryDungeonID)
    if l_dungeonRow then
        local l_awardId = l_dungeonRow.AwardDrop[0] or 0
        if l_awardId > 0 then
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId, "ThemeDungeonStoryReward")
        end
    end

    -- 设置寻找组队信息
    self.teamTemplate:SetData({targetTeamId = l_themeDungeonRow.TeamTargetID})
end

function Theme_StoryCtrl:RefreshBossInfo()
    if not self.currentThemeDungeonInfo then return end

    if self.panel.BossTog.TogEx.isOn then
        self.panel.DesText.LabText = self.currentThemeDungeonInfo.tableInfo.LeaderDesc
    elseif self.panel.SpecialTog.TogEx.isOn then
        self.panel.DesText.LabText = self.currentThemeDungeonInfo.tableInfo.LeaderFeatureDesc
    elseif self.panel.RecordTog.TogEx.isOn then
        self.panel.DesText.LabText = self.currentThemeDungeonInfo.tableInfo.LeaderFileDesc
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.InformationScroll.transform)
    self.panel.InformationScroll.Scroll.verticalNormalizedPosition = 1
    self.panel.InformationScroll:SetScrollRectDownAndUpState(nil, self.panel.DownArrow.gameObject)
end

function Theme_StoryCtrl:RefreshReward(awardInfo)
    if awardInfo then
        local l_datas = {}
        for i, v in ipairs(awardInfo.award_list) do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
            if l_itemRow then
                table.insert(l_datas, {
                    ID = v.item_id,
                    count = v.count,
                    dropRate = v.drop_rate,
                    isParticular = v.is_particular,
                    IsShowCount = false,
                })
            end
        end
        self.rewardPool:ShowTemplates({Datas = l_datas})
    end
end

--lua custom scripts end
return Theme_StoryCtrl