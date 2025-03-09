--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.RankData
module("ModuleData.RankData", package.seeall)

--lua model end

RankListInfo = {}
--显示用时间戳
RankTimeStamp = {}
--timer迭代器，将数据缓存一段时间，避免重复获取数据导致服务器卡顿，方便释放，避免信息清掉了timer没停神仙报错
TimerMgr = {}
OwnRankInfo = {}
SelectTeamMemberInfo = {}
TotalNum = 0
LeaderBoardColumnInfoTable = TableUtil.GetLeaderBoardColumnInfoTable()
--缓存时间
RefreshDataCd = 1

totalRankType = 0
totalShowFriendOrGuild = 0
totalRankTime = 0
totalPage = 0
isGetNextPage = false

BoardViewType = {
    kBoardViewTypeNone = 0,
    kBoardViewTypeAll = 1,
    kBoardViewTypeFriend = 2,
    kBoardViewTypeGuild = 3,
};
EShowMemberType = {
    Single = 1,
    Team = 2,
    Guild = 3,
}

ShowFriendType = { 2, 4, 8 }

--事件定义
RANKINFO_IS_READY = "RANKINFO_IS_READY" --获取排行榜数据回调，并返回获取的信息
RANKINFO_NEXT_PAGE = "RANKINFO_NEXT_PAGE" --获取排行榜下一页回调，并返回获取的信息
RANKINFO_NIL = "RANKINFO_NIL" --获取排行榜下一页回调，并返回获取的信息
SELECT_TEAM = "SELECT_TEAM"--显示选中队伍数据回调

--lua functions
function Init()
    --ResetRankListInfo()
end --func end
--next--
function Logout()
    ResetRankListInfo()
    ClearSelectTeamInfo()
end --func end
--next--
--lua functions end

--lua custom scripts

-----------------------------------Get---------------------------------------------------
--如果返回的是一个长度为0的表，需要手动获取
function GetRankListByType(RankType, ShowFriendOrGuild, RankTime, Page, reset)
    if RankListInfo == nil then
        RankListInfo = {}
    end
    if RankListInfo[RankType] == nil then
        RankListInfo[RankType] = {}
    end
    if RankListInfo[RankType][ShowFriendOrGuild] == nil then
        RankListInfo[RankType][ShowFriendOrGuild] = {}
    end
    if RankListInfo[RankType][ShowFriendOrGuild][RankTime] == nil then
        RankListInfo[RankType][ShowFriendOrGuild][RankTime] = {}
    end
    if RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page] == nil then
        RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page] = {}
    end
    if reset then
        RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page] = {}
    end
    return RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page]
end

function GetPbVarInExcelByType(RankType)
    local l_PbVars = {}
    local l_row = TableUtil.GetLeaderBoardComponentTable().GetRowByID(RankType)
    local l_columnInfos = Common.Functions.VectorToTable(l_row.ColumnInfo)
    for _, v in pairs(l_columnInfos) do
        local l_row = LeaderBoardColumnInfoTable.GetRowByID(tonumber(v))
        local myRow = {}
        myRow.name = l_row.ColumnName
        myRow.var = l_row.PbVar
        myRow.columnWidth = l_row.ColumnWidth
        myRow.templateName = l_row.TemplateName
        local m_ownColor = Common.Functions.VectorToTable(l_row.OwnColor)
        myRow.ownColor = Color(m_ownColor[1], m_ownColor[2], m_ownColor[3], m_ownColor[4])
        local m_color = Common.Functions.VectorToTable(l_row.TextColor)
        myRow.textColor = Color(m_color[1], m_color[2], m_color[3], m_color[4])
        table.insert(l_PbVars, myRow)
    end
    return l_PbVars
end

function GetOwnRankInfo()
    local key = totalRankType .. "_" .. totalShowFriendOrGuild .. "_" .. totalRankTime
    --log(key,ToString(OwnRankInfo))
    return OwnRankInfo[key]
end

--------------------------------------End--Get-------------------------------------------


--------------------------------------Set------------------------------------------------

