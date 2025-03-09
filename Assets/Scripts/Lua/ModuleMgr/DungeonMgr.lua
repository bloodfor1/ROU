---@module ModuleMgr.DungeonMgr
module("ModuleMgr.DungeonMgr", package.seeall)

require "Command.AddFlagValCommand"
require "ModuleMgr/CommonMsgProcessor"

EventDispatcher = EventDispatcher.new()
--------------------------------进入副本相关--------------------------------------
SYNC_MEMBER_REPLY_ENTER_FB_NTF = "SYNC_MEMBER_REPLY_ENTER_FB_NTF"
ON_UPDATE_MONSTER_NUM = "ON_UPDATE_MONSTER_NUM"
--点赞数量
UPDATE_ENCOURAGE_NUM = "UPDATE_ENCOURAGE_NUM"
CANCLE_THREE_TO_THREE = "CANCLE_THREE_TO_THREE"
CONFIRM_THREE_TO_THREE = "CONFIRM_THREE_TO_THREE"
DUNGEON_COUNT_DOWN_FINISH = "DUNGEON_COUNT_DOWN_FINISH"
DUNGEON_MONSTERS_REFRESH = "TOWER_MONSTERS_REFRESH"
ENTER_DUNGEON = "ENTER_DUNGEON"
EXIT_DUNGEON = "EXIT_DUNGEON"
Refresh_Dungeon_Info = "Refresh_Dungeon_Info"
-- 副本提示
SHOW_DUNGEON_ALARM = "SHOW_DUNGEON_ALARM"

DungeonLifeHudType = {
    Icon = 1,
    Text = 2,
}

DungeonType = {
    None = 0,
    DungeonMirror = 1, --镜像副本
    DungeonThemeStory = 2, --主题副本剧情
    DungeonThemeChallenge = 26, --主题副本挑战
    DungeonTower = 3, --无限塔
    DungeonDoubleCook = 4, --双人烹饪
    DungeonLover = 5, --爱神副本
    DungeonBattle = 6, --战场
    DungeonHymn = 7, --圣歌试炼
    DungeonChangeJob = 8, --转职试炼副本
    DungeonGuildScene = 9, --公会场景
    DungeonGuild = 10, --公会副本
    DungeonArena = 11, --擂台
    DungeonTask = 12, --任务副本
    DungeonHero = 13, --极限挑战
    DungeonCook = 14, --单人厨房副本玩法同双人
    DungeonsBlackHouse = 15, --黑暗迷宫
    DungeonGuildHunt = 16, --公会狩猎
    DungeonFollow = 17, --尾行
    DungeonAvoid = 18, --躲避玩法
    DungeonMaze = 19, --迷雾之森
    DungeonBeach = 20, --抢滩登录
    DungeonPvp = 21, --pvp
    DungeonWorldPve = 22, --奇闻
    TowerDefenseSingle = 23, --单人天地树
    TowerDefenseDouble = 24, --双人天地树
    DungeonGuildMatch = 25, --公会匹配赛
    DungeonTypeThemeStory = 26, --剧情本
}

EDungeonResultType = {
    NoResult = 1, -- 无结算界面
    WithReward = 2, -- 结算界面（有奖励类型）
    WithoutReward = 3, -- 结算界面（有奖励类型）
}

DungeonTimeLimitType = {
    TimeLimit_NO = 0,
    TimeLimit_Ascending = 1,
    TimeLimit_Reverse = 2,
    TimeLimit_Wait = 3,
}

g_teamInfo = {}
--是否在镜像副本
PlayerInCopyDungeon = false
-- 组队进入副本确认的开始时间
TeamCheckStartTime = nil
-- 副本的开始时间
DungeonStartTime = 0
-- 副本的结算时间
DungeonResultTime = 0
-- 副本的剩余时间
DungeonRemainTime = 0
-- 副本房间开始时间
RoomStartTime = 0
--主题副本组队界面按钮是否已被点击过
IsThemeDungeonTeamBtnClicked = false
--是否默认助战
DefaultAssist = false
-- 副本词缀
DungeonAffixIds = {}

--副本处理的标志位
IsTransferProfession = false
IsSliderShow = false
IsAddPoint = false
IsIgnoreFirst = false   --是否忽略第一个推荐
ShowAttrRiseTime = 0
IsTempTeamMode = false
RecommendTable = {}



--弱网情况下可能会收到多份结算
isDungeonResultProcessed = false
--缓存的副本名
local dungeonName = ""
-- 副本是否已结算
local isResulted = false
--副本怪物列表
local monsterInfo = {}

local ADDPOINT_SCENEID = 2116

local DUNGEON_TARGET_ADDPOINT_1 = 650

local DUNGEON_TARGET_ADDPOINT_2 = 652

-- message_id = -1 --只有写操作，没有读操作，暂时注释掉
-- 是否在加载中
local isLoading = false
-- 缓存的messageId
local cacheMessageId = -1

dungeonAffixTimeStamp = {}

-- 用于处理副本词缀刷新后第一次展示给玩家
function OnDungeonCommonData(dungeonId, value)
    value = tonumber(value)
    if #DungeonAffixIds > 0 and dungeonAffixTimeStamp[dungeonId] ~= value then
        UIMgr:ActiveUI(UI.CtrlNames.Bossbuff)
    end
    dungeonAffixTimeStamp[dungeonId] = value
end

function OnInit()
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_DUNGEON,
        Callback = OnDungeonCommonData,
    })

    l_commonData:Init(l_data)

    GlobalEventBus:Add(EventConst.Names.CutSceneStop, OnCutSceneStop)
    MgrMgr:GetMgr("TeamMgr").EventDispatcher:Add(DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE,
            function(a)
                local l_info = DataMgr:GetData("TeamData").myTeamInfo
                if TeamCheckStartTime then
                    local l_disable = false
                    if table.maxn(l_info.memberList) == 0 or #g_teamInfo ~= table.maxn(l_info.memberList) then
                        l_disable = true
                    else
                        if #g_teamInfo > 0 and table.maxn(l_info.memberList) > 0 then
                            for i = 1, #g_teamInfo do
                                local l_id = g_teamInfo[i].roleId
                                local l_state = g_teamInfo[i].onlineState
                                local l_name = g_teamInfo[i].roleName
                                for i = 1, table.maxn(l_info.memberList) do
                                    local l_roleId = l_info.memberList[i].roleId
                                    if tostring(l_roleId) == tostring(l_id) then
                                        if l_state and l_info.memberList[i].state == MemberStatus.MEMBER_OFFLINE then
                                            l_disable = true
                                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TEAM_NUMBER_OFFLINE"), l_name))
                                        end
                                        break
                                    end
                                end
                                if l_disable then
                                    break
                                end
                            end
                        end
                    end
                    if l_disable then
                        TeamCheckStartTime = nil
                        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
                    end
                end
            end, MgrMgr:GetMgr("DungeonMgr"))
