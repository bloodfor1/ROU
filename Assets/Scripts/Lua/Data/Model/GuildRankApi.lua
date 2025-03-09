require "Data/Model/GuildRankData"
require "Data/Model/GuildScoreData"
require "Data/Model/GuildMainMemberMap"

module("Data", package.seeall)
GuildRankApi = class("GuildRankApi")
local ELuaBaseType = GameEnum.ELuaBaseType
--- 每次增量获取数据的数量
local C_EXPEND_VALUE = 6
--- 每个页对表ID的映射
local C_PAGE_TABLE_ID_MAP = {
    [GameEnum.EGuildRankPageType.Elite] = 800,
    [GameEnum.EGuildRankPageType.Normal] = 810,
}

local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")

--- 从公会表当中获取数据
local function _parseDataFromTable(key, valueStruct, valueType)
    local tableStr = TableUtil.GetGuildActivityTable().GetRowBySetting(key).Value
    local ret = strParseMgr.ParseValue(tableStr, valueStruct, valueType)
    return ret
end

local C_GUILD_SCROLL_VIEW_COUNT = _parseDataFromTable("RoyalRaceShowListNum", GameEnum.EStrParseType.Value, GameEnum.ELuaBaseType.Number)

function GuildRankApi:ctor()
    ---@type table<number, table<number, GuildRankData[]>>
    self._rankMap = {
        [GameEnum.EGuildRankPageType.Elite] = {},
        [GameEnum.EGuildRankPageType.Normal] = {}
    }

    self._selfGuildUID = 0
    self._currentSeason = 0
    self._remainTime = 0
    self._memberMap = Data.GuildMainMemberMap.new()
    self._selfRankData = Data.GuildScoreData.new()
end

--- 排序用的算法，外部需要获取的时候需要传参来决定是否需要排序算法
---@param leftData GuildRankData
---@param rightData GuildRankData
function GuildRankApi._sortFunc(leftData, rightData)
    if nil == leftData or nil == rightData then
        logError("[GuildRankApi] invalid sort param, element cannot be nil")
        return true
    end

    if leftData:GetScore() ~= rightData:GetScore() then
        return leftData:GetScore() > rightData:GetScore()
    end

    return leftData:GetRank() < rightData:GetRank()
end

--- 每次关闭页面的时候要清空缓存数据
function GuildRankApi:Clear()
    self._rankMap = {
        [GameEnum.EGuildRankPageType.Elite] = {},
        [GameEnum.EGuildRankPageType.Normal] = {}
    }

    self._selfRankData:Clear()
    self._memberMap:Clear()
end

function GuildRankApi:ClearRankData()
    self._rankMap = {
        [GameEnum.EGuildRankPageType.Elite] = {},
        [GameEnum.EGuildRankPageType.Normal] = {}
    }

    self._memberMap:Clear()
end

function GuildRankApi:GetSelfCurrentRank()
    return self._selfRankData._currentSelfRank
end

--- 获取自身工会指定类型的分数
---@param scoreType number
---@return number
function GuildRankApi:GetSelfGuildScoreByType(scoreType)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildRankApi] invalid param type: " .. type(scoreType))
        return nil
    end

    return self._selfRankData:GetScoreByType(scoreType)
end

--- 获取自身工会指定类型的排名，主要是奖杯和图片方面使用
function GuildRankApi:GetSelfGuildRankByType(scoreType)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildRankApi] invalid param type: " .. type(scoreType))
        return nil
    end

    return self._selfRankData:GetRankByType(scoreType)
end

--- 通过类型和是否排序来获取工会排名的数据，这边只返回全量的排序数据，具体想要取哪块不关心
--- 排序参数如果没有传，默认是不排序
---@param scoreType number
---@param sort boolean
---@return GuildRankData[]
function GuildRankApi:GetGuildRankListByType(pageType, scoreType, sort)
    if ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildRankApi] invalid param type: " .. type(scoreType))
        return nil
    end

    if ELuaBaseType.Number ~= type(pageType) then
        logError("[GuildRankApi] invalid param type: " .. type(pageType))
        return nil
    end

    local page = self._rankMap[pageType]
    if nil == page then
        logError("[GuildRankApi] invalid page idx: " .. tostring(pageType))
        return nil
    end

    local ret = page[scoreType]
    if nil == ret then
        return {}
    end

    local retArray = {}
    for key, value in pairs(ret) do
        table.insert(retArray, value)
    end

    if sort then
        table.sort(retArray, self._sortFunc)
        return retArray
    else
        return retArray
    end

    return {}
end

function GuildRankApi:GetSelfGuildUID()
    return self._selfGuildUID
end

--- 这个是uint64，玩家公会UID是存放在另一个模块的数据，所以再开界面前要先取一下
function GuildRankApi:SetGuildUID(uid)
    if nil == uid then
        logError("[GuildRankApi] invalid param")
        return
    end

    self._selfGuildUID = uid
end

function GuildRankApi:GetBoardIdByType(clientType)
    local boardType = self._selfRankData._guildCurrentScoreRankType[clientType]
    return C_PAGE_TABLE_ID_MAP[boardType]
end

