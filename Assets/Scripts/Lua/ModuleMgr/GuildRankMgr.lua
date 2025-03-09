require "Data/Model/GuildRankApi"

--- 包装一层，这边主要是负责应对一些UI上的需求
---@module ModuleMgr.GuildRankMgr
module("ModuleMgr.GuildRankMgr", package.seeall)
GuildRankApi = Data.GuildRankApi.new()
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")
local dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
local cachePageState = GameEnum.EGuildRankPageType.None
local cacheFiltrateState = GameEnum.EGuildScoreType.None
local C_GUILD_TROPHY_MIN_RANGE = 4
local C_GUILD_TROPHY_MAX_RANGE = 20
local C_GUILD_ACTIVITY_TROPHY_COUNT = 5
local C_GUILD_SCROLL_VIEW_COUNT = 0
--- 延迟多秒刷新
local C_GUILD_EXTRA_SEC_COUNT = 3
local C_GUILD_RANK_MZ_REFRESH_TIME = 86400
local cacheNeedRefresh = false
local enterUI = false
--- 强制刷新的活动ID映射表
local forceRefreshMap = {}

--- 工会积分，类型和表配置编号的映射
local C_GUILD_SCORE_IDX_MAP = {
    [GameEnum.EGuildScoreType.GuildHunt] = 1,
    [GameEnum.EGuildScoreType.GuildCooking] = 2,
    [GameEnum.EGuildScoreType.GuildEliteMatch] = 3,
    [GameEnum.EGuildScoreType.GVG] = 4,
}

--- 各个活动开发的情况
local C_GUILD_RANK_OPEN_MAP = {
    [GameEnum.EGuildScoreType.GuildHunt] = true,
    [GameEnum.EGuildScoreType.GuildCooking] = true,
    [GameEnum.EGuildScoreType.GuildEliteMatch] = true,
    [GameEnum.EGuildScoreType.GVG] = false,
}

--- 奖杯名映射表
local C_GUILD_TYPE_ACT_NAME_MAP = {
    [GameEnum.EGuildScoreType.Total] = Lang("C_GUILD_TOTAL"),
    [GameEnum.EGuildScoreType.GuildHunt] = Lang("C_GUILD_ACT_HUNT"),
    [GameEnum.EGuildScoreType.GuildCooking] = Lang("C_GUILD_ACT_COOK"),
    [GameEnum.EGuildScoreType.GuildEliteMatch] = Lang("C_GUILD_ACT_ELITE_MATCH"),
}

--- 荣誉组第N名
local C_DEFAULT_STR = Lang("C_GUILD_RANK_NORMAL_N")
--- 未上榜
local C_GUILD_RANK_NO_RANK = Lang("C_GUILD_RANK_NO_RANK")
--- 第一个赛季排名
local C_GUILD_RAND_DEFAULT_DESC = Lang("C_GUILD_RANK_DESC")

--- 名次描述字符串
local C_GUILD_RANK_STR_MAP = {
    [GameEnum.EGuildRankPageType.Elite] = Lang("C_GUILD_RANK_ELITE"),
    [GameEnum.EGuildRankPageType.Normal] = Lang("C_GUILD_RANK_NORMAL"),
}

function OnInit()
    dailyTaskMgr.EventDispatcher:Add(dailyTaskMgr.DAILY_ACTIVITY_STATE_CHANGE, _onEventChange, nil)
    _genEventIDMap()
    C_GUILD_SCROLL_VIEW_COUNT = _parseDataFromTable("RoyalRaceShowListNum", GameEnum.EStrParseType.Value, GameEnum.ELuaBaseType.Number)
end

function _genEventIDMap()
    local actIDs = _parseDataFromTable("RoyalRaceActivities", GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.Number)
    for i = 1, #actIDs do
        forceRefreshMap[actIDs[i]] = 1
    end
end

function GetSelfGuildScoreByType(scoreType)
    return GuildRankApi:GetSelfGuildScoreByType(scoreType)
end

--- 获取当前的公会排名
function GetSelfCurrentRank()
    return GuildRankApi:GetSelfCurrentRank()
end

--- 获取上一次排名的数据
function GetSelfGuildRankByType(scoreType)
    return GuildRankApi:GetSelfGuildRankByType(scoreType)