end

function UnInit()
    MgrMgr:GetMgr("TeamMgr").EventDispatcher:RemoveObjectAllFunc(DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, MgrMgr:GetMgr("DungeonMgr"))
end

function OnReconnected(reconnectData)
    --获取剩余时间 和 是否已结算
    DungeonStartTime = reconnectData.dungeons.begin_time
    isResulted = reconnectData.dungeons.is_resulted
    DungeonRemainTime = isResulted and reconnectData.dungeons.kick_left_time or 0
    RoomStartTime = reconnectData.dungeons.room_start_time
    ShowLeftTimer()
end

function OnLuaDoEnterScene(info)
    --获取剩余时间 和 是否已结算
    DungeonStartTime = info.dungeons.begin_time
    isResulted = info.dungeons.is_resulted
    DungeonRemainTime = isResulted and info.dungeons.kick_left_time or 0
    RoomStartTime = info.dungeons.room_start_time
    isDungeonResultProcessed = false

    DungeonAffixIds = {}
    for _, v in ipairs(info.dungeons.affixids) do
        table.insert(DungeonAffixIds, v.value)
    end

    EventDispatcher:Dispatch(Refresh_Dungeon_Info)
end

function OnEnterScene(sceneId)
    ---特判场景ID不是狩猎场场景，用于规避进入狩猎场场景后再次打开组队确认面板
    if TeamCheckStartTime ~= nil and MScene.SceneID ~= MGlobalConfig:GetInt("HuntingGroundSceneID",0) then
        UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonTeam, function(l_ctrl)
            l_ctrl.panel.ThemeDungeonNameLab.LabText = Lang("DUNGEONS_WAIT_ENTER", dungeonName)
        end)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
    end
    --刚进副本时 剩余时间倒计时显示
    ShowLeftTimer()
    OnEnterSceneAddPointCheck(sceneId)
end

function OnResetTime()
    TeamCheckStartTime = nil
end

function OnLogout()
    OnResetTime()
    EventDispatcher:Dispatch(EXIT_DUNGEON)
    dungeonAffixTimeStamp = {}
end

function InitInfo()
    ---初始化隊員同意状态信息
    g_teamInfo = {}
    ---@type ClientTeamInfo
    local l_info = DataMgr:GetData("TeamData").myTeamInfo
    if table.maxn(l_info.memberList) == 0 or table.maxn(g_teamInfo) > 0 then
        return
    end
    -- 把队长的信息放在第一个
    local l_index = 2 --1 leader
    for i = 1, table.maxn(l_info.memberList) do
        local l_roleId = l_info.memberList[i].roleId
        if l_info.captainId == l_roleId then
            --leader
            g_teamInfo[1] = {}
            g_teamInfo[1].roleId = l_roleId
            g_teamInfo[1].roleName = MPlayerInfo.Name
            g_teamInfo[1].state = ReplyType.REPLY_TYPE_AGREE
            g_teamInfo[1].roleType = l_info.memberList[i].roleType
            g_teamInfo[1].onlineState = true
            g_teamInfo[1].roleHead = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_info.memberList[i].roleBriefInfo)
        else
            g_teamInfo[l_index] = {}
            g_teamInfo[l_index].roleId = l_roleId
            g_teamInfo[l_index].roleName = l_info.memberList[i].roleName
            g_teamInfo[l_index].state = -1
            g_teamInfo[l_index].roleType = l_info.memberList[i].roleType
            g_teamInfo[l_index].onlineState = l_info.memberList[i].state ~= MemberStatus.MEMBER_OFFLINE
            g_teamInfo[l_index].roleHead = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_info.memberList[i].roleBriefInfo)
            l_index = l_index + 1
        end
    end
end

function ClearTeamInfo()
    ---清空状态信息
    g_teamInfo = {}
end

