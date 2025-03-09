--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.GuildMatchData
module("ModuleData.GuildMatchData", package.seeall)
--lua model end

--lua functions
function Init()


end --func end
--next--
function Logout()


end --func end
--next--
--lua functions end

--lua custom scripts

SystemForTeam = 15103           --队伍管理
SystemForEnter = 15104          --进入等候区
SystemForLaLa = 15102           --啦啦队报名
SystemOpen = 15101              --总开关（队伍报名）

ON_REFRESH_TEAM_MGR = "ON_REFRESH_TEAM_MGR"
ON_REFRESH_TEAM_SEL = "ON_REFRESH_TEAM_SEL"
ON_REFRESH_TEAM_CACHE = "ON_REFRESH_TEAM_CACHE"
ON_REFRESH_TEAM_CONVENE = "ON_REFRESH_TEAM_CONVENE"

EUIOpenType = {
    PRE_TIME = 1,
    MATCH_TIME = 2,
    OpenSelPanel = 3,
}

ActivityType = {
    MATCH = 1,
    WATCH = 2
}

NowMatchRound = 0
TimeStamp = 0
MgrTeamInfo = {}
MgrTeamUuid = {}
AllBattleTeam = {}
AllCheeringTeam = {}
maxTeamCount = 4
battleTeamNum = 3
camp1Info = {}
camp2Info = {}
ResultInfo = {}
teamCache = {}
local refreshBtnTimeStamp = -1

------------Set---------------------
function SetMgrTeamInfo(data)

    ResetMgrTeamInfo()
    for i = 1, table.maxn(data) do
        if data[i] ~= nil then
            MgrTeamUuid[i] = data[i].team_uuid
            MgrTeamInfo[i].teamuuid = data[i].team_uuid
            MgrTeamInfo[i].round = data[i].battle_order
            for j = 1, table.maxn(data[i].member_list) do
                table.insert(MgrTeamInfo[i].memberList, SetMemberInfo(data[i].member_list[j]))
            end
        else
            MgrTeamUuid[i] = 0
            MgrTeamInfo[i].teamuuid = 0
            MgrTeamInfo[i].memberList = {}
        end
    end

end

function GetRefreshBtnCd()
    return refreshBtnTimeStamp
end

function SetRefreshBtnCd()
    refreshBtnTimeStamp = Common.TimeMgr.GetNowTimestamp() + MGlobalConfig:GetFloat("G_MatchSummonBtnCD")
end

function RefreshBtnCd()
    refreshBtnTimeStamp = -1
end

function ReplaceTeamInfo(type, other)

    local l_temp = MgrTeamInfo[type]
    MgrTeamInfo[type] = MgrTeamInfo[other]
    MgrTeamInfo[other] = l_temp

end

function UpdateMgrTeamInfo(uuid, type)

    for i = 1, table.maxn(MgrTeamInfo) do
        if MgrTeamInfo[i].teamuuid == uuid then
            MgrTeamInfo[i].teamuuid = 0
            MgrTeamInfo[i].memberList = {}
        end
    end

    for i = 1, table.maxn(AllBattleTeam) do
        if AllBattleTeam[i].teamuuid == uuid then
            MgrTeamInfo[type] = AllBattleTeam[i]
        end
    end

end

function SetAllBattleTeam(data)

    ResetAllBattleTeam(table.maxn(data))
    for i = 1, table.maxn(data) do
        AllBattleTeam[i].teamuuid = data[i].team_uuid
        AllBattleTeam[i].round = data[i].battle_order or 0
        for j = 1, table.maxn(data[i].member_list) do
            table.insert(AllBattleTeam[i].memberList, SetMemberInfo(data[i].member_list[j]))
        end
    end

end

function SetAllCheeringTeam(data)

    ResetAllCheeringTeam()
    for i = 1, table.maxn(data) do
        AllCheeringTeam[i].teamuuid = data[i].team_uuid
        AllCheeringTeam[i].round = data[i].battle_order
        for j = 1, table.maxn(data[i].member_list) do
            table.insert(AllCheeringTeam[i].memberList, SetMemberInfo(data[i].member_list[j]))
        end
    end

end

function SetTeamCache(teamInfo, isTeamVal)

    teamCache = {}
    if isTeamVal then
        teamCache = teamInfo
    else
        for i = 1, #teamInfo.role_info do
            local v = teamInfo.role_info[i]
            local teamMember = {}
            teamMember.id = v.role_id
            teamMember.name = v.role_name
            table.insert(teamCache, teamMember)
        end
    end

end

function SetMemberInfo(member)

    local oneInfo = {}
    if member then
        oneInfo.roleId = member.role_uid
        oneInfo.roleType = member.type
        oneInfo.roleName = Common.Utils.PlayerName(member.name)
        oneInfo.roleSex = member.sex
        oneInfo.roleLvl = member.base_level
        oneInfo.jobLvl = member.job_level
        oneInfo.member_info = member
    else
        oneInfo.roleId = 0
        oneInfo.roleType = nil
        oneInfo.roleName = ""
        oneInfo.roleSex = nil
        oneInfo.roleLvl = 0
        oneInfo.jobLvl = 0
    end
    return oneInfo

end

function SetCampInfo(camp1, camp2)

    ClearCampInfo()
    camp1Info.guildName = camp1.guild_name
    camp1Info.guildId = camp1.guild_id
    camp1Info.iconId = camp1.icon_id
    for _, v in pairs(camp1.team_result) do
        local oneResult = {}
        oneResult.score = v.score
        oneResult.win = v.win_or_not
        if v.mvp_role_name == '' then
            oneResult.mvp = ''
        else
            oneResult.mvp = Common.Utils.PlayerName(v.mvp_role_name)
        end
        table.insert(camp1Info.teamResult, oneResult)
    end
    camp2Info.guildName = camp2.guild_name
    camp2Info.guildId = camp2.guild_id
    camp2Info.iconId = camp2.icon_id
    for _, v in pairs(camp2.team_result) do
        local oneResult = {}
        oneResult.score = v.score
        oneResult.win = v.win_or_not
        if v.mvp_role_name == '' then
            oneResult.mvp = ''
        else
            oneResult.mvp = Common.Utils.PlayerName(v.mvp_role_name)
        end
        table.insert(camp2Info.teamResult, oneResult)
    end

end

------------Get---------------------
function GetTeamCache()
    return teamCache
end
------------Clear-------------------
function ResetMgrTeamInfo()

    MgrTeamInfo = {}
    MgrTeamUuid = {}
    for i = 1, maxTeamCount do
        table.insert(MgrTeamInfo, { teamuuid = 0, round = 0, memberList = {} })
    end

end

function ResetAllBattleTeam(count)

    AllBattleTeam = {}
    for i = 1, count do
        table.insert(AllBattleTeam, { teamuuid = 0, round = 0, memberList = {} })
    end

end

function ResetAllCheeringTeam()

    AllCheeringTeam = {}
    --for i = 1, maxTeamCount do
    --    table.insert(AllCheeringTeam, { teamuuid = 0, round = 0, memberList = {} })
    --end

end
function ClearCampInfo()

    camp1Info = {
        guildId = 0,
        iconId = 0,
        teamResult = {}
    }
    camp2Info = {
        guildId = 0,
        iconId = 0,
        teamResult = {}
    }

end

--lua custom scripts end
return ModuleData.GuildMatchData