---
--- Created by cmd(TonyChen).
--- DateTime: 2018/9/20 23:20
---
---@module ModuleMgr.RefitTrolleyMgr
module("ModuleMgr.RefitTrolleyMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--特殊装备选择使用后事件
ON_USE_TROLLEY = "ON_USE_TROLLEY"
------------- END 事件相关  -----------------

--获取特殊装备商店类型信息 （大嘴鸟/猎鹰/手推车）
function GetRefitShopTypeInfo()

    local l_typeInfo = {}
    --shopName 商店名
    --equipPos 特殊装备对应放入装备位置

    local l_jobType = math.floor(MPlayerInfo.ProfessionId / 1000)
    if l_jobType == 2 then
        --战士系 大嘴鸟
        l_typeInfo.shopName = Lang("TOUCAN_SHOP")
        l_typeInfo.equipPos = EquipPos.BATTLE_HORSE + 1
    elseif l_jobType == 7 then
        --猎人系 猎鹰
        l_typeInfo.shopName = Lang("FALCON_SHOP")
        l_typeInfo.equipPos = EquipPos.BATTLE_BIRD + 1
    elseif l_jobType == 6 then
        --商人系 手推车
        l_typeInfo.shopName = Lang("TROLLRY_SHOP")
        l_typeInfo.equipPos = EquipPos.TROLLEY + 1
    else
        l_typeInfo.shopName = Lang("TROLLRY_SHOP")
        l_typeInfo.equipPos = EquipPos.TROLLEY + 1
    end

    return l_typeInfo
end


--------------------------以下是服务器交互PRC------------------------------------------

--请求使用选中的手推车
function ReqUseTrolley(trolleyId, profession)
    local l_msgId = Network.Define.Rpc.ChangeTrolley
    ---@type ChangeTrolleyArg
    local l_sendInfo = GetProtoBufSendTable("ChangeTrolleyArg")
    l_sendInfo.trolley_id = trolleyId
    l_sendInfo.profession_id = profession
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器返回的手推车使用结果
function OnReqUseTrolley(msg, arg)
    ---@type ChangeTrolleyRes
    local l_info = ParseProtoBufToTable("ChangeTrolleyRes", msg)
    if l_info.result == 0 then
        --事件回调
        EventDispatcher:Dispatch(ON_USE_TROLLEY, arg.trolley_id)
    else
        --弹对应错误tip
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

------------------------------PRC  END------------------------------------------

