---@module ModuleMgr.WatchWarMgr
module("ModuleMgr.WatchWarMgr", package.seeall)

--------------------------------------------事件定义--Start----------------------------------
EventDispatcher = EventDispatcher.new()

ON_SELECT_CLASSIFY_EVENT = "ON_SELECT_CLASSIFY_EVENT"                -- 选择观战列表类型
ON_WATCH_LIST_DATA_UPDATE = "ON_WATCH_LIST_DATA_UPDATE"               -- 观战列表消息更新
ON_STAGE_CHANGED = "ON_STAGE_CHANGED"                        -- Stage切换
ON_MAIN_WATCH_ALL_BRIEF_INFO = "ON_MAIN_WATCH_ALL_BRIEF_INFO"            -- 观战详细信息更新
ON_MAIN_WATCH_BRIEF_INFO_UPDATE = "ON_MAIN_WATCH_BRIEF_INFO_UPDATE"         -- 观战状态信息更新
ON_GUILD_MATCH_INFO_UPDATE = "ON_GUILD_MATCH_INFO_UPDATE"                 --工会匹配战用刷新
ON_MAIN_ROOM_WATCH_INFO_DATA = "ON_MAIN_ROOM_WATCH_INFO_DATA"            -- 观战人数、点赞信息更新
ON_SWITCH_WATCH_PLAYER = "ON_SWITCH_WATCH_PLAYER"                  -- 切换观战对象
ON_WATCH_RECORD_UPDATE = "ON_WATCH_RECORD_UPDATE"                  -- 观战数据更新
ON_ARENA_FIGHT_GROUP_CHANGE = "ON_ARENA_FIGHT_GROUP_CHANGE"             -- 阵营切换
ON_LIKE_STATUS = "ON_LIKE_STATUS"                          -- 点赞
ON_SPECTATOR_WATCH_CHAT_STUTAS = "ON_SPECTATOR_WATCH_CHAT_STUTAS"
ON_TEAM_WATCH_STATUS_CHANGE = "ON_TEAM_WATCH_STATUS_CHANGE"
--------------------------------------------事件定义--End----------------------------------

--------------------------------------------控制变量--Start----------------------------------

local l_needClearStageInfo = false      -- 是否需要清理
local l_needAutoShowUI = false
local l_hasEnterScene = false
local l_action

--------------------------------------------控制变量--End----------------------------------
---@type ModuleData.WatchWarData
local l_data

--------------------------------------------生命周期--Start----------------------------------
function OnInit()

    l_data = DataMgr:GetData("WatchWarData")
    l_selectClassifyTypeID = l_data.ESelectClassifyType.UnDefined

    MgrMgr:GetMgr("TeamMgr").EventDispatcher:Add(DataMgr:GetData("TeamData").ON_QUIT_TEAM_MEMBER, OnMemberQuitTeam)
end

function OnLogout()

    l_needAutoShowUI = false
end

function OnLeaveScene()

    l_hasEnterScene = false
    l_action = nil

end

-- 进入Stage
function OnEnterStage(stage)

    if MPlayerInfo.IsWatchWar then
        MEventMgr:LuaFireEvent(MEventType.MEvent_CamTarget, MScene.GameCamera);

        l_needClearStageInfo = true
    end
    BroadcastStageChanged()

end

function OnLuaDoEnterScene(info)

    if info ~= nil and info.dungeons ~= nil and info.dungeons.guild_match_reconnect ~= nil then
        local data = info.dungeons.guild_match_reconnect
        l_data.MainWatchRoomInfo.hasGuildMatchInfo = false
        l_data.OnEnterScene(data)
        if data.left_life_counter then
            local uHeartTable = {}
            for i = 1, table.maxn(data.left_life_counter) do
                local v = data.left_life_counter[i]
                MgrMgr:GetMgr("DungeonMgr").ShowLifeHUD(3, v.second, nil, v.first)
                MPlayerDungeonsInfo.LeftLifeCounter:set_Item(v.first, v.second)
                table.insert(uHeartTable, v)
            end
            l_data.PlayerLife = uHeartTable
        end
        EventDispatcher:Dispatch(ON_GUILD_MATCH_INFO_UPDATE)
    end
