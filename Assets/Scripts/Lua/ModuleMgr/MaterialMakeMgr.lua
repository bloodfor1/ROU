---
--- Created by cmd(TonyChen).
--- DateTime: 2018/9/19 23:14
---
---@module ModuleMgr.MaterialMakeMgr
module("ModuleMgr.MaterialMakeMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获取材料制造成功事件
ON_MATERIAL_MAKE_SUCCESS = "ON_MATERIAL_MAKE_SUCCESS"
------------- END 事件相关  -----------------

--判断是否已解锁
--limitCode 解锁条件
function CheckIsUnlock(limitCode)
    return MPlayerInfo:GetCurrentSkillInfo(limitCode:get_Item(0)).lv >= limitCode:get_Item(1)
end

--确认是否制造
--costGroup  消耗材料的数据组
--makeNum  制造数量
function CheckCanMake(costGroup, makeNum)
    local l_isCanMake = true
    for i = 0, costGroup.Count - 1 do
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(costGroup:get_Item(i, 0))
        if l_curNum < costGroup:get_Item(i, 1) * makeNum then
            l_isCanMake = false
            break
        end
    end

    return l_isCanMake
end

--------------------------以下是服务器交互PRC------------------------------------------
--请求材料制造
function ReqMakeMaterial(makeItemId, makeNum, isBindFirst)
    local l_msgId = Network.Define.Rpc.MaterialsMechant
    ---@type MaterialsMechantArg
    local l_sendInfo = GetProtoBufSendTable("MaterialsMechantArg")
    l_sendInfo.wanted_item_id = makeItemId
    l_sendInfo.wanted_count = tonumber(tostring(makeNum))
    l_sendInfo.prefer_use_bind = isBindFirst
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的材料制造结果
function OnReqMakeMaterial(msg)
    ---@type MaterialsMechantRes
    local l_resInfo = ParseProtoBufToTable("MaterialsMechantRes", msg)

    --展示制造成功特效
    if l_resInfo.result.errorno == 0 then
        EventDispatcher:Dispatch(ON_MATERIAL_MAKE_SUCCESS)
        --如果产生的结果数量为0 提示玩家制造失败
        if l_resInfo.result.param and #l_resInfo.result.param > 0 and l_resInfo.result.param[1].value == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MATERIAL_MAKE_FAILED"))
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result.errorno))
    end
end






------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------





------------------------------PTC  END------------------------------------------