--------------------------------副本结算相关--------------------------------------
function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)

    if not MgrMgr:GetMgr("DungeonMgr").IsInDungeons() then
        return
    end

    -- 迷雾之森迷宫房间胜利不用处理，其它情况需过滤断线重连的重复协议问题
    if l_info.status ~= DungeonsResultStatus.kResultMazeRoomVictory then
        if GetDungeonResult() then
            return
        end
        isDungeonResultProcessed = true
    end

    local l_dungeonRow = nil
    -- dungeons_id可能为0
    if l_info.dungeons_id > 0 then
        l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_info.dungeons_id)
    end

    --副本时间处理
    if l_dungeonRow then
        MgrMgr:GetMgr("DungeonMgr").DungeonRemainTime = l_dungeonRow.TimeToKickDefeat
    end
    MgrMgr:GetMgr("DungeonMgr").DungeonResultTime = tonumber(tostring(MServerTimeMgr.UtcSeconds))
    if l_info.status == DungeonsResultStatus.kResultVictory and l_dungeonRow then
        MgrMgr:GetMgr("DungeonMgr").DungeonRemainTime = l_dungeonRow.TimeToKick
    end
    --- 多种副本的奖励用到了主题副本，需放在结算前提前统一处理
    MgrMgr:GetMgr("ThemeDungeonMgr").UpdateAwardsInfo(l_info.awards_info)

    -- 副本结算界面处理
    if l_dungeonRow then
        if l_dungeonRow.ShowResultHudType == EDungeonResultType.NoResult then
            -- 无结算界面
            return
        elseif l_dungeonRow.ShowResultHudType == EDungeonResultType.WithReward then
            -- 结算界面(有奖励类型)
            if l_info.status == DungeonsResultStatus.kResultVictory then
                UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonResult)
            elseif l_info.status == DungeonsResultStatus.kResultLose then
                UIMgr:ActiveUI(UI.CtrlNames.DungeonRegret)
            end
        elseif l_dungeonRow.ShowResultHudType == EDungeonResultType.WithoutReward then
            -- 结算界面(无奖励类型)
            if l_info.status == DungeonsResultStatus.kResultVictory then
                UIMgr:ActiveUI(UI.CtrlNames.Goalachieved, { resultType = GameEnum.ESucceedFail.Succeed })
            elseif l_info.status == DungeonsResultStatus.kResultLose then
                UIMgr:ActiveUI(UI.CtrlNames.Goalachieved, { resultType = GameEnum.ESucceedFail.Fail })
            end
        end
    end

    local l_dungeonsType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    --logGreen("dungeon result = ", l_dungeonsType)
    if l_dungeonsType == DungeonType.DungeonMirror then
        DungeonRemainTime = MPlayerInfo.PlayerDungeonsInfo.TimeToKick
        if MPlayerInfo.PlayerDungeonsInfo.TimeToKick > 0 then
            local l_data = {
                startTime = MServerTimeMgr.UtcSeconds,
                remainTime = MPlayerInfo.PlayerDungeonsInfo.TimeToKick
            }
            UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
        end
    elseif l_dungeonsType == DungeonType.DungeonThemeStory or l_dungeonsType == DungeonType.DungeonThemeChallenge then
        --主题副本BOSS死亡播放慢动作 时间走全局配置
        --l_aniDuration 慢动作持续时间
        --l_slowMotion 慢动作减慢比例
        local l_aniDuration = MGlobalConfig:GetFloat("BossDeadSlowDownTime")
        local l_slowMotion = MGlobalConfig:GetFloat("BossDeadSlowDownRatio")

        l_aniDuration = l_aniDuration * l_slowMotion
        MGame:SetTimeScale(l_slowMotion)
        local l_timer = Timer.New(function()
            MGame:SetTimeScale(1)
            MgrMgr:GetMgr("ThemeDungeonMgr").OnDungeonsResult(msg)
        end, l_aniDuration, 0, true)
        l_timer:Start()

    elseif l_dungeonsType == DungeonType.DungeonTower then
        MgrMgr:GetMgr("InfiniteTowerDungeonMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonBattle then
        MgrMgr:GetMgr("BattleMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonHymn then
        --圣歌试炼
        MgrMgr:GetMgr("ThemeDungeonMgr").OnDungeonsResult(msg)
        MgrMgr:GetMgr("HymnTrialMgr").InitLog()  --缓存清理
        UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialInfo) --信息展示界面关闭
    elseif l_dungeonsType == DungeonType.DungeonAvoid or
            l_dungeonsType == DungeonType.DungeonBeach or
            l_dungeonsType == DungeonType.DungeonsBlackHouse or
            l_dungeonsType == DungeonType.DungeonWorldPve or
            l_dungeonsType == DungeonType.DungeonGuildHunt then
        --转职试炼 躲避球 小黑屋 任务副本 公会狩猎
        MgrMgr:GetMgr("ThemeDungeonMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonArena or
            l_dungeonsType == DungeonType.DungeonPvp then
        -- 擂台
        MgrMgr:GetMgr("ArenaMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonHero then
        MgrMgr:GetMgr("HeroChallengeMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.TowerDefenseSingle or l_dungeonsType == DungeonType.TowerDefenseDouble then
        MgrMgr:GetMgr("TowerDefenseMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonMaze then
        MgrMgr:GetMgr("MazeDungeonMgr").OnDungeonsResult(msg)
    elseif l_dungeonsType == DungeonType.DungeonGuildMatch then
        MgrMgr:GetMgr("GuildMatchMgr").OnDungeonsResult(msg)
    end
end

--------------------------------副本结算相关--------------------------------------
-- 离开副本
function LeaveDungeon()
    local l_msgId = Network.Define.Ptc.LeaveSceneReq
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function SendLeaveSceneReq()
    ---发送离开场景

    local l_tips = Lang("DUNGEON_COMFIRM_QUIT")
    -- local stageEnum = StageMgr:GetCurStageEnum()
    -- if stageEnum == MStageEnum.BattlePre then
    --     local l_teamInfo = MgrMgr:GetMgr("TeamMgr").myTeamInfo
    --     --if l_teamInfo.isInTeam and MPlayerInfo.UID:tostring() ~= l_teamInfo.captainId then
    --     if l_teamInfo.isInTeam then
    --         l_tips = Common.Utils.Lang("BATTLE_PRE_TIPS")
    --     end
    -- end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_tips, function()
        LeaveDungeon()
    end, nil, nil, nil, nil, nil, CommonUI.Dialog.DialogTopic.DUNGEON_QUIT)
end

function SendLeaveSceneReqWithFunc(okFunc)
    ---发送离开场景
    local l_tips = Lang("DUNGEON_COMFIRM_QUIT")
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_tips, function()
        LeaveDungeon()
        okFunc()
    end, nil, nil, nil, nil, nil, CommonUI.Dialog.DialogTopic.DUNGEON_QUIT)
end


-- 是否在某个副本中
function CheckPlayerInDungeon(dungeonId)
    if dungeonId == nil or dungeonId == 0 then
        return MPlayerDungeonsInfo.InDungeon
    end
    return MPlayerInfo.PlayerDungeonsInfo.DungeonID == dungeonId
end

-- 是否在镜像副本中
function CheckPlayerInCopyDungeon(...)
    local l_dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    if l_dungeonID > 0 then
        local l_dungeonTableData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonID)
        if l_dungeonTableData == nil then
            return false
        end
        if l_dungeonTableData.DungeonsType == DungeonType.DungeonMirror then
            return true
        end
    end
    return false
end

------------------------------副本提示-----------------------------------------------
function OnShowLoading()
    cacheMessageId = -1
    isLoading = false
end

function OnHideLoading()
    isLoading = true
    if cacheMessageId ~= -1 then
        MgrMgr:GetMgr("MessageRouterMgr").OnMessage(cacheMessageId)
        cacheMessageId = -1
    end
end



--客户端通知副本打开叙事性文本
function OnThemeDungeonsPrompt(luaType, messageId)
    if not UIMgr:IsActiveUI(UI.CtrlNames.DungenAlarm) then
        -- message_id = messageId
    end
    MgrMgr:GetMgr("MessageRouterMgr").OnMessage(messageId)
end

function OnUpdateLeftTime(msg)
    ---@type DungeonsUpdateNotifyInfo
    local l_info = ParseProtoBufToTable("DungeonsUpdateNotifyInfo", msg)

    local l_dungeonsType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    if l_dungeonsType == DungeonType.DungeonDoubleCook then
        MCookingMgr:AddExtraTime(l_info.lose_extra_time)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_EXTRA_COOK_TIME", l_info.lose_extra_time))
    end
end

--副本剩余怪物统计功能
function OnUpdateMonsterNum(luaType, num, changeValue)
    --这里主要是动态推送 静态取值直接用 MPlayerInfo.PlayerDungeonsInfo.LeftMonster
    EventDispatcher:Dispatch(ON_UPDATE_MONSTER_NUM, num, changeValue)
end

function SetIsAssist(state)
    local l_msgId = Network.Define.Rpc.IsAssist
    ---@type IsAssistArg
    local l_sendInfo = GetProtoBufSendTable("IsAssistArg")
    l_sendInfo.is_assist = state
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ShowAssistDayTips()
    local todayDateNum = tostring(math.ceil(Common.TimeMgr.GetUtcTimeByTimeTable() / 86400))
    local saveDateString = tostring(MPlayerInfo.UID) .. "AssistDay"
    local localTodayNum = UnityEngine.PlayerPrefs.GetString(saveDateString)
    local getLimitNum = MgrMgr:GetMgr("LimitBuyMgr").GetLimitByKey(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ASSISTDAY, '701')
    local showTipsStr = StringEx.Format(Common.Utils.Lang("GET_MAX_ASSIST_DAY"), getLimitNum)

    --每天的第一次弹出
    if localTodayNum == "" or todayDateNum ~= localTodayNum then
        UnityEngine.PlayerPrefs.SetString(saveDateString, todayDateNum)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(showTipsStr)
        return
    end
    ShowSystemChannelTips(showTipsStr)
end

function ShowAssistWeekTips()
    local todayDateNum = tostring(math.ceil(Common.TimeMgr.GetUtcTimeByTimeTable() / 604800))
    local saveDateString = tostring(MPlayerInfo.UID) .. "AssistWeek"
    local localTodayNum = UnityEngine.PlayerPrefs.GetString(saveDateString)
    local getLimitNum = MgrMgr:GetMgr("LimitBuyMgr").GetLimitByKey(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ASSISTWEEK, '701')
    local showTipsStr = StringEx.Format(Common.Utils.Lang("GET_MAX_ASSIST_WEEK"), getLimitNum)

    --每周的第一次弹出
    if localTodayNum == "" or todayDateNum ~= localTodayNum then
        UnityEngine.PlayerPrefs.SetString(saveDateString, todayDateNum)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang(showTipsStr))
        return
    end
    ShowSystemChannelTips(showTipsStr)
end

function ShowSystemChannelTips(str)
    if str == nil then
        return
    end
    MgrMgr:GetMgr("ChatMgr").DoHandleMsgNtf(nil, DataMgr:GetData("ChatData").EChannel.SystemChat, str, nil, nil, false)
end

--新手副本召唤怪物
function OnSceneTriggerArgs(groupId, triggerId, timimgType)
    local l_msgId = Network.Define.Rpc.SceneTriggerSummonMonster
    ---@type OnSceneTriggerArg
    local l_sendInfo = GetProtoBufSendTable("OnSceneTriggerArg")
    l_sendInfo.group_id = groupId
    l_sendInfo.trigger_id = triggerId
    l_sendInfo.timing_type = timimgType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function GetTempMonsterEntityTb()
    local allEntity = MEntityMgr:GetEnemyMEntities()
    local entityTb = {}
    for z = 0, allEntity.Count - 1 do
        local attr = allEntity[z].AttrComp
        table.insert(entityTb, attr)
    end
    return entityTb
end

function SetThreeToThreeMode(state)
    if IsTempTeamMode == state then
        return
    end
    IsTempTeamMode = state
    if state then
        EventDispatcher:Dispatch(CONFIRM_THREE_TO_THREE)
    else
        EventDispatcher:Dispatch(CANCLE_THREE_TO_THREE)
    end
end

-- 进副本之后判断当前副本是否是3V3副本 并设置组队模式为3V3自定义数据模式
function SetToThreeToThreeDungeonsMode()
    local threeToThreeDungeonIds = MGlobalConfig:GetSequenceOrVectorInt("ThreeToThreeDungeonIds")
    local isThreeToThreeMode = false
    for i = 1, threeToThreeDungeonIds.Length do
        if threeToThreeDungeonIds[i - 1] == MPlayerDungeonsInfo.DungeonID then
            isThreeToThreeMode = true
            break
        end
    end
    if isThreeToThreeMode then
        SetThreeToThreeMode(true)
    end
end

function OnCutSceneStop(id)
    if MPlayerDungeonsInfo and MPlayerDungeonsInfo.DungeonID > 0 then
        local l_data = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)

        if l_data == nil then
            return
        end
        if l_data.NumbersLimit == nil then
            return
        end
        if l_data.NumbersLimit[0] == 1 and l_data.NumbersLimit[1] == 1 then
            local l_msgId = Network.Define.Ptc.SingleTimeLineEnd
            ---@type SingleTimeLineData
            local l_sendInfo = GetProtoBufSendTable("SingleTimeLineData")
            l_sendInfo.timelineid = id
            Network.Handler.SendPtc(l_msgId, l_sendInfo)
        end
    end
