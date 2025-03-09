-- 附魔继承网络模块
---@module ModuleMgr.EnchantInheritNetMgr
module("ModuleMgr.EnchantInheritNetMgr", package.seeall)

local l_eventMgr = MgrProxy:GetGameEventMgr()

-- 上行请求
function ReqEnchantInherit(equipUID, stoneUID)
    if nil == equipUID or nil == stoneUID then
        logError("[EnchantInherit] req contains nil param, plis check")
        return
    end

    local l_msgId = Network.Define.Rpc.EquipEnchantInherit
    ---@type EquipEnchantInheritArg
    local l_sendInfo = GetProtoBufSendTable("EquipEnchantInheritArg")
    l_sendInfo.item_from_uid = stoneUID
    l_sendInfo.item_to_uid = equipUID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 服务器回报
function RecvEnchantInherit(msg)
    ---@type EquipEnchantInheritRes
    local l_info = ParseProtoBufToTable("EquipEnchantInheritRes", msg)
    local l_errorCode = l_info.result

    if 0 == l_errorCode then
        l_eventMgr.RaiseEvent(l_eventMgr.OnEnchantInheritConfirmed)
        return
    end

    local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

return ModuleMgr.EnchantInheritNetMgr