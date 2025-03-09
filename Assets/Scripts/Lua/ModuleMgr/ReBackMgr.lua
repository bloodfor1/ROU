--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.ReBackMgr
module("ModuleMgr.ReBackMgr", package.seeall)

l_eventDispatcher = EventDispatcher.new()

SIG_RETURN_TASK_UPDATE = "SIG_RETURN_TASK_UPDATE"
SIG_WELCOME_NEXT_RES = "SIG_WELCOME_NEXT_RES"
SIG_WELCOME_FRIEND_CHOOSE_CHANGE = "SIG_WELCOME_FRIEND_CHOOSE_CHANGE"
SIG_WELCOME_GUILD_CHOOSE_CHANGE = "SIG_WELCOME_GUILD_CHOOSE_CHANGE"
SIG_RETURN_WELCOME_STATUS_NTF = "SIG_RETURN_WELCOME_STATUS_NTF"
SIG_GET_MEET_GIFT_PREVIEW_ITEM = "SIG_GET_MEET_GIFT_PREVIEW_ITEM"
OnReconnectedEvent="OnReconnectedEvent"
local l_curWaitMessage = nil

--lua model end

--lua custom scripts

local l_taskData = {}
---@type ReturnPrizeWelcomeInfo
local l_status = nil
local endTime = -1
local timeLeftFormat = nil

function OnInit()
    timeLeftFormat = Common.Utils.Lang("Return_Time_Left")
end

function OnLogout()
    ResetData()
end

function OnReconnected(reconnectData)
    --ResetData()
    l_curWaitMessage = nil
    l_eventDispatcher:Dispatch(OnReconnectedEvent)
end

function ResetData()
    l_taskData = {}
    l_status = nil
    endTime = -1
    l_curWaitMessage = nil
end

function OnEnterScene(sceneId)
    CheckLetter()
end

function CheckLetter()
    if MPlayerInfo.ShownTagId == ROLE_TAG.RoleTagRegress and ModuleMgr.OpenSystemMgr.IsSystemOpen(ModuleMgr.OpenSystemMgr.eSystemId.Return) then
        if l_status then
            local ui = UIMgr:GetUI(UI.CtrlNames.ReBackLetter)
            if ui ~= nil then
                return
            end
            UIMgr:ActiveUI(UI.CtrlNames.ReBackLetter)
        end
    end
end

-- 欢迎流程进度通知，流程结束后不再下发这个数据
function OnReturnStatusNtf(msg)
    ---@type ReturnPrizeWelcomeInfo
    local info = ParseProtoBufToTable("ReturnPrizeWelcomeInfo", msg)
    l_status = info
    l_eventDispatcher:Dispatch(SIG_RETURN_WELCOME_STATUS_NTF)
end

-- 重置。上线、跨天时收到
function OnReturnTaskReset(msg)
    ---@type ReturnPrizeNtf
    local info = ParseProtoBufToTable("ReturnPrizeNtf", msg)
    l_taskData = {}
    endTime = tonumber(info.endtime)
    MgrMgr:GetMgr("ReBackLoginMgr").SetLoginData(info)
    _updateTaskData(info.returntasks.allreturntasks)
    l_eventDispatcher:Dispatch(SIG_RETURN_TASK_UPDATE)
end

function OnReturnTaskUpdate(msg)
    ---@type ReturnPrizeTaskUpdateInfoNtf
    local info = ParseProtoBufToTable("ReturnPrizeTaskUpdateInfoNtf", msg)
    _updateTaskData(info.returntasks.allreturntasks)
    l_eventDispatcher:Dispatch(SIG_RETURN_TASK_UPDATE)
end

-- 回归任务请求领奖
function ReqFinishTask(taskID)
    local msgId = Network.Define.Rpc.ReturnTaskFinish
    ---@type GetReturnTaskPrizeReq
    local sendInfo = GetProtoBufSendTable("GetReturnTaskPrizeReq")
    sendInfo.returntaskid = taskID
    Network.Handler.SendRpc(msgId, sendInfo)
end

function ResFinishTask(msg)
    ---@type GetReturnTaskPrizeRes
    local l_info = ParseProtoBufToTable("GetReturnTaskPrizeRes", msg)
    local l_errorCode = l_info.result
    if 0 ~= l_errorCode then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_errorCode)
    end
end

