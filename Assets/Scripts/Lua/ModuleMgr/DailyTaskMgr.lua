---@class DailyActivityNetInfo
---@field id 
---@field maxCount
---@field nowCount
---@field start_time
---@field battleStartTime
---@field endTime
---@field state
---@field runState
---@field round
---@field roundLeftTime

---@module ModuleMgr.DailyTaskMgr
module("ModuleMgr.DailyTaskMgr", package.seeall)
ExtraFightStatus = GameEnum.ExtraFightStatus
EventDispatcher = EventDispatcher.new()

local l_dailyPanelListLayer = 41
local battleFuncID = 15001      -- 战场功能ID
function GetDailyPanelLayer()
    return l_dailyPanelListLayer
end

function OnNewDayComming()
    log("[DailyTaskMgr]OnNewDayComming...")
    --更新活动数据
    UpdateDailyTaskInfo()
end

DAILY_SCROLL_SCREEN_EVENT = "DAILY_SCROLL_SCREEN_EVENT"
DAILY_ACTIVITY_SHOW_EVENT = "DAILY_ACTIVITY_SHOW_EVENT"
DAILY_ACTIVITY_EXPEL_INFO = "DAILY_ACTIVITY_EXPEL_INFO"
DAILY_ACTIVITY_EXPEL_OPERATE = "DAILY_ACTIVITY_EXPEL_OPERATE"
DAILY_ACTIVITY_UPDATE_EVENT = "DAILY_ACTIVITY_UPDATE_EVENT"
DAILY_ACTIVITY_SHOW_NOTICE_EVENT = "DAILY_ACTIVITY_SHOW_NOTICE_EVENT" -- 显示活动倒计时提示
DAILT_FIRST_OPEN = "DAILT_FIRST_OPEN"   --每日首次打开冒险活动
DAILY_ACTIVITY_STATE_CHANGE = "DAILY_ACTIVITY_STATE_CHANGE"  --限时活动开放状态变更
NEW_DAY_COMING = "NEW_DAY_COMING"  --新的一天到来了

g_noticeTimer = nil
---@type DailyActivityNetInfo
g_netInfo = {}
g_gayPoint = nil
g_lastTime = nil
blessInfo = nil

remindCheckCd = 5           -- 检查提示间隔
fightTime = 10 * 60         -- 连续战斗时间
activityCacheSdatas = {}
openSystemSdatas = {}
wildFightTImeThresheld = nil
---@type DailyActivityNetInfo 
g_tempInfo = {}
g_pushActivityInfos = {}
g_isOpenDailyTask = false
g_farmPromptInfo = array.group(TableUtil.GetFarmInfoTable().GetTable(), "ProfessionId")
g_teamTargetInfo = {}
g_activityNotices = {}

--是否已被通知
mBeNoticedFlags = {}

local l_showItem = {}
local healthTime = MGlobalConfig:GetInt("HealthyFightTime")
local tiredTime = MGlobalConfig:GetInt("TiredFightTime")
local l_activityAward = MGlobalConfig:GetVectorSequence("ActivityAward")
local l_reward = {}
local l_lastRecordExpelRemainTime = 0  --上一次请求的魔物驱逐剩余祝福时间
local l_netInfoDataDirty = true  --g_netInfo数据发送变化
local l_lastCountRedSignData = 0
local l_lastRecordLocalTimeStamp = 0 --上一次记录的本地时间
local l_waitBattleData = false  -- 等待服务器战场数据
g_ActivityType = {
    activity_HappyPark = 1, ---乐园团
    activity_Recall = 2, ---贤者的回忆
    activity_Tower = 3, --- 无尽塔
    activity_Pvp = 4, ---pvp
    activity_Mvp = 5, ---mvp
    activity_Trial = 6, ---圣歌试炼
    activity_Battle = 7, --战场
    activity_Evil = 8, ----恶魔宝藏
    activity_Magic = 9, -----------魔物驱除
    activity_Ring = 10, ---擂台
    activity_GuildCook = 11, ---- 公会宴会
    activity_WorldNews = 12, ----时空调查团
    activity_CatTeam = 13, ----猫手商队
    activity_HeroChallenge = 14, ----英雄挑战
    activity_GuildHunt = 15, ----公会狩猎
    activity_WeekParty = 16, ----周末派对
    activity_TowerDefenseSingle = 17, ----天地树守卫战 单人
    activity_TowerDefenseDouble = 18, ----天地树守卫战 双人
    activity_GuildCookWeek = 19, ----公会周末宴会
    activity_GuildMatch = 20, ----公会匹配赛
    activity_Fashion = 21, ----时尚评分
    activity_GuildMatchWatch = 100001, ----公会匹配赛观战（非活动，仅做推送ID）
}
g_ActivityState = {
    Non = 0,
    Waiting = 1,
    CountDown = 2,
    Runing = 3,
    Finish = 4,
}

