--lua model
---@module ModuleData.TeamData
module("ModuleData.TeamData", package.seeall)
--lua model end

ETeamOpenType = {
    AddOfferInfo = 1,
    SetPanelByInfo = 2,
    RefreshHeadIconByUid = 3,
    SetQuickPanelByNameAndFunc = 4,
}

--请求自动匹配 or 关闭自动匹配
EAutoPairType = {
    autoTypeNone = 0,
    autoTypeStart = 1,
    autoTypeEnd = 2,
}

ERoleInfoType = {
    PvPResult = 1,
    HymnTrialRoulette = 2,
    TeamRecommend = 3,
    TeamSpecialRecommend = 4,
    FashionCollection = 5,
    Rank = 6
}

ETeamPosType = {
    Empty = 0,
    Role = 1,
    Mercenary = 2
}

--组队邀请相关
TeamInviteList = {}
--队伍信息
---@class ClientTeamInfo
myTeamInfo = {}
--申请入队列表
TeamApplicationInfo = {}
--邀请列表
TeamInvationList = {}
--组队列表
TeamList = {}
--用于存储位置信息
TeamMemberPosList = {}
--用于存储玩家自己是否处于暂离状态 因为要传给C#
SelfIsInAfk = false
--用于存储已经邀请的玩家的邀请Cd
TeamInvationCdList = {}
--是否在单人副本
isInSoloDungeon = false
--C#用 获取队伍出战佣兵UID
MercenaryUids2Api = {}
--TeamMgr用，需要请求复活时间的佣兵
NeedRevieMercenarys = {}
--本地存储 匹配状态
isAutoPair = false
--本地存储 匹配目标 默认为附近的人
autoPairTarget = 1000
--是否在跟随中
Isfollowing = false
--私用MercenaryId 对应的mercenaryList中的index number=>number 考虑进阶问题 存储前两位 因为进阶后前两位不变 个位数递增1
indexByMercenaryId = {}
-- 选择目标
selectedUid = -1
--最大人员
maxTeamNumber = 5
--可以进行组队操作
CanUseTeamFunc = true

MatchTimeStamp = -1

local currentMemberIds = {}
local _isInTeam = false

TotalTime = MGlobalConfig:GetFloat("TeamInviteLastTime", 15)

-------------  事件相关  -----------------
--获取玩家信息事件
ON_GET_PLAYER_INFO = "ON_GET_PLAYER_INFO"
--获取玩家的组队和好友信息
ON_GET_PLAYER_TEAM_FRIEND_INFO = "ON_GET_PLAYER_TEAM_FRIEND_INFO"
--组队信息变化
ON_TEAM_INFO_UPDATE = "ON_TEAM_INFO_UPDATE"
--组队申请信息变化
ON_TEAM_APPLY_INFO_UPDATE = "ON_TEAM_APPLY_INFO_UPDATE"
--组队位置血量信息变化
ON_TEAM_BASIC_INFO_UPDATE = "ON_TEAM_BASIC_INFO_UPDATE"
--邀请列表变化事件
ON_ADD_NEW_INVATION = "ON_ADD_NEW_INVATION"
--新成员入队
ON_NEW_TEAM_MEMBER = "ON_NEW_TEAM_MEMBER"
--刷新组队目标
ON_REFRESH_TEAM_TARGET = "ON_REFRESH_TEAM_TARGET"
--队友或自己离队
ON_QUIT_TEAM_MEMBER = "ON_QUIT_TEAM_MEMBER"
--自己进队
ON_SELF_IN_TEAM = "ON_SELF_IN_TEAM"
--跟随状态变更
ON_TEAM_FOLLOW_STATE_CHANGE = "ON_TEAM_FOLLOW_STATE_CHANGE"
--发出刷新组队查询列表的请求
ON_TEAMSEARCH_INFO_UPDATE = "ON_TEAMSEARCH_INFO_UPDATE"
--发出组队自动刷新匹配状态
ON_TEAM_AUTOPAIR_STATUS = "ON_TEAM_AUTOPAIR_STATUS"
--刷新选择佣兵面板
ON_TEAM_MERCENARY_SELECT = "ON_TEAM_MERCENARY_SELECT"
--刷新选择佣兵面板数量显示
ON_TEAM_MERCENARY_SELECT_NUM = "ON_TEAM_MERCENARY_SELECT_NUM"
--刷新佣兵复活面板
ON_MERCENARY_RIVIVE_UPDATE = "ON_MERCENARY_RIVIVE_UPDATE"
--进入单人副本
ON_SOLODUNGEONS_UPDATE = "ON_SOLODUNGEONS_UPDATE"
--获得推荐队友ID
ON_GET_INVITATION_ID_LIST = "ON_GET_INVITATION_ID_LIST"
------------- END 事件相关  -----------------

