---@module ModuleMgr.TeamMatchOptionMgr
module("ModuleMgr.TeamMatchOptionMgr", package.seeall)

--- 当前本地保存玩家记录数据的数量
local C_PLAYER_COUNT_LIMIT = 3
local C_PLAYER_PREF_SAVE_OPTION = "player_team_duty"
local C_STR_UID_TIME_SYMBOL = "="
AutoPair = false
local _strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")

--- 描述当前有哪些已经标记不再提示的
---@type string[]
local _doNotShowHintMap = nil

--- 玩家所选择的职责
---@type number[]
local _dutyList = nil

--- 希望成为队长的映射表，在表中表示愿意成为队长
--- 希望成为队长的映射表
---@type table<number, boolean>
local _wishBecomeLeadMap = true

function OnInit()
    _dutyList = {}
    _wishBecomeLeadMap = true
    _loadMap()
    AutoPair = false
end

function OnLogout()
    AutoPair = false
end

---@return number[]
function GetDutyList()
    return _dutyList
end

function SetDutyList(dutyList)
    _dutyList = dutyList
end

--- 添加是否希望成为队长的选项
function SetLeaderDefault(wishBecomeLeader)
    _wishBecomeLeadMap = wishBecomeLeader
end

--- 获取是否希望成为队长的默认配置
---@return boolean
function GetLeaderDefault()
    --if nil == id then
    --    logError("[TeamDuty] invalid param")
    --    return false
    --end
    --
    --local ret = _wishBecomeLeadMap[id]
    --if nil ~= ret then
    --    return ret
    --end

    return _wishBecomeLeadMap
end

--- 添加不再提示的玩家
function AddDoNotShowHint()
    if nil == _doNotShowHintMap then
        _doNotShowHintMap = {}
    end

    if C_PLAYER_COUNT_LIMIT > #_doNotShowHintMap then
        _refreshMap()
    else
        table.remove(_doNotShowHintMap, 1)
        _refreshMap()
    end

    _saveMap()
end

--- 返回当前角色是否显示提示
---@return boolean
function PlayerShowHint()
    if nil == _doNotShowHintMap then
        return false
    end

    local playerUIDStr = tostring(MPlayerInfo.UID)
    for i = 1, #_doNotShowHintMap do
        local singleUID = _doNotShowHintMap[i]
        if playerUIDStr == singleUID then
            return false
        end
    end

    return true
end

--- 返回是否显示勾选框
---@return boolean
function ShowCheckBox()
    local C_VALID_COUNT = 1
    local options = _getTeamDuty()
    local validValue = 0
    for i = 1, #options do
        local singleValue = options[i]
        if singleValue.active then
            validValue = validValue + 1
        end
    end

    return C_VALID_COUNT < validValue
end

--- 获取职业职责的列表
---@return TeamDutyShowPair[]
function GetTeamDutyOptions(playerPro)
    return _getTeamDuty(playerPro)
end

--- 获取职业职责的列表
---@return TeamDutyShowPair[]
function _getTeamDuty(playerPro)
    playerPro = playerPro or MPlayerInfo.ProfessionId
    local config = TableUtil.GetProfessionTable().GetRowById(playerPro)
    local dutyMap = {}
    local matchDuty = Common.Functions.VectorToTable(config.MatchDuty)
    for i = 1, #matchDuty do
        local singleDuty = matchDuty[i]
        dutyMap[singleDuty] = 1
    end

    ---@type TeamDutyShowPair[]
    local ret = {
        { dutyID = GameEnum.ETeamDuty.Tank, active = false },
        { dutyID = GameEnum.ETeamDuty.Heal, active = false },
        { dutyID = GameEnum.ETeamDuty.Attack, active = false },
    }

    for i = 1, #ret do
        local singlePair = ret[i]
        ret[i].active = nil ~= dutyMap[singlePair.dutyID]
    end

    return ret
end

--- 刷新保存的记录
--- 如果有重复保存的，就重置保存顺序
function _refreshMap()
    if nil == _doNotShowHintMap then
        return
    end

    local uidStr = tostring(MPlayerInfo.UID)
    for i = #_doNotShowHintMap, 1, -1 do
        local singleUID = _doNotShowHintMap[i]
        if singleUID == uidStr then
            table.remove(_doNotShowHintMap, i)
        end
    end

    table.insert(_doNotShowHintMap, uidStr)
end

--- 载入所有已经保存的需要不再提示的玩家UID
function _loadMap()
    if nil == _doNotShowHintMap then
        _doNotShowHintMap = {}
    end

    local saveStr = PlayerPrefs.GetString(C_PLAYER_PREF_SAVE_OPTION)
    if nil == saveStr then
        return
    end

    local dataMatrix = _strParseMgr.ParseValue(saveStr, GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.String)
    for i = 1, #dataMatrix do
        local singleUID = dataMatrix[i]
        _doNotShowHintMap[i] = singleUID
    end
end

--- 保存角色映射表
function _saveMap()
    if nil == _doNotShowHintMap then
        return
    end

    local saveStr = ""
    for i = 1, #_doNotShowHintMap do
        local singleUID = _doNotShowHintMap[i]
        saveStr = saveStr + singleUID
        if i ~= #_doNotShowHintMap then
            saveStr = saveStr .. C_STR_UID_TIME_SYMBOL
        end
    end

    PlayerPrefs.SetString(C_PLAYER_PREF_SAVE_OPTION, saveStr)
end

return ModuleMgr.TeamMatchOptionMgr