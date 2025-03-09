--lua model
---@module ModuleMgr.GuildMatchMgr
module("ModuleMgr.GuildMatchMgr", package.seeall)
--lua model end

EventDispatcher = EventDispatcher.new()

local MsgId = "todo"
---@type ModuleData.GuildMatchData
local l_guildMatchData = DataMgr:GetData("GuildMatchData")
--lua custom scripts

function IsActivityOpend()

    local l_beginTime, l_endTime = 0, 0
    local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(l_taskMgr.g_ActivityType.activity_GuildMatch)
    if sdata.StartTime.Count > 0 then
        l_beginTime = l_taskMgr.GetDayTimestamp(sdata.TimePass[0][0])
        l_endTime = l_taskMgr.GetDayTimestamp(sdata.TimePass[0][1])
    end
    local l_nowTime = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
    if l_nowTime >= l_beginTime and l_nowTime <= l_endTime then
        return true
    end
    return false

end

-- 离开战斗
function LeaveFight()

    local l_watchWarData = DataMgr:GetData("WatchWarData")
    local uHeartTable = l_watchWarData.PlayerLife
    if uHeartTable then
        for k, v in pairs(uHeartTable) do
            MgrMgr:GetMgr("DungeonMgr").HideLifeHUD(v.first)
        end
        l_watchWarData.PlayerLife = nil
    end

end

function GetGuildFlowers(type, count)
    local l_msgId = Network.Define.Rpc.GetGuildFlowers
    ---@type CommandScriptInfo
    local l_sendInfo = GetProtoBufSendTable("GetGuildFlowersArg")
    l_sendInfo.type = type
    l_sendInfo.flowers_count = count
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetGuildFlowers(msg)
    ---@type GetGuildFlowersRes
    local l_info = ParseProtoBufToTable("GetGuildFlowersRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

function GuildBattleTeamApply(type)
    local l_msgId = Network.Define.Rpc.GuildBattleTeamApply
    ---@type GuildBattleTeamApplyArg
    local l_sendInfo = GetProtoBufSendTable("GuildBattleTeamApplyArg")
    l_sendInfo.type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGuildBattleTeamApply(msg)
    ---@type GuildBattleTeamApplyRes
    local l_info = ParseProtoBufToTable("GuildBattleTeamApplyRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_GUILD_ROLE_IS_CANDIDATED then
            local content = Common.Utils.Lang("GUILD_MATCH_RE_CONTENT")
            CommonUI.Dialog.ShowYesNoDlg(true, nil, content, function()
                GuildBattleTeamReApply()
            end, nil, nil, 0)
        elseif l_info.result == ErrorCode.ERR_GUILD_IN_TIME_NOT_ENOUGH then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.time_err_role_name, l_info.time))
        elseif l_info.result == ErrorCode.ERR_GUILD_MEMBER_NOT_EXIST then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.guild_err_role_name))
        elseif l_info.result == ErrorCode.ERR_GUILD_MATCH_SYSTEM_NOT_OPEN then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.guild_err_role_name, l_info.time))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    else
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MATCH_SUCCESS"))
    end
end

function GuildBattleTeamReApply()
    local l_msgId = Network.Define.Rpc.GuildBattleTeamReApply
    ---@type GuildBattleTeamReApplyArg
    local l_sendInfo = GetProtoBufSendTable("GuildBattleTeamReApplyArg")
    l_sendInfo.type = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGuildBattleTeamReApply(msg)
    ---@type GuildBattleTeamReApplyRes
    local l_info = ParseProtoBufToTable("GuildBattleTeamReApplyRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_GUILD_IN_TIME_NOT_ENOUGH then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.time_err_role_name, l_info.time))
        elseif l_info.result == ErrorCode.ERR_GUILD_MEMBER_NOT_EXIST then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.guild_err_role_name))
        elseif l_info.result == ErrorCode.ERR_GUILD_MATCH_SYSTEM_NOT_OPEN then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.result), l_info.guild_err_role_name, l_info.time))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    end
end

