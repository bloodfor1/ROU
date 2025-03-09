---@module ModuleMgr.TeamLeaderMatchMgr
module("ModuleMgr.TeamLeaderMatchMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

LEADER_MATCH_SELECT_DUTY = "LEADER_MATCH_SELECT_DUTY"

local C_FIRST_TIME_MATCH = "team_first_time_match"
--- 本地最多保存3个玩家的数据
local C_MAX_SAVE_PLAYER_COUNT = 3
--- 默认队伍当中的人数为5个
local C_NUM_TEAM_MEMBER_COUNT = 5
local C_STR_UID_TIME_SYMBOL = "="

local _strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")

---@type table<number, number>
local _teamSlotDutyMap = nil

local PngName = {
    "UI_Commonicon_Icon_Random_01.png",
    "UI_Commonicon_Icon_Tank_01.png",
    "UI_Commonicon_Icon_Treatment_01.png",
    "UI_Commonicon_Icon_Output_01.png",
}

--- 是否是第一次使用这个功能
---@type boolean
local _firstTimeMatch = false

--- 第一次登陆的缓存
---@type string[]
local _firstTimeCacheMap = nil

function OnInit()
    _teamSlotDutyMap = {}
    _firstTimeCacheMap = {}
    _loadHint()
end

---@return TeamIconParam[]
function GetMemberShowConfig()
    ---@type ClientTeamInfo
    local teamData = DataMgr:GetData("TeamData").myTeamInfo
    local memberList = teamData.memberList
    local data = {}
    for i = 1, #memberList do
        local singleMember = memberList[i]
        table.insert(data, { iconData = singleMember })
    end
    return data
end

--- 设置默认职责队列
function SetDefaultDutyList()
    for i = 1, C_NUM_TEAM_MEMBER_COUNT do
        _teamSlotDutyMap[i] = GameEnum.ETeamDuty.Free
    end
end

function SetSlotDuty(slotID, dutyID)
    if #_teamSlotDutyMap == 0 then
        SetDefaultDutyList()
    end
    if nil == slotID or nil == dutyID then
        logError("[TeamLeaderMatch] invalid param")
        return
    end

    if 1 > slotID or C_NUM_TEAM_MEMBER_COUNT < slotID then
        logError("[TeamLeaderMatch] invalid param, slotID: " .. tostring(slotID))
        return
    end

    _teamSlotDutyMap[slotID] = dutyID
    EventDispatcher:Dispatch(LEADER_MATCH_SELECT_DUTY)
end

function GetSlotDuty(slotID)
    if #_teamSlotDutyMap == 0 then
        SetDefaultDutyList()
    end
    if nil == slotID then
        logError("[TeamLeaderMatch] invalid param")
        return GameEnum.ETeamDuty.None
    end

    if 1 > slotID or C_NUM_TEAM_MEMBER_COUNT < slotID then
        logError("[TeamLeaderMatch] invalid param, slotID: " .. tostring(slotID))
        return GameEnum.ETeamDuty.None
    end
    return _teamSlotDutyMap[slotID]
end

--- 返回时候是第一次进行修改操作
--- 主要用来描述是否要弹出提示，如果提示过不会弹出
--- 如果没有保存过，仅仅是操作过，也不会弹出
---@return boolean
function IsFirstTime()
    local playerUIDStr = tostring(MPlayerInfo.UID)
    for i = 1, #_firstTimeCacheMap do
        local singleUID = _firstTimeCacheMap[i]
        if singleUID == playerUIDStr then
            return false
        end
    end

    return _firstTimeMatch
end

function SetFirstTimeDirty()
    _firstTimeMatch = false
end

--- 保存提示记录
function SaveHint()
    local playerUIDStr = tostring(MPlayerInfo.UID)
    for i = #_firstTimeCacheMap, 1, -1 do
        local singleUID = _firstTimeCacheMap[i]
        if singleUID == playerUIDStr then
            table.remove(_firstTimeCacheMap, i)
        end
    end

    local saveStr = ""
    table.insert(_firstTimeCacheMap, playerUIDStr)
    for i = 1, #_firstTimeMatch do
        local singleUID = _firstTimeMatch[i]
        saveStr = saveStr .. singleUID
        if i ~= #_firstTimeMatch then
            saveStr = saveStr .. C_STR_UID_TIME_SYMBOL
        end
    end

    local diffValue = #_firstTimeCacheMap - C_MAX_SAVE_PLAYER_COUNT
    if 0 < diffValue then
        for i = 1, diffValue do
            table.remove(_firstTimeCacheMap, 1)
        end
    end

    PlayerPrefs.SetString(C_FIRST_TIME_MATCH, saveStr)
end

--- 在缓存当中载入数据
function _loadHint()
    if nil == _firstTimeCacheMap then
        _firstTimeCacheMap = {}
    end

    local saveStr = PlayerPrefs.GetString(C_FIRST_TIME_MATCH)
    if nil == saveStr then
        return
    end

    local dataMatrix = _strParseMgr.ParseValue(saveStr, GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.String)
    for i = 1, #dataMatrix do
        local singleUID = dataMatrix[i]
        _firstTimeCacheMap[i] = singleUID
    end
end

function GetPngName(dutyId)
    return PngName[dutyId + 1]
end

return ModuleMgr.TeamLeaderMatchMgr