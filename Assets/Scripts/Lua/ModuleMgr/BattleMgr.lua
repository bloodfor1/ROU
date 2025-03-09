---
--- Created by chauncyhu.
--- DateTime: 2018/6/12 10:56
---
---@module ModuleMgr.BattleMgr
module("ModuleMgr.BattleMgr", package.seeall)

g_fight1 = MLuaClientHelper.GetROGameLibsEnumValue(ROGameLibs.FightGroupType.kFightPVPCamp1)
g_fight2 = MLuaClientHelper.GetROGameLibsEnumValue(ROGameLibs.FightGroupType.kFightPVPCamp2)

m1 = 40001--7
m2 = 40002--8

s1 = 40003--7
s2 = 40004--8

p1 = 40005--7
p2 = 40006--8

k1 = 1004000501
k2 = 1004000601

l_playerFightGroup = nil
l_myDoorId = nil
l_myStoneId = nil
l_myFire = nil
l_mySkill = nil

l_targetDoorId = nil
l_targetStoneId = nil
l_targetFire = nil
l_targetSkill = nil

m_groupNum = {}

m_battleTime = 0
m_passTime = 0
m_type = nil

l_list = {}

g_BattleTex = nil
g_teamRequireNum = MGlobalConfig:GetInt("BgMinTeamSize")

--- 战场过程中数据
C_PARAM_TYPE_NAME_MAP = {
    [MLuaClientHelper.GetROGameLibsEnumValue(ROGameLibs.PVPType.PVP_PLAYER_KILL_NUM)] = "Kill",
    [MLuaClientHelper.GetROGameLibsEnumValue(ROGameLibs.PVPType.PVP_PLAYER_BE_KILLED_NUM)] = "Death",
    [MLuaClientHelper.GetROGameLibsEnumValue(ROGameLibs.PVPType.PVP_PLAYER_ASSIST_NUM)] = "AssistKill",
}

--- 对应的是global配置当中的key
---@type table<number, string>
C_BATTLE_TAG_TYPE_CONFIG_KEY_MAP = {
    [GameEnum.EBattleFieldTagType.MostKill] = "BgMaxKillIcon",
    [GameEnum.EBattleFieldTagType.MostDamage] = "BgMaxDamageIcon",
    [GameEnum.EBattleFieldTagType.MostAssist] = "BgMaxAssistIcon",
    [GameEnum.EBattleFieldTagType.MostHeal] = "BgMaxHealIcon",
}

--- 结算界面的标签图集名
C_BATTLE_SETTLE_ATLAS_NAME = "Settlement"

--- 战场数据调整
---@type table<number, table<uint64, BattleFieldKDA>>
_battleFieldCampData = {}
--- 曾经在这个机器上登陆过的玩家账号
---@type string[]
_battleGuideData = {}
--- 记录的最大账户数
C_MAX_ACCOUNT_NUM = 3
C_STR_BATTLE_FIELD_GUIDE_NAME = "account_battle_field_guide"
--- 战场结算数据，战场结算两边阵营的数据
---@type BattleFieldResultDataPack
g_campInfo = {}
--- 战场是否已经胜利
g_result = false
g_dailyBattleCount = 0 --记录战场阶段次数
--- 战场打完经过的时间
_battleFieldPassTime = 0

function OnInit()
    _loadBattleGuideData()
end

function OnReconnected(reconnectData)
    m_groupNum = {}
end

EventDispatcher = EventDispatcher.new()

ON_UPDATE_HP = "ON_UPDATE_HP"
ON_MONSTER_HP_UPDATE = "ON_MONSTER_HP_UPDATE"
ON_UPDATE_NUMBER = "ON_UPDATE_NUMBER"
ON_PI_PEI_SUCCESS = "ON_PI_PEI_SUCCESS"
ON_PI_PEI_START = "ON_PI_PEI_START"
ON_PI_PEI_STOP = "ON_PI_PEI_STOP"
ON_FIGHT_GROUP_CHANGE = "ON_FIGHT_GROUP_CHANGE"
ON_INIT_TIME_INFO = "ON_INIT_TIME_INFO"
ON_BATTLEFIELD_TEAM_REQUIRENUM_UPDATE = "ON_BATTLEFIELD_TEAM_REQUIRENUM_UPDATE"
ON_BATTLE_ENTER = "ON_BATTLE_ENTER"

