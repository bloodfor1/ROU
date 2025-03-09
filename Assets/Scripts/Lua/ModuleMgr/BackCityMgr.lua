module("ModuleMgr.BackCityMgr", package.seeall)

-- 取消回城
function CancelBackCity()
    local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")

    ---@type RecallOperateArg
    local l_sendInfo = GetProtoBufSendTable("RecallOperateArg")
    l_sendInfo.auto_recall = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnBlessOut)
    l_sendInfo.five_recall = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnFive)
    l_sendInfo.cancle_recall = true
    Network.Handler.SendRpc(Network.Define.Rpc.RecallOperate, l_sendInfo)
end

function SetAutoRecallOnBlessOut(isOn)
    local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")

    ---@type RecallOperateArg
    local l_sendInfo = GetProtoBufSendTable("RecallOperateArg")
    l_sendInfo.auto_recall = isOn
    l_sendInfo.five_recall = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnFive)
    l_sendInfo.cancle_recall = false
    Network.Handler.SendRpc(Network.Define.Rpc.RecallOperate, l_sendInfo)
end

function SetAutoRecallOnFive(isOn)
    local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")

    ---@type RecallOperateArg
    local l_sendInfo = GetProtoBufSendTable("RecallOperateArg")
    l_sendInfo.auto_recall = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnBlessOut)
    l_sendInfo.five_recall = isOn
    l_sendInfo.cancle_recall = false
    Network.Handler.SendRpc(Network.Define.Rpc.RecallOperate, l_sendInfo)
end

function OnRecallOperate(msg, arg)
    local l_info = ParseProtoBufToTable("RecallOperateArg", msg)
end

function OnRoleRecallNtf(msg)
    local l_info = ParseProtoBufToTable("RoleRecallData", msg)

    UIMgr:ActiveUI(UI.CtrlNames.BackCityOffer, {reason = l_info.reason, leftTime = l_info.left_time})
end

return ModuleMgr.BackCityMgr