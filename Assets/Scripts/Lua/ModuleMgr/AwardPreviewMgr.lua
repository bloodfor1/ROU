---
--- Created by richardjiang.
--- DateTime: 2018/7/13 10:02
---
module("ModuleMgr.AwardPreviewMgr", package.seeall)

AWARD_PREWARD_MSG = "AWARD_PREWARD_MSG" -- 预览奖励事件
AWARD_PREWARD_MSG_ERROR = "AWARD_PREWARD_MSG_ERROR" -- 预览奖励事件

EventDispatcher = EventDispatcher.new()
SortAwardTypes = { 3, 4 }
PreViewNumType = { mainline = 0, prob = 1, sign = 2 }

local l_getPreviewRewardsMsgQueue = nil

function OnInit()
    if l_getPreviewRewardsMsgQueue ~= nil then
        l_getPreviewRewardsMsgQueue:clear()
    else
        l_getPreviewRewardsMsgQueue = Common.queue.LinkedListQueue.create()
    end
end
function OnLogout()
    if l_getPreviewRewardsMsgQueue ~= nil then
        l_getPreviewRewardsMsgQueue:clear()
    end
end

--重连后如果不清空该队列会导致后续所有的请求不会发送，不确定会不会有其他影响 @马鑫 后边有问题找马哥 跟他说过了
function OnReconnected(reconnectData)
    if l_getPreviewRewardsMsgQueue ~= nil then
        l_getPreviewRewardsMsgQueue:clear()
    else
        l_getPreviewRewardsMsgQueue = Common.queue.LinkedListQueue.create()
    end
end

--[[
    @Description: 收到预览奖励数据
    @Date: 2018/7/13
    @Param: msg
    @Return
--]]
function OnAwardPreviewMsg(msg, arg, customData)
    ---@type AwardPreviewRes
    local l_info = ParseProtoBufToTable("AwardPreviewRes", msg)

    if l_info.result ~= 0 then
        EventDispatcher:Dispatch(customData or AWARD_PREWARD_MSG_ERROR)
        sendNextPreviewRewardReq()
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.result)
        return
    end

    if table.ro_contains(SortAwardTypes, l_info.preview_type) then
        table.sort(l_info.award_list, function(a, b)
            local l_itemInfo_a = TableUtil.GetItemTable().GetRowByItemID(a.item_id)
            local l_itemInfo_b = TableUtil.GetItemTable().GetRowByItemID(b.item_id)
            if l_itemInfo_a.ItemQuality > l_itemInfo_b.ItemQuality then
                return true
            end
            if l_itemInfo_a.ItemQuality < l_itemInfo_b.ItemQuality then
                return false
            end
            if l_itemInfo_a.TypeTab < l_itemInfo_b.TypeTab then
                return true
            end
            if l_itemInfo_a.TypeTab > l_itemInfo_b.TypeTab then
                return false
            end
            if a.item_id < b.item_id then
                return true
            end
            if a.item_id > b.item_id then
                return false
            end
        end)
    end
    EventDispatcher:Dispatch(customData or AWARD_PREWARD_MSG, l_info, customData, arg.award_id)
    sendNextPreviewRewardReq()
end

function OnBatchAwardPreviewMsg(msg, arg, customData)
    ---@type BatchAwardPreviewRes
    local l_info = ParseProtoBufToTable("BatchAwardPreviewRes", msg)
    if l_info.result ~= 0 then
        EventDispatcher:Dispatch(customData or AWARD_PREWARD_MSG_ERROR)
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.result)
        return
    end

    for i = 1, #l_info.preview_result do
        local l_preview = l_info.preview_result[i]

        if table.ro_contains(SortAwardTypes, l_preview.preview_type) then
            table.sort(l_preview.award_list, function(a, b)
                local l_itemInfo_a = TableUtil.GetItemTable().GetRowByItemID(a.item_id)
                local l_itemInfo_b = TableUtil.GetItemTable().GetRowByItemID(b.item_id)
                if l_itemInfo_a.ItemQuality > l_itemInfo_b.ItemQuality then
                    return true
                end
                if l_itemInfo_a.ItemQuality < l_itemInfo_b.ItemQuality then
                    return false
                end
                if l_itemInfo_a.TypeTab < l_itemInfo_b.TypeTab then
                    return true
                end
                if l_itemInfo_a.TypeTab > l_itemInfo_b.TypeTab then
                    return false
                end
                if a.item_id < b.item_id then
                    return true
                end
                if a.item_id > b.item_id then
                    return false
                end
            end)
        end
    end

    EventDispatcher:Dispatch(customData or AWARD_PREWARD_MSG, l_info.preview_result, arg.award_id_list)
end

--[[
    @Description: 获取预览奖励
    @Date: 2018/7/13
    @Param: [awardId:奖励id]
    @Return 预览奖励信息
--]]
function GetPreviewRewards(awardId, eventName)
    if not awardId then
        return
    end
    --由于底层机制改变，已无法连续发送同一消息，因此用队列缓存消息
    l_getPreviewRewardsMsgQueue:enqueue({
        awardId = awardId,
        eventName = eventName })
    if l_getPreviewRewardsMsgQueue:size() > 1 then
        return
    end
    reqPreviewRewardsIgnoreQueue(awardId, eventName)