-------GetData----------

function GetPlayerTeamInfo()
    local l_isCaptain = false
    local l_isInTeam = false

    if table.maxn(myTeamInfo.memberList) > 0 then
        l_isInTeam = true
    end

    if MPlayerInfo.UID == myTeamInfo.captainId then
        l_isCaptain = true
    end

    return l_isInTeam, l_isCaptain
end

function GetTeamPlayerCount()
    local l_count = 0
    for _, __ in pairs(myTeamInfo.memberList) do
        l_count = l_count + 1
    end
    return l_count
end

function GetTeamPlayerLevel()
    local level = {}
    for _, v in pairs(myTeamInfo.memberList) do
        table.insert(level, v.roleLevel)
    end
    return level
end

function GetIsInTeam()
    return _isInTeam
end

--function GetTeamInfo()
--    return myTeamInfo
--end

function GetInvitationTeamInfo()
    if table.maxn(TeamInviteList) > 0 then
        return TeamInviteList[1]
    else
        return nil
    end
end

function GetTempTeamSetting()
    local l_newTeamSeting = {}
    local l_teamSet = myTeamInfo.teamSetting
    l_newTeamSeting.min_lv = l_teamSet.min_lv ~= nil and l_teamSet.min_lv or 0
    l_newTeamSeting.max_lv = l_teamSet.max_lv ~= nil and l_teamSet.max_lv or 0
    l_newTeamSeting.target = l_teamSet.target ~= nil and l_teamSet.target or 0
    l_newTeamSeting.sub_target = l_teamSet.sub_target ~= nil and l_teamSet.sub_target or 0
    l_newTeamSeting.name = l_teamSet.name ~= nil and l_teamSet.name or ""
    return l_newTeamSeting
end

function GetCurrentMemberIds()
    return currentMemberIds
end

--获取组队成员名字
function GetNameById(cUid, teamInfo)
    local uName = ""
    local data = teamInfo == nil and myTeamInfo.memberList or teamInfo.memberList
    for i = 1, table.maxn(data) do
        if tostring(data[i].roleId) == tostring(cUid) then
            uName = Common.Utils.PlayerName(data[i].roleName)
            break
        end
    end
    return uName
end

function GetLvById(cUid, teamInfo)
    local uLv = 0
    local data = teamInfo == nil and myTeamInfo.memberList or teamInfo.memberList
    for i = 1, table.maxn(data) do
        if data[i].roleId == cUid then
            uLv = data[i].roleLevel
            break
        end
    end
    return uLv
end


--返回参数 队长吗 队长等级
function GetTeamInfoById(cpId)
    for j = 1, table.maxn(myTeamInfo.memberList) do
        if myTeamInfo.memberList[j].roleId == cpId then
            return Common.Utils.PlayerName(myTeamInfo.memberList[j].roleName), myTeamInfo.memberList[j].roleLevel
        end
    end
    return "Error TeamInfo", 0
end

function GetUserIsInTeamAndSceneId(userId)
    for i = 1, table.maxn(myTeamInfo.memberList) do
        if tostring(myTeamInfo.memberList[i].roleId) == tostring(userId) then
            return true, myTeamInfo.memberList[i].sceneId
        end
    end
    return false, 0
end

function GetInviteInfoByIdOrName(cValue)
    cTb = {}
    for i = 1, table.maxn(TeamInvationList) do
        if tostring(TeamInvationList[i].role_uid) == cValue or tostring(TeamInvationList[i].name) == cValue then
            table.insert(cTb, TeamInvationList[i])
        end
    end
    return cTb
end

function GetSelectedUid()
    return selectedUid
end

function GetProfessionImageById(professionId)
    local ret = nil
    if professionId == 0 or professionId == nil then
        return ret
    end
    local professionRow = TableUtil.GetProfessionTable().GetRowById(professionId)
    if professionRow then
        ret = professionRow.ProfessionIcon
    end
    return ret
end

