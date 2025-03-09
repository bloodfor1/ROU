--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainGuildMatchPanel"
--lua requires end

--lua model
module("UI", package.seeall)
local fightWarnColor = Color(1, 79 / 255, 79 / 255, 1)
local fightNormalColor = Color(1, 216 / 255, 77 / 255, 1)
E_Result = {
    Win = 1,
    Lose = 2,
    Draw = 3
}
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MainGuildMatchCtrl = class("MainGuildMatchCtrl", super)
--lua class define end
MatchPointsPerPlayer = MGlobalConfig:GetInt("G_MatchPointsPerPlayer")
--lua functions
function MainGuildMatchCtrl:ctor()

    super.ctor(self, CtrlNames.MainGuildMatch, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function MainGuildMatchCtrl:Init()

    self.panel = UI.MainGuildMatchPanel.Bind(self)
    super.Init(self)
    ---@type ModuleMgr.GuildMatchMgr
    self.mgr = MgrMgr:GetMgr("GuildMatchMgr")
    ---@type ModuleData.GuildMatchData
    self.data = DataMgr:GetData("GuildMatchData")
    self.type = nil
    self.timer = nil
    self.round = 0
    self.time = 0
    self.alarm = -1

end --func end
--next--
function MainGuildMatchCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.round = nil
    self.time = nil
    self.type = nil
    self.alarm = nil
    self:StopCountDown()

end --func end
--next--
function MainGuildMatchCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData == self.data.EUIOpenType.PRE_TIME then
            self.type = self.data.EUIOpenType.PRE_TIME
            self:PreInit()
        end
        if self.uiPanelData == self.data.EUIOpenType.MATCH_TIME then
            self.type = self.data.EUIOpenType.MATCH_TIME
            self:MatchInit()
        end
    else
        self.type = self.data.EUIOpenType.MATCH_TIME
        self:MatchInit()
    end

end --func end
--next--
function MainGuildMatchCtrl:OnDeActive()

end --func end
--next--
function MainGuildMatchCtrl:Update()


end --func end
--next--
function MainGuildMatchCtrl:Refresh()


end --func end
--next--
function MainGuildMatchCtrl:OnLogout()


end --func end
--next--
function MainGuildMatchCtrl:OnReconnected(roleData)


end --func end
--next--
function MainGuildMatchCtrl:Show(withTween)

    if not super.Show(self, withTween) then
        return
    end

end --func end
--next--
function MainGuildMatchCtrl:Hide(withTween)

    if not super.Hide(self, withTween) then
        return
    end

end --func end
--next--
function MainGuildMatchCtrl:BindEvents()

    local l_UpdateInfo = function()
        self:RefreshMatch()
    end
    local l_TeamCacheInfo = function()
        self:RefreshTeamCache()
    end
    self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher,
            MgrMgr:GetMgr("WatchWarMgr").ON_MAIN_ROOM_WATCH_INFO_DATA, l_UpdateInfo)
    self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher,
            MgrMgr:GetMgr("WatchWarMgr").ON_MAIN_WATCH_BRIEF_INFO_UPDATE, l_UpdateInfo)
    self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher,
            MgrMgr:GetMgr("WatchWarMgr").ON_GUILD_MATCH_INFO_UPDATE, l_UpdateInfo)
    self:BindEvent(MgrMgr:GetMgr("GuildMatchMgr").EventDispatcher,
            DataMgr:GetData("GuildMatchData").ON_REFRESH_TEAM_CACHE, l_TeamCacheInfo)

end --func end
--next--
--lua functions end

--lua custom scripts
function MainGuildMatchCtrl:StopCountDown()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

end