function GetGuildBattleMgrTeamInfo()
    local l_msgId = Network.Define.Rpc.GetGuildBattleMgrTeamInfo
    ---@type GetGuildBattleMgrTeamInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildBattleMgrTeamInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetGuildBattleMgrTeamInfo(msg)
    ---@type GetGuildBattleMgrTeamInfoRes
    local l_info = ParseProtoBufToTable("GetGuildBattleMgrTeamInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_guildMatchData.SetMgrTeamInfo(l_info.team_info)
        UIMgr:ActiveUI(UI.CtrlNames.Guildteammanage)
    end
end

function RefreshGuildMatchTeamInfoNtf(msg)
    ---@type GetGuildBattleTeamInfoRes
    local l_info = ParseProtoBufToTable("GetGuildBattleTeamInfoRes", msg)
    l_guildMatchData.SetAllBattleTeam(l_info.team_info)
    EventDispatcher:Dispatch(l_guildMatchData.ON_REFRESH_TEAM_SEL)     --抛出选择界面更新事件
end

function GetGuildBattleTeamInfo(type)
    local l_msgId = Network.Define.Rpc.GetGuildBattleTeamInfo
    ---@type GetGuildBattleTeamInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildBattleTeamInfoArg")
    l_sendInfo.type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetGuildBattleTeamInfo(msg, arg)
    ---@type GetGuildBattleTeamInfoRes
    local l_info = ParseProtoBufToTable("GetGuildBattleTeamInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_guildMatchData.SetAllBattleTeam(l_info.team_info)
        EventDispatcher:Dispatch(l_guildMatchData.ON_REFRESH_TEAM_SEL)     --抛出选择界面更新事件
    end
end

function ChangeGuildBattleTeam(teamData)
    local l_msgId = Network.Define.Rpc.ChangeGuildBattleTeam
    ---@type ChangeGuildBattleTeamArg
    local l_sendInfo = GetProtoBufSendTable("ChangeGuildBattleTeamArg")
    l_sendInfo.battle_team = teamData
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnChangeGuildBattleTeam(msg)
    ---@type ChangeGuildBattleTeamRes
    local l_info = ParseProtoBufToTable("ChangeGuildBattleTeamRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_MATCH_TEAMS_SET"))
end

function GuildMatchConvene()
    local l_msgId = Network.Define.Rpc.GuildMatchConvene
    ---@type GuildMatchConveneArg
    local l_sendInfo = GetProtoBufSendTable("GuildMatchConveneArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGuildMatchConvene()
    ---@type GuildMatchConveneRes
    local l_info = ParseProtoBufToTable("GuildMatchConveneRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    EventDispatcher:Dispatch(l_guildMatchData.ON_REFRESH_TEAM_CONVENE)
end

function OnRefreshGuildBattrleMgrTeamInfoNtf(msg)
    ---@type MgrTeamInfo
    local l_info = ParseProtoBufToTable("MgrTeamInfo", msg)
    l_guildMatchData.SetMgrTeamInfo(l_info.team_info)
    EventDispatcher:Dispatch(l_guildMatchData.ON_REFRESH_TEAM_MGR)     --抛出申请界面更新事件
end

function OnGuildTeamCache(msg)
    ---@type TeamCacheInfo
    local l_info = ParseProtoBufToTable("TeamCacheInfo", msg)
    l_guildMatchData.SetTeamCache(l_info)
    EventDispatcher:Dispatch(l_guildMatchData.ON_REFRESH_TEAM_CACHE)
end

function OnGuildBattleResultNtf(msg)
    ---@type BattleResultInfo
    local l_info = ParseProtoBufToTable("BattleResultInfo", msg)
    l_guildMatchData.SetCampInfo(l_info.camp1, l_info.camp2)
end

function OnEnterGuildMatchWaitingRoomRequest(msg)
    ---@type EnterGuildMatchWaitingRoomRequestRes
    local l_resInfo = ParseProtoBufToTable("EnterGuildMatchWaitingRoomRequestRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end
end

function OnGuildMatchBattleTeamApplyResultNtf()
    ---@type EnterGuildMatchWaitingRoomRequestRes
    local l_resInfo = ParseProtoBufToTable("EnterGuildMatchWaitingRoomRequestRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    else
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MATCH_SUCCESS"))
    end
end

function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    local player = MEntityMgr.PlayerEntity
    if not player then
        return
    end
    local ResultInfo = {
        player = {},
        other = {},
        statistics = {},
        score = {
        },
        attrs = l_info.attrs,
        round = l_info.pvp.round_id,
        --floor = l_info.guild_match_statistics.floor,
        guildInfo = {
        },
    }
    local l_guildInfo = {
        [1] = {
            name = nil,
            icon = nil,
        },
        [2] = {
            name = nil,
            icon = nil,
        },
    }
    local guildBrief = l_info.guild_match_statistics.guild_brief
    for i = 1, 2 do
        l_guildInfo[tonumber(guildBrief[i].camp_id)].name = guildBrief[i].guild_name
        l_guildInfo[tonumber(guildBrief[i].camp_id)].icon = guildBrief[i].icon_id
    end
    ResultInfo.status = l_info.status

    local l_playerId = tostring(player.UID)
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        l_playerId = tostring(MPlayerInfo.WatchFocusPlayerId)
    end

    local playerCamp, otherCamp
    local isPlayer = array.find(l_info.pvp.camp1.role_ids, function(v)
        return tostring(v.value) == l_playerId
    end)
    if isPlayer then
        playerCamp, otherCamp = l_info.pvp.camp1, l_info.pvp.camp2
        ResultInfo.score[1], ResultInfo.score[2] = l_info.guild_match_statistics.camp1_remain_points, l_info.guild_match_statistics.camp2_remain_points
        ResultInfo.guildInfo[1], ResultInfo.guildInfo[2] = l_guildInfo[1], l_guildInfo[2]
    else
        playerCamp, otherCamp = l_info.pvp.camp2, l_info.pvp.camp1
        ResultInfo.score[2], ResultInfo.score[1] = l_info.guild_match_statistics.camp1_remain_points, l_info.guild_match_statistics.camp2_remain_points
        ResultInfo.guildInfo[1], ResultInfo.guildInfo[2] = l_guildInfo[2], l_guildInfo[1]
    end
    local max_score = 0
    ---@type PvpMgr
    local pvpMgr = MgrMgr:GetMgr("PvpMgr")
    local mvpId, otherMvpId
    for _, v in ipairs(playerCamp.role_ids) do
        local l_kill, l_help, l_score, l_beKill = pvpMgr.GeneratePvpCountersInfo(v.value, playerCamp.role_infos)
        ResultInfo.player[v.value] = {
            kill = l_kill,
            help = l_help,
            score = l_score,
            beKill = l_beKill,
        }
        if l_score > max_score or not mvpId then
            mvpId = v.value
            max_score = l_score
        end
    end
    max_score = 0
    for _, v in ipairs(otherCamp.role_ids) do
        local l_kill, l_help, l_score, l_beKill = pvpMgr.GeneratePvpCountersInfo(v.value, otherCamp.role_infos)
        ResultInfo.other[v.value] = {
            kill = l_kill,
            help = l_help,
            score = l_score,
            beKill = l_beKill,
        }
        if l_score > max_score or not otherMvpId then
            otherMvpId = v.value
            max_score = l_score
        end
    end
    if l_info.guild_match_statistics then
        for i, v in ipairs(l_info.guild_match_statistics.role_life_counter) do
            ResultInfo.statistics[tostring(v.first)] = v.second or 0
        end
    end
    ResultInfo.mvpId = mvpId
    ResultInfo.otherMvpId = otherMvpId
    l_guildMatchData.ResultInfo = ResultInfo
    --UIMgr:HideTipsLayer()
    local dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    pvpMgr.ExcuteCameraTex(mvpId, dailyTaskMgr.g_ActivityType.activity_GuildMatch)
    DataMgr:GetData("WatchWarData").ClearFlowerNum()
end

function GetGuildBattleResult()
    local l_msgId = Network.Define.Rpc.GetGuildBattleResult
    ---@type GetGuildBattleResultArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildBattleResultArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetGuildBattleResult(msg)
    ---@type GetGuildBattleResultRes
    local l_info = ParseProtoBufToTable("GetGuildBattleResultRes", msg)
    l_guildMatchData.SetCampInfo(l_info.camp1, l_info.camp2)
    UIMgr:ActiveUI(UI.CtrlNames.GuildMatchSettlement)

end

function OnGuildMatchActivityNtf(msg)

    ---@type ActivityData
    local l_info = ParseProtoBufToTable("ActivityData", msg)
    if l_info.type == l_guildMatchData.ActivityType.MATCH then
        local l_activitySdata = TableUtil.GetDailyActivitiesTable().GetRowById(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatch)
        UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
            ctrl:StartLeftTimer(l_info.end_time, l_activitySdata.TextBeforeStartTime,
                    MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatch)
        end)
    elseif l_info.type == l_guildMatchData.ActivityType.WATCH then
        if l_info.end_time ~= 0 then
            l_guildMatchData.NowMatchRound = l_info.round
            UIMgr:ActiveUI(UI.CtrlNames.ArenaOffer, function(ctrl)
                ctrl:ShowContentWithoutCountdown(Lang("GUILD_MATCH_WATCH_OFFER", l_info.round),
                        MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatchWatch, true, Lang("WATCH_NOW"))
            end)
        else
            GlobalEventBus:Dispatch(EventConst.Names.ARENA_CLOSE_OFFER,
                    MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatchWatch)
        end
    end

end
--lua custom scripts end
return ModuleMgr.GuildMatchMgr