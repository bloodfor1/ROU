--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleArenaPanel"
--lua requires end

--lua model
module("UI", package.seeall)
local fightWarnColor = Color(1, 79/255, 79/255, 1)
local fightNormalColor = Color(1, 216/255, 77/255, 1)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BattleArenaCtrl = class("BattleArenaCtrl", super)
local l_mgr = MgrMgr:GetMgr("ArenaMgr")
--lua class define end

--lua functions
function BattleArenaCtrl:ctor()

	super.ctor(self, CtrlNames.BattleArena, UILayer.Normal, nil, ActiveType.Normal)
	self.fadeTime = 1.5
    self.mgr = MgrMgr:GetMgr("ArenaMgr")
    self.dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
end --func end
--next--
function BattleArenaCtrl:Init()

	self.panel = UI.BattleArenaPanel.Bind(self)
    super.Init(self)
    self.scoreCountLabs = {}
    self.lastUpdateTime = -1000
end --func end

--next--
function BattleArenaCtrl:Uninit()
    self.scoreCountLabs = nil
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function BattleArenaCtrl:OnActive()
    self.panel.BtnExit.UObj:SetActiveEx(false)
    local inWait = StageMgr:GetCurStageEnum() == MStageEnum.RingPre
	self.panel.WaitPanel.UObj:SetActiveEx(inWait)
	self.panel.FightPanel.UObj:SetActiveEx(not inWait)
    self.panel.Alarm.UObj:SetActiveEx(false)
    if inWait then
        self:InitRingPre()
    else
        self:InitFight()
    end
    UIMgr:DeActiveUI(UI.CtrlNames.MatchMask)
end --func end

function BattleArenaCtrl:InitRingPre()
    self.panel.CountDown.LabText = "--:--"
    MgrMgr:GetMgr("DailyTaskMgr").UpdateDailyTaskInfo()
    local sceneId = StageMgr:CurStage().sceneId
    local teamMemCount = DataMgr:GetData("TeamData").GetTeamNum()
    local memberTipShow = teamMemCount > MgrMgr:GetMgr("ArenaMgr").ArenaFactionMembers
    local teamTipShow = teamMemCount == 0
    local memberInWaitShow = not DataMgr:GetData("TeamData").IsAllMemberInSameScene(sceneId)
    self.panel.MemberInWaitTipText.LabText = Common.Utils.Lang("ARENA_MEMBER_OUTSIDE")
    self.panel.MemberCountTipText.LabText = Common.Utils.Lang("ARENA_TEAM_TOO_BIG", l_mgr.ArenaFactionMembers)
    self.panel.TeamMatchTip.LabText = Common.Utils.Lang("ARENA_WAIT_FOR_START", l_mgr.ArenaFactionMembers)
    self.panel.BeginTipText.LabText = Common.Utils.Lang("ARENA_WAIT_FOR_START", l_mgr.ArenaFactionMembers)
    self.panel.TeamMatchTipOther.LabText = Lang("ARENA_NEED_TEAM_OTHER", l_mgr.ArenaFactionMembers)
    self.panel.MemberInWaitTip.UObj:SetActiveEx(memberInWaitShow)
    self.panel.MemberCountTip.UObj:SetActiveEx(memberTipShow)
    self.panel.JoinTeamTip.UObj:SetActiveEx(teamTipShow)
    self.panel.JoinTeamTipMore.UObj:SetActiveEx(teamTipShow)
    --self.panel.TipBg.UObj:SetActiveEx(memberInWaitShow or memberTipShow or teamTipShow)
    self.panel.BeginTip.UObj:SetActiveEx(not memberTipShow and not memberInWaitShow and not teamTipShow)
    self.panel.BtnExit.UObj:SetActiveEx(false)
    self.panel.BtnExit:AddClick(function()
        MgrMgr:GetMgr("DungeonMgr").SendLeaveSceneReq()
    end)
    local rtTrans = self.panel.TipBg.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
end

function BattleArenaCtrl:InitFight()
    self.panel.timerLab.LabText = "--:--"
    --self:OnFightCountDown(MgrMgr:GetMgr("ArenaMgr").FightCountDown)
    self:OnUpdateScore()
end

function BattleArenaCtrl:OnDailyTaskInfoUpdate()
    MgrMgr:GetMgr("ArenaMgr").StartCountDown()
    local leftTime, round = MgrMgr:GetMgr("DailyTaskMgr").GetRoundFightInfo()
    self.panel.BtnExit.UObj:SetActiveEx(round == 0 or round == l_mgr.ArenaBattleRounds)
    if round > 0 then
        self.panel.BeginTipText.LabText = Lang("ARENA_WAITING_FOR_NEXT_ROUND", round + 1, l_mgr.ArenaBattleRounds)
    end
    if round == l_mgr.ArenaBattleRounds then
        UIMgr:ActiveUI(UI.CtrlNames.ArenaSettlement,l_mgr.FormatDirectPromoptResult())
    end
end
--next--
function BattleArenaCtrl:OnDeActive()
end --func end
--next--
function BattleArenaCtrl:Update()


end --func end

