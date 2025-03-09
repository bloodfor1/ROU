--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-06-29 15:54:45
--
---@module ModuleMgr.TimeLimitPayMgr
module("ModuleMgr.TimeLimitPayMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

ON_ACTIVITY_CHANGE = "ON_ACTIVITY_CHANGE"
ON_GET_AWARD_EVENT = "ON_GET_AWARD_EVENT"
ON_AWARD_INFO_NOTIFY = "ON_AWARD_INFO_NOTIFY"

local l_checkTimerInterval = 5                              -- 状态监测间隔
local l_pollingCheckTimer                                   -- 状态检查timer
local l_idleStartTime                                       -- 无操作的时间戳
local l_freezeTime = false                                      -- 忽略请求
local l_data                                                -- 数据层引用
CacheOpenSystem = nil
Visible = false
IsOnOpenPanel = false
--------------------------------------------生命周期接口--Start----------------------------------

function OnInit()
    
    l_data = DataMgr:GetData("TimeLimitPayData")
    
    reset()
    
    local l_payMgr = game:GetPayMgr()
    local l_limitMgr = MgrMgr:GetMgr("TimeLimitPayMgr")
    l_payMgr.EventDispatcher:Add(l_payMgr.ON_SDK_PAY_SUCCESS, OnPaySuccess, l_limitMgr)

    MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher:Add(ON_GET_AWARD_EVENT, OnGetAwardInfo, l_limitMgr)

    GlobalEventBus:Add(EventConst.Names.CutSceneStop, ShowOpenFunction, l_payMgr)
end

function Uninit()

    reset()

end

function OnLogout()
    
    reset()
end

--------------------------------------------生命周期接口--End----------------------------------

--------------------------------------------协议--Start----------------------------------
function OnSelectRoleNtf()

    l_freezeTime = false
    clearTimer()

    l_idleStartTime = Time.realtimeSinceStartup
    MPlayerInfo.LastTouchTime = Time.realtimeSinceStartup
    ChangeCurState(RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE)

    setupTimer()

    ReqeustAwardInfo()
end

function OnReconnected()

    l_freezeTime = false
end


-- 获取显示特惠状态
function RequestRoleActivityStatusNtf(newState)

    local l_msgId = Network.Define.Rpc.RoleActivityStatusNtf
    ---@type RoleActivityStatusNtfArg
    local l_sendInfo = GetProtoBufSendTable("RoleActivityStatusNtfArg")
    l_sendInfo.role_activity_type  = newState
    l_freezeTime = true
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 限时特惠状态处理
function OnRoleActivityStatusNtf(msg, sendArg)
    ---@type RoleActivityStatusNtfRes
    local l_info = ParseProtoBufToTable("RoleActivityStatusNtfRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
    l_freezeTime = false
    l_data.FinishTime = Time.realtimeSinceStartup + l_info.rest_time
    l_data.CurIdleState = sendArg.role_activity_type
end

-- 显示特惠状态切换
function OnNtfClientLimitedOfferStatus(msg)
    ---@type LimitedOfferStatus
    local l_info = ParseProtoBufToTable("LimitedOfferStatus", msg)
    log("OnNtfClientLimitedOfferStatus", l_info)
    
    l_data.FinishTime = Time.realtimeSinceStartup + l_info.rest_time
    l_data.ActivityState = l_info.status_type 

    if l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        Visible = false
        if l_info.is_start then
            MgrMgr:GetMgr("RedSignMgr").SetIgnoreState(eRedSignKey.WelfareTimeLimitPay, 0, 0)
            ShowOpenFunction()
        else
            Visible = true
        end
    else
        Visible = false
    end

    EventDispatcher:Dispatch(ON_ACTIVITY_CHANGE)

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.TimeLimitPay)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.WelfareTimeLimitPay)
end

function ShowOpenFunction()

    if Visible then
        return
    end

    if l_data.ActivityState ~= LimitedOfferStatusType.LIMITED_OFFER_START then
        return
    end

    if MPlayerInfo.IsPhotoMode then
        return
    end

    if MgrMgr:GetMgr("NpcMgr").IsTalking() then
        return
    end

    if MCutSceneMgr.IsPlaying then
        return
    end

    IsOnOpenPanel = true

    UIMgr:ActiveUI(UI.CtrlNames.RollbackSpine)
end

function SetVisible(flag)

    Visible = flag

    -- local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(eRedSignKey.TimeLimitPay)
    -- MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(114)
end

