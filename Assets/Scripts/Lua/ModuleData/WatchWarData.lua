---@module ModuleData.WatchWarData
module("ModuleData.WatchWarData", package.seeall)

ESelectClassifyType = {
    Recommend = 1,
    Self = 2,
    UnDefined = 0,
}

SpectatorListRefreshInterval = nil --刷新间隔
SpectatorPageCap = nil --每页容量
SpectatorTotalCap = nil --总共容量
SpectatorHistoryCap = nil --历史容量
SpectatorRecommendationCap = nil --推荐容量
SpectatorKeywordMinLength = nil --查询关键字最低长度
SpectatorSearchResultCap = nil --查询结果容量
SpectatorInfoCondition = nil --被观战显示观战人数的触发数量
SpectatorTranslation = nil --黑幕配置
SpectatorMinUiAudience = nil --观战信息显示后，观众人数低于该人数时显示为该人数
SpectatorMaxDisplayNum = 0 -- 显示最大观战人数
SpectatorKeywordMaxLength = 0 -- 搜索关键字最大长度
--------------------------------------------------------------------------------观战相关变量定义
WatchDatas = {}           -- 观战列表信息
SearchDatas = nil         -- 观战搜索结果 = {}
RecordDatas = {}          -- 历史记录

AutoSearchTimeRecord = {}     -- 缓存每个类型上次查询时间
PlayerLife = {}               -- 玩家剩余生命
MainWatchRoomInfo = {}        -- 观战房间详细内容
BattleTeamInfo = {}           -- 记录战场对于与阵营关系

UnderBlackCurtainFadeIn = false       -- 当前是否有黑幕

SequenceUid = 0

ChatStatus = true

MemberWatchRecord = {}      -- 成员观战记录

local selectClassifyTypeID = nil

function Init()

    SpectatorListRefreshInterval = MGlobalConfig:GetInt("SpectatorListRefreshInterval")
    SpectatorPageCap = MGlobalConfig:GetInt("SpectatorPageCap")
    SpectatorTotalCap = MGlobalConfig:GetInt("SpectatorTotalCap")
    SpectatorHistoryCap = MGlobalConfig:GetInt("SpectatorHistoryCap")
    SpectatorRecommendationCap = MGlobalConfig:GetInt("SpectatorRecommendationCap")
    SpectatorKeywordMinLength = MGlobalConfig:GetInt("SpectatorKeywordMinLength")
    SpectatorSearchResultCap = MGlobalConfig:GetInt("SpectatorSearchResultCap")
    SpectatorInfoCondition = MGlobalConfig:GetInt("SpectatorInfoCondition")
    SpectatorTranslation = MGlobalConfig:GetSequenceOrVectorFloat("SpectatorSwitchCharTransitionTime")
    SpectatorMinUiAudience = MGlobalConfig:GetFloat("SpectatorMinUiAudience")
    MatchPointsPerPlayer = MGlobalConfig:GetInt("G_MatchPointsPerPlayer")
    SpectatorMaxDisplayNum = MGlobalConfig:GetInt("SpectatorMaxDisplayViews", 1)
    SpectatorKeywordMaxLength = MGlobalConfig:GetInt("SpectatorKeywordMaxLength", 7)

    ResetSelectClassifyTypeID()

    InitChatStatus()
end

function Logout()
    InitChatStatus()
end

function InitChatStatus()
    ChatStatus = true
    local l_record = Common.Serialization.LoadData("WatchChatStatus", MPlayerInfo.UID:tostring())
    if l_record and string.len(l_record) > 0 then
        ChatStatus = false
    end
end

function OnGetWatchRoomList(rooms, spectatorType)

    for i, v in ipairs(rooms) do
        local l_limitFlag = IsSpectatorUnderDelayLimit(v.dungeon_id, v.create_time)
        if not l_limitFlag then
            ParseWatchUnitInfoPb(v, WatchDatas, spectatorType)
        end
    end
end