end

function GetGuildRankListByType(pageType, scoreType, sort)
    return GuildRankApi:GetGuildRankListByType(pageType, scoreType, sort)
end

--- 尝试开UI
function TryUpdateInfo(paramEnterUI)
    local guildUID = DataMgr:GetData("GuildData").selfGuildMsg.id
    GuildRankApi:SetGuildUID(guildUID)
    _reqSelfGuildRankInfo(paramEnterUI)
end

--- 是否是第一赛季
function IsFirstSeason()
    return _isFirstSeason()
end

function _isFirstSeason()
    return 1 == GuildRankApi._currentSeason
end

--- 获取剩余多少秒
function GetRemainSeconds()
    -- todo 测试代码
    --do
    --    return C_GUILD_EXTRA_SEC_COUNT
    --end

    local currentTimeStamp = MServerTimeMgr.UtcSeconds
    local remainTime = tonumber(GuildRankApi._remainTime) - tonumber(currentTimeStamp)
    return remainTime + C_GUILD_EXTRA_SEC_COUNT
end

--- 获取赛季的剩余时间
function GetRemainDays()
    local currentTimeStamp = MServerTimeMgr.UtcSeconds
    local remainTime = tonumber(GuildRankApi._remainTime) - tonumber(currentTimeStamp)
    return math.modf(remainTime / C_GUILD_RANK_MZ_REFRESH_TIME)
end

---@param state boolean
function _onEventChange(id, state)
    if state then
        return
    end

    if nil == forceRefreshMap[id] then
        return
    end

    GuildRankApi:Clear()
    _reqSelfGuildRankInfo(false)
end

--- 强制重新获取全部数据，全刷
function ForceRefreshAll()
    GuildRankApi:Clear()
    _reqSelfGuildRankInfo(false)
end

--- 收到服务器回包的回调，这里走的是通用协议
---@param msg RoleLeaderBoardRank[]
function _onCommonGroupRsp(msg)
    if nil == msg or 0 == #msg then
        logError("[GuildRankMgr] req self rank failed")
        return
    end

    local currentGuildRank = 0
    currentGuildRank = msg[1].row.rank
    GuildRankApi:OnRankInfoOnlyRsp(currentGuildRank)
    _forceRefreshUI()
end

--- 尝试拉取服务器信息，走通用协议
function _tryReqRankThroughCommon()
    GuildRankApi:ReqSelfGuildRankInfo(_onReqTimeOut)
    local boardID = GuildRankApi:GetBoardIdByType(GameEnum.EGuildScoreType.Total)
    local idList = { tostring(GuildRankApi:GetSelfGuildUID()) }
    local svrType = LeaderBoardRequestType.LeaderBoardRequestTypeGuildRoyal
    MgrMgr:GetMgr("CommonGroupDataNetMgr").ReqGroupData(boardID, idList, svrType, _onCommonGroupRsp, nil)
end

--- 强制刷新UI
function _forceRefreshUI()
    if enterUI then
        UIMgr:ActiveUI(UI.CtrlNames.GuildRank_ScorePanel)
        enterUI = false
    end

    gameEventMgr.RaiseEvent(gameEventMgr.ForceRefreshGuildRank)
end

function _reqSelfGuildRankInfo(paramEnterUI)
    enterUI = paramEnterUI
    GuildRankApi:ReqSelfGuildScoreInfo(_onReqTimeOut)
end