function GetProfessionNameById(professionId)
    local ret = ""
    if professionId == 0 or professionId == nil then
        return ret
    end
    local professionRow = TableUtil.GetProfessionTable().GetRowById(professionId)
    if professionRow then
        ret = professionRow.Name
    end
    return ret
end

--获取队伍人数
function GetTeamNum()
    local cTeamNum = 0
    for _, _ in pairs(myTeamInfo.memberList) do
        cTeamNum = cTeamNum + 1
    end
    return cTeamNum
end

--返回参数 1 队长Id 2 队伍人数 3队员ID和性别的一个Table
function ReturnTaskNeededInfo()
    local cCaptainId = myTeamInfo.captainId
    local cTeamNum = table.maxn(myTeamInfo.memberList)
    local cTeamTable = {}
    for j = 1, table.maxn(myTeamInfo.memberList) do
        cTeamTable[j] = {}
        cTeamTable[j].cId = myTeamInfo.memberList[j].roleId
        cTeamTable[j].cSex = myTeamInfo.memberList[j].roleSex
        cTeamTable[j].cLevel = myTeamInfo.memberList[j].roleLevel
        cTeamTable[j].cRoleJobLevel = myTeamInfo.memberList[j].roleJobLevel
    end
    return cCaptainId, cTeamNum, cTeamTable
end

function GetTargetNameById(id)
    local data = TableUtil.GetTeamTargetTable().GetRowByID(id)
    if data then
        return data.Name
    end
    return ""
end

function GetTargetNameByIdInTeamSearchPanel(id)
    if id == 1 then
        return Common.Utils.Lang("TEAM_NEARBY_PEOPLE")
    end
    local data = TableUtil.GetTeamTargetTable().GetRowByID(id)
    if data then
        return data.Name
    end
    return ""
end

function GetSelfLineNumber()
    return MScene.SceneLine
end

function GetTempEntityTb()
    local allEntity = MEntityMgr:GetMEntities()
    local entityTb = {}
    for z = 0, allEntity.Count - 1 do
        local attr = allEntity[z].AttrComp
        table.insert(entityTb, attr)
    end
    return entityTb
end

--==============================--
--@Description:所有队员是否在指定场景
--@Date: 2018/9/13
--@Param: [args]
--@Return:
--==============================--
function IsAllMemberInSameScene(sceneId)
    local ret = true
    for i, v in ipairs(myTeamInfo.memberList) do
        if v.sceneId ~= sceneId then
            ret = false
            break
        end
    end
    return ret
end

--==============================--
--@Description:是否有队友在指定场景
--@Date: 2018/9/19
--@Param: [args]
--@Return:
--==============================--
function HasMemberInScene(sceneId)
    local ret = false
    for i, v in ipairs(myTeamInfo.memberList) do
        if v.sceneId == sceneId then
            ret = true
            break
        end
    end
    return ret
end

--==============================--
--@Description:所有在同一等级段内[minLv, maxLv)开区间
--@Date: 2018/9/14
--@Param: [args]
--@Return:
--==============================--
function IsAllMemberInSameLvRange(minLv, maxLv)
    local ret = true
    for i, v in ipairs(myTeamInfo.memberList) do
        if v.roleLevel < minLv or v.roleLevel >= maxLv then
            ret = false
            break
        end
    end
    return ret
end

--==============================--
--@Description: 获取组队玩家uid集合
--@Date: 2018/9/27
--@Param: [args]
--@Return:
--==============================--
function GetTeamPlayerIds()
    local ret = {}
    for _, v in ipairs(myTeamInfo.memberList) do
        table.insert(ret, v.roleId)
    end
    return ret
end

function GetCurMercenaryNum()
    local l_num = 0
    for _, v in pairs(myTeamInfo.mercenaryList) do
        if v.isInTeam then
            l_num = l_num + 1
        end
    end
    return l_num
end

-- 队伍可携带的佣兵数量
function CanTakeMercenaryNumber()
    local l_canFightNum = 0
    local l_limit = MGlobalConfig:GetSequenceOrVectorInt("BattleUnlockLimit")
    for _, v in pairs(myTeamInfo.memberList) do
        for i = 0, l_limit.Length - 1 do
            if l_limit[i] ~= 0 and l_limit[i] <= v.roleLevel then
                l_canFightNum = l_canFightNum + 1
            end
        end
    end
    return math.min(l_canFightNum, GetMaxMercenaryNum())
end

function GetMaxMercenaryNum()
    return maxTeamNumber - table.maxn(myTeamInfo.memberList)
end

