module("ModuleMgr.CookingDoubleMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

COOKING_DOUBLE_START = "COOKING_DOUBLE_START"
COOKING_DOUBLE_END = "COOKING_DOUBLE_END"

COOKING_DOUBLE_ADD_MENU = "COOKING_DOUBLE_ADD_MENU"
COOKING_DOUBLE_REMOVE_MENU = "COOKING_DOUBLE_REMOVE_MENU"
COOKING_DOUBLE_CLEAR_MENU = "COOKING_DOUBLE_CLEAR_MENU"
COOKING_DOUBLE_MENU_TIME = "COOKING_DOUBLE_MENU_TIME"

COOKING_DOUBLE_OPERATION = "COOKING_DOUBLE_OPERATION"

COOKING_DOUBLE_REMAIN_TIME = "COOKING_DOUBLE_REMAIN_TIME"
COOKING_DOUBLE_FINISHED_COUNT = "COOKING_DOUBLE_FINISHED_COUNT"
COOKING_DOUBLE_FINISHED_SCORE = "COOKING_DOUBLE_FINISHED_SCORE"
StartFlag = false
CachedChangedItems = {}

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function Start()
    StartFlag = true
    CachedChangedItems = {}
    EventDispatcher:Dispatch(COOKING_DOUBLE_START)
end

function End(finishCount, finishScore, failedCount, success)
    StartFlag = false
    EventDispatcher:Dispatch(COOKING_DOUBLE_END, finishCount, finishScore, failedCount, success)
end

function AddMenu(menuId, menuUid, remainTime)
    EventDispatcher:Dispatch(COOKING_DOUBLE_ADD_MENU, menuId, menuUid, remainTime)
end

function RemoveMenu(menuUid)
    EventDispatcher:Dispatch(COOKING_DOUBLE_REMOVE_MENU, menuUid)
end

function ClearMenu()
    EventDispatcher:Dispatch(COOKING_DOUBLE_CLEAR_MENU)
end

function UpdateMenuTime(menuUid, time)
    EventDispatcher:Dispatch(COOKING_DOUBLE_MENU_TIME, menuUid, time)
end

function Operation(opId, objUid, opHint)
    EventDispatcher:Dispatch(COOKING_DOUBLE_OPERATION, opId, objUid, opHint)
end

function UpdateRemainTime(timeStr)
    EventDispatcher:Dispatch(COOKING_DOUBLE_REMAIN_TIME, timeStr)
end

function UpdateFinishedCount(count)
    EventDispatcher:Dispatch(COOKING_DOUBLE_FINISHED_COUNT, count)
end

function UpdateFinishedScore(score)
    EventDispatcher:Dispatch(COOKING_DOUBLE_FINISHED_SCORE, score)
end

function UpdateFinishedInfo(count, score)
    UpdateFinishedCount(count)
    UpdateFinishedScore(score)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[CookingDoubleMgr] invalid param")
        return
    end

    CachedChangedItems = CachedChangedItems or {}
    for i = 1, #itemUpdateDataList do
        ---@type CookingUpdateItemData
        local singleCookingUpdateData = {}
        local singleUpdateData = itemUpdateDataList[i]
        if ItemChangeReason.ITEM_REASON_COOK_DUNGEONS == singleUpdateData.Reason then
            local data = singleUpdateData:GetItemCompareData()
            singleCookingUpdateData.ID = data.id
            singleCookingUpdateData.Count = data.count
            table.insert(CachedChangedItems, singleCookingUpdateData)
        end
    end

    if StageMgr:GetCurStageEnum() ~= MStageEnum.Cooking then
        ShowCachedNotices()
    end
end

function OnLeaveStage()
    if StageMgr:GetCurStageEnum() ~= MStageEnum.Cooking then
        return
    end

    if not CachedChangedItems then
        return
    end

    ShowCachedNotices()
end

function ShowCachedNotices()
    if not CachedChangedItems then
        return
    end

    if #CachedChangedItems <= 0 then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("COOKING_DOUBLE_SUCCESS_TIPS"))
    for i, v in ipairs(CachedChangedItems) do
        local l_opt = {
            itemId = v.ID,
            itemOpts = { num = v.Count, icon = { size = 18, width = 1.4 } },
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
    end

    CachedChangedItems = nil
end

--@Description:获得公会宴会的ActivityId,如果满足周末宴会的开放条件返回周末宴会的ActivityId,
--*如果不满足则返会公会宴会的ActivityId
function GetCookActivityId()
    local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_activityId = l_dailyMgr.g_ActivityType.activity_GuildCook
    if l_dailyMgr.IsActivityInOpenDay(l_dailyMgr.g_ActivityType.activity_GuildCookWeek) then
        l_activityId = l_dailyMgr.g_ActivityType.activity_GuildCookWeek
    end

    return l_activityId
end

local function _checkConditionSystemOpen(func_id)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSystemMgr.IsSystemOpen(func_id) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_openSystemMgr.GetOpenSystemTipsInfo(func_id))
        return false
    end

    local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_activity_id = GetCookActivityId()

    if not l_dailyMgr.IsActivityOpend(l_activity_id) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("OPEN_SYSTEM_LIMIT_TIME"))
        return false
    end
    return true
