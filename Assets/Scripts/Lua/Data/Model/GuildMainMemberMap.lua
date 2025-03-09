--- 这个类的职责是维护角色UID到公会UID的映射表
--- 为了取回角色显示数据的时候能够快速找到对应的公会
module("Data", package.seeall)

GuildMainMemberMap = class("GuildMainMemberMap")

function GuildMainMemberMap._newIndex(table, key, value)
    if nil == table[key] then
        error("[GuildMainMemberMap] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

function GuildMainMemberMap:ctor()
    local metatable = getmetatable(self)
    metatable.__newindex = nil

    self._memberMap = {}

    metatable.__newindex = self._newIndex
end

function GuildMainMemberMap:Clear()
    self._memberMap = {}
end

--- 为角色UID添加映射
function GuildMainMemberMap:AddPlayer(uid, guildUID)
    if nil == uid or nil == guildUID then
        logError("[GuildMainMemberMap] invalid param")
        return
    end

    self._memberMap[uid] = guildUID
end

--- 取回角色对应的公会UID
function GuildMainMemberMap:GetPlayerGuildUID(uid)
    if nil == uid then
        logError("[GuildMainMemberMap] invalid param")
        return nil
    end

    return self._memberMap[uid]
end