-- 获取观战延迟
function GetSpectatorDelay(dungeonId)

    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId, true)
    if not l_dungeonRow then
        return false
    end
    local l_spectatorRow = TableUtil.GetSpectatorSettingsTable().GetRowByDungeonType(l_dungeonRow.DungeonsType, true)
    if not l_spectatorRow then
        return false
    end
    return true, l_spectatorRow.Delay

end

-- 观战是否还在延迟下
function IsSpectatorUnderDelayLimit(dungeonId, createTime)

    local l_noLimit, l_delay = GetSpectatorDelay(dungeonId)
    if l_noLimit then
        return (MLuaCommonHelper.Int(MServerTimeMgr.UtcSeconds) - MLuaCommonHelper.Int(createTime)) < l_delay
    else
        return true
    end

end

-- 辅助方法，解析WatchUnitInfo
function ParseWatchUnitInfoPb(unitInfo, container, spectatorType)

    if not unitInfo.room_uid or unitInfo.room_uid == 0 then
        return
    end

    -- 根据观战类型分类
    container[spectatorType] = container[spectatorType] or {}
    local l_index
    for i, v in ipairs(container[spectatorType]) do
        if v.room_uid == unitInfo.room_uid then
            l_index = i
            break
        end
    end
    -- 放到对应的队伍列表中
    if l_index then
        container[spectatorType][l_index] = unitInfo
    else
        table.insert(container[spectatorType], unitInfo)
    end

end

-- 辅助方法，解析WatchedRoleBrief
function ParseWatchedBriefInfo(briefInfo, container)

    local l_roleId = tostring(briefInfo.role_id)
    if not container[l_roleId] then
        return
    end

    if not briefInfo.is_in_dungeon then
        container[l_roleId] = nil
        return
    end

    local l_ret = container[l_roleId]
    l_ret.role_id = l_roleId
    l_ret.is_in_dungeon = briefInfo.is_in_dungeon
    l_ret.hp = briefInfo.hp
    l_ret.sp = briefInfo.sp
    l_ret.kill = briefInfo.kill
    l_ret.dead = briefInfo.dead
    l_ret.assist = briefInfo.assist

end

-- 辅助方法，解析WatchedRoleBoardInfo
function ParseWatchedRoleBoardInfo(roleInfo, container)

    local l_teamId = tostring(roleInfo.team_id)
    local l_roleId = tostring(roleInfo.role_id)
    -- 队伍与Role快速索引
    if not container.teamLinkInfos[l_teamId] then
        container.teamLinkInfos[l_teamId] = {}
        local l_default = int64.new(0)
        local l_guildId = l_default
        if roleInfo.avatar_info then
            l_guildId = roleInfo.avatar_info.guild_id or l_default
        end
        table.insert(container.teamInfoList, l_teamId)
        --logError("ParseWatchedRoleBoardInfo", l_teamId, l_guildId, ToString(roleInfo))
        table.insert(container.CaptainGuildId, l_guildId)
    end

    if not table.ro_contains(container.teamLinkInfos[l_teamId], l_roleId) then
        table.insert(container.teamLinkInfos[l_teamId], l_roleId)
    end

    container.role_infos[l_roleId] = {
        type = roleInfo.type,
        name = roleInfo.name,
        avatar_info = roleInfo.avatar_info,
        team_id = l_teamId,
        is_hit_outlook = roleInfo.is_hit_outlook,
    }

    -- ParseWatchedBriefInfo(roleInfo.brief, container.role_infos)
end

function SetDungeonBattleInfo(seqId, customData)

    SequenceUid = seqId
    BattleTeamInfo = {}
    if not customData or not customData.team then
        return
    end
    for i, v in ipairs(customData.team) do
        if #v.members > 0 then
            BattleTeamInfo[i] = v.members[1].uid
        else
            BattleTeamInfo[i] = 0
        end
    end

end

