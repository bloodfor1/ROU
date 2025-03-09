--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerDefenseEntrancePanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local Mgr = MgrMgr:GetMgr("TowerDefenseMgr")
--next--
--lua fields end

--lua class define
TowerDefenseEntranceCtrl = class("TowerDefenseEntranceCtrl", super)
--lua class define end

local l_AWARD_PREVIEW_EVENT_NAME = "TOWER_DEFENSE_AWARD_PREVIEW"

--lua functions
function TowerDefenseEntranceCtrl:ctor()

    super.ctor(self, CtrlNames.TowerDefenseEntrance, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function TowerDefenseEntranceCtrl:Init()

    self.panel = UI.TowerDefenseEntrancePanel.Bind(self)
    super.Init(self)
    self.AwardPreviewData = {}    -- 奖励预览数据
    self.CurrentDungeonsId = 0    -- 当前的副本id
    --关闭界面
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TowerDefenseEntrance)
    end)
    -- 单人守卫战
    self.panel.TogSingle:OnToggleExChanged(function(value)
        if value then
            Mgr.CurrentTDMode = Mgr.ETowerDefenseModel.Single
            self:RefreshPanel()
        end
    end)
    -- 双人守卫战
    self.panel.TogDouble:OnToggleExChanged(function(value)
        if value then
            Mgr.CurrentTDMode = Mgr.ETowerDefenseModel.Double
            self:RefreshPanel()
        end
    end)
    self.panel.TogSingle.gameObject:GetComponent("UIToggleEx").isOn = false
    self.panel.TogSingle.gameObject:GetComponent("UIToggleEx").isOn = true
    -- 功能未开放置灰色
    self.panel.BtnDoubleGray:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(ErrorCode.ERR_SYSTEM_NOT_OPEN))
    end)
    -- 提示信息
    self.panel.PanelExplain.gameObject:SetActiveEx(false)
    self.panel.TxtExplain.LabText = Common.Utils.Lang("TD_TIP_SCORE_FACTOR")
    self.panel.BtnScoreTips:AddClick(function()
        self.panel.PanelExplain.gameObject:SetActiveEx(true)
    end)
    self.panel.BtnCloseExplain.Listener.onClick = function()
        self.panel.PanelExplain.gameObject:SetActiveEx(false)
    end
    -- 奖励展示
    self.AwardTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.ScrollViewAwardPreview.LoopScroll,
    })
    -- 快速组队
    self.panel.BtnTeam:AddClick(function()
        local teamTargetInfo = MgrMgr:GetMgr("DailyTaskMgr").GetTeamTargetInfo(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_TowerDefenseDouble)
        if teamTargetInfo.teamTargetType ~= 0 then
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(teamTargetInfo.teamTargetType, teamTargetInfo.teamTargetId)
            end)
        end
    end)
    -- 开始守卫
    self.panel.BtnDefense:AddClick(function()
        self:_prepareStartDungeon()
    end)

    self.panel.TDAwardButton:AddClick(function()
        self:_openAwardPanel()
    end)

    self.panel.AttackBlessButton:AddClick(function()
        self:_openBlessPanel(true)
    end)

    self.panel.DefenseBlessButton:AddClick(function()
        self:_openBlessPanel(false)
    end)

end --func end
--next--
function TowerDefenseEntranceCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.AwardPreviewData = {}
    self.CurrentDungeonsId = 0
    Mgr.CurrentTDMode = Mgr.ETowerDefenseModel.None