--next--
function BattleArenaCtrl:BindEvents()
    self:BindEvent(self.dailyTaskMgr.EventDispatcher,self.dailyTaskMgr.DAILY_ACTIVITY_UPDATE_EVENT, self.OnDailyTaskInfoUpdate)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventCountDownUpdate, self.OnCountDown)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventPrepareFightCountDownUpdate, self.OnFightPrepareCountDown)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventFightCountDownUpdate, self.OnFightCountDown)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventPlatformTeamRequireNumUpdate, self.OnTeamInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, self.OnTeamInfoUpdate)
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher,MgrMgr:GetMgr("WatchWarMgr").ON_MAIN_WATCH_BRIEF_INFO_UPDATE, self.OnUpdateSpectatorScore)
    else
        self:BindEvent(self.mgr.EventDispatcher,self.mgr.EventUpdateScore, self.OnUpdateScore)
    end
end --func end
--next--
--lua functions end

--lua custom scripts
function BattleArenaCtrl:OnCountDown(countDown)
    if countDown == 0 then
        self.panel.CountDown:SetActiveEx(false)
        self.panel.desText:SetActiveEx(false)
        self.panel.Matching:SetActiveEx(true)
    else
        self.panel.CountDown:SetActiveEx(true)
        self.panel.desText:SetActiveEx(true)
        self.panel.Matching:SetActiveEx(false)
        local min, sec = math.floor(countDown/60), math.floor(countDown%60)
        self.panel.CountDown.LabText = StringEx.Format("{0:00}:{1:00}", min, sec)
        local color = self.panel.CountDown.LabColor
        if countDown <= 30 then
            if color ~= fightWarnColor then
                self.panel.CountDown.LabColor = fightWarnColor
            end
        else
            if color ~= fightNormalColor then
                self.panel.CountDown.LabColor = fightNormalColor
            end
        end
    end
end

function BattleArenaCtrl:OnFightPrepareCountDown(time)
    self.panel.Tips.LabText = Lang("ARENA_BEGIN_TIP", time)
    self.panel.Alarm.UObj:SetActiveEx(time > 3)
end

function BattleArenaCtrl:OnFightCountDown(countDown)
    local min, sec = math.floor(countDown/60), math.floor(countDown%60)
    self.panel.timerLab.LabText = StringEx.Format("{0:00}:{1:00}", min, sec)
    local color = self.panel.timerLab.LabColor
    if countDown <= 30 then
        if color ~= fightWarnColor then
            self.panel.timerLab.LabColor = fightWarnColor
        end
    else
        if color ~= fightNormalColor then
            self.panel.timerLab.LabColor = fightNormalColor
        end
    end
end

--==============================--
--@Description: 组队信息发生变化
--@Date: 2018/9/15
--@Param: [args]
--@Return:
--==============================--
function BattleArenaCtrl:OnTeamInfoUpdate()
    local sceneId = StageMgr:CurStage().sceneId
    local teamMemCount = DataMgr:GetData("TeamData").GetTeamNum()
    local memberTipShow = teamMemCount > MgrMgr:GetMgr("ArenaMgr").ArenaFactionMembers
    local teamTipShow = teamMemCount == 0
    local memberInWaitShow = not DataMgr:GetData("TeamData").IsAllMemberInSameScene(sceneId)
    self.panel.MemberInWaitTip.UObj:SetActiveEx(memberInWaitShow)
    self.panel.MemberCountTip.UObj:SetActiveEx(memberTipShow)
    self.panel.JoinTeamTip.UObj:SetActiveEx(teamTipShow)
    self.panel.JoinTeamTipMore.UObj:SetActiveEx(teamTipShow)
    --self.panel.TipBg.UObj:SetActiveEx(memberInWaitShow or memberTipShow or teamTipShow)
    self.panel.BeginTip.UObj:SetActiveEx(not memberTipShow and not memberInWaitShow and not teamTipShow)
    local rtTrans = self.panel.TipBg.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
end

--==============================--
--@Description:更新分数
--@Date: 2018/9/15
--@Param: [args]
--@Return:
--==============================--
function BattleArenaCtrl:OnUpdateScore()
    self.panel.redCountLab.LabText = math.max(0, MgrMgr:GetMgr("ArenaMgr").ArenaFactionPoints - MPlayerDungeonsInfo.PlayerCampDeadCount)
    self.panel.blueCountLab.LabText = math.max(0, MgrMgr:GetMgr("ArenaMgr").ArenaFactionPoints - MPlayerDungeonsInfo.EnemyCampDeadCount)
end

function BattleArenaCtrl:OnUpdateSpectatorScore()

    local l_watchInfo = DataMgr:GetData("WatchWarData").MainWatchRoomInfo
    if not l_watchInfo then
        return
    end
    
    if not self.scoreCountLabs then
        return
    end

    if Time.realtimeSinceStartup - self.lastUpdateTime < 1 then
        return 
    end
    self.lastUpdateTime = Time.realtimeSinceStartup

    local l_compareValue1, l_compareValue2 = l_watchInfo.camp1_score, l_watchInfo.camp2_score
    self.panel.blueCountLab.LabText = math.max(0, MgrMgr:GetMgr("ArenaMgr").ArenaFactionPoints - l_compareValue1)
    self.panel.redCountLab.LabText = math.max(0, MgrMgr:GetMgr("ArenaMgr").ArenaFactionPoints - l_compareValue2)
end

--lua custom scripts end
return BattleArenaCtrl