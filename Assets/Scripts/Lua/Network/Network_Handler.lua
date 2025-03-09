--[[
	发送&接收协议处理
--]]

module("Network.Handler", package.seeall)

RpcHandlers = {}
PtcHandlers = {}
OnConnectedHandlers = {}
OnConnectFailedHandlers = {}
OnReconnectedHandlers = {}
OnReconnectFailedHandlers = nil
OnClosedHandlers = {}
OnKickoutHandlers = nil
OnSwitchSceneFailedHandlers = nil
OnLuaDoEnterSceneHandlers = nil

--[[msgData可不传]]
function SendRpc(msgId, msgData, customData, onResp, onErr, onTimeout, onSendSuccess)
    local l_byteStr, l_byteLen = nil, 0
    if msgData ~= nil then
        l_byteStr = msgData:SerializeToString()
        l_byteLen = string.len(l_byteStr)
    end
    onErr = onErr or OnReceiveRpcMsgErr
    onTimeout = onTimeout or OnReceiveRpcTimeout

    MLuaNetworkHelper.sharedLuaSendBuffer:Copy(l_byteStr, l_byteLen)
	return MLuaNetworkHelper.SendRpcByLua(msgId,
        function(msgId, receivedMsg, receivedMsgLen)
            OnReceiveRpcMsg(msgId, receivedMsg, receivedMsgLen, msgData, customData, onResp)
            RecycleProtoBuf(msgData)
        end,
    onErr, onTimeout, onSendSuccess)
end

function OnReceiveRpcMsg(msgId, receivedMsg, receivedMsgLen, sendArg, customData, onResp)
    receivedMsg = string.sub(receivedMsg, 1, receivedMsgLen)

    --add by tm for debug protocols
    if g_Globals.DEBUG_NETWORK then

        MgrMgr:GetMgr("GmMgr").OnTestReceiveRpc(msgId, receivedMsg, receivedMsgLen)
    end

	local l_handler = RpcHandlers[msgId]
    if l_handler then
        if l_handler.file then
            require(l_handler.file)
        end
        if l_handler.func then
            l_handler.func(receivedMsg, sendArg, customData)
        end
    else
        logWarn("RPC:{0} has no handling method", msgId)
    end
    if onResp ~= nil then
        onResp(receivedMsg, sendArg, customData)
    end
end

function OnReceiveRpcMsgErr(msgId, errCode)
    msgId = tonumber(msgId) or 0
    if errCode == MLuaErrEnum.BUFFER_OVERFLOW then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_BUFFER_OVERFLOW", msgId))
    elseif errCode == MLuaErrEnum.RPC_PROCESSING then
        logRed("[LUARPC]Please wait previous processing rpc:{0}", msgId)
    else
        logError("RPC response error(" .. tostring(errCode) .. "), msgId=" .. tostring(msgId))
    end
end

function OnReceiveRpcTimeout(msgId)
    -- body
    logRed("[LUA][OnReceiveRpcTimeout]processing rpc:{0} is timeout", msgId)
end

--[[msgData可不传]]
function SendPtc(msgId, msgData, onSendSuccess)
    local l_byteStr, l_byteLen = nil, 0
    if msgData ~= nil then
        l_byteStr = msgData:SerializeToString()
        l_byteLen = string.len(l_byteStr)
    end
    RecycleProtoBuf(msgData)

    MLuaNetworkHelper.sharedLuaSendBuffer:Copy(l_byteStr, l_byteLen)
    return MLuaNetworkHelper.SendPtcByLua(msgId, onSendSuccess)
end

function OnReceivePtcMsg(msgId, luaBuffer, msgLen)
    --这里必须sub，因为传过来的luaBuffer是65536个byte长度，后面绝大部分都是空byte，会导致解析卡住
    luaBuffer = string.sub(luaBuffer, 1, msgLen)

    --add by tm for debug protocols
    if g_Globals.DEBUG_NETWORK then
        MgrMgr:GetMgr("GmMgr").OnTestReceivePtc(msgId, luaBuffer, msgLen)
    end
    --logError(tostring(msgId))
	local l_handler = PtcHandlers[msgId]
    if l_handler then
        if l_handler.file then
            require(l_handler.file)
        end
        if l_handler.func then
            l_handler.func(luaBuffer, msgLen)
        end
    end
end

function OnReceivePtcMsgErr(msgId, errCode)
    msgId = tonumber(msgId) or 0
    if errCode == MLuaErrEnum.BUFFER_OVERFLOW then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NET_BUFFER_OVERFLOW", msgId))
    else
        logError("Ptc response error(" .. tostring(errCode) .. "), msgId=" .. tostring(msgId))
    end
end

--连接成功
function OnConnected()
    local l_stage = StageMgr.current
    local l_handler = OnConnectedHandlers[l_stage]
    if l_handler then
        l_handler()
    end
end

--连接失败
function OnConnectFailed()
    local l_stage = StageMgr.current
    local l_handler = OnConnectFailedHandlers[l_stage]
    if l_handler then
        l_handler()
    end
end

function Reconnect()
    MNetClient:Reconnect()
end

--重连成功
function OnReconnected(msg)
    local l_handler = OnReconnectedHandlers
    if l_handler then
        l_handler(msg)
    end
end

--重连失败
function OnReconnectFailed()
    local l_handler = OnReconnectFailedHandlers
    if l_handler then
        l_handler()
    end
end

--连接断开
function OnClosed(errCode)
    if errCode == ENetErrCode.Net_NormalClose then
        return
    end

    local l_step = MNetClient.NetLoginStep
    local l_handler = OnClosedHandlers

    if l_handler then
        l_handler(l_step, errCode)
    end
end

--[Comment]
--被踢下线 ErrorNotify和KickRoleNtf都会调到此有一份
--ErrorNotify 是各种原因登录失败，或者gs宕机，或者另外一端登录被踢下线等
--KickRoleNtf 是后台封号等各种原因被踢出
function OnKickout(errorCode, banInfo)
    local l_handler = OnKickoutHandlers
    if l_handler then
        l_handler(errorCode, banInfo)
    end
end

--切场景失败
function OnSwitchSceneFailed(errorCode)
    local l_handler = OnSwitchSceneFailedHandlers
    if l_handler then
        l_handler(errorCode)
    end
end

function OnLuaDoEnterScene(msg)
    local l_handler = OnLuaDoEnterSceneHandlers
    if l_handler then
        l_handler(msg)
    end
end