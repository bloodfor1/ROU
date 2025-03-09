---@module ModuleMgr.ComErrorCodeMgr
module("ModuleMgr.ComErrorCodeMgr", package.seeall)

function ShowMarkedWords(errorInfo)
    local l_errorCode = errorInfo.errorno or ErrorCode.ERR_SUCCESS
    if l_errorCode == ErrorCode.ERR_SUCCESS then
    else
        --没有特殊需求走通用处理
        ShowCommon(errorInfo)
    end
end

function ShowCommon(errorInfo)
    local l_errorCode = errorInfo.errorno
    local l_param = errorInfo.param
    local l_s = Common.Functions.GetErrorCodeStr(l_errorCode)
    if l_s == nil then
        logError(tostring(l_errorCode))
        return
    end
    if l_param ~= nil then
        local l_ss = {}
        for i = 1, #l_param do
            l_ss[i] = tostring(l_param[i].value)
        end
        local l_showS = StringEx.Format(l_s, l_ss)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_showS)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
    end
end

--统一处理服务器返回给客户端的状态互斥错误码消息
function OnCheckStateExclusionFailNtf(msg)
    ---@type StateExclusionFailData
    local l_info = ParseProtoBufToTable("StateExclusionFailData", msg)
    local fromStateList = l_info.from_state_type_list
    local toState = l_info.to_state_type
    if fromStateList[1] and toState then
        StateExclusionManager:ShowMsgByStateCode(fromStateList[1].value, toState)
    end
    local stateIntTb = {}
    for i = 1, table.maxn(fromStateList) do
        table.insert(stateIntTb, fromStateList[i].value)
    end
    StateExclusionManager:ShowLogMsgByStateCode(stateIntTb, toState)
end