end

function OnEnterDungeon()
    EventDispatcher:Dispatch(ENTER_DUNGEON)
    MgrMgr:GetMgr("MercenaryMgr").OnEnterDungeon()
end

function OnLeaveDungeon()
    MgrMgr:GetMgr("DungeonTargetMgr").l_targetInfo = {}
    MgrMgr:GetMgr("DungeonTargetMgr").l_id = nil
    --圣歌试炼离开场景时 关闭圣歌试炼信息界面
    if MPlayerInfo.PlayerDungeonsInfo.DungeonType == DungeonType.DungeonHymn then
        MgrMgr:GetMgr("HymnTrialMgr").InitLog()  --缓存清理
        UIMgr:DeActiveUI(UI.CtrlNames.HymnTrialInfo)
    elseif MPlayerInfo.PlayerDungeonsInfo.DungeonType == DungeonType.DungeonBeach then
        MgrMgr:GetMgr("BeachMgr").EndBeach()
    end
    EventDispatcher:Dispatch(EXIT_DUNGEON)
end


---------------------------------协议处理-------------------------------------
-- 请求进入副本失败
function OnFailEnterFBNtf(msg)
    ---@type FailEnterFBData
    local l_info = ParseProtoBufToTable("FailEnterFBData", msg)
    if l_info.reason == 0 then
        return
    end
    local l_tips
    if l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_ITEM_NOT_ENOUGH then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_ITEM_NOT_ENOUGH")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_FORMER_CHAPTER_UNLOCK then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_FORMER_CHAPTER_UNLOCK")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_TASK_ERROR then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_TASK_ERROR")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_LEVEL_ERROR then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_LEVEL_ERROR")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_TIMES_LIMIT then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_TIMES_LIMIT")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_MEMBER_NUMBER then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_MEMBER_NUMBER")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_IN_DUNGEONS then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_IN_DUNGEONS")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_SCENE_FAILED then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_SCENE_FAILED")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_REQUEST_TOO_FAST then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_REQUEST_TOO_FAST")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FN_TIMEOUT then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FN_TIMEOUT")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_COOK_DUNGEON_TIME_LIMIT then
        local l_name = DataMgr:GetData("TeamData").GetNameById(l_info.uid) or ""
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_COOK_DUNGEON_TIME_LIMIT", l_name)
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_SOMEONE_LEAVE_WAITING_SCENE then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_SOMEONE_LEAVE_WAITING_SCENE")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_BANNED or
            l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_NUMBER_FEW or
            l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_NUMBER_MANY or
            l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_LEVEL_FEW or
            l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_LEVEL_MANY then
        local l_str = Common.Utils.Lang("FAIL_ENTER_" .. tostring(l_info.reason))
        l_tips = StringEx.Format(l_str, l_info.param)
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_DEAD then
        local l_name = DataMgr:GetData("TeamData").GetNameById(l_info.uid) or ""
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_DEAD", l_name)
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_NOT_IN_TEAM then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_NOT_IN_TEAM")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_IN_VEHICLE then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_IN_VEHICLE")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_SELF_IN_DUNGEONS then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_SELF_IN_DUNGEONS")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_RUN_BUSINESS then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_RUN_BUSINESS")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_CHECK_STATE then
        --状态互斥判断 这个不显示
        return
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_SYSTEM_NOT_OPENED then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_SYSTEM_NOT_OPENED")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_PRE_WAVE then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_PRE_WAVE", MgrMgr:GetMgr("TowerDefenseMgr").TdCoopModeEntryWaves)
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_NOT_ACTIVITY then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_NOT_ACTIVITY")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_FAIL then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_FAIL")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_CURR_SCENE_NOT_ALLOW then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_SCENE_CANT_IN")
    elseif l_info.reason == FailEnterFBReason.FAIL_ENTER_FB_MEMBER_IN_SCENE then
        l_tips = Common.Utils.Lang("FAIL_ENTER_FB_MEMBER_IN_DUNGEON")
    end
    if l_tips == nil then
        local l_key = "FAIL_ENTER_" .. tostring(l_info.reason)
        l_tips = Common.Utils.Lang(l_key)
        -- 说明没配置
        if l_key == l_tips then
            logError(l_key .. "对应的错误码没处理")
            l_tips = Common.Utils.Lang("FAIL_ENTER_N7") .. tostring(l_info.reason)
        end
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
end