function OnInit()
    local activities = TableUtil.GetDailyActivitiesTable().GetTable()
    local hour, min = 0, 0
    local pushTimes, deltaTime = nil, 0
    for i, v in pairs(activities) do
        if v.ActiveType == GameEnum.ActivityType.weekInTime and v.PushTime.Count > 0 then
            if v.TimePass[0][0] ~= 0 then
                local noticeTimes = {}
                pushTimes = Common.Functions.VectorToTable(v.PushTime)
                for i, pushTime in ipairs(pushTimes) do
                    hour, min = math.floor((pushTime or 0) / 100), (pushTime or 0) % 100
                    deltaTime = hour * 3600 + min * 60
                    if deltaTime > 0 then
                        table.insert(noticeTimes, deltaTime)
                    end
                end
                g_pushActivityInfos[v.Id] = { sData = v, noticeTimes = noticeTimes, _noticeTimes = array.copy(noticeTimes) }
            end
        end
    end

    local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    l_dailyTaskMgr.EventDispatcher:Add(l_dailyTaskMgr.DAILY_ACTIVITY_SHOW_NOTICE_EVENT, function(_self, time, id)
        local activitySdata = TableUtil.GetDailyActivitiesTable().GetRowById(id)
        if not activitySdata then
            return
        end
        if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(activitySdata.FunctionID) then
            return
        end
        if MPlayerDungeonsInfo.InDungeon then
            return
        end
        local stageEnum = StageMgr:GetCurStageEnum()
        if stageEnum == MStageEnum.RingPre or stageEnum == MStageEnum.BattlePre or
                stageEnum == MStageEnum.MatchPre or stageEnum == MStageEnum.ArenaPre then
            return
        end
        UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
            if time == 0 and activitySdata.TextAfterStartTime ~= "" then
                ctrl:ShowContentWithoutCountdown(activitySdata.TextAfterStartTime, id, true)
            else
                ctrl:StartLeftTimer(time, activitySdata.TextBeforeStartTime, id)
            end
        end)
    end, l_dailyTaskMgr)

    MgrMgr:GetMgr("GuildHuntMgr").EventDispatcher:Add(MgrMgr:GetMgr("GuildHuntMgr").ON_GET_GUILD_HUNT_INFO_RSP, function(_self)
        SendDailyActivityShowToMS()
    end, l_dailyTaskMgr)

    GlobalEventBus:Add(EventConst.Names.ARENA_MIN_OFFER, function(_self, id)
        if id then
            g_activityNotices[id] = true
        else
            logError("min offer invalid param ", id)
        end
    end, l_dailyTaskMgr)

    GlobalEventBus:Add(EventConst.Names.ARENA_CLOSE_OFFER, function(_self, id)
        if not id then
            g_activityNotices = {}
        else
            g_activityNotices[id] = nil
        end
    end, l_dailyTaskMgr)

    for i = 1, l_activityAward.Length do
        l_reward[i] = {}
        l_reward[i].count = tonumber(l_activityAward[i - 1][0])
        l_reward[i].rewardId = tonumber(l_activityAward[i - 1][1])
    end
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    l_openSystemMgr.EventDispatcher:Add(l_openSystemMgr.OpenSystemUpdate,
            function(a)
                UpdateDailyTaskInfo()
            end, l_dailyTaskMgr)
end

function OnUnInit()
    if g_noticeTimer then
        g_noticeTimer:Stop()
        g_noticeTimer = nil
    end
    g_pushActivityInfos = {}
    local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    l_dailyTaskMgr.EventDispatcher:RemoveObjectAllFunc(l_dailyTaskMgr.DAILY_ACTIVITY_SHOW_NOTICE_EVENT, l_dailyTaskMgr)
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.ARENA_MIN_OFFER, l_dailyTaskMgr)
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.ARENA_CLOSE_OFFER, l_dailyTaskMgr)
    MgrMgr:GetMgr("GuildHuntMgr").EventDispatcher:RemoveObjectAllFunc(MgrMgr:GetMgr("GuildHuntMgr").ON_GET_GUILD_HUNT_INFO_RSP, l_dailyTaskMgr)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    l_openSystemMgr.EventDispatcher:RemoveObjectAllFunc(l_openSystemMgr.OpenSystemUpdate,
            l_dailyTaskMgr)
end

function OnSelectRoleNtf()
    if g_noticeTimer then
        g_noticeTimer:Stop()
        g_noticeTimer = nil
    end
    g_noticeTimer = Timer.New(OnNoticeCheck, 1, -1)
    g_noticeTimer:Start()

    SendDailyActivityShowToMS()
end

function GetDayTimestamp(activityTime)
    local dayTime = Common.TimeMgr.GetDayTimestamp()
    if activityTime > 0 then
        local hour, min = math.floor(activityTime / 100), math.floor(activityTime % 100)
        dayTime = dayTime + hour * 3600 + min * 60
    end
    return dayTime
end

function OnNoticeCheck()
    --周限时活动开启主界面按钮通知检测
    for _, v in ipairs(g_netInfo) do
        local l_isOpen = false
        local l_row = TableUtil.GetDailyActivitiesTable().GetRowById(v.id)
        if l_row and l_row.ActiveType == 2 then
            l_isOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_row.FunctionID)
        end
        if l_isOpen then
            OnWeekInTimeMainButtonNoticeCheck(v.id, v.startTime)
        end
    end

    local curTime = Common.TimeMgr.GetLocalNowTimestamp()
    local startSec, spanSec, noticeTimes, battletTime
    local notice = false
    local noticeTime = 0
    local startTime = 0
    local endTime = 0
    local battleTime = 0
    local curZeroTime = Common.TimeMgr.GetLocalTimestamp(Common.TimeMgr.GetDayTimestamp())
    local pushActivitysData
    local lastActivityState = nil  --上次检测到的活动的开放状态
    local currentActivityState =  nil --本次检测到的活动的开放状态

    checkNewDay(curZeroTime,curTime)

    for i, v in ipairs(g_netInfo) do
        local l_pushActivityInfo = g_pushActivityInfos[v.id]
        if l_pushActivityInfo then
            notice = false
            lastActivityState = l_pushActivityInfo.lastActivityState
            pushActivitysData = l_pushActivityInfo.sData
            noticeTimes = l_pushActivityInfo.noticeTimes

            startTime = Common.TimeMgr.GetLocalTimestamp(v.startTime)
            endTime = Common.TimeMgr.GetLocalTimestamp(v.endTime)
            battleTime = Common.TimeMgr.GetLocalTimestamp(v.battleStartTime)

            if battleTime == 0 and pushActivitysData.StartTime.Count > 0 then
                battleTime = GetDayTimestamp(pushActivitysData.StartTime[0])
            end
            currentActivityState = curTime>=startTime and curTime<=endTime
            if currentActivityState ~= lastActivityState then
                if currentActivityState and (not lastActivityState) then --活动开始
                    EventDispatcher:Dispatch(DAILY_ACTIVITY_STATE_CHANGE, v.id,true)
                elseif (not currentActivityState) and  lastActivityState then --活动结束
                    EventDispatcher:Dispatch(DAILY_ACTIVITY_STATE_CHANGE, v.id,false)
                end
                l_pushActivityInfo.lastActivityState = currentActivityState
            end

            if battleTime > 0 then
                if curTime > battleTime and pushActivitysData.FunctionID == battleFuncID and not l_waitBattleData then      -- 如果战场已经结束，获取下一次活动时间
                    l_waitBattleData = true
                    SendDailyActivityShowToMS()
                end
                for j = #noticeTimes, 1, -1 do
                    local l_noticeLocalTime = curZeroTime + noticeTimes[j]
                    if curTime >= l_noticeLocalTime and curTime < battleTime then
                        table.remove(noticeTimes, j)
                        --- 当前时间距通知时间小于1分钟才会推送通知
                        if curTime - l_noticeLocalTime< 60 then
                            notice = true
                            noticeTime = battleTime - curTime
                        end
                    end
                end
                if notice and v.id ~= g_ActivityType.activity_GuildMatch then
                    --test 推送偶现大额时间bug无法复现，原因查不到，加追踪日志
                    if noticeTime>18000 then
                        logError("遇到此报错请把详细日志贴给@孟宇杰  curZeroTime:" .. tostring(curZeroTime)..
                                "   curTime:" .. tostring(curTime)..
                                "   endTime:" .. tostring(endTime)..
                                "   noticeTime:" .. tostring(noticeTime)..
                                "   battleTime:" .. tostring(battleTime)..
                                "   v.id:" .. tostring(v.id)..
                                "   时区："..tostring(MServerTimeMgr.TimeZoneOffsetValue)..
                                "   本地时间撮："..tostring(Common.TimeMgr.GetLocalNowTimestamp()))
                    end
                    EventDispatcher:Dispatch(DAILY_ACTIVITY_SHOW_NOTICE_EVENT, noticeTime, v.id)
                end

                if IsEmptyOrNil(pushActivitysData.TextAfterStartTime) then
                    endTime = battleTime
                end

                if g_activityNotices[v.id] and curTime > endTime then
                    GlobalEventBus:Dispatch(EventConst.Names.ARENA_CLOSE_OFFER, v.id)
                end
            end
        end
    end