function OnBattlefieldApply(l_info)

end

---==========================战场主ui============================================================

function InitTimeInfo()
    m_passTime = MgrMgr:GetMgr("DungeonMgr").GetDungeonsPassTime()
    local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
    if dungeonData and dungeonData.TimeLimit then
        local l_dataType = dungeonData.TimeLimit:get_Item(0)
        local l_dataSec = dungeonData.TimeLimit:get_Item(1)
        m_battleTime = l_dataSec
        m_type = l_dataType
    else
        m_battleTime = 0
        m_type = nil
    end
end

function OnInitTimeInfo(time)
    MgrMgr:GetMgr("DungeonMgr").SetDungeonsStartTime(time)
    EventDispatcher:Dispatch(ON_INIT_TIME_INFO)
end

---拿entity信息
function InitEntityInfo()
    --TODO:OnEnterScene时,PlayerEntitys是一定有的,这里没问题;
    l_playerFightGroup = MEntityMgr.PlayerEntity.AttrRole.FightGroup
    if l_playerFightGroup == g_fight1 then
        l_myDoorId = m1
        l_myStoneId = s1
        l_targetDoorId = m2
        l_targetStoneId = s2
        l_myFire = p1
        l_mySkill = k1
        l_targetFire = p2
        l_targetSkill = k2
        EventDispatcher:Dispatch(ON_FIGHT_GROUP_CHANGE)
        return
    end
    if l_playerFightGroup == g_fight2 then
        l_myDoorId = m2
        l_myStoneId = s2
        l_targetDoorId = m1
        l_targetStoneId = s1
        l_myFire = p2
        l_mySkill = k2
        l_targetFire = p1
        l_targetSkill = k1
        EventDispatcher:Dispatch(ON_FIGHT_GROUP_CHANGE)
        return
    end
    l_myDoorId = m1
    l_myStoneId = s1
    l_targetDoorId = m2
    l_targetStoneId = s2
    l_myFire = p1
    l_mySkill = k1
    l_targetFire = p2
    l_targetSkill = k2
    log("[BattleMgr]can not find fight group")
    EventDispatcher:Dispatch(ON_FIGHT_GROUP_CHANGE)
end

function OnUpdateMonsterHp(table, roleId, hpValue, entityId)
    EventDispatcher:Dispatch(ON_MONSTER_HP_UPDATE, roleId, hpValue, entityId)
end

function OnUpdateNumber(table, fightGroup, isNeutral, showTips)
    if m_groupNum[g_fight1] == nil then
        m_groupNum[g_fight1] = 0
    end
    if m_groupNum[g_fight2] == nil then
        m_groupNum[g_fight2] = 0
    end
    if fightGroup == g_fight1 then
        m_groupNum[g_fight1] = m_groupNum[g_fight1] + 1
        if not isNeutral then
            m_groupNum[g_fight2] = m_groupNum[g_fight2] - 1
        end
    else
        m_groupNum[g_fight2] = m_groupNum[g_fight2] + 1
        if not isNeutral then
            m_groupNum[g_fight1] = m_groupNum[g_fight1] - 1
        end
    end
    if showTips then
        if l_playerFightGroup == fightGroup then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BATTLE_WARNING_OCCUPIED_POWER_STONE"))
        else
            if not isNeutral then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BATTLE_WARNING_POWER_STONE_LOST"))
            end
        end
    end
    EventDispatcher:Dispatch(ON_UPDATE_NUMBER)
end

---==========================战场队员信息============================================================

g_teamInfo = {}

function InitTeamInfo()
    g_teamInfo = {}
    g_teamInfo = l_list
end

function OnUpdateHP(table, roleId, hpValue)
    local l_id = tostring(roleId)
    if g_teamInfo[l_id] then
        g_teamInfo[l_id].hp = hpValue
        EventDispatcher:Dispatch(ON_UPDATE_HP, l_id)
    end
