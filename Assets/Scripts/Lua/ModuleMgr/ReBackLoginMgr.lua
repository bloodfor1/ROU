module("ModuleMgr.ReBackLoginMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
GetDayAwardEvent = "GetDayAwardEvent"
GetSumDayAwardEvent = "GetSumDayAwardEvent"
ReceiveGetReturnLoginPrizeEvent = "ReceiveGetReturnLoginPrizeEvent"
ReceiveReturnPrizeLoginAwardUpdateEvent = "ReceiveReturnPrizeLoginAwardUpdateEvent"
OnReconnectedEvent="OnReconnectedEvent"

---@type ReturnPrizeLoginAward
local _returnPrizeLoginAward = nil
local _currentAwardTableId = 1

function ShowData(index1,index2,index3,index4)
    logGreen("_returnPrizeLoginAward:"..ToString(_returnPrizeLoginAward))
    logGreen("_currentAwardTableId:"..tostring(_currentAwardTableId))
    logGreen("IsDailyAwardCanGet:"..tostring(MgrMgr:GetMgr("ReBackLoginMgr").IsDailyAwardCanGet(index1)))
    logGreen("IsDailyAwardGetFinish:"..tostring(MgrMgr:GetMgr("ReBackLoginMgr").IsDailyAwardGetFinish(index2)))
    logGreen("IsSumAwardCanGet:"..tostring(MgrMgr:GetMgr("ReBackLoginMgr").IsSumAwardCanGet(index3)))
    logGreen("IsSumAwardGetFinish:"..tostring(MgrMgr:GetMgr("ReBackLoginMgr").IsSumAwardGetFinish(index4)))
end

---@param data ReturnPrizeNtf
function SetLoginData(data)
    if data == nil then
        logError("回归数据服务器发的是空的")
        return
    end
    SetLoginAwardData(data.loginaward)
    _currentAwardTableId = data.returnprizetype
end

---@param data ReturnPrizeLoginAward
function SetLoginAwardData(data)
    if data == nil then
        logError("回归数据服务器发的是空的")
        return
    end
    _returnPrizeLoginAward = data
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.ReBackLogin)
end

function IsDailyAwardCanGet(index)
    if _returnPrizeLoginAward == nil then
        logError("回归数据服务器发的是空的")
        return false
    end
    local dailyAwardsIndex = _returnPrizeLoginAward.dailyawardsindex
    return _isContainsIndex(dailyAwardsIndex, index)
end
function IsDailyAwardGetFinish(index)
    if _returnPrizeLoginAward == nil then
        logError("回归数据服务器发的是空的")
        return false
    end
    local finishedDailyAwardsIndex = _returnPrizeLoginAward.finisheddailyawardsindex
    return _isContainsIndex(finishedDailyAwardsIndex, index)
end

function IsSumAwardCanGet(index)
    if _returnPrizeLoginAward == nil then
        logError("回归数据服务器发的是空的")
        return false
    end
    local sumDayAwardsIndex = _returnPrizeLoginAward.sumdayawardsindex
    return _isContainsIndex(sumDayAwardsIndex, index)
end
function IsSumAwardGetFinish(index)
    if _returnPrizeLoginAward == nil then
        logError("回归数据服务器发的是空的")
        return false
    end
    local finishedSumDayAwardsIndex = _returnPrizeLoginAward.finishedsumdayawardsindex
    return _isContainsIndex(finishedSumDayAwardsIndex, index)
end

function IsCanGetAward()
    if _returnPrizeLoginAward == nil then
        return false
    end
    if #_returnPrizeLoginAward.dailyawardsindex>0 then
        return true
    end
    if #_returnPrizeLoginAward.sumdayawardsindex>0 then
        return true
    end
    return false
end

function _isContainsIndex(dataTable, index)
    if index == nil then
        return false
    end
    index = index - 1
    return table.ro_contains(dataTable, index)
end

function GetReturnLoginRewardTableInfo()
    local tableId = _currentAwardTableId
    local tableInfo = TableUtil.GetReturnLoginReward().GetRowByID(tableId)
    if tableInfo == nil then
        tableInfo = TableUtil.GetReturnLoginReward().GetRowByID(1)
    end
    return tableInfo
end

--领奖
function RequestGetReturnLoginPrize(isDaily, index)
    local l_msgId = Network.Define.Rpc.GetReturnLoginPrize
    ---@type GetReturnLoginPrizeReq
    local l_sendInfo = GetProtoBufSendTable("GetReturnLoginPrizeReq")
    l_sendInfo.isdaily = isDaily
    l_sendInfo.index = index
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveGetReturnLoginPrize(msg)
    ---@type GetReturnLoginPrizeRsp
    local l_info = ParseProtoBufToTable("GetReturnLoginPrizeRsp", msg)

    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(ReceiveGetReturnLoginPrizeEvent, l_info.isdaily, l_info.index)
end

function ReceiveReturnPrizeLoginAwardUpdate(msg)
    ---@type ReturnPrizeLoginAward
    local info = ParseProtoBufToTable("ReturnPrizeLoginAward", msg)
    SetLoginAwardData(info)
    EventDispatcher:Dispatch(ReceiveReturnPrizeLoginAwardUpdateEvent)
end

function RedSignCheckMethod()
    if IsCanGetAward() then
        return 1
    end
    return 0
end

function OnReconnected()
    EventDispatcher:Dispatch(OnReconnectedEvent)
end

function OnLogout()
    _returnPrizeLoginAward = nil
end

return ModuleMgr.ReBackLoginMgr