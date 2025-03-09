---@module ModuleMgr.CommonServerInfoMgr
module("ModuleMgr.CommonServerInfoMgr", package.seeall)

--服务器信息
local l_serverList

--arg 需要的参数
--cb 是否为刷新服务器列表
function FetchServerInfo(arg)
    local l_msgId = Network.Define.Rpc.QueryGateIPNew
    ---@type QueryGateNewArg
    local l_sendInfo = GetProtoBufSendTable("QueryGateNewArg")
    l_sendInfo.token = arg.token
    l_sendInfo.account = arg.account
    l_sendInfo.type = arg.type
    l_sendInfo.platid = arg.platid
    l_sendInfo.version = arg.version
    Network.Handler.SendRpc(l_msgId, l_sendInfo, {
        cb = arg.cb,
        forLogin = arg.forLogin
    })
end

function OnQueryGateIPNew(msg, sendArg, customData)
    ---@type QueryGateNewRes
    local l_info = ParseProtoBufToTable("QueryGateNewRes", msg)
    if l_info.error ~= ErrorCode.ERR_SUCCESS then
        if type(customData.cb) == "function" then
            customData.cb(false, nil, customData.forLogin)
        end
        return
    end

    logGreen("[OnQueryGateIPNew]获取服务器列表信息成功")
    --按serverid排序
    table.sort(l_info.allservers, function(a, b) return a.serverid < b.serverid end)
    l_serverList = l_info
    local l_gate = game:GetAuthMgr().AuthData.GetCurGateServer()
    if l_gate ~= nil then
        local l_isExist = false
        for i, v in ipairs(l_serverList.allservers) do
            if l_gate.serverid == v.serverid then
                l_gate = v
                l_isExist = true
                break
            end
        end
        if not l_isExist then
            l_gate = l_serverList.recommandgate
        end
    else
        l_gate = l_serverList.recommandgate
    end

    if l_gate == nil then
        logError("[OnQueryGateIPNew]recommandgate is nil")
    else
        l_serverList.recommandgate = l_gate
    end

    --关闭连接
    -- MNetClient:CloseConnection()
    if type(customData.cb) == "function" then
        customData.cb(true, l_gate, customData.forLogin)
    end
end

function GetServerList()
    return l_serverList
end