function OnSelfGuildRankInfoRsp(msg)
    ---@type GuildRankActivityRes
    local l_info = ParseProtoBufToTable("GuildRankActivityRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.result)
        return
    end

    GuildRankApi._currentSeason = l_info.current_season
    GuildRankApi._remainTime = l_info.season_end_time
    GuildRankApi:OnSelfGuildRankInfoRsp(l_info.royal_info)
    _tryReqRankThroughCommon()
end

--- 尝试对指定的类型进行扩容，如果满了，就不扩容
--- 如果容器没有满，而且需要扩容了，则扩容
function TryExpendData(pageType, filtrateType, idx)
    local currentRankInfoCount = #GuildRankApi:GetGuildRankListByType(pageType, filtrateType, false)
    if currentRankInfoCount >= C_GUILD_SCROLL_VIEW_COUNT then
        return
    end

    if idx < currentRankInfoCount then
        return
    end

    GuildRankApi:ReqRankByTypePage(pageType, filtrateType, _onReqTimeOut)
end

--- 会进到这个方法的时候一定是有缓存状态的，如果没有说明有问题
function OnRankInfoRsp(msg)
    ---@type GetGuildLeaderBoardRes
    local l_info = ParseProtoBufToTable("GetGuildLeaderBoardRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.result)
        return
    end

    local currentGuildInfo = GuildRankApi:GetGuildRankListByType(cachePageState, cacheFiltrateState, false)
    local currentCount = #currentGuildInfo
    if 0 == currentCount then
        cacheNeedRefresh = true
    end

    local uidList = GuildRankApi:OnRankInfoRsp(l_info.datas, cachePageState, cacheFiltrateState)
    _tryUpdatePlayers(uidList)
end

function _tryUpdatePlayers(uidList)
    MgrMgr:GetMgr("CommonIconNetMgr").ReqPlayerIconDataList(uidList, _onPlayerIconUpdate, nil)
end

function _onPlayerIconUpdate(netInfoList)
    GuildRankApi:UpdateMemberInfo(netInfoList, cachePageState, cacheFiltrateState)

    ---@type GuildRankPageState
    local param = {
        pageState = cachePageState,
        typeState = cacheFiltrateState,
        needRefresh = cacheNeedRefresh,
    }

    cacheNeedRefresh = false
    gameEventMgr.RaiseEvent(gameEventMgr.OnRefreshGuildRank, param)
end

--- 请求超时的提示回调
function _onReqTimeOut(msgId)
    local str = Lang("SVR_TIME_OUT") .. tostring(msgId)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
end

--- 关闭积分面板
function OnCloseClick()
    GuildRankApi:Clear()
    UIMgr:DeActiveUI(UI.CtrlNames.GuildRank_ScorePanel)
end

--- 点击排行版按钮
function OnRankClick()
    UIMgr:ActiveUI(UI.CtrlNames.GuildRank)
end

--- 点击奖杯按钮，开启奖杯面板
function OnTrophyClick()
    if _isFirstSeason() then
        local str = Lang("C_FIRST_SEASON_NO_TROPHY")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
        return
    end

    UIMgr:ActiveUI(UI.CtrlNames.GuildRank_TrophyPanel)
end

--- 关闭奖杯按钮
function OnTrophyPanelClose()
    UIMgr:DeActiveUI(UI.CtrlNames.GuildRank_TrophyPanel)
end

--- 关闭排行榜页面
function OnRankPanelClose()
    GuildRankApi:ClearRankData()
    UIMgr:DeActiveUI(UI.CtrlNames.GuildRank)
end

--- UI调用的函数
---@return GuildRankScoreData
function GetRankScorePairByScoreType(scoreType)
    if GameEnum.ELuaBaseType.Number ~= type(scoreType) then
        logError("[GuildRankMgr] invalid param type: " .. type(scoreType))
        return nil
    end

    local spriteConfig = _parseDataFromTable("RoyalRaceActivitiesIcon", GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.String)
    local targetIdx = C_GUILD_SCORE_IDX_MAP[scoreType]
    local targetConfig = spriteConfig[targetIdx]
    local descArray = _parseDataFromTable("RoyalRaceActivitiesScoreName", GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.String)
    local targetDesc = descArray[targetIdx]
    local targetShowNameConfig = _parseDataFromTable("RoyalRaceActivitiesName", GameEnum.EStrParseType.Array, GameEnum.ELuaBaseType.String)

    ---@type GuildRankScoreData
    local ret = {
        rank = GuildRankApi:GetSelfGuildRankByType(scoreType),
        score = GuildRankApi:GetSelfGuildScoreByType(scoreType),
        atlasName = targetConfig[1],
        spriteName = targetConfig[2],
        desc = Lang(targetDesc),
        name = Lang(targetShowNameConfig[targetIdx]),
        isOpening = C_GUILD_RANK_OPEN_MAP[scoreType]
    }

    return ret
end

--- 目前这个方法只有总排名，没有单独排名
---@return string
function GetGuildRankStr()
    local currentRank = GuildRankApi:GetSelfCurrentRank()
    local rankValue = _parseDataFromTable("SecondDivisionShowLimit", GameEnum.EStrParseType.Value, GameEnum.ELuaBaseType.Number)
    if 0 == currentRank then
        return C_GUILD_RANK_NO_RANK
    end

    if -1 == currentRank then
        return tostring(rankValue) .. "+"
    end

    --- 如果是第一个赛季，直接返回默认表述
    if _isFirstSeason() then
        return StringEx.Format(C_GUILD_RAND_DEFAULT_DESC, tostring(currentRank))
    end

    local currentGuildRankType = GuildRankApi._selfRankData._guildCurrentScoreRankType[GameEnum.EGuildScoreType.Total]
    if currentRank > rankValue then
        return C_DEFAULT_STR
    end

    local str = C_GUILD_RANK_STR_MAP[currentGuildRankType]
    local ret = StringEx.Format(str, tostring(currentRank))
    return ret
end

--- UI调用的，获取奖杯显示数据
---@return GuildRankTrophyData[]
function GetTrophyDataList()
    local ret = {}
    local fullScore = _genTrophyDataByTypeRank(GameEnum.EGuildScoreType.Total)
    local guildHuntScore = _genTrophyDataByTypeRank(GameEnum.EGuildScoreType.GuildHunt)
    local guildCookingScore = _genTrophyDataByTypeRank(GameEnum.EGuildScoreType.GuildCooking)
    local guildEliteMatchScore = _genTrophyDataByTypeRank(GameEnum.EGuildScoreType.GuildEliteMatch)
    ret = _genTrophyArray(ret, fullScore)
    ret = _genTrophyArray(ret, guildHuntScore)
    ret = _genTrophyArray(ret, guildCookingScore)
    ret = _genTrophyArray(ret, guildEliteMatchScore)
    return ret
end

--- 将生成的奖杯数据放在一个数组当中，如果数据是空则不放
---@return GuildRankTrophyData
function _genTrophyArray(ret, data)
    if nil ~= data then
        table.insert(ret, data)
    end

    return ret
end

--- 根据类型和排名创建奖杯数据
---@return GuildRankTrophyData
function _genTrophyDataByTypeRank(type)
    ---@type GuildRankTrophyData
    local ret = {}
    ret.rank = GuildRankApi:GetSelfGuildRankByType(type)
    ret.desc = C_GUILD_TYPE_ACT_NAME_MAP[type]
    if 0 >= ret.rank then
        return nil
    end

    if C_GUILD_TROPHY_MAX_RANGE < ret.rank then
        return nil
    end

    local rankType = GuildRankApi:GetLastSeasonRankByType(type)
    if nil ~= C_GUILD_SCORE_IDX_MAP[type] then
        if GameEnum.EGuildRankPageType.Normal == rankType then
            return nil
        end

        if C_GUILD_ACTIVITY_TROPHY_COUNT < ret.rank then
            return nil
        end

        local spriteConfig = _parseDataFromTable("RoyalRaceActivitiesAwardIcon", GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.String)
        local targetIdx = C_GUILD_SCORE_IDX_MAP[type]
        local targetConfig = spriteConfig[targetIdx]
        ret.atlasName = targetConfig[1]
        if C_GUILD_TROPHY_MIN_RANGE <= ret.rank then
            ret.spName = StringEx.Format(targetConfig[2], tostring(C_GUILD_TROPHY_MIN_RANGE))
        else
            ret.spName = StringEx.Format(targetConfig[2], tostring(ret.rank))
        end

        --- 奖杯是按照上个赛季的排名发放的，随意当当前是第二个赛季的时候，奖杯是第一个赛季的
        if 2 == GuildRankApi._currentSeason then
            ret.rankDesc = StringEx.Format(Lang("C_GUILD_RANK_DESC"), tostring(ret.rank))
        else
            ret.rankDesc = StringEx.Format(Lang("C_GUILD_RANK_ELITE"), tostring(ret.rank))
        end

        return ret
    end

    if GameEnum.EGuildScoreType.Total == type then
        local spriteConfig = _parseDataFromTable("RoyalRaceDivisionAwardIcon", GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.String)
        local targetIdx = 0
        if GameEnum.EGuildRankPageType.Elite == rankType then
            targetIdx = 2
            ret.rankDesc = StringEx.Format(Lang("C_GUILD_RANK_ELITE"), tostring(ret.rank))
        else
            targetIdx = 1
            ret.rankDesc = StringEx.Format(Lang("C_GUILD_RANK_NORMAL"), tostring(ret.rank))
        end

        if 2 == GuildRankApi._currentSeason then
            ret.rankDesc = StringEx.Format(Lang("C_GUILD_RANK_DESC"), tostring(ret.rank))
        end

        local targetConfig = spriteConfig[targetIdx]
        ret.atlasName = targetConfig[1]
        if C_GUILD_TROPHY_MIN_RANGE <= ret.rank then
            ret.spName = StringEx.Format(targetConfig[2], tostring(C_GUILD_TROPHY_MIN_RANGE))
        else
            ret.spName = StringEx.Format(targetConfig[2], tostring(ret.rank))
        end

        return ret
    end

    return nil
end

--- UI页面是通过消息进行刷新的，这个方法会先判断是否有这个数据
--- 如果有则刷新，如果没有则向服务器请求数据，回包之后会刷新
function TryRefreshRankPage(pageType, filtrateType, forceGetFormSvr)
    if GameEnum.ELuaBaseType.Number ~= type(pageType)
            or GameEnum.ELuaBaseType.Number ~= type(filtrateType)
    then
        logError("[GuildRank] invalid param, do nothing")
        return
    end

    cachePageState = pageType
    cacheFiltrateState = filtrateType
    if forceGetFormSvr then
        GuildRankApi:Clear()
        GuildRankApi:ReqRankByTypePage(pageType, filtrateType, _onReqTimeOut)
        return
    end

    local rankList = GuildRankApi:GetGuildRankListByType(pageType, filtrateType, true)
    if nil ~= rankList and 0 < #rankList then
        ---@type GuildRankPageState
        local param = {
            pageState = pageType,
            typeState = filtrateType,
            needRefresh = true,
        }

        gameEventMgr.RaiseEvent(gameEventMgr.OnRefreshGuildRank, param)
        return
    end

    GuildRankApi:ReqRankByTypePage(pageType, filtrateType, _onReqTimeOut)
end

--- 将工会成员数据转义成头像数据
---@param guildMemberData GuildMainMemberData
function ParsePlayerIconData(guildMemberData)
    if nil == guildMemberData then
        logError("[GuildRank] param must not be nil")
        return nil
    end

    local equipData = MoonClient.MEquipData.New()
    equipData.IsMale = guildMemberData.Gender == GameEnum.EPlayerGender.Male
    equipData.ProfessionID = guildMemberData.Profession
    equipData.HairStyleID = guildMemberData.HairID
    equipData.EyeID = guildMemberData.EyeID
    equipData.EyeColorID = guildMemberData.EyeColorID
    equipData.FashionItemID = guildMemberData.FashionID
    equipData.HeadID = guildMemberData.HeadIconID
    equipData.OrnamentHeadItemID = guildMemberData.HelmetID
    equipData.OrnamentFaceItemID = guildMemberData.FaceMaskID
    equipData.OrnamentMouthItemID = guildMemberData.MouthGearID
    equipData.IconFrameID = guildMemberData.Frame
    return equipData
end

--- 点击头像之后需要弹出小窗口，需要进行操作
function OnSingleIconClick(uid)
    local l_openData = {
        openType = GameEnum.EHeadMenuOpenType.RefreshHeadIconByUid,
        Uid = uid
    }

    UIMgr:ActiveUI(UI.CtrlNames.PlayerMenuL, l_openData)
end

--- 从公会表当中获取数据
function _parseDataFromTable(key, valueStruct, valueType)
    local tableStr = TableUtil.GetGuildActivityTable().GetRowBySetting(key).Value
    local ret = strParseMgr.ParseValue(tableStr, valueStruct, valueType)
    return ret
end

return ModuleMgr.GuildRankMgr