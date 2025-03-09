---
--- Created by cmd(TonyChen).
--- DateTime: 2019/1/25 20:00
---
---@module ModuleMgr.BoliGroupMgr
module("ModuleMgr.BoliGroupMgr", package.seeall)

EPollyAwardType =
{
    Single = 0,
    PollyType = 1,
    Region = 2
}

-------------  事件相关  -----------------
--EventDispatcher = EventDispatcher.new()
--暂无事件
------------- END 事件相关  -----------------

--波利团数据类获取
local l_boliData = DataMgr:GetData("BoliGroupData")

--登录获取Boli数据
function OnSelectRoleNtf(info)
    --设置波利团发现记录
    l_boliData.SetBoliFindDatas(info.illustration.yahh.boli)
    l_boliData.SetBoliRegionAwardDatas(info.illustration.yahh.region_award_info)
    l_boliData.SetBoliTypeAwardDatas(info.illustration.yahh.type_award_info)
    GlobalEventBus:Dispatch(EventConst.Names.OnDiscoverPolly) 
end

function GetRegionData()
    return l_boliData.BoliRegionDatas
end

function GetTypeData()
    return l_boliData.BoliTypeDatas
end

--展示波利图鉴
function ShowBoliIllustration(regionId)
    if regionId == nil or regionId == 0 then
        UIMgr:ActiveUI(UI.CtrlNames.Polly)
    else    
        UIMgr:ActiveUI(UI.CtrlNames.Polly,{RegionId = regionId})
    end 
end

--initShowTypeId  初始展示的波利类型ID
-- function ShowBoliIllustration(initShowTypeId)
--     local l_openData = {
--         type = l_boliData.EUIOpenType.BoliIllustration,
--         index = l_initShowIndex,
--     }
--     --获取起始展示的索引
--     local l_initShowIndex = nil
--     if initShowTypeId then
--         for i = 1, #l_boliData.BoliFindDatas do
--             if l_boliData.BoliFindDatas[i].typeId == initShowTypeId then
--                 l_initShowIndex = i
--                 break
--             end
--         end
--     end
--     --打开UI
--     local l_openData = {
--         type = l_boliData.EUIOpenType.BoliIllustration,
--         index = l_initShowIndex,
--     }
--     UIMgr:ActiveUI(UI.CtrlNames.BoliIllustration, l_openData)   
-- end


function RequestGetPollyAward(type,id,count)
    local l_msgId = Network.Define.Rpc.GetPollyAward
    local l_sendInfo = GetProtoBufSendTable("GetBoliAwardArg")
    l_sendInfo.type = type
    l_sendInfo.id = id 
    l_sendInfo.count = count
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end


function OnModifyPollyAward(msg,isNew)
    local l_info =  ParseProtoBufToTable("GetBoliAwardRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    local l_type = l_info.type
    local l_id = l_info.id
    local l_count = l_info.count
    if l_type == EPollyAwardType.Single then
        l_boliData.UpdatePollyAwardSingle(l_id)
        GlobalEventBus:Dispatch(EventConst.Names.OnDiscoverPolly) 
    elseif l_type == EPollyAwardType.PollyType then
        l_boliData.UpdatePollyAwardType(l_id,l_count,isNew)
        GlobalEventBus:Dispatch(EventConst.Names.OnDiscoverPolly) 
        GlobalEventBus:Dispatch(EventConst.Names.OnModifyPollyTypeAward,l_id) 
    elseif l_type == EPollyAwardType.Region then
        l_boliData.UpdatePollyAwardRegion(l_id,l_count,isNew)
        GlobalEventBus:Dispatch(EventConst.Names.OnModifyPollyRegionAward,l_id) 
    end
end

---------------------------以下是服务器推送 PTC------------------------------------

--接收找到波利的消息推送
function OnFindBoliNtf(msg)
    ---@type BoliInfo
    local l_info = ParseProtoBufToTable("BoliInfo", msg)

    --维护本地缓存数据
    local l_row = TableUtil.GetElfTable().GetRowByID(l_info.id)
    if l_row then
        l_boliData.UpdateBoliRegionDatas(l_info)
        l_boliData.UpdateBoliTypeDatas(l_info,l_row.ElfTypeID)

        --展示发现波利的界面
        --打开UI
        local l_openData = {
            type = l_boliData.EUIOpenType.BoliFind,
            boliInfo = l_info,
            boliId = l_info.id,
        }
        UIMgr:ActiveUI(UI.CtrlNames.BoliFind, l_openData)
    end
    GlobalEventBus:Dispatch(EventConst.Names.OnDiscoverPolly) 
end
------------------------------PTC  END------------------------------------------
---------------------红点-------------------------
function CheckRedSignPollyType()
    for k,v in pairs(l_boliData.BoliTypeDatas) do
        for x,y in pairs(v.awards) do
            if y.finish and not y.gotAward then
                return 1
            end
        end
    end
    return 0
end

function CheckRedSignSinglePollyAward()
    for k,v in pairs(l_boliData.BoliRegionDatas) do
        local l_pollys = v.unlockPolly
        for x,y in pairs(l_pollys) do
            if not y.gotAward then
                return 1
            end
        end
    end
    return 0
end

function CheckRedSignRegionAward()
    for k,v in pairs(l_boliData.BoliRegionDatas) do
        local l_awards = v.awards
        for x,y in pairs(l_awards) do
            if y.finish and not y.gotAward then
                return 1
            end
        end
    end
    return 0
end

--------------------------------------------------
