--- 这个数据是当前玩家自身的数据，负责记录玩家自身工会所拥有的排名和分数数据
--- 主要是用来显示奖杯，分数和角色名字HUD上的标签
--- 每次更新需要重新向服务器发消息
module("Data", package.seeall)

---@class GuildScoreData
GuildScoreData = class("GuildScoreData")
local EGuildScoreType = GameEnum.EGuildScoreType
local ELuaBaseType = GameEnum.ELuaBaseType
local C_INVALID_RANK = 0

--- 服务器类型和客户端类型转换映射表
--- 会有总类型是因为需要上个赛季排名
local C_SVR_CLIENT_SCORE_TYPE_MAP = {
    [GuildRankScoreType.GuildRankScoreTypeMatch] = GameEnum.EGuildScoreType.GuildEliteMatch,
    [GuildRankScoreType.GuildRankScoreTypeHunter] = GameEnum.EGuildScoreType.GuildHunt,
    [GuildRankScoreType.GuildRankScoreTypeDinner] = GameEnum.EGuildScoreType.GuildCooking,
    [GuildRankScoreType.GuildRankScoreTypeTotal] = GameEnum.EGuildScoreType.Total,
}

--- 客户端和服务器的转换映射
local C_SVR_CLIENT_PAGE_MAP = {
    [GuildRoyalType.GuildRoyalTypeFirst] = GameEnum.EGuildRankPageType.Elite,
    [GuildRoyalType.GuildRoyalTypeSecond] = GameEnum.EGuildRankPageType.Normal,
}

--- 重写元表，不允许随意添加数据
function GuildScoreData._newIndex(table, key, value)
    if nil == table[key] then
        error("[GuildScoreData] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

function GuildScoreData:ctor()
    local metatable = getmetatable(self)
    metatable.__newindex = nil

    --- 本公会当前赛季的排名
    self._currentSelfRank = 0

    --- 当前赛季的积分
    ---@type table<number, number>
    self._guildScoreMap = {
        [EGuildScoreType.GVG] = C_INVALID_RANK,
        [EGuildScoreType.GuildHunt] = C_INVALID_RANK,
        [EGuildScoreType.GuildEliteMatch] = C_INVALID_RANK,
        [EGuildScoreType.GuildCooking] = C_INVALID_RANK,
        [EGuildScoreType.Total] = C_INVALID_RANK,
    }

    --- 当前各类排名的类型
    self._guildCurrentScoreRankType = {
        [EGuildScoreType.GVG] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildHunt] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildEliteMatch] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildCooking] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.Total] = GameEnum.EGuildRankPageType.None,
    }

    --- 这个是上一个赛季的排名
    ---@type table<number, number>
    self._guildRankMap = {
        [EGuildScoreType.GVG] = 0,
        [EGuildScoreType.GuildHunt] = 0,
        [EGuildScoreType.GuildEliteMatch] = 0,
        [EGuildScoreType.GuildCooking] = 0,
        [EGuildScoreType.Total] = 0,
    }

    --- 上个赛季排名的类型
    self._guildLastSeasonRankType = {
        [EGuildScoreType.GVG] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildHunt] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildEliteMatch] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildCooking] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.Total] = GameEnum.EGuildRankPageType.None,
    }

    metatable.__newindex = self._newIndex
end

function GuildScoreData:Clear()
    self._currentSelfRank = 0
    self._guildRankMap = {
        [EGuildScoreType.GVG] = 0,
        [EGuildScoreType.GuildHunt] = 0,
        [EGuildScoreType.GuildEliteMatch] = 0,
        [EGuildScoreType.GuildCooking] = 0,
        [EGuildScoreType.Total] = 0,
    }

    self._guildScoreMap = {
        [EGuildScoreType.GVG] = C_INVALID_RANK,
        [EGuildScoreType.GuildHunt] = C_INVALID_RANK,
        [EGuildScoreType.GuildEliteMatch] = C_INVALID_RANK,
        [EGuildScoreType.GuildCooking] = C_INVALID_RANK,
        [EGuildScoreType.Total] = C_INVALID_RANK,
    }

    --- 当前各类排名的类型
    self._guildCurrentScoreRankType = {
        [EGuildScoreType.GVG] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildHunt] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildEliteMatch] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildCooking] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.Total] = GameEnum.EGuildRankPageType.None,
    }

    self._guildLastSeasonRankType = {
        [EGuildScoreType.GVG] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildHunt] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildEliteMatch] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.GuildCooking] = GameEnum.EGuildRankPageType.None,
        [EGuildScoreType.Total] = GameEnum.EGuildRankPageType.None,
    }
end

---@return number
function GuildScoreData:GetScoreByType(scoreType)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildScoreData] invalid param type: " .. type(scoreType))
        return nil
    end

    return self._guildScoreMap[scoreType]
end

---@return number
function GuildScoreData:GetRankByType(scoreType)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildScoreData] invalid param type: " .. type(scoreType))
        return nil
    end

    return self._guildRankMap[scoreType]
end

--- 获取上一个赛季指定类型的组别类型，可能是普通组，也可能是精英组
function GuildScoreData:GetLastSeasonRankType(scoreType)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildScoreData] invalid param type: " .. type(scoreType))
        return nil
    end

    return self._guildLastSeasonRankType[scoreType]
end

--- 获取当前的公会排名
function GuildScoreData:GetSelfRank()
    return self._currentSelfRank
end

--- 更新当前的公会排名
function GuildScoreData:UpdateSelfRank(rank)
    self._currentSelfRank = rank
end

--- 更新用的数据，这边负责更新数据写入，主要是用来接网络消息
---@param pbData GuildRankScoreUnitData
function GuildScoreData:UpdatePlayerScoreData(pbData)
    if nil == pbData then
        logError("[GuildScoreData] Update Failed, pb data got nil")
        return
    end

    local clientType = C_SVR_CLIENT_SCORE_TYPE_MAP[pbData.rank_score_type]
    if nil == clientType then
        logError("[GuildScoreData] redundant svr type: " .. pbData.rank_score_type)
        return
    end

    self._guildRankMap[clientType] = pbData.last_season_rank
    self._guildLastSeasonRankType[clientType] = C_SVR_CLIENT_PAGE_MAP[pbData.last_royal_type]
    self._guildScoreMap[clientType] = pbData.score_value
    self._guildCurrentScoreRankType[clientType] = C_SVR_CLIENT_PAGE_MAP[pbData.current_royal_type]
end

return Data.GuildScoreData