end

---==========================战场结算============================================================

function OnSelectRoleNtf(info)
    g_dailyBattleCount = info.dungeons.battlefield.daily_battle_count
    if nil == g_dailyBattleCount then
        g_dailyBattleCount = 0
    end
end

--- 进入战场之后触发的函数
---@param info DoEnterSceneRes
function OnLuaDoEnterScene(info)
    --- 清空柱子逻辑
    m_groupNum = {}

    l_list = {}
    local l_battleParam = info.battle_param.pvp
    if l_battleParam then
        local l_p1 = l_battleParam.camp1.role_infos
        local l_p2 = l_battleParam.camp2.role_infos
        if #l_p1 == 0 and #l_p2 == 0 then
            return
        end
        local l_target = nil
        if #l_p1 > 0 then
            for i = 1, #l_p1 do
                if tostring(l_p1[i].role_id) == tostring(MPlayerInfo.UID) then
                    l_target = l_p1
                    break
                end
            end
        end
        if not l_target then
            l_target = l_p2
        end
        if #l_target > 0 then
            --Common.Functions.DumpTable(l_target)
            for i = 1, #l_target do
                local l_id = tostring(l_target[i].role_id)
                if l_id ~= tostring(MPlayerInfo.UID) then
                    l_list[l_id] = {}
                    l_list[l_id].roleId = l_id
                    l_list[l_id].Name = l_target[i].name
                    l_list[l_id].isMale = l_target[i].sex == 0
                    l_list[l_id].professionId = l_target[i].profession
                    l_list[l_id].hp = 0
                end
            end
        end
    end
end

function OnEnterScene(sceneId)
    local l_showTips = InBattlePre(sceneId, MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Battle)
    if l_showTips and g_dailyBattleCount >= MGlobalConfig:GetInt("BgRewardAmountCap") then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BATTLE_NO_REWARD"))
    end

    EventDispatcher:Dispatch(ON_BATTLE_ENTER)
end

--- 玩家阵营是否赢了
function DidBattleWin()
    return g_result
end

--- 战场击杀数同步信息
function OnBattleDataSync(msg)
    ---@type BattleFieldPVPCounterNtfData
    local info = ParseProtoBufToTable("BattleFieldPVPCounterNtfData", msg)
    --- 为了防止数据产生堆积，每次更新都会清空
    _battleFieldCampData = {}
    for i = 1, #info.brief_info do
        local singleInfo = info.brief_info[i]
        local singleKdaData = _parseSingleKDAData(singleInfo)
        local campType = GameEnum.EBattleFieldCamp.CampNone
        if 1 == singleInfo.camp_id then
            campType = GameEnum.EBattleFieldCamp.CampLeft
        elseif 2 == singleInfo.camp_id then
            campType = GameEnum.EBattleFieldCamp.CampRight
        else
            logError("[BattleMgr] invalid camp id: " .. tostring(singleInfo.camp_id))
        end

        _updateBattleFieldKDAData(singleKdaData, campType)
    end

    --- 如果玩家没有在左边阵营当中，这个时候会交换两个阵营的引用
    --- 服务器是不会记录是不是左边阵营的，所以可能会发下来的是阵营1，但是实际上不是玩家所在阵营
    if nil == _battleFieldCampData[GameEnum.EBattleFieldCamp.CampLeft][MPlayerInfo.UID] then
        local tempCampData = _battleFieldCampData[GameEnum.EBattleFieldCamp.CampLeft]
        _battleFieldCampData[GameEnum.EBattleFieldCamp.CampLeft] = _battleFieldCampData[GameEnum.EBattleFieldCamp.CampRight]
        _battleFieldCampData[GameEnum.EBattleFieldCamp.CampRight] = tempCampData
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnBattleFieldKDAUpdated)
end

--- 获取玩家自身的KDa
---@return BattleFieldKDA
function GetPlayerKDA()
    local playerUID = MPlayerInfo.UID
    for k, map in pairs(_battleFieldCampData) do
        if nil ~= map[playerUID] then
            return map[playerUID]
        end
    end

    -- todo 这边可能存在一个协议顺序的问题，所以当获取不到角色数据的时候，创建一个默认数据
    local ret = {
        PlayerID = playerUID,
        Kill = 0,
        Death = 0,
        AssistKill = 0,
    }

    return ret
