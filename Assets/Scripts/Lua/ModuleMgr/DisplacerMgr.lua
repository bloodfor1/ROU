---
--- Created by cmd(TonyChen).
--- DateTime: 2018/9/25 01:01
---
---@module ModuleMgr.DisplacerMgr
module("ModuleMgr.DisplacerMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--置换器制造成功的事件
ON_DISPLACER_MAKE_SUCCESS = "ON_DISPLACER_MAKE_SUCCESS"
--置换器使用成功的事件
ON_DISPLACER_USE_SUCCESS = "ON_DISPLACER_USE_SUCCESS"
------------- END 事件相关  -----------------

--------------------------以下是服务器交互PRC------------------------------------------
--请求置换器制造
--makeId  制造项ID
--indexChoose1  可选材料1索引
--isUseChoose2  是否使用可选材料2
function ReqDisplacerMake(makeId, indexChoose1, isUseChoose2)
    local l_msgId = Network.Define.Rpc.MakeDevice
    ---@type MakeDeviceArg
    local l_sendInfo = GetProtoBufSendTable("MakeDeviceArg")
    l_sendInfo.make_id = makeId
    l_sendInfo.con1_index = indexChoose1
    l_sendInfo.con2_index = isUseChoose2
    l_sendInfo.is_blind_first = false
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的置换器制造结果
function OnReqDisplacerMake(msg)
    ---@type MakeDeviceRes
    local l_resInfo = ParseProtoBufToTable("MakeDeviceRes", msg)

    --展示制造成功特效
    if l_resInfo.result.errorno == 0 then
        EventDispatcher:Dispatch(ON_DISPLACER_MAKE_SUCCESS)
        --如果产生的结果数量为0 提示玩家制造失败
        if l_resInfo.result.param and #l_resInfo.result.param > 0 and l_resInfo.result.param[1].value == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MATERIAL_MAKE_FAILED"))
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result.errorno))
    end
end

--请求使用置换器
--equipUID  使用置换器的装备UID
--displacerUID  使用的置换器UID
function ReqUseDisplacer(equipUID, displacerUID)
    local l_msgId = Network.Define.Rpc.UseDevice
    ---@type UseDeviceArg
    local l_sendInfo = GetProtoBufSendTable("UseDeviceArg")
    l_sendInfo.device_uid = tostring(displacerUID)
    l_sendInfo.equip_uid = tostring(equipUID)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的使用置换器的结果
function OnReqUseDisplacer(msg)
    ---@type UseDeviceRes
    local l_resInfo = ParseProtoBufToTable("UseDeviceRes", msg)

    --展示制造成功特效
    if l_resInfo.result == 0 then
        EventDispatcher:Dispatch(ON_DISPLACER_USE_SUCCESS)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end