end
function checkNewDay(zeroTimeStamp,nowLocalTimeStamp)
    if l_lastRecordLocalTimeStamp==0 then
        l_lastRecordLocalTimeStamp = nowLocalTimeStamp
        return
    end
    --- 新的一天到来了
    if l_lastRecordLocalTimeStamp<zeroTimeStamp and
        nowLocalTimeStamp >=zeroTimeStamp then
        EventDispatcher:Dispatch(NEW_DAY_COMING)
    end
    l_lastRecordLocalTimeStamp = nowLocalTimeStamp
end
function OpenDailyTask()
    g_isOpenDailyTask = true
    ---公会狩猎
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("GuildHuntMgr").ReqGetGuildHuntInfo()
    else
        SendDailyActivityShowToMS()
    end
end

function UpdateDailyTaskInfo()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Activity)
    if not l_isOpen then
        return
    end

    g_isOpenDailyTask = false
    ---公会狩猎
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("GuildHuntMgr").ReqGetGuildHuntInfo()
    else
        SendDailyActivityShowToMS()
    end
end

function SendDailyActivityShowToMS()
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk) then
        return
    end
    --拉取信息
    local l_msgId = Network.Define.Rpc.DailyActivityShowToMS
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnDailyActivityShowToMS(msg)
    ---@type DailyActivityShowRes
    local l_info = ParseProtoBufToTable("DailyActivityShowRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    g_tempInfo = {}
    UpdateInfo(l_info)
    SendDailyActivityShow()
end

function SendDailyActivityShow()
    --拉取信息
    local l_msgId = Network.Define.Rpc.DailyActivityShow
    ---@type DailyActivityShowArg
    local l_sendInfo = GetProtoBufSendTable("DailyActivityShowArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnDailyActivityShow(msg)
    --接收信息
    ---@type DailyActivityShowRes
    local l_info = ParseProtoBufToTable("DailyActivityShowRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    UpdateInfo(l_info)
    UpdateGuildHuntInfo()
    g_netInfo = {}

    g_netInfo = g_tempInfo
    l_netInfoDataDirty = true
    table.sort(g_netInfo, function(x, y)
        return x.startTime < y.startTime
    end)
    if g_isOpenDailyTask then
        EventDispatcher:Dispatch(DAILY_ACTIVITY_SHOW_EVENT)
    else
        EventDispatcher:Dispatch(DAILY_ACTIVITY_UPDATE_EVENT)
        MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_OnDailyActivityUpdate)
    end
    g_isOpenDailyTask = false
end

function UpdateInfo(msg)
    local l_rsp = msg.activitys
    g_gayPoint = msg.award_index
    if g_gayPoint == nil then
        g_gayPoint = 0
    end
    for i = 1, #l_rsp do
        AppendInfo(l_rsp[i])
    end
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.DailyTask)
end

function AppendInfo(info)
    local l_id = info.activity_id
    local l_activityInfo=nil
    for i = 1, #g_tempInfo do  --日常活动信息是否已添加
        local l_tempInfo=g_tempInfo[i]
        if l_tempInfo.id==l_id then
            l_activityInfo=l_tempInfo
            break
        end
    end
    if l_activityInfo==nil then
        l_activityInfo={}
        local l_index = #g_tempInfo + 1
        g_tempInfo[l_index] = l_activityInfo
    end
    l_activityInfo.id = l_id
    l_activityInfo.maxCount = info.max_count
    if l_activityInfo.maxCount == nil then
        l_activityInfo.maxCount = 0
    end
    l_activityInfo.nowCount = info.now_count
    if l_activityInfo.nowCount == nil then
        l_activityInfo.nowCount = 0
    end

    local l_start = info.start_time
    l_activityInfo.startTime = l_start == nil and 0 or MLuaCommonHelper.Int(l_start)
    local l_battleStartTime = info.battle_start_time or info.start_time
    l_activityInfo.battleStartTime = l_battleStartTime == nil and 0 or MLuaCommonHelper.Int(l_battleStartTime)
    local l_end = info.end_time
    l_activityInfo.endTime = l_end == nil and 0 or MLuaCommonHelper.Int(l_end)

    l_activityInfo.state = info.is_finished
    l_activityInfo.runState = info.status
    if info.platform then
        l_activityInfo.round = info.platform.round_id
        l_activityInfo.roundLeftTime = info.platform.next_round_left_time
    end
    --附带的战场排队信息
    if l_id == g_ActivityType.activity_Battle then
        MgrMgr:GetMgr("BattleMgr").SetState(info.battlefield.in_match_deque and true)
    end

    if info.FunctionID == battleFuncID then
       l_waitBattleData = false
    end
end

function UpdateGuildHuntInfo()
    local l_guildData = DataMgr:GetData("GuildData")
    if l_guildData.guildHuntInfo.state == 0 then
        return
    end
    local l_index = nil
    if #g_tempInfo > 0 then
        for i = 1, #g_tempInfo do
            if g_tempInfo[i].id == g_ActivityType.activity_GuildHunt then
                l_index = i
                break
            end
        end
    end
    if nil == l_index then
        l_index = #g_tempInfo + 1
        g_tempInfo[l_index] = {}
    end
    g_tempInfo[l_index].id = g_ActivityType.activity_GuildHunt
    g_tempInfo[l_index].maxCount = 0
    g_tempInfo[l_index].nowCount = 0
    g_tempInfo[l_index].battleStartTime = 0
    g_tempInfo[l_index].runState = 0
    if l_guildData.guildHuntInfo.state == 1 then
        g_tempInfo[l_index].startTime = tonumber(tostring(MServerTimeMgr.UtcSeconds)) - 1
        g_tempInfo[l_index].endTime = g_tempInfo[l_index].startTime + l_guildData.guildHuntInfo.leftTime
        g_tempInfo[l_index].state = false
        return
    end
    if l_guildData.guildHuntInfo.state == 2 then
        g_tempInfo[l_index].startTime = -1
        g_tempInfo[l_index].endTime = -1
        g_tempInfo[l_index].state = true
        return
    end
end

function OnUpdate()

end

function GetLastRecordExpelRemainTime()
    return l_lastRecordExpelRemainTime
end

function GetBattleTime(id)
    id = id or g_ActivityType.activity_Battle
    local l_time = MServerTimeMgr.UtcSeconds
    local l_count = #g_netInfo
    if l_count < 1 then
        return l_time
    end
    for i = 1, l_count do
        local l_id = g_netInfo[i].id
        if l_id == id then
            if id == g_ActivityType.activity_GuildCook or id == g_ActivityType.activity_GuildMatch
                    or id == g_ActivityType.activity_Fashion then
                local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(id)
                if sdata.StartTime.Count > 0 then
                    l_time = GetDayTimestamp(sdata.StartTime[0])
                end
            else
                l_time = g_netInfo[i].battleStartTime
            end
        end
    end
    return l_time
end

function IsPlatFormStart()
    local battleTime = GetBattleTime(g_ActivityType.activity_Ring)
    return Common.TimeMgr.GetNowTimestamp() >= MLuaCommonHelper.Int(battleTime)
end

function GetRoundFightInfo()
    local leftTime, round = 0, 0
    for i, v in ipairs(g_netInfo) do
        if v.id == g_ActivityType.activity_Ring then
            leftTime = v.roundLeftTime
            round = v.round
            break
        end
    end
    return leftTime, round
end

function GetFightRound()
    local _, round = GetRoundFightInfo()
    return round
end

function SendDrawBoLiPointAwardReq()
    local l_msgId = Network.Define.Rpc.DrawBoLiPointAward
    ---@type DrawBoLiPointAwardArg
    local l_sendInfo = GetProtoBufSendTable("DrawBoLiPointAwardArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnDrawBoLiPointAwardRsp(msg)
    ---@type DrawBoLiPointAwardRes
    local l_info = ParseProtoBufToTable("DrawBoLiPointAwardRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    --TODO
    SendDailyActivityShow()
end

--region 魔物驱逐
--[[
    @Description: 检查提示魔物驱逐活动
    @Date: 2018/7/31
    @Param: [args]
    @Return
--]]
function NeedCheckRemindExpelMonster(activityId)
    if HasBless() then
        return false
    end

    local ret = false
    local activitySdata = activityCacheSdatas[activityId]
    if not activitySdata then
        activitySdata = TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
        activityCacheSdatas[activityId] = activitySdata
    end
    if activitySdata then
        local funcSdata = openSystemSdatas[activitySdata.FunctionID]
        if not funcSdata then
            funcSdata = TableUtil.GetOpenSystemTable().GetRowById(activitySdata.FunctionID)
            openSystemSdatas[activitySdata.FunctionID] = funcSdata
        end
        ret = table.ro_contains(MgrMgr:GetMgr("OpenSystemMgr").OpenSystem, activitySdata.FunctionID) and (MPlayerInfo.Lv >= funcSdata.NoticeBaseLevel)
    end
    return ret
end

function GetDailyActivitiesTbData(activityId)
    local activityData = TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
    if activityData then
        return activityData
    end
    return nil
end

function GetBlessInfo()
    local l_msgId = Network.Define.Rpc.GetBlessInfo
    ---@type GetBlessInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetBlessInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetBlessInfo(msg)
    ---@type GetBlessInfoRes
    local l_info = ParseProtoBufToTable("GetBlessInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    blessInfo = l_info
    l_lastRecordExpelRemainTime = l_info.remain_time
    EventDispatcher:Dispatch(DAILY_ACTIVITY_EXPEL_INFO, l_info)
end

function BlessOperate(isOpen)
    local l_msgId = Network.Define.Rpc.BlessOperation
    ---@type BlessOperationArg
    local l_sendInfo = GetProtoBufSendTable("BlessOperationArg")
    l_sendInfo.is_open = isOpen
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnBlessOperate(msg)
    ---@type BlessOperationRes
    local l_info = ParseProtoBufToTable("BlessOperationRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    blessInfo.is_blessing = l_info.is_blessing
    EventDispatcher:Dispatch(DAILY_ACTIVITY_EXPEL_OPERATE, l_info)
end

function HasBless()
    return blessInfo and blessInfo.is_blessing
end

function GetActivityNetInfo(id)
    return array.find(g_netInfo or {}, function(v)
        if v.id == id then
            return v
        end
    end)
end
--endregion

---================================================================================================
function CheckRedSignMethod()

    if CheckActivityRedSign() > 0 then
        return 1
    end
    if CheckFirstUseToday() > 0 then
        return 1
    end
    return 0
end

function CheckFirstUseToday()
    --检测是否今日首次使用（5点刷新）
    local l_lastTimeStamp = PlayerPrefs.GetInt(Common.Functions.GetPlayerPrefsKey(DAILT_FIRST_OPEN), -1)
    if l_lastTimeStamp == -1 then
        return 1
    end

    local l_nowTime = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetNowTimestamp())
    local l_lastOpenDailyPanelTime = Common.TimeMgr.GetTimeTable(l_lastTimeStamp)
    if l_lastOpenDailyPanelTime.yday < l_nowTime.yday - 1 then
        return 1
    end
    if l_lastOpenDailyPanelTime.yday < l_nowTime.yday then
        if l_nowTime.hour >= 5 then
            return 1
        else
            return 0
        end
    end
    if l_lastOpenDailyPanelTime.hour < 5 and l_nowTime.hour >= 5 then
        return 1
    end
    return 0
end
function CheckActivityRedSign()
    l_netInfoDataDirty = true
    if not l_netInfoDataDirty then
        return l_lastCountRedSignData
    end
    l_lastCountRedSignData = 0
    local l_count = #g_netInfo
    if l_count < 1 then
        return 0
    end
    l_showItem = {}
    local l_existTimeLimitActivity = false
    for i = 1, l_count do
        local l_netInfo = g_netInfo[i]
        local l_id = l_netInfo.id
        local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(l_id)
        local l_isOpen = true
        local l_show = false
        local l_functionId = l_info.FunctionID
        if not table.ro_contains(MgrMgr:GetMgr("OpenSystemMgr").OpenSystem, l_functionId) then
            l_isOpen = false
            local l_row = TableUtil.GetOpenSystemTable().GetRowById(l_functionId)
            if l_row.NoticeBaseLevel > MPlayerInfo.Lv then
                l_show = true
            end
        end

        if l_isOpen or l_show then
            if l_netInfo.startTime ~= 0 and l_netInfo.startTime ~= nil then
                l_existTimeLimitActivity = true
                local startSec = MLuaClientHelper.GetTiks2NowSeconds(l_netInfo.startTime)
                startSec = MLuaCommonHelper.Int(startSec)
                local endSec = MLuaClientHelper.GetTiks2NowSeconds(l_netInfo.endTime)
                endSec = MLuaCommonHelper.Int(endSec)
                --活动开始前30分钟至结束显示红点
                if startSec <= 1800 and endSec > 0 then
                    l_showItem[l_id] = true
                end
            end
        end
    end
    if not l_existTimeLimitActivity then
        --不存在限时活动可将脏
        l_netInfoDataDirty = false
    end
    if table.ro_size(l_showItem) > 0 then
        l_lastCountRedSignData = 1
        return 1
    end
    return 0
end

function IsActivityLimited(activity_id)
    if not g_netInfo then
        return true
    end

    for i, v in ipairs(g_netInfo) do
        if v.id == activity_id then
            log("v.maxCount <= v.nowCount:" .. tostring(v.maxCount) .. "|" .. tostring(v.nowCount))
            return v.maxCount <= v.nowCount
        end
    end

    return true
end

function IsActivityOpend(activity_id)
    if not g_netInfo then
        return false
    end
    for i, v in ipairs(g_netInfo) do
        if v.id == activity_id then
            if v.startTime and v.endTime then
                if v.startTime == v.endTime and v.startTime == 0 then
                    return true
                else
                    require "Common/TimeMgr"
                    local l_curTime = Common.TimeMgr.GetNowTimestamp()
                    if l_curTime >= v.startTime and l_curTime < v.endTime then
                        return true
                    end
                end
                return false
            else
                logError("IsActivityOpendByFuncId  数据没有活动的开始时间和结束时间", tostring(v.startTime), tostring(v.endTime))
            end
            break
        end
    end

    return false
end
--@Description:活动是否在开放日
function IsActivityInOpenDay(activityId)
    local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
    if l_info==nil then
        return false
    end
    if not IsTimeLimitActivity(l_info.ActiveType) then
        return true
    end
    if activityId == g_ActivityType.activity_GuildHunt then
        local l_hasGuild = MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild()
        local l_canGetReward = MgrMgr:GetMgr("GuildHuntMgr").CheckReward()
        local l_isOpen = DataMgr:GetData("GuildData").guildHuntInfo.state ~= 0 or l_canGetReward
        return l_hasGuild and l_isOpen
    end

    if l_info.TimeCycle==nil or l_info.TimeCycle.Count<1 then
        return true
    end

    local l_weekDay=Common.TimeMgr.GetNowWeekDay()
    for i = 0, l_info.TimeCycle.Count-1 do
        local l_tempWeekDay=l_info.TimeCycle[i]
        if l_tempWeekDay==7 then
            l_tempWeekDay=0
        end
        if l_tempWeekDay==l_weekDay then
            return true
        end
    end
    return false
end
--==============================--
--@Description: 获取野外挂机状态提示
--@Date: 2018/9/17
--@Param: [args]
--@Return:
--==============================--
function GetStatusTip(time)
    if not wildFightTImeThresheld then
        wildFightTImeThresheld = {}
        table.insert(wildFightTImeThresheld, { time = 0, tip = Lang("EXPEL_MONSTER_STATUS_TIP_1"), color = RoColorTag.Green })
        table.insert(wildFightTImeThresheld, { time = healthTime, tip = Lang("EXPEL_MONSTER_STATUS_TIP_2"), color = RoColorTag.Yellow })
        table.insert(wildFightTImeThresheld, { time = tiredTime, tip = Lang("EXPEL_MONSTER_STATUS_TIP_3"), color = RoColorTag.Red })
    end
    local ret = "unknow"
    local color = RoColorTag.Blue
    for i, v in ipairs(wildFightTImeThresheld) do
        if i < #wildFightTImeThresheld then
            if time >= v.time and time < wildFightTImeThresheld[i + 1].time then
                ret = v.tip
                color = v.color
                break
            end
        else
            if time >= v.time then
                ret = v.tip
                color = v.color
                break
            end
        end
    end
    return ret, color
end

--==============================--
--@Description:根据职业和玩家等级获取推荐练级数据
--@Date: 2018/9/17
--@Param: [args]
--@Return:
--==============================--
function GetPromptInfoByJobAndLv()
    local lv = MPlayerInfo.Lv
    local _, proId = DataMgr:GetData("SkillData").CurrentProTypeAndId()
    local ret = {}
    local farmInfos = TableUtil.GetFarmInfoTable().GetTable()
    local proIds
    for i, v in ipairs(farmInfos) do
        proIds = Common.Functions.VectorToTable(v.ProfessionId)
        if lv >= v.LvRange[0] and lv <= v.LvRange[1] and table.ro_contains(proIds, proId) then
            table.insert(ret, v)
        end
    end
    return ret
end

function OnExtraFightTimeChange(time, lastTime)
    if lastTime == 0 then
        return
    end
    --if time >= healthTime and lastTime < healthTime then
    --    UIMgr:ActiveUI(UI.CtrlNames.TiredTips, function(ctrl)
    --        ctrl:UpdateNotice(ExtraFightStatus.tired)
    --    end)
    --else
    if time >= tiredTime and lastTime < tiredTime then
        UIMgr:ActiveUI(UI.CtrlNames.TiredTips, function(ctrl)
            ctrl:UpdateNotice(ExtraFightStatus.exhaust)
        end)
    end
end

function OnLogout()
    g_activityNotices = {}
    g_netInfo = {}
    --标志清除
    mBeNoticedFlags = {}
    if g_noticeTimer then
        g_noticeTimer:Stop()
        g_noticeTimer = nil
    end
    
end

--==============================--
--@Description:获取boli点数
--@Date: 2018/10/24
--@Param: [args]
--@Return:
--==============================--
function GetBoliAwardCount(id)
    local l_rewardCount = 0
    local sData = TableUtil.GetDailyActivitiesTable().GetRowById(id)
    if not sData then
        return
    end
    local l_times = sData.AcitiveTimes
    local l_acitiveAward2 = sData.AcitiveAwardTimes[1]
    local l_rewardRate = l_times / l_acitiveAward2
    local l_target = sData.AcitiveAward
    for i = 0, l_target.Count - 1 do
        if l_target:get_Item(i, 0) == 301 then
            l_rewardCount = l_target:get_Item(i, 1) * l_rewardRate
            break
        end
    end
    return l_rewardCount
end

function RequestSyncServerTime()
    local l_msgId = Network.Define.Rpc.SyncTime
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function GotoDailyTask(id, callback, talk)
    local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(id)
    if not sdata then
        return false
    end

    local l_sceneInfo = sdata.ScenePosition
    local sceneId, npcId, npcTb

    if id == g_ActivityType.activity_WorldNews then
        MgrMgr:GetMgr("WorldPveMgr").NavigateToNpc()
        return true
    else
        -- 读取npc离线表
        npcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(sdata.FunctionID)
        if not next(npcTb) then
            logError("日常活动{0}读取离线表Npc失败 ", sdata.ActivityName)
            return false
        end
        npcId = npcTb[1]
    end

    local arriveMethod = function(_sceneId)
        _sceneId = _sceneId or sceneId
        if talk then
            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(_sceneId, npcId)
        else
            MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(sdata.FunctionID)
        end
    end

    if l_sceneInfo.Length == 1 then
        l_sceneInfo = l_sceneInfo[0]
        sceneId = l_sceneInfo[0]
        local l_scenePos = Vector3.New(l_sceneInfo[1], l_sceneInfo[2], l_sceneInfo[3])
        if sceneId and sceneId > 0 then
            MTransferMgr:GotoPosition(MLuaCommonHelper.Int(sceneId), l_scenePos, arriveMethod)
            if callback then
                callback()
            end
            return true
        end
    elseif l_sceneInfo.Length > 1 then
        local sceneTb = {}
        local posTb = {}
        local j = 1
        while j <= l_sceneInfo.Length do
            local l_targetPosInfo = l_sceneInfo[j - 1]
            sceneTb[j] = l_targetPosInfo[0]
            posTb[j] = Vector3.New(l_targetPosInfo[1], l_targetPosInfo[2], l_targetPosInfo[3])
            j = j + 1
        end
        Common.CommonUIFunc.ShowItemAchievePlacePanel(sceneTb, posTb, function(i)
            arriveMethod(sceneTb[i])
            if callback then
                callback()
            end
        end)
        return true
    else
        local sceneTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(npcTb[1])
        if not next(sceneTb) or not next(posTb) then
            logError("Npc离线表中数据异常 NpcId = ", npcTb[1])
            return false
        end
        sceneId = sceneTb[1]
        MTransferMgr:GotoPosition(sceneId, posTb[1], arriveMethod)
        if callback then
            callback()
        end
        return true
    end
end

-- 根据活动获取组队搜索信息
function GetTeamTargetInfo(id)
    local ret = { teamTargetType = 0, teamTargetId = 0 }
    if id then
        local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(id)
        if sdata then
            if sdata.TeamTargetType[0] == 0 then
                ret.teamTargetId = 0
                ret.teamTargetType = sdata.TeamTargetType[1]
            else
                if not next(g_teamTargetInfo) then
                    g_teamTargetInfo = array.group(TableUtil.GetTeamTargetTable().GetTable(), "BelongType")
                end
                local belongTypeTargetInfos = g_teamTargetInfo[sdata.TeamTargetType[1]]
                if belongTypeTargetInfos and next(belongTypeTargetInfos) then
                    table.sort(belongTypeTargetInfos, function(a, b)
                        return a.LevelLimit[0] < b.LevelLimit[0]
                    end)
                    for i, v in ipairs(belongTypeTargetInfos) do
                        if MPlayerInfo.Lv >= v.LevelLimit[0] then
                            ret.teamTargetId = v.ID
                            ret.teamTargetType = v.BelongType
                            break
                        end
                    end
                end
            end
        end
    end
    return ret
end
------------------new-----------------
function GetShowTextByDailyActivityItem(data, isProgressShow, onlyTableStr)
    local l_isEmptyStr = true
    if data == nil then
        return "", l_isEmptyStr
    end
    local l_formatStr

    if data.Id == g_ActivityType.activity_GuildHunt then
        local l_hasGuild = MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild()
        local l_canGetReward = MgrMgr:GetMgr("GuildHuntMgr").CheckReward()
        if l_canGetReward and l_hasGuild then
            return Lang("CAN_GET_REWARD"), false
        else
            return "", l_isEmptyStr
        end
    end

    if isProgressShow then
        l_formatStr = data.ProgressDisplay
    else
        l_formatStr = data.CustomTextDisplay
    end
    if l_formatStr == "" then
        return l_formatStr, l_isEmptyStr
    end
    l_isEmptyStr = false
    if onlyTableStr then
        return l_formatStr, l_isEmptyStr
    end
    local l_showStr=""
    if data.Id==g_ActivityType.activity_Recall then
        local l_dayPassCount, l_dayPassLimit = MgrMgr:GetMgr("ThemeDungeonMgr").GetDayPassCountAndLimit()
        local l_weekPassCount, l_weekPassLimit = MgrMgr:GetMgr("ThemeDungeonMgr").GetWeekPassCountAndLimit()
        l_showStr = StringEx.Format(l_formatStr, l_weekPassCount .. "/" .. l_weekPassLimit, l_dayPassCount .. "/" .. l_dayPassLimit)
    elseif data.Id == g_ActivityType.activity_Tower then
        local l_lv = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_saveTowerLevel
        if l_lv<=0 then
            l_lv="-"
        end
        l_showStr = StringEx.Format(l_formatStr, l_lv)
    elseif data.Id == g_ActivityType.activity_Mvp then
        local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
        local l_target = l_limitMgr.g_allInfo[l_limitMgr.g_limitType.MVP_REWARD]
        local l_count1 = MgrMgr:GetMgr("LimitBuyMgr").GetItemCount(l_limitMgr.g_limitType.MVP_REWARD,2)
        local l_count2 = MgrMgr:GetMgr("LimitBuyMgr").GetItemLimitCount(l_limitMgr.g_limitType.MVP_REWARD,2)
        if not l_target then
            logError("[ActivityCtrl]没有找到剩余次数@陈阳@徐飞")
        end
        l_showStr = StringEx.Format(l_formatStr, string.format("%s/%s", l_count1, l_count2))
    elseif data.Id == g_ActivityType.activity_Magic then
        GetBlessInfo()
        if l_lastRecordExpelRemainTime > 0 then
            l_showStr = StringEx.Format(l_formatStr, math.floor(l_lastRecordExpelRemainTime / (60 * 1000)))
        end
    elseif data.Id == g_ActivityType.activity_WorldNews then
        local l_worldPveMgr = MgrMgr:GetMgr("WorldPveMgr")
        local l_dailyCount = l_worldPveMgr.todayCount
        local l_dailyTotalCount = l_worldPveMgr.todayMax
        --local l_weekCount = l_worldPveMgr.weekCount
        --local l_weekTotalCount = l_worldPveMgr.weekMax
        l_showStr = StringEx.Format(l_formatStr,  l_dailyCount , l_dailyTotalCount)
    elseif data.Id == g_ActivityType.activity_TowerDefenseSingle then
        local l_towerDefenseMgr = MgrMgr:GetMgr("TowerDefenseMgr")
        local l_countData = l_towerDefenseMgr.GetCountLimitData()
        if l_countData then
            local l_dailyTotalCount = l_countData.single.todayLimt
            local l_dailyCount = l_dailyTotalCount - l_countData.single.todayCount
            local l_weekTotalCount = l_countData.single.weekLimt
            local l_weekCount = l_weekTotalCount - l_countData.single.weekCount
            l_showStr = StringEx.Format(l_formatStr, l_weekCount .. "/" .. l_weekTotalCount, l_dailyCount .. "/" .. l_dailyTotalCount)
        else
            l_showStr = StringEx.Format(l_formatStr, "0/0", "0/0")
        end
    elseif data.Id == g_ActivityType.activity_TowerDefenseDouble then
        local l_towerDefenseMgr = MgrMgr:GetMgr("TowerDefenseMgr")
        local l_countData = l_towerDefenseMgr.GetCountLimitData()
        if l_countData then
            local l_weekTotalCount = l_countData.double.weekLimt
            local l_weekCount = l_weekTotalCount - l_countData.double.weekCount
            l_showStr = StringEx.Format(l_formatStr, l_weekCount .. "/" .. l_weekTotalCount)
        else
            l_showStr = StringEx.Format(l_formatStr, "0/0")
        end
    end
    return l_showStr, l_isEmptyStr
end
function GetActivityFinishState(activityId)
    local l_finish = false
    if activityId == g_ActivityType.activity_Recall then
        local l_weekCount = MgrMgr:GetMgr("ThemeDungeonMgr").WeekPassCount
        local l_weekTotalCount = MGlobalConfig:GetInt("GreatSecretMaxActivityLimit")
        l_finish = l_weekCount >= l_weekTotalCount
    elseif activityId == g_ActivityType.activity_Tower then
        local l_lv = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_saveTowerLevel
        l_finish = l_lv > 0
    elseif activityId == g_ActivityType.activity_Mvp then
        local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
        local l_target = l_limitMgr.g_allInfo[l_limitMgr.g_limitType.MVP_REWARD]
        local l_count1 = MgrMgr:GetMgr("LimitBuyMgr").GetItemCount(l_limitMgr.g_limitType.MVP_REWARD,2)
        local l_count2 = MgrMgr:GetMgr("LimitBuyMgr").GetItemLimitCount(l_limitMgr.g_limitType.MVP_REWARD,2)
        if not l_target then
            logError("[ActivityCtrl]没有找到剩余次数@陈阳@徐飞")
        end
        l_finish = l_count1 >= l_count2
    elseif activityId == g_ActivityType.activity_Magic then
        l_finish = false
    elseif activityId == g_ActivityType.activity_WorldNews then
        local l_worldPveMgr = MgrMgr:GetMgr("WorldPveMgr")
        local l_weekCount = l_worldPveMgr.weekCount
        local l_weekTotalCount = l_worldPveMgr.weekMax
        l_finish = l_weekCount >= l_weekTotalCount
    elseif activityId == g_ActivityType.activity_TowerDefenseSingle then
        local l_towerDefenseMgr = MgrMgr:GetMgr("TowerDefenseMgr")
        local l_countData = l_towerDefenseMgr.GetCountLimitData()
        local l_weekTotalCount = l_countData.single.weekLimt
        local l_weekCount = l_weekTotalCount - l_countData.single.weekCount
        l_finish = l_weekCount >= l_weekTotalCount
    elseif activityId == g_ActivityType.activity_TowerDefenseDouble then
        local l_towerDefenseMgr = MgrMgr:GetMgr("TowerDefenseMgr")
        local l_countData = l_towerDefenseMgr.GetCountLimitData()
        local l_weekTotalCount = l_countData.double.weekLimt
        local l_weekCount = l_weekTotalCount - l_countData.double.weekCount
        l_finish = l_weekCount >= l_weekTotalCount
    end
    return l_finish
end
function IsTimeLimitActivity(activityType)
    --是否为限时活动
    return activityType == 2 or activityType == 3
end
function GetTimeDes(sec)
    local l_hour, l_rem = math.modf(sec / 3600)
    local l_min = math.modf(l_rem * 60 + 0.5)
    return l_hour, l_min
end
--魔物驱逐主界面按钮通知检测
function OnBlessMainButtonNoticeCheck()
    if mBeNoticedFlags["Bless"] then
        return
    end

    --每次上线获取一次祝福时间
    if not mBeNoticedFlags["AlreadyGetBless"] then
        GetBlessInfo()
        mBeNoticedFlags["AlreadyGetBless"] = true
        return
    end

    local l_pushRow = TableUtil.GetDailyActivitiesPushTable().GetRowByPushMesId(2)
    if l_pushRow and blessInfo then
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterExpel)
                and blessInfo.remain_time / 60000 >= tonumber(l_pushRow.Parameter[0] or 999) then
            MgrMgr:GetMgr("MainUIMgr").ShowMainButtonNotice(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk, 2, { activityId = 9 })
            mBeNoticedFlags["Bless"] = true
        end
    end
end
function CanGotoActivity(data)
    if not data.isOpen then
        return false
    end
    if data == nil or data.tableInfo == nil or data.unOpenTime then
        return false
    end
    if data.id == g_ActivityType.activity_GuildCook then
        return true
    end
    if data.tableInfo.ScenePosition.Length > 0 then
        return true
    end
    if MgrMgr:GetMgr("SystemFunctionEventMgr").IsHaveSystemFunctionEvent(data.tableInfo.FunctionID) then
        return true
    end
    return false
end

--判断某次活动是否被玩家操作过，startTimeStamp用于标记某次活动
function IsActivityProcessed(pushId, activityId, startTimeStamp)
    local l_lastStartTimeStamp = PlayerPrefs.GetString(StringEx.Format("activity{0}-{1}-{2}", MPlayerInfo.UID, pushId, activityId))
    --if activityId == 10 then
    --    logError(tostring(MPlayerInfo.UID))
    --    logError(l_lastStartTimeStamp)
    --    logError(startTimeStamp)
    --end
    return l_lastStartTimeStamp == tostring(startTimeStamp)
end

function SetActivityProcessed(pushId, activityId, startTimeStamp)
    if startTimeStamp == nil then
        return
    end
    PlayerPrefs.SetString(StringEx.Format("activity{0}-{1}-{2}", MPlayerInfo.UID, pushId, activityId), startTimeStamp)
end

function GetActivityProcessedTime(pushId, activityId)
    local l_timeStr = PlayerPrefs.GetString(StringEx.Format("activity{0}-{1}-{2}", MPlayerInfo.UID, pushId, activityId), "0")
    if l_timeStr == "" then
        l_timeStr = "0"
    end
    return tonumber(l_timeStr)
end

--周限时活动开启主界面按钮通知检测
function OnWeekInTimeMainButtonNoticeCheck(activityId, startTimeStamp)
    if mBeNoticedFlags["activityOpen" .. activityId] or IsActivityProcessed(1, activityId, startTimeStamp) then
        return
    end
    local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
    if l_info == nil then
        return
    end
    local openId=l_info.FunctionID
    local openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(openId) then
        return
    end

    local l_pushRow = TableUtil.GetDailyActivitiesPushTable().GetRowByPushMesId(1)
    if l_pushRow then
        local l_leftTime = startTimeStamp - Common.TimeMgr.GetNowTimestamp()

        if l_leftTime <= tonumber(l_pushRow.Parameter[0] or 0) and l_leftTime > 0 then
            MgrMgr:GetMgr("MainUIMgr").ShowMainButtonNotice(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk, 1, { activityId = activityId, params = { l_info.ActivityName }, startTimeStamp = startTimeStamp })
            mBeNoticedFlags["activityOpen" .. activityId] = true
        end
    end
end

--公会狩猎通知
function OnGuildHuntOpenNotify()
    local l_startTimeStamp = Common.TimeMgr.GetNowTimestamp()
    local l_deltaTime = l_startTimeStamp - GetActivityProcessedTime(3, 15)
    if l_deltaTime < 24 * 3600 then
        return
    end
    --主界面按钮推送
    MgrMgr:GetMgr("MainUIMgr").ShowMainButtonNotice(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk, 3, { activityId = 15, startTimeStamp = l_startTimeStamp })
end

--公会狩猎可领奖通知（唯一活动结束后仍然需要提示玩家领奖的神奇活动）
function OnGuildHuntRewardNotify()
    local l_startTimeStamp = Common.TimeMgr.GetNowTimestamp()
    local l_deltaTime = l_startTimeStamp - GetActivityProcessedTime(4, 15)
    if l_deltaTime < 24 * 3600 then
        return
    end
    --主界面按钮推送
    MgrMgr:GetMgr("MainUIMgr").ShowMainButtonNotice(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk, 4, { activityId = 15, startTimeStamp = l_startTimeStamp })
end
------------------new end-------------
return ModuleMgr.DailyTaskMgr