end
function sendNextPreviewRewardReq()
    local l_previewRewardsQueueSize = l_getPreviewRewardsMsgQueue:size()
    --移除队列首的请求，并请求队列中下一个请求
    if l_previewRewardsQueueSize > 0 then
        l_getPreviewRewardsMsgQueue:dequeue()
        if l_previewRewardsQueueSize > 1 then
            local l_firstReqInQueue = l_getPreviewRewardsMsgQueue:peek()
            if l_firstReqInQueue ~= nil then
                reqPreviewRewardsIgnoreQueue(l_firstReqInQueue.awardId, l_firstReqInQueue.eventName)
            end
        end
    end
end
function reqPreviewRewardsIgnoreQueue(awardId, eventName)
    if not awardId then
        return
    end

    local l_msgId = Network.Define.Rpc.AwardPreview
    ---@type AwardPreviewArg
    local l_sendInfo = GetProtoBufSendTable("AwardPreviewArg")
    l_sendInfo.award_id = awardId
    Network.Handler.SendRpc(l_msgId, l_sendInfo, eventName)
end
function GetBatchPreviewRewards(awardIds, eventName)
    if not awardIds then
        return
    end
    local l_msgId = Network.Define.Rpc.BatchAwardPreview
    ---@type BatchAwardPreviewArg
    local l_sendInfo = GetProtoBufSendTable("BatchAwardPreviewArg")
    for i = 1, #awardIds do
        l_sendInfo.award_id_list:add().value = awardIds[i]
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo, eventName)
end

--[[
    @Description: 是否显示道具数量
    @Date: 2018/7/26
    @Param: [args]
    @Return
--]]
function IsShowAwardNum(previewNum, count)
    local ret = true
    if previewNum == PreViewNumType.mainline then
        return count ~= 1
    elseif previewNum == PreViewNumType.prob then
        return false
    elseif previewNum == PreViewNumType.sign then
        return count > 1
    end
    return ret
end

function HandleAwardRes(awardPreviewRes)
    local l_reward = awardPreviewRes and awardPreviewRes.award_list
    local previewCount = awardPreviewRes.preview_count
    if awardPreviewRes.preview_count == -1 or awardPreviewRes.preview_count == 0 then
        previewCount = #l_reward
    end
    local previewnum = awardPreviewRes.preview_num
    local datas = {}
    local showCount
    if previewCount > 0 then
        for i, v in ipairs(l_reward) do
            showCount = IsShowAwardNum(previewnum, v.count)
            table.insert(datas, { ID = v.item_id,
                                  IsShowCount = showCount,
                                  dropRate = v.drop_rate,
                                  isParticular = v.is_particular,
                                  probablyType = v.is_probably,
                                  Count = v.count,
                                  IsShowTips = true })
            --logError(ToString(v))
            if i >= previewCount then
                break
            end
        end
    end
    return datas
end

function HandleBatchAwardRes(awardPreviewRes)
    local ret = {}
    for i, v in ipairs(awardPreviewRes) do
        local data = HandleAwardRes(v)
        for _, itemv in ipairs(data) do
            if not array.find(ret, function(v)
                return v.ID == itemv.ID
            end) then
                table.insert(ret, itemv)
            end
        end
    end
    return ret
end

-- 通过awardid 获取所有的 item
function GetAllItemByAwardId(awardId)
    local l_ItemList = {}
    local l_AwardData = TableUtil.GetAwardTable().GetRowByAwardId(awardId)
    if l_AwardData then
        for i = 0, l_AwardData.PackIds.Count - 1 do
            GetAllItemByAwardPackId(l_AwardData.PackIds[i], l_ItemList)
        end
    end
    return l_ItemList
end

-- 通过awardpackid 获取所有 item
function GetAllItemByAwardPackId(awardPackId, itemList)
    if itemList == nil then
        itemList = {}
    end
    local l_AwardPackData = TableUtil.GetAwardPackTable().GetRowByPackId(awardPackId)
    if l_AwardPackData then
        for j = 0, l_AwardPackData.GroupContent.Count - 1 do
            local item_id = tonumber(l_AwardPackData.GroupContent:get_Item(j, 0))
            local count = tonumber(l_AwardPackData.GroupContent:get_Item(j, 1))
            local groupWeight = -1
            -- 不相等，说明策划GroupWeight的个数没有配置正确
            if l_AwardPackData.GroupWeight.Count == 0 then
                groupWeight = 0
            else
                if l_AwardPackData.GroupWeight.Count == l_AwardPackData.GroupContent.Count then
                    groupWeight = l_AwardPackData.GroupWeight[j]
                else
                    groupWeight = l_AwardPackData.GroupWeight[0]
                end
            end

            if count == -1 then
                if awardPackId ~= item_id then
                    GetAllItemByAwardPackId(item_id, itemList)
                end
            else
                -- 去重
                local flag = false
                for _, v in ipairs(itemList) do
                    if v.item_id == item_id then
                        flag = true
                    end
                end
                if not flag then
                    table.insert(itemList, { item_id = item_id, count = count, groupWeight = groupWeight })
                end
            end

        end
    else
        logError("AwardPackTable not have id " .. awardPackId)
    end

end

return ModuleMgr.AwardPreviewMgr