--Check

function CheckIsInvateCd(userId)
    for i = 1, table.maxn(TeamInvationCdList) do
        if TeamInvationCdList[i].UserID == userId then
            if TeamInvationCdList[i].LeftInvatCdTime > 0 then
                return true
            end
        end
    end
    return false
end

function CheckTeamInvite()
    if TeamInviteList[1].remainTime > 0 then
        if not TeamInviteList[1].isStart then
            TeamInviteList[1].isStart = true
            return true
        end
    end
    return false
end

function CheckIsShowTeamShout(settingData)

    if settingData == nil then
        return false
    end

    if MPlayerInfo == nil then
        return false
    end

    --玩家等级判断和组队目标配置等级判断
    local data = TableUtil.GetTeamTargetTable().GetRowByID(settingData.target)
    if data then
        if MPlayerInfo.Lv < data.LevelLimit[0] then
            return false
        end
    end

    --玩家等级判断和组队目标设置等级判断
    if MPlayerInfo.Lv >= settingData.min_lv and MPlayerInfo.Lv <= settingData.max_lv then
        return true
    else
        --不满足等级 但是自己在队伍当中 显示
        if myTeamInfo.isInTeam then
            return true
        end
        return false
    end

    return true
end

-------SetData--------

function SetIsInTeam(flag)
    _isInTeam = flag
end

function SetCurrentMemberIds(data)
    currentMemberIds = {}
    for _, v in ipairs(data) do
        currentMemberIds[v] = 1
    end
end

---@param data MemberBaseInfo__Array
---@return ClientOneMemberInfo[],table<uint64, number>
function SetMemberList(data)
    ---@type ClientOneMemberInfo[]
    local memberList = {}
    ---@type table<uint64, number>
    for i = 1, table.maxn(data) do
        --SetIsInTeam(true)
        local oneInfo = data[i]
        ---@class ClientOneMemberInfo
        local luaOneInfo = {}
        luaOneInfo.state = oneInfo.status
        luaOneInfo.sceneId = oneInfo.map_id
        luaOneInfo.roleType = oneInfo.type
        luaOneInfo.roleId = oneInfo.role_uid
        luaOneInfo.roleName = Common.Utils.PlayerName(oneInfo.name)
        luaOneInfo.roleLevel = oneInfo.base_level
        luaOneInfo.roleSex = oneInfo.sex
        luaOneInfo.roleOutlook = oneInfo.outlook
        luaOneInfo.roleEquipIds = oneInfo.equip_ids
        luaOneInfo.roleLineId = oneInfo.line_id
        luaOneInfo.roleJobLevel = oneInfo.job_level
        luaOneInfo.roleBriefInfo = oneInfo
        if luaOneInfo.roleId == myTeamInfo.captainId then
            myTeamInfo.captainName = luaOneInfo.roleName
            myTeamInfo.captainLv = luaOneInfo.roleLevel
        end
        if tostring(luaOneInfo.roleId) == tostring(MPlayerInfo.UID) then
            SetSelfIsInAfk(oneInfo.status == MemberStatus.MEMBER_AFK)
        end
        table.insert(memberList, luaOneInfo)
    end
    return memberList
end

---@param data MercenaryBrief__Array
---@return ClientMercenaryInfo[],table<number, number>
function SetMercenaryList(data)
    ---@type ClientMercenaryInfo[]
    local mercenaryList = {}
    ---@type table<number, number>
    local l_indexByMercenaryId = {}
    ClearMercenaryUids()
    for i = 1, table.maxn(data) do
        local oneinfo = data[i]
        ---@class ClientMercenaryInfo
        local luaOneInfo = {}
        l_indexByMercenaryId[math.ceil(tonumber(oneinfo.id) / 10)] = i
        luaOneInfo.ownerId = oneinfo.owner_id
        luaOneInfo.UId = oneinfo.uid
        luaOneInfo.isInTeam = oneinfo.is_in_team
        luaOneInfo.Id = oneinfo.id
        luaOneInfo.hp = oneinfo.hp
        luaOneInfo.reviveTime = 0
        luaOneInfo.isDeath = false
        if not oneinfo.hp or oneinfo.hp == 0 then
            table.insert(NeedRevieMercenarys, { ownerId = luaOneInfo.ownerId, mercenaryId = luaOneInfo.Id })
        end
        luaOneInfo.sp = oneinfo.sp
        luaOneInfo.lvl = oneinfo.level
        table.insert(mercenaryList, luaOneInfo)
        table.insert(MercenaryUids2Api, luaOneInfo.UId)
    end
    return mercenaryList, l_indexByMercenaryId
    --myTeamInfo.mercenaryList = mercenaryList
