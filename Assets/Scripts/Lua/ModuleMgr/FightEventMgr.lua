---
--- Created by richardjiang.
--- DateTime: 2018/7/31 15:04
--- 战斗事件处理 用来服务上层逻辑(如统计野外时间)
---



module("ModuleMgr.FightEventMgr", package.seeall)

local TimeMgr = Common.TimeMgr
local ActivityShowType = GameEnum.ActivityShowType


fightEvent = {
    harm = 1, -- 伤害
}
fightTimer = nil -- 野外战斗计时器
fightTime = 0 -- 野外战斗累计时间
wildCheckCd = 8 -- 野外检查间隔
stopCalcFightCd = 30 -- 停止野外战斗记时cd
fightNotifyEvents = {}
fightNotifyEventNamePrefix = "FIGHT_TIME_CALC_NOTIFY"
lastFightTime = -1
l_storeTag = "True"
l_expelActivityId = -1
l_ExpelMonsterTipTime = MGlobalConfig:GetFloat("ExpelMonsterTipTime")
EventDispatcher = EventDispatcher.new()
checkNoticeCache = {}

function OnInit()
    local dailyActivityTable = TableUtil.GetDailyActivitiesTable().GetTable()
    for i, v in ipairs(dailyActivityTable) do
        if v.NeedNotice and v.NeedNotice ~= "" then
            RegisterCheckEvents(v.Id, v.NeedNotice)
        end
        if v.Type == ActivityShowType.expelMonster then
            l_expelActivityId = v.Id
        end
    end
end

function OnUnInit()
    ClearFightTimer()
    fightNotifyEvents = {}
end

function OnLogout()
end

function OnReconnected(reconnectData)

end

function ClearFightTimer()
    if fightTimer then
        fightTimer:Stop()
        fightTimer = nil
    end
end

--[[
    @Description: 注册需要检查的系统
    @Date: 2018/7/31
    @Param: [args]
    @Return
--]]
function RegisterCheckEvents(activityId, needNoticeFunc)
    fightNotifyEvents[activityId] = {
        time = l_ExpelMonsterTipTime,
        checkFunc = ModuleMgr.DailyTaskMgr[needNoticeFunc],
        args = { activityId },
        event = fightNotifyEventNamePrefix .. activityId,
        needNoticeFunc = needNoticeFunc,
    }
end

--[[
    @Description: 移除需要检查的系统
    @Date: 2018/7/31
    @Param: [args]
    @Return
--]]
function UnRegisterCheckEvents(activityId)
    fightNotifyEvents[activityId] = nil
end

--[[
    @Description: 是否需要统计野外战斗时间
    @Date: 2018/8/2
    @Param: [args]
    @Return
--]]
function NeedStaticsFightTime()
    local result, ret = false, false
    for activityId, eventData in pairs(fightNotifyEvents) do
        if eventData.checkFunc then
            result, ret = pcall(eventData.checkFunc, unpack(eventData.args))
            if not result then
                logError("FightEvent.checkFunc check fail: ", ret)
                ret = false
            end
        end
        if result and ret then break end
    end
    return ret
end

--[[
    @Description: 累计野外战斗时间
    @Date: 2018/8/3
    @Param: [args]
    @Return
--]]
function OnFightEvent(_self)
    if not MScene.IsWild then return end

    --魔物驱逐时间通知
    MgrMgr:GetMgr("DailyTaskMgr").OnBlessMainButtonNoticeCheck()

    local dateTime = Common.TimeMgr.GetDateNumByTimestamp()
    if checkNoticeCache[dateTime] then
        local ret = false
        for activityId, eventData in pairs(fightNotifyEvents) do
            if not checkNoticeCache[dateTime][eventData.event] then
                ret = true
                break
            end
        end
        if not ret then return end
    end

    if not fightTimer then
        fightTimer = Timer.New(function () CalcFightTimer() end, wildCheckCd, -1, true)
        fightTimer:Start()
    end

    if lastFightTime < 0 then
        lastFightTime = Common.TimeMgr.GetUtcTimeByTimeTable()
    else
        local nowTime = Common.TimeMgr.GetUtcTimeByTimeTable()
        if nowTime - lastFightTime < wildCheckCd then
            fightTime = fightTime + (nowTime - lastFightTime)
        else
            fightTime = 0
        end
        lastFightTime = nowTime
    end
    --logError("fightTime ", fightTime)
end


function CalcFightTimer()
    if fightTime == 0 then return end

    if lastFightTime < 0 then lastFightTime = Common.TimeMgr.GetUtcTimeByTimeTable() end
    local nowTime = Common.TimeMgr.GetUtcTimeByTimeTable()
    if nowTime - lastFightTime >= stopCalcFightCd then
        fightTime = 0
        ClearFightTimer()
        return
    end

    local dateTime = Common.TimeMgr.GetDateNumByTimestamp()
    local result, ret = false, false
    for id, eventData in pairs(fightNotifyEvents) do
        if fightTime >= eventData.time then
            if eventData.checkFunc then
                result, ret = pcall(eventData.checkFunc, unpack(eventData.args))
            end
            if result and ret then
                if not checkNoticeCache[dateTime] then checkNoticeCache[dateTime] = {} end
                if checkNoticeCache[dateTime] and not checkNoticeCache[dateTime][eventData.event] and LoadTag(eventData.event) ~= l_storeTag then
                    UpdateCheckRedPoint()
                    ClearFightTimer()
                    StoreTag(eventData.event)
                end
            end
        end
    end
end

function GetWildFightTime()
    return fightTime
end

function StoreTag(eventName)
    local dateTime = Common.TimeMgr.GetDateNumByTimestamp()
    Common.Serialization.StoreData(eventName .. dateTime, l_storeTag, MPlayerInfo.UID:tostring())
    if not checkNoticeCache[dateTime] then checkNoticeCache[dateTime] = {} end
    checkNoticeCache[dateTime][eventName] = true
end

function LoadTag(eventName)
    return Common.Serialization.LoadData(eventName .. Common.TimeMgr.GetDateNumByTimestamp(), MPlayerInfo.UID:tostring()) or ""
end

function CheckExpelMonsterRedPoint()
    if fightTime >= l_ExpelMonsterTipTime and MgrMgr:GetMgr("DailyTaskMgr").NeedCheckRemindExpelMonster(l_expelActivityId) then
        return 1
    else
        return 0
    end
end

function UpdateCheckRedPoint()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.ExpelMonster)
end

function IsArenaPreFightOver()
    local mgr = MgrMgr:GetMgr("ArenaMgr")
    return mgr.IsFightOver()
end