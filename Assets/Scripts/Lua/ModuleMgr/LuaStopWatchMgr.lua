---@module ModuleMgr.LuaStopWatchMgr : ChatData
module("ModuleMgr.LuaStopWatchMgr", package.seeall)
--方便分析间隔时间，对应于C#中的StopWatch类
ELuaStopWatchType={
    LastHandleChatTime=1,
}
local l_stopWatchData = {}
function Start(label)
    if not checkLegality(label) then
        return
    end
    logYellow("[luaStopWatch] Start "..label)
    l_stopWatchData[label] = getCurrentMsTime()
end
function getCurrentMsTime()
    return MoonCommonLib.DateTimeEx.GetCurrentMsTime()
end
function GetTimeStamp(label)
    if not checkLegality(label) then
        return 0
    end
    local l_storeTimeStamp = l_stopWatchData[label]
    if l_storeTimeStamp==nil then
        return 0
    end
    return getCurrentMsTime() - l_storeTimeStamp
end

function End(label)
    if not checkLegality(label) then
        return
    end
    logYellow("[luaStopWatch] End "..label)
    l_stopWatchData[label] = nil
end

function Reset(label)
    if not checkLegality(label,true) then
        return
    end
    logYellow("[luaStopWatch] Reset "..label)
    Start(label)
end

function ResetAll()
    l_stopWatchData = {}
    logYellow("[luaStopWatch] ResetAll!")
end

function checkLegality(label,needExist)
    if label==nil then
        logError("[luaStopWatch]error: label is nil!")
        return false
    end
    if needExist then
        if l_stopWatchData[label]==nil then
            logError("[luaStopWatch]error: label对应的数据不存在!")
            return false
        end
    end
    return true
end

function OnInit()
    ResetAll()
end
return ModuleMgr.LuaStopWatch