-- 下一步
function ReqPrizeWelcomeNext(friendList,statue)
    if l_curWaitMessage then
        return
    end
    l_curWaitMessage = Network.Define.Rpc.ReturnPrizeWelcomeNext
    local msgId = Network.Define.Rpc.ReturnPrizeWelcomeNext
    ---@type ReturnPrizeWelcomeNextReq
    local sendInfo = GetProtoBufSendTable("ReturnPrizeWelcomeNextReq")
    if friendList then
        for _,v in ipairs(friendList) do
            local cData = sendInfo.chozenfriends:add()
            cData = v
        end
    end
    sendInfo.status = statue and statue or l_status.status
    Network.Handler.SendRpc(msgId, sendInfo)
end

function ResPrizeWelcomeNext(msg)
    if l_curWaitMessage then
        l_curWaitMessage = nil
    end
    ---@type ReturnPrizeWelcomeNextRsp
    local info = ParseProtoBufToTable("ReturnPrizeWelcomeNextRsp", msg)
    if info.result ~= 0 then
        if info.result == ErrorCode.ERR_RETURN_WELCOME_WRONG_STATUS then
            ReqPrizeWelcomeNext(nil,0)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.ReBackTips)
            UIMgr:DeActiveUI(UI.CtrlNames.ReBackLetter)
        end
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(info.result)
    end
    l_status = info.welcomeinfo
    if l_status.status == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_end + 1 then       -- 已经结束
        l_status = nil
    end
    l_eventDispatcher:Dispatch(SIG_WELCOME_NEXT_RES)
end

function GetSortedTaskData()
    return l_taskData
end

function _sortFunc(a,b)
    if a.isTaken ~= b.isTaken then
        return b.isTaken
    elseif a.isFinish ~= b.isFinish then
        return a.isFinish
    else
        return false
    end
end

function _updateTaskData(taskList)
    for k,v in pairs(taskList) do
        _updateOneTaskInfo(v)
    end
    table.sort(l_taskData,_sortFunc)
end

function _updateOneTaskInfo(info)
    for i,v in ipairs(l_taskData) do
        if v.taskID == info.taskid then
            v.step = info.step
            v.isFinish = info.isfinish
            v.isTaken = info.istaken
            return
        end
    end
    local data = {}
    data.taskID = info.taskid
    data.step = info.step
    data.isFinish = info.isfinish
    data.isTaken = info.istaken
    data.cfg = TableUtil.GetReturnTask().GetRow(info.taskid)
    table.insert(l_taskData,data)
end

function ReturnCheckRedSign()
    for k,v in ipairs(l_taskData) do
        if v.isFinish and not v.isTaken then
            return 1
        end
    end
    return 0
end

-- 返回秒
function GetLeftTime()
    if endTime < 0 then
        return 0
    end
    local result = endTime - Common.TimeMgr.GetNowTimestamp()
    if result < 0 then
        result = 0
    end
    return result
end

function GetFormatTime(leftTime)
    local day,t1 = math.modf(leftTime / 86400)
    local hour,t2 = math.modf(t1 * 24)
    local min = math.modf(t2 * 60)
    return StringEx.Format(timeLeftFormat,day,hour,min)
end

function GetStatue()
    if l_status then
        return l_status.status
    end
    return nil
end

function GetMeetGiftPackageID()
    if l_status then
        return l_status.prizeid
    end
    return nil
end

function GetReturnFriends()
    local result = {}
    if l_status then
        for _,v in ipairs(l_status.friends) do
            table.insert(result,v)
        end
        --for i=0,l_status.friends.Length - 1 do
        --    table.insert(result,l_status.friends[i])
        --end
    end
    return result
end

function GetReturnGuild()
    local result = {}
    if l_status then
        for _,v in ipairs(l_status.guilds) do
            local data = {}
            local tData = v
            data.guildId = tData.guildid
            data.guildName = tData.guildname
            data.friendCount = tData.friendcount
            data.maxCount = tData.maxcount
            data.currentCount = tData.currentcount
            data.iconId = tData.iconid
            table.insert(result,data)
        end
        --[[
        for i=0,l_status.guilds.Length - 1 do
            local data = {}
            local tData = l_status.guilds[i]
            data.guildId = tData.guildid
            data.guildName = tData.guildname
            data.friendCount = tData.friendcount
            data.maxCount = tData.maxcount
            data.currentCount = tData.currentcount
            table.insert(result.data)
        end
        ]]
    end
    return result
end

function GetAFKDay()
    if l_status then
        return l_status.afkdays
    end
    return 99
end

--lua custom scripts end
return ModuleMgr.ReBackMgr