function MainGuildMatchCtrl:GetRoundAndTime(SceneType)

    local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_matchBeginTime = l_taskMgr.GetBattleTime(l_taskMgr.g_ActivityType.activity_GuildMatch)
    local l_dungeonID = tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchBattleDungeonId").Value)
    local l_countDownAlarm = tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchCountDownBeforeBattle").Value)
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonID)
    if not l_dungeonData then
        logError("策划配的数据没了你看看{0}里面有没有{1}号副本", DungeonsTable, l_dungeonID)
        return 0
    end
    local l_matchPerTime = l_dungeonData.TimeLimit:get_Item(1) + l_countDownAlarm
    local l_matchRoundTime = tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchRoundInterval").Value)
    local l_nowTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
    local l_matchRunTime = l_nowTime - l_matchBeginTime
    local l_round = 1
    if SceneType == self.data.EUIOpenType.PRE_TIME then
        for i = 1, 3, 1 do
            if l_matchRunTime > 0 then
                l_matchRunTime = l_matchRunTime - l_matchRoundTime
                l_round = l_round + 1
            end
        end
        l_matchRunTime = -l_matchRunTime
        if l_matchRunTime > 0 or self.round == 0 then
            return l_round, l_matchRunTime, -1
        end
        return self.round, self.time - 1, self.alarm - 1
    elseif SceneType == self.data.EUIOpenType.MATCH_TIME then
        l_matchPerTime = l_matchPerTime - l_countDownAlarm
        local l_data = DataMgr:GetData("GuildMatchData").TimeStamp
        self.time = DataMgr:GetData("GuildMatchData").TimeStamp - Common.TimeMgr.GetNowTimestamp()
        self.alarm = self.time - l_matchPerTime
        return self.round, self.time, self.alarm
    end
    return 0, 0

end

function MainGuildMatchCtrl:TimeToUI(TimeUI, type)

    if type == self.data.EUIOpenType.MATCH_TIME then
        self.round, self.time, self.alarm = self:GetRoundAndTime(self.data.EUIOpenType.MATCH_TIME)
    elseif type == self.data.EUIOpenType.PRE_TIME then
        self.round, self.time = self:GetRoundAndTime(self.data.EUIOpenType.PRE_TIME)
    end
    self.panel.WaitTipTxt.LabText = Lang("MATCH_PRE_HINT", self.round)
    if self.time < 0 then
        self.time = 0
    end
    TimeUI.LabText = StringEx.Format("{0:00}:{1:00}", math.floor(self.time / 60), self.time % 60)
    if self.time <= 30 then
        if TimeUI.LabColor ~= fightWarnColor then
            TimeUI.LabColor = fightWarnColor
        end
    else
        if TimeUI.LabColor ~= fightNormalColor then
            TimeUI.LabColor = fightNormalColor
        end
    end
    if self.alarm >= 1 then
        if self.alarm <= 10 then
            self.panel.Alarm.gameObject:SetActiveEx(true)
            self.panel.Tips.LabText = StringEx.Format(Lang("ARENA_BEGIN_TIP"), tostring(self.alarm))
            local l_watchWarData = DataMgr:GetData("WatchWarData")
            local uHeartTable = l_watchWarData.PlayerLife
            if uHeartTable then
                for k, v in pairs(uHeartTable) do
                    MgrMgr:GetMgr("DungeonMgr").ShowLifeHUD(3, v.second, nil, v.first)
                end
            end
        else
            self.panel.Alarm.gameObject:SetActiveEx(false)
        end
    else
        self.panel.Alarm.gameObject:SetActiveEx(false)
    end
    local l_rtTrans = self.panel.TipBg.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(l_rtTrans)

end

function MainGuildMatchCtrl:StartCountDown(TimeUI, type)

    self:StopCountDown()
    self:TimeToUI(TimeUI, type)
    self.timer = self:NewUITimer(function()
        self:TimeToUI(TimeUI, type)
    end, 1, -1)
    self.timer:Start()

end

