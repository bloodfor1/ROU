---@module ModuleMgr.GuildHuntMgr
module("ModuleMgr.GuildHuntMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--公会狩猎相关信息获取后事件
ON_GET_GUILD_HUNT_INFO = "ON_GET_GUILD_HUNT_INFO"
--活动界面显示事件
ON_GET_GUILD_HUNT_INFO_RSP = "ON_GET_GUILD_HUNT_INFO_RSP"
------------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")

--前往参加公会狩猎
function GoToAttendGuildHunt(npcId)

    if npcId then
        MgrMgr:GetMgr("GuildMgr").GuildFindPath_Pos(l_guildData.huntNpcLoc[npcId])
    else
        MgrMgr:GetMgr("GuildMgr").GuildFindPath_FuncId(DataMgr:GetData("GuildData").EGuildFunction.GuildHunt)
    end

end

--请求进入公会狩猎的副本 CS调用
function ReqEnterGuildHuntDungeon(type, command, args)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    --判断奖励次数
    if l_guildData.guildHuntInfo.usedTimes_reward >= l_guildData.guildHuntInfo.maxTimes_reward then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("YOUR_AWARD_TIMES_IS_OVER"))
        return
    end
    --根据难度进入副本
    local l_difficultType = tonumber(args[1].Value)
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        if l_guildData.guildHuntInfo.dungeonList[i].type == l_difficultType then
            MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_guildData.guildHuntInfo.dungeonList[i].id, 0, 0)
            return
        end
    end
    logError("@陈阳 请求进入公会狩猎的副本难度配置有误 l_difficultType = " .. tostring(l_difficultType))
    logError("对应副本列表数量 = " .. tostring(#l_guildData.guildHuntInfo.dungeonList))
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        logError("存在的副本难度类型 difficultType = " .. tostring(l_guildData.guildHuntInfo.dungeonList[i].type))
    end
end

--获取公会狩猎传送门的数据 CS获取
function GetGuildHuntPortalInfo(luaType, portalId, portalUID, portalEntity)
    --没有就新建
    if not l_guildData.guildHuntPortalIds then
        l_guildData.guildHuntPortalIds = {}
    end
    --记录传送门UID
    l_guildData.guildHuntPortalIds[portalId] = portalUID
    --更新HUD数据
    local l_portalIdKeys = { "HuntingEasyNpcID", "HuntingNormalNpcID", "HuntingHardNpcID" }
    for i = 1, #l_portalIdKeys do
        local l_portalIdStr = TableUtil.GetGuildActivityTable().GetRowBySetting(l_portalIdKeys[i]).Value
        local l_portalIdGroup = string.ro_split(l_portalIdStr, "=")
        for j = 1, #l_portalIdGroup do
            if portalId == tonumber(l_portalIdGroup[j]) then
                for k = 1, #l_guildData.guildHuntInfo.dungeonList do
                    local l_temp = l_guildData.guildHuntInfo.dungeonList[k]
                    if l_temp.type == i - 1 then
                        SetGuildHuntPortalHUD(l_temp, portalId, portalEntity)
                        return
                    end
                end
            end
        end
    end
end

--更新公会狩猎传送门HUD
function UpdateGuildHuntPortalHUD()
    --没有就新建
    if not l_guildData.guildHuntPortalIds then
        l_guildData.guildHuntPortalIds = {}
    end

    local l_portalIdKey = "HuntingEasyNpcID"
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        local l_temp = l_guildData.guildHuntInfo.dungeonList[i]
        --获取传送门ID组对应key
        if l_temp.type == l_guildData.EGuildHuntDungeonType.Easy then
            l_portalIdKey = "HuntingEasyNpcID"
        elseif l_temp.type == l_guildData.EGuildHuntDungeonType.Normal then
            l_portalIdKey = "HuntingNormalNpcID"
        elseif l_temp.type == l_guildData.EGuildHuntDungeonType.Hard then
            l_portalIdKey = "HuntingHardNpcID"
        end
        --拆分ID字符串
        local l_portalIdStr = TableUtil.GetGuildActivityTable().GetRowBySetting(l_portalIdKey).Value
        local l_portalIdGroup = string.ro_split(l_portalIdStr, "=")
        for j = 1, #l_portalIdGroup do
            SetGuildHuntPortalHUD(l_temp, tonumber(l_portalIdGroup[j]))
        end
    end
end

--设置公会传送门HUD
function SetGuildHuntPortalHUD(dungeonsInfo, portalId, portalEntity)
    if l_guildData.guildHuntPortalIds[portalId] then
        local l_aimEntity = portalEntity or MEntityMgr:GetEntity(l_guildData.guildHuntPortalIds[portalId])
        if l_aimEntity then
            local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonsInfo.id)
            if not l_row then
                logError("服务器传回的公会狩猎副本ID错误 id=" .. tostring(dungeonsInfo.id))
                return
            end
            MEventMgr:LuaFireEvent(MEventType.MEvent_Guild_Hunt_Portal_Change,
                    l_aimEntity, dungeonsInfo.cur_count, dungeonsInfo.max_count, l_row.DungeonsName)
        else
            l_guildData.guildHuntPortalIds[portalId] = nil
        end
    end
end

function OpenGuildHuntInfo()
    if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_GUILD"))
    else
        UIMgr:ActiveUI(UI.CtrlNames.GuildHuntInfo)
    end
end

--确认公会狩猎任务目标是否已完成
function CheckGuildHuntAimIsCompleted()
    --如果狩猎副本列表为空 则没有活动 直接返回为未完成
    if #l_guildData.guildHuntInfo.dungeonList == 0 then
        return false
    end
    --数据记录申明
    local l_allBossNum = 0
    local l_curFinishNum = 0
    --遍历所有公会狩猎副本信息
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        local l_temp = l_guildData.guildHuntInfo.dungeonList[i]
        --计算进度总数
        if l_temp.max_count ~= -1 then
            l_allBossNum = l_allBossNum + l_temp.max_count
            l_curFinishNum = l_curFinishNum + l_temp.cur_count
        end
    end
    return l_curFinishNum >= l_allBossNum
end

function _getBagItemsByTid(tid)
    if GameEnum.ELuaBaseType.Number ~= type(tid) then
        logError("[MagicRecoverMachine] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

--使用道具
function TryUseItem(iid, propId)
    if propId ~= l_guildData.GUILD_HUNT_REDENVELOPE_ID then
        return false
    end

    local l_itemInfo = _getBagItemsByTid(propId)
    ReqUseRedEnvelope(iid, Lang(TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingRankRedEnvelopesText").Value,
            MPlayerInfo.Name, l_itemInfo[1].GuildRedPacketValue))
    return true
end

--判断BUFF条件，满足返回true
function BuffJudge(easyPassCount, itemUseCount)
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        if l_guildData.guildHuntInfo.dungeonList[i].type == l_guildData.EGuildHuntDungeonType.Easy then
            if l_guildData.guildHuntInfo.dungeonList[i].cur_count < easyPassCount then
                return false
            end
        end
    end

    if l_guildData.guildHuntInfo.seal < itemUseCount then
        return false
    end

    return true
end

--宝箱可以打开
function CheckReward()

    if not CheckGuildHuntAimIsCompleted() then
        --狩猎目标未完成，无法领取奖励
        return false
    elseif l_guildData.guildHuntInfo.usedTimes_reward == 0 then
        --你未参与此次狩猎，无法领取奖励
        return false
    elseif l_guildData.guildHuntInfo.isGetFinalReward then
        --已经领取过奖励
        return false
    end
    return true

end

--返回简单副本通过次数和碎片使用次数
function BuffGetCount()
    local l_passCount, l_sealCount = 0, l_guildData.guildHuntInfo.seal
    for i = 1, #l_guildData.guildHuntInfo.dungeonList do
        if l_guildData.guildHuntInfo.dungeonList[i].type == l_guildData.EGuildHuntDungeonType.Easy then
            l_passCount = l_guildData.guildHuntInfo.dungeonList[i].cur_count
        end
    end
    return l_passCount, l_sealCount
end

----------------------- RPC -------------------------------
--请求发送公会红包
function ReqUseRedEnvelope(uid, words)
    local l_msgId = Network.Define.Rpc.UseRedEnvelope
    ---@type UseRedEnvelopeArg
    local l_sendInfo = GetProtoBufSendTable("UseRedEnvelopeArg")
    l_sendInfo.uid = uid
    l_sendInfo.words = words
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取红包发送结果
function OnReqUseRedEnvelope(msg)
    ---@type UseRedEnvelopeRes
    local l_info = ParseProtoBufToTable("UseRedEnvelopeRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求获取公会狩猎寻找队友信息
function ReqGuildHuntFindTeamMate()
    local l_msgId = Network.Define.Rpc.GuildHuntFindTeamMate
    ---@type GuildHuntFindTeamMateArg
    local l_sendInfo = GetProtoBufSendTable("GuildHuntFindTeamMateArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取服务器返回的公会狩猎队友剩余次数相关的信息
function OnReqGuildHuntFindTeamMate(msg)
    ---@type GuildHuntFindTeamMateRes
    local l_info = ParseProtoBufToTable("GuildHuntFindTeamMateRes", msg)

    if l_info.error_code == 0 then
        --排行榜获取
        l_guildData.guildHuntInfo.friendList = {}
        for i = 1, #l_info.member_list do
            local l_temp = {}
            l_temp.member = l_info.member_list[i].member
            l_temp.score = l_info.member_list[i].score
            l_temp.remain = l_info.member_list[i].remain_count
            table.insert(l_guildData.guildHuntInfo.friendList, l_temp)
        end
        table.sort(l_guildData.guildHuntInfo.friendList, function(a, b)
            if a.member.base_level > b.member.base_level then
                return true
            elseif a.member.base_level == b.member.base_level and a.remain > b.remain then
                return true  --同成就
            elseif a.member.base_level == b.member.base_level and a.remain == b.remain then
                return MemberNameCompare(a, b)
            else
                return false
            end
        end)

        --通知界面刷新数据
        EventDispatcher:Dispatch(ON_GET_GUILD_HUNT_INFO)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

    EventDispatcher:Dispatch(ON_GET_GUILD_HUNT_INFO_RSP)

end

--请求获取公会狩猎的信息
function ReqGetGuildHuntInfo()
    local l_msgId = Network.Define.Rpc.GuildHuntGetInfo
    ---@type GuildHuntGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("GuildHuntGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取服务器返回的公会狩猎的信息
function OnReqGetGuildHuntInfo(msg)
    ---@type GuildHuntGetInfoRes
    local l_info = ParseProtoBufToTable("GuildHuntGetInfoRes", msg)

    if l_info.error_code == 0 then
        --数据设置
        l_guildData.SetGuildHuntInfo(l_info)
        --通知界面刷新数据
        EventDispatcher:Dispatch(ON_GET_GUILD_HUNT_INFO)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

    --如果冒险已经开启了 才拉取冒险信息
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk) then
        EventDispatcher:Dispatch(ON_GET_GUILD_HUNT_INFO_RSP)
    end

end

--请求开启公会狩猎活动
function ReqOpenHuntActivity()
    local l_msgId = Network.Define.Rpc.GuildHuntOpenRequest
    ---@type GuildHuntOpenRequestArg
    local l_sendInfo = GetProtoBufSendTable("GuildHuntOpenRequestArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的请求开启公会狩猎活动的结果
function OnReqOpenHuntActivity(msg)
    ---@type GuildHuntOpenRequestRes
    local l_info = ParseProtoBufToTable("GuildHuntOpenRequestRes", msg)

    if l_info.error_code == 0 then
        --不需要单独的提示 直接请求新数据刷新界面信息即可
        ReqGetGuildHuntInfo()
        ReqGuildHuntFindTeamMate()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求开启公会狩猎宝箱奖励
function ReqGetGuildHuntAwardBox()
    local l_msgId = Network.Define.Rpc.GuildHuntGetFinalReward
    ---@type GuildHuntGetFinalRewardArg
    local l_sendInfo = GetProtoBufSendTable("GuildHuntGetFinalRewardArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的请求开启狩猎宝箱的结果
function OnReqGetGuildHuntAwardBox(msg)
    ---@type GuildHuntGetFinalRewardRes
    local l_info = ParseProtoBufToTable("GuildHuntGetFinalRewardRes", msg)

    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        ReqGetGuildHuntInfo()
        ReqGuildHuntFindTeamMate()
    end
end

--------------------- end RPC -----------------------------

----------------------- PTC -------------------------------
--活动结束，进入领宝箱的阶段
function OnGuildHuntReward(msg)
    ---@type GuildHuntFinishNtfData
    local l_info = ParseProtoBufToTable("GuildHuntFinishNtfData", msg)
    if CheckReward() then
        MgrMgr:GetMgr("DailyTaskMgr").OnGuildHuntRewardNotify()
    end
end

--副本完成，但还未达到奖励上限
function OnGuildHuntResult(msg)
    ---@type NtfGuildHuntRewardData
    local l_info = ParseProtoBufToTable("NtfGuildHuntRewardData", msg)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILDHUNT_REWARD_INFO",
            TableUtil.GetGuildActivityTable().GetRowBySetting("HuntingAwardTimes").Value, l_info.times))
end

--接收服务器推送的公会狩猎灵魂碎片使用消息
function OnGuildHuntSealPieceCount(msg)
    ---@type GuildHuntSealPieceCountData
    local l_info = ParseProtoBufToTable("GuildHuntSealPieceCountData", msg)
    l_guildData.guildHuntInfo.seal = l_info.seal_piece_count
end

--接收服务器推送的公会狩猎活动开启消息
function OnGuildHuntOpenNotify(msg)
    ---@type GuildHuntOpenNotifyInfo
    local l_info = ParseProtoBufToTable("GuildHuntOpenNotifyInfo", msg)

    --请求具体信息
    ReqGetGuildHuntInfo()
    ReqGuildHuntFindTeamMate()
    --展示是否加入的提示
    UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
        ctrl:ShowContentWithoutCountdown(Lang("GUILD_HUNT_ACTIVITY_START_NOTIFY"),
                MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildHunt,
                false)
    end)

    MgrMgr:GetMgr("DailyTaskMgr").OnGuildHuntOpenNotify()
end

--接收公会狩猎进度更新消息
function OnGuildHuntDungeonUpdateNotify(msg)
    ---@type GuildHuntDungeonUpdateNotifyInfo
    local l_info = ParseProtoBufToTable("GuildHuntDungeonUpdateNotifyInfo", msg)

    for i = 1, #l_info.dungeon_list do
        for j = 1, #l_guildData.guildHuntInfo.dungeonList do
            if l_guildData.guildHuntInfo.dungeonList[j].type == l_info.dungeon_list[i].type then
                l_guildData.guildHuntInfo.dungeonList[j] = l_info.dungeon_list[i]
                break
            end
        end
    end

    --传送门HUD更新
    UpdateGuildHuntPortalHUD()

end

--------------------- end PTC -----------------------------

--成员姓名的排序对比
function MemberNameCompare(a, b)
    if a.member.name and b.member.name then
        if MLuaClientHelper.CompareStringByCurrentCulture(a.member.name, b.member.name) then
            return true
        end
        return false
    elseif a.member.name then
        return true
    else
        return false
    end
end

return GuildHuntMgr

