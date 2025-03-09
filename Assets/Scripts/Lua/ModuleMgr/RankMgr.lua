--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleMgr.RankMgr
module("ModuleMgr.RankMgr", package.seeall)

---@type ModuleData.RankData
l_rankData = DataMgr:GetData("RankData")
EventDispatcher = EventDispatcher.new()
--lua model end

--lua custom scripts

--获取排行榜信息
---@param RankType number --排行榜ID对应LeaderBoardComponentTable
---@param ShowFriendOrGuild number --勾选框只显示好友与公会对应参数，LeaderBoardTable.PermissionLevel
---@param RankTime number --时间标签 RankData.RankTimeStamp[RankType][].severstamp
---@param Page number --页
function TryToGetRankListInfo(RankType, ShowFriendOrGuild, RankTime, Page)
    --log("TryToGetRankListInfo", RankType, ShowFriendOrGuild, RankTime, Page)
    ShowFriendOrGuild = ShowFriendOrGuild or 0
    RankTime = RankTime or 0
    Page = Page or 0
    --索引标记，避免回包时界面已切换导致数据脏乱显示错误，需在UI层判断，若不一致，请重新获取
    local strKey = RankType .. "_" .. ShowFriendOrGuild .. "_" .. RankTime .. "_" .. Page
    l_rankData.SetTotalRankType(RankType)
    l_rankData.SetTotalRankTime(RankTime)
    l_rankData.SetTotalShowFriendOrGuild(ShowFriendOrGuild)

    --先从缓存中拿，缓存中没有向服务器获取
    local targetRankList = l_rankData.GetRankListByType(RankType, ShowFriendOrGuild, RankTime, Page)
    if table.maxn(targetRankList) > 0 then
        strKey = RankType .. "_" .. ShowFriendOrGuild .. "_" .. RankTime
        EventDispatcher:Dispatch(l_rankData.RANKINFO_IS_READY, strKey, targetRankList)
    else
        MgrMgr:GetMgr("RankMgr").RequestLeaderBoardInfo(RankType, ShowFriendOrGuild, RankTime, Page)
    end

end

function GetNextPage()
    l_rankData.AddTotalPage()
    l_rankData.isGetNextPage = true
    RequestLeaderBoardInfo(l_rankData.totalRankType, l_rankData.totalShowFriendOrGuild, l_rankData.totalRankTime, l_rankData.totalPage)
end

--从服务器获取排行榜信息（不推荐直接调用）
--不进行缓存判断故不推荐使用，如无特殊需求请使用TryToGetRankListInfo
---@param RankType number --排行榜ID对应LeaderBoardComponentTable
---@param ShowFriendOrGuild number --勾选框只显示好友与公会对应参数，LeaderBoardTable.PermissionLevel
---@param RankTime number --时间标签 RankData.RankTimeStamp[RankType][].severstamp
---@param Page number --页
function RequestLeaderBoardInfo(RankType, ShowFriendOrGuild, RankTime, Page)
    --log("RequestLeaderBoardInfo", RankType, ShowFriendOrGuild, RankTime, Page)
    local l_msgId = Network.Define.Rpc.RequestLeaderBoardInfo
    local l_sendInfo = GetProtoBufSendTable("RequestLeaderBoardInfoArg")--PbcMgr.get_pbc_team_pb().RequestLeaderBoardInfoArg()
    l_sendInfo.component_id = RankType
    l_sendInfo.page = Page
    l_sendInfo.date_index = RankTime
    l_sendInfo.view_type = ShowFriendOrGuild
    l_sendInfo.component_id = RankType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestLeaderBoardInfo(msg, arg)
    local l_info = ParseProtoBufToTable("RequestLeaderBoardInfoRes", msg)
    --log("OnRequestLeaderBoardInfo", ToString(l_info), "l_rankData.totalPage", l_rankData.totalPage, ToString(arg))
    if l_info.result ~= 0 then
        l_rankData.LessTotalPage()
        if arg.page <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
        if l_info.history_timestamp and table.maxn(l_info.history_timestamp) > 0 then
            l_rankData.SetRankTimeStamp(arg.component_id, l_info.history_timestamp)
        end
        l_rankData.SetOwnRankInfo(l_info.own_rank, arg.component_id, arg.view_type, arg.date_index)
        if l_rankData.totalPage == -1 and not l_rankData.isGetNextPage then
            EventDispatcher:Dispatch(l_rankData.RANKINFO_NIL, strKey)
        end
        if arg.page == 0 then
            EventDispatcher:Dispatch(l_rankData.RANKINFO_NIL, strKey)
            l_rankData.ResetTotalPage()
        end
        if l_rankData.totalPage <= 0 then
            l_rankData.ResetTotalPage()
        end
    else
        local targetRankList = l_rankData.SetRankListByType(l_info.rows, arg.component_id, arg.view_type, arg.date_index, arg.page)
        if l_info.history_timestamp and table.maxn(l_info.history_timestamp) > 0 then
            l_rankData.SetRankTimeStamp(arg.component_id, l_info.history_timestamp)
        end
        --索引标记，避免回包时界面已切换导致数据脏乱显示错误，需在UI层判断，若不一致，请重新获取
        l_rankData.SetOwnRankInfo(l_info.own_rank, arg.component_id, arg.view_type, arg.date_index)
        local strKey = arg.component_id .. "_" .. arg.view_type .. "_" .. arg.date_index
        if l_rankData.isGetNextPage and arg.page > 0 then
            l_rankData.isGetNextPage = false
            EventDispatcher:Dispatch(l_rankData.RANKINFO_NEXT_PAGE, strKey, targetRankList)
        else
            EventDispatcher:Dispatch(l_rankData.RANKINFO_IS_READY, strKey, targetRankList)
        end
    end
end

function GetTimeStampsByType(RankType)
    return l_rankData.RankTimeStamp[RankType]
end

function GetPbVarInExcelByType(rankType)
    return l_rankData.GetPbVarInExcelByType(rankType)
end

function GetOwnRankInfo()
    return DataMgr:GetData("RankData").GetOwnRankInfo()
end

function SetSelectTeamInfo(info)
    l_rankData.SetSelectTeamInfo(info)
    UIMgr:ActiveUI(UI.CtrlNames.ShowTeamMember)
end

--lua custom scripts end
return ModuleMgr.RankMgr