end

local function _checkConditionTeamRequest(info)
    local l_result = false
    local l_err_info
    local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_activity_id = GetCookActivityId()
    local l_isWeekCook = l_activity_id == l_dailyMgr.g_ActivityType.activity_GuildCookWeek

    -- 组队状态
    if not info.is_in_team then
        if l_isWeekCook then
            l_err_info = Lang("COOKING_WEEK_DOUBLE_TEAM_REQUEST")
        else
            l_err_info = Lang("COOKING_DOUBLE_TEAM_REQUEST")
        end
        -- 双人组队
    elseif not info.member_count == 2 then
        if l_isWeekCook then
            l_err_info = Lang("COOKING_WEEK_DOUBLE_TEAM_REQUEST")
        else
            l_err_info = Lang("COOKING_DOUBLE_TEAM_REQUEST")
        end
        -- 队长
    elseif not info.is_captain then
        if l_isWeekCook then
            l_err_info = Lang("COOKING_WEEK_DOUBLE_CAPTAIN_REQUEST")
        else
            l_err_info = Lang("COOKING_DOUBLE_CAPTAIN_REQUEST")
        end
        -- 有人已经参与,这块放服务器判定(不知道对方的状态)
        -- elseif
    else
        l_result = true
    end
    if not l_result then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_err_info)
    end
    return l_result
end

function ProcessCheckAsyn(mgr, event, bind_object, check_func, callback)
    mgr.EventDispatcher:RemoveObjectAllFunc(event, bind_object)
    mgr.EventDispatcher:Add(event,
            function(_, info)
                if check_func(info) then
                    callback()
                end
                mgr.EventDispatcher:RemoveObjectAllFunc(event, bind_object)
            end, bind_object)
end

function CaptainRequestEnter(func_id)

    if not func_id then
        logError("CaptainRequestEnter失败，没有传入func_id")
        return
    end
    --TODO
    if not _checkConditionSystemOpen(func_id) then
        return false
    end

    ProcessCheckAsyn(ModuleMgr.TeamMgr, DataMgr:GetData("TeamData").ON_GET_PLAYER_TEAM_FRIEND_INFO, ModuleMgr.CookingDoubleMgr, _checkConditionTeamRequest, CaptainRequestEnterDirectly)
    MgrMgr:GetMgr("TeamMgr").GetUserInTeamOrNot(MPlayerInfo.UID)
end

function CaptainRequestEnterDirectly()
    local l_msgId = Network.Define.Ptc.CaptainRequestEnterFBPtc
    ---@type CaptainRequestEnterFBData
    local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterFBData")
    l_sendInfo.dungeon_id = 7000
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

return CookingDoubleMgr