end

---@param data TeamInfo
function SetTeamInfo(data)
    indexByMercenaryId = {}
    myTeamInfo = {}
    myTeamInfo.teamId = data.team_id
    myTeamInfo.captainId = data.captain_id
    myTeamInfo.viceCaptainId = data.vice_captain_id
    myTeamInfo.captainName = ""
    myTeamInfo.captainLv = 0
    myTeamInfo.teamSetting = {}
    myTeamInfo.teamSetting = data.team_setting
    ---@type ClientOneMemberInfo[]
    myTeamInfo.memberList = {}
    myTeamInfo.mercenaryList = {}
    myTeamInfo.memberList = SetMemberList(data.member_list)
    if data.mercenary_list then
        myTeamInfo.mercenaryList, indexByMercenaryId = SetMercenaryList(data.mercenary_list)
    end
    myTeamInfo.isInTeam = myTeamInfo.teamId and myTeamInfo.teamId ~= 0
    if myTeamInfo.teamSetting.name == nil or myTeamInfo.teamSetting.name == "" then
        myTeamInfo.teamSetting.name = Common.Utils.Lang("TEAM_DEFAULT_NAME", myTeamInfo.captainName)
    end
end

function Pb2teamInfo(data)
    local TeamInfo = {}
    local l_indexByMercenaryId = {}
    TeamInfo.teamId = data.team_id
    TeamInfo.captainId = data.captain_id
    TeamInfo.viceCaptainId = data.vice_captain_id
    TeamInfo.captainName = ""
    TeamInfo.captainLv = 0
    TeamInfo.teamSetting = {}
    TeamInfo.teamSetting = data.team_setting
    TeamInfo.memberList = {}
    TeamInfo.mercenaryList = {}

    TeamInfo.memberList = SetMemberList(data.member_list)
    if data.mercenary_list then
        TeamInfo.mercenaryList, l_indexByMercenaryId = SetMercenaryList(data.mercenary_list)
    end
    TeamInfo.isInTeam = TeamInfo.teamId and TeamInfo.teamId ~= 0
    if TeamInfo.teamSetting.name == nil or TeamInfo.teamSetting.name == "" then
        TeamInfo.teamSetting.name = Common.Utils.Lang("TEAM_DEFAULT_NAME", TeamInfo.captainName)
    end
    return TeamInfo
end

function HidTeamInvite()
    if table.maxn(TeamInviteList) > 0 then
        TeamInviteList[1].remainTime = 0
    end
end

function SetTeamApplicationInfo(data)
    TeamApplicationInfo = {}
    for i = 1, table.maxn(data) do
        table.insert(TeamApplicationInfo, data[i])
    end
end

function SetTeamInvationList(data)
    TeamInvationList = data
end

function SetIsInSoloDungeon(flag)
    isInSoloDungeon = flag
end

function SetCaptainData(captainId)
    myTeamInfo.captainId = captainId
    myTeamInfo.captainName, myTeamInfo.captainLv = GetTeamInfoById(captainId)
end

function SetIsFollowing(state)
    Isfollowing = state
end

function SetTeamSetting(data)
    myTeamInfo.teamSetting = data
end

function SetAutoPairTarget(target)
    autoPairTarget = target
end

function SetIsAutoPair(flag)
    isAutoPair = flag
end

function SetState(members)
    local index = GetIndexByRoleId(tostring(members.role_id))
    if myTeamInfo.memberList[index] then
        myTeamInfo.memberList[index].state = members.status
    end
end

function SetSelfIsInAfk(flag)
    selfIsInAfk = flag
end

function SetSelectedUid(value)
    selectedUid = value
end

function SetCanUseTeamFunc(value)
    CanUseTeamFunc = value
end

function SetMercenaryReviveTime(data)
    local l_index = GetMercenaryIndexByMercenaryId(data.mercenary_id)
    if l_index == 0 then
        return
    end
    if data.revive_timestamp and tonumber(data.revive_timestamp) > Common.TimeMgr.GetNowTimestamp() and myTeamInfo.mercenaryList[l_index] then
        myTeamInfo.mercenaryList[l_index].reviveTime = data.revive_timestamp
        myTeamInfo.mercenaryList[l_index].isDeath = true
    else
        myTeamInfo.mercenaryList[l_index].isDeath = false
    end