end

function OnEnterScene(sceneId)
    if IsInSpectator() then
        ResetWatchUI()
    else
        if not IsInSpectator() and l_needAutoShowUI then
            l_needAutoShowUI = false
            if not StageMgr:CurStage():IsConcreteStage() then
                return
            end
            UIMgr:ActiveUI(UI.CtrlNames.WatchWarBG)
        end
    end
    if l_action then
        l_action()
        l_action = nil
    end
    l_hasEnterScene = true
end


-- 离开Stage
function OnLeaveStage()

    if not MPlayerInfo.IsWatchWar and l_needClearStageInfo then
        ClearRoomListData()
        l_needClearStageInfo = false
    end

end
--------------------------------------------生命周期--End----------------------------------

--------------------------------------------协议处理--Start----------------------------------

-- 选角
function OnSelectRoleNtf()

    l_data.RecordDatas = {}
    ResetSelectClassifyTypeID()
    ClearRoomListData()

end


-- 请求房间列表
function RequestGetWatchRoomList(spectatorType, page, force, clear)

    local l_msgId = Network.Define.Rpc.GetWatchRoomList
    ---@type GetWatchRoomListArgs
    local l_sendInfo = GetProtoBufSendTable("GetWatchRoomListArgs")
    l_sendInfo.spectator_type = spectatorType or l_data.ESelectClassifyType.Recommend
    l_sendInfo.page = page or 1
    l_sendInfo.is_refresh = force or false
    Network.Handler.SendRpc(l_msgId, l_sendInfo, clear)

end

-- 收到房间列表信息
function OnGetWatchRoomList(msg, args, clear)
    ---@type GetWatchRoomListRes
    
    local l_info = ParseProtoBufToTable("GetWatchRoomListRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_WATCH_ROOM_NOMORE_PAGE then
            l_data.WatchDatas[args.spectator_type] = {}
            EventDispatcher:Dispatch(ON_WATCH_LIST_DATA_UPDATE)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))    
        end
        return
    end

    if args.page == 1 then
        l_data.WatchDatas[args.spectator_type] = {}
    end

    if clear and #l_info.rooms > 0 then
        l_data.WatchDatas[args.spectator_type] = {}
    end

    l_data.OnGetWatchRoomList(l_info.rooms, args.spectator_type)
    EventDispatcher:Dispatch(ON_WATCH_LIST_DATA_UPDATE, args.page or 1)

end

-- 点赞某个房间
function RequestLikeWatchRoom(room_uid)
    local l_msgId = Network.Define.Rpc.LikeWatchRoom
    ---@type LikeWatchRoomArgs
    local l_sendInfo = GetProtoBufSendTable("LikeWatchRoomArgs")
    l_sendInfo.room_uid = room_uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

-- 点赞结果
function OnLikeWatchRoom(msg)
    ---@type LikeWatchRoomRes
    local l_info = ParseProtoBufToTable("LikeWatchRoomRes", msg)
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_HAS_ALREADY_LIKE_ROOM then
            EventDispatcher:Dispatch(ON_LIKE_STATUS)
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(ON_LIKE_STATUS)

end

-- 根据关键字搜索房间
function RequestSearchWatchRoom(name)

    local l_msgId = Network.Define.Rpc.SearchWatchRoom
    ---@type SearchWatchRoomArgs
    local l_sendInfo = GetProtoBufSendTable("SearchWatchRoomArgs")
    l_sendInfo.name = name
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