end --func end
--next--
function TowerDefenseEntranceCtrl:OnActive()

    if Mgr.IsReachAddTimeServerLevel() then
        local l_beginnerGuideChecks = { "TdSingleLimitUp" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end

    self:InitGOData()
    self:_showBlessIcon()
    self:_showAwardRedSign()

    self:SetTogDoubleStatus()


end --func end
--next--
function TowerDefenseEntranceCtrl:OnDeActive()
    self:CloseDoubleFxEffect()

end --func end
--next--
function TowerDefenseEntranceCtrl:Update()


end --func end

--next--
function TowerDefenseEntranceCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, l_AWARD_PREVIEW_EVENT_NAME, function(_, awardInfo)
        self:RefreshAwardPrevieData(awardInfo)
    end)
    self:BindEvent(Mgr.EventDispatcher, Mgr.OnCheckTowerDefenseCondition, function()
        self:SetTogDoubleStatus()
    end)

    self:BindEvent(Mgr.EventDispatcher,Mgr.ReceiveSetTowerDefenseBlessEvent,function()
        self:_showBlessIcon()
    end)

    self:BindEvent(Mgr.EventDispatcher, Mgr.ReceiveGetTowerDefenseWeekAwardEvent, function()
        self:_showAwardRedSign()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
-- 初始化都配置的数据
function TowerDefenseEntranceCtrl:InitGOData()
    self.AwardPreviewData = {}

    local l_awardIds={}

    local l_dungeonsId = Mgr.GetDungeonsIDByPlayerLevel(Mgr.ETowerDefenseModel.Single, MPlayerInfo.Lv)
    local l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(l_dungeonsId)
    if l_dungeonsRowData then
        self.panel.TxtSingleOffLevel.LabText = string.format("Lv.%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])
        self.panel.TxtSingleOnLevel.LabText = string.format("Lv.%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])
        if l_dungeonsRowData.DisplayAward.Length>0 then
            table.insert(l_awardIds,l_dungeonsRowData.DisplayAward[0])
        end

    end
    l_dungeonsId = Mgr.GetDungeonsIDByPlayerLevel(Mgr.ETowerDefenseModel.Double, MPlayerInfo.Lv)
    l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(l_dungeonsId)
    if l_dungeonsRowData then
        self.panel.TxtDoubleOffLevel.LabText = string.format("Lv.%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])
        self.panel.TxtDoubleOnLevel.LabText = string.format("Lv.%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])
        self.panel.TxtGrayLevel.LabText = string.format("Lv.%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])
        if l_dungeonsRowData.DisplayAward.Length>0 then
            table.insert(l_awardIds,l_dungeonsRowData.DisplayAward[0])
        end

    end

    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_awardIds,l_AWARD_PREVIEW_EVENT_NAME)

    -- 设置tips提示文字
    self.panel.TxtTipsUp.LabText = Common.Utils.Lang("TD_MIN_WAVES_REQUIRED", Mgr.TdCoopModeEntryWaves)
    self.panel.TxtTipsMid.LabText = Common.Utils.Lang("TD_CANT_BE_IN_TEAM")
    self.panel.TxtTipsDown.LabText = Common.Utils.Lang("TD_COOP_MODE_TIME_FRAME")
end
-- 设置预览奖励数据
function TowerDefenseEntranceCtrl:RefreshAwardPrevieData(awardInfo)

    if awardInfo == nil then
        return
    end
    self.AwardPreviewData={}
    for i = 1, #awardInfo do
        local l_awardId=awardInfo[i].award_id
        self.AwardPreviewData[l_awardId] = {}
        for i, v in ipairs(awardInfo[i].award_list) do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
            if l_itemRow then
                table.insert(self.AwardPreviewData[l_awardId], {
                    ID = v.item_id,
                    count = v.count,
                    IsShowCount = false,
                })
            else
                logError("TowerDefenseEntranceCtrl:RefreshAwardPrevieData fail, 奖励预览道具id客户端找不到 " .. v.item_id)
            end
        end
    end

    local l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(self.CurrentDungeonsId)
    self:_showAwardPreview(l_dungeonsRowData)

end

-- 刷新全部要显示的数据
function TowerDefenseEntranceCtrl:RefreshPanel()
    -- 结合CountTable和服务器数据，获得当前玩家剩余次数
    local l_countData = Mgr.GetCountLimitData()
    local l_dungeonsRowData = nil
    local l_tdLvRangeRowData = nil
    local l_dungeonsId = 0
    local l_tdTableData = nil
    if Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Single then
        l_tdLvRangeRowData = Mgr.GetTdLvRangeRowByModel(Mgr.ETowerDefenseModel.Single)
        l_dungeonsId = Mgr.GetDungeonsIDByPlayerLevel(Mgr.ETowerDefenseModel.Single, MPlayerInfo.Lv)
        l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(l_dungeonsId)
        l_tdTableData = Mgr.GetTdRowByDungeonsId(l_dungeonsId)
        self.panel.TxtTeam.LabText = Common.Utils.Lang("TowerDefenseSinglePlayer")
        if l_countData then
            --logGreen("l_countData.single.todayLimt:"..tostring(l_countData.single.todayLimt))
            --logGreen("l_countData.single.todayCount:"..tostring(l_countData.single.todayCount))
            self.panel.TxtTimes.LabText = Common.Utils.Lang("TD_DAILY_WEEKLY_LIMITS", l_countData.single.todayLimt - l_countData.single.todayCount, l_countData.single.todayLimt, l_countData.single.weekLimt - l_countData.single.weekCount, l_countData.single.weekLimt)
        else
            self.panel.TxtTimes.LabText = ""
        end
        self:SetBtnGroupAndTipsStatus(true, false, false, true, false, false, false)
    elseif Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Double then
        l_tdLvRangeRowData = Mgr.GetTdLvRangeRowByModel(Mgr.ETowerDefenseModel.Double)
        l_dungeonsId = Mgr.GetDungeonsIDByPlayerLevel(Mgr.ETowerDefenseModel.Double, MPlayerInfo.Lv)
        l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(l_dungeonsId)
        l_tdTableData = Mgr.GetTdRowByDungeonsId(l_dungeonsId)
        self.panel.TxtTeam.LabText = Common.Utils.Lang("TowerDefenseDoublePlayer")
        if l_countData then
            self.panel.TxtTimes.LabText = Common.Utils.Lang("TD_2P_WEEKLY_LIMIT", l_countData.double.weekLimt - l_countData.double.weekCount, l_countData.double.weekLimt)
        else
            self.panel.TxtTimes.LabText = ""
        end
        if Mgr.EntraceConditionData ~= nil then
            if Mgr.EntraceConditionData.is_open then
                if Mgr.EntraceConditionData.is_single_wave then
                    self:SetBtnGroupAndTipsStatus(true, false, true, true, false, false, false)
                else
                    self:SetBtnGroupAndTipsStatus(false, true, false, false, true, false, false)
                end
            else
                if Mgr.EntraceConditionData.is_single_wave then
                    self:SetBtnGroupAndTipsStatus(false, true, false, false, false, false, true)
                else
                    self:SetBtnGroupAndTipsStatus(false, true, false, false, true, false, true)
                end
            end
        end
    end


    -- 背景介绍
    if l_tdLvRangeRowData then
        self.panel.TxtInfo.LabText = l_tdLvRangeRowData.LevelDesc
        self.panel.ImgMap:SetRawTexAsync("Map/" .. l_tdLvRangeRowData.LevelImageName .. ".png")
    end
    -- 等级条件
    if l_dungeonsRowData then
        self.panel.TxtLevelLimit.LabText = string.format("%d-%d", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1])

        self:_showAwardPreview(l_dungeonsRowData)
    end
    -- 难度系数
    if l_tdTableData then
        self.panel.TxtScore.LabText = string.format("%.1f", l_tdTableData.ScoreFactor)
    end
    self.CurrentDungeonsId = l_dungeonsId
end

function TowerDefenseEntranceCtrl:_showAwardPreview(dungeonsRowData)
    if dungeonsRowData==nil then
        return
    end

    if dungeonsRowData.DisplayAward.Length <= 0 then
        logError("副本表没填预览奖励，副本id："..tostring(dungeonsRowData.DungeonsID))
        return
    end

    local l_awardDatas=self.AwardPreviewData[dungeonsRowData.DisplayAward[0]]
    if l_awardDatas == nil then
        return
    end
    -- 奖励预览
    self.AwardTemplatePool:ShowTemplates({
        Datas = l_awardDatas
    })
end

-- 设置双人界面按钮和文字提示的状态
function TowerDefenseEntranceCtrl:SetBtnGroupAndTipsStatus(status1, status2, status3, status4, status5, status6, status7)
    self.panel.BtnGroup.gameObject:SetActiveEx(status1)
    self.panel.PanelTips.gameObject:SetActiveEx(status2)
    self.panel.BtnTeam.gameObject:SetActiveEx(status3)
    self.panel.BtnDefense.gameObject:SetActiveEx(status4)
    self.panel.TxtTipsUp.gameObject:SetActiveEx(status5)
    self.panel.TxtTipsMid.gameObject:SetActiveEx(status6)
    self.panel.TxtTipsDown.gameObject:SetActiveEx(status7)
end

-- 由于双人守卫战功能未开放，tog按钮置灰
function TowerDefenseEntranceCtrl:SetTogDoubleStatus()
    if Mgr.EntraceConditionData == nil then
        self.panel.BtnDoubleGray.gameObject:SetActiveEx(true)
        self.panel.TogDouble.gameObject:SetActiveEx(false)
    else
        self.panel.TogDouble.gameObject:SetActiveEx(true)
        self.panel.BtnDoubleGray.gameObject:SetActiveEx(false)
        -- 组队模式默认打开双人界面
        local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
        local l_teamCount = DataMgr:GetData("TeamData").GetTeamPlayerCount()
        if selfInTeam and l_teamCount > 1 then
            self.panel.TogDouble.gameObject:GetComponent("UIToggleEx").isOn = false
            self.panel.TogDouble.gameObject:GetComponent("UIToggleEx").isOn = true
        end
        if Mgr.EntraceConditionData.is_open then
            self:OpenDoubleFxEffect()
        else
            self.panel.ImgEffect.gameObject:SetActiveEx(false)
        end
    end
end

-- 设置环绕光效
function TowerDefenseEntranceCtrl:OpenDoubleFxEffect()
    if self.effectID then
        return
    end
    self.panel.ImgEffect.gameObject:SetActiveEx(false)
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ImgEffect.RawImg
    l_fxData.loadedCallback = function(go)
        go.transform:SetLocalScale(0.95, 1, 1)
        self.panel.ImgEffect.gameObject:SetActiveEx(true)
    end
    self.effectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_TianDiShuShouWeiZhan_HuanRaoTeXiao_01", l_fxData)
    
end

-- 销毁环绕光效
function TowerDefenseEntranceCtrl:CloseDoubleFxEffect()
    if self.effectID and self.effectID ~= 0 then
        self:DestroyUIEffect(self.effectID)
        self.effectID = nil
    end
end
function TowerDefenseEntranceCtrl:_prepareStartDungeon()

    local l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(self.CurrentDungeonsId)
    if l_dungeonsRowData then
        if MPlayerInfo.Lv < l_dungeonsRowData.LevelLimit[0] or MPlayerInfo.Lv > l_dungeonsRowData.LevelLimit[1] then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DUNGEON_LV_NOT_MEET"))
            return
        end
    end
    local l_countData = Mgr.GetCountLimitData()
    if Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Single then
        --logGreen("l_countData.single.todayCount:"..tostring(l_countData.single.todayCount))
        if l_countData.single.todayCount <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TD_DAILY_LIMIT_REACHED"))
            return
        end
        if l_countData.single.weekCount <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TD_WEEKLY_LIMIT_REACHED"))
            return
        end
    elseif Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Double then
        if l_countData.double.todayCount <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TD_DAILY_LIMIT_REACHED"))
            return
        end
        if l_countData.double.weekCount <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TD_WEEKLY_LIMIT_REACHED"))
            return
        end
    end

    local l_attackBlessSkillId = Mgr.GetAttackBlessSkillId()
    local l_defenseBlessSkillId = Mgr.GetDefenseBlessSkillId()

    if l_attackBlessSkillId == 0 or l_defenseBlessSkillId == 0 then
        CommonUI.Dialog.ShowYesNoDlg(true, nil,
                Common.Utils.Lang("TowerDefense_StartDungeonBlessText"),
                function()
                    self:_startDungeon()
                end)
    else
        self:_startDungeon()
    end
end

function TowerDefenseEntranceCtrl:_startDungeon()

    if Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Single then
        local l_fightMercenarys = MgrMgr:GetMgr("MercenaryMgr").FindFightMercenary()
        local l_canFightNum = MgrMgr:GetMgr("MercenaryMgr").CanTakeMercenaryNumber()
        if #l_fightMercenarys < l_canFightNum then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("TD_1P_CONFIRM_MERCENARY", l_canFightNum), function()
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.CurrentDungeonsId, 0, 0)
            end)
        else
            MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.CurrentDungeonsId, 0, 0)
        end
    elseif Mgr.CurrentTDMode == Mgr.ETowerDefenseModel.Double then

        local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
        if selfInTeam then
            if selfIsCaptain then
                local teamCount = DataMgr:GetData("TeamData").GetTeamPlayerCount()
                if teamCount == 2 then
                    local teamLevel = DataMgr:GetData("TeamData").GetTeamPlayerLevel()
                    local l_dungeonsRowData = Mgr.GetDungeonsRowByDungeonsId(self.CurrentDungeonsId)
                    if l_dungeonsRowData then
                        local l_isLevel = true
                        for _, v in ipairs(teamLevel) do
                            if v < l_dungeonsRowData.LevelLimit[0] or v > l_dungeonsRowData.LevelLimit[1] then
                                l_isLevel = false
                            end
                        end
                        if l_isLevel then
                            local l_fightMercenarys = DataMgr:GetData("TeamData").GetCurMercenaryNum()
                            local l_canFightNum = MgrMgr:GetMgr("MercenaryMgr").CanTakeMercenaryNumber()
                            if l_fightMercenarys < l_canFightNum then
                                CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("TD_2P_CONFIRM_MERCENARY", l_canFightNum), function()
                                    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.CurrentDungeonsId, 0, 0)
                                end)
                            else
                                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.CurrentDungeonsId, 0, 0)
                            end
                        else
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseTeamLevelError", l_dungeonsRowData.LevelLimit[0], l_dungeonsRowData.LevelLimit[1]))
                        end
                    end
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseNeedDoubleTeam"))
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseCaptainReqDoubleTeam"))
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseNeedDoubleTeam"))
        end
    end