end

---@param members MemberStatusInfo__Array
function RefreshMemberStatus(members)
    if table.maxn(myTeamInfo.memberList) == 0 then
        return
    end
    local l_isRefreshTeamMember = false
    for i = 1, table.maxn(members) do
        local memberListIndex = GetIndexByRoleId(tostring(members[i].role_id))
        if myTeamInfo.memberList[memberListIndex] then
            if members[i].cur_hp ~= nil then
                myTeamInfo.memberList[memberListIndex].cur_hp = members[i].cur_hp
            end
            if members[i].cur_sp ~= nil then
                myTeamInfo.memberList[memberListIndex].cur_sp = members[i].cur_sp
            end
            if members[i].total_hp ~= nil then
                myTeamInfo.memberList[memberListIndex].total_hp = members[i].total_hp
            end
            if members[i].total_sp ~= nil then
                myTeamInfo.memberList[memberListIndex].total_sp = members[i].total_sp
            end
            if members[i].lv ~= nil then
                if myTeamInfo.memberList[memberListIndex].roleLevel ~= members[i].lv then
                    l_isRefreshTeamMember = true
                end
                myTeamInfo.memberList[memberListIndex].roleLevel = members[i].lv
            end
            if members[i].scene_id ~= nil then
                if myTeamInfo.memberList[memberListIndex].sceneId ~= members[i].scene_id then
                    myTeamInfo.memberList[memberListIndex].sceneId = members[i].scene_id
                    l_isRefreshTeamMember = true
                end
            end
            if members[i].role_type ~= nil then
                if myTeamInfo.memberList[memberListIndex].roleType ~= members[i].role_type then
                    myTeamInfo.memberList[memberListIndex].roleType = members[i].role_typed
                    l_isRefreshTeamMember = true
                end
            end
            if members[i].line_id ~= nil then
                if myTeamInfo.memberList[memberListIndex].roleLineId ~= members[i].line_id then
                    myTeamInfo.memberList[memberListIndex].roleLineId = members[i].line_id
                    l_isRefreshTeamMember = true
                end
            end
            local l_roleid = members[i].role_id
            local pos = members[i].pos
            if TeamMemberPosList[l_roleid] then
                TeamMemberPosList[l_roleid].pos = pos
            else
                TeamMemberPosList[l_roleid] = {}
                TeamMemberPosList[l_roleid].pos = pos
            end
        end
    end
    return l_isRefreshTeamMember
end

function RefreshMercenaryStatus(mercenarys)
    ClearNeedRevieMercenarys()
    for i = 1, #mercenarys do
        local l_index = GetMercenaryIndexByMercenaryId(mercenarys[i].id)
        if l_index ~= 0 and l_index <= #myTeamInfo.mercenaryList and myTeamInfo.mercenaryList[l_index] then
            myTeamInfo.mercenaryList[l_index].Id = mercenarys[i].id
            myTeamInfo.mercenaryList[l_index].UId = mercenarys[i].uid
            if mercenarys[i].hp ~= nil then
                myTeamInfo.mercenaryList[l_index].hp = mercenarys[i].hp
            end
            if not mercenarys[i].hp or mercenarys[i].hp == 0 then
                table.insert(NeedRevieMercenarys, { ownerId = myTeamInfo.mercenaryList[l_index].ownerId, mercenaryId = myTeamInfo.mercenaryList[l_index].Id })
            end
            if mercenarys[i].sp ~= nil then
                myTeamInfo.mercenaryList[l_index].sp = mercenarys[i].sp
            end
            if mercenarys[i].level ~= nil then
                myTeamInfo.mercenaryList[l_index].lvl = mercenarys[i].level
            end
        end
    end
end

function RefreshMercenaryInfo(data)
    myTeamInfo.mercenaryList, indexByMercenaryId = SetMercenaryList(data)
end

-- Add

function AddMercenaryUids2Api(value)
    table.insert(MercenaryUids2Api, value)
end

function AddNewInvitation(teaminfo, index)
    if not index then
        table.insert(TeamInvationList, teaminfo)
    else
        table.insert(TeamInvationList, index, teaminfo)
    end
end

function AddTeamInvationCdList(data)
    table.insert(TeamInvationCdList, data)
end

function AddTeamList(data)
    table.insert(TeamList, data)