end

--- 获取一个阵营的所有击杀数
function GetTotalKills(camp)
    if nil == camp then
        logError("[BattleFieldMgr] invalid data")
        return 0
    end

    local ret = 0
    local map = _battleFieldCampData[camp]
    if nil == map then
        return 0
    end

    for k, v in pairs(map) do
        ret = ret + v.Kill
    end

    return ret
end

--- 保存所有数据
function SaveBattleFieldAccountData()
    if _isAccountNeedGuide() then
        table.insert(_battleGuideData, tostring(MPlayerInfo.UID))
    end

    local saveStr = nil
    if C_MAX_ACCOUNT_NUM >= #_battleGuideData then
        saveStr = table.concat(_battleGuideData, '|')
    else
        local subStr = {}
        local startIdx = #_battleGuideData - C_MAX_ACCOUNT_NUM
        local idx = 1
        for i = startIdx, #_battleGuideData do
            subStr[idx] = _battleGuideData[i]
            idx = idx + 1
        end

        saveStr = table.concat(subStr, '|')
    end

    PlayerPrefs.SetString(C_STR_BATTLE_FIELD_GUIDE_NAME, saveStr)
end

--- 判断当前账户是否需要显示教学视频
function IsAccountNeedGuide()
    return _isAccountNeedGuide()
end

--- 根据传入的类型，获取对应的标签图片
---@return string, string
function GetPlayerTag(singleType)
    if nil == singleType then
        logError("[BattleFieldMgr] invalid data")
        return nil, nil
    end

    local targetKey = C_BATTLE_TAG_TYPE_CONFIG_KEY_MAP[singleType]
    if nil == targetKey then
        logError("[BattleFieldMgr] invalid data, key: " .. tostring(singleType))
        return nil, nil
    end

    local spriteName = MGlobalConfig:GetString(targetKey, "")
    return C_BATTLE_SETTLE_ATLAS_NAME, spriteName
end

--- 获取战场经过的时间
function GetBattleFieldPassTime()
    return _battleFieldPassTime
end

--- 协议更新之后更新的单个玩家KDA数据
---@param singleKDA BattleFieldKDA
function _updateBattleFieldKDAData(singleKDA, campType)
    if nil == singleKDA then
        logError("[BattleFieldMgr] invalid data")
        return
    end

    if GameEnum.EBattleFieldCamp.CampNone == campType then
        logError("[BattleMgr] invalid type")
        return
    end

    if nil == _battleFieldCampData[campType] then
        _battleFieldCampData[campType] = {}
    end

    _battleFieldCampData[campType][singleKDA.PlayerID] = singleKDA
end

---@param pbData RoleBattleBriefInfo
---@return BattleFieldKDA
function _parseSingleKDAData(pbData)
    if nil == pbData then
        logError("[BattleFieldMgr] invalid data")
        return nil
    end

    ---@type BattleFieldKDA
    local ret = {}
    ret.PlayerID = pbData.role_id
    for i = 1, #pbData.pvp_counters do
        local singleData = pbData.pvp_counters[i]
        local paramName = C_PARAM_TYPE_NAME_MAP[singleData.key]
        if nil ~= paramName then
            ret[paramName] = singleData.value
        end
    end

    --- 进入场景的时候如果没有这个值则默认置为0
    for k, v in pairs(C_PARAM_TYPE_NAME_MAP) do
        if nil == ret[v] then
            ret[v] = 0
        end
    end

    return ret
end

--- 一进入游戏就会加载所有的已经保存的数据
function _loadBattleGuideData()
    local saveStr = PlayerPrefs.GetString(C_STR_BATTLE_FIELD_GUIDE_NAME)
    if nil == saveStr then
        return
    end

    local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")
    local dataMatrix = strParseMgr.ParseValue(saveStr, GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.String)
    for i = 1, #dataMatrix do
        local singleAccountName = dataMatrix[i]
        if nil ~= tonumber(singleAccountName) then
            table.insert(_battleGuideData, singleAccountName)
        end
    end
