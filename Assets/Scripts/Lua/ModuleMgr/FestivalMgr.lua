--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.FestivalMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
Event = {
    RefreshFestival = "Festival",
    OnGetAwardPreview = "OnGetAwardPreview",
    PointRefresh = "PointRefresh",
}
allClientOnce = {}
--lua model end

function OnInit()

    festivalData = DataMgr:GetData("FestivalData")
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BACKSTAGE_ACT,
        Callback = function(key, value)
            OnClientOnceCommonData(CommondataType.kCDT_BACKSTAGE_ACT, key, value)
        end
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BACKSTAGE_TOTAL_SCORE,
        Callback = function(key, value)
            OnClientOnceCommonData(CommondataType.kCDT_BACKSTAGE_TOTAL_SCORE, key, value)
        end
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BACKSTAGE_TODAY_SCORE_FIVE,
        Callback = function(key, value)
            OnClientOnceCommonData(CommondataType.kCDT_BACKSTAGE_TODAY_SCORE_FIVE, key, value)
        end
    })
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BACKSTAGE_TODAY_SCORE_ZERO,
        Callback = function(key, value)
            OnClientOnceCommonData(CommondataType.kCDT_BACKSTAGE_TODAY_SCORE_ZERO, key, value)
        end
    })
    l_commonData:Init(l_data)

end

function OnLogout()
    allClientOnce = {}
end

function UnInit()
    festivalData = nil
end

--lua custom scripts

function GetYMD(time)

    local l_time = Common.TimeMgr.GetLocalTimestamp(time)
    l_time = Common.TimeMgr.GetTimeTable(l_time)
    return StringEx.Format("{0:0000}.{1:00}.{2:00}", l_time.year, l_time.month, l_time.day)

end

function GetHMS(time)

    time = time / 60
    local min, sec = math.modf(time / 60)
    sec = time - (min * 60)
    return StringEx.Format("{0:00}:{1:00}", min, sec)

end

--openDay和closeDay的格式为"20200512"，dayOpenTime为开启时间段的列表，内元素单位为秒
function CheckActivityOpen(openDay, closeDay, dayOpenTime)

    local nowTime, nowDayTime
    nowTime = Common.TimeMgr.GetNowTimestamp()
    nowDayTime = nowTime - Common.TimeMgr.GetDayTimestamp()
    if nowTime < openDay or nowTime > closeDay then
        return false
    else
        if #dayOpenTime == 0 then
            return true
        end
        for i = 1, #dayOpenTime do
            if nowDayTime >= dayOpenTime[i].first and nowDayTime <= dayOpenTime[i].second then
                return true
            end
            if nowDayTime + 86400 >= dayOpenTime[i].first and nowDayTime + 86400 <= dayOpenTime[i].second then
                return true
            end
        end
        return false
    end

end

function IsActivityOpenByType(type)
    local l_actId = GetIdByType(type)
    local l_data = GetDataById(l_actId)
    if l_data then
        return CheckActivityOpen(l_data.actual_time.first, l_data.actual_time.second, l_data.day_times, l_data.delayTime)
    end
    return false
end




function OnBackstageAct(msg)
    ---@type backstageAct2ClientList
    local l_info = ParseProtoBufToTable("backstageAct2ClientList", msg)
    --logError(ToString(l_info))
    if l_info.act_list and #l_info.act_list > 0 then
        festivalData.UpdateInfo(l_info.act_list)
        festivalData.UpdateFatherInfo(l_info.father_data[#l_info.father_data])
        if l_info.is_from_rpc then
            if not UIMgr:IsActiveUI(UI.CtrlNames.Festival) then
                UIMgr:ActiveUI(UI.CtrlNames.Festival)
            else
                --EventDispatcher:Dispatch(Event.RefreshFestival)       TODO：没有必要
            end
        end
        local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
        gameEventMgr.RaiseEvent(gameEventMgr.FestivalDataUpdate)
    end
end

function SendBackstageAct()
    local l_msgId = Network.Define.Rpc.BackstageActRequest
    ---@type GiveGuildFlowerArg
    local l_sendInfo = GetProtoBufSendTable("BackstageActReqArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveBackStageActResult(msg)

    ---@type BackstageActReqRes
    local l_info = ParseProtoBufToTable("BackstageActReqRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
    --[[festivalData.UpdateTestInfo()
    if not UIMgr:IsActiveUI(UI.CtrlNames.Festival) then
        UIMgr:ActiveUI(UI.CtrlNames.Festival)
    end]]

end

function GetCommonDataValue(type, key)

    key = tonumber(key)
    if allClientOnce[type] == nil then
        return 0
    end
    if allClientOnce[type][key] == nil then
        return 0
    end
    return allClientOnce[type][key]

end

function OnClientOnceCommonData(type, key, valueInt64)
    valueInt64 = tonumber(valueInt64)
    if allClientOnce[type] == nil then
        allClientOnce[type] = {}
    end
    allClientOnce[type][key] = valueInt64
    EventDispatcher:Dispatch(Event.PointRefresh)
end

function ReqActData(type)
    local msgId = Network.Define.Rpc.ActivityGetData
    ---@type GetActivitiesDataArg
    local sendInfo = GetProtoBufSendTable("GetActivitiesDataArg")
    sendInfo.act_type = type
    Network.Handler.SendRpc(msgId, sendInfo)
end

function OnGetActData(msg, sendArg)
    ---@type GetActivitiesDataRes
    local l_info = ParseProtoBufToTable("GetActivitiesDataRes", msg)
    local l_errorCode = l_info.result
    if 0 ~= l_errorCode then
        local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end
    if l_info.act_type == GameEnum.EActType.NewKing then
        local count = 0
        if l_info.act_data ~= "" then
            local tempData = ParseProtoBufToTable("JifenActivityData",l_info.act_data)
            for i,v in ipairs(tempData.jifen_list) do
                count = count + tonumber(v.second)
            end
        end
        MgrMgr:GetMgr("ActivityNewKingMgr").SetTotalCount(count)
    end
end

--lua custom scripts end
return ModuleMgr.FestivalMgr