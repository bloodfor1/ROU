---
--- Created by cmd(TonyChen) detach from GuildMgr. 
--- DateTime: 2019/02/25 16:37
---
---@module ModuleMgr.GuildBuildMgr
module("ModuleMgr.GuildBuildMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获得公会建筑信息新数据后事件
ON_GET_NEW_GUILD_BUILD_INFO = "ON_GET_NEW_GUILD_BUILD_INFO"
--公会建筑升级完成后事件
ON_GUILD_BUILD_UPGRADING_OVER = "ON_GUILD_BUILD_UPGRADING_OVER"
--公会建设剩余时间确认事件
ON_GUILD_BUILD_TIME_CHECK = "ON_GUILD_BUILD_TIME_CHECK"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")


--打开参与建设界面
--buildActiveId 本次建设的编号升级表ID  由超链接打开需要对比
function OpenGuildAttendBuildPanel(buildActiveId)
    ReqGuildBuildMsg(function()
        if DataMgr:GetData("GuildData").selfGuildMsg.hasBuilt then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_ATTENTED_BUILD"))
            return
        end
        --找到正在升级的建筑
        local l_buildInfo = nil
        for i=1,#l_guildData.guildBuildInfo do
            if l_guildData.guildBuildInfo[i].is_upgrading then
                l_buildInfo = l_guildData.guildBuildInfo[i]
                break
            end
        end
        --如果有正在升级的建筑 切彼此对应则打开 参与建设界面
        if l_buildInfo and (l_buildInfo.id * 100 + l_buildInfo.level) == buildActiveId then
            EventDispatcher:Dispatch(ON_GUILD_BUILD_TIME_CHECK, l_buildInfo.upgrade_left_time)  --主角面时间更新
            --开启建设选择界面
            local l_openData = {
                type = l_guildData.EUIOpenType.GuildConstruction,
                buildInfo = l_buildInfo
            }
            UIMgr:ActiveUI(UI.CtrlNames.GuildConstruction, l_openData)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILD_ACTIVE_IS_OVER"))
        end
    end)
end

--获取剩余建设时间
function GetBuildLastTimeStr(time)
    local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(time)
    --秒数不为0 则补1分钟
    if l_second > 0 then l_minuite = l_minuite + 1 end
    if l_minuite >= 60 then
        l_minuite = 0
        l_hour = l_hour + 1
    end
    if l_hour >= 24 then
        l_hour = 0
        l_day = l_day + 1
    end
    return StringEx.Format(Lang("TIMESHOW_D_H_M"), tostring(l_day), tostring(l_hour), tostring(l_minuite))
end


--------------------------以下是服务器交互PRC------------------------------------------

--请求获取公会建筑信息
function ReqGuildBuildMsg(callback)
    if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        local l_msgId = Network.Define.Rpc.GuildGetBuildingInfo
        ---@type GuildGetBuildingInfoArg
        local l_sendInfo = GetProtoBufSendTable("GuildGetBuildingInfoArg")
        Network.Handler.SendRpc(l_msgId, l_sendInfo, callback)  --此处将callback作为customData传入
    end
end

--接受服务器返回的公会建筑信息
function OnReqGuildBuildMsg(msg, arg, callback)  --callback实际为customData
    ---@type GuildGetBuildingInfoRes
    local l_info = ParseProtoBufToTable("GuildGetBuildingInfoRes", msg)
    if l_info.result == 0 then
        l_guildData.guildBuildInfo = l_info.buildings
        l_guildData.guildBaseInfo.cur_money = l_info.cur_money
        l_guildData.selfGuildMsg.hasBuilt = l_info.self_had_built
        --更新华丽水晶1级提示红点
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GuildCrystalOneLv)
        --事件派发
        EventDispatcher:Dispatch(ON_GET_NEW_GUILD_BUILD_INFO)
        if callback then
            callback()
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end

end

--请求公会建筑升级
--buildId  建筑Id
function ReqGuildBuildUpgrade(buildId)
    local l_msgId = Network.Define.Rpc.GuildUpBuildingLevel
    ---@type GuildUpBuildingLevelArg
    local l_sendInfo = GetProtoBufSendTable("GuildUpBuildingLevelArg")
    l_sendInfo.building_id = buildId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器返回的请求公会建筑升级结果
function OnReqGuildBuildUpgrade(msg, arg)
    ---@type GuildUpBuildingLevelRes
    local l_info = ParseProtoBufToTable("GuildUpBuildingLevelRes", msg)
    if l_info.result.errorno == 0  then
        --信息同步由PTC完成
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result.errorno))
    end
end

--请求物资捐献
function ReqMaterialDonate(buildId)
    local l_msgId = Network.Define.Rpc.GuildDonateMaterials
    ---@type GuildDonateMaterialsArg
    local l_sendInfo = GetProtoBufSendTable("GuildDonateMaterialsArg")
    l_sendInfo.building_id = buildId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器返回的请求物资捐献结果
function OnReqMaterialDonate(msg)
    ---@type GuildDonateMaterialsRes
    local l_info = ParseProtoBufToTable("GuildDonateMaterialsRes", msg)
    if l_info.result == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DONATE_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--请求财物捐献
function ReqDiamondContribute(buildId)
    local l_msgId = Network.Define.Rpc.GuildDonateMoney
    ---@type GuildDonateMoneyArg
    local l_sendInfo = GetProtoBufSendTable("GuildDonateMoneyArg")
    l_sendInfo.building_id = buildId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接受服务器返回的请求财物捐献结果
function OnReqDiamondContribute(msg)
    ---@type GuildDonateMoneyRes
    local l_info = ParseProtoBufToTable("GuildDonateMoneyRes", msg)
    if l_info.result == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CONTRIBUTE_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end



------------------------------PRC  END------------------------------------------

---------------------------以下是单项协议 PTC------------------------------------

--公会建筑升级完成推送
function OnGuildBuildUpgradeCompletedNotify(msg)
    ---@type GuildUpgradeNotifyData
    local l_info = ParseProtoBufToTable("GuildUpgradeNotifyData", msg)
    local l_buildInfo = l_info.buildings
    for i = 1, #l_guildData.guildBuildInfo do
        if l_guildData.guildBuildInfo[i].id == l_buildInfo.id then
            l_guildData.guildBuildInfo[i].level = l_buildInfo.level
            l_guildData.guildBuildInfo[i].is_upgrading = l_buildInfo.is_upgrading
            l_guildData.guildBuildInfo[i].upgrade_left_time = l_buildInfo.upgrade_left_time
            break
        end
    end
    --更新华丽水晶1级提示红点
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GuildCrystalOneLv)
    --事件派发
    EventDispatcher:Dispatch(ON_GUILD_BUILD_UPGRADING_OVER)
    EventDispatcher:Dispatch(ON_GET_NEW_GUILD_BUILD_INFO)
end

------------------------------PTC  END------------------------------------------

