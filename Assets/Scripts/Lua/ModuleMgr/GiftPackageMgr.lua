module("ModuleMgr.GiftPackageMgr", package.seeall)


EventType = {
    TimeGiftInfoRefresh = "TimeGiftInfoRefresh",
    TimeGiftInfoStateChange = "TimeGiftInfoStateChange"
}

EventDispatcher = EventDispatcher.new()

-- 首充礼包id
FirstRechargeAwardId = 200001

-- 活动礼包信息
timeGiftInfos = {

}

function OnInit()
    local l_activityMgr = MgrMgr:GetMgr("ActivityMgr")
    l_activityMgr.EventDispatcher:Add(l_activityMgr.EventType.ActivityStateChange, function(_, activityType, activityId, activityState)
        if activityType == GameEnum.ECommonActivityType.kCA_Gift and timeGiftInfos[activityId] then
            timeGiftInfos[activityId].state = activityState
            EventDispatcher:Dispatch(EventType.TimeGiftInfoStateChange)
        end
    end, ModuleMgr.GiftPackageMgr)
    
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.ItemPurchaseInfoUpdated, UpdateRedSign)

    local l_monthCardMgr = MgrMgr:GetMgr("MonthCardMgr")
    l_monthCardMgr.EventDispatcher:Add(l_monthCardMgr.ON_BUY_MONTHCARD_SUCCESS,function()
        UpdateRedSign()
    end, ModuleMgr.GiftPackageMgr)
end

function OnUnInit()
    local l_activityMgr = MgrMgr:GetMgr("ActivityMgr")
    l_activityMgr.EventDispatcher:RemoveObjectAllFunc(l_activityMgr.EventType.ActivityStateChange, ModuleMgr.GiftPackageMgr)

    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    l_limitBuyMgr.EventDispatcher:RemoveObjectAllFunc(l_limitBuyMgr.LIMIT_BUY_COUNT_UPDATE, ModuleMgr.GiftPackageMgr)


    local l_monthCardMgr = MgrMgr:GetMgr("MonthCardMgr")
    l_monthCardMgr.EventDispatcher:RemoveObjectAllFunc(l_monthCardMgr.ON_BUY_MONTHCARD_SUCCESS, ModuleMgr.GiftPackageMgr)
end

function OnLogout()
    timeGiftInfos = {}
end

function GetGroupInfos()
    local l_groupInfos = {}
    local l_groupNotEmptyState = {}
    for _, info in pairs(timeGiftInfos) do
        if info.groupId == 0 then
            table.insert(l_groupInfos, info)
        else
            l_groupNotEmptyState[info.groupId] = true
        end
    end
    local l_notEmptyGroupInfos = {}
    for _, info in ipairs(l_groupInfos) do
        if l_groupNotEmptyState[info.mainId] then
            table.insert(l_notEmptyGroupInfos, info)
        end
    end
    table.sort(l_notEmptyGroupInfos, function(a, b)
        return a.sortId < b.sortId
    end)
    return l_notEmptyGroupInfos
end

function GetGiftIdsByGroupId(groupId)
    local l_giftInfos = {}
    for _, info in pairs(timeGiftInfos) do
        if info.groupId == groupId then
            table.insert(l_giftInfos, info)
        end
    end
    table.sort(l_giftInfos, function(a, b)
        return a.sortId < b.sortId
    end)
    local l_giftIds = {}
    for _, info in ipairs(l_giftInfos) do
        for _, id in ipairs(info.giftIds) do
            table.insert(l_giftIds, {
                mainId = info.mainId,
                giftId = id,
                timeId = info.timeId,
                state = info.state
            })
        end
    end

    return l_giftIds
end

function GetGroupEndTimeStamp(groupId)
    local l_groupEndTimeStamp = 0
    for _, info in pairs(timeGiftInfos) do
        if info.groupId == groupId then
            l_groupEndTimeStamp = math.max(l_groupEndTimeStamp, MgrMgr:GetMgr("ActivityMgr").GetEndTimeStamp(info.timeId))
        end
    end
    return l_groupEndTimeStamp
end

function IsGroupRedPoint(groupId)
    local l_isRedPoint = false
    local l_giftIds = GetGiftIdsByGroupId(groupId)
    for _, giftInfo in ipairs(l_giftIds) do
        local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(giftInfo.giftId)
        if l_giftRow then
            local l_isFree = l_giftRow.Cost[0][1] == 0
            local l_count, l_limit = GetLimitInfo(giftInfo.giftId)
            local l_canGet = l_count < l_limit
            if l_isFree and l_canGet then
                l_isRedPoint = true
                break
            end
        end
    end
    return l_isRedPoint
end

function GetTimeGiftInfo(mainId)
    return timeGiftInfos[mainId]
end


-- 领取/购买奖励
function BuyGiftPackage(majorId, mainId)
    ---@type GetCommonAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetCommonAwardArg")
    l_sendInfo.award_id = majorId
    l_sendInfo.award_times = 1
    l_sendInfo.active_id = mainId
    Network.Handler.SendRpc(Network.Define.Rpc.GetCommonAward, l_sendInfo)
end

function RequestTimeGiftInfo()
    ---@type GetTimeGiftInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetTimeGiftInfoArg")
    Network.Handler.SendRpc(Network.Define.Rpc.GetTimeGiftInfo, l_sendInfo)
end


-- 返回，已购买，总次数
function GetLimitInfo(majorId)
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    return l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.GiftPackage, majorId), l_limitBuyMgr.GetItemLimitCount(l_limitBuyMgr.g_limitType.GiftPackage, majorId)
end

function OnGetCommonAward(msg)
    local l_info = ParseProtoBufToTable("GetCommonAwardRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        if l_info.error_code == ErrorCode.ERR_IN_PAYING then
            game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.GetCommonAward, function ()
            end)
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
end

function OnGetTimeGiftInfo(msg)
    local l_info = ParseProtoBufToTable("GetTimeGiftInfoRes", msg)
    --if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
    --    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    --    return
    --end

    --logError(ToString(l_info))

    timeGiftInfos = {}
    for i = 1, #l_info.gift_info_list do
        local l_gift = l_info.gift_info_list[i]
        local l_giftIds = {}
        for j = 1, #l_gift.gift_id_list do
            table.insert(l_giftIds, l_gift.gift_id_list[j])
        end
        timeGiftInfos[l_gift.main_id] = {
            mainId = l_gift.main_id,
            groupId = l_gift.group_id,
            functionId = l_gift.function_id,
            timeId = l_gift.time_limit_id,
            activityName = l_gift.activity_name,
            sortId = l_gift.sort,
            giftIds = l_giftIds,
            state = l_gift.state
        }
    end

    EventDispatcher:Dispatch(EventType.TimeGiftInfoRefresh)
end

function UpdateTimeGiftInfos(activityId,activityState)
    RequestTimeGiftInfo()
end

-- 首充红点
function CheckFirstRedSign()
    local l_canReceive = MgrMgr:GetMgr("MonthCardMgr").GetIsFirstCharge()
    local l_count, l_limit = GetLimitInfo(FirstRechargeAwardId)
    local l_isReceived = l_count > 0
    return l_canReceive and not l_isReceived and 1 or 0
end

--首冲的特效，只判断功能是否开启就可以
function CheckShowEffectFirstRedSign()
    return 1
end

function UpdateRedSign()
    -- 首充红点刷新
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.FirstRechargeInner)
end


return ModuleMgr.GiftPackageMgr