end

function SortTeamList()
    table.sort(TeamList, function(x, y)
        if table.maxn(x.profession_ids) > table.maxn(y.profession_ids) then
            return true
        else
            if table.maxn(x.profession_ids) == table.maxn(y.profession_ids) then
                return x.create_time > y.create_time
            end
        end
        return false
    end)
end

function AddTeamInviteList(data)
    table.insert(TeamInviteList, data)
end

function AddTeamApplication(data)
    if table.maxn(TeamApplicationInfo) == 0 then
        table.insert(TeamApplicationInfo, table.maxn(TeamApplicationInfo) + 1, data.info)
        return true
    else
        local isInApplicationList = false
        for i = 1, table.maxn(TeamApplicationInfo) do
            if TeamApplicationInfo[i].role_uid == data.info.role_uid then
                isInApplicationList = true
                break
            end
        end
        if not isInApplicationList then
            table.insert(TeamApplicationInfo, table.maxn(TeamApplicationInfo) + 1, data.info)
            return true
        end
    end
    return false
end

-- Remove

--依据Team_id从组队查询列表里面移除数据
function RemoveFromTeamListByTeamId(teamId)
    for i = 1, table.maxn(TeamList) do
        if tostring(TeamList[i].team_id) == tostring(teamId) then
            table.remove(TeamList, i)
            break
        end
    end
end

function RemoveTeamApplicationInfoById(addUserId)
    local cTable = {}
    for i = 1, table.maxn(TeamApplicationInfo) do
        if TeamApplicationInfo[i].role_uid ~= addUserId then
            table.insert(cTable, table.maxn(cTable) + 1, TeamApplicationInfo[i])
        end
    end
    TeamApplicationInfo = cTable
end

function RemoveMember(Id)
    for i, memberInfo in ipairs(myTeamInfo.memberList) do
        if memberInfo.roleId == Id then
            leaveTeamName = Common.Utils.PlayerName(memberInfo.roleName)
            table.remove(myTeamInfo.memberList, i)
            local isCaptain = memberInfo.roleId == myTeamInfo.captainId
            return isCaptain, memberInfo
        end
    end
    return false, nil
end

-- Reset

function ResetAll()
    ResetTeamInfo()
    TeamInviteList = {}
    TeamInvationList = {}
    TeamList = {}
    TeamMemberPosList = {}
end

function ResetTeamInfo()
    myTeamInfo = {
        isInTeam = false,
        teamId = -1,
        captainId = -1,
        viceCaptainId = -1,
        inviterId = -1,
        captainLv = -1,
        captainName = "",
        memberList = {

        },
        mercenaryList = {

        },
        teamSetting = {

        }
    }
    isAutoPair = false
end

function ResetTeamApplication()
    TeamApplicationInfo = {}
end

function ClearTeamInvite()
    TeamInviteList = {}
end

function ClearMercenaryUids()
    -- body
    MercenaryUids2Api = {}
end

function ClearTeamList()
    TeamList = {}
end

function ClearNeedRevieMercenarys()
    NeedRevieMercenarys = {}
end

function ResetMercenaryRevive(mercenaryId)
    local l_index = GetMercenaryIndexByMercenaryId(mercenaryId)
    if l_index and l_index > 0 and myTeamInfo.mercenaryList[l_index] then
        myTeamInfo.mercenaryList[l_index].reviveTime = 0
        myTeamInfo.mercenaryList[l_index].isDeath = false
    end
end

function GetIndexByRoleId(rid)
    for i = 1, #myTeamInfo.memberList do
        if tostring(myTeamInfo.memberList[i].roleId) == rid then
            return i
        end
    end
end

function GetMercenaryIndexByMercenaryId(merID)
    for i = 1, #myTeamInfo.mercenaryList do
        if math.ceil(tonumber(myTeamInfo.mercenaryList[i].Id)) == math.ceil(tonumber(merID)) then
            return i
        end
    end
    return 0
end
---@param memberInfo MemberBaseInfo
function UpdateMemberBaseInfo(memberInfo)
    for k, v in pairs(myTeamInfo.memberList) do
        if uint64.equals(v.roleId, memberInfo.role_uid) then
            v.roleOutlook = memberInfo.outlook
            v.roleEquipIds = memberInfo.equip_ids
            v.roleJobLevel = memberInfo.job_level
            v.roleBriefInfo = memberInfo
            return
        end
    end
end

return ModuleData.TeamData