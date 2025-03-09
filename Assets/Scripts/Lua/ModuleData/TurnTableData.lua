--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-11 14:06:17
--

module("ModuleData.TurnTableData", package.seeall)

QueryTurnTableRewardCount = 10

-- 缓存转盘奖励信息，用于转盘结束后做奖励提示
CacheAwardResult = nil

IsAction = false

local cachedTips = {}

function GetTickyRewardsPreview(awardId)

    local l_awardRow = TableUtil.GetAwardTable().GetRowByAwardId(awardId)
    if not l_awardRow then
        return
    end

    local l_awardPackIds = Common.Functions.VectorToTable(l_awardRow.PackIds)
    local l_awardPackRow = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardPackIds[1] or 0)
    if not l_awardPackRow then
        return
    end

    return Common.Functions.VectorSequenceToTable(l_awardPackRow.GroupContent)
end

function CacheTips(str)

    table.insert(cachedTips, str)
end

function PopCacheTips()

    local l_ret = cachedTips
    cachedTips = {}
    return l_ret
end

return ModuleData.TurnTableData