module("ModuleMgr.MapleServerInfoMgr", package.seeall)

local l_serverList
local l_fetchArgs

function Init()
    local l_account = game:GetAuthMgr().AuthData.GetAccountInfo().account
    logGreen("[MapleServerInfoMgr] Init {0}", l_account)
    if not MMaple.IsMapleConnected() or MNetClient.NetLoginStep == ENetLoginStep.LoginServerLogged then
        --未连接与切换帐号时需要Init
        MMaple.MapleInit(CJson.encode({openid = l_account}))
    end

    return false
end

function FetchServerInfo(arg)
    logGreen("[MapleServerInfoMgr]FetchServerInfo")
    Init()
    l_fetchArgs = arg
    MMaple.MapleQueryTree(CJson.encode({zoneId = arg.mapleZoneId}))
end

function OnFetchServerTreeInfo(succ, gateList)
    if not succ then
        if type(l_fetchArgs.cb) == "function" then
            l_fetchArgs.cb(succ, nil, l_fetchArgs.forLogin)
        end
        return
    end
    if gateList.allservers.Count == 0 then
        logError("[MapleServerInfoMgr][OnFetchServerTreeInfo]gateList.allservers.Count = 0")
        if type(l_fetchArgs.cb) == "function" then
            l_fetchArgs.cb(succ, nil, l_fetchArgs.forLogin)
        end
        return
    end

    logGreen("[MapleServerInfoMgr]拉取maple成功")
    l_serverList = GateDataToTable(gateList)
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
        l_gate = l_serverList.allservers[1]
    end
    l_serverList.recommandgate = l_gate

    --关闭连接
    -- MNetClient:CloseConnection()
    if type(l_fetchArgs.cb) == "function" then
        l_fetchArgs.cb(succ, l_gate, l_fetchArgs.forLogin)
    end
end

function GetServerList()
    return l_serverList
end

function GateDataToTable(info)
    local l_loginType = game:GetAuthMgr().loginType
    l_serverList = {
        recommandgate = nil,
        servers = {},
        allservers = {}
    }
    local l_recommandgateTable = LoginGateDataToTable(info.recommandgate, l_loginType)
    if l_recommandgateTable ~= nil then
        l_serverList.recommandgate = l_recommandgateTable
    end
    for i = 0,info.servers.Count - 1 do
        local l_selfServerTable = SelfServerDataToTable(info.servers[i], l_loginType)
        if l_selfServerTable ~= nil then
            table.insert(l_serverList.servers, l_selfServerTable)
        end
    end

    for i = 0,info.allservers.Count - 1 do
        local l_gateServerTable = LoginGateDataToTable(info.allservers[i], l_loginType)
        if l_gateServerTable ~= nil then
            table.insert(l_serverList.allservers, LoginGateDataToTable(info.allservers[i], l_loginType))
        end
    end

    return l_serverList
end

local l_map = {
    [GameEnum.EMSDKLoginType.QQ] = 1,
    [GameEnum.EMSDKLoginType.Weixin] = 2,
    [GameEnum.EMSDKLoginType.WXQrCode] = 2,
    -- [GameEnum.EMSDKLoginType.Guest] = "Guest"
}

function LoginGateDataToTable(data, loginType)
    if data == nil then
        return nil
    end
    -- attr1:
    -- 1=>QQ
    -- 2=>微信
    -- 3=>都能看
    if data.customData.attr1 ~= 3 then
        if l_map[loginType] == nil or l_map[loginType] ~= data.customData.attr1 then
            return nil
        end
    end
    -- attr2:
    -- 1=>所有人可看到
    -- 2=>普白以上看到
    -- 3=>只有超白能看到
    local arg = {
        ip = data.ip,
        zonename = data.zonename,
        servername = data.servername,
        port = data.port,
        serverid = data.serverid,
        state = data.state,
        flag = data.flag
    }
    if MSpecialUserManager.MatchUserTag(MUserType.SuperPlayer) then
        if data.customData.attr2 <= 3 then
            return arg
        end
    elseif MSpecialUserManager.MatchUserTag(MUserType.TestPlayer) then
        if data.customData.attr2 <= 2 then
            return arg
        end
    elseif MSpecialUserManager.MatchUserTag(MUserType.Normal)
            or MSpecialUserManager.CurrentPlayerTag == 0 then
        if data.customData.attr2 <= 1 then
            return arg
        end
    end
    return nil
end

function SelfServerDataToTable(data, loginType)
    if data == nil then
        return nil
    end
    local l_data = LoginGateDataToTable(data.servers, loginType)
    if l_data ~= nil then
        return {
            level = data.level,
            servers = l_data,
        }
    else
        return nil
    end
end