-- 通知队员选择
function OnAskMemberEnterFBNtf(msg)
    ---@type AskMemberEnterFBData
    local l_info = ParseProtoBufToTable("AskMemberEnterFBData", msg)
    DefaultAssist = l_info.assist
    if l_info.dungeon_id ~= 0 then
        AskEnterDungeon(l_info.dungeon_id)
    else
        AskEnterScene(l_info.scene_id)
    end
end

function AskEnterDungeon(dungeonId)
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId)
    if not l_dungeonData then
        logError("[OnAskMemberEnterFBNtf]not find dungeonData,id:" .. tostring(dungeonId))
        return
    end
    --当你不在主城且不在公会场景中时，拦截
    if MPlayerInfo.PlayerDungeonsInfo.DungeonID ~= 0 and MPlayerInfo.PlayerDungeonsInfo.DungeonID ~= 29 then
        return
    end
    TeamCheckStartTime = Time.realtimeSinceStartup
    dungeonName = l_dungeonData.DungeonsName
    InitInfo()
    DataMgr:GetData("ThemeDungeonData").DumpTeamInfo()
    IsThemeDungeonTeamBtnClicked = false
    UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonTeam, { dungeonID = dungeonId })
end

function AskEnterScene(sceneId)
    local l_sceneData = TableUtil.GetSceneTable().GetRowByID(sceneId)
    if not l_sceneData then
        logError("[OnAskMemberEnterFBNtf]not find sceneData,id:" .. tostring(sceneId))
        return
    end

    TeamCheckStartTime = Time.realtimeSinceStartup
    dungeonName = l_sceneData.Comment
    InitInfo()
    DataMgr:GetData("ThemeDungeonData").DumpTeamInfo()
    IsThemeDungeonTeamBtnClicked = false

    UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonTeam, { sceneID = sceneId })
end

local ai_sync_func = {}

-- 更新副本进度条
ai_sync_func["UpdateDungeonBar"] = function(info)

    local UIBarCur = 0
    local UIBarLast = 0
    local UIBarTime = 0
    local UIBarName = ""
    local UIBarColorOrder = ""

    for i = 1, #info.key_list do
        if info.key_list[i] == "UIBarCur" then
            UIBarCur = tonumber(info.value_list[i])
        end
        if info.key_list[i] == "UIBarLast" then
            UIBarLast = tonumber(info.value_list[i])
        end
        if info.key_list[i] == "UIBarTimeInterval" then
            UIBarTime = tonumber(info.value_list[i])
        end
        if info.key_list[i] == "UIBarName" then
            UIBarName = info.value_list[i]
        end
        if info.key_list[i] == "UIBarColorOrder" then
            UIBarColorOrder = info.value_list[i]
        end
    end
    local l_uiBarName = ""
    if UIBarName ~= "" then
        l_uiBarName = Lang(UIBarName)
    end

    IsSliderShow = true
    --副本进度条处理
    local l_ui = UIMgr:GetUI(UI.CtrlNames.DungeonExtend)
    if l_ui then
        l_ui:InitPrayDungeons(UIBarCur / 100, UIBarLast / 100, UIBarTime, l_uiBarName, UIBarColorOrder == "RedToGreen")
    else
        UIMgr:ActiveUI(UI.CtrlNames.DungeonExtend, function(ctrl)
            ctrl:InitPrayDungeons(UIBarCur / 100, UIBarLast / 100, UIBarTime, l_uiBarName, UIBarColorOrder == "RedToGreen")
        end)
    end
end

ai_sync_func["CloseDungeonBar"] = function(info)
    UIMgr:DeActiveUI(UI.CtrlNames.DungeonExtend)
end

ai_sync_func["DoCommand"] = function(info)
    CommandBlock.OpenAndRunBlock(info.value_list[1], info.value_list[2])
end

-- AI数据同步给Lua的通用协议
-- key_list 里的第一个为 方法名，要调用的方法程序统一加上前缀 "OnAISync_"
function OnAISyncVarListNtf(msg)
    --print("OnAISyncVarListNtf")
    ---@type AISyncVarData
    local l_info = ParseProtoBufToTable("AISyncVarData", msg)
    --local l_AISyncType = l_info.ai_sync_type
    --logError(ToString(l_info))
    --print(l_AISyncType)
    --for k, v in pairs(l_info.key_list) do
    --    print (k, v)
    --end
    local l_funcName = l_info.key_list[1]
    local l_func = ai_sync_func[l_funcName]
    if l_func ~= nil then
        l_func(l_info)
    else
        logError("[AISceneSyncVarList], [" .. l_info.key_list[1] .. "], can't find this function @策划")
    end
    --for i = 1, #l_info.key_list do
    --    if l_info.key_list[i] == "UpdateDungeonBar" then
    --        UpdateDungeonBar(l_info)
    --        return
    --    elseif l_info.key_list[i] == "CloseDungeonBar" then
    --        UIMgr:DeActiveUI(UI.CtrlNames.DungeonExtend)
    --        return
    --    end
    --end
end

function OnEnterSceneAddPointCheck(sceneId)
    if sceneId == nil then
        return
    end
    if sceneId >= ADDPOINT_SCENEID or sceneId <= ADDPOINT_SCENEID + 5 then
        local l_target650Data = MgrMgr:GetMgr("DungeonTargetMgr").GetDungeonTargetInfo(DUNGEON_TARGET_ADDPOINT_1)
        local l_target652Data = MgrMgr:GetMgr("DungeonTargetMgr").GetDungeonTargetInfo(DUNGEON_TARGET_ADDPOINT_2)
        if (l_target650Data and l_target650Data.cur_step < l_target650Data.total_count) or
                (l_target652Data and l_target652Data.cur_step < l_target652Data.total_count) then
            IsAddPoint = true
            IsIgnoreFirst = l_target652Data ~= nil
            UIMgr:ActiveUI(UI.CtrlNames.DungeonExtend, function(l_ui)
                l_ui:InitAddPointDungeons()
            end)
        end
    end