end

function _isAccountNeedGuide()
    for i = 1, #_battleGuideData do
        local singleAccount = _battleGuideData[i]
        if tostring(MPlayerInfo.UID) == singleAccount then
            return false
        end
    end

    return true
end

function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    g_campInfo = {}
    m_groupNum = {}
    -- 是否是胜利
    g_result = l_info.status == 1
    _battleFieldPassTime = l_info.pass_time

    local l_p1 = l_info.pvp.camp1
    local l_p2 = l_info.pvp.camp2
    local l_inA = false
    local l_info = {}
    l_info.teamA = {}
    l_info.teamB = {}
    local l_camp = l_p1.camp_id
    local pvpMgr = MgrMgr:GetMgr("PvpMgr")
    for i = 1, #l_p1.role_ids do
        local l_id = l_p1.role_ids[i].value
        if g_campInfo[l_camp] == nil then
            g_campInfo[l_camp] = {}
        end

        local l_index = #g_campInfo[l_camp] + 1
        g_campInfo[l_camp][l_index] = {}
        g_campInfo[l_camp][l_index].id = l_id
        local l_roleInfo = l_p1.role_infos
        local l_kill, l_help, l_score, l_beKill, damage, heal = pvpMgr.GeneratePvpCountersInfo(l_id, l_roleInfo)
        g_campInfo[l_camp][l_index].score = l_score
        g_campInfo[l_camp][l_index].kill = l_kill
        g_campInfo[l_camp][l_index].help = l_help
        g_campInfo[l_camp][l_index].damage = damage
        g_campInfo[l_camp][l_index].heal = heal
        if tostring(l_id) == tostring(MPlayerInfo.UID) then
            l_inA = true
        end

        table.sort(g_campInfo[l_camp], function(x, y)
            return x.score > y.score
        end)
    end

    if l_inA then
        l_info.teamA = g_campInfo[l_camp]
    else
        l_info.teamB = g_campInfo[l_camp]
    end

    l_camp = l_p2.camp_id
    for i = 1, #l_p2.role_ids do
        local l_id = l_p2.role_ids[i].value
        if g_campInfo[l_camp] == nil then
            g_campInfo[l_camp] = {}
        end

        local l_index = #g_campInfo[l_camp] + 1
        g_campInfo[l_camp][l_index] = {}
        g_campInfo[l_camp][l_index].id = l_id
        local l_roleInfo = l_p2.role_infos
        local l_kill, l_help, l_score, l_beKill, damage, heal = pvpMgr.GeneratePvpCountersInfo(l_id, l_roleInfo)
        g_campInfo[l_camp][l_index].score = l_score
        g_campInfo[l_camp][l_index].kill = l_kill
        g_campInfo[l_camp][l_index].help = l_help
        g_campInfo[l_camp][l_index].damage = damage
        g_campInfo[l_camp][l_index].heal = heal
        table.sort(g_campInfo[l_camp], function(x, y)
            return x.score > y.score
        end)
    end

    if l_inA then
        l_info.teamB = g_campInfo[l_camp]
    else
        l_info.teamA = g_campInfo[l_camp]
    end

    g_campInfo = {}
    g_campInfo = l_info
    local l_mvpId = l_info.teamA[1].id

    for key, singlePlayer in pairs(g_campInfo.teamA) do
        if uint64.equals(singlePlayer.id, MPlayerInfo.UID) then
            g_dailyBattleCount = g_dailyBattleCount + 1
            break
        end
    end

    pvpMgr.ExcuteCameraTex(l_mvpId, MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Battle)
end

---==============================================================================

--是否和主角在相同的匹配区间
function CanMatchingLevelSection(level)
    local l_targetMin, l_targetMax = GetMatchingLevelSection(level)
    local l_myMin, l_myMax = GetMatchingLevelSection(MPlayerInfo.Lv)
    return l_targetMin ~= nil and l_targetMin == l_myMin and l_targetMax == l_myMax
