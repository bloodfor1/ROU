---@module ModuleMgr.ServerNotifyMgr
module("ModuleMgr.ServerNotifyMgr", package.seeall)

function OnMSErrorNotify(msg, serverType)
    ---@type ErrorInfo
    local l_info = ParseProtoBufToTable("ErrorInfo", msg)
    if l_info and l_info.errorno then
        --不同errorcode需要特殊处理
        if not CheckErrorNeedShowTips(l_info, serverType) then
            return
        end
        --需要飘字的配置errortable对应提示   不需要飘字自己处理的无需配置
        if l_info.errorno ~= 0 then
            local l_errcodeConfig = Common.Functions.GetErrorCodeStr(l_info.errorno)
            local param = 0
            if l_info.param and l_info.param[1] then
                param = l_info.param[1].value
            end
            local l_errcodeStr = StringEx.Format(l_errcodeConfig,l_info.message,param)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_errcodeStr)
        end
    end
end

--自定义errorcode处理  返回是否还需要继续飘字
---@param errorInfo ErrorInfo
function CheckErrorNeedShowTips(errorInfo, serverType)
    local l_errCode = errorInfo.errorno
    if l_errCode == ErrorCode.ERR_PLATFORM_MATCHED_FAIL then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ARENA_MATCHED_FAIL"))
        return false
    elseif l_errCode == ErrorCode.ERR_PLATFORM_MATCHED_NEXT_FLOOR then
        MgrMgr:GetMgr("ArenaMgr").OnDirectPromote()
        return false
    elseif l_errCode == ErrorCode.ERR_BATTLEFIELD_MATCHED_SUCCESS then
        MgrMgr:GetMgr("BattleMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("BattleMgr").ON_PI_PEI_SUCCESS)
        return false
    elseif l_errCode == ErrorCode.ERR_HERO_CHALLENGE_REFRESH then
        MgrMgr:GetMgr("HeroChallengeMgr").RefreshInfo()
        return false
    elseif l_errCode == ErrorCode.ERR_SERVER_ERROR then
        logError("ServerError, serverType={0} msg={1}", serverType, tostring(errorInfo.message))
        return false
        --以下Error临时解决服务器Master宕机组队Bug
    elseif l_errCode == ErrorCode.ERR_MS_UNREADY then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_ON_SERVERCLOSED"))
        return false
    elseif l_errCode == ErrorCode.ERR_SERVER_CUSTOM_ERR then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(errorInfo.message)
        return false
    elseif l_errCode == ErrorCode.ERR_ASSIST_DAY_LIMIT then
        MgrMgr:GetMgr("DungeonMgr").ShowAssistDayTips()
        return false
    elseif l_errCode == ErrorCode.ERR_ASSIST_WEEK_LIMIT then
        MgrMgr:GetMgr("DungeonMgr").ShowAssistWeekTips()
        return false
    elseif l_errCode == ErrorCode.ERR_ROLE_NOT_CHANGE_NAME then
        MgrMgr:GetMgr("RoleInfoMgr").RoleNotChangeName()
        return false
    elseif l_errCode == ErrorCode.ERR_ROLE_STATE_NOT_IN_GAME then
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonTeam)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_errCode), errorInfo.message))
        return false
    elseif l_errCode == ErrorCode.ERR_ALREADY_IN_WATCH_ROOM then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STATE_IN_WATCHROOM_CANNOT_FOLLOW", errorInfo.message))
        return false
    elseif l_errCode == ErrorCode.ERR_TREASURE_HUNTER_OPEN_TREASURE then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_errCode), errorInfo.message))
        return false
    elseif l_errCode == ErrorCode.ERR_TREASURE_HUNTER_FIND_DETECTED
    --or l_errCode == ErrorCode.ERR_TREASURE_HUNTER_NO_TRACE_DETECTED
    then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_errCode), tostring(errorInfo.param[1].value)))
        return false
    elseif l_errCode == ErrorCode.ERR_PRESTIGE_USE_TIPS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_errCode), tostring(errorInfo.param[1].value), tostring(errorInfo.param[2].value)))
        return false
    end
    return true
end

function ExecuteActionByServerNotify(msg)
    local l_info = ParseProtoBufToTable("CallBlackCurtainData", msg)

    local l_actionId = l_info.id
    if l_actionId == 0 or l_actionId == nil then
        return
    end

    if l_info.type == nil then
        l_info.type = GameEnum.EServerNotifyActionType.BlackCurtain
    end

    if l_info.type == GameEnum.EServerNotifyActionType.BlackCurtain then
        MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(l_actionId)
    elseif l_info.type == GameEnum.EServerNotifyActionType.StoryBoard then
        UIMgr:ActiveUI(UI.CtrlNames.StoryBoard, { storyBoardId = l_actionId, callback = nil, args = nil })
    end
end

return ModuleMgr.ServerNotifyMgr