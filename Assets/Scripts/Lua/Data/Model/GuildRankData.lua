require "Data/Model/GuildMainMemberData"

--- 这个类当中负责维护单个排名所需要的数据，主要是包括工会的名字，ID，积分，主要的三个成员
module("Data", package.seeall)

---@class GuildRankData
GuildRankData = class("GuildRankData")
local ELuaBaseType = GameEnum.ELuaBaseType
local C_REQUIRE_MEMBER_COUNT = 3
local C_DEFAULT_NAME = "NIL"

function GuildRankData._newIndex(table, key, value)
    if nil == table[key] then
        error("[GuildRankData] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

function GuildRankData:ctor()
    local metatable = getmetatable(self)
    metatable.__newindex = nil

    self._rank = 0
    self._id = 0
    self._name = C_DEFAULT_NAME
    self._score = 0
    ---@type GuildMainMemberData[]
    self._mainMembers = {}
    metatable.__newindex = self._newIndex
end

---@return number
function GuildRankData:GetID()
    return self._id
end

---@return string
function GuildRankData:GetGuildName()
    return self._name
end

function GuildRankData:GetRank()
    return self._rank
end

---@return GuildMainMemberData
function GuildRankData:GetMemberDataByIdx(index)
    if ELuaBaseType.Number ~= type(index) then
        logError("[GuildRankData] invalid param type, type: " .. type(index))
        return nil
    end

    if C_REQUIRE_MEMBER_COUNT < index then
        logError("[GuildRankData] invalid index：" .. tostring(index))
        return nil
    end

    return self._mainMembers[index]
end

---@return number
function GuildRankData:GetScore()
    return self._score
end

---@param pbData GuildLeaderBoardRowData
function GuildRankData:UpdateData(pbData)
    if nil == pbData then
        logError("[GuildRankData] param got nil, update failed")
        return
    end

    self._id = pbData.guild_id
    self._name = pbData.guild_name
    self._score = pbData.score
    self._rank = pbData.rank
    
    for i = 1, #pbData.member_list do
        local singleMember = Data.GuildMainMemberData.new()
        singleMember.UID = pbData.member_list[i]
        table.insert(self._mainMembers, singleMember)
    end
end

---@param iconData RoleSmallPhotoData
function GuildRankData:TryUpdateGuildMemberData(iconData)
    if nil == iconData then
        logError("[GuildRankData] param got nil, update failed")
        return
    end

    for i = 1, #self._mainMembers do
        if self._mainMembers[i].UID == iconData.role_id then
            self._mainMembers[i]:UpdateData(iconData)
        end
    end
end

return Data.GuildRankData