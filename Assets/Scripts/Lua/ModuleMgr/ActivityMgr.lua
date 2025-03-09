-- 活动时间管理
module("ModuleMgr.ActivityMgr", package.seeall)

EventType = {
    ActivityRefresh = "ActivityRefresh",
    ActivityStateChange = "ActivityStateChange"
}

EventDispatcher = EventDispatcher.new()

-- 活动信息
activityTimeInfos = {}


function OnLogout()
    activityTimeInfos = {}
end

function GetActivityTimeInfo(timeId)
    return activityTimeInfos[timeId]
end

function GetBeginTimeStamp(timeId)
    local l_activityTimeInfo = activityTimeInfos[timeId]
    if l_activityTimeInfo then
        return l_activityTimeInfo.beginTimeStamp
    end
    return 0
end

function GetEndTimeStamp(timeId)
    local l_activityTimeInfo = activityTimeInfos[timeId]
    if l_activityTimeInfo then
        return l_activityTimeInfo.endTimeStamp
    end
    return 0
end

function GetShowBeginTimeStamp(timeId)
    local l_activityTimeInfo = activityTimeInfos[timeId]
    if l_activityTimeInfo then
        return l_activityTimeInfo.showBeginTimeStamp
    end
    return 0
end

function GetShowEndTimeStamp(timeId)
    local l_activityTimeInfo = activityTimeInfos[timeId]
    if l_activityTimeInfo then
        return l_activityTimeInfo.showEndTimeStamp
    end
    return 0
end

function OnNtfActivityTimeInfo(msg)
    ---@type NtfActivityTimeInfoList
    local l_info = ParseProtoBufToTable("NtfActivityTimeInfoList", msg)

    --logError(ToString(l_info))

    for i = 1, #l_info.activity_time_info_list do
        local l_activityTimeInfo = l_info.activity_time_info_list[i]
        activityTimeInfos[l_activityTimeInfo.time_id] = {
            timeId = l_activityTimeInfo.time_id,
            loopType = l_activityTimeInfo.loop_type,
            loopDay = l_activityTimeInfo.loop_day,
            beginTimeStamp = l_activityTimeInfo.real_begin_time,
            endTimeStamp = l_activityTimeInfo.real_end_time,
            showBeginTimeStamp = l_activityTimeInfo.show_begin_time,
            showEndTimeStamp = l_activityTimeInfo.show_end_time,
        }
    end

    EventDispatcher:Dispatch(EventType.ActivityRefresh)
end

function OnNtfActivityState(msg)
    ---@type ActivityState
    local l_info = ParseProtoBufToTable("ActivityState", msg)
    MgrMgr:GetMgr("GiftPackageMgr").UpdateTimeGiftInfos(l_info.activity_id,l_info.activity_state)
    EventDispatcher:Dispatch(EventType.ActivityRefresh, l_info.activity_type, l_info.activity_id, l_info.activity_state)
end


return ModuleMgr.ActivityMgr