end

function OnAttrRaisedNotify(msg)
    ---@type AttrRaisedArg
    local l_info = ParseProtoBufToTable("AttrRaisedArg", msg)
    IsAddPoint = l_info.enable
    local l_ui = UIMgr:GetUI(UI.CtrlNames.DungeonExtend)
    if l_info.enable then
        ShowAttrRiseTime = ShowAttrRiseTime + 1
        local activeUIFunc = function()
            if l_ui then
                l_ui:InitAddPointDungeons()
            else
                UIMgr:ActiveUI(UI.CtrlNames.DungeonExtend, function(ctrl)
                    ctrl:InitAddPointDungeons()
                end)
            end
        end
        --[[
        if ShowAttrRiseTime == 1 then
            MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(10001, activeUIFunc)
        elseif ShowAttrRiseTime == 2 then
            MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(10002, activeUIFunc)
        else
            activeUIFunc()
        end
        ]]--
        activeUIFunc()
    else
        if l_ui then
            l_ui:CloseAddPoint()
        end
    end
end

function OnBossTimeline(msg)
    ---@type BossTimelineData
    local l_info = ParseProtoBufToTable("BossTimelineData", msg)
    local l_name = l_info.timeline_name
    --UIMgr:DeActiveAllPanels()
    MCutSceneMgr:PlayImm(l_name, DirectorWrapMode.Hold, function()
        game:ShowMainPanel()
        MPlayerInfo:FocusToMyPlayer()
    end)
end

function OnShowCutSceneNtf(msg)
    ---@type CutSceneData
    local l_info = ParseProtoBufToTable("CutSceneData", msg)
    local l_id = l_info.id
    MCutSceneMgr:PlayImmById(l_id, DirectorWrapMode.Hold, function()
        MPlayerInfo:FocusToMyPlayer()
    end)
end

function OnFollowOutRangeNft(msg)
    ---@type FollowOutRangeNftData
    local l_info = ParseProtoBufToTable("FollowOutRangeNftData", msg)
    local l_state = 1 == l_info.out_or_in
    if l_state then
        if not UIMgr:IsActiveUI(UI.CtrlNames.Follow) then
            UIMgr:ActiveUI(UI.CtrlNames.Follow)
        end
    else
        if UIMgr:IsActiveUI(UI.CtrlNames.Follow) then
            UIMgr:DeActiveUI(UI.CtrlNames.Follow)
        end
    end
end