-- 获取下次开放时间(GM使用)
function RequestNextTime()

    local l_msgId = Network.Define.Rpc.GetNextLimitedOfferOpenTime
    ---@type GetNextLimitedOfferOpenTimeArg
    local l_sendInfo = GetProtoBufSendTable("GetNextLimitedOfferOpenTimeArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 显示下次开放时间
function OnGetNextLimitedOfferOpenTime(msg)
    ---@type GetNextLimitedOfferOpenTimeRes
    local l_info = ParseProtoBufToTable("GetNextLimitedOfferOpenTimeRes", msg)
    local l_timeTable = Common.TimeMgr.GetTimeTable(l_info.next_open_time)

    local l_str = StringEx.Format("{0}/{1}/{2} {3}:{4}:{5}", l_timeTable.year, l_timeTable.month, l_timeTable.day, l_timeTable.hour, l_timeTable.min, l_timeTable.sec)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

-- 充值成功后，回调通知服务器
function OnPaySuccess(_, data)

    
end

--------------------------------------------协议--End----------------------------------

--------------------------------------------操作--Start----------------------------------
-- 修改当前状态
function ChangeCurState(newState)

    RequestRoleActivityStatusNtf(newState)
end

-- 清理
function reset()

    Visible = false

    clearTimer()

    l_data.reset()    
end

-- 清理计时timer
function clearTimer()
    if l_pollingCheckTimer then
        l_pollingCheckTimer:Stop()
        l_pollingCheckTimer = nil
    end
end

-- 迭代timer正体，更新系统状态
function updateActivityState()
    local l_lastTouchTime = MPlayerInfo.LastTouchTime
    if not StageMgr:CurStage():IsConcreteStage() then
        return
    end

    if l_freezeTime then
        return
    end

    if l_idleStartTime ~= l_lastTouchTime then
        l_idleStartTime = l_lastTouchTime
        if l_data.CurIdleState ~= RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE then
            ChangeCurState(RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE)
        end
    elseif (Time.realtimeSinceStartup - l_lastTouchTime) >= l_data.TriggerIdleTime then
        if l_data.CurIdleState ~= RoleActivityStatusType.ROLE_ACTIVITY_STATUS_STANDBY then
            l_idleStartTime = l_lastTouchTime
            ChangeCurState(RoleActivityStatusType.ROLE_ACTIVITY_STATUS_STANDBY)
        end
    end
end

-- 设置更新timer
function setupTimer()

    updateActivityState()
    
    l_pollingCheckTimer = Timer.New(function()
        updateActivityState()
    end, l_checkTimerInterval, -1, true)
    l_pollingCheckTimer:Start()
end

--------------------------------------------操作--End----------------------------------

-- 判断当前是否开启的额外方法
function IsSystemOpenExtraCheck()
    return l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START
end

function IsSystemOpen()

    local l_mgr = MgrMgr:GetMgr("OpenSystemMgr")
    return l_mgr.IsSystemOpen(l_mgr.eSystemId.TimeLimitPay) and IsSystemOpenExtraCheck()
end

-- 红点接口实现
function CheckRedSignMethod()
    
    if l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        local l_remainningTime = l_data.FinishTime - Time.realtimeSinceStartup
        if l_remainningTime > 0 then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

function ReqeustAwardInfo()

    if l_data.AwardInfo then 
        return
    end

    local l_limitPayMgr = MgrMgr:GetMgr("TimeLimitPayMgr")
    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_data.AwardIds, l_limitPayMgr.ON_GET_AWARD_EVENT)
end

function OnGetAwardInfo(_, info, awardIds)
    
    if not info or not awardIds then
        logError("[TimeLimitPayMgr]奖励预览失败")
        return 
    end
    

    local l_temp = {}
    for _, awardInfo in ipairs(info) do
        local l_rewardCount = awardInfo.award_list[1] and awardInfo.award_list[1].count or 0
        l_temp[l_data.AwardId2Index[awardInfo.award_id]] = l_rewardCount
    end

    if #l_temp == l_data.MallAwardCount then
        l_data.AwardInfo = l_temp
        EventDispatcher:Dispatch(ON_AWARD_INFO_NOTIFY)
    else
        logError("[TimeLimitPayMgr]奖励预览失败", l_count)
    end
end

function GetAddtionCountByAwardId(awardId)

    if not l_data.AwardInfo then
        return 0
    end
    
    return l_data.AwardInfo[l_data.AwardId2Index[awardId]] or 0
end

function GetRatio()

    return l_data.Ratio
end

return ModuleMgr.TimeLimitPayMgr