function MainGuildMatchCtrl:RefreshTeamCache()

    local l_teamCache = self.data.GetTeamCache()
    for i = 1, 4, 1 do
        if l_teamCache[i] then
            self.panel.WarnTip[i].gameObject:SetActiveEx(true)
            self.panel.WarnTipTxt[i].LabText = Lang("MATCH_PRE_TEAM_HINT", l_teamCache[i].name)
        else
            self.panel.WarnTip[i].gameObject:SetActiveEx(false)
        end
    end

end

function MainGuildMatchCtrl:PreInit()

    self.panel.PrePare.gameObject:SetActiveEx(false)
    self.panel.Alarm.gameObject:SetActiveEx(false)
    self.panel.WaitPanel.gameObject:SetActiveEx(true)

    self:StartCountDown(self.panel.CountDown, self.data.EUIOpenType.PRE_TIME)
    self.panel.WaitTip.gameObject:SetActiveEx(true)
    self:RefreshTeamCache()

end

function MainGuildMatchCtrl:MatchInit()

    self.panel.PrePare.gameObject:SetActiveEx(false)
    self.panel.Alarm.gameObject:SetActiveEx(false)
    self.panel.WaitPanel.gameObject:SetActiveEx(false)

    ---@type ModuleData.WatchWarData
    local l_data = DataMgr:GetData("WatchWarData")
    if l_data.MainWatchRoomInfo and l_data.MainWatchRoomInfo.hasGuildMatchInfo then
        self:RefreshMatch()
    end
    self:StartCountDown(self.panel.Time, self.data.EUIOpenType.MATCH_TIME)

end

function MainGuildMatchCtrl:RefreshMatch()
    if self.uiPanelData and self.uiPanelData == self.data.EUIOpenType.PRE_TIME then
        return
    end
    self.panel.PrePare.gameObject:SetActiveEx(true)
    ---@type ModuleData.WatchWarData
    local l_data = DataMgr:GetData("WatchWarData")
    local l_dungeonID = tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchBattleDungeonId").Value)
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonID)
    self.panel.Round.LabText = l_data.MainWatchRoomInfo.roundTxt
    self.panel.BlueFlowers.LabText = l_data.MainWatchRoomInfo.camp1_flower
    self.panel.RedFlowers.LabText = l_data.MainWatchRoomInfo.camp2_flower
    self.panel.BlueScore.LabText = l_data.MainWatchRoomInfo.camp1_score
    self.panel.RedScore.LabText = l_data.MainWatchRoomInfo.camp2_score
    local l_matchPerTime = l_dungeonData.TimeLimit:get_Item(1)
    self.alarm = self.time - l_matchPerTime
    if l_data.MainWatchRoomInfo.HistoryCamp1 == nil or #l_data.MainWatchRoomInfo.HistoryCamp1 < 3
            or l_data.MainWatchRoomInfo.HistoryCamp2 == nil or #l_data.MainWatchRoomInfo.HistoryCamp2 < 3 then
        --直接通过GM指令进入匹配赛不会立刻收到数据，否则需要服务器查下逻辑
        for i = 1, 6 do
            self.panel.BluePoint[i]:SetActiveEx(false)
            self.panel.RedPoint[i]:SetActiveEx(false)
        end
        return
    end
    for i = 1, 3 do
        self.panel.BluePoint[i * 2]:SetActiveEx(l_data.MainWatchRoomInfo.HistoryCamp1[i] == DungeonsResultStatus.kResultVictory)
        self.panel.BluePoint[i * 2 - 1]:SetActiveEx(l_data.MainWatchRoomInfo.HistoryCamp1[i] == DungeonsResultStatus.kResultDraw)
        self.panel.RedPoint[i * 2]:SetActiveEx(l_data.MainWatchRoomInfo.HistoryCamp2[i] == DungeonsResultStatus.kResultVictory)
        self.panel.RedPoint[i * 2 - 1]:SetActiveEx(l_data.MainWatchRoomInfo.HistoryCamp2[i] == DungeonsResultStatus.kResultDraw)
    end

end

--lua custom scripts end
return MainGuildMatchCtrl