--请求获取副本怪物列表
function RequestDungeonsMonster()
    local l_msgId = Network.Define.Rpc.GetDungeonsMonster
    ---@type GetDungeonsMonsterArg
    local l_sendInfo = GetProtoBufSendTable("GetDungeonsMonsterArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取副本怪物列表
function OnGetDungeonsMonster(msg)
    ---@type GetDungeonsMonsterRes
    local l_info = ParseProtoBufToTable("GetDungeonsMonsterRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    local l_monsters = l_info.data.monsters
    for i, v in ipairs(l_monsters) do
        monsterInfo[v.dungeons_id] = v.monster_ids
    end
    EventDispatcher:Dispatch(DUNGEON_MONSTERS_REFRESH)
end

function OnGetSceneTriggerRes(msg)
    ---@type OnSceneTriggerRes
    local l_info = ParseProtoBufToTable("OnSceneTriggerRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips("成功")
    end
end

function OnDungeonsPrompt(msg)
    ---@type DungeonsPromptData
    local l_info = ParseProtoBufToTable("DungeonsPromptData", msg)
    local l_id = l_info.message_id
    if not UIMgr:IsActiveUI(UI.CtrlNames.DungenAlarm) then
        -- message_id = l_id
    end
    if isLoading then
        MgrMgr:GetMgr("MessageRouterMgr").OnMessage(l_id)
    else
        cacheMessageId = l_id
    end
end


-- 发送点赞
function SendDungeonsEncourage(roleId)
    local l_msgId = Network.Define.Ptc.DungeonsEncourage
    ---@type DungeonsEncourageData
    local l_sendInfo = GetProtoBufSendTable("DungeonsEncourageData")
    l_sendInfo.dest_role_id = roleId
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--收到点赞事件
function OnNotifyDungeonsEncourage(msg)
    ---@type DungeonsEncourageData
    local l_info = ParseProtoBufToTable("DungeonsEncourageData", msg)
    EventDispatcher:Dispatch(UPDATE_ENCOURAGE_NUM, l_info.dest_role_id)
    --被点赞的人不是自己或者如果自己点赞自己都不谈提示
    if tostring(l_info.dest_role_id) ~= tostring(MPlayerInfo.UID) or tostring(l_info.src_role_id) == tostring(MPlayerInfo.UID) then
        return
    end
    if tostring(l_info.src_role_id) == tostring(MPlayerInfo.UID) then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowItemPraiseNotice(l_info.src_role_id)
end

function OnSetIsAssist(msg)
    ---@type IsAssistRes
    local l_info = ParseProtoBufToTable("IsAssistRes", msg)
    if l_info.error.errorno ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error.errorno))
    end
end

-- 队员同意或拒绝
function SendMemberReplyEnterFBPtc(replyType)
    local l_msgId = Network.Define.Ptc.MemberReplyEnterFBPtc
    ---@type MemberReplyEnterFBData
    local l_sendInfo = GetProtoBufSendTable("MemberReplyEnterFBData")
    l_sendInfo.type = replyType
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

-- 同步其他队员的选择
function OnSyncMemberReplyEnterFBNtf(msg)
    ---@type SyncMemberReplyEnterFBData
    local l_info = ParseProtoBufToTable("SyncMemberReplyEnterFBData", msg)
    ---TODO
    if l_info.type == ReplyType.REPLY_TYPE_REFUSE then
        TeamCheckStartTime = nil
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(DataMgr:GetData("TeamData").GetNameById(l_info.uid) .. Common.Utils.Lang("REPLY_TYPE_REFUSE"))
        return
    end
    for i, v in ipairs(g_teamInfo) do
        if v.roleId == l_info.uid then
            v.state = l_info.type
            EventDispatcher:Dispatch(SYNC_MEMBER_REPLY_ENTER_FB_NTF, v.roleId)
            return
        end
    end
end

--加点副本加点
function OnAttrRaisedArg(num, enable)
    local l_msgId = Network.Define.Rpc.AttrRaisedChoose
    ---@type AttrRaisedArg
    local l_sendInfo = GetProtoBufSendTable("AttrRaisedArg")
    l_sendInfo.num = num
    l_sendInfo.enable = enable
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnAttrRaisedChooseRes(msg)
    ---@type AttrRaisedRes
    local l_info = ParseProtoBufToTable("AttrRaisedRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end


---------------------------------对外接口--------------------------------------
--返回副本开始时间
function GetDungeonsStartTime()
    return DungeonStartTime
end

function SetDungeonsStartTime(time)
    DungeonStartTime = time
end

--返回副本结算标记
function GetDungeonResult()
    return isDungeonResultProcessed
end

--返回副本内玩法房间开始时间
function GetDungeonsRoomStartTime()
    return RoomStartTime
end


-- 副本已经流逝的时间
function GetDungeonsPassTime()
    ---断线重连
    if not MEntityMgr.PlayerEntity then
        return 0
    end
    local l_beginTime = MLuaCommonHelper.Int(MEntityMgr.PlayerEntity.DungeonsBegainTime)
    local l_curTime = MLuaCommonHelper.Int(MServerTimeMgr.UtcSeconds)
    local l_delay = 0
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        local _, l_tmp = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorDelay(MPlayerDungeonsInfo.DungeonID)
        l_delay = l_tmp or 0
    end

    return l_curTime - l_beginTime - l_delay
end


--显示副本提示信息,EMessageRouterType[23, 27]
function ShowDungeonHints(id, msgType, content, isClose)
    local l_mrMgr = MgrMgr:GetMgr("MessageRouterMgr")
    --副本持续提示显示在normal层
    if msgType == l_mrMgr.EMessageRouterType.DungeonHintLastWarning or msgType == l_mrMgr.EMessageRouterType.DungeonHintLastAuxiliary then
        if not (not UIMgr:IsActiveUI(UI.CtrlNames.DungeonHintNormal) and isClose) then
            UIMgr:ActiveUI(UI.CtrlNames.DungeonHintNormal, function(ctrl)
                ctrl:ShowDungeonHints(id, msgType, content, isClose)
            end)
        end
    else
        UIMgr:ActiveUI(UI.CtrlNames.TipsDlg, function(ctrl)
            ctrl:ShowDungeonHints(id, msgType, content, isClose)
        end)
    end
end

function ReSetDungeonExtendData()
    if IsTransferProfession then
        --如果是从新手体验副本出来 打开体验界面
        UIMgr:ActiveUI(UI.CtrlNames.JobPreview)
    end
    IsTransferProfession = false
    IsSliderShow = false
    IsAddPoint = false
    ShowAttrRiseTime = 0
    SetThreeToThreeMode(false)
    RecommendTable = {}
end

function ShowLifeHUD(id, currentShowCount, maxShowCount, uid, type)
    if not uid then
        uid = MPlayerInfo.UID
    end
    local l_dotHudTable = TableUtil.GetDotHudTable().GetRowByID(id)
    if l_dotHudTable == nil then
        return
    end
    if not type then
        type = l_dotHudTable.Type
    end
    local l_position = Vector3.New(l_dotHudTable.Position[0], l_dotHudTable.Position[1], l_dotHudTable.Position[2])
    --图片的大小
    local l_spriteSize = Vector2.New(l_dotHudTable.SpriteSize[0], l_dotHudTable.SpriteSize[1])
    --每一行的个数
    local l_perRowCount = l_dotHudTable.DotsPerRow
    --图片的间隔
    local l_spriteSpace = l_dotHudTable.HorizontalSpacing
    --竖向的间隔
    local l_verticalSpacing = l_dotHudTable.VerticalSpacing
    --总个数
    local l_maxShowCount
    if maxShowCount then
        l_maxShowCount = maxShowCount
    else
        l_maxShowCount = l_dotHudTable.MaxShowCount
    end
    --初始的位置
    local l_spriteInitialOffset = -((l_perRowCount - 1) / 2 * l_spriteSpace)
    --当前显示的个数
    local l_currentShowCount = currentShowCount

    local l_hudTextData = MoonClient.HUDTextData.Get()

    --图片数据
    if type == DungeonLifeHudType.Icon then
        local l_hudSpriteDatas = {}
        for i = 1, l_maxShowCount do
            local l_index = i - 1
            if l_currentShowCount >= i then
                local l_hudSpriteData = MoonClient.HUDSpriteData.Get()
                l_hudSpriteData.spriteName = MoonSerializable.HUDMesh.ESpriteName.LifeIcon
                l_hudSpriteData.size = l_spriteSize
                l_hudSpriteData.offsetX = l_spriteInitialOffset + l_spriteSpace * ((l_index % l_perRowCount))
                l_hudSpriteData.offsetY = math.floor(l_index / l_perRowCount) * l_verticalSpacing
                table.insert(l_hudSpriteDatas, l_hudSpriteData)
            else
                local l_hudSpriteDataBg = MoonClient.HUDSpriteData.Get()
                l_hudSpriteDataBg.spriteName = MoonSerializable.HUDMesh.ESpriteName.LifeIconBg
                l_hudSpriteDataBg.size = l_spriteSize
                l_hudSpriteDataBg.offsetX = l_spriteInitialOffset + l_spriteSpace * ((l_index % l_perRowCount))
                l_hudSpriteDataBg.offsetY = math.floor(l_index / l_perRowCount) * l_verticalSpacing
                table.insert(l_hudSpriteDatas, l_hudSpriteDataBg)
            end
        end
        l_hudTextData.Text = ""
        MLuaClientHelper.ShowTextAndSpriteHUD(uid, true, l_position, l_hudSpriteDatas, l_hudTextData)
        for i = 1, #l_hudSpriteDatas do
            MoonClient.HUDSpriteData.Release(l_hudSpriteDatas[i])
        end
    elseif type == DungeonLifeHudType.Text then
        local l_hudSpriteDatas = {}
        local l_hudSpriteData = MoonClient.HUDSpriteData.Get()
        l_hudSpriteData.spriteName = MoonSerializable.HUDMesh.ESpriteName.LifeIcon
        l_hudSpriteData.size = l_spriteSize
        l_hudSpriteData.offsetX = l_spriteInitialOffset + l_spriteSpace * 1.5
        l_hudSpriteData.offsetY = 0
        table.insert(l_hudSpriteDatas, l_hudSpriteData)

        l_hudTextData.Text = "   " .. currentShowCount
        l_hudTextData.TextColor = Color.white
        l_hudTextData.OffsetY = 2

        MLuaClientHelper.ShowTextAndSpriteHUD(uid, true, l_position, l_hudSpriteDatas, l_hudTextData)
        for i = 1, #l_hudSpriteDatas do
            MoonClient.HUDSpriteData.Release(l_hudSpriteDatas[i])
        end
    end

    if l_hudTextData then
        MoonClient.HUDTextData.Release(l_hudTextData)
    end

end

function HideLifeHUD(uid)
    if not uid then
        uid = MPlayerInfo.UID
    end
    MLuaClientHelper.ShowTextAndSpriteHUD(uid, false, Vector3.zero, nil, nil)
end


-- 进入副本
-- @param dungeonId，副本ID
-- @param chapterId
-- @param degree，难度
-- @return
function EnterDungeons(dungeonId, chapterId, degree)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.ThemeDungeonTeam)
    if l_ui and l_ui.isActive then
        return
    end
    local l_dungeonInfo = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId)
    if not l_dungeonInfo then
        logError("[DungeonMgr]can not find dungeon,id:" .. tostring(dungeonId))
        return
    end
    local l_numMax = 1000
    local l_numMin = 1
    local l_levelMax = 1000
    local l_levelMin = 1
    local l_taskId = nil
    local l_taskState = nil
    local l_hasTeam = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList) > 0
    local l_teamNum = 0
    local l_isCaptain = false
    if l_hasTeam then
        l_teamNum = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList)
        l_isCaptain = MPlayerInfo.UID:tostring() == tostring(DataMgr:GetData("TeamData").myTeamInfo.captainId)
    end
    local l_levelInfo = Common.Functions.SequenceToTable(l_dungeonInfo.LevelLimit)
    if l_levelInfo then
        l_levelMin = l_levelInfo[1]
        l_levelMax = l_levelInfo[2]
    end
    local l_taskInfo = Common.Functions.SequenceToTable(l_dungeonInfo.NeedTask)
    if l_taskInfo then
        l_taskId = l_taskInfo[1]
        l_taskState = l_taskInfo[2]
    end
    local l_numInfo = Common.Functions.SequenceToTable(l_dungeonInfo.NumbersLimit)
    if l_numInfo then
        l_numMin = l_numInfo[1]
        l_numMax = l_numInfo[2]
    end
    if l_numMin == 1 and l_numMax == 1 then
        local l_msgId = Network.Define.Ptc.CaptainRequestEnterFBPtc
        ---@type CaptainRequestEnterFBData
        local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterFBData")
        l_sendInfo.dungeon_id = dungeonId
        l_sendInfo.chapter_id = chapterId
        l_sendInfo.dungeons_degree = degree
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
        return
    end
    local l_enterType = l_dungeonInfo.EnterType
    if 1 == l_enterType or (l_numMin <= 1 and not l_hasTeam) then
        if MPlayerInfo.Lv < l_levelMin or MPlayerInfo.Lv > l_levelMax then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DUNGEON_LIMIT_LEVEL", l_levelMin))
            return
        end
        -- local l_msgId = Network.Define.Ptc.EnterDungeons
        -- local l_sendInfo = PbcMgr.get_pbc_scene_pb().EnterDungeonsData()
        -- l_sendInfo.dungeons_id = dungeonId
        -- l_sendInfo.role_id = MPlayerInfo.UID:tostring()
        -- Network.Handler.SendPtc(l_msgId, l_sendInfo)
        local l_msgId = Network.Define.Ptc.CaptainRequestEnterFBPtc
        ---@type CaptainRequestEnterFBData
        local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterFBData")
        l_sendInfo.dungeon_id = dungeonId
        l_sendInfo.chapter_id = chapterId
        l_sendInfo.dungeons_degree = degree
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
        return
    end
    if not l_hasTeam then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_IN_TEAM"))
        return
    end
    if not l_isCaptain then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DUNGEON_LEADER_NOT_MEET"))
        return
    end

    if not MGameContext.IsOpenGM then
        if l_teamNum < l_numMin then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DUNGEON_LIMIT_NUMMIN", l_numMin))
            return
        end
        if l_teamNum > l_numMax then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DUNGEON_LIMIT_NUMMAX", l_numMax))
            return
        end
    end

    if MPlayerInfo.Lv < l_levelMin or MPlayerInfo.Lv > l_levelMax then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DUNGEON_LIMIT_LEVEL", l_levelMin))
        return
    end
    for i, v in pairs(DataMgr:GetData("TeamData").myTeamInfo.memberList) do
        if v.roleLevel < l_levelMin then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TEAMPLAYER_LEVEL_LIMIT"), v.roleName, l_levelMin))
            return
        end
        if v.roleLevel > l_levelMax then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("DUNGEON_LIMIT_NUMLEVEL"), v.roleName))
            return
        end
    end
    local l_msgId = Network.Define.Ptc.CaptainRequestEnterFBPtc
    ---@type CaptainRequestEnterFBData
    local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterFBData")
    l_sendInfo.dungeon_id = dungeonId
    l_sendInfo.chapter_id = chapterId
    l_sendInfo.dungeons_degree = degree
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--展示副本剩余时间
function ShowLeftTimer()
    if MPlayerDungeonsInfo and MPlayerDungeonsInfo.DungeonID > 0 then
        if isResulted then
            --已结算过得副本只有 镜像副本和主题副本需要倒计时
            --还有公会狩猎
            if MPlayerDungeonsInfo.DungeonType == DungeonType.DungeonMirror
                    or MPlayerDungeonsInfo.DungeonType == DungeonType.DungeonTheme
                    or MPlayerDungeonsInfo.DungeonType == DungeonType.DungeonGuildHunt then

                if DungeonRemainTime > 0 then
                    local l_data = {
                        startTime = MServerTimeMgr.UtcSeconds,
                        remainTime = DungeonRemainTime,
                        isShowToBtnExit = true
                    }
                    UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
                end

            end
        else
            --未结算的副本 需要根据一些条件判断是否显示倒计时
            local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
            if l_dungeonData then
                --防止和擂台、烹饪副本冲突 这两类副本不适用倒计时
                if MPlayerDungeonsInfo.DungeonID > 6100 then
                    return
                end
                --判断是否是需要显示倒计时的类型
                if l_dungeonData.TimeLimit and l_dungeonData.TimeLimit[0] == 2 then
                    local l_data = {
                        startTime = DungeonStartTime,
                        remainTime = l_dungeonData.TimeLimit[1],
                        tipText = Lang("DUNGEON_REMAIN_TIME_TIP"),
                        numColor = Color.New(136 / 255.0, 230 / 255.0, 67 / 255.0),
                        isShowToBtnExit = true
                    }
                    UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
                end
            end
        end
    end
end

-- 获取副本中的怪物列表
function GetDungeonsMonster(dungeonsId)
    local monsters = monsterInfo[dungeonsId]
    local l_result = {}
    if monsters == nil then
        return l_result
    end
    for k, v in pairs(monsters) do
        if v ~= nil and v.value ~= nil then
            table.insert(l_result, v.value)
        end
    end
    return l_result
end

function IsInDungeons()
    if MPlayerInfo.PlayerDungeonsInfo == nil then
        return false
    end
    if MPlayerInfo.PlayerDungeonsInfo.DungeonType == DungeonType.None then
        return false
    end
    return true
end

return ModuleMgr.DungeonMgr