---设置排行榜信息并返回，！！！不对外！！！，请调用RankMgr中TryToGetRankListInfo
function SetRankListByType(RankData, RankType, ShowFriendOrGuild, RankTime, Page)
    local myRankList = GetRankListByType(RankType, ShowFriendOrGuild, RankTime, Page, true)
    local myVars = GetPbVarInExcelByType(RankType)
    local myShowMemberType = TableUtil.GetLeaderBoardComponentTable().GetRowByID(RankType).Type
    for i = 1, table.maxn(RankData) do
        local myRow = {}
        for _, v in pairs(myVars) do
            if RankData[i][v.var] == nil and RankData[i]["members"][1][v.var] == nil then
                logError("策划填错LeaderBoardColumnInfoTable或服务器发送空数据", ToString(v))
            else
                local l_temTab = {}
                l_temTab.name = v.name
                if v.templateName == "RankRowNameTem" then
                    --可以点击出名片的样式
                    l_temTab.membersInfo = RankData[i].members
                    l_temTab.showMemberType = myShowMemberType
                end
                if v.var == "profession" then
                    --RankData[i]["members"][1][v.var]
                    l_temTab.value = TableUtil.GetProfessionTable().GetRowById(RankData[i]["members"][1][v.var]).Name
                elseif v.var == "timestamp" then
                    local l_timeData = Common.TimeMgr.GetTimeTable(RankData[i][v.var])  --ExtensionByQX.TimeHelper.TimestampToDateTime(tostring(RankData[i][v.var]))
                    l_temTab.value = StringEx.Format(Common.Utils.Lang("DATE_M_D"), l_timeData.month, l_timeData.day)
                else
                    l_temTab.value = RankData[i][v.var]
                end
                table.insert(myRow, l_temTab)
            end
        end
        table.insert(myRankList, myRow)
    end
    --timer迭代器下标，避免重复加个_，有更好意见的麻烦改一下
    local timerKey = RankType .. "_" .. ShowFriendOrGuild .. "_" .. RankTime .. "_" .. Page
    if TimerMgr[timerKey] == nil then
        TimerMgr[timerKey] = {}
    end
    if TimerMgr[timerKey].timer then
        TimerMgr[timerKey].timer:Stop()
        TimerMgr[timerKey].timer = nil
    end
    if TimerMgr[timerKey].timer then
        TimerMgr[timerKey].timer:Stop()
        TimerMgr[timerKey].timer = nil
    end
    TimerMgr[timerKey].timer = Timer.New(function()
        GetRankListByType(RankType, ShowFriendOrGuild, RankTime, Page, true)
    end, RefreshDataCd, 1)
    TimerMgr[timerKey].timer:Start()
    return myRankList
end

function SetRankTimeStamp(rankType, timerStamp)
    RankTimeStamp[rankType] = {}
    for i = 1, table.maxn(timerStamp) do
        table.insert(RankTimeStamp[rankType], { severstamp = timerStamp[i] })
    end
end

function SetOwnRankInfo(RankData, RankType, ShowFriendOrGuild, RankTime)
    local key = RankType .. "_" .. ShowFriendOrGuild .. "_" .. RankTime
    OwnRankInfo[key] = {}
    local myVars = GetPbVarInExcelByType(RankType)
    local myShowMemberType = TableUtil.GetLeaderBoardComponentTable().GetRowByID(RankType).Type
    if RankData.rank == 0 then
        return
    end
    for _, v in pairs(myVars) do
        --log(ToString(RankData),v.var)
        if RankData[v.var] == nil and RankData["members"][1][v.var] == nil then
            --logError("策划填错LeaderBoardColumnInfoTable或服务器发送空数据", ToString(v))
            OwnRankInfo[key] = {}
            return
        else
            if v.var == "rank" and RankData[v.var] == 0 then
                OwnRankInfo[key] = {}
                return
            end
            local l_temTab = {}
            l_temTab.var = v.var
            l_temTab.name = v.name
            if v.templateName == "RankRowNameTem" then
                --可以点击出名片的样式
                l_temTab.membersInfo = RankData.members
                l_temTab.showMemberType = myShowMemberType
            end
            if v.var == "profession" then
                l_temTab.value = TableUtil.GetProfessionTable().GetRowById(RankData["members"][1][v.var]).Name
            elseif v.var == "timestamp" then
                local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(RankData[v.var]))
                l_temTab.value = Lang("DATE_M_D", l_timeTable.month, l_timeTable.day)
            else
                l_temTab.value = RankData[v.var]
            end
            table.insert(OwnRankInfo[key], l_temTab)
        end
    end
end

function SetTotalRankType(value)
    totalRankType = value
end

function SetTotalRankTime(value)
    totalRankTime = value
end

function SetTotalShowFriendOrGuild(value)
    totalShowFriendOrGuild = value
end

function AddTotalPage()
    totalPage = totalPage + 1
end
function LessTotalPage()
    totalPage = totalPage - 1
end
function ResetTotalPage()
    totalPage = 0
end

function SetSelectTeamInfo(info)
    ClearSelectTeamInfo()
    for _, v in ipairs(info) do
        table.insert(SelectTeamMemberInfo, v)
    end
end
--------------------------------------End--Set-------------------------------------------


--------------------------------------Check----------------------------------------------
function CheckHaveRankListByType(RankType, ShowFriendOrGuild, RankTime, Page)
    if RankListInfo == nil then
        return false
    elseif RankListInfo[RankType] == nil then
        return false
    elseif RankListInfo[RankType][ShowFriendOrGuild] == nil then
        return false
    elseif RankListInfo[RankType][ShowFriendOrGuild][RankTime] == nil then
        return false
    elseif RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page] == nil then
        return false
    end
    return RankListInfo[RankType][ShowFriendOrGuild][RankTime][Page]
end

--------------------------------------End--Check-----------------------------------------


--------------------------------------Reset----------------------------------------------

function ResetRankListInfo()
    RankListInfo = nil
    RankListInfo = {}
    for _, v in pairs(TimerMgr) do
        if v.timer then
            v.timer:Stop()
            v.timer = nil
        end
    end
    TimerMgr = nil
    TimerMgr = {}
end

function ClearOwnRankInfo()
    OwnRankInfo = {}
end

function ClearSelectTeamInfo()
    SelectTeamMemberInfo = {}
end
--------------------------------------End--Reset-----------------------------------------



--lua custom scripts end
return ModuleData.RankData