function OnDungeonWatchAllMemberStatusNtf(info)
    MainWatchRoomInfo = {
        room_uid = info.room_uid,
        dungeon_id = info.dungeon_id,
        beliked_times = info.beliked_times or 0,
        spectators_num = info.spectators_num or 0,
        create_time = info.create_time,
        camp1_sorce = 0, --info.camp1_socre or 0,
        camp2_socre = 0, --info.camp2_socre or 0,
        role_infos = {},
        teamLinkInfos = {},
        teamInfoList = {},
        CaptainGuildId = {},
    }
    for i, v in ipairs(info.role_infos) do
        ParseWatchedRoleBoardInfo(v, MainWatchRoomInfo)
    end
    if info.camp_flower and #info.camp_flower == 2 then
        if info.camp_flower[2].guild_id == DataMgr:GetData("GuildData").selfGuildMsg.id then
            MainWatchRoomInfo.camp1_flower = info.camp_flower[2].num
            MainWatchRoomInfo.camp2_flower = info.camp_flower[1].num
        else
            MainWatchRoomInfo.camp1_flower = info.camp_flower[1].num
            MainWatchRoomInfo.camp2_flower = info.camp_flower[2].num
        end
    end
end

function OnDungeonWatchBriefStatusNft(info)
    MainWatchRoomInfo = MainWatchRoomInfo or {}
    MainWatchRoomInfo.role_infos = MainWatchRoomInfo.role_infos or {}
    SetCampScore(info)
    local l_markNeedForceRebuild = false
    local l_markRemoveIds = nil
    for i, v in ipairs(info.role_infos) do
        if not v.is_in_dungeon and MainWatchRoomInfo.role_infos[v.role_id] then
            if l_markNeedForceRebuild == false then
                l_markNeedForceRebuild = true
                l_markRemoveIds = {}
            end
            l_markRemoveIds[v.role_id] = true
        end
        ParseWatchedBriefInfo(v, MainWatchRoomInfo.role_infos)
    end

    if l_markNeedForceRebuild then
        for teamId, roleIdList in pairs(MainWatchRoomInfo.teamLinkInfos) do
            for i = #roleIdList, 1, -1 do
                if l_markRemoveIds[roleIdList[i]] then
                    table.remove(roleIdList, i)
                end
            end
        end
        return true
    end

end
---@param l_info GuildMatchSyncRoleLifeData
function OnUpdateScore(l_info)
    --DataMgr:GetData("GuildMatchData").TimeStamp = l_info.dungeons_end_time
    --logYellow(l_info.dungeons_end_time)
    local _info = {}
    _info.camp1_id = l_info.camp1_guild_id
    _info.camp2_id = l_info.camp2_guild_id
    _info.camp1_score = l_info.camp1_score
    _info.camp2_score = l_info.camp2_score


    SetCampScore(_info)
end

function OnUpdateRoomWatchInfo(info)
    MainWatchRoomInfo = MainWatchRoomInfo or {}
    MainWatchRoomInfo.beliked_times = info.beliked_times
    MainWatchRoomInfo.spectators_num = info.spectators_num
    if info.camp_flower and #info.camp_flower == 2 then
        if DataMgr:GetData("GuildData").selfGuildMsg.id == info.camp_flower[2].guild_id then
            MainWatchRoomInfo.camp1_flower = info.camp_flower[2].num or 0
            MainWatchRoomInfo.camp2_flower = info.camp_flower[1].num or 0
        else
            MainWatchRoomInfo.camp1_flower = info.camp_flower[1].num or 0
            MainWatchRoomInfo.camp2_flower = info.camp_flower[2].num or 0
        end
    end
    MainWatchRoomInfo.round = info.round_id + 1
    MainWatchRoomInfo.HistoryCamp1 = {}
    MainWatchRoomInfo.HistoryCamp2 = {}
    if info.fight_history.pvp_result and #info.fight_history.pvp_result > 0 then
        for i = 1, 3 do
            table.insert(MainWatchRoomInfo.HistoryCamp1, info.fight_history.pvp_result[i].camp1_result)
            table.insert(MainWatchRoomInfo.HistoryCamp2, info.fight_history.pvp_result[i].camp2_result)
        end
    end
end