function GuildRankApi:GetLastSeasonRankByType(clientType)
    return self._selfRankData:GetLastSeasonRankType(clientType)
end

--- 只请求公会的排名
function GuildRankApi:ReqSelfGuildRankInfo(timeOutFunc)
    local l_msgId = Network.Define.Rpc.SelfRankRpc

    ---@type SelfRankArg
    local l_sendInfo = GetProtoBufSendTable("SelfRankArg")
    -- todo 这个地方类型和公会的UID类型没有对齐，这便是uint64，公会UID是int64
    l_sendInfo.key_id = tostring(self._selfGuildUID)
    local clientType = self._selfRankData._guildCurrentScoreRankType[GameEnum.EGuildScoreType.Total]
    l_sendInfo.board_id = C_PAGE_TABLE_ID_MAP[clientType]
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, timeOutFunc)
end

--- 只更新公会的当前排名，且类型只有总分
---@param msg SelfRankRes
function GuildRankApi:OnRankInfoOnlyRsp(rank)
    if nil == rank then
        logError("[GuildRankApi] invalid param")
        return
    end

    self._selfRankData:UpdateSelfRank(rank)
end

--- 请求全部内容
function GuildRankApi:ReqSelfGuildScoreInfo(timeOutFunc)
    local l_msgId = Network.Define.Rpc.GuildRankActivityRpc

    ---@type GuildRankActivityArg
    local l_sendInfo = GetProtoBufSendTable("GuildRankActivityArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, timeOutFunc)
end

---@param msg GuildRankScoreDBInfo
function GuildRankApi:OnSelfGuildRankInfoRsp(msg)
    if not msg then
        logError("[GuildRankApi] invalid param")
        return
    end

    for i = 1, #msg.data_list do
        local singleData = msg.data_list[i]
        self._selfRankData:UpdatePlayerScoreData(singleData)
    end
end

--- 如果发送了请求就肯定会请求下一批数据，至于是否请求下一批数据的判断不是在这里做的
function GuildRankApi:ReqRankByTypePage(page, scoreType, timeOutFunc)
    local l_msgId = Network.Define.Rpc.GetGuildLeaderBoardByRank
    local tableID = C_PAGE_TABLE_ID_MAP[page]
    local svrKey = tableID + scoreType
    if nil == self._rankMap[page][scoreType] then
        self._rankMap[page][scoreType] = {}
    end

    local currentCount = self:_getCount(self._rankMap[page][scoreType])
    local startIdx = currentCount + 1
    local endIdx = C_EXPEND_VALUE + currentCount
    if C_GUILD_SCROLL_VIEW_COUNT < endIdx then
        endIdx = C_GUILD_SCROLL_VIEW_COUNT
    end

    ---@type GetGuildLeaderBoardArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildLeaderBoardArg")
    l_sendInfo.board_id = svrKey
    l_sendInfo.begin_rank = startIdx
    l_sendInfo.end_rank = endIdx
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, timeOutFunc)
end

--- 保存公会数据的时候使用的是哈希表，这边需要计算一下哈希表的长度
function GuildRankApi:_getCount(hashMap)
    if nil == hashMap then
        logError("[GuildRankApi] invalid param")
        return 0
    end

    local ret = 0
    for key, value in pairs(hashMap) do
        ret = ret + 1
    end

    return ret
end

---@param msg GuildLeaderBoardRowData[]
---@return number[]
function GuildRankApi:OnRankInfoRsp(msg, currentPage, currentType)
    if nil == msg then
        logError("[GuildRankApi] invalid param")
        return {}
    end

    local uidArray = {}
    for i = 1, #msg do
        local newRankData = Data.GuildRankData.new()
        newRankData:UpdateData(msg[i])
        local targetMap = self._rankMap[currentPage][currentType]

        --- 有可能在这个节点数据已经被清空了，触发的是强行刷新逻辑
        if nil == targetMap then
            self._rankMap[currentPage][currentType] = {}
        end

        self._rankMap[currentPage][currentType][newRankData._id] = newRankData
        for j = 1, #msg[i].member_list do
            local singleMemberUID = msg[i].member_list[j]
            self._memberMap:AddPlayer(singleMemberUID, msg[i].guild_id)
            table.insert(uidArray, singleMemberUID)
        end
    end

    return uidArray
end

---@param msg RoleSmallPhotoData[]
function GuildRankApi:UpdateMemberInfo(msg, pageType, filtrateType)
    if nil == msg then
        logError("[GuildRankApi] invalid param")
        return
    end

    for i = 1, #msg do
        local singlePlayerIconData = msg[i]
        local guildUID = self._memberMap:GetPlayerGuildUID(singlePlayerIconData.role_id)
        local guildData = self._rankMap[pageType][filtrateType][guildUID]
        if nil ~= guildData then
            guildData:TryUpdateGuildMemberData(singlePlayerIconData)
        else
            logError("invalid guild uid: " .. tostring(guildUID) .. " msg count: " .. #msg)
            -- todo 测试代码
            --logError(tostring(singlePlayerIconData.role_id))
            --logError(ToString(self._memberMap._memberMap))
        end
    end
end

return Data.GuildRankApi