---@module ModuleMgr.TeamMatchProcessMgr
module("ModuleMgr.TeamMatchProcessMgr", package.seeall)

local C_BRIEF_DEFAULT_POS = { x = 0, y = 0, z = 0 }

--- 如果匹配时长没有读取到，默认返回这个
local C_DEFAULT_MATCH_TIME = 10

---@type ROPos
local cachePos = nil

--- 获取匹配市场上限
function GetMatchLimitTime()
    local C_TIME_LIMIT_KEY = "MatchTime"
    local matchTimeConfig = TableUtil.GetGlobalTable().GetRowByName(C_TIME_LIMIT_KEY)
    local matchTime = C_DEFAULT_MATCH_TIME
    if nil ~= matchTimeConfig then
        matchTime = tonumber(matchTimeConfig.Value)
    else
        logError("[TeamMatch] " .. tostring(C_TIME_LIMIT_KEY) .. " got nil")
    end

    return matchTime
end

--- 获取保存的位置
---@return ROPos
function GetCurrentPos()
    if nil == cachePos then
        cachePos = C_BRIEF_DEFAULT_POS
    end

    return cachePos
end

--- 更新位置
---@param currentPos ROPos
function UpdatePos(currentPos)
    if nil == cachePos then
        cachePos = C_BRIEF_DEFAULT_POS
    end

    cachePos = currentPos
end

--- 获取玩家匹配中模式显示的标签
---@return number[]
function GetSelfDutyIDs()
    local playerPro = MPlayerInfo.ProID
    local config = TableUtil.GetProfessionTable().GetRowById(playerPro)
    if nil == config then
        return {}
    end

    --if 1 >= config.MatchDuty.Length then
    --    return {}
    --end

    local matchOptionMgr = MgrMgr:GetMgr("TeamMatchOptionMgr")
    return matchOptionMgr.GetDutyList()
end

--- 会返回是不是自由匹配模式
---@return TeamIconParam[], boolean
function GetMemberInfoList()
    local leaderMgr = MgrMgr:GetMgr("TeamLeaderMatchMgr")
    local ret = leaderMgr.GetMemberShowConfig()
    local isFreeMatch = true
    local EDuty = GameEnum.ETeamDuty
    local C_VALID_STATE_MAP = {
        [EDuty.Occupied] = 1,
        [EDuty.Free] = 1,
    }

    local target = DataMgr:GetData("TeamData").myTeamInfo.teamSetting.target
    local targetInfo = TableUtil.GetTeamTargetTable().GetRowByID(target, true)
    if not targetInfo then
        logError("Zxs TeamMatch Bugly DebugHelper TeamTargetID = ", target, ToString(DataMgr:GetData("TeamData").myTeamInfo.teamSetting))
        return ret, true
    end
    isFreeMatch = not targetInfo.IsDuty
    --todo 是否自由模式
    --for i = 1, #ret do
    --    local singleConfig = ret[i]
    --    if nil == C_VALID_STATE_MAP[singleConfig.dutyID] then
    --        isFreeMatch = false
    --        break
    --    end
    --end

    return ret, isFreeMatch
end

return ModuleMgr.TeamMatchProcessMgr