end

--获取匹配区间
function GetMatchingLevelSection(level)
    local l_rows = TableUtil.GetBattleGroundLvRangeTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        local l_nextRow = nil
        if i < #l_rows then
            l_nextRow = l_rows[i + 1]
            if l_nextRow.Type ~= 7 then
                l_nextRow = nil
            end
        end

        if l_row.Type == 7 then
            local l_minLevel = l_row.Scenes[0]
            if level >= l_minLevel then
                if l_nextRow == nil then
                    return l_minLevel, nil
                else
                    return l_minLevel, l_nextRow.Scenes[0]
                end
            end
        end
    end
    return nil, nil
end

function InBattlePre(sceneID, activityId)
    local l_rows = TableUtil.GetBattleGroundLvRangeTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        if l_row.Type == activityId then
            if sceneID == l_row.Scenes[1] then
                return true
            end
        end
    end
    return false
end

--是否在等候区
function CanInBattlePre(sceneID)
    local l_rows = TableUtil.GetBattleGroundLvRangeTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        if l_row.Type == MgrMgr:GetMgr("SystemFunctionEventMgr").battleFieldActivityId or
                l_row.Type == MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Ring then
            if sceneID == l_row.Scenes[1] then
                return true
            end
        end
    end
    return false
end

--当前是否正式开战
function InBattleTime()
    local l_time = MgrMgr:GetMgr("DailyTaskMgr").GetBattleTime()
    local sec = MLuaClientHelper.GetTiks2NowSeconds(l_time)
    return sec <= 0
end

---------------------------匹配请求----------------------
--请求开始匹配
function BeginMatchForBattle()
    local l_msgId = Network.Define.Rpc.BeginMatchForBattleField
    ---@type BeginMatchForBattleFieldArg
    local l_sendInfo = GetProtoBufSendTable("BeginMatchForBattleFieldArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--匹配回执消息
function OnBeginMatchForBattleField(msg, arg)
    ---@type BeginMatchForBattleFieldRes
    local l_info = ParseProtoBufToTable("BeginMatchForBattleFieldRes", msg)
    if l_info.error ~= 0 then
        if l_info.error == ErrorCode.ERR_BATTLEFIELD_ALREADY_IN_MATCH_DEQUE then
            SetState(true)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        end
    end
end

--进入匹配队列
function OnNotityTeamBattlefieldMatch(msg)
    ---@type NullRes
    local l_info = ParseProtoBufToTable("NullRes", msg)
    SetState(true)

    require("ModuleMgr/DungeonMgr")
    MgrMgr:GetMgr("DungeonMgr").TeamCheckStartTime = nil
    UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
end

-----------------------------正在匹配队列----------------------------
InQueue = false
function SetState(b)
    if InQueue == b then
        return false
    end
    InQueue = b
    if InQueue then
        EventDispatcher:Dispatch(ON_PI_PEI_START)
    else
        EventDispatcher:Dispatch(ON_PI_PEI_STOP)
    end
    return true
end

function OnShowBattleTips(msg)
    ---@type PVPBroadcastNotice
    local l_info = ParseProtoBufToTable("PVPBroadcastNotice", msg)
    local l_id = l_info.announce_id
    local args = l_info.message
    local l_row = TableUtil.GetDungeonAnnouncementTable().GetRowByAnnouncementId(l_id)
    if nil == l_row then
        return
    end

    l_tips = Common.Utils.Lang(l_row.TextId)
    MgrMgr:GetMgr("TipsMgr").ShowBattleTips(MLuaCommonHelper.Format(l_tips, args))
end

function GetTeamRequireNum()
    return g_teamRequireNum
end

function SetTeamRequireNum(num)
    g_teamRequireNum = num
    EventDispatcher:Dispatch(ON_BATTLEFIELD_TEAM_REQUIRENUM_UPDATE)
end

function GetAirDoorDispearTime()
    return MgrMgr:GetMgr("DungeonMgr").GetDungeonsStartTime() + 60
end

--- 战场界面的特效红点检测方法
function CheckRedSign()
    return 1
end

return BattleMgr