-- 搜索房间结果
function OnSearchWatchRoom(msg)
    ---@type SearchWatchRoomRes
    local l_info = ParseProtoBufToTable("SearchWatchRoomRes", msg)
    l_data.SearchDatas = nil
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    l_data.SearchDatas = l_info.rooms
    if not l_data.SearchDatas or #l_data.SearchDatas <= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NONE_WATCH_ROOM"))
        return
    end

    EventDispatcher:Dispatch(ON_WATCH_LIST_DATA_UPDATE)

end

-- 请求观战
function RequestWatchRoom(seq_id, extraInfo)
    local l_msgId = Network.Define.Rpc.RequestWatchDungeons
    ---@type RequestWatchDungeonArgs
    local l_sendInfo = GetProtoBufSendTable("RequestWatchDungeonArgs")
    l_sendInfo.seq_id = seq_id
    extraInfo = extraInfo or {}
    extraInfo.seq_id = seq_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo, extraInfo)

end

-- 请求观战结果
function OnRequestWatchDungeons(msg, args, customData)
    ---@type RequestWatchDungeonRes
    local l_info = ParseProtoBufToTable("RequestWatchDungeonRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))

        if l_info.result == ErrorCode.ERR_WATCH_ROOM_NOT_EXIST then
            local l_ret = l_data.RemoveNotExistRoom(customData and customData.seq_id or 0)
            if l_ret then
                EventDispatcher:Dispatch(ON_WATCH_LIST_DATA_UPDATE)
            end
        end

        return
    end
    l_needAutoShowUI = true
    l_data.SetDungeonBattleInfo(args.seq_id, customData)

end

-- 观战房间内详细信息
function OnDungeonWatchAllMemberStatusNtf(msg)

    local l_tmpWatchId = MPlayerInfo.WatchFocusPlayerId
    ClearRoomListData()
    MPlayerInfo.WatchFocusPlayerId = l_tmpWatchId
    ---@type WatchRoomBoardInfo
    local l_info = ParseProtoBufToTable("WatchRoomBoardInfo", msg)
    l_data.OnDungeonWatchAllMemberStatusNtf(l_info)
    EventDispatcher:Dispatch(ON_MAIN_WATCH_ALL_BRIEF_INFO)

end

-- 观战状态信息更新
function OnDungeonWatchBriefStatusNft(msg)
    ---@type DungeonWatchBriefData
    local l_info = ParseProtoBufToTable("DungeonWatchBriefData", msg)
    local l_needRebuild = l_data.OnDungeonWatchBriefStatusNft(l_info)
    EventDispatcher:Dispatch(ON_MAIN_WATCH_BRIEF_INFO_UPDATE)
    if l_needRebuild then
        EventDispatcher:Dispatch(ON_MAIN_WATCH_ALL_BRIEF_INFO)
    end

end

-- 观战人数&点赞人数更新
function OnUpdateRoomWatchInfo(msg)
    ---@type UpdateRoomWatchInfoData
    local l_info = ParseProtoBufToTable("UpdateRoomWatchInfoData", msg)

    l_data.OnUpdateRoomWatchInfo(l_info)
    EventDispatcher:Dispatch(ON_MAIN_ROOM_WATCH_INFO_DATA)

end

-- 观战对象切换
function OnWatchSwitch(msg)
    ---@type WatchSwitchData
    local l_info = ParseProtoBufToTable("WatchSwitchData", msg)
    FocusWatchMember(l_info.switch_player_uuid)

    EventDispatcher:Dispatch(ON_SWITCH_WATCH_PLAYER)

end

-- 请求获取我的记录
function GetRoleWatchRecord()
    local l_msgId = Network.Define.Rpc.GetRoleWatchRecord
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 我的记录
function OnGetRoleWatchRecord(msg)
    ---@type GetRoleWatchRecordRes
    local l_info = ParseProtoBufToTable("GetRoleWatchRecordRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_data.RecordDatas = l_info.record
    EventDispatcher:Dispatch(ON_WATCH_RECORD_UPDATE)

end

-- 请求切换观战对象
function WatcherSwitchPlayer(player_uuid)

    local l_msgId = Network.Define.Rpc.WatcherSwitchPlayer
    ---@type WatcherSwitchPlayerArg
    local l_sendInfo = GetProtoBufSendTable("WatcherSwitchPlayerArg")
    l_sendInfo.player_uuid = player_uuid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 观战对象切换
function OnWatcherSwitchPlayer(msg)
    ---@type WatcherSwitchPlayerRes
    local l_info = ParseProtoBufToTable("WatcherSwitchPlayerRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

end

-- 观战设置
function RequestSetSpectatorStatus(status)
    MgrMgr:GetMgr("SettingMgr").SavePearsonalSetting(status)
end

-- 观战气泡点击协议
function RequestGetWatchRoomInfo(owner_uid, seq_id)
    local l_msgId = Network.Define.Rpc.GetWatchRoomInfo
    ---@type GetWatchRoomInfoArgs
    local l_sendInfo = GetProtoBufSendTable("GetWatchRoomInfoArgs")
    l_sendInfo.seq_id = seq_id and tonumber(seq_id) or 0
    l_sendInfo.owner_uid = tostring(owner_uid)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

-- 观战气泡协议回包
function OnGetWatchRoomInfo(msg)
    ---@type GetWatchRoomInfoRes
    local l_info = ParseProtoBufToTable("GetWatchRoomInfoRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    l_data.SearchDatas = {}
    table.insert(l_data.SearchDatas, l_info.room)

    SetClassifyTypeByRoom(l_info.room)

    UIMgr:ActiveUI(UI.CtrlNames.WatchWarBG)

end


-- 副本初始化
function OnDungeonsWatchInit(msg)
    ---@type DungeonsWatchInitData
    local l_info = ParseProtoBufToTable("DungeonsWatchInitData", msg)
    MEntityMgr.PlayerEntity.DungeonsBegainTime = MLuaCommonHelper.Long(l_info.begin_time)
    if MPlayerInfo.PlayerDungeonsInfo.DungeonID == 6152 then
        DataMgr:GetData("GuildMatchData").TimeStamp = l_info.begin_time + Common.Functions.SequenceToTable(TableUtil.GetDungeonsTable().GetRowByDungeonsID(6152).TimeLimit)[2]
                + TableUtil.GetSpectatorSettingsTable().GetRowByDungeonType(25).Delay
                + tonumber(TableUtil.GetGlobalTable().GetRowByName("G_MatchCountDownBeforeBattle").Value)
    end
    local l_playerDungeonsInfo = MPlayerInfo.PlayerDungeonsInfo
    local l_dungeonType = l_playerDungeonsInfo.DungeonType
    l_action = nil
    if l_dungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonArena then
        l_action = function()
            MgrMgr:GetMgr("ArenaMgr").EnterFight()
            MgrMgr:GetMgr("ArenaMgr").EnterFightUI()
            MgrMgr:GetMgr("ArenaMgr").InitMemberLifeByWatch(l_info.pvp_life_count)
        end
    elseif l_dungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonBattle then
        l_action = function()
            local _, l_tmp = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorDelay(MPlayerDungeonsInfo.DungeonID)
     
            MgrMgr:GetMgr("BattleMgr").OnInitTimeInfo(l_info.begin_time + (l_tmp or 0))
        end
    end

    if l_hasEnterScene and l_action then
        l_action()
        l_action = nil
    end

end

function OnTeamWatchStatusNtf(msg)

    local l_info = ParseProtoBufToTable("TeamWatchStatusNtfData", msg)
    for i, v in ipairs(l_info.members) do
        l_data.MarkMemberWatchRecord(v.role_id, v.is_watching)
    end

    EventDispatcher:Dispatch(ON_TEAM_WATCH_STATUS_CHANGE)
end

--------工会匹配战添加@曾祥硕--Start--------------------

function GetGuildBattleWatchInfo()
    local l_msgId = Network.Define.Rpc.GetGuildBattleWatchInfo
    ---@type GetGuildBattleWatchInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildBattleWatchInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetGuildBattleWatchInfo(msg)
    ---@type ChangeGuildBattleTeamRes
    local l_info = ParseProtoBufToTable("ChangeGuildBattleTeamRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        l_data.SetGuildMatchInfo(l_info)

    end
end
function GiveGuildFlower()

    local l_msgId = Network.Define.Rpc.GiveGuildFlower
    ---@type GiveGuildFlowerArg
    local l_sendInfo = GetProtoBufSendTable("GiveGuildFlowerArg")
    local l_guild_id = MEntityMgr:GetRole(MPlayerInfo.WatchFocusPlayerId).AttrRole.GuildId
    l_sendInfo.guild_id = l_guild_id
    l_sendInfo.num = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGiveGuildFlower(msg)
    ---@type GiveGuildFlowerRes
    local l_info = ParseProtoBufToTable("GiveGuildFlowerRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

end

function OnGuildFlowersChangeNtf(msg)
    ---@type GuildFlowerChangeInfo
    local l_info = ParseProtoBufToTable("GuildFlowerChangeInfo", msg)
    l_data.SetGuildMatchInfo(l_info.guild_battle_info)
end

function OnRoleLifeUpdate(msg)
    ---@type GuildMatchSyncRoleLifeData
    local l_info = ParseProtoBufToTable("GuildMatchSyncRoleLifeData", msg)
    l_data.OnUpdateScore(l_info)
    EventDispatcher:Dispatch(ON_GUILD_MATCH_INFO_UPDATE)
    for i = 1, table.maxn(l_info.camp1_role_life_counter) do
        local v = l_info.camp1_role_life_counter[i]
        MgrMgr:GetMgr("DungeonMgr").ShowLifeHUD(3, v.second, nil, v.first)
        MPlayerDungeonsInfo.LeftLifeCounter:set_Item(v.first, v.second)
    end
    for i = 1, table.maxn(l_info.camp2_role_life_counter) do
        local v = l_info.camp2_role_life_counter[i]
        MgrMgr:GetMgr("DungeonMgr").ShowLifeHUD(3, v.second, nil, v.first)
        MPlayerDungeonsInfo.LeftLifeCounter:set_Item(v.first, v.second)
    end

end


-----------工会匹配战添加--End--------------------

--------------------------------------------协议处理--End----------------------------------

--------------------------------------------辅助方法--Start----------------------------------
-- 根据teamId和其在队伍中的位置获取roleId
function GetWatchUnitIdByTeamAndIndex(teamId, roleIndex)
    if not teamId or not roleIndex then
        return
    end

    if not l_data.MainWatchRoomInfo.teamLinkInfos[teamId] then
        return
    end

    return l_data.MainWatchRoomInfo.teamLinkInfos[teamId][roleIndex]
end

-- 根据roleId获取WatchUnitInfo
function GetWatchUnitInfoByRoleId(roleId)

    if not roleId then
        return
    end

    if not l_data.MainWatchRoomInfo.role_infos[roleId] then
        return
    end

    return l_data.MainWatchRoomInfo.role_infos[roleId]
end

-- 检测方法，判定能否刷新房间列表
function IsSpectatorRefreshLimit(spectator, needUpdateTime)

    local l_flag = true
    -- 若之前没记录，则不被限制
    if not l_data.AutoSearchTimeRecord[spectator] then
        l_flag = false
    else
        -- 时间间隔大于刷新间隔
        if Time.realtimeSinceStartup - l_data.AutoSearchTimeRecord[spectator] > l_data.SpectatorListRefreshInterval then
            l_flag = false
        end
    end
    -- 是否需要更新时间
    if needUpdateTime and not l_flag then
        l_data.AutoSearchTimeRecord[spectator] = Time.realtimeSinceStartup
    end

    return l_flag
end



-- 打开设置界面 观战设置的地方
function OpenSettingCtrl()

    UIMgr:ActiveUI(UI.CtrlNames.Setting, function(ctrl)
        ctrl:SetPlayerHandlerScrollTo("Watch")
        ctrl:SelectOneHandler(UI.HandlerNames.SettingPlayer)
    end)
end

-- 当Focus玩家时，触发事件
function OnFocusRole()

    EventDispatcher:Dispatch(ON_SWITCH_WATCH_PLAYER)
end

-- 当前是否在观战
function IsInSpectator()

    return MPlayerInfo.IsWatchWar
end

-- 通知Stage切换
function BroadcastStageChanged()

    EventDispatcher:Dispatch(ON_STAGE_CHANGED)
end

-- 根据副本类型获取观战类型
function GetSpectatorTypeByDungeonType(dungeonType)

    local DungeonType = MgrMgr:GetMgr("DungeonMgr").DungeonType
    if dungeonType == DungeonType.DungeonBattle then
        return WatchUnitType.WatchUnitTypePVPHeavy
    elseif dungeonType == DungeonType.DungeonArena or dungeonType == DungeonType.DungeonGuildMatch then
        return WatchUnitType.kWatchUnitTypePVPLight
    else
        return WatchUnitType.kWatchUnitTypePVE
    end
end

-- 自动找一个单位Focus
function AutoFindWatchMember()
    local l_watchId = MPlayerInfo.WatchFocusPlayerId
    if l_watchId and MEntityMgr:GetEntity(l_watchId, true) then
        WatcherSwitchPlayer(l_watchId)
        return
    end

    local l_teamLinkInfos = l_data.MainWatchRoomInfo.teamLinkInfos or {}
    local l_teamId = next(l_teamLinkInfos)
    local l_roleId = GetWatchUnitIdByTeamAndIndex(l_teamId, 1)
    if l_roleId then
        WatcherSwitchPlayer(l_roleId)
    else
        logError("AutoFindWatchMember error, 找不到观战目标", l_teamId)
    end
end

-- Unit出现时
function OnUnitAppear(uid)

end

-- 相机跟随黑幕处理
function FocusWatchMember(targetUid)

    if l_data.UnderBlackCurtainFadeIn then
        return
    end

    local l_lastFocusId = MPlayerInfo.WatchFocusPlayerId
    MPlayerInfo.WatchFocusPlayerId = targetUid

    local l_dungeonId = l_data.MainWatchRoomInfo and l_data.MainWatchRoomInfo.dungeon_id
    if not l_dungeonId then
        return
    end

    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonId, true)
    if not l_dungeonRow then
        return
    end

    if l_dungeonRow.DungeonsType ~= MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonBattle and
            l_dungeonRow.DungeonsType ~= MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonArena then
        return
    end

    local l_lastFocusIdStr = tostring(l_lastFocusId)
    local l_curFocusIdStr = tostring(targetUid)
    -- 无观战目标
    if l_curFocusIdStr == "0" then
        return
    end
    local l_needShowBlackCurtain = false
    -- 当前无观战对象，则显示黑幕
    if l_lastFocusIdStr == "0" then
        l_needShowBlackCurtain = true
        -- 当前目标与新目标一致，不处理
    elseif l_lastFocusIdStr == l_curFocusIdStr then
        -- 当前目标与新目标是一个队伍，不处理
    elseif MPlayerInfo:IsInSameTeam(l_lastFocusId, targetUid) then
    else
        local l_curEntity, l_tarEntity = MEntityMgr:GetEntity(l_lastFocusId), MEntityMgr:GetEntity(targetUid)
        -- 实体都不存在时，显示黑幕
        if not l_tarEntity or not l_tarEntity then
            l_needShowBlackCurtain = true
            -- 不是一个阵营，显示黑幕
        elseif MEntityMgr:IsEnemy(l_lastFocusId, targetUid) then
            l_needShowBlackCurtain = true
        end
    end

    if l_needShowBlackCurtain then
        l_data.UnderBlackCurtainFadeIn = true
        -- 回调中清理黑幕状态变量
        MgrMgr:GetMgr("BlackCurtainMgr").BlackCurtain(function()
            l_data.UnderBlackCurtainFadeIn = false
        end, function()
            l_data.UnderBlackCurtainFadeIn = false
        end, nil, l_data.SpectatorTranslation[0], l_data.SpectatorTranslation[1], l_data.SpectatorTranslation[2], true)
    end
end


-- 通知当前观战阵营变化
function UpdateBattleSide()

    local l_dungeonId = l_data.MainWatchRoomInfo and l_data.MainWatchRoomInfo.dungeon_id
    if not l_dungeonId then
        return
    end

    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonId, true)
    if not l_dungeonRow then
        return
    end

    if l_dungeonRow.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonBattle then
        MgrMgr:GetMgr("BattleMgr").InitEntityInfo()
        return
    end

    if l_dungeonRow.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonArena then
        EventDispatcher:Dispatch(ON_ARENA_FIGHT_GROUP_CHANGE)
        return
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

-- 重置UI
function ResetWatchUI()

    local l_playerDungeonsInfo = MPlayerInfo.PlayerDungeonsInfo
    local l_dungeonType = l_playerDungeonsInfo.DungeonType
    local l_spectatorRow = TableUtil.GetSpectatorSettingsTable().GetRowByDungeonType(l_dungeonType, true)
    if l_spectatorRow then
        MgrMgr:GetMgr("SceneEnterMgr").ResetSceneUIWithId(l_spectatorRow.MainUi, { UI.CtrlNames.Battle, UI.CtrlNames.TipsDlg })
    end

end

-- 设置聊天弹幕显示
function RequestSetSpectatorChatStatus(value)

    l_data.RequestSetSpectatorChatStatus(value)
    EventDispatcher:Dispatch(ON_SPECTATOR_WATCH_CHAT_STUTAS)
end

function GetSpectatorCharStatus()

    return l_data.GetSpectatorCharStatus()
end

--------------------------------------------辅助方法--End----------------------------------

--------------------------------------------观战列表方法--Start----------------------------------

function ResetSelectClassifyTypeID()
    l_data.ResetSelectClassifyTypeID()
end

function SetSelectClassifyTypeID(id, request)

    l_data.SetSelectClassifyTypeID(id)
    EventDispatcher:Dispatch(ON_SELECT_CLASSIFY_EVENT)
    if request then
        RequestGetWatchRoomList(id, nil, nil, true)
    end

end

function GetSelectClassifyTypeID()
    return l_data.GetSelectClassifyTypeID()
end

function SetClassifyTypeByRoom(room)

    if not room then
        return
    end

    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(room.dungeon_id)
    if not l_dungeonRow then
        return
    end

    local l_spectatorRow = TableUtil.GetSpectatorTypeTable().GetRowByID(l_dungeonRow.SpectatorType)
    if l_spectatorRow then
        l_data.SetSelectClassifyTypeID(l_dungeonRow.SpectatorType)
    end
end

--------------------------------------------观战列表方法--End----------------------------------

--------------------------------------------清理数据--Start----------------------------------

-- 清理搜索结果
function ClearSearchInfo()
    l_data.SearchDatas = nil
end

-- 重置观战列表数据
function ClearRoomListData()

    ClearRoomListInfo()
    ClearSearchInfo()
    l_data.MainWatchRoomInfo = {}
    MPlayerInfo.WatchFocusPlayerId = 0
    l_data.UnderBlackCurtainFadeIn = false

end

-- 清理房间列表信息
function ClearRoomListInfo()

    l_data.WatchDatas = {}
    l_data.RecordDatas = {}
    l_data.AutoSearchTimeRecord = {}

end

-- 清理观战信息
function ClearWatchedCache()
    MPlayerInfo.WatchFocusPlayerId = 0
end

--------------------------------------------清理数据--End----------------------------------

--------------------------------------------气泡--Start----------------------------------

local l_sequenceCount = 0           -- 序列数
-- 气泡被点击时(eventData, EntityId, roomUid)
function OnClick(_, EntityId, roomUid, ownerId)
    -- 防止多次响应
    l_sequenceCount = l_sequenceCount + 1
    local l_sequence = l_sequenceCount
    -- 满足条件
    local _action = function(sequence)
        -- 序列不同则忽略
        if l_sequence ~= sequence then
            return
        end
        RequestGetWatchRoomInfo(ownerId)
    end

    -- 判断是否是同一个工会的
    local l_ownerId = ownerId
    local _checkGuildFunc = function()
        MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(l_ownerId, function(info)
            if not info then
                logError("WatchWar Bubble GetPlayerInfoFromServer fail", l_ownerId)
                return
            end
            -- 判断
            if info.guildId ~= 0 and info.guildId == DataMgr:GetData("GuildData").selfGuildMsg.id then
                _action(l_sequence)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("WATCHWAR_BUBBLE_CONDITION"))
            end
        end)
    end
    -- 判断好感度>=1
    local l_teamMgr = MgrMgr:GetMgr("TeamMgr")
    MgrMgr:GetMgr("CookingDoubleMgr").ProcessCheckAsyn(l_teamMgr,
            DataMgr:GetData("TeamData").ON_GET_PLAYER_TEAM_FRIEND_INFO, MgrMgr:GetMgr("WatchWarMgr"), function(info)
                local l_flag = info.intimacy_degree >= 1
                if not l_flag then
                    _checkGuildFunc()
                end
                return l_flag
            end, function()
                _action(l_sequence)
            end)
    -- 请求
    l_teamMgr.GetUserInTeamOrNot(l_ownerId)

end

--分享，显示在聊天界面
function ShareWatch(Text, TextParam, position)

    local l_names = {}
    local l_callBacks = {}
    local l_Text = Text
    local l_TextParam = TextParam
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_channels = { l_chatDataMgr.EChannel.WorldChat, l_chatDataMgr.EChannel.GuildChat }
    for i, l_channel in pairs(l_channels) do
        local l_name = l_chatDataMgr.GetChannelName(l_channel)
        if l_name ~= nil then
            table.insert(l_names, l_name)
            local l_callBack = function()
                local l_isSendSucceed = MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, l_Text, l_channel, l_TextParam)
                if l_isSendSucceed then
                    local l_tips
                    if l_channel == l_chatDataMgr.EChannel.WorldChat then
                        l_tips = Lang("ShareSucceedTextWorld")
                    elseif l_channel == l_chatDataMgr.EChannel.GuildChat then
                        l_tips = Lang("ShareSucceedTextGuild")
                    else
                        l_tips = Lang("ShareSucceedText")
                    end
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
                end
            end
            table.insert(l_callBacks, l_callBack)
        end
    end
    UIMgr:DeActiveUI(UI.CtrlNames.TeamQuickFunc)
    if #l_names > 0 then
        local openData = {
            openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
            nameTb = l_names,
            callbackTb = l_callBacks,
            dataopenPos = position,
            dataAnchorMaxPos = nil,
            dataAnchorMinPos = nil
        }
        UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
    end

end
--------------------------------------------气泡--End----------------------------------

function GetSpectatorDisplayNum(num)

    if num > l_data.SpectatorMaxDisplayNum then
        return StringEx.Format("{0}+", l_data.SpectatorMaxDisplayNum)
    else
        return tostring(num)
    end
end

function OnMemberQuitTeam(targetInfo)

    if not targetInfo then
        l_data.ClearMemberWatchRecord()
    end
end

function HasMemberWatchRecord(uid)

    return l_data.HasMemberWatchRecord(uid)
end

return WatchWarMgr