end

function TowerDefenseEntranceCtrl:_openBlessPanel(isOpenAttackBless)
    UIMgr:ActiveUI(UI.CtrlNames.TowerDefenseBless, isOpenAttackBless)
end

function TowerDefenseEntranceCtrl:_openAwardPanel()
    UIMgr:ActiveUI(UI.CtrlNames.TowerDefenseAward)
end

function TowerDefenseEntranceCtrl:_showBlessIcon()

    local l_attackBlessSkillId = Mgr.GetAttackBlessSkillId()
    local l_defenseBlessSkillId = Mgr.GetDefenseBlessSkillId()

    if l_attackBlessSkillId and l_attackBlessSkillId~=0 then
        self.panel.AttackBless:SetActiveEx(true)
        self.panel.NoAttackBless:SetActiveEx(false)
        local l_tableInfo = TableUtil.GetTdOrderTable().GetRowByID(l_attackBlessSkillId)
        self.panel.AttackBless:SetSpriteAsync(l_tableInfo.IconAtlas, l_tableInfo.IconName)
    else
        self.panel.AttackBless:SetActiveEx(false)
        self.panel.NoAttackBless:SetActiveEx(true)
    end

    if l_defenseBlessSkillId and l_defenseBlessSkillId~=0 then
        self.panel.DefenseBless:SetActiveEx(true)
        self.panel.NoDefenseBless:SetActiveEx(false)
        local l_tableInfo = TableUtil.GetTdOrderTable().GetRowByID(l_defenseBlessSkillId)
        self.panel.DefenseBless:SetSpriteAsync(l_tableInfo.IconAtlas, l_tableInfo.IconName)
    else
        self.panel.DefenseBless:SetActiveEx(false)
        self.panel.NoDefenseBless:SetActiveEx(true)
    end
end

function TowerDefenseEntranceCtrl:_isCanShowAwardRedSign()
    local l_TableInfos= TableUtil.GetTdQuestTable().GetTable()
    for i = 1, #l_TableInfos do
        local l_tableInfo=l_TableInfos[i]
        if l_tableInfo.IsActive then
            if not Mgr.IsGetAwardWithId(l_tableInfo.ID,l_tableInfo.Type) then
                local l_currentProgress=Mgr.GetAwardTaskProgressWithType(l_tableInfo.Type)
                if l_currentProgress>=l_tableInfo.Arg then
                    return true
                end
            end
        end
    end
    return false
end

function TowerDefenseEntranceCtrl:_showAwardRedSign()
    if self:_isCanShowAwardRedSign() then
        self.panel.RedSignPrompt:SetActiveEx(true)
    else
        self.panel.RedSignPrompt:SetActiveEx(false)
    end
end
--lua custom scripts end
return TowerDefenseEntranceCtrl