function OnEnterScene(info)
    if info.end_time ~= 0 then
        DataMgr:GetData("GuildMatchData").TimeStamp = info.end_time + tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchCountDownBeforeBattle").Value)
    end
    MainWatchRoomInfo.camp1_score = info.camp1_remain_points
    MainWatchRoomInfo.camp2_score = info.camp2_remain_points
    --MainWatchRoomInfo.camp1_flower = info.camp1_flower_num
    --MainWatchRoomInfo.camp2_flower = info.camp2_flower_num
    MainWatchRoomInfo.round = info.round_id + 1
    MainWatchRoomInfo.HistoryCamp1 = {}
    MainWatchRoomInfo.HistoryCamp2 = {}
    MainWatchRoomInfo.hasGuildMatchInfo = false
    if info.fight_history.pvp_result then
        for i = 1, table.maxn(info.fight_history.pvp_result) do
            MainWatchRoomInfo.hasGuildMatchInfo = true
            table.insert(MainWatchRoomInfo.HistoryCamp1, info.fight_history.pvp_result[i].camp1_result)
            table.insert(MainWatchRoomInfo.HistoryCamp2, info.fight_history.pvp_result[i].camp2_result)
        end
    end

end

function RemoveNotExistRoom(id)

    if not WatchDatas then
        return
    end

    if not id or id <= 0 then
        return
    end

    local l_tb, l_index
    for k, v in pairs(WatchDatas) do
        for i, roomInfo in ipairs(v) do
            if roomInfo.sequence_uid == id then
                l_tb = v
                l_index = i
                break
            end
        end
    end

    if l_tb and l_index then
        table.remove(l_tb, l_index)
        return true
    end
end

function ResetSelectClassifyTypeID()
    SetSelectClassifyTypeID(ESelectClassifyType.Recommend)
end

function SetSelectClassifyTypeID(id)
    selectClassifyTypeID = id
end

function GetSelectClassifyTypeID()
    return selectClassifyTypeID
end

function RequestSetSpectatorChatStatus(value)

    if value == ChatStatus then
        return
    end
    ChatStatus = value
    Common.Serialization.StoreData("WatchChatStatus", value and "" or "1", MPlayerInfo.UID:tostring())
end

function GetSpectatorCharStatus()
    local l_record = Common.Serialization.LoadData("WatchChatStatus", MPlayerInfo.UID:tostring())
    return ChatStatus
end

function ClearMemberWatchRecord()
    MemberWatchRecord = {}
end

function MarkMemberWatchRecord(id, flag)

    MemberWatchRecord[tostring(id)] = flag
end

function HasMemberWatchRecord(id)

    return MemberWatchRecord[tostring(id)] or false
end

function ClearFlowerNum()
    MainWatchRoomInfo.camp1_flower = 0
    MainWatchRoomInfo.camp2_flower = 0
end

function GetLeftTeamGuildId()

    if not MainWatchRoomInfo or not MainWatchRoomInfo.CaptainGuildId then
        return 0
    end

    local l_guildId = MainWatchRoomInfo.CaptainGuildId[1]
    return l_guildId
end

function SetCampScore(info)
    if MPlayerInfo.IsWatchWar then
        local leftGuildId = GetLeftTeamGuildId()
        if int64.equals(leftGuildId,info.camp1_id) then
            MainWatchRoomInfo.camp1_score = info.camp1_score or 0
            MainWatchRoomInfo.camp2_score = info.camp2_score or 0
        else
            MainWatchRoomInfo.camp1_score = info.camp2_score or 0
            MainWatchRoomInfo.camp2_score = info.camp1_score or 0
        end
    else
        if info.camp2_id == DataMgr:GetData("GuildData").selfGuildMsg.id then
            MainWatchRoomInfo.camp1_score = info.camp2_score or 0
            MainWatchRoomInfo.camp2_score = info.camp1_score or 0
        else
            MainWatchRoomInfo.camp1_score = info.camp1_score or 0
            MainWatchRoomInfo.camp2_score = info.camp2_score or 0
        